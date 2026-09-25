{-./../Type.hs-}

module Core.Parse.Book 
  ( parseBook
  , doParseBook
  , doReadBook
  ) where

import Control.Monad (when)
import Control.Monad.State.Strict (State, get, put, evalState)
import Data.Char (isAsciiLower, isAsciiUpper, isDigit)
import Data.List (intercalate)
import Data.Void
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Data.Map.Strict as M
import qualified Text.Megaparsec.Char.Lexer as L

import Debug.Trace

import Core.Adjust
import Core.Parse
import Core.Parse.Term (parseTerm, parseTermBefore)
import Core.Type

-- | Book parsing

-- | Syntax: def name : Type = term | type Name<T>(i) -> Type: cases | name : Type = term
parseDefinition :: Parser (Name, Defn, Maybe (Name, HitDecl))
parseDefinition = choice [ parseType , (\(n, d) -> (n, d, Nothing)) <$> parseDef ]

-- | Syntax: def name : Type = term | def name(x: T1, y: T2) -> RetType: body
parseDef :: Parser (Name, Defn)
parseDef = do
  _ <- symbol "def"
  f <- name
  choice
    [ parseDefFunction f
    , parseDefSimple f ]

-- | Syntax: def name : Type = term
parseDefSimple :: Name -> Parser (Name, Defn)
parseDefSimple defName = do
  _ <- symbol ":"
  t <- parseTermBefore "="
  _ <- symbol "="
  x <- parseTerm
  return (defName, (False, x, t))

-- | Syntax: def name(x: Type1, y: Type2) -> ReturnType: body
--           def name<A, B>(x: Type1, y: Type2) -> ReturnType: body
parseDefFunction :: Name -> Parser (Name, Defn)
parseDefFunction f = label "function definition" $ do
  -- Parse optional generic type parameters <A, B, ...>
  typeParams <- option [] $ angles $ sepEndBy name (symbol ",")
  -- Convert type params to arguments with type Set
  let typeArgs = [(tp, Set) | tp <- typeParams]
  -- Parse regular arguments
  regularArgs <- parens $ sepEndBy (parseArg False) (symbol ",")
  -- Combine type params (as Set-typed args) with regular args
  let args = typeArgs ++ regularArgs
  _ <- symbol "->"
  returnType <- parseTerm
  _ <- symbol ":"
  body <- parseTerm
  let (typ, bod) = foldr nestTypeBod (returnType, body) args
  return (f, (False, bod, typ))
  where
    -- parseArg = (,) <$> name <*> (symbol ":" *> parseTerm)
    -- TODO: refactor parseArg to use a do-block instead. DO IT BELOW:
    nestTypeBod (argName, argType) (currType, currBod) = (All argType (Lam argName (\v -> currType)), Lam argName (\v -> currBod))

-- | Parse a module path like Path/To/Lib
parseModulePath :: Parser String
parseModulePath = do
  firstPart <- name
  restParts <- many (try $ char '/' >> name)
  skip -- consume whitespace after path
  return $ intercalate "/" (firstPart : restParts)

-- | Add an import mapping to the parser state
addImportMapping :: String -> String -> Parser ()
addImportMapping alias path = do
  st <- get
  let aliasKey = alias ++ "/"
      pathValue = path ++ "/"
      newImports = M.insert aliasKey pathValue (imports st)
  put st { imports = newImports }

-- | Syntax: import Path/To/Lib as Lib
parseImport :: Parser ()
parseImport = do
  _ <- symbol "import"
  path <- parseModulePath
  _ <- symbol "as"
  alias <- name
  addImportMapping alias path

-- | Syntax: import statements followed by definitions
parseBook :: Parser Book
parseBook = do
  -- Parse all import statements first
  _ <- many (try parseImport)
  -- Then parse definitions
  entries <- many parseDefinition
  let defs = [ (n, d) | (n, d, _) <- entries ]
      hits = [ h | (_, _, Just h) <- entries ]
  return $ Book (M.fromList defs) (M.fromList hits)

-- | Syntax: type Name<T, U>(i: Nat) -> Type: case @Tag1: field1: T1 case @Tag2: field2: T2
parseType :: Parser (Name, Defn, Maybe (Name, HitDecl))
parseType = label "datatype declaration" $ do
  _       <- symbol "type"
  tName   <- name
  params  <- option [] $ angles (sepEndBy (parseArg True) (symbol ","))
  indices <- option [] $ parens (sepEndBy (parseArg False) (symbol ","))
  args    <- return $ params ++ indices
  retTy   <- option Set (symbol "->" *> parseTerm)
  _       <- symbol ":"
  clauses <- many (choice [ Left <$> parseTypeCase, Right <$> parsePathCase ])
  let cases  = [ c | Left c <- clauses ]
      pathCs = [ p | Right p <- clauses ]
  when (null clauses) $ fail "datatype must have at least one constructor case"
  return (if null pathCs then mkData tName args retTy cases else mkHit tName args retTy clauses)

-- | An ordinary (point-only) datatype: the enum-tagged sigma encoding.
mkData :: Name -> [(Name, Term)] -> Term -> [(String, [(Name, Term)])] -> (Name, Defn, Maybe (Name, HitDecl))
mkData tName args retTy cases =
  let tags = map fst cases
      mkFields :: [(Name, Term)] -> Term
      mkFields []             = Uni
      mkFields ((fn,ft):rest) = Sig ft (Lam fn (\_ -> mkFields rest))
      branches v = Pat [v] [] [([Sym tag], mkFields flds) | (tag, flds) <- cases]
      body0 = Sig (Enu tags) (Lam "ctr" (\v -> branches v))
      nest (n, ty) (tyAcc, bdAcc) = (All ty  (Lam n (\_ -> tyAcc)) , Lam n (\_ -> bdAcc))
      (fullTy, fullBody) = foldr nest (retTy, body0) args
  in (tName, (True, fullBody, fullTy), Nothing)

-- | Syntax: case @Tag: field1: Type1 field2: Type2
parseTypeCase :: Parser (String, [(Name, Term)])
parseTypeCase = label "datatype constructor" $ do
  _    <- symbol "case"
  _    <- symbol "@"
  tag  <- some (satisfy isNameChar)
  _    <- symbol ":"
  flds <- many parseField
  return (tag, flds)
  where
    -- Parse a field declaration  name : Type
    parseField :: Parser (Name, Term)
    parseField = do
      -- Stop if next token is 'case' (start of next constructor) or 'def'/'data'
      notFollowedBy (symbol "case")
      notFollowedBy (symbol "path")
      n <- try $ do
        n <- name
        _ <- symbol ":"
        return n
      t <- parseTerm
      -- Optional semicolon or newline is already handled by lexeme
      return (n,t)

parseArg :: Bool -> Parser (Name, Term)
parseArg expr = do
  k <- name
  _ <- symbol ":"
  t <- if expr then parseTerm else parseTerm
  return (k, t)

-- | Main entry points

-- | Parse a book from a string, returning an error message on failure
doParseBook :: FilePath -> String -> Either String Book
doParseBook file input =
  case evalState (runParserT p file input) (ParserState True input [] M.empty) of
    Left err  -> Left (formatError input err)
    Right res -> Right (adjustBook res)
      -- in Right (trace (show book) book)
  where
    p = do
      skip
      book <- parseBook
      skip
      eof
      return book

-- | Parse a book from a string, crashing on failure
doReadBook :: String -> Book
doReadBook input =
  case doParseBook "<input>" input of
    Left err  -> error err
    Right res -> res

-- | Syntax:  path @tag(f1: T1, f2: T2): Path(T(ps), lhs, rhs)
-- A path constructor of a higher inductive type: named fields in parens and
-- the constructor's own (nested) Path type into the HIT.
parsePathCase :: Parser (String, [(Name, Term)], Term)
parsePathCase = label "path constructor" $ do
  _    <- symbol "path"
  _    <- symbol "@"
  tag  <- some (satisfy isNameChar)
  flds <- option [] $ parens (sepEndBy (parseArg True) (symbol ","))
  _    <- symbol ":"
  ty   <- parseTerm
  return (tag, flds, ty)

-- | A `type` declaration with at least one `path` clause is a HIT: the type
-- former is opaque (its body is the HTy node), and every constructor gets a
-- closed Pi-type over the parameters and its fields.
mkHit :: Name -> [(Name, Term)] -> Term -> [Either (String, [(Name, Term)]) (String, [(Name, Term)], Term)] -> (Name, Defn, Maybe (Name, HitDecl))
mkHit tName args _ clauses =
  let nest (n, ty) acc = All ty (Lam n (\_ -> acc))
      hitTy   = foldr nest Set args
      self    = HTy tName [ Var n 0 | (n, _) <- args ]
      body    = foldr (\(n, _) acc -> Lam n (\_ -> acc)) self args
      ctor cl = case cl of
        Left  (tag, flds)     -> (tag, HitCtor (length flds) 0 (foldr nest self (args ++ flds)))
        Right (tag, flds, ty) -> (tag, HitCtor (length flds) (pathDim ty) (foldr nest ty (args ++ flds)))
      pathDim t = case t of
        Loc _ u   -> pathDim u
        Pth l _ _ -> 1 + pathDim (lineBody l)
        _         -> 0
      lineBody l = case l of
        Loc _ u  -> lineBody u
        Lam _ f  -> f (Var "_" 0)
        u        -> App u (Var "_" 0)
      decl = HitDecl (length args) hitTy (map ctor clauses)
  in (tName, (True, body, hitTy), Just (tName, decl))
