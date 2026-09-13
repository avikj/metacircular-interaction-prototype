"""Exact algebra checks supporting the accompanying mathematical derivations.
No zeta zero computation, RH certificate, NS continuation, or proof-assistant build.
"""
import sympy as s

checks = []
def check(name, expr):
    if isinstance(expr, s.MatrixBase):
        ok = all(s.simplify(x) == 0 for x in expr)
    else:
        ok = s.simplify(expr) == 0
    assert ok, (name, expr)
    checks.append(name)

# The existing tilted triangular packet.
x = s.symbols('x', real=True)
a = s.symbols('a', positive=True)
H = (s.integrate(16*x*s.exp(-a*x), (x, 0, s.Rational(1,4)))
     + s.integrate(16*(s.Rational(1,2)-x)*s.exp(-a*x),
                   (x, s.Rational(1,4), s.Rational(1,2))))
check('tilted packet Laplace transform',
      H - 16*(1-s.exp(-a/4))**2/a**2)

# Q is linear in its first argument. Its two-basis entries are (0,c;conj(c),M).
p, q = s.symbols('p q', real=True)
M = s.symbols('M', positive=True)
c = p+s.I*q
beta = -c/M
value = s.conjugate(beta)*c + beta*s.conjugate(c) + M*beta*s.conjugate(beta)
check('exact negative continuation vector', value+(p*p+q*q)/M)
G = s.Matrix([[0,c],[s.conjugate(c),M]])
check('negative two-packet determinant', G.det()+p*p+q*q)

# Nullity-to-negative-index block congruence, a fully symbolic 2x2 Hermitian D.
d0,d1,d2,d3 = s.symbols('d0 d1 d2 d3', real=True)
D = s.Matrix([[d0,d1+s.I*d2],[d1-s.I*d2,d3]])
I=s.eye(2); Z=s.zeros(2)
B = Z.row_join(I).col_join(I.row_join(D))
T = I.row_join(-D/2).col_join(Z.row_join(I))
J = Z.row_join(I).col_join(I.row_join(Z))
check('nullity block exact congruence', T.H*B*T-J)
check('balanced-signature block diagonalization',
      (I.row_join(I).col_join(I.row_join(-I))).T * J *
      (I.row_join(I).col_join(I.row_join(-I)))
      - s.diag(2,2,-2,-2))

# Pointwise strain/vorticity/determinant identity.
s0,s1,s2,s01,s02,s12 = s.symbols('s0 s1 s2 s01 s02 s12')
w0,w1,w2 = s.symbols('w0 w1 w2')
S=s.Matrix([[s0,s01,s02],[s01,s1,s12],[s02,s12,s2]])
w=s.Matrix([w0,w1,w2])
Omega=s.Matrix([[0,-w2,w1],[w2,0,-w0],[-w1,w0,0]])/2
check('det(S+Omega) = det S + omega.S.omega/4',
      (S+Omega).det()-S.det()-(w.T*S*w)[0]/4)

# Piola cancellation checked with arbitrary differentiable symbolic functions.
y,z = s.symbols('y z', real=True)
coords=(x,y,z)
u=s.Matrix([s.Function(f'u{i}')(*coords) for i in range(3)])
A=u.jacobian(coords)
C=A.cofactor_matrix()
for i in range(3):
    check(f'Piola row {i}', sum(s.diff(C[i,j],coords[j]) for j in range(3)))
check('cofactor homogeneity', sum(A[i,j]*C[i,j] for i in range(3) for j in range(3))-3*A.det())
Jflux=C.T*u
check('div(cof(grad u)^T u) = 3 det(grad u)',
      sum(s.diff(Jflux[j],coords[j]) for j in range(3))-3*A.det())

print(f'{len(checks)} exact symbolic checks passed:')
for name in checks:
    print('PASS:',name)
print('These checks do not verify the analytic continuation, zero-density, operator-domain,')
print('or infinite-dimensional parts of the mathematical arguments.')
