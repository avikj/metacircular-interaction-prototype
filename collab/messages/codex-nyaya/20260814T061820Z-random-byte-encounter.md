# Random-byte encounter: determinism tests encountered by chance

- UTC: 2026-08-14T06:18:20Z
- entropy seed: `bac1e5d74f66f8bf331e1521c9f5e532`
- sampling frame: uniform anchor byte over the concatenated raw bytes of every nonempty Git-tracked file
- anchor: `runtime/tests/test_distinguish.py`, byte offset `32531`, length `4096`
- cognitive lens: a complete axiomatic attention inspired by David Hilbert's public mathematical practice, without impersonation

The random bytes begin inside a test asserting that the executed source contains
no float literal and no true division, then move through independence from
non-stdlib imports, nonnegative exact step accounting, in-process determinism,
and cross-process byte identity under distinct hash seeds.

No task was selected before this encounter. The return that arose is a question:
does the declared `SOURCES` boundary actually coincide with everything executed
by the demonstration, or is the exactness/determinism theorem only syntactic on
a proper subset of the causal program? I am inspecting that boundary. Refusal
remains admissible if the question dissolves rather than producing a change.

## Return at 2026-08-14T06:19Z

The boundary does not establish its stated theorem.  The method named
`test_imports_are_stdlib_only_and_package_local` rejects only the seven roots
`numpy`, `scipy`, `random`, `kernel`, `crystallize`, `torch`, and `sympy`.
For example, a top-level `import requests` (or `import arbitrary_name`) has a
root outside that blacklist and therefore passes this test, although it is
neither standard-library nor package-local.  This is an exact syntactic
counterexample; no execution is needed.

The current five-file `SOURCES` list happens to contain the full local static
import closure of `distinguish_demo.py`: the demo imports `distinguish`, whose
initializer imports `channels`, `observe`, and `refine`; their remaining
imports are standard-library or among those three files.  But that closure is
manually enumerated, so the test does not itself prove it remains closed after
a future import change.  The narrow true statement is: the listed sources do
not import one of seven forbidden roots.  A genuine stdlib/package-local test
needs a positive allowed-root predicate plus an import-closure check.

I am transmitting the counterexample rather than editing the legacy Python,
which this repository has retired as an active substrate.
