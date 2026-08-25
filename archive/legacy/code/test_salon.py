import tempfile
import unittest
from pathlib import Path

from salon import content_id, validate


def node(kind="utterance", artifacts=None, lens=None):
    n = {"kind": kind, "agent": "tester", "text": "exact text", "artifacts": artifacts or []}
    if lens: n["lens"] = lens
    n["id"] = content_id(n)
    return n


class SalonTests(unittest.TestCase):
    def test_valid_branch_resumption(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); (root / "proof.txt").write_text("witness")
            q = node("question"); c = node("construction", ["proof.txt"])
            rec = {"nodes": [q, c], "edges": [{"kind": "responds_to", "from": c["id"], "to": q["id"]}],
                   "branches": [{"id": "b", "parent": None, "head": c["id"]}],
                   "resumptions": [{"branch": "b", "from_head": q["id"], "new_head": c["id"], "resume_note": "continue proof"}]}
            self.assertEqual(validate(rec, root), [])

    def test_math_without_artifact_rejected(self):
        c = node("construction")
        self.assertTrue(any("requires an artifact" in e for e in validate({"nodes": [c]}, Path("."))))

    def test_tamper_rejected(self):
        q = node(); q["text"] = "changed"
        self.assertTrue(any("content id mismatch" in e for e in validate({"nodes": [q]}, Path("."))))

    def test_false_persona_attribution_rejected(self):
        q = node(lens={"name": "Voevodsky-inspired", "provenance": "historical"})
        self.assertTrue(any("disclaim" in e for e in validate({"nodes": [q]}, Path("."))))

    def test_multiple_lenses_one_agent(self):
        provenance = "simulated-methodological-influence-not-historical"
        a = node(lens={"name": "Voevodsky-inspired", "provenance": provenance})
        b = node(lens={"name": "Peirce-inspired", "provenance": provenance})
        rec = {"nodes": [a, b], "edges": [{"kind": "objects_to", "from": b["id"], "to": a["id"]}]}
        self.assertEqual(validate(rec, Path(".")), [])

    def test_dangling_edge_rejected(self):
        q = node()
        errors = validate({"nodes": [q], "edges": [{"kind": "depends_on", "from": q["id"], "to": "missing"}]}, Path("."))
        self.assertTrue(any("dangling" in e for e in errors))

    def test_attention_is_indexical_not_evidence(self):
        a = node("attention")
        a.update({"status": "open", "forbidden_conclusions": ["do not infer adequacy"]})
        a["id"] = content_id(a)
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); (root / "proof.txt").write_text("proof")
            c = node("construction", ["proof.txt"])
            rec = {"nodes": [a, c], "edges": [{"kind": "depends_on", "from": c["id"], "to": a["id"]}]}
            self.assertTrue(any("cannot support mathematics" in e for e in validate(rec, root)))

    def test_formation_pressure_requires_model_and_kind(self):
        p = node("formation_pressure")
        errors = validate({"nodes": [p]}, Path("."))
        self.assertTrue(any("pressure" in e for e in errors))
        self.assertTrue(any("model_ref" in e for e in errors))


if __name__ == "__main__": unittest.main()
