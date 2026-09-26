#!/usr/bin/env bash
# pusc/test.sh — MAP.md §10.  Each line: file  def  expected-value.  Values only; ITRS is the kernel's own metric.
set -u; cd "$(dirname "$0")"
gcc -std=gnu11 -O2 -Wall -Wno-misleading-indentation -Wno-unused-parameter -Wno-unused-function -o pusc cell.c read.c verify.c main.c -lm || exit 1
pass=0; fail=0
check() { got=$(./pusc run "$1" "$2" 2>&1 | head -1); if [ "$got" = "$3" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL $1 $2: got '$got' want '$3'"; fi; }
check t/basic.pusc main      '#Suc{#Suc{#Suc{#Suc{#Zer{}}}}}'
check t/lazy.pusc  main      '#False{}'
check t/sup.pusc   pick0     '1'
check t/sup.pusc   pick1     '2'
check t/sup.pusc   dist      '&1{6,10}'
check t/sup.pusc   matchsup  '&1{#False{},#True{}}'
check t/sup.pusc   main      '#Pair{1,2}'
check t/kan.pusc   reg       '5'
check t/kan.pusc   suptrp    '#True{}'
check t/kan.pusc   hc-true   '7'
check t/kan.pusc   hc-none   '0'
check t/kan.pusc   hc-nat    '#Suc{#Zer{}}'
check t/kan.pusc   pitrp     '9'
# a Glue type with a true face IS that partial type (glueT)
got=$(./pusc run t/ua.pusc glue-at-0 | head -1); case "$got" in '#Bool{}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL glue-at-0: $got";; esac
check t/ua.pusc    fwd-true  '#False{}'
check t/ua.pusc    fwd-false '#True{}'
check t/ua.pusc    bwd-true  '#False{}'
# composites in the universe: hcomp in Set is a Glue type (transpEquiv); the inverse and Pi lines of ua
check t/setcomp.pusc via-inv      '#False{}'
check t/setcomp.pusc via-pi       '#False{}'
check t/setcomp.pusc via-negneg-t '#True{}'
check t/setcomp.pusc via-negneg-f '#False{}'
# higher inductive types: endpoint from the type, eliminator at a symbolic interval, face into a stuck spine,
# eliminator over a composite (comp along the motive), transport pushing into a constructor's field
check t/hit.pusc loop0     '#base{}'
check t/hit.pusc at-sym    '2'
check t/hit.pusc at-0      '1'
check t/hit.pusc faced     '1'
check t/hit.pusc helim-sq  '#Zer{}'
check t/hit.pusc sup-pt    '&1{1,1}'
check t/hit.pusc merid-t   '#merid{#Bool{},#False{}}'
check t/hit.pusc merid-t0  '#north{#Bool{}}'
# the interval is De Morgan, not Boolean: absorption holds, complement does not
got=$(./pusc run t/kan.pusc absorb | head -1);   case "$got" in i[0-9]*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL absorb: $got";; esac
got=$(./pusc run t/kan.pusc nocompl | head -1);  case "$got" in '~i'*'∨i'*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL nocompl: $got";; esac
got=$(./pusc run t/kan.pusc demorgan | head -1); case "$got" in '~i'*'∨~i'*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL demorgan: $got";; esac
# no capture: the face at M passes inside; the inner sup keeps its own fresh name (a heap address, not a fixed label)
got=$(./pusc run t/sup.pusc nocapture | head -1); case "$got" in '&'*'{5,6}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL nocapture: $got";; esac
# the machine that asks (§5): questions from the world, an ASK answered by the world
got=$(printf '(lam p (proj 0 p))\n(lam t (proj 0 (proj 1 t)))\n' | ./pusc interact t/interact.pusc main | grep -v Itrs | tr '\n' ' ')
if [ "$got" == "#Pair{1,#Pair{2,3}} 1 #Pair{1,#Pair{2,3}} " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL interact: $got"; fi
got=$(printf '(ctr True)\n(lam p (proj 1 p))\n' | ./pusc interact t/interact.pusc asks | grep -v Itrs | tr '\n' ' ')
if [ "$got" == "? #Cons{'w',#Cons{'h',#Cons{'o',#Nil{}}}} #Pair{#True{},7} 7 " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL ask: $got"; fi
# the checker (verify.c) on its probes: every definition checks
n=$(./pusc check t/check.pusc 2>/dev/null | grep -c '✓'); m=$(grep -c '^(def' t/check.pusc)
if [ "$n" -eq "$m" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL check: $n of $m definitions check"; fi
# §3.3 erase at the projection: a forgotten port costs one row where it is forgotten; the fibre's size never enters
checkn() { got=$(./pusc run "$1" "$2" 2>&1 | tr '\n' ' '); if [ "$got" = "$3 - Itrs: $4 " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL $1 $2: got '$got' want '$3 - Itrs: $4'"; fi; }
checkn t/erase.pusc fst-big '1' 2
checkn t/erase.pusc and-f   '#False{}' 4
checkn t/erase.pusc and-t   '#True{}' 3
checkn t/erase.pusc const   '7' 2
checkn t/erase.pusc dflt    '3' 3
checkn t/erase.pusc carry   '1' 2
# §5.1 a dialect is a book (t/grammar.pusc): the sentence's characters meet the rules; an ambiguity is a superposition at
# a label, the later context (< or >) is the face map that decides it; the translation is read back as the kernel's text
checkp() { got=$(printf '%s\n' "$1" | ./pusc parse t/grammar.pusc - 2>&1 | sed -n '2p;3p' | tr '\n' ' '); if [ "$got" = "$2 - Itrs: $3 " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL parse '$1': got '$got' want '$2 - Itrs: $3'"; fi; }
checkp '10 - 4 - 3'   '&7{3,9}' 4
checkp '10 - 4 - 3 <' '3' 2
checkp '10 - 4 - 3 >' '9' 2
checkp '(\f. \x. f (f x)) (\n. n - 1) 9' '7' 6
got=$(printf '10 - 4 - 3 <\n' | ./pusc parse t/grammar.pusc - | head -1); if [ "$got" = "(def main (op2 - (op2 - 10 4) 3)) " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL translation: $got"; fi
# §8 install: notnot := id by a checked certificate; the value is unchanged, the run pays one R_INSTALL row instead of two case rows;
# a certificate that does not check refuses to run
check t/install.pusc main '#True{}'
n=$(./pusc run t/install.pusc main | sed -n 's/^- Itrs: //p'); if [ "$n" -lt 5 ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL install itrs: $n"; fi
got=$(./pusc check t/install.pusc | grep -c '✓ install notnot := id'); if [ "$got" -eq 1 ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL install check"; fi
sed 's/(ref notnot) (ref id))/(ref id) (ref id))/; s/(app (app (ref negLnv) x) i)/x/' t/install.pusc > /tmp/pusc-badinstall.pusc
./pusc run /tmp/pusc-badinstall.pusc main >/dev/null 2>&1; if [ $? -eq 1 ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL bad install accepted"; fi; rm -f /tmp/pusc-badinstall.pusc
echo "pass=$pass fail=$fail"; [ $fail -eq 0 ]
