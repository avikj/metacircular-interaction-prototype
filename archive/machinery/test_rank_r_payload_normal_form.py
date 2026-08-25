import unittest
from itertools import product

from rank_r_payload_normal_form import (
    add,
    assemble,
    conj_flag,
    coords_valid,
    corner_partner,
    diff_coords,
    exists_integral_left_partner,
    extract,
    group_identity,
    group_inverse,
    group_law,
    identity,
    k_side_member,
    mul,
    neg,
    payload,
    replay,
    section_change,
)
from mixed_rank_smith_stabilizer import (
    blocks,
    exists_integral_partner,
    h_side_member,
    mixed_diag,
    two_sided_stabilizes,
)
from flag_congruence_smith_stabilizer import (
    det,
    in_flag_gamma0_congruence,
    inverse_unimodular,
    mat_mul,
)

N = 3
FLAGS = ((2,), (2, 4))  # r = 1 and r = 2 at n = 3, nontrivial divisors


def unimodular(size):
    out = []
    for entries in product((-1, 0, 1), repeat=size * size):
        m = tuple(entries[i * size:(i + 1) * size] for i in range(size))
        if abs(det(m)) == 1:
            out.append(m)
    return out


U3 = unimodular(3)
UNI = {1: unimodular(1), 2: unimodular(2)}


def blocks_window(rows, cols):
    return [
        tuple(entries[i * cols:(i + 1) * cols] for i in range(rows))
        for entries in product((-1, 0, 1), repeat=rows * cols)
    ]


def coords_window(flag):
    r = len(flag)
    s = N - r
    gamma = [a for a in UNI[r] if in_flag_gamma0_congruence(a, flag)]
    return [
        (a, b, e, rr, ss)
        for a in gamma
        for b in blocks_window(r, s)
        for e in UNI[s]
        for rr in blocks_window(s, r)
        for ss in UNI[s]
    ]


def stride(seq, count):
    step = max(1, len(seq) // count)
    return seq[::step]


# Explicit rank-deficient M = PM D QM with unimodular PM, QM; the base
# event is (PM^-1, QM^-1).
PM = ((1, 1, 0), (0, 1, 1), (0, 0, 1))
QM = ((1, 0, 0), (2, 1, 0), (0, 1, 1))


def base_data(flag):
    d = mixed_diag(flag, N)
    m = mat_mul(mat_mul(PM, d), QM)
    u0 = inverse_unimodular(PM)
    v0 = inverse_unimodular(QM)
    assert mat_mul(mat_mul(u0, m), v0) == d
    return d, m, u0, v0


# Nontrivial section-change coordinates g = (a, b, e, rho, sigma).
G_COORDS = {
    (2,): (((-1,),), ((1, -1),), ((0, 1), (1, 0)),
           ((1,), (-1,)), ((1, 1), (0, 1))),
    (2, 4): (((1, 1), (0, 1)), ((1,), (-1,)), ((-1,),),
             ((1, -1),), ((-1,),)),
}


class CoordinateBijectionTest(unittest.TestCase):
    """Theorem 1: (A,B,E,R,S) <-> Stab^2(D), full window at n = 3."""

    def test_h_window_membership_iff_integral_partner(self):
        """Full H window: H extends to a stabilizing pair iff it has
        the H-side normal form (no integral K exists otherwise, which
        certifies exclusion beyond any K window)."""
        for flag in FLAGS:
            for h in U3:
                self.assertEqual(
                    h_side_member(h, flag),
                    exists_integral_partner(h, flag, N),
                    (h, flag),
                )

    def test_k_window_membership_iff_integral_left_partner(self):
        """Full K window: mirror statement for the K side."""
        for flag in FLAGS:
            for k in U3:
                self.assertEqual(
                    k_side_member(k, flag),
                    exists_integral_left_partner(k, flag, N),
                    (k, flag),
                )

    def test_member_pairs_stabilize_iff_corners_matched(self):
        """All member x member pairs: H D K = D iff the K corner is
        exactly D_r^-1 A^-1 D_r.  With the two exclusion tests above
        this is the full-window iff of Theorem 1."""
        for flag in FLAGS:
            r = len(flag)
            d = mixed_diag(flag, N)
            hs = [h for h in U3 if h_side_member(h, flag)]
            ks = [k for k in U3 if k_side_member(k, flag)]
            self.assertGreater(len(hs), 100)
            self.assertGreater(len(ks), 100)
            for h in hs:
                hd = mat_mul(h, d)
                predicted = corner_partner(blocks(h, r)[0], flag)
                for k in ks:
                    self.assertEqual(
                        mat_mul(hd, k) == d,
                        blocks(k, r)[0] == predicted,
                        (h, k, flag),
                    )

    def test_assemble_extract_roundtrip_full_coordinate_window(self):
        """Every coordinate tuple over the {-1,0,1} window assembles to
        a stabilizing pair and extracts back to itself (injectivity +
        well-definedness); extraction of any stabilizing member pair
        re-assembles to the same matrices (surjectivity)."""
        for flag in FLAGS:
            window = coords_window(flag)
            self.assertGreater(len(window), 1000)
            for coords in window:
                self.assertTrue(coords_valid(coords, flag, N))
                h, k = assemble(coords, flag, N)
                self.assertTrue(two_sided_stabilizes(h, k, flag, N))
                self.assertEqual(extract(h, k, flag, N), coords)
                self.assertEqual(assemble(extract(h, k, flag, N),
                                          flag, N), (h, k))


class GroupLawTest(unittest.TestCase):
    """Theorem 2: the coordinate group law, K side opposite."""

    def test_group_law_matches_matrix_product(self):
        """(H,K)*(H',K') = (HH', K'K) stabilizes, and its coordinates
        are (AA', AB'+BE', EE', R' D_r^-1 A^-1 D_r + S'R, S'S)."""
        for flag in FLAGS:
            sample = stride(coords_window(flag), 24)
            for x in sample:
                hx, kx = assemble(x, flag, N)
                for y in sample:
                    hy, ky = assemble(y, flag, N)
                    h, k = mat_mul(hx, hy), mat_mul(ky, kx)
                    self.assertTrue(two_sided_stabilizes(h, k, flag, N))
                    self.assertEqual(extract(h, k, flag, N),
                                     group_law(x, y, flag))

    def test_componentwise_k_product_stabilizes_iff_corners_commute(self):
        """Negative control (Lemma 0 remark): the componentwise product
        (HH', KK') stabilizes iff the corners commute, AA' = A'A.  At
        r = 1 corners are scalars, so it always does; at r = 2 the
        window contains non-commuting corners and it genuinely fails --
        the opposite convention on the K side is forced."""
        for flag in FLAGS:
            sample = stride(coords_window(flag), 12)
            broken = 0
            for x in sample:
                hx, kx = assemble(x, flag, N)
                for y in sample:
                    hy, ky = assemble(y, flag, N)
                    ok = two_sided_stabilizes(
                        mat_mul(hx, hy), mat_mul(kx, ky), flag, N)
                    self.assertEqual(
                        ok, mul(x[0], y[0]) == mul(y[0], x[0]), flag)
                    if not ok:
                        broken += 1
            if len(flag) == 1:
                self.assertEqual(broken, 0, flag)
            else:
                self.assertGreater(broken, 0, flag)

    def test_identity_and_inverse(self):
        for flag in FLAGS:
            ident = group_identity(flag, N)
            self.assertEqual(assemble(ident, flag, N),
                             (identity(N), identity(N)))
            for x in stride(coords_window(flag), 200):
                xi = group_inverse(x, flag)
                self.assertTrue(coords_valid(xi, flag, N))
                self.assertEqual(group_law(x, xi, flag), ident)
                self.assertEqual(group_law(xi, x, flag), ident)
                self.assertEqual(group_law(x, ident, flag), x)
                self.assertEqual(group_law(ident, x, flag), x)
                # inverse in coordinates = componentwise matrix inverse
                h, k = assemble(x, flag, N)
                self.assertEqual(
                    assemble(xi, flag, N),
                    (inverse_unimodular(h), inverse_unimodular(k)),
                )


class PayloadNormalFormTest(unittest.TestCase):
    """Theorem 3: events over a rank-deficient M form a torsor with
    unique coordinates and explicit recovery/replay."""

    def test_event_replay_roundtrip(self):
        for flag in FLAGS:
            d, m, u0, v0 = base_data(flag)
            self.assertEqual(payload(u0, v0, u0, v0, flag, N),
                             group_identity(flag, N))
            for coords in stride(coords_window(flag), 300):
                u, v = replay(coords, u0, v0, flag, N)
                self.assertEqual(mat_mul(mat_mul(u, m), v), d)
                self.assertEqual(payload(u, v, u0, v0, flag, N), coords)

    def test_full_u_window_onto(self):
        """Every unimodular U in the window is the U-side of an event
        iff U U0^-1 has the H normal form (exclusion is certified over
        ALL integral V); when it is, the recovered (A,B,E) are the
        blocks of U U0^-1 and any tail choice completes the event."""
        for flag in FLAGS:
            r = len(flag)
            d, m, u0, v0 = base_data(flag)
            u0_inv = inverse_unimodular(u0)
            completable = 0
            for u in U3:
                h = mul(u, u0_inv)
                member = h_side_member(h, flag)
                self.assertEqual(member,
                                 exists_integral_partner(h, flag, N))
                if not member:
                    continue
                completable += 1
                a, b, _, e = blocks(h, r)
                s = N - r
                tails = (tuple((0,) * r for _ in range(s)),
                         tuple(tuple(1 if i == j else 0
                                     for j in range(s))
                               for i in range(s)))
                coords = (a, b, e) + tails
                u2, v = replay(coords, u0, v0, flag, N)
                self.assertEqual(u2, u)
                self.assertEqual(mat_mul(mat_mul(u, m), v), d)
                self.assertEqual(payload(u, v, u0, v0, flag, N), coords)
            self.assertGreater(completable, 100)


class SectionTransformationTest(unittest.TestCase):
    """Theorems 4 and 5: exact transformation law under base change,
    and the section-independent difference coordinates."""

    def new_base(self, g_coords, u0, v0, flag):
        gh, gk = assemble(g_coords, flag, N)
        return (mul(inverse_unimodular(gh), u0),
                mul(v0, inverse_unimodular(gk)), gh, gk)

    def test_transformation_law_per_coordinate(self):
        for flag in FLAGS:
            d, m, u0, v0 = base_data(flag)
            g = G_COORDS[flag]
            self.assertTrue(coords_valid(g, flag, N))
            a_g, b_g, e_g, rho, sigma = g
            u0n, v0n, gh, gk = self.new_base(g, u0, v0, flag)
            # the new base is itself an event, and g is its old payload
            self.assertEqual(mat_mul(mat_mul(u0n, m), v0n), d)
            self.assertEqual(mul(u0, inverse_unimodular(u0n)), gh)
            self.assertEqual(mul(inverse_unimodular(v0n), v0), gk)
            changed = [False] * 5
            for coords in stride(coords_window(flag), 200):
                u, v = replay(coords, u0, v0, flag, N)
                new = payload(u, v, u0n, v0n, flag, N)
                self.assertEqual(new, section_change(coords, g, flag))
                a, b, e, r_blk, s_blk = coords
                expected = (
                    mul(a, a_g),
                    add(mul(a, b_g), mul(b, e_g)),
                    mul(e, e_g),
                    add(mul(rho, corner_partner(a, flag)),
                        mul(sigma, r_blk)),
                    mul(sigma, s_blk),
                )
                self.assertEqual(new, expected)
                for i in range(5):
                    if new[i] != coords[i]:
                        changed[i] = True
            # no single coordinate is section-independent: this one
            # base change moves every coordinate somewhere
            self.assertEqual(changed, [True] * 5, flag)

    def test_differences_section_independent(self):
        for flag in FLAGS:
            d, m, u0, v0 = base_data(flag)
            g = G_COORDS[flag]
            u0n, v0n, _, _ = self.new_base(g, u0, v0, flag)
            sample = stride(coords_window(flag), 16)
            for x in sample:
                ux, vx = replay(x, u0, v0, flag, N)
                for y in sample:
                    uy, vy = replay(y, u0, v0, flag, N)
                    old_x = payload(ux, vx, u0, v0, flag, N)
                    old_y = payload(uy, vy, u0, v0, flag, N)
                    new_x = payload(ux, vx, u0n, v0n, flag, N)
                    new_y = payload(uy, vy, u0n, v0n, flag, N)
                    delta = diff_coords(old_x, old_y, flag)
                    self.assertEqual(delta,
                                     diff_coords(new_x, new_y, flag))
                    # closed form of Theorem 5(ii)
                    ax, bx, ex, rx, sx = old_x
                    ay, by, ey, ry, sy = old_y
                    ayi = inverse_unimodular(ay)
                    eyi = inverse_unimodular(ey)
                    syi = inverse_unimodular(sy)
                    axi = inverse_unimodular(ax)
                    self.assertEqual(delta, (
                        mul(ax, ayi),
                        mul(add(bx, neg(mul(mul(ax, ayi), by))), eyi),
                        mul(ex, eyi),
                        mul(syi, add(rx, neg(mul(ry, conj_flag(
                            mul(ay, axi), flag))))),
                        mul(syi, sx),
                    ))
                    # matrix form: (H_x H_y^-1, K_y^-1 K_x)
                    hx, kx = assemble(old_x, flag, N)
                    hy, ky = assemble(old_y, flag, N)
                    self.assertEqual(
                        assemble(delta, flag, N),
                        (mat_mul(hx, inverse_unimodular(hy)),
                         mat_mul(inverse_unimodular(ky), kx)),
                    )


if __name__ == "__main__":
    unittest.main()
