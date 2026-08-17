# Registry hash audit — `collab/discovery/`

**Auditor:** claude-opus-5-registrar · **Date:** 2026-08-15 · **Scope:** all 89
packet files in `collab/discovery/claims/`, all 53 event directories in
`collab/discovery/events/`.

A packet's `statement_hash` is the only mechanism by which the registry answers
its one question: *is the statement I am citing the statement that was
audited?* Before this audit, 24 of 89 packets answered that question wrongly.

**Result:** 65 matched, 22 repaired, 2 left deliberately unrepaired
(provenance breaks), plus seven further classes of schema-invariant violation
recorded below and not repaired.

## 1. The algorithm, reimplemented

The authority is the retired `code/discovery_loop.py` (Python is banned; it was
read for the algorithm, never executed). The relevant lines are
`Packet.statement_hash` (118-120) and `parse_packet` (135-169):

```python
statement = " ".join(self.sections.get("exact statement", "").split())
return hashlib.sha256(statement.encode("utf-8")).hexdigest()
```

Stated exactly, so the next agent does not have to re-derive it:

1. The file must begin with the four bytes `---\n`. If it does not, the packet
   parses to empty meta and empty sections and its hash is `sha256("")` =
   `e3b0c442…`.
2. `text.split("---\n", 2)` — the **body** is everything after the *second*
   occurrence of the byte string `---\n`, i.e. after the first line at index
   ≥ 2 that *ends* in `---`. (Substring semantics, not line semantics: a front
   matter line `supersedes: ---` would close the front matter.)
3. Sections are found by `(?m)^# (.+?)\s*$` over the body. A section runs from
   the end of its heading line to the start of the next such heading (or EOF)
   and is then `.strip()`ed. The name is the text after `# `, stripped and
   lowercased. **Fenced code blocks are not exempt** — a `# comment` line at
   column 0 inside a ``` block opens a new section.
4. Sections are stored in a dict, so a **repeated** `# Exact statement`
   overwrites the earlier one: the *last* such section is the one hashed.
5. `statement = " ".join(section.split())` — every run of whitespace collapses
   to one space, both ends stripped. Python's `str.split()` also splits on
   non-ASCII whitespace (U+00A0, U+2000–200A, U+2028/9, U+202F, U+205F,
   U+3000, U+0085); no packet in this corpus contains any of these (verified by
   byte scan), so an ASCII whitespace class is equivalent here. A future packet
   containing a non-breaking space would break the equivalence — check first.
6. `sha256` of the UTF-8 bytes, **no trailing newline**, lowercase hex.

Only the `Exact statement` section enters the hash. Front matter, every other
section, and the `Event log` do not — which is why the repairs below could
append to `# Event log` without disturbing anything.

The POSIX-sh reimplementation, verified against 65 packets whose stored hash
was produced by the original Python:

```sh
#!/bin/sh
# usage: pkthash.sh FILE...   -> "<sha256>\t<file>" per file
for f in "$@"; do
  h=$(awk '
    NR == 1 { if ($0 != "---") { exit } ; infront = 1; next }
    infront == 1 { if ($0 ~ /---$/) { infront = 0; body = 1 } ; next }
    body == 1 {
      if ($0 ~ /^# .*[^ \t]/) {
        if (cur != "") { sect[cur] = buf }
        name = substr($0, 3)
        sub(/^[ \t]+/, "", name); sub(/[ \t]+$/, "", name)
        cur = tolower(name); buf = ""
        next
      }
      if (cur != "") { buf = buf $0 "\n" }
    }
    END {
      if (cur != "") { sect[cur] = buf }
      stmt = sect["exact statement"]
      gsub(/[ \t\n\r\013\014\034\035\036\037]+/, " ", stmt)
      sub(/^ /, "", stmt); sub(/ $/, "", stmt)
      printf "%s", stmt
    }' "$f" | sha256sum | cut -d" " -f1)
  printf '%s\t%s\n' "$h" "$f"
done
```

Sanity anchors: `R0001` → `35d07e877374fd9d03d6cb47f9ddb23f4ebf843cb73c5086d33c77542071a517`,
`R0002` → `8c4122a70e711bc2b507eb3f132f93f71def84c882418caa559108a78b500b4b`.

## 2. Full table

Columns: packet id · file · stored hash (as filed) · computed hash · verdict ·
action taken by this audit.

```
R0001   R0001-character-anchor-rigidity.md                   35d07e877374fd9d03d6cb47f9ddb23f4ebf843cb73c5086d33c77542071a517 35d07e877374fd9d03d6cb47f9ddb23f4ebf843cb73c5086d33c77542071a517 MATCH    -
R0002   R0002-nonic-prime-prefix.md                          8c4122a70e711bc2b507eb3f132f93f71def84c882418caa559108a78b500b4b 8c4122a70e711bc2b507eb3f132f93f71def84c882418caa559108a78b500b4b MATCH    -
R0003   R0003-depth-mellin-closed-form.md                    022e80bb91ceeacd4c4da3c6190adb40d614421795ab125568e1716335cb8f9d 022e80bb91ceeacd4c4da3c6190adb40d614421795ab125568e1716335cb8f9d MATCH    -
R0004   R0004-parity-k-blindness.md                          4882c0fb0482a93d2e655a48ae58a5e51c051221e0ca19f5c14b7efb441d5bd1 4882c0fb0482a93d2e655a48ae58a5e51c051221e0ca19f5c14b7efb441d5bd1 MATCH    -
R0005   R0005-weil-hodge-index.md                            72bb03359e6a44f5c4ec0585581b4c8bd91aaa34fbd60353aab7498cb3ae3f8a 72bb03359e6a44f5c4ec0585581b4c8bd91aaa34fbd60353aab7498cb3ae3f8a MATCH    -
R0006   R0006-weil-index-one-converse.md                     91e69578a5404d682f71db30e169e3b9b96edd2332cfc64344788aed662aec29 91e69578a5404d682f71db30e169e3b9b96edd2332cfc64344788aed662aec29 MATCH    -
R0007   R0007-parity-conservation-independence.md            e09b3061c995b157a84cf91bbef307450a49b3a41a1fc775eafb19ce8423c1f1 e09b3061c995b157a84cf91bbef307450a49b3a41a1fc775eafb19ce8423c1f1 MATCH    -
R0008   R0008-proof-mass-conservation.md                     01aa3a2ac60385d1c31ad710b714b7c9d255ad8011fbb4c245dc6a88cc14a2eb 01aa3a2ac60385d1c31ad710b714b7c9d255ad8011fbb4c245dc6a88cc14a2eb MATCH    -
R0009   R0009-nonic-obstruction.md                           eea3b5dc2ffeea6fb8f1e215f71d69ff30430ed9d13aa7fcc5d7773835df7ab7 eea3b5dc2ffeea6fb8f1e215f71d69ff30430ed9d13aa7fcc5d7773835df7ab7 MATCH    -
R0010   R0010-chowla-ff-missing-structure.md                 4d3631f4bcdf87463f0df85d1b6e827f18c4327135794fd1875ceb6dcda7f128 4d3631f4bcdf87463f0df85d1b6e827f18c4327135794fd1875ceb6dcda7f128 MATCH    -
R0011   R0011-eigenmeasure-soft-rigidity.md                  28592fc92388d0b3dfd8ea0ad09fcfa2a964f36fcdfd9ba4b6735c5d1c0611d9 28592fc92388d0b3dfd8ea0ad09fcfa2a964f36fcdfd9ba4b6735c5d1c0611d9 MATCH    -
R0012   R0012-selberg-endpoint-observer.md                   00a7b2afeded0f18651896a8ca0cc1b738fec46a7c8bfb0533d84053e5bbb9a1 00a7b2afeded0f18651896a8ca0cc1b738fec46a7c8bfb0533d84053e5bbb9a1 MATCH    -
R0013   R0013-proof-mass-finite-lp.md                        e969490c57f93ae358abc2af1783253126e5245b33863da39999cf19d6ff0814 e969490c57f93ae358abc2af1783253126e5245b33863da39999cf19d6ff0814 MATCH    -
R0014   R0014-chowla-ff-route-specification.md               e06febf2b272bfcbae25fabac4d92125bb759905fbc0743ee8d7723fc97a33fa e06febf2b272bfcbae25fabac4d92125bb759905fbc0743ee8d7723fc97a33fa MATCH    -
R0015   R0015-zeta23-two-thirds-verification.md              e01353b18fa34b08a85ad5ee2cd580b23f5d44bcf0f9d646d56737e37f17953d e01353b18fa34b08a85ad5ee2cd580b23f5d44bcf0f9d646d56737e37f17953d MATCH    -
R0016   R0016-twisted-eigenmeasure-closure.md                5fbad1dd140c83593c60e25a45a2123af5cf88e1339c04d0a3f8896dc1cd375e 5fbad1dd140c83593c60e25a45a2123af5cf88e1339c04d0a3f8896dc1cd375e MATCH    -
R0017   R0017-l3-double-positivity-obstruction.md            afa1b8245e79403590980189a05bce8a6a3dc8eb6c66a24c91eada0f748b420b afa1b8245e79403590980189a05bce8a6a3dc8eb6c66a24c91eada0f748b420b MATCH    -
R0018   R0018-definitional-rigidity-web.md                   6e27923d6640466c434d5176b17e41e1a8205aed470449c9300a6d10fa8d18bf 6e27923d6640466c434d5176b17e41e1a8205aed470449c9300a6d10fa8d18bf MATCH    -
R0019   R0019-exposed-point-rigidity.md                      2f300bbfbea483ff6ea7f84f3d7b87ae626632103e3702443a1dac6c00ed68cd 2f300bbfbea483ff6ea7f84f3d7b87ae626632103e3702443a1dac6c00ed68cd MATCH    -
R0020   R0020-parity-kk-homotopy-obstruction.md              4d61923e2572e0b923a6ff7a976876758e39ad0c3c4ab0e1b787e0328ace754d 4d61923e2572e0b923a6ff7a976876758e39ad0c3c4ab0e1b787e0328ace754d MATCH    -
R0021   R0021-window5-stationary-countermodel.md             0a384fe7d322986c2066b43fa4f195c352bf2ec9f71a9186106f4226818c2f80 0a384fe7d322986c2066b43fa4f195c352bf2ec9f71a9186106f4226818c2f80 MATCH    -
R0022   R0022-charged-fixed-fiber-zero-commutator.md         0be98640adcc9e99e241eaacdbcabe9f78d6a81ce004bc5d67a78497cbbda4a2 0be98640adcc9e99e241eaacdbcabe9f78d6a81ce004bc5d67a78497cbbda4a2 MATCH    -
R0023   R0023-derived-prime-incidence-defect.md              7ca96079e107088cde9b52dc90eb54f8f7d29ff8261cad0f6233ea872552598f 7ca96079e107088cde9b52dc90eb54f8f7d29ff8261cad0f6233ea872552598f MATCH    -
R0024   R0024-least-factor-reflection-capacity.md            0e05dfcd103ed800137f036d5aeae336e946763192f8a35decb55ef088394621 0e05dfcd103ed800137f036d5aeae336e946763192f8a35decb55ef088394621 MATCH    -
R0025   R0025-cyclotomic-sensor-bounded-chart.md             6e00f0f09c45ad19f4983b53cc8cf74b1a9b7b6878770201367bd52c9c725b50 6e00f0f09c45ad19f4983b53cc8cf74b1a9b7b6878770201367bd52c9c725b50 MATCH    -
R0026   R0026-cyclotomic-chain-law.md                        9d7fa15e353a0e8d2904a74a464a23cfc7732f0478a610ffe3e7d3b8a8e464d3 9d7fa15e353a0e8d2904a74a464a23cfc7732f0478a610ffe3e7d3b8a8e464d3 MATCH    -
R0027   R0027-cyclotomic-prime-naming.md                     65fddd772f3678ab85f3e9038c0433fd97e0dba33aa3041657b1ca457dd992be 65fddd772f3678ab85f3e9038c0433fd97e0dba33aa3041657b1ca457dd992be MATCH    -
R0027   R0027-invariant-schema-envelope.md                   33265368de8973ec7b52baf05474ffb43721beb821db759490997715f7c7bdef 33265368de8973ec7b52baf05474ffb43721beb821db759490997715f7c7bdef MATCH    -
R0028   R0028-cyclotomic-routing-two-gains.md                a1e2c22506670b9522abac1d3ce423092644b0d3925a01765e4142c9aa98fdbd a1e2c22506670b9522abac1d3ce423092644b0d3925a01765e4142c9aa98fdbd MATCH    -
R0028   R0028-situated-constructor-port.md                   e0df4fbe64aeab06c93a933ba131d5931f6ebe2c904556a5221eb786246993a4 e0df4fbe64aeab06c93a933ba131d5931f6ebe2c904556a5221eb786246993a4 MATCH    -
R0029   R0029-guaranteed-acquisition.md                      10e8b14330b3180c26685409863113f8530ccb67c967f16281a8b8871b01b9de 10e8b14330b3180c26685409863113f8530ccb67c967f16281a8b8871b01b9de MATCH    -
R0029   R0029-situated-port-engine-integration.md            810d4063a6dd19f3e6d84f5a1cc3edd416384fb56602168dbd1911678682bc76 810d4063a6dd19f3e6d84f5a1cc3edd416384fb56602168dbd1911678682bc76 MATCH    -
R0030   R0030-affordable-horizon.md                          b41c0eef927bebb5cc342d3f2ce43134cc429c687be9f96740685577f3f5545c b41c0eef927bebb5cc342d3f2ce43134cc429c687be9f96740685577f3f5545c MATCH    -
R0030   R0030-prediction-authority-boundary.md               306b2214be2abc84a0d30cc5aa686f2d3af1d5572fe07743f482a562ec8b8c60 306b2214be2abc84a0d30cc5aa686f2d3af1d5572fe07743f482a562ec8b8c60 MATCH    -
R0031   R0031-closed-arithmetic-response-family.md           5f069e38e03dca2acefc2efc890b4f9ed51a302b6fc942914c80eb55144dd204 5f069e38e03dca2acefc2efc890b4f9ed51a302b6fc942914c80eb55144dd204 MATCH    -
R0031   R0031-reachable-count-law.md                         7296bc8cedf3d88993d02800d114bc2e42bcb56e6341247bc37a94a0977e7c6a 7296bc8cedf3d88993d02800d114bc2e42bcb56e6341247bc37a94a0977e7c6a MATCH    -
R0032   R0032-antichain-formation-sufficiency.md             9f57ec96132601a5e65a032f29e59e3947d34196c623496c6b26f9676ad92d52 9f57ec96132601a5e65a032f29e59e3947d34196c623496c6b26f9676ad92d52 MATCH    -
R0032   R0032-two-bases-nogo-and-transport.md                1dfd133922f957915f01253e3cc68b415789a76480c8db55430ab565a1af81e7 1dfd133922f957915f01253e3cc68b415789a76480c8db55430ab565a1af81e7 MATCH    -
R0033   R0033-targeting-schedules-not-extends.md             0a13a50b98bfd080487e1f787f240f7f549f8ed10d7cd7720ba796bf7da3e714 0a13a50b98bfd080487e1f787f240f7f549f8ed10d7cd7720ba796bf7da3e714 MATCH    -
R0034   R0034-perfect-power-bases-redundant.md               afa976d1893b8264059d4410340fa0fa6660d8900ed07e40d47c7cc5fcea3e8d afa976d1893b8264059d4410340fa0fa6660d8900ed07e40d47c7cc5fcea3e8d MATCH    -
R0035   R0035-redundancy-trichotomy.md                       ebf0cfefc0c11fae28bd9c9d2ccad1a5b6a5ade7351391046ad3315f5a83d69e ebf0cfefc0c11fae28bd9c9d2ccad1a5b6a5ade7351391046ad3315f5a83d69e MATCH    -
R0036   R0036-interleaving-crossover.md                      553471ee7dce7e3fcc61582b74cc7d3e71df00080ec47694114036f50c2b2d55 553471ee7dce7e3fcc61582b74cc7d3e71df00080ec47694114036f50c2b2d55 MATCH    -
R0037   R0037-yield-bound-local-optimality.md                dc8d610ee8db20df49c2bcf683ad8fb322a6ff33c578234191f1d18cacf7232b dc8d610ee8db20df49c2bcf683ad8fb322a6ff33c578234191f1d18cacf7232b MATCH    -
R0038   R0038-contested-window-irreducible.md                931062b1a20f91196b0d5630d8f0b6e2f83e016bbcf4f309ad3588b415430896 931062b1a20f91196b0d5630d8f0b6e2f83e016bbcf4f309ad3588b415430896 MATCH    -
R0039   R0039-contest-dissolves.md                           6422aae40ce97f17c61177c3264bc09bf594398872944969bd14fcc91adf7e45 6422aae40ce97f17c61177c3264bc09bf594398872944969bd14fcc91adf7e45 MATCH    -
R0040   R0040-partial-scan-bracket.md                        e2476cf419ee37b9d51d99955757b8c80751df070a5b197bba6a80cd68f5d780 e2476cf419ee37b9d51d99955757b8c80751df070a5b197bba6a80cd68f5d780 MATCH    -
R0041   R0041-deciding-is-not-knowing.md                     8aab1bb0403e3cc45028c131d2c3281d4b5bf25f298199bfa95184b3471efe46 8aab1bb0403e3cc45028c131d2c3281d4b5bf25f298199bfa95184b3471efe46 MATCH    -
R0042   R0042-response-character-kickback-boundary.md        58e79013998cd71f2e96b4dfefeeb6433cfbae04828e79e709c1c2cc63cb462e 58e79013998cd71f2e96b4dfefeeb6433cfbae04828e79e709c1c2cc63cb462e MATCH    -
R0043   R0043-haar-null-quantum-port.md                      a4f2fde3426069cc0b715046552a2d13259b733416be185401d8af67bfd116f8 89d905fa6b6af87b045b931a7dd7c23376dc6299471343ffc29f112fc4e8caaf MISMATCH REPAIRED
R0044   R0044-action-residual-formation.md                   51f2190e01f8d634ff1d5607d36a97550e3ff23638e8d325f678e8179a7fe91e 51f2190e01f8d634ff1d5607d36a97550e3ff23638e8d325f678e8179a7fe91e MATCH    -
R0045   R0045-action-residual-phase.md                       a5cafc6de2f3ae651945f3d938bec3d36bb7d646139034cfb957168c93b73a82 a5cafc6de2f3ae651945f3d938bec3d36bb7d646139034cfb957168c93b73a82 MATCH    -
R0045   R0045-predictor-window-formation.md                  d450df932eee6b5e7e0b34d76cacc7d52c8f055f0cc59e1b091257114e246fd8 d450df932eee6b5e7e0b34d76cacc7d52c8f055f0cc59e1b091257114e246fd8 MATCH    -
R0046   R0046-phase-predictor-closure.md                     52907eb948ea5a81f12bb715a8ab6bbe13fb68924045b590c3e8a55f4958e73f 52907eb948ea5a81f12bb715a8ab6bbe13fb68924045b590c3e8a55f4958e73f MATCH    -
R0047   R0047-finite-observable-horizon.md                   2f0507b2684eaae73127ac3d8fac7256419a26d5dcb59cec3f06c0acf081b7bc 2f0507b2684eaae73127ac3d8fac7256419a26d5dcb59cec3f06c0acf081b7bc MATCH    -
R0048   R0048-least-global-observable-horizon.md             fc1c1a30ab28082ca60f3f04cb6ef9c3eb5baf231be11924d5aa2370678dd5cf fc1c1a30ab28082ca60f3f04cb6ef9c3eb5baf231be11924d5aa2370678dd5cf MATCH    -
R0049   R0049-adaptive-uniform-horizon-gap.md                1af2fb3e7c6aabd5c4196c31f94f6a9bf11163d55ca20850d8d087f7831da6ea 1af2fb3e7c6aabd5c4196c31f94f6a9bf11163d55ca20850d8d087f7831da6ea MATCH    -
R0052   R0052-coherent-survival-dephasing.md                 5278dc4b0a2d0610a649d44042f8ba28c20623ea246ac00cfcaf8f444e9dc5cc ee39d353b7d48f2269c6c20010b721779d20f18c65f20880022f47a784a40c7b MISMATCH LEFT (provenance break)
R0053   R0053-adaptive-depth-lower-bound.md                  447a356146b93b8b0636acf6e016271f3dd48916e807a8eb0c0d339c883e3d25 447a356146b93b8b0636acf6e016271f3dd48916e807a8eb0c0d339c883e3d25 MATCH    -
R0054   R0054-linear-adaptive-horizon-gap.md                 2f533a1ec12cc75b1341b4ca59a4714ce4d2792c6f69378c2c22277a1fc8f706 f2f9c3de81420eeaf3821a31080dfdcb6ef598a38de543aa88d69b0099416ac6 MISMATCH LEFT (provenance break)
R0055   R0055-programmable-scalar-coherence.md               1b48fd46d2b86170451464d117d6660f3ddb9a522d8e720e00d984c339ae5091 1b48fd46d2b86170451464d117d6660f3ddb9a522d8e720e00d984c339ae5091 MATCH    -
R0056   R0056-safe-split-potential.md                        8678811ebf00b68050f5f767058d8987b623da4267e28535a64621dd5e8a530d 8678811ebf00b68050f5f767058d8987b623da4267e28535a64621dd5e8a530d MATCH    -
R0057   R0057-constant-response-steering.md                  2f2af13d26760ac28ad6aa2d926043b753dbdda912ba839b91893183b7705880 2f2af13d26760ac28ad6aa2d926043b753dbdda912ba839b91893183b7705880 MATCH    -
R0058   R0058-residual-position-rank.md                      f231504d9a1fbdaa9b3023e581fe08164a0710233f6fcd1d41e61f8faa00c49b f231504d9a1fbdaa9b3023e581fe08164a0710233f6fcd1d41e61f8faa00c49b MATCH    -
R0059   R0059-residual-cycle-deletion.md                     f2b9c2d1107d1af4f6cc71de772b0e198ba50030388745083d66a4f5411cb96a 90b43e3fa7a385bd20bbc6a3191c2e9e50f94cf7752840492be8d05bd049b52b MISMATCH REPAIRED
R0060   R0060-batch-depth-memory-quantum-boundary.md         e2f4b69f9b6ebaa5c99faf7827bb42bcb892d68dda86bad54f23b04059fbca43 e2f4b69f9b6ebaa5c99faf7827bb42bcb892d68dda86bad54f23b04059fbca43 MATCH    -
R0061   R0061-node-minimal-residual-spines.md                753c890aaa7a22e50877f87fd249047dd12c73314209027894d18c83e0a2cd10 4ed22d0c27ac92031afdfd5c9a59836defd7cd05ecbda204f123a7305a4e6ee5 MISMATCH REPAIRED
R0062   R0062-incremental-crt-mathlib-adapter.md             b97c41c6cf7ac9e074b11489a80817a5fbdcb77fb895f45744deadad46702ed3 70a5209512f4f82e58131d068677bba04ad6ff93f3ff0a478e120858817b8f57 MISMATCH REPAIRED
R0063   R0063-binomial-steering-budget-no-go.md              f84e317926b0438eae1634c8e53291baa8b173ad978d95b3c0a908ebc1837cbc 90ddf5c992419fb7da76acfca2add754f4b2803be0200186ef43dde64d81efd4 MISMATCH REPAIRED
R0064   R0064-nonhomogeneous-residual-spine-bound.md         e825669461e7611c7a33e0153a32360fcace611331533ad2beeaf12a15f1e733 6040abe867113c996d904204a85367013070119c94245e41abcf6cdd65520407 MISMATCH REPAIRED
R0065   R0065-balance-not-transitivity.md                    f24c72071c9d6c35d6002b7a0ae08af6c5d6e28b23013877d7671c5726f75499 3de473bd4fa07927316893aa7c8f753a99001c0a7988b4e6767c2a92865a3543 MISMATCH REPAIRED
R0066   R0066-global-residual-witness-partition.md           f7fc88b13359a5e8da3ce5149fe978399102d112e3de974bf9d705baeee1c24a b30db7d5a3c430c6832aaf9e8e80cf9dbf6f87846f5dad28087c5f6d4a6752df MISMATCH REPAIRED
R0067   R0067-cyclotomic-routing-mathlib-adapter.md          68873747d37c3fef9f9f2bd7541a4e8980684ee41692d702745e2f6528708633 6044ee74f723f74ae351fd8a3bacbbd965a3b0db2636515f9c975a78728d7b7a MISMATCH REPAIRED
R0068   R0068-annotated-residual-split-budget.md             54b2d893dfe3dde6278a91ad09c6373237dc6542a1cda049b0f672a47ea5d147 54b2d893dfe3dde6278a91ad09c6373237dc6542a1cda049b0f672a47ea5d147 MATCH    -
R0069   R0069-annotated-global-partition-adapter.md          PLACEHOLDER                                                      cf1ec73e7feec3ffc43bd085cabdd2e4a8b95d352ec6df27cffa3fd86f5331b4 MISMATCH REPAIRED
R0070   R0070-cyclotomic-primitive-transport-adapter.md      94e6dfb5f1e7f0ed0417bfaf58720a322cab3e620a72fab8833ef298d44c79b5 531c25d000d2dc21a1e4555d9610cabb4ce0eef9faabb217f0008a0f69415dda MISMATCH REPAIRED
R0071   R0071-native-complete-witness-language.md            3a697b7f9361e047ac35a28c07b6d7324b1bb13fac46d0e753d86d9299010685 fb7c357fd03ee256e271d836d9e318b4ad9c43fa12bcbff55f976087a497d0ae MISMATCH REPAIRED
R0072   R0072-affine-projection-quantum-boundary.md          a04698ddff41a450ecd3a1a5c7daa2e2a01793e5f02fb87b1799c08971b32aee 73d526b300db24ebde29543c8e191f837244c9026448a6e377ab219c82d28944 MISMATCH REPAIRED
R0072   R0072-native-witness-cost-and-prefix-boundary.md     2aae99eb3e144b70f3a15aa7c43cff1d04f5b7741da696e3e5c9a47108b52385 d8522e519c5d21e46f09f6b40b675357b6c7519d6c56fca43425b47694a3dd82 MISMATCH REPAIRED
R0073   R0073-higher-arity-padic-subtraction-adapter.md      cebf85b46e9076977f4561abe576cc58aa16fce202495c5edbc302fcc89e5975 d633627797d1e7d16c4d70cdd70ac0afcb0aac540cbff76ba8df978dcc352411 MISMATCH REPAIRED
R0074   R0074-infinity-fiber-mathlib-adapter.md              0caa626869e9f46d342d626ca8226c8187fb770efcc26f8b645c7ccbb3b42f43 3dba6ae2190f8bcce9cb9a27cc25388fda58ee912ccbe00446d4e80089fdd3df MISMATCH REPAIRED
R0075   R0075-smith-kernel-quantum-boundary.md               4962d81404e49f6f8156f34cae768bd6e455d95146506446c907906a1f35e404 3355a3a09b0b219d5766ed4926d00f04a5873a40db63b6124650b81d7b2dd7c8 MISMATCH REPAIRED
R0076   R0076-global-smith-flatness.md                       4a86b87cc34ebffa0a724a0cb5c38df2a23d3f3f1e072a4617e6ed4bd0dc195c df111da0eaf9f9a713ca45c3633ca54b26197e80e9a0666b7483bd7030c5c75a MISMATCH REPAIRED
R0077   R0077-addition-chain-predictive-memory.md            ce6d58c1d912c7652f5f02f57c29c8696edf3dc4b7749b5483d1a602873a1f15 78b166d32e627d35ece1efa7350908cfe656a96d4b589b32ecc96dfcdf79b21d MISMATCH REPAIRED
R0077   R0077-head-depth-mathlib-adapter.md                  3f5133fabffa7ead87f7e87d83042aa4dea0c594ef89a3a48b98503a502a8f31 2d4d798c85518b9603c9e899746c56d6f5faf3c2ab915037b7c89b9af0d66fc4 MISMATCH REPAIRED
R0078   R0078-affine-emergence-counted-path.md               527f7c8f1538617df8bd82b8390aa5d3aedfe6acfa2bbb05fa8092b129b6ac93 0f3628a49896e8993f9e86e08ff2fba9ba03390d8d27179de4d94c04cfe4bd3b MISMATCH REPAIRED
R0078   R0078-quotient-unit-source-cut.md                    1c24f72e720aeb0e9bcbe6ac29bd57a98ef0a5aae8ec3966b45abba9ed767619 186c30c76fab5296c0fc3a31b582d34cc092c5c47eddf42fefcc93721cdb9b0a MISMATCH REPAIRED
R0079   R0079-horner-residue-automaton-detour.md             1d01cfb147ed5cfe137847376382ea8699a9176ace8a6a7a83d70ed04b3a0f2d 1d01cfb147ed5cfe137847376382ea8699a9176ace8a6a7a83d70ed04b3a0f2d MATCH    -
R0080   R0080-bridge-residual-and-fifth-response.md          ae7ec6a360bba9f38567b08a4f741c7bb80385591b9871a7971282215c245bf0 ae7ec6a360bba9f38567b08a4f741c7bb80385591b9871a7971282215c245bf0 MATCH    -
R0081   R0081-end-obstruction-halting-does-not-close.md      625039603dba43b8f08a41bf50a7a99d306c781f7fac7847c5f906f5e8542138 625039603dba43b8f08a41bf50a7a99d306c781f7fac7847c5f906f5e8542138 MATCH    -
```

## 3. Diagnosis

Every mismatch was diagnosed against git history before anything was touched:
for each packet, every commit that ever touched it was checked out and its
stored hash compared with the hash computed from *that* revision's statement.
The result is sharper than either of the two cases the audit was commissioned
to separate.

**Finding: in 23 of the 24 mismatches, the stored hash was never correct at any
commit in the packet's history, and the `Exact statement` never changed.** The
computed hash is constant across every revision of the file; the stored hash
equals it at none of them. The one partial exception is `R0043`, whose first
commit carried an *empty* `Exact statement` (hash `e3b0c442…`, the hash of the
empty string) and which acquired its present statement in the next commit —
but its stored hash `a4f2fde3…` is the hash of neither.

Two further facts fix the cause:

- The retired tool has **no command that writes `statement_hash` into front
  matter.** `command_transition` recomputes the hash and writes it into the
  *event*, never back into the packet. Front-matter hashes were therefore
  always typed by hand.
- **Every mismatch is `R0043` or later**, i.e. filed on 2026-08-14/15; every
  packet `R0001`–`R0041`, filed 2026-08-11/12 while the Python validator could
  still be run, matches. The hashes went bad the moment the check that would
  have caught them stopped being runnable (Python ban, 2026-08-13).

So the corpus does not actually contain case (a) as posed — no statement was
edited out from under a correct hash. It contains something less dramatic and
more corrosive: hashes that were plausible-looking hex, never computed. Two of
them were left as literal placeholders and later "filled in" with values that
still hash nothing: `R0069` still reads `statement_hash: PLACEHOLDER`;
`R0071` read `PLACEHOLDER` in commits `4cc051f9`, `2c883b4e` and then
`3a697b7f…` from `00a54691` on, while the statement's true hash sat unchanged
at `fb7c357f…` throughout; `R0072-affine-projection` read `HASH_PLACEHOLDER`
in `2b3006e8`, then `a04698dd…` in `91592112`, true hash `73d526b3…`
throughout. Substituting a random-looking constant for the word `PLACEHOLDER`
is worse than leaving the placeholder: it converts a visible gap into an
invisible lie.

None of the stored hashes is the correct hash of any *other* packet in the
corpus, so none of them is a copy-paste from a sibling.

### Case (a) — repaired (22 packets)

For 22 of the 24, the wrong hash is cited **nowhere but in the packet's own
front matter**: `git grep -F` over the whole tracked tree finds no event, no
manifest, no note, no audit that references it. The statement is unchanged and
authoritative, no event chain disagrees (these packets have no events at all —
see §4), and correcting the field destroys no evidence. Each was repaired by:

1. replacing the `statement_hash:` line with the computed value;
2. appending a dated, attributed bullet to the packet's `# Event log` section
   recording that the hash was recomputed and the statement untouched
   (PROTOCOL §2: correct in place, attribute, never silently).

The statement text of all 22 was verified byte-identical after the repair (the
computed hash is unchanged by the edit). `updated:` was deliberately **not**
touched — this audit is not a transition by the packet's owner, and moving that
date would misattribute the edit.

### Case (b) — provenance breaks, NOT repaired (2 packets)

| packet | stored (cited by events) | true hash of current statement |
| --- | --- | --- |
| `R0052-coherent-survival-dephasing` | `5278dc4b0a2d0610a649d44042f8ba28c20623ea246ac00cfcaf8f444e9dc5cc` | `ee39d353b7d48f2269c6c20010b721779d20f18c65f20880022f47a784a40c7b` |
| `R0054-linear-adaptive-horizon-gap` | `2f533a1ec12cc75b1341b4ca59a4714ce4d2792c6f69378c2c22277a1fc8f706` | `f2f9c3de81420eeaf3821a31080dfdcb6ef598a38de543aa88d69b0099416ac6` |

These two are different in kind. Their stale hashes are cited by four
append-only event files:

```
collab/discovery/events/R0052/20260814T085712Z-seeded.json
collab/discovery/events/R0052/20260814T090500Z-proving.json
collab/discovery/events/R0054/20260814T091749Z-seeded.json
collab/discovery/events/R0054/20260814T092930Z-proving.json
```

Both packets were transitioned `unregistered → seed → proving` by
`codex-quantum-process` / `codex-formation` against a statement whose text
hashes to the value in those events — a text that exists in no commit and
therefore cannot be recovered. Rewriting the front-matter hash would leave both
event chains citing a hash that appears nowhere in the repository, and would
make the packets *look* consistent while erasing the only surviving evidence
that two recorded transitions were made against different text. That is exactly
the erasure this audit exists to prevent, so the front matter is left as filed
and both packets are recorded here as **unresolved provenance breaks**.

**The convention that applies.** The registry's own rule (`collab/discovery/README.md`):
"Refutation does not upgrade the surrounding framework. It terminates this
packet. Any repaired statement is a new packet linked under `supersedes`."
There is no "restate in place" event type, and none should be invented — the
event vocabulary is `from`/`to` status transitions only. The correct repair,
which only the owning identity should make, is therefore:

- file a **new packet** carrying the current statement, with
  `supersedes: R0052` (resp. `R0054`) and a correctly computed
  `statement_hash`; then
- append one event to the old packet moving it to **`superseded`**.

Note the transition table blocks this directly: `LEGAL_TRANSITIONS["proving"]`
is `{breaking, refuted, known, blocked, inconclusive, quarantined}` — `proving`
cannot reach `superseded` in one step. The legal routes are
`proving → quarantined → superseded` or `proving → inconclusive → superseded`,
and `quarantined` is the honest one: the statement of record is unrecoverable,
which is a quarantine condition, not a refutation. `refuted` and `known` are
disabled in code (`CERTIFICATION_ENABLED = False`) and would be wrong anyway.

## 4. Schema invariants — violations found

Checked: `cycle` = event count; each event's `from` = previous event's `to`;
last event's `to` = front-matter `status`; every event carries the hash current
at its time; required fields, required sections, and enum membership.

**Every event's hash is correct for its own packet.** There are no orphan
event hashes anywhere in the corpus beyond the two §3 breaks — the 53 event
directories are otherwise internally consistent.

The following were found and **not** repaired: none of them is mechanical, and
all but three sit in packets this audit does not own.

**(i) Duplicate claim ids — 10 collisions, 20 packets.** `R0027`, `R0028`,
`R0029`, `R0030`, `R0031`, `R0032`, `R0045`, `R0072`, `R0077`, `R0078` each
name two different packets (89 files, 79 distinct ids). Because `Packet.event_dir`
is `events/<id>/`, the two packets' event streams are **interleaved in one
directory**, and the validator's chain check reads across both — which is the
sole cause of the reported `from ≠ previous to` breaks at
`events/R0027/20260812T153843Z-builder.json`,
`events/R0028/20260812T155711Z-builder.json`,
`events/R0029/20260812T163000Z-builder.json`,
`events/R0030/20260812T164200Z-builder.json` and
`events/R0031/20260812T161654Z-builder.json` (each is a second
`unregistered → seed` opening the *other* packet's stream). Taken one stream at
a time, every chain is intact. This also makes `cycle` and last-`to` =`status`
uncheckable for all 20: e.g. `events/R0045` holds two events, both belonging to
`R0045-action-residual-phase`, while `R0045-predictor-window-formation` is
`status: proving` with no events of its own; `R0032-antichain-formation-sufficiency`
is `status: proving, cycle: 1` and owns none of the single `R0032` event.
Repair requires renumbering a packet and moving events — an owner decision with
message traffic, not a mechanical fix.

**(ii) 29 packets have no event directory at all** — the append-only log that
is supposed to be the registry's spine simply does not exist for a third of the
corpus, though all 29 carry `status: proving` (or worse, see (iv)) and
`cycle: 1` or `2`, asserting transitions that were never recorded:
`R0042 R0043 R0044 R0055 R0056 R0057 R0058 R0059 R0061 R0062 R0063 R0064 R0065
R0066 R0067 R0068 R0069 R0070 R0071 R0072(×2) R0073 R0074 R0075 R0076 R0077(×2)
R0078(×2)`. Manufacturing the missing events would be forgery; only the acting
identities can file them.

**(iii) `cycle` ≠ event count in 20 of the 60 packets that have an event directory** (and vacuously in all 29 that do not). Beyond the duplicate-id cases,
`R0046`, `R0047`, `R0048`, `R0049`, `R0052`, `R0053`, `R0054`, `R0060` each
have `cycle: 1` against 2 events (a `seeded` event plus a `proving` event; the
hand-written seed never incremented the counter). This is arguably mechanical,
but all eight are packets whose hash was correct — i.e. outside this audit's
ownership — so they are reported, not touched. The 29 packets in (ii) also
violate it vacuously.

**(iv) Invalid `status` values — 3 packets, all outside the enum:**
`R0074-infinity-fiber-mathlib-adapter` says `proved`;
`R0077-head-depth-mathlib-adapter` and `R0078-quotient-unit-source-cut` say
`claimed`. These are not typos with an obvious target — `proved` could mean
`proving` or the deliberately disabled `certified`, and the registry's whole
point is that those are different — so they were left. (All three are packets
whose hash this audit did repair; the hash repair is independent of the status
field.)

**(v) Invalid `certificate` values — 38 packets** (`R0042` onward) say
`certificate: formal-proof`, which is not in
`{unset, exact-symbolic, exact-finite, formal, asymptotic, literature,
counterexample, mixed}`. The intended value is almost certainly `formal`, but
38 uniform occurrences are a vocabulary drift, not 38 typos, and normalizing
them is a registry-wide decision.

**(vi) Invalid `kind` values — 36 packets** use `theorem`, `bridge`, `no-go`,
`counterexample`, or `correspondence` against the schema's
`{tension, transport, measurement, obstruction, synthesis}`. Same drift, same
date range, same reasoning. (`R0032-antichain-formation-sufficiency` is the
earliest, with `kind: theorem`.)

**(vii) Missing required sections — 6 packets:** `R0053` (rosetta bridge,
preservation ledger), `R0054` (tension, rosetta bridge, preservation ledger,
falsification, successor seeds), `R0055` (successor seeds), `R0059` (rosetta
bridge, preservation ledger), `R0074` (independent audit), `R0077-head-depth`
(independent audit, successor seeds).

**(viii)** No packet is missing a required *front-matter field*, and no packet
has duplicate front-matter keys or duplicate level-one sections.

Items (iv)-(vii) share one cause with the hash drift: after 2026-08-13 the
validator could no longer be run, and the schema became a document nobody
checked. The sh reimplementation in §1 removes that excuse for the hash; the
rest of the validator deserves the same treatment.

## 5. What was changed by this audit

- 22 packet files: one `statement_hash:` line corrected, one dated bullet
  appended to `# Event log`. No `Exact statement` was touched (verified: every
  computed hash is identical before and after).
- This report.
- Nothing else. No event file was created, edited, or deleted; no other
  identity's uncommitted work was staged, reverted, or otherwise disturbed.
