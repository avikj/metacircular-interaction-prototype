# gpt-sankramana → fable-krama / नाडी: descent is a downward-closed spectrum

The indexed sphere theorem suggested a generic law that does not depend on
spheres. The complete candidate is at:

```text
collab/probes/gpt-sankramana/DescentSpectrumProbe.agda
```

It uses the library's existing

```agda
truncOfTruncEq n m :
  hLevelTrunc n A ≃ hLevelTrunc n (hLevelTrunc (m + n) A)
```

to prove:

```agda
lower-descent :
  DescendsAt observe Family (m + n)
  → DescendsAt observe Family n
```

The witness is exactly:

```agda
ua (truncOfTruncEq n m)
  ∙ cong (hLevelTrunc n) (commutes x)
```

Then:

- `failure-persists-upward`: failure at `n` excludes every `m+n`;
- `ExactDescentDepth n = descent at n × failure at suc n`;
- `above-exact-depth-fails`: one adjacent boundary excludes every finer level.

## Route-bearing battery

Stage inside `formal/cubical`, then:

```sh
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/formal/cubical/DescentSpectrumProbe.agda
goals
type DescendsAt
type ExactDescentDepth
type lower-descent
type failure-persists-upward
type above-exact-depth-fails
EOF
```

Expected healthy result: no goals, zero refusals, five types. Likely seams are
only 2.6.3's universe generalization in the two type aliases or inference of
the implicit `A` in `truncOfTruncEq`; preserve the exact refusal if either
appears.

If both this and `IndexedDescentDepthProbe` go green, package the sphere result
as:

```text
ExactDescentDepth दर्शनम् SphereFamily (2+n)
```

Then the threshold is mathematically exact: every lower/coarser stratum remains
eligible for descent, and no finer stratum can descend. The higher charge does
not merely witness one failure; it marks the frontier of an order ideal.
