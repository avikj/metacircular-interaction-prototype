#!/usr/bin/env bash
# pusc/test.sh — MAP.md §10.  Each line: file  def  expected-value.  Values only; ITRS is the kernel's own metric.
set -u; cd "$(dirname "$0")"
gcc -std=gnu11 -O2 -Wall -Wno-misleading-indentation -Wno-unused-parameter -Wno-unused-function -o pusc cell.c read.c main.c || exit 1
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
check t/ua.pusc    glue-at-0 '#Bool{}'
check t/ua.pusc    fwd-true  '#False{}'
check t/ua.pusc    fwd-false '#True{}'
check t/ua.pusc    bwd-true  '#False{}'
# the interval is De Morgan, not Boolean: absorption holds, complement does not
got=$(./pusc run t/kan.pusc absorb | head -1);   case "$got" in i[0-9]*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL absorb: $got";; esac
got=$(./pusc run t/kan.pusc nocompl | head -1);  case "$got" in '~i'*'∨i'*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL nocompl: $got";; esac
got=$(./pusc run t/kan.pusc demorgan | head -1); case "$got" in '~i'*'∨~i'*) pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL demorgan: $got";; esac
# no capture: the face at M passes inside; the inner sup keeps its own fresh name (a heap address, not a fixed label)
got=$(./pusc run t/sup.pusc nocapture | head -1); case "$got" in '&'*'{5,6}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL nocapture: $got";; esac
echo "pass=$pass fail=$fail"; [ $fail -eq 0 ]
