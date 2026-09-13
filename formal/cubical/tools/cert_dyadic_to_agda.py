#!/usr/bin/env python3
"""Dyadic slack certificate (JSON: n, A, L, D, E, c as scaled integers with
A − c·I = L·D·Lᵀ + E exactly, D ≥ 0, 4E_ii ≥ Σ_j|E_ij| + Σ_j|E_ji|) → Agda module
checked by SadhakaSesa.  Usage: cert_dyadic_to_agda.py cert.json ModuleName > ModuleName.agda"""
import sys, json
sys.set_int_max_str_digits(0)
c=json.load(open(sys.argv[1])); n=c["n"]; mod=sys.argv[2]
A,L,D,E,cc=c["A"],c["L"],c["D"],c["E"],c["c"]
for i in range(n):
    for j in range(n):
        assert A[i][j]-(cc if i==j else 0)==sum(L[i][k]*D[k]*L[j][k] for k in range(n))+E[i][j],(i,j)
    assert D[i]>=0 and 4*E[i][i]>=sum(abs(E[i][j]) for j in range(n))+sum(abs(E[j][i]) for j in range(n)),i
assert cc>0
def s𝕊(x): return f"⁺ {x}" if x>=0 else f"⁻ {-x}"
def t2(name,M):
    rows=" ∷\n  ".join("(" + " ∷ ".join(s𝕊(M[i][j]) for j in range(n)) + " ∷ [])" for i in range(n))
    return f"{name}-rows : List (List 𝕊)\n{name}-rows =\n  {rows} ∷ []\n{name} : ℕ → ℕ → 𝕊\n{name} i j = at𝕊 (atL {name}-rows i) j"
print(f"""{{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}}
module {mod} where
-- dyadic slack certificate: A′ = 2^{c['k']}·A, L′ = 2^{c.get('kL','?')}·L, D′ = 2^{c.get('kD','?')}·D, c′ = 2^{c['k']}·c
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (true)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (_≤_)
open import Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed using (𝕊 ; ⁺_ ; ⁻_)
open import Sadhaka_AnIntegerLDLTCertificateCheckedAtMachineSpeedYieldsThePositivityOfTheRationalFormThroughPramanika using (toℚ)
open import SadhakaSesa_ADyadicSlackCertificateCheckedAtMachineSpeedYieldsAStrictSpectralGapOfTheRationalFormThroughGersgorinAndPramanika
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm using (Σ⟨_⟩)
import Gersgorin_ADiagonallyDominantMatrixWithNonnegativeDiagonalHasANonnegativeQuadraticFormSoASlackTermInACertificateIsAbsorbedRowByRow as G
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
{t2("A",A)}
{t2("L",L)}
{t2("E",E)}
D-list : List ℕ
D-list = {" ∷ ".join(str(d) for d in D)} ∷ []
D : ℕ → ℕ
D i = atℕ D-list i
c : ℕ
c = {cc}
sādhya-satya : sādhya {n} A L E D c ≡ true
sādhya-satya = refl
-- THE THEOREM: the certified spectral gap of the rational form
antara : (v : ℕ → ℚ) → toℚ (⁺ c) · Σ⟨ {n} ⟩ (λ i → v i · v i) ≤ G.Q {n} (Aℚ {n} A L E D c) v
antara = sādhaka-śeṣa {n} A L E D c sādhya-satya
""")
