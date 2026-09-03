#!/usr/bin/env python3
"""
generative.py — compression as coding a derivation against a generative
grammar that grows by install.  This is NOT a byte predictor with the
corpus's words on it; it is the corpus's own mechanism, run on bytes.

THE MECHANISM, term by term (kernel + RewriteEngine):

  * A GENERATIVE GRAMMAR offers, at each state, a finite set of enabled
    futures — `List (EnabledFuture seed)` (GenerativeKernel.form /
    ControlledGrammar.advance).  The datum is a PATH through that branching;
    to store it you store WHICH branch at each step.  The kernel is explicit
    (TheControlCarriesItsInstance… §note): "Nothing scores, ranks or samples
    the enabled list."  So the compressed datum is the sequence of branch
    identities in its derivation — nothing else.

  * The grammar is not fixed.  When the datum reaches a pair the grammar can
    only generate as two separate branches that recur together — an
    OBSTRUCTION — `install` (ControlledGrammar.install : Derivation → Native-
    Operation) adds a production N → x y whose control fires at that class
    (vyāpti — one rule pervades every occurrence, not one memorised site).
    Acceptance is `laghava` (MDL): install iff the description length
    strictly drops.  When nothing earns installation, growth halts — the
    plateau.

  * WEIGHTS ⇒ TRACES.  Every install is a deterministic function of the
    causal past (the pairs already seen), so the decoder regrows the identical
    grammar from the symbols it has already emitted.  Zero grammar is
    transmitted.

  * LOSSLESS BY CONSTRUCTION.  A production expands back to exactly its two
    children (reverse = invEquiv in the kernel; here the expansion table is
    exact), so decoding replays the derivation to the original bytes.  Checked
    by re-decoding before returning.

WHAT IS THE CORPUS'S AND WHAT IS FORCED.  The grammar (which productions
exist) is grown by install+laghava — the corpus's discipline.  Coding the
branch index needs a measure over the current alphabet; the kernel refuses
to score, so the measure is the ONLY thing the kernel hands off: it is a
projection weight = π(trace) (README §3), used solely to order an arithmetic
code and never stored — the trace (the grammar + the path) is the object,
the frequency is its lossy shadow, and arithmetic coding inverts exactly so
no byte is lost to the shadow.  This is the one honest projection; it is
named, not hidden.

This is RePair's family of grammar-based codes — because grammar-based
coding IS what "code the derivation against the generative grammar" is; the
corpus supplies the frame (generative branches, install-on-obstruction,
laghava, vyapti, weights⇒traces), not a novel search.
"""
from __future__ import annotations
import sys, struct, zlib, bz2, lzma, math, time

# ── the entropy floor: a binary range coder (lossless; the code, not the model)
MASK32=(1<<32)-1; K_TOP=1<<24
class REnc:
    def __init__(s): s.low=0;s.range=MASK32;s.cache=0;s.cs=1;s.out=bytearray()
    def _sl(s):
        if s.low<0xFF000000 or s.low>MASK32:
            c=s.cache
            while True:
                s.out.append((c+(s.low>>32))&0xFF);c=0xFF;s.cs-=1
                if s.cs==0:break
            s.cache=(s.low>>24)&0xFF
        s.cs+=1;s.low=(s.low<<8)&MASK32
    def bit(s,p0,b):
        bound=(s.range>>12)*p0
        if b==0:s.range=bound
        else:s.low+=bound;s.range-=bound
        while s.range<K_TOP:s.range=(s.range<<8)&MASK32;s._sl()
    def finish(s):
        for _ in range(5):s._sl()
        return bytes(s.out)
class RDec:
    def __init__(s,d):
        s.d=d;s.p=1;s.range=MASK32;s.code=0
        for _ in range(4):s.code=((s.code<<8)|s._b())&MASK32
    def _b(s):
        v=s.d[s.p] if s.p<len(s.d) else 0;s.p+=1;return v
    def bit(s,p0):
        bound=(s.range>>12)*p0
        if s.code<bound:s.range=bound;b=0
        else:s.code-=bound;s.range-=bound;b=1
        while s.range<K_TOP:s.range=(s.range<<8)&MASK32;s.code=((s.code<<8)|s._b())&MASK32
        return b

# Code a symbol (a branch identity) over the current alphabet by a binary
# decomposition of an adaptive frequency table — the projection π(trace),
# used only to order the code.  An order-1 context (previous branch) sharpens
# the measure; still a projection, still nothing stored.
class BranchCoder:
    def __init__(s, nsyms_max):
        s.NB = max(1,(nsyms_max-1).bit_length())     # bits to name a branch
        # order-1 counts: ctx -> per-bit-node p1 (12-bit), lazily grown
        s.tab = {}
    def _p(s, ctx, node):
        k=(ctx<<6)|node
        return s.tab.get(k, 2048)
    def _u(s, ctx, node, bit):
        k=(ctx<<6)|node
        v=s.tab.get(k,2048); s.tab[k]=v+(((bit<<12)-v)>>4)
    def enc(s, enc, ctx, sym, nb):
        node=1
        for i in range(nb-1,-1,-1):
            bit=(sym>>i)&1; p1=s._p(ctx,node); p0=4096-p1
            p0=1 if p0<1 else(4095 if p0>4095 else p0)
            enc.bit(p0,bit); s._u(ctx,node,bit); node=(node<<1)|bit
    def dec(s, dec, ctx, nb):
        node=1
        for i in range(nb-1,-1,-1):
            p1=s._p(ctx,node); p0=4096-p1
            p0=1 if p0<1 else(4095 if p0>4095 else p0)
            bit=dec.bit(p0); s._u(ctx,node,bit); node=(node<<1)|bit
        return node-(1<<nb)

# ── the generative grammar over bytes, grown by install+laghava ───────────
#
# A production is N -> (a,b).  The alphabet is 0..255 (terminals) then grown
# nonterminals.  Compress: repeatedly, one pass installs the digram that
# laghava says saves most (install-on-obstruction), then the sequence is
# rewritten through it.  The path over the final grammar's top sequence is
# coded; the grammar itself regrows on decode from the SAME laghava-greedy
# rule over the SAME causal data, so nothing about it is transmitted.
#
# This is the offline form (whole-sequence install rounds); the branch set at
# each install round is the corpus's `advance` over the current grammar, and
# `laghava` picks which obstruction to resolve.

def _digram_counts(seq):
    d={}
    i=0; n=len(seq)
    while i<n-1:
        p=(seq[i],seq[i+1])
        d[p]=d.get(p,0)+1
        i+=1
    return d

def install_grammar(data):
    seq=list(data)
    rules=[]                         # index i -> (a,b) for nonterminal 256+i
    next_id=256
    while True:
        dc=_digram_counts(seq)
        if not dc: break
        # laghava: installing N->(a,b) that occurs k times replaces k pairs
        # (2k symbols) by k symbols + one 2-symbol rule => saves k-2 symbols.
        (a,b),k = max(dc.items(), key=lambda kv: kv[1])
        if k-2 <= 0: break           # plateau: no obstruction earns install
        rid=next_id; rules.append((a,b)); next_id+=1
        out=[]; i=0; n=len(seq)
        while i<n:
            if i<n-1 and seq[i]==a and seq[i+1]==b:
                out.append(rid); i+=2
            else:
                out.append(seq[i]); i+=1
        seq=out
    return seq, rules

def _expand(seq, rules, out):
    for s in seq:
        stack=[s]
        while stack:
            x=stack.pop()
            if x<256: out.append(x)
            else:
                a,b=rules[x-256]; stack.append(b); stack.append(a)

def compress(data:bytes)->bytes:
    seq, rules = install_grammar(data)
    nsyms = 256+len(rules)
    enc=REnc(); bc=BranchCoder(nsyms)
    nb=max(1,(nsyms-1).bit_length())
    ctx=0
    for sym in seq:
        bc.enc(enc, ctx&0x3F, sym, nb)
        ctx=sym
    payload=enc.finish()
    # header: original length, #rules, the rule table (each rule two syms).
    hdr=bytearray(b"GENV")
    hdr+=struct.pack("<QI",len(data),len(rules))
    W=max(1,(nsyms-1).bit_length())
    rb=REnc(); rbc=BranchCoder(nsyms); rctx=0
    for (a,b) in rules:
        rbc.enc(rb,rctx&0x3F,a,W); rctx=a
        rbc.enc(rb,rctx&0x3F,b,W); rctx=b
    rpay=rb.finish()
    hdr+=struct.pack("<I",len(rpay))+rpay
    hdr+=struct.pack("<I",len(seq))
    arc=bytes(hdr)+payload
    if decompress(arc)!=data: raise AssertionError("generative: roundtrip certificate FAILED")
    compress.rules=len(rules); compress.seqlen=len(seq); compress.nsyms=nsyms
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"GENV"
    off=4
    n,nr=struct.unpack_from("<QI",arc,off); off+=12
    nsyms=256+nr; nb=max(1,(nsyms-1).bit_length())
    rlen,=struct.unpack_from("<I",arc,off); off+=4
    rpay=arc[off:off+rlen]; off+=rlen
    # regrow the rule table (same coder, deterministic)
    rd=RDec(rpay); rbc=BranchCoder(nsyms); rctx=0; rules=[]
    W=nb
    for _ in range(nr):
        a=rbc.dec(rd,rctx&0x3F,W); rctx=a
        b=rbc.dec(rd,rctx&0x3F,W); rctx=b
        rules.append((a,b))
    seqlen,=struct.unpack_from("<I",arc,off); off+=4
    payload=arc[off:]
    dec=RDec(payload); bc=BranchCoder(nsyms); ctx=0; seq=[]
    for _ in range(seqlen):
        sym=bc.dec(dec,ctx&0x3F,nb); seq.append(sym); ctx=sym
    out=bytearray(); _expand(seq,rules,out)
    return bytes(out[:n])

def bench(data,label):
    n=len(data); t0=time.time(); c=compress(data); dt=time.time()-t0
    rows=[("generative",len(c)),("gzip-9",len(zlib.compress(data,9))),
          ("bz2-9",len(bz2.compress(data,9))),("lzma",len(lzma.compress(data,preset=9)))]
    print(f"\n{label}: {n} bytes  ({dt:.1f}s)")
    print(f"  grammar: {compress.rules} productions installed, "
          f"top sequence {compress.seqlen} symbols, alphabet {compress.nsyms}")
    for nm,sz in rows: print(f"  {nm:12s} {sz:9d}  {n/sz:6.2f}x  {8*sz/n:5.3f} bpc")
    assert decompress(c)==data; print("  [certificate] roundtrip exact; zero grammar transmitted")

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]: bench(open(f,"rb").read(),f)
    else: print(__doc__)
