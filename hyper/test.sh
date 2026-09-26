#!/usr/bin/env bash
# hyper/test.sh — the substrate's checks: values, and the ledger's count where a check is about cost.
set -u; cd "$(dirname "$0")"
gcc -std=gnu11 -O2 -Wall -Wno-misleading-indentation -Wno-unused-parameter -Wno-unused-function -o hyper cell.c read.c verify.c main.c -lm || exit 1
pass=0; fail=0
check() { got=$(./hyper run "$1" "$2" 2>&1 | head -1); if [ "$got" = "$3" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL $1 $2: got '$got' want '$3'"; fi; }
check t/basic.hyper main      '#Suc{#Suc{#Suc{#Suc{#Zer{}}}}}'
# §10.4 capture probes: cap4 = 4, two∘two = 4, the triple = 16
check t/basic.hyper cap4    '4'
check t/basic.hyper two-two '4'
check t/basic.hyper triple  '16'
check t/lazy.hyper  main      '#False{}'
check t/sup.hyper   pick0     '1'
check t/sup.hyper   pick1     '2'
check t/sup.hyper   dist      '&1{6,10}'
check t/sup.hyper   matchsup  '&1{#False{},#True{}}'
check t/sup.hyper   main      '#Pair{1,2}'
check t/kan.hyper   reg       '5'
check t/kan.hyper   suptrp    '#True{}'
check t/kan.hyper   hc-true   '7'
check t/kan.hyper   hc-none   '0'
check t/kan.hyper   hc-nat    '#Suc{#Zer{}}'
check t/kan.hyper   pitrp     '9'
# a Glue type with a true face IS that partial type (glueT)
got=$(./hyper run t/ua.hyper glue-at-0 | head -1); case "$got" in '#Bool{}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL glue-at-0: $got";; esac
check t/ua.hyper    fwd-true  '#False{}'
check t/ua.hyper    fwd-false '#True{}'
check t/ua.hyper    bwd-true  '#False{}'
# §10.5 sharing: a transport consumed k times costs one transport plus k small increments (linear in k, each ≪ the transport)
u1=$(./hyper run t/ua.hyper use1 | sed -n 's/^- Itrs: //p'); u2=$(./hyper run t/ua.hyper use2 | sed -n 's/^- Itrs: //p'); u4=$(./hyper run t/ua.hyper use4 | sed -n 's/^- Itrs: //p')
if [ $((u4-u1)) -eq $((3*(u2-u1))) ] && [ $((u2-u1)) -lt 10 ] && [ "$u1" -gt 50 ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL sharing k uses: $u1 $u2 $u4"; fi
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
# the machine that asks (§5): questions from the world, an ASK answered by the world
got=$(printf '(lam p (proj 0 p))\n(lam t (proj 0 (proj 1 t)))\n' | ./hyper interact t/interact.hyper main | grep -v Itrs | tr '\n' ' ')
if [ "$got" == "#Pair{1,#Pair{2,3}} 1 #Pair{1,#Pair{2,3}} " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL interact: $got"; fi
got=$(printf '(ctr True)\n(lam p (proj 1 p))\n' | ./hyper interact t/interact.hyper asks | grep -v Itrs | tr '\n' ' ')
if [ "$got" == "? #Cons{'w',#Cons{'h',#Cons{'o',#Nil{}}}} #Pair{#True{},7} 7 " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL ask: $got"; fi
# the checker (verify.c) on its probes: every definition checks
n=$(./hyper check t/check.hyper 2>/dev/null | grep -c '✓'); m=$(grep -c '^(def' t/check.hyper)
if [ "$n" -eq "$m" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL check: $n of $m definitions check"; fi
# §3.3 erase at the projection: a forgotten port costs one row where it is forgotten; the fibre's size never enters
checkn() { got=$(./hyper run "$1" "$2" 2>&1 | grep -v Words | tr '\n' ' '); if [ "$got" = "$3 - Itrs: $4 " ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL $1 $2: got '$got' want '$3 - Itrs: $4'"; fi; }
# §3 a demanded port fires once: a redex held by both sides of a distribution is one row (3*4 once, not per side)
checkn t/sup.hyper shared-redex '&3{13,14}' 6
checkn t/erase.hyper fst-big '1' 2
checkn t/erase.hyper and-f   '#False{}' 4
checkn t/erase.hyper and-t   '#True{}' 3
checkn t/erase.hyper const   '7' 2
checkn t/erase.hyper dflt    '3' 3
checkn t/erase.hyper carry   '1' 2
# §9 schedules: the redex bag is the only scheduler; serving the right demand first, or a coin per choice, gives
# the same value in the same count on every probe above (a fresh dimension's printed name is gauge, not value)
for pair in t/basic.hyper:main t/sup.hyper:dist t/sup.hyper:matchsup t/kan.hyper:reg t/kan.hyper:hc-nat t/kan.hyper:pitrp t/ua.hyper:fwd-true t/setcomp.hyper:via-pi t/hit.hyper:helim-sq t/hit.hyper:merid-t t/erase.hyper:and-f; do
  f=${pair%%:*}; d=${pair##*:}; a=$(./hyper run $f $d 2>&1 | grep -v Words | tr '\n' ' '); b=$(HYPER_SCHEDULE=right ./hyper run $f $d 2>&1 | grep -v Words | tr '\n' ' '); c=$(HYPER_SCHEDULE=7 ./hyper run $f $d 2>&1 | grep -v Words | tr '\n' ' ')
  if [ "$a" = "$b" ] && [ "$a" = "$c" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL schedule $f $d: [$a] [$b] [$c]"; fi; done
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
# the encounter of two peers (kernel-flat/TheEncounterOfTwoPeers…), computed: two terms that reach one normal form;
# §2 the results need not agree, §4 the prior trace is a prefix, §5 the round trip is 2·len τ from a to a, §3 revelation and generation
got=$(./hyper meet t/meet.hyper a b | sed -n '1p;2p;3p;5p;6p;7p;8p' | tr '\n' '|')
want="meeting: #Suc{#Suc{#Zer{}}}|mine: 4  theirs: 1  τ: 5|A′ stands at b, B′ stands at a; the two results need not agree|the prior trace is a prefix: yes|round trip: 10 steps, from a to a; the meaning is refl, the object is not done|A could act at the meeting before: no; after: yes|the pair holds the joint route: yes yes|"
if [ "$got" = "$want" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL meet: $got"; fi
./hyper meet t/meet.hyper a c >/dev/null 2>&1; if [ $? -eq 2 ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL meet: no meeting should refuse"; fi
# §7 the crossing: two redexes that do not touch, contracted in the two orders: same value, same len, different traces (§8: no section)
l=$(HYPER_TRACE=1 ./hyper run t/meet.hyper cross | sed -n '1p;4p' | tr '\n' '|'); r=$(HYPER_TRACE=1 HYPER_SCHEDULE=right ./hyper run t/meet.hyper cross | sed -n '1p;4p' | tr '\n' '|')
lv=${l%%|*}; rv=${r%%|*}; lt=${l#*|}; rt=${r#*|}; ln=$(echo "$lt" | wc -w); rn=$(echo "$rt" | wc -w)
if [ "$lv" = "26" ] && [ "$lv" = "$rv" ] && [ "$ln" -eq "$rn" ] && [ "$lt" != "$rt" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL crossing: [$l] [$r]"; fi
# the joint state (theorems/logic/Jiva_…), computed: the product joint is independent; the diagonal joint has empty fibres at
# (True,False) and (False,True); the joint over Unit×Unit has a two-point fibre; the living step refuses along the visible
# side and descends along the hidden one; the dead step descends on both
got=$(./hyper joint t/jiva.hyper product left right | tail -1); [ "$got" = "स्वातन्त्र्यम्: the comparison is an equivalence" ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "FAIL joint product: $got"; }
got=$(./hyper joint t/jiva.hyper bools id id | tr '\n' '|')
[ "$got" = "(#True{}, #True{}): सकलादेश #True{}|(#True{}, #False{}): रिक्तम्|(#False{}, #True{}): रिक्तम्|(#False{}, #False{}): सकलादेश #False{}|entangled: the comparison is not an equivalence|" ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "FAIL joint diagonal: $got"; }
got=$(./hyper joint t/jiva.hyper bools unit unit | head -1); [ "$got" = "(#Tt{}, #Tt{}): बहु #True{} #False{}" ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "FAIL joint hidden: $got"; }
got=$(./hyper descends t/jiva.hyper cnot left product | cut -d: -f1); [ "$got" = "जीवति" ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "FAIL living step: $got"; }
got=$(./hyper descends t/jiva.hyper cnot right product | cut -d: -f1); [ "$got" = "अवतरणम्" ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "FAIL cnot right: $got"; }
got=$(./hyper descends t/jiva.hyper dead left product | cut -d: -f1)$(./hyper descends t/jiva.hyper dead right product | cut -d: -f1); [ "$got" = "अवतरणम्अवतरणम्" ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "FAIL dead step: $got"; }
# §0.3 step 1: a declaration with a type and no body is a coordinate; a match asks it and it becomes the superposition of
# the match's constructors, correlated across every holder (one label on both sides of pair), split only as far as asked
got=$(./hyper run t/coord.hyper pick | head -1); case "$got" in '&'*'{2,1}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL coord pick: $got";; esac
got=$(./hyper run t/coord.hyper pair | head -1); l1=$(echo "$got" | sed -n 's/^#Pair{&\([0-9]*\){2,1},&\([0-9]*\){#False{},#True{}}}$/\1 \2/p')
if [ -n "$l1" ] && [ "${l1% *}" = "${l1#* }" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL coord pair: $got"; fi
got=$(./hyper run t/coord.hyper depth | head -1); case "$got" in '&'*'{0,&'*'{1,2}}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL coord depth: $got";; esac
# §0.3 step 2: the declaration is the program.  sort's specification, its only text, resolves B for A = [3,1,2];
# the fibre of isort over [1,2] has two points and prints as their superposition; an empty fibre prints as *.
check t/sort.hyper main '#Cons{#Suc{#Zer{}},#Cons{#Suc{#Suc{#Zer{}}},#Cons{#Suc{#Suc{#Suc{#Zer{}}}},#Nil{}}}}'
got=$(./hyper run t/sort.hyper perms | head -1); case "$got" in '&'*'{#Cons{#Suc{#Zer{}},#Cons{#Suc{#Suc{#Zer{}}},#Nil{}}},#Cons{#Suc{#Suc{#Zer{}}},#Cons{#Suc{#Zer{}},#Nil{}}}}') pass=$((pass+1));; *) fail=$((fail+1)); echo "FAIL sort perms: $got";; esac
check t/sort.hyper none '*'
check t/sort.hyper head '#Suc{#Zer{}}'
# every identifier MAP.md names is on the line it cites
if ./cite.sh >/dev/null; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL cite: $(./cite.sh | tail -3 | tr '\n' ' ')"; fi
echo "pass=$pass fail=$fail"; [ $fail -eq 0 ]
