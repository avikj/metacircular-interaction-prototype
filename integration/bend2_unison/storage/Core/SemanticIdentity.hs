{-# LANGUAGE OverloadedStrings #-}
module Core.SemanticIdentity
  ( semanticVersion
  , checkedNatIdentity
  ) where

import Core.Admission (CheckedSource(..))
import Core.Equal (equal)
import Core.FlatCodec (encodeFlat)
import Core.Reify (Flat(..), alphaTerm)
import Core.Type (Book(..), Name, Term(..))
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import qualified Data.Map.Strict as Map
import qualified Data.Text as Text

-- The version describes the exact checker and deliberately small evaluator
-- whose results are indexed. It is independent of component storage identity.
semanticVersion :: Text.Text
semanticVersion = "bend2-f026483-cubical-checked-nat-beta-v1"

-- | Return an identity only for a checked, closed Nat definition in the
-- reference-free lambda/application/numeral fragment. A fuel-limited
-- evaluator establishes a finite numeral and Bend's own conversion checker
-- must then prove the source term equal to that numeral. No Fix, Ref, HIT,
-- primitive, or cap-truncated normal form can reach the index.
checkedNatIdentity :: CheckedSource -> Name -> Maybe Bytes.ByteString
checkedNatIdentity checked name = do
  let book@(Book defs _) = checkedBook checked
  (_,body,typ) <- Map.lookup name defs
  if alphaTerm typ /= Node "Nat" [] then Nothing else pure ()
  let flat = alphaTerm body
  if not (safeFragment 0 flat) || fragmentSize flat > 1024 then Nothing else pure ()
  (result,_) <- evaluate 4096 [] flat
  numeral <- case result of
    Natural n -> Just n
    Closure _ _ -> Nothing
  if numeral > 4096 || not (equal 0 book body (natTerm numeral)) then Nothing else pure ()
  let encoded = Lazy.toStrict (encodeFlat (Node "CheckedNatBetaV1" [NatAtom numeral]))
  pure (ByteArray.convert (hash encoded :: Digest SHA3_512))

data Value = Natural Int | Closure Flat [Value]

-- Check every branch, including uncalled lambda bodies, before evaluation.
-- The size bound keeps the checker comparison focused on short certificates.
safeFragment :: Int -> Flat -> Bool
safeFragment count _ | count > 1024 = False
safeFragment _ (Node "Zer" []) = True
safeFragment count (Node "Suc" [n]) = safeFragment (count+1) n
safeFragment count (Node "Lam" [Node "Body" [body]]) = safeFragment (count+1) body
safeFragment count (Node "App" [f,x]) = safeFragment (count+1) f && safeFragment (count+1) x
safeFragment _ (Bound i) = i >= 0 && i <= 1024
safeFragment _ _ = False

fragmentSize :: Flat -> Int
fragmentSize (Node _ children) = 1 + sum (map fragmentSize children)
fragmentSize _ = 1

evaluate :: Int -> [Value] -> Flat -> Maybe (Value,Int)
evaluate fuel _ _ | fuel <= 0 = Nothing
evaluate fuel env flat = case flat of
  Bound i -> do
    value <- at i env
    pure (value,fuel-1)
  Node "Zer" [] -> Just (Natural 0,fuel-1)
  Node "Suc" [n] -> do
    (value,left) <- evaluate (fuel-1) env n
    case value of
      Natural count | count < 4096 -> Just (Natural (count+1),left)
      _ -> Nothing
  Node "Lam" [Node "Body" [body]] -> Just (Closure body env,fuel-1)
  Node "App" [f,x] -> do
    (function,left1) <- evaluate (fuel-1) env f
    (argument,left2) <- evaluate left1 env x
    case function of
      Closure body captured -> evaluate left2 (argument:captured) body
      Natural _ -> Nothing
  _ -> Nothing

at :: Int -> [a] -> Maybe a
at i _ | i < 0 = Nothing
at _ [] = Nothing
at 0 (x:_) = Just x
at i (_:xs) = at (i-1) xs

natTerm :: Int -> Term
natTerm n = go n
  where
    go 0 = Zer
    go k = Suc (go (k-1))
