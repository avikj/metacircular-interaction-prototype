#!/usr/bin/env bash
# hyper/test.sh — the substrate's checks.  Each line: file  def  expected value.  Values only.
set -u; cd "$(dirname "$0")"
gcc -std=gnu11 -O2 -Wall -Wno-misleading-indentation -Wno-unused-parameter -Wno-unused-function -o hyper cell.c read.c verify.c main.c -lm || exit 1
pass=0; fail=0
check() { got=$(./hyper run "$1" "$2" 2>&1 | head -1); if [ "$got" = "$3" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL $1 $2: got '$got' want '$3'"; fi; }
check t/basic.hyper main      '#Suc{#Suc{#Suc{#Suc{#Zer{}}}}}'
# the capture probes: cap4 = 4, two∘two = 4, the triple = 16
check t/basic.hyper cap4    '4'
check t/basic.hyper two-two '4'
check t/basic.hyper triple  '16'
check t/lazy.hyper  main      '#False{}'
check t/sup.hyper   pick0     '1'
check t/sup.hyper   pick1     '2'
check t/sup.hyper   dist      '&1{6,10}'
check t/sup.hyper   matchsup  '&1{#False{},#True{}}'
check t/sup.hyper   main      '#Pair{1,2}'
check t/sup.hyper   shared-redex '&3{13,14}'
check t/kan.hyper   reg       '5'
check t/kan.hyper   suptrp    '#True{}'
check t/kan.hyper   hc-true   '7'
check t/kan.hyper   hc-none   '0'
check t/kan.hyper   hc-nat    '#Suc{#Zer{}}'
check t/kan.hyper   pitrp     '9'
# a Glue type with a true face IS that partial type
got=$(./hyper run t/ua.hyper glue-at-0 | head -1); case "$got" in '#Bool{}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL glue-at-0: $got";; esac
check t/ua.hyper    fwd-true  '#False{}'
check t/ua.hyper    fwd-false '#True{}'
check t/ua.hyper    bwd-true  '#False{}'
# composites in the universe: hcomp in Set is a Glue type (transpEquiv); the inverse and Pi lines of ua
check t/setcomp.hyper via-inv      '#False{}'
check t/setcomp.hyper via-pi       '#False{}'
check t/setcomp.hyper via-negneg-t '#True{}'
check t/setcomp.hyper via-negneg-f '#False{}'
# higher inductive types: endpoint from the type, eliminator at a symbolic interval, face into a stuck spine,
# eliminator over a composite (comp along the motive), transport pushing into a constructor's field
check t/hit.hyper loop0     '#base{}'
check t/hit.hyper at-sym    '2'
check t/hit.hyper at-0      '1'
check t/hit.hyper faced     '1'
check t/hit.hyper helim-sq  '#Zer{}'
check t/hit.hyper sup-pt    '&1{1,1}'
check t/hit.hyper merid-t   '#merid{#Bool{},#False{}}'
check t/hit.hyper merid-t0  '#north{#Bool{}}'
# the interval is De Morgan, not Boolean: absorption holds, complement does not
got=$(./hyper run t/kan.hyper absorb | head -1);   case "$got" in i[0-9]*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL absorb: $got";; esac
got=$(./hyper run t/kan.hyper nocompl | head -1);  case "$got" in '~i'*'∨i'*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL nocompl: $got";; esac
got=$(./hyper run t/kan.hyper demorgan | head -1); case "$got" in '~i'*'∨~i'*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL demorgan: $got";; esac
# no capture: the face at M passes inside; the inner sup keeps its own fresh name (a heap address, not a fixed label)
got=$(./hyper run t/sup.hyper nocapture | head -1); case "$got" in '&'*'{5,6}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL nocapture: $got";; esac
# Fibre.CorpusInteraction: the point, questions from the world (typed maps), the point presented along each;
# an ASK cell is answered by the world
got=$(printf '(lam p (proj 0 p))\n(lam t (proj 0 (proj 1 t)))\n' | ./hyper interact t/interact.hyper main | tr '\n' ' ')
if [ "$got" == "#Pair{1,#Pair{2,3}} 1 #Pair{1,#Pair{2,3}} " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL interact: $got"; fi
got=$(printf '(ctr True)\n(lam p (proj 1 p))\n' | ./hyper interact t/interact.hyper asks | tr '\n' ' ')
if [ "$got" == "? #Cons{'w',#Cons{'h',#Cons{'o',#Nil{}}}} #Pair{#True{},7} 7 " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL ask: $got"; fi
# the checker (verify.c) on its probes: every definition checks
n=$(./hyper check t/check.hyper 2>/dev/null | grep -c '✓'); m=$(grep -c '^(def' t/check.hyper)
if [ "$n" -eq "$m" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL check: $n of $m definitions check"; fi
# the census of a question (Fibre.WholePartialDesa §3, computed): f : Unit → Bool is सकलादेश at True and नास्ति at False;
# g : Bool → Unit is विकलादेश at Tt; the composite is सकलादेश; not : Bool → Bool is सकलादेश everywhere
got=$(./hyper census t/census.hyper always-true unit bool2 | tr '\n' ' ')
if [ "$got" = "#True{}: सकलादेश #Tt{} #False{}: नास्ति " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL census f: $got"; fi
got=$(./hyper census t/census.hyper forget bool unit | tr '\n' ' ')
if [ "$got" = "#Tt{}: विकलादेश #True{} #False{} " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL census g: $got"; fi
got=$(./hyper census t/census.hyper compose unit unit | tr '\n' ' ')
if [ "$got" = "#Tt{}: सकलादेश #Tt{} " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL census g∘f: $got"; fi
got=$(./hyper census t/census.hyper not bool bool2 | tr '\n' ' ')
if [ "$got" = "#True{}: सकलादेश #False{} #False{}: सकलादेश #True{} " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL census not: $got"; fi
# every identifier MAP.md names is on the line it cites
if ./cite.sh >/dev/null; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL cite: $(./cite.sh | tail -3 | tr '\n' ' ')"; fi
echo "pass=$pass fail=$fail"; [ $fail -eq 0 ]
