"""The all-certified-history prefix closure is necessarily infinite."""

from runtime.execute.rewrite import apply_rule, rule_from_axiom
from runtime.kernel import check as C
from runtime.kernel import term as T
from runtime.prefix_closure import certified_return_paths


def test_one_installed_equality_forces_unbounded_prefix_histories():
    z = T.base_sort("PrefixClosureZ")
    zz = T.arrow(z, z)
    f = T.Const("prefix.f", zz)
    a = T.Const("prefix.a", z)
    fa = T.App(f, a)

    ctx = C.CheckContext()
    ctx.declare_axiom("prefix.step", a, fa)
    rule = rule_from_axiom(ctx, "prefix.step")
    rewrite = apply_rule(a, rule, "fwd", (), ctx)
    assert rewrite is not None

    histories = certified_return_paths(rewrite.path, ctx)
    first = [next(histories) for _ in range(6)]
    assert [len(path) for path in first] == [2, 4, 6, 8, 10, 12]
    assert all(C.check_path(path, a.addr, a.addr, ctx) for path in first)


def test_unchecked_path_cannot_generate_closure():
    z = T.base_sort("PrefixClosureControlZ")
    a = T.Const("prefix.control.a", z)
    b = T.Const("prefix.control.b", z)
    forged = (C.Step(a.addr, b.addr, "assumption", C.Axiom("absent")),)
    try:
        next(certified_return_paths(forged, C.CheckContext()))
    except ValueError:
        pass
    else:
        raise AssertionError("unchecked path entered prefix closure")

