#!/usr/bin/env python3
"""Exact-rational LDLᵀ certificate → integer-scaled Agda module checked by Sadhaka.
Input JSON: {"n": N, "A": [[..]], "L": [[..]], "D": [..]} entries "p/q" or ints, A = L D Lᵀ exactly, D ≥ 0.
Scaling: s = lcm of denominators of L; L' = s·L (integers); t = lcm of denominators of D; D' = t·D (naturals);
A' = t·s²·A (integers).  Then A' = L' D' L'ᵀ.  Emits tables in Saṅkhyā (⁺ n / ⁻ n) and a refl check.
Usage: cert_to_agda.py cert.json ModuleName > ModuleName.agda
"""
import sys, json
sys.set_int_max_str_digits(0)
from fractions import Fraction as F
from math import lcm
def s𝕊(x):
    x=int(x); return f"⁺ {x}" if x>=0 else f"⁻ {-x}"
def t2(name,M,n):
    rows=" ∷\n  ".join("(" + " ∷ ".join(s𝕊(M[i][j]) for j in range(n)) + " ∷ [])" for i in range(n))
    return f"{name}-rows : List (List 𝕊)\n{name}-rows =\n  {rows} ∷ []\n{name} : ℕ → ℕ → 𝕊\n{name} i j = at𝕊 (atL ({name}-rows) i) j"
def t1(name,V,n):
    return f"{name}-list : List ℕ\n{name}-list = " + " ∷ ".join(str(int(v)) for v in V) + f" ∷ []\n{name} : ℕ → ℕ\n{name} i = atℕ {name}-list i"
c=json.load(open(sys.argv[1])); n=c["n"]; mod=sys.argv[2]
A=[[F(str(x)) for x in r] for r in c["A"]]; L=[[F(str(x)) for x in r] for r in c["L"]]; D=[F(str(x)) for x in c["D"]]
for i in range(n):
    for j in range(n):
        assert A[i][j]==sum(L[i][k]*D[k]*L[j][k] for k in range(n)), (i,j)
assert all(d>=0 for d in D)
s=1
for r in L:
    for x in r: s=lcm(s,x.denominator)
t=1
for d in D: t=lcm(t,d.denominator)
Lp=[[x*s for x in r] for r in L]; Dp=[d*t for d in D]; Ap=[[x*t*s*s for x in r] for r in A]
assert all(x.denominator==1 for r in Lp for x in r) and all(d.denominator==1 for d in Dp) and all(x.denominator==1 for r in Ap for x in r)
print(f"""{{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}}
module {mod} where
-- integer-scaled certificate: A' = {t}·{s}²·A, L' = {s}·L, D' = {t}·D
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (true)
open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (_≤_)
open import Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed using (𝕊 ; ⁺_ ; ⁻_)
open import Sadhaka_AnIntegerLDLTCertificateCheckedAtMachineSpeedYieldsThePositivityOfTheRationalFormThroughPramanika
import Pramanika_AnExactRationalLDLTFactorisationCertifiesThatAQuadraticFormIsNonnegativeSoAPositivityCertificateIsACheckableTerm as P
open import Cubical.Data.List using (List ; [] ; _∷_)
atL : List (List 𝕊) → ℕ → List 𝕊
atL []       _       = []
atL (r ∷ _)  zero    = r
atL (_ ∷ rs) (suc i) = atL rs i
at𝕊 : List 𝕊 → ℕ → 𝕊
at𝕊 []       _       = ⁺ 0
at𝕊 (x ∷ _)  zero    = x
at𝕊 (_ ∷ xs) (suc i) = at𝕊 xs i
atℕ : List ℕ → ℕ → ℕ
atℕ []       _       = 0
atℕ (x ∷ _)  zero    = x
atℕ (_ ∷ xs) (suc i) = atℕ xs i
{t2("A",Ap,n)}
{t2("L",Lp,n)}
{t1("D",Dp,n)}
sādhya-satya : sādhya {n} A L D ≡ true
sādhya-satya = refl
dhana : (v : ℕ → ℚ) → 0 ≤ P.Q {n} (Aℚ {n} A L D) (Lℚ {n} A L D) (Dℚ {n} A L D) v
dhana = sādhaka {n} A L D sādhya-satya
""")
