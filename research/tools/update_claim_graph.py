#!/usr/bin/env python3
"""Build research/CLAIM_GRAPH.json: the received handoff graph plus the native
repository loci added since the pin.  The received bundle under
research/handoff_20260908/ is left byte-identical (its MANIFEST still verifies);
this file is the live graph the handoff asks agents to update.

Run from the repository root:  python3 research/tools/update_claim_graph.py
"""
import json, glob, os, datetime
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RECEIVED = os.path.join(ROOT, 'research/handoff_20260908/CLAIM_GRAPH.json')
OUT = os.path.join(ROOT, 'research/CLAIM_GRAPH.json')

def locus(prefix):
    hits = sorted(glob.glob(os.path.join(ROOT, 'formal/cubical/theorems/*/%s_*.agda' % prefix)))
    if len(hits) != 1:
        hits = sorted(glob.glob(os.path.join(ROOT, 'formal/cubical/theorems/*/%s*.agda' % prefix)))
    assert len(hits) == 1, (prefix, hits)
    return os.path.relpath(hits[0], ROOT)

# received claim id -> native modules whose checked statements are the algebraic
# core of (part of) that claim.  The claim's own status is unchanged: an
# analytic claim stays ANALYTIC; the native module discharges its ring/algebra
# content exactly and names its analytic hypotheses as module parameters.
NATIVE = {
  'A-POLARIZE':   ['Samamsa', 'MadhyaCheda'],
  'N-MIDPOINT':   ['MadhyaCheda'],
  'N-STORAGE':    ['MadhyaCheda', 'PurnaAvakalana'],
  'R-PASSIVE':    ['MadhyaCheda', 'Sopana_TheDamping'],
  'K-CERT':       ['PramanaPatra', 'YogaPatra'],
  'K-EXCURSION':  ['PunarAgamana'],
  'N-RENEWAL':    ['PunarAgamana'],
  'N-OBSRETRACT': ['PunarAgamana'],
  'N-LIFT':       ['DvitiyaLeibniz', 'DvipadaGuna'],
  'R-ABEL':       ['AbelaRupa'],
  'R-DYADIC':     ['AbelaRupa', 'SesaDvaya'],
  'N-RETURN24':   ['Vartana'],
  'N-INVERSE2':   ['Vartana'],
  'N-TOROIDAL':   ['Vartana', 'PurnaAvakalana'],
  'R-HOLONOMY':   ['PratibimbaBhramana', 'ArdhaTala'],
  'R-IMAGE':      ['PratibimbaTantu', 'RiktaTantu'],
  'K-FIBRE':      ['RiktaTantu'],
  'N-POTENTIAL':  ['KalaSetu'],
  'N-MEMORYK':    ['SmrtiBija', 'SmrtiMula'],
  'N-SIGNEDK':    ['SmrtiBija', 'SmrtiMula'],
  'N-COMMUTATOR': ['SamanaMula', 'SarvaMula'],
  'N-TRANSPORT':  ['VahanaSamata', 'EkaSesa', 'SarvaMula'],
  'N-AFFINE':     ['SahagunaVaha', 'BhramaMatra', 'TryaSresthaDosa', 'CaturthaAnka'],
  'N-SYMBOL':     ['TiryakChihna'],
  'N-SCALE':      ['DviDrsti', 'ManaSesa', 'Sikhara'],
  'N-ZENO':       ['ManaSesa', 'YugmaVyaya'],
  'A-CRT':        ['EkagraSreni'],
  'A-JUNITARY':   ['Vyatikrama', 'DviMana'],
  'R-THETA':      ['DhruvaMula'],
  'R-CARDINAL':   ['DhruvaMula'],
  'N-H5':         ['DhruvaMula'],
  'N-PEAK':       ['Sikhara'],
  'R-PACKET':     ['Grahaka'],
  'R-Z':          ['Grahaka'],
  'R-TWOPACKET':  ['Grahaka'],
  'R-SCHUR':      ['DviSthana'],
  'N-PRESSURE':   ['PidaMatra', 'BhramaMatra'],
  'N-LEAK4':      ['SmrtiMula'],
  'R-LADDER':     ['Sopana_TheDamping'],
  'R-INVERSE':    ['Sopana_TheDamping'],
  'R-GEOMETRY':   ['ArdhaTala'],
  'R-CURVATURE':  ['ArdhaTala'],
  'R-MINORS':     ['ArdhaTala'],
}
# native modules from this branch not mapped onto a received claim
UNMAPPED = ['AdrsyaMana', 'SamaVrddhi', 'DvitiyaAntara', 'VyarthaCakra']

g = json.load(open(RECEIVED))
g['title'] = g['title'] + ' — live copy with native repository loci'
g['received_graph'] = 'research/handoff_20260908/CLAIM_GRAPH.json'
g['native_records'] = 'research/NATIVE_RECORDS.md'
g['updated'] = datetime.date.today().isoformat()
byid = {n['id']: n for n in g['nodes']}
for cid, mods in NATIVE.items():
    n = byid[cid]
    n.setdefault('history', []).append({'received_repository_loci': list(n['repository_loci']),
                                        'received_native_verification': n['native_verification_this_transfer']})
    for m in mods:
        p = locus(m)
        if p not in n['repository_loci']:
            n['repository_loci'].append(p)
    n['native_verification_this_transfer'] = True
    n['native_scope'] = 'ring/algebra core checked in --safe Cubical Agda; analytic hypotheses remain module parameters'
g['unmapped_native_modules'] = [locus(m) for m in UNMAPPED]
json.dump(g, open(OUT, 'w'), indent=1, ensure_ascii=False)
print('wrote', OUT, 'nodes with native loci:', sum(1 for n in g['nodes'] if n['native_verification_this_transfer']))
