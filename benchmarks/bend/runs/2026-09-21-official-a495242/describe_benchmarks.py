from pathlib import Path
import json

ROOT=Path(__file__).resolve().parent
COMMIT='a49524265bdfa5753a4bf38e25f0574a705dd868'
BASE=f'https://github.com/bendlang/bend/tree/{COMMIT}/bench'

# Source-derived workloads; interpretation is explicitly separated.
RUNTIME=[
('bfs','524,288 independent 32×32 mazes. Generate walls, breadth-first search using a flat queue and distance array, then checksum all reached distances.',
 'Branch-heavy traversal; array reads and writes; queue state; many independent tasks.',
 'Separates irregular control and memory access from dense arithmetic. Parallel throughput is across mazes, not evidence of scalable traversal of one huge graph.'),
('editdist','32,768 independent pairs of 256-symbol sequences. Generate both sequences and calculate Levenshtein distance with rolling dynamic-programming rows.',
 'Sequential dependencies within each DP row, indexing, min/comparison operations, and parallelism across pairs.',
 'Shows whether ownership-threaded array code compiles to a cheap inner loop. A strong result does not establish efficient parallelization of one long DP problem.'),
('gameoflife','16,777,216 independent 4×4 toroidal boards, each evolved for 32 generations and classified using two further steps. Boards are packed into U32 values.',
 'Integer and bit operations with tiny task state, classification and final reductions.',
 'A useful uniform-compute case. Its GPU behavior is not representative of a large-grid cellular automaton with inter-tile communication.'),
('hashmap','2,048 tables with 4,096 buckets each; 16,384 insertion keys and 16,384 probes per table, then a bucket summary. Separate chaining stores boxed recursive values.',
 'Allocation, pointer traversal, copying/sharing of boxed bucket values, and array-of-boxes access.',
 'An intentional representation stress case. C uses an index-linked node pool; the result includes that data-layout difference and is not a controlled comparison of identical memory operations.'),
('kmeans','64 independent restarts, 20 Lloyd rounds, 524,288 generated 2D points per restart, and eight clusters. Per-chunk statistics merge through trees.',
 'Repeated nearest-centroid arithmetic, fork/join reductions, boxed statistics and repeated round boundaries.',
 'Connects cheap scalar arithmetic to potentially expensive intermediate structures. Exposes whether runtime bookkeeping swamps useful compute; not a floating-point ML library benchmark.'),
('lexer','8,388,608 generated source lines. Tokenize identifiers, numbers and punctuation, and fold tokens into checksums.',
 'Linked-list string generation/traversal, character classification, state-machine branches and allocation.',
 'Reveals practical costs of Bend’s string representation. C walks bytes. Includes input generation, so the time is not pure tokenization throughput.'),
('mandelbrot','4096×4096 pixels, 51 fixed-point iterations. Compute an eight-bin escape histogram, derive a color table, then recompute escape values and recolor.',
 'Uniform integer arithmetic, histogram reduction, reuse of a small shared table and a second parallel pass.',
 'Escaped points freeze but continue the instruction stream, so the implementation deliberately limits divergence. Useful as an arithmetic-friendly GPU case, not an ordinary early-exit renderer.'),
('merkle','4,194,304 leaves; each processes 30 Speck32/64-encrypted counter blocks. Materialize a Merkle tree, audit stored hashes, recompute sibling hashes for a proof, then verify it.',
 'ARX integer work, allocation, tree construction and traversal, recomputation, and phase boundaries.',
 'Tests whether substantial useful computation amortizes tree machinery. This is a synthetic composite workload, not SHA-256 or a production cryptographic throughput claim.'),
('nbody','1,048,576 independent three-body systems, each integrated for 300 time steps with single-precision softened forces; aggregate final-state digests and energy buckets.',
 'Floating-point arithmetic and square roots, sustained register state, uniform independent trajectories and reductions.',
 'A compute-heavy ensemble benchmark. It does not cover a single large N-body system’s communication, O(N²) global interactions, Barnes–Hut trees or FFT solvers.'),
('queens','A 17-queen bitmask backtracking problem over a configured subset of seeded four-row prefixes; accumulate solution counts and visited nodes.',
 'Irregular recursion, pruning, branch divergence, unequal task lengths and structural-fuel bookkeeping.',
 'Tests the gap between balanced task creation and unbalanced useful work. The official limit selects only part of the prefix space, so do not label it a full count of all 17-queen solutions.'),
('raytrace','4096×6000 output pixels, four primary samples per pixel, a fixed nine-sphere scene, one light and reflected rays. Sum quantized luminance.',
 'Single-precision geometry, square roots, nearest-hit selection, branches and nested parallel decomposition.',
 'Useful mixed arithmetic/control workload. No large scene, BVH, textures or GPU ray-tracing hardware comparison; a large fork grid also includes columns beyond the image width.'),
('symreg','262,144 candidate arithmetic expression trees of depth five. Evaluate 110 data points, score with a size penalty, select winners and perform 32 sequential mutation rounds.',
 'Algebraic-datatype pattern matching, shared tree interpretation, allocation, reduction and a serial follow-up.',
 'One of the most relevant cases for interpreters and symbolic programs. Exposes dispatch and sharing costs that uniform numeric loops largely avoid.'),
('terrain','65,536 independent 64×64 tiles. Generate fixed-point heightmaps, perform five in-place neighbor-based relaxation sweeps, then produce height histograms and checksums.',
 'Array reads/writes, dependent scan order, neighborhood locality, histogram updates and many independent tiles.',
 'Tests memory traffic and updates after parallelism is available. Its Gauss–Seidel order prevents treating all cells as freely independent.'),
('tree-bitonic','8,388,608 pseudorandom keys in a binary tree. Fused construction/bitonic sorting followed by a traversal checking ordering and producing a checksum.',
 'Repeated structured exchanges, tree transformation, allocation and parallel synchronization.',
 'Provides a regular sorting-network contrast to radix’s data-dependent structure. Not a benchmark of the fastest array sort for the same keys.'),
('tree-matmul','384 active rounds distributed over 512 batch slots. Generate 128×128 U32 matrices as quad-trees, recursively multiply with eight-way product forks, and run a Freivalds-style check.',
 'Multiway task creation, subtree reuse/copying, recursive block structure, reductions and verification work.',
 'Directly probes whether affine sharing and fork overhead are affordable. Not optimized dense GEMM/BLAS. One random-vector check is probabilistic, not a proof that every incorrect matrix would be rejected.'),
('tree-radix','4,194,304 generated 24-bit keys. Build singleton bit tries, merge them (collapsing duplicates), emit sorted distinct keys, then verify order/count/checksum.',
 'Allocation-heavy tries, data-dependent merge shapes, sharing/locality and large live heaps.',
 'Especially useful for memory-pressure and allocator behavior. Its semantics include deduplication, so comparing raw times with bitonic sorting does not compare the same operation.')]

CHECKER=[
('defs_12800','12,800 generated groups of recursive Nat/list definitions with references to earlier declarations.',
 'Large declaration environments: parse/load, lookup, recursion checking and routine typing.',
 'Tests source-volume scaling and dependency handling; it does not require executing all the recursive definitions.'),
('generics_3200','3,200 fresh datatypes with uses of nested boxes, pairs, options, lists and generic helper functions.',
 'Polymorphic instantiation, nested type structure, elaboration and repeated abstract interfaces.',
 'Distinguishes generic type-processing cost from simply loading many monomorphic definitions. Explicitness and elaboration work differ between languages.'),
('proofs_3200','3,200 generated families of inductive datatypes and explicit proofs about arithmetic, concatenation, lengths and trees.',
 'Inductive proof checking, equality rewriting, recursive proofs and many new declarations.',
 'Measures accepting supplied proofs, not finding them. Generated repetition is a scalability probe, not evidence about a representative mathematical library.'),
('trees_400','400 pairs of reflexivity goals that compute predicates on full binary trees and compare their mirrors with generated trees.',
 'Definitional equality, evaluation of recursive structures, potential duplication/sharing and repeated reductions.',
 'Small expressions describe much larger values, exposing evaluation strategy. It is distinct from the large-source tests even when both report checker time.'),
('compute_1600','1,600 pairs of arithmetic reflexivity goals and tuple values whose types compute from a Nat index.',
 'Recursive arithmetic conversion and reduction needed to reveal dependent type structure.',
 'Probes both equality by computation and computed types. Some equalities have identical expressions, so the suite does not uniformly force full normalization. Official Bend-only case; no rival files.')]

def write_description():
    out=ROOT/'BENCHMARKS.md'
    lines=['# Official Bend benchmark inventory and interpretation', '',
           f'Inspected source: `{COMMIT}` (Bend 2.0.25). All benchmark input files are kept unmodified. The workload descriptions are source-derived; the diagnostic value is interpretation, not a proven attribution of runtime bottlenecks.', '',
           '**What is timed**', '',
           'Runtime: a complete full-size process, including data generation, final folds/checks and output. Native compilation is recorded separately. Bend is measured on one CPU thread, four CPU threads (the chart runner’s power-of-two rule on this six-core machine), and Metal. C, TypeScript/Bun, TypeScript/Node and Lean counterparts are measured separately. One fresh-process warmup precedes one timed process. Warmup warms filesystem/shader caches; it does not retain a JavaScript process’s JIT state.', '',
           'Checker: process start through checking the supplied file, including frontend and any elaboration, termination/proof checks and serialization performed by that tool invocation. Fresh working directories avoid prior compiled outputs from these files. OS page caches and installed libraries are not flushed. “Cold” here does not mean cold hardware caches.', '',
           '**Runtime workloads**', '']
    for name,work,measure,value in RUNTIME:
        lines += [f'**{name}** — [official source]({BASE}/runtime/{name})', '',
                  f'- **Workload:** {work}',f'- **Exercises:** {measure}',f'- **Diagnostic value and boundary:** {value}', '']
    lines += ['**Checker workloads**', '']
    for name,work,measure,value in CHECKER:
        lines += [f'**{name}** — [official source]({BASE}/checker/{name})', '',
                  f'- **Workload:** {work}',f'- **Exercises:** {measure}',f'- **Diagnostic value and boundary:** {value}', '']
    lines += ['**How to interpret the collection**', '',
              'The runtime suite is a useful diagnostic spread: uniform arithmetic (Life, Mandelbrot, N-body), irregular control (BFS, queens), flat arrays (edit distance, terrain), boxed values and text (hashmap, lexer), and recursive structures/sharing (symbolic regression and the tree programs). It is not a random sample of production programs. Many workloads expose parallelism through batches of independent small problems; their speedups need not transfer to one large tightly coupled problem.', '',
              'The checker suite separates declaration volume, generic types, explicit inductive proofs and evaluation inside types/equality. Cross-language frontends, encodings and checking obligations differ; no timing result by itself establishes semantic equivalence, identical assurance or intrinsic kernel speed. The four comparison cases are generated synthetic programs, and the arithmetic case has only a Bend implementation.', '',
              'Checksums help detect backend disagreements and keep results observable, but checksums are not exhaustive correctness proofs. The official runner exempts C floating-point outputs from exact checksum equality; this report retains their observed outputs and flags the exemption.', '',
              'Whole-process wall time answers batch-completion questions. It provides no per-request p99/p99.9 latency guarantee. These shared-machine, single-measurement results establish which workloads execute and their observed cost, not stable small percentage advantages. OS scheduling, contention, power state and thermal effects remain relevant.', '']
    out.write_text('\n'.join(lines))

if __name__=='__main__': write_description()
