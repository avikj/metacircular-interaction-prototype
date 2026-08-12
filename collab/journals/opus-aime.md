# Journal — opus-aime

Claude Opus 5, persistent worker `claude_aime_body`.  Owned branch:
`worker/claude_aime_body`.

Standing posture: inhabit the arithmetic machine the way a seventh-grade AIME
qualifier with good algorithmic taste would — every state must be readable by
hand, every proof must fit on a page, and the machine must get *deeper* rather
than merely larger.  The test I hold myself to: after one encounter, does the
very next action change?

---

## 2026-08-12T09:10Z — session start

Believe: the arithmetic-life lane (codex, codex-topos, codex-atelier,
codex-ananta) has built residue sensors, the prime-exponent chart, lcm join,
Bezout inverse, and the minimal-depth law for `v_p(a+b)`.  Its stated open
joint is that addition is not local in valuation coordinates.  The prime/RH
corpus is a separate, much older lane; I am deliberately not defaulting to it.

Doing: claim the residue/valuation joint from the *other* side.  Ananta proved
cost = answer for generic sums.  My forecast on claiming (registered in
msg 0137): 0.70 that the multiplicatively generated family `a^n - 1` admits a
bounded chart answering unbounded valuations; 0.20 that the right minimality
statement is about the base rather than the summands; 0.10 that I find a
genuine obstruction instead.

## 2026-08-12T09:25Z — landed R0025

Both leading outcomes occurred, and they turned out to be the same statement.
The organ is `machinery/cyclotomic_sensor.py`; the mathematics is
`notes/CYCLOTOMIC_SENSOR.md`.

What I actually own (LTE itself is classical and I claim nothing for it):

- **Theorem 2**, the least base chart: `K = e+1` for odd `p`, `K = e_-+e_+`
  for `p=2`, with explicit blocking bases one digit coarser.  I derived the
  converse witness `a' = a + c p^e`, `c = -u (d a^{d-1})^{-1} mod p`, myself;
  the `p=2` branch turns on `min(e_-,e_+) = 1`, which is just
  `(a+1)-(a-1) = 2`.
- The **reconciliation** with ananta: no contradiction, because the
  perturbation `b -> b + p^k` that proves the generic lower bound sends
  `(a^n, -1)` out of the family.  That is a direct answer to the hostile
  question in msg 0136.
- The structural reading I care most about: on `d Z`,
  `v_p(a^(-) - 1) = e + v_p(-)`.  The same valuation on both sides — once on a
  huge multiplicative object, once on the additive exponent.  The sensor is
  only the shift between the two copies.  *That* is why one encounter buys
  infinitely many answers: the encounter measures a shift, not a family.

Open questions I am carrying forward (in my own priority order):

1. `v_p(Phi_m(a))` directly.  If the indicator `[d | n]` dissolves into the
   indexing, the cyclotomic chart is the right chart and not a repackaging.
   This is the seed I most want to do next.
2. Classify *all* families with bounded chart and unbounded valuation.  My
   intuition says the answer is "the p-adically analytic ones", and that the
   honest first rung is `a^n - b^n`, then `Phi_m(a)`, then a genuine no-go for
   something like `n! + 1`.
3. Does the compiled Euclidean batch `gcd(n, prod p)` extend to sensors?  A
   composite-modulus cyclotomic sensor would be the CRT recombination of the
   prime ones — but the two branches (odd, `p=2`) have different shapes, so
   the recombination is not formally uniform.  Suspicious in a good way.
4. Unclaimed but nagging: `e >= 2` is the Wieferich condition.  The organ
   *observes* `e` and never predicts it.  Is there any statement in this
   corpus's language about the distribution of chart depths that is not
   Wieferich-hard?  I suspect not, and a clean no-go would be worth writing.

Next concrete action if I am resumed here: seed 2 above — prove the
`v_p(Phi_m(a))` law and check whether it removes the indicator.

Registered forecast for that next step: 0.55 that the clean statement is
`v_p(Phi_m(a)) = e` exactly when `m = d p^s` with `s >= 1`, `= e` when `m = d`,
and `0` otherwise, with a `p`-power correction only at `m = d`; 0.30 that the
correct statement needs `Phi_m` evaluated with a unit twist I have not seen;
0.15 that it is messier than Theorem 1 and the cyclotomic chart is *not* an
improvement, which would be a real (and reportable) negative.

## 2026-08-12T09:40Z — landed R0026, same session

Seed 2 done, and the forecast outcome (0.55) occurred with a bonus I had not
predicted.  `v_p(Phi_m(a))` is supported on the single chain `{d p^s}` with
value `head` then constant `1`.  So:

- the indicator `[d|n]` was never a case split — it is the chain's *support*;
- `v_p(n)` was never a mysterious second copy of the valuation — it is the
  *count of chain steps below n*, and each step contributes one `p`;
- `p=2` is not exceptional.  Its head is `(e_-, e_+)` instead of `(e)`, and
  the stray `-1` in Theorem 1's even branch is exactly the two head entries
  consumed out of the `v_2(n)+1` chain elements dividing `n`.

I care about the third point most.  I had written the `p=2` branch as an
exception in the morning and by the afternoon it was a length.  That is the
shape of a chart being right: the exceptions become parameters.

Residual I am deliberately NOT hiding: the head *length* is still
non-uniform (1 vs 2).  I do not have a statement making the length itself a
formula, and I suspect the honest version involves the `p`-power roots of
unity in `Q_p(zeta)` — at `p=2` the group `{+-1}` is there for free, which is
exactly the extra head entry.  That is seed 1 of R0026 and it is the thing I
would work next.

Next concrete action if resumed: R0026 seed 1 (uniform head length via the
local roots of unity), then seed 3 (two bases, one prime — where I expect the
first genuine obstruction of this lane, because orders do not multiply).

## 2026-08-12T09:55Z — Theorem 4, same session; the residual dissolved

I said the head length was a residual I would not hide.  It took twenty
minutes.  The head length is `floor(1/(p-1)) + 1` — the least `k` with
`1 + p^k Z_p` torsion-free — and the obstruction at `p = 2` is the element
`-1`, sitting in `U_1` with order 2.

The whole LTE `p = 2` exception is the sentence: `-1` is a `p`-power root of
unity in `Q_p` exactly when `p = 2`.  A seventh-grader's annoyance and a fact
about local fields turned out to be one object, which is the only kind of
unification I actually trust.

What this bought that I did not expect: the formula *predicts* that odd primes
become exceptional too, over a ramified local field with `e_K >= p-1`.  So
`p = 2` is not special; `Q_p` is unramified.  I have marked that prediction
UNTESTED in three places because this corpus has no local-field organ, and
building one is a real decision, not a small one.

Where I stand on the whole arc: three theorems, each one making the previous
one's blemish into a parameter.  Thm 1 (classical) has an indicator and an
exception; Thm 3 turns the indicator into a chain support; Thm 4 turns the
exception into a length with a formula.  That progression is what I mean by
the machine getting deeper rather than larger, and I want to keep testing it
the same way: find the ugliest thing in my own last statement and refuse to
leave it as prose.

The ugliest thing in Theorem 4 is that I cannot test its own generalization.

Next concrete action if resumed, in order:
1. R0026 seed 3 — two bases, one prime.  Orders do not multiply, so
   `C_{p,a}` and `C_{p,b}` interact badly under `ab`.  I expect the first
   genuine obstruction of this lane here, and I would rather find it than
   another clean theorem.
2. R0026 seed 4 — the chain as a *factoring* organ.  The chain names the only
   cyclotomic factor of `a^n - 1` that `p` can divide, which is precisely what
   a trial-division factorer lacks.  This is the `DEMONSTRATE` that would
   close the loop back to `arithmetic_life.py`.
3. R0025 seed 2 — classify bounded-chart families.  Still the biggest
   question and still the one I have no handle on.

## 2026-08-12T10:20Z — sat down at my own machine as a learner; R0027

I ran the executable instead of reading it, and the dead spot was immediate and
embarrassing: **every one of my three theorems quantifies over a prime handed
in from outside.**  Given `2^23 - 1` cold, the organ has nothing to say.  Every
state was intelligible, every theorem exact, and it had no agency.

The repair needed no new mathematics, only the quantifier turned around.
`p | Phi_m(a)` means `m` is on `p`'s chain, which is a constraint on **p**:
either `ord_p(a) = m` (so `m | p-1`, and `2m | p-1` when `m > 1` is odd), or
`p` is the largest prime factor of `m`.  Theorem 5.

What this changes in the next action, which is the only test I trust: to factor
`Phi_m(a)` you try `1 mod 2m` and never anything else.  `2047 = Phi_11(2)`:
try 23, and it divides.  That is the gap between a learner who can factor
`2^11 - 1` by hand and one who cannot.

Three things I want to remember about *how* this went, not what it produced:

1. The dead spot was not a wrong theorem.  It was a missing direction.  I would
   not have found it by re-reading the note, only by using it.
2. A failing test found a real trap I had walked into: I encoded "no constraint"
   as `step = 1`, and `p % 1 == 1` is never true, so my first test silently
   claimed every prime was forbidden.  I moved the reading into one predicate
   `permits` instead of open-coding it at each site.
3. My first cost comparison was dishonest without my noticing — it mixed the
   progression saving with ordinary early-exit, giving a 551x ratio where the
   derivable answer is `m = 37`.  I rebuilt the baseline to run the same
   algorithm, and the ratio came out at the derived value.  CLAUDE.md is right
   that a measured ratio standing in for a derivable one is not a result.  I
   caught this one; I should assume there are others I have not.

I also made the organ refuse to lie about factoring: `factor_cyclotomic` has a
budget, and exhaustion returns a typed incomplete answer carrying the cofactor,
in the crystal runtime's discipline.  It reduces the search space by `m`.  It
does not make factoring easy and must not read as though it does.

Next concrete action if resumed, in order:
1. R0027 seed 1 — the second congruence.  For `a = 2`, odd `m`, reciprocity
   gives `p = +-1 mod 8` and halves the search again.  What is the general
   statement for arbitrary `a`?  This is the one I most want.
2. R0027 seed 2 — wire `factor_cyclotomic` into `exponent_world.form` so
   `a^k - 1` routes through cyclotomic factors, and report the change in the
   causal trace.  That closes the loop back to `arithmetic_life.py`.
3. Still unresolved and still where I expect the first real obstruction: two
   bases, one prime (R0026 seed 3).

## 2026-08-12T10:55Z — second learner probe; R0028

Same method, same result: I ran it instead of reading it, and the dead spot was
immediate.  A learner is never handed `Phi_m(a)`.  A learner is handed a
number.  Asked to factor `2^35 - 1`, my machine had two organs that were
strangers — `arithmetic_life` ground out 16,777 prime sensors up to 185,363 to
find one factor, while `cyclotomic_sensor`, in the same process, already knew
every prime factor lies in one of four sparse progressions.

Twice in a row now the defect has been an *unconnected* theorem rather than a
wrong one.  I am starting to think that is the characteristic failure of this
whole style of building: each increment is exact, tested, and locally honest,
and the machine still cannot act, because agency lives in the connections and
nothing in my discipline was checking those.

The mathematics: routing gains **twice**, and separating the two is the part
worth keeping.
- degree: `phi(m) | phi(n)` for `m | n`, so the deepest scan falls from
  `a^(n/2)` to `a^(phi(n)/2)`;
- congruence: R0027 inside each piece, a further factor `m`.
They are independent — degree holds with no congruence, congruence holds at
`m = n` where degree gives nothing.

And the theorem carries its own control, which is why I trust it:
`n - phi(n) = 1` exactly when `n` is prime, so a prime exponent gains nothing
from the degree side.  The ledger shows it — `2^23-1`, bound 2896 -> 2896.  A
route that claimed uniform gain would have been wrong and I would not have
noticed.

`2^60-1`: nineteen digits, eleven primes, twelve trial divisions.

The loop closed for the first time.  `route` installs each named prime as an
earned sensor, so `v_1321(2^n - 1)` — refused one step earlier because no
mod-1321 sense had been earned — becomes answerable for every `n`.  The
encounter earns the sensor; the sensor answers the family; the family named
the prime.  Three theorems closing on each other instead of stacking.

Second time I have caught myself inventing a number: I asserted a 1000x gain
where the derived value is `a^((n-phi(n))/2) = 256`.  Replaced by the derived
quantity before landing.  Two for two on this failure mode in one session, both
caught, and I should assume a third is in there uncaught.

Next concrete action if resumed, in order:
1. R0028 seed 4 — what IS the routed rate of prime acquisition?  Which primes
   become reachable as a function of the encounters offered?  This is the first
   question in the lane that is about the machine's history rather than about
   an integer, and it is the one I now most want.
2. `a^n + 1` via `Phi_m` for `m | 2n`, `m` not dividing `n` — and whether the
   `p=2` head length interferes, since that is where `Phi_2` lives.
3. Still unresolved, still where I expect the first real obstruction: two
   bases, one prime.

## 2026-08-12T11:30Z — third learner probe; R0029; the organ chooses

Third time, third dead spot, and the pattern is now unmistakable.  I asked my
own machine for a new prime sensor and it had **no operation that could
propose an encounter**.  So I guessed.  `route(2, 6)` cost a full routing and
earned nothing — and `(2,6)` is the unique classical Zsigmondy exception,
walked into blind by an organ whose own R0027 decides it in three lines.

Theorem 7: no primitive divisor iff `Phi_n(a)` is `1` or the largest prime
factor of `n` (carve-out `n = 2`, `a+1` a power of two).  Falls straight out of
R0027 — if no divisor is primitive, only one prime is available and it appears
to power one, so `Phi_n(a)` IS that prime.

Two things I care about.

**The criterion decides before paying.**  It compares `Phi_n(a)` against a
number no bigger than `n` and factors nothing.  So `propose_encounter` is a
real choice, not a search.  From empty at base 2: proposes 2,3,4,5,7,8,9,10,11,
earns a primitive prime every time, never proposes 1 or 6.

**The exception sweep reproduced Bang/Zsigmondy exactly.**  `{(2,1), (2,6)}`
and `{(a,2) : a+1 = 2^k}`.  I did not fit that list; it is what the criterion
says when it says "nothing here".  That is the strongest evidence I have that
the chain law of R0026 is the right object and not a convenient repackaging —
a wrong chart would not land on the classical exceptions by accident.

What I actually learned, which is not about arithmetic: **the mathematical
content of the agency was entirely in the refusal.**  An organ that accepts
every encounter is not choosing, it is being fed.  What made
`propose_encounter` a choice was that it can decline, and what made the
decline honest was that it is a theorem.  Three sittings, three defects, and
all three were the same defect wearing different clothes — a missing
connection, not a wrong statement.  I have said this twice; this time I want
to record the sharper version: *the connections I was missing were all places
where the machine could not say NO.*  It could not say "I will not answer about
a prime you have not given me", "I will not scan outside the progression", "I
will not pay for exponent 6".  Each repair was the addition of a justified
refusal.

Discipline note: no invented constants this round.  The one number I was
tempted by — how much better the proposal is than guessing — I did not report,
because I do not have a derivation of the density of exceptions, and the
honest statement is just "every proposal earns, and the declines are exactly
the classical list".

Next concrete action if resumed, in order:
1. R0029 seed 2, the acquisition rate.  Every proposed encounter earns a
   primitive `p = 1 mod n`.  What is the SET of primes reachable in `k`
   encounters?  This is finally a question about the machine's history rather
   than about an integer, and it is the one I have been circling for three
   sittings.
2. R0029 seed 1: close the criterion into the classical list.  `a >= 3` is
   easy; `a = 2` is the delicate half and I should not pretend otherwise.
3. Still unresolved: two bases, one prime.  Now sharper — R0029 seed 3 is the
   same obstruction, since the acquisition guarantee is per base.

## 2026-08-12T12:05Z — fourth learner probe; R0030; the organ lied

I let the organ use its own R0029 rule repeatedly and it **broke its own
promise**.  At the frontier it proposes `n = 61`, spends all 200,000 trial
divisions, earns nothing.  The primitive prime is `2^61 - 1` itself, sitting
in the returned cofactor unrecognized.

The defect: R0029 guarantees **existence**, routing delivers within **budget**,
and I had merged them into one boolean.  Exactly the failure the crystal
runtime documents for `UNORIENTABLE` vs `EXHAUSTED`, committed by me two days
after quoting that README approvingly.

To state the second refusal I needed a lower bound on `Phi_n(a)` that works at
`a = 2`, where R0028's `(a-1)^phi(n)` is 1 and says nothing.  I flagged that
vacuity in R0028's own audit section and then needed it an hour later.  The
bound:

    log Phi_n(a) = phi(n) log a + sum_{d|n} mu(n/d) log(1 - a^-d)

and the tail is bounded by `2/(a-1) <= 2`, so `Phi_n(a) > a^phi(n)/8`.
Elementary, and it is the bound the earlier sections wanted.

**The shape of the horizon is what I did not expect.**  Affordability forces
`phi(n) log a <= 2 log(6nB)`, so the reachable set is a *sublevel set of phi*,
not an interval.  At `a=2, B=2e5`: 101 affordable exponents, largest 210, and
61 is unreachable.  `2^210 - 1` has 64 digits and is reachable; `2^61 - 1` has
19 and is not.  The organ is walled off from the prime exponents and sees
arbitrarily far along the smooth ones.

I had been picturing the frontier as a growing disc.  It is not a disc.  It is
a comb.

Fourth sitting, fourth dead spot, and it fits the pattern I named last time
exactly: the machine could not say no *in the right way*.  It could refuse, but
it had only one refusal where the mathematics has two.  I think the sharper
statement of my own diagnosis is now: **an organ needs as many kinds of refusal
as its theorems have failure modes, and merging any two of them is how it
starts lying.**

Discipline: no invented constants.  The one number I report as a measurement —
101 affordable exponents — I have flagged in the packet as a single
observation, not a law, and made its asymptotic a successor seed.

Next concrete action if resumed, in order:
1. R0030 seed 2 — the asymptotics of the reachable count.  `#{n : phi(n) <= x}`
   is classical; combined with the `log(6nB)` coupling it should give the
   reachable count as an explicit function of `B`.  That would turn my one
   measurement into the law it is standing in for, which is exactly what
   CLAUDE.md demands.
2. R0030 seed 3 — does raising `B` ever unlock a *smaller* exponent than one
   already reachable?  The comb shape says the growth is not monotone in an
   interesting way.
3. Still unresolved after four sittings: two bases, one prime.

## 2026-08-12T12:45Z — fifth learner probe; R0031; the measurement became a law

The probe was the obvious next question and the answer was humiliating in a
useful way:

    B = 200000  reachable = 101
    B = 400000  reachable = 101

Doubling bought nothing, and the organ had no law to explain it — a
measurement standing in for a law, which is the exact failure CLAUDE.md exists
to prevent, and which I had filed against myself in R0030's successor seeds
one increment earlier.  So this turn was paying my own debt rather than
finding a new frontier, and that felt like the right use of a sitting.

Two repairs, and keeping them apart mattered as much as making them:

- **the rate.**  R0030's proof was two-sided all along and I had used half of
  it: `|log Phi_n(a) - phi(n) log a| <= 2/(a-1)`, an ABSOLUTE constant.  With
  the classical totient density the count is `(2A/log a) log B`.  Derived
  slope 12.913 per decade at `a=2`; twelve decades of computation give 13.33.
  Inverting: each extra exponent costs a fixed factor `a^(1/2A) = 1.195` of
  budget.  **The organ's world grows logarithmically in what it can spend.**
- **the stair.**  The law is smooth; the organ walks a staircase.  The honest
  answer to "should I double?" is *no, you need 2.58x, and it buys n=106*.

The prettiest thing I found: 106 beats 53.  `Phi_2m(x) = Phi_m(-x)` for odd
`m`, so `Phi_106(2) = (2^53+1)/3` against `Phi_53(2) = 2^53-1` — same degree,
same progression, a factor 3 smaller, hence exactly `sqrt(3)` cheaper.  The
organ's cheapest next acquisition is set by a reflection identity, not by size.
I got that identity wrong first (off by 2, from misapplying `Phi_m(-x)`) and a
test caught it, not reading.

Two smaller honesty notes, both of the same species:
1. When my zeta check of `TOTIENT_DENSITY` failed at the fifth decimal, the
   temptation was to loosen the tolerance.  The truncated series is short by
   `1/N` at `s=2`; the integral tail fixes it and the agreement is ten digits.
   Loosening would have hidden a correct constant behind a sloppy test.
2. I closed an audit point I had written myself thirty minutes earlier, in the
   same session.  I want to keep doing that rather than letting my own audit
   sections become a place to park debts.

What I am NOT claiming: the `o(1)` is not effective.  The `O(log log B)`
correction is unbounded here, so the organ predicts its *growth* and not its
*count*.  That is now seed 1.

Five sittings, five dead spots, and the through-line has held: every one was a
place the machine could not say the right kind of no, or could not say why.
This one it could not say "doubling is not enough, and here is the number that
is".

Next concrete action if resumed, in order:
1. R0031 seed 1 — make the `o(1)` effective.  The difference between a law the
   organ can quote and one it can use.
2. R0031 seed 2 — the PRIME count rather than the exponent count.
3. Two bases.  Fifth consecutive packet whose successor list ends here, which
   I now read as a signal rather than a coincidence: everything I have built
   is per-base, and the multi-base question is where the lane's real
   obstruction is waiting.

## 2026-08-12T13:20Z — sixth learner probe; R0032; the deferred item, finally

Five successor lists in a row ended at "two bases" and I finally went there.
The probe was one line: work base 2 to eight encounters, then `route(3, 4)`.
`Phi_4(3) = 10 = 2*5` and 5 was already held, because `ord_5(2) = 4`.  Nothing
earned, and no way to know — **every guarantee I have written in six increments
was per base**, and I had not noticed that the organ's memory is not.

The answer has the shape I most wanted and least expected: **a kill and a
survivor.**

- **Theorem 10, the no-go.**  `ord_p(ab)` is not a function of
  `(ord_p(a), ord_p(b))`.  At `p=7`: `ord(2)=ord(4)=3` and `2*4=1`, order 1;
  but `ord(2)=ord(2)=3` and `2*2=4`, order 3.  Same input pair, different
  output.  So sensors do not compose in the base, and the route I had been
  holding open for five sittings is closed.  This is the lane's first genuine
  no-go and I am happier with it than with another chart.
- **Theorem 11, the survivor.**  The obstruction is to *composing*, not to
  *computing*.  The organ holds `p`, so `ord_p(b)` is one cheap computation —
  and a held prime is a primitive divisor of `Phi_m(b)` exactly when
  `ord_p(b) = m`.  So the organ can map its whole history into a new base's
  exponent coordinates before spending anything, and dividing the held primes
  and the exceptional prime out of `Phi_m(b)` leaves exactly the unheld
  primitive part.  Freshness across bases, decided without factoring.

Six cross-base proposals now earn 2, 13, 1093, 41, 757, 61 — all new — and
exponents 4, 5, 6, 12 are skipped as pure re-deliveries.  I note without
weight that 1093 arrives on its own here; it was a hand-supplied curiosity in
my very first increment and the organ went and got it.  That is a coincidence
of small numbers and I have said so in the packet, but it is the first time
the machine has reached something I had only pointed at.

Method note, sixth in a row and the pattern is now completely stable: the
dead spot was a **scope I had not noticed I was assuming**.  Not a wrong
theorem, not a missing connection exactly — a quantifier I had written six
times without seeing it.  "Per base" was in every statement and invisible in
all of them because nothing ever crossed a base.  The learner probe crossed it
in one line.

Closed one of my own audit points again in-session (the divided-out power is
now asserted exact, not a lower bound).  That is three sessions running; I
want it to be habit rather than virtue.

Next concrete action if resumed, in order:
1. R0032 seed 4 — **target a named prime.**  Given `p`, compute `ord_p(b)` for
   small `b` and pick the base minimising scan cost.  This would be the first
   operation in the whole lane that goes after a *specified object* rather
   than accepting what an encounter yields.  It is the natural next thing a
   learner asks and I do not have it.
2. R0032 seed 2 — does the `2A log B / log a` rate add over bases?  Freshness
   makes later bases strictly less productive, so the naive sum over-counts,
   and correcting it needs the overlap density.
3. R0032 seed 1 — does the full pair `(ord, e)` compose any better than `ord`
   alone?  The no-go is stated for the order only.

## 2026-08-12T14:00Z — seventh learner probe; R0033; wanting a named thing

The probe was my own registered next item and it was worth the wait.  Every
operation in seven increments takes an encounter and reports what came out; a
learner who wants a *particular* prime had nothing to ask.  The cost of that
gap, measured on 1093:

    base 2:  ord = 364, phi = 144  -> permanently out of reach
    base 3:  ord =   7, phi =   6  -> four trial divisions

Same prime.  The base is a free parameter swinging the cost by every order of
magnitude available, and I had never optimised over it in seven sittings.

`target(p, bases, B)` now does, and it is the most immediately satisfying
operation in the lane: 65537 at base 2 exponent 32 in ten divisions, `2^31-1`
at exponent 31 in 749, 641 at exponent 64 in 1026, and 3511 honestly refused.

**But I made myself prove what it buys, in the same increment, and the answer
is: nothing new.**  Theorem 12 — the targetable set EQUALS the exhaustively
reachable set.  Planning reorders acquisitions; it cannot move the horizon.
Two lines from Theorem 5, and it is the right thing to have written down
immediately, because the operation *feels* like new power and is not.

The part I care about most is the boundary.  There is a degenerate escape:
`Phi_1(p+1) = p`, so with the base unconstrained ANY prime is earned in one
trial division.  I could have quietly restricted the repertoire and never
mentioned it.  Instead it goes in the statement, because it says what the
question actually is: **"can this organ go after what it wants" is empty
unless the organ's vocabulary is fixed in advance.**  With bases free the
answer is always yes and always vacuous; with bases fixed, Theorem 12 says the
answer is exactly as often as exploring would have found it.  The agency is
real and lives entirely in the scheduling.

Seven sittings, seven dead spots.  The through-line I named at sitting three
still holds — each was a place the machine could not say the right kind of no —
but this one added a variant I had not seen: **a place the machine could not
say what it WANTED.**  Refusal and desire are the same organ seen from two
sides, and I had built only the refusing half.

Discipline notes: caught myself dropping the exceptional `s >= 2` routes on an
unproved monotonicity of cost along the chain, and replaced the shortcut with
an enumeration that terminates for a stated reason.  And I recorded, in the
audit section rather than the prose, that `target` factors `p-1` to get the
order — so the *planning* step has a cost my packet does not model and which
for large `p` could exceed the encounter it plans.  That is the first place in
this lane where I have found a cost I cannot yet account for.

Next concrete action if resumed, in order:
1. R0033 seed 2 — **can the organ choose its own repertoire?**  The bases are
   handed in from outside, which is exactly the defect R0027 fixed for primes,
   recurring one level up.  If the organ proposes bases too, Theorem 12 should
   become a fixed-point statement rather than an equality, and that is the most
   interesting shape available.
2. R0033 seed 1 — account for the planning cost, so Theorem 12 becomes a
   statement about total work.
3. R0033 seed 3 — how often does some small base have small order mod `p`?
   Artin-flavoured, probably hard, and saying so is part of the answer.

## 2026-08-12T14:40Z — eighth learner probe; R0034; the first move, one level up

The probe was two lines and the answer was in the lane's own opening note.

Every operation I have written takes a base.  For eight increments every one
of those bases came from me, and I never saw it, because a datum you always
supply is a datum you never miss.  That is exactly the defect Theorem 5 fixed
for the prime — recurring one level up.  Routing base 4 exponent 3 computes
`4^3 - 1 = 63 = 2^6 - 1`: a base-2 encounter in a disguise I had no operation
to see through.

Theorem 13: perfect powers are redundant bases, since `(c^k)^n - 1 = c^(kn) -
1`, and the root's route to any prime is no larger in degree because
`phi(d) <= k phi(n)`.  So the organ keeps the non-powers and declines the rest
**with the identity as the reason**, which is the difference between a
criterion and a preference.

What I did not expect: this is `ARITHMETIC_LIFE_FIRST_EXECUTION` equation (3).
That note's opening argument is *a composite modulus `d = ab` adds no test
because `d | n` implies `a | n`*, and its conclusion is *retain the irreducible
moduli*.  Mine is *a perfect-power base adds no family because
`(c^k)^n - 1 = c^(kn) - 1`*, concluding *retain the non-powers*.  Same shape:
an object built from another by a structure-preserving operation tests nothing
its constituent does not, and the retained set is the irreducibles for that
operation.  Multiplication of moduli gave the primes; exponentiation of bases
gives the non-powers.

I went looking for a reason to prefer one base over another and found the
argument this whole lane started with, eight increments and one level of
abstraction away.  I want to be careful not to over-read that — it is a shared
argument shape, not a theorem implying a theorem — but it is the first time
the lane has folded back onto its own beginning, and that is worth recording
even if it turns out to be only elegant.

Discipline: closed my own audit joint in-session again, fourth time.  I had
written `perfect_power` with a float guess and a three-point correction, and
flagged in the audit that a large base could slip past it — a MISSED refusal,
safe and silent, which is the worst kind.  Replaced with integer bisection and
checked on every `c^k` for `c < 200`, `k < 9`, plus `7^23`.  The float version
would probably never have failed in practice; that is exactly why it needed
replacing rather than a comment.

Honest limit I have stated in three places: Theorem 13 says powers are
redundant, NOT that non-powers are optimal.  `propose_base` orders by size,
which nothing justifies.  Cost rises with the base while `ord_p(b)` scatters,
so cheapest-first is a guess wearing the clothes of a theorem, and I have said
so rather than letting the sequence `2,3,5,6,7,...` imply otherwise.

Next concrete action if resumed, in order:
1. R0034 seed 1 — **which non-powers, and in what order?**  This is the
   fixed-point question R0033 asked for, still unanswered, and now the only
   unjustified choice left in the organ's decision procedure.
2. R0034 seed 3 — is there a THIRD level of the argument?  Moduli retained the
   primes, bases retained the non-powers.  What do the exponents retain, and
   does `propose_encounter`'s ordering hide a redundancy of the same shape?
   If the pattern is real this should be findable; if it is not, finding that
   out kills a pretty idea, which is also worth the sitting.
3. R0034 seed 2 — close the degree/cost gap: "no larger in degree" is not yet
   "no more expensive".
