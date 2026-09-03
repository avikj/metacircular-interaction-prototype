#!/usr/bin/env python3
"""
cmdl.py — Cohomological-MDL lossless codec (prototype).

The conservative-semantic-compression theory, built as a running tool for
arbitrary byte data.

  * Choose the complex, per block, by MDL.  A block is a 0-cochain on a path
    graph.  A finite-difference operator d is a boundary map; its inverse
    (prefix sum) is the Green operator G.  Each candidate transform is one
    choice of d.  We pick, per block, the d that makes the block MOST EXACT
    (smallest order-0 residual entropy) — "the differential complex in which
    the data becomes maximally exact and minimally cohomological."
  * Code the residual.  An adaptive order-1 binary range coder (LZMA-style),
    the entropy layer, over the transformed stream.
  * Certificate.  encode is a constructor: encode() re-decodes internally and
    asserts exact reconstruction before returning, so a produced archive is
    lossless by construction, not by hope.  decode() is model-agnostic: it
    reconstructs (d, G) from the transform ids and inverts — the codec is
    decoupled from any learned predictor.

No dependencies beyond the standard library.  Bit-exact; verified by roundtrip.
"""

from __future__ import annotations
import sys, struct, zlib, bz2, lzma, math

# ---------------------------------------------------------------------------
# Layer 2 : an adaptive binary range coder (LZMA-style), provably invertible.
# ---------------------------------------------------------------------------

K_TOP = 1 << 24
MASK32 = (1 << 32) - 1
PROB_BITS = 11
PROB_INIT = 1 << (PROB_BITS - 1)          # 1024
ADAPT = 5                                  # adaptation shift

class RangeEncoder:
    def __init__(self):
        self.low = 0
        self.range = MASK32
        self.cache = 0
        self.cache_size = 1
        self.out = bytearray()

    def _shift_low(self):
        if self.low < 0xFF000000 or self.low > MASK32:
            c = self.cache
            while True:
                self.out.append((c + (self.low >> 32)) & 0xFF)
                c = 0xFF
                self.cache_size -= 1
                if self.cache_size == 0:
                    break
            self.cache = (self.low >> 24) & 0xFF
        self.cache_size += 1
        self.low = (self.low << 8) & MASK32

    def encode_bit(self, probs, i, bit):
        p = probs[i]
        bound = (self.range >> PROB_BITS) * p
        if bit == 0:
            self.range = bound
            probs[i] = p + (((1 << PROB_BITS) - p) >> ADAPT)
        else:
            self.low += bound
            self.range -= bound
            probs[i] = p - (p >> ADAPT)
        while self.range < K_TOP:
            self.range = (self.range << 8) & MASK32
            self._shift_low()

    def finish(self):
        for _ in range(5):
            self._shift_low()
        return bytes(self.out)

class RangeDecoder:
    def __init__(self, data):
        self.data = data
        self.pos = 1                       # skip leading cache byte
        self.range = MASK32
        self.code = 0
        for _ in range(4):
            self.code = ((self.code << 8) | self._byte()) & MASK32

    def _byte(self):
        b = self.data[self.pos] if self.pos < len(self.data) else 0
        self.pos += 1
        return b

    def decode_bit(self, probs, i):
        p = probs[i]
        bound = (self.range >> PROB_BITS) * p
        if self.code < bound:
            self.range = bound
            probs[i] = p + (((1 << PROB_BITS) - p) >> ADAPT)
            bit = 0
        else:
            self.code -= bound
            self.range -= bound
            probs[i] = p - (p >> ADAPT)
            bit = 1
        while self.range < K_TOP:
            self.range = (self.range << 8) & MASK32
            self.code = ((self.code << 8) | self._byte()) & MASK32
        return bit

# byte via an 8-node-deep bit tree, order-1 context = previous byte.
def _new_model():
    return [PROB_INIT] * (256 * 256)       # [ctx*256 + treenode]

def encode_byte(enc, model, ctx, byte):
    base = ctx << 8
    node = 1
    for k in range(7, -1, -1):
        bit = (byte >> k) & 1
        enc.encode_bit(model, base + node, bit)
        node = (node << 1) | bit
    return byte

def decode_byte(dec, model, ctx):
    base = ctx << 8
    node = 1
    for _ in range(8):
        bit = dec.decode_bit(model, base + node)
        node = (node << 1) | bit
    return node & 0xFF

# ---------------------------------------------------------------------------
# Layer 1 : the complex.  Each transform is an exact bijection on a block —
# a choice of boundary operator d, with inverse the Green operator G.
# ---------------------------------------------------------------------------

def t_identity_f(b): return b
def t_identity_g(b): return b

def t_delta1_f(b):
    out = bytearray(len(b)); prev = 0
    for i, x in enumerate(b):
        out[i] = (x - prev) & 0xFF; prev = x
    return bytes(out)
def t_delta1_g(b):
    out = bytearray(len(b)); prev = 0
    for i, d in enumerate(b):
        prev = (prev + d) & 0xFF; out[i] = prev
    return bytes(out)

def t_delta2_f(b): return t_delta1_f(t_delta1_f(b))
def t_delta2_g(b): return t_delta1_g(t_delta1_g(b))

def t_xor1_f(b):
    out = bytearray(len(b)); prev = 0
    for i, x in enumerate(b):
        out[i] = x ^ prev; prev = x
    return bytes(out)
def t_xor1_g(b):
    out = bytearray(len(b)); prev = 0
    for i, d in enumerate(b):
        prev = d ^ prev; out[i] = prev
    return bytes(out)

TRANSFORMS = [
    (t_identity_f, t_identity_g),
    (t_delta1_f,   t_delta1_g),
    (t_delta2_f,   t_delta2_g),
    (t_xor1_f,     t_xor1_g),
]

def order0_bits(b):
    """Cheap MDL proxy: order-0 empirical code length of a block, in bits.
    This is the 'how exact is the block under this d' score."""
    if not b: return 0.0
    from collections import Counter
    c = Counter(b); n = len(b); acc = 0.0
    for v in c.values():
        acc -= v * math.log2(v / n)
    return acc

def choose_complex(block):
    """MDL selection of the boundary operator d for this block: the transform
    whose residual has least order-0 code length.  Returns (id, transformed)."""
    best_id, best_cost, best_t = 0, None, None
    for tid, (f, _g) in enumerate(TRANSFORMS):
        t = f(block)
        cost = order0_bits(t)
        if best_cost is None or cost < best_cost:
            best_id, best_cost, best_t = tid, cost, t
    return best_id, best_t

# ---------------------------------------------------------------------------
# Container : header + per-block transform ids + one order-1 coded payload.
# ---------------------------------------------------------------------------

MAGIC = b"CMDL"
BLOCK = 1 << 14                            # 16 KiB blocks

def compress(data: bytes) -> bytes:
    n = len(data)
    ids = bytearray()
    transformed = bytearray()
    for off in range(0, n, BLOCK):
        block = data[off:off + BLOCK]
        tid, t = choose_complex(block)
        ids.append(tid)
        transformed += t
    # entropy-code the concatenated transformed stream, order-1.
    enc = RangeEncoder()
    model = _new_model()
    ctx = 0
    for x in transformed:
        encode_byte(enc, model, ctx, x)
        ctx = x
    payload = enc.finish()
    ids_z = zlib.compress(bytes(ids), 9)   # the ids are tiny; pack them
    out = bytearray()
    out += MAGIC
    out += struct.pack("<QI", n, len(ids_z))
    out += ids_z
    out += payload
    archive = bytes(out)
    # CERTIFICATE: the constructor re-decodes and refuses to emit a lossy archive.
    if decompress(archive) != data:
        raise AssertionError("cmdl: roundtrip certificate FAILED — refusing to emit")
    return archive

def decompress(archive: bytes) -> bytes:
    assert archive[:4] == MAGIC, "not a cmdl archive"
    n, ids_len = struct.unpack_from("<QI", archive, 4)
    p = 4 + 12
    ids = zlib.decompress(archive[p:p + ids_len]); p += ids_len
    payload = archive[p:]
    nblocks = (n + BLOCK - 1) // BLOCK
    # range-decode the transformed stream.
    dec = RangeDecoder(payload)
    model = _new_model()
    transformed = bytearray(); ctx = 0
    total_t = n                            # transformed stream has same length as data
    for _ in range(total_t):
        x = decode_byte(dec, model, ctx)
        transformed.append(x); ctx = x
    # invert each block's chosen boundary operator (its Green operator G).
    out = bytearray(); off = 0
    for bi in range(nblocks):
        blen = min(BLOCK, n - off)
        seg = bytes(transformed[off:off + blen])
        g = TRANSFORMS[ids[bi]][1]
        out += g(seg)
        off += blen
    return bytes(out)

# ---------------------------------------------------------------------------
# Harness.
# ---------------------------------------------------------------------------

def bench(data: bytes, label: str):
    n = len(data)
    results = []
    c = compress(data); results.append(("cmdl", len(c)))
    results.append(("gzip-9", len(zlib.compress(data, 9))))
    results.append(("bz2-9", len(bz2.compress(data, 9))))
    results.append(("lzma", len(lzma.compress(data, preset=9))))
    print(f"\n{label}: {n} bytes")
    for name, sz in results:
        ratio = n / sz if sz else 0
        print(f"  {name:8s} {sz:9d}  {ratio:6.2f}x  {100*sz/n:5.1f}%")
    assert decompress(c) == data
    print("  [certificate] cmdl roundtrip exact: OK")

if __name__ == "__main__":
    if len(sys.argv) >= 3 and sys.argv[1] == "c":
        data = open(sys.argv[2], "rb").read()
        open(sys.argv[3], "wb").write(compress(data)); print("compressed")
    elif len(sys.argv) >= 3 and sys.argv[1] == "d":
        data = open(sys.argv[2], "rb").read()
        open(sys.argv[3], "wb").write(decompress(data)); print("decompressed")
    elif len(sys.argv) >= 2 and sys.argv[1] == "bench":
        for path in sys.argv[2:]:
            bench(open(path, "rb").read(), path)
    else:
        print(__doc__)
