#!/usr/bin/env python3
"""Rerunnable exact controls for the actual toroidal 2->4->2 return.

Symbolic polynomial/ODE/kernel controls are separated from numerical
consistency checks. No zeta zeros or nonlinear PDE evolutions are simulated.
Dependencies: sympy; numpy/scipy only for the optional consistency section.
"""
from __future__ import annotations
import sympy as s

checks = 0

def check(label: str, value, expected=0) -> None:
    global checks
    difference = value - expected
    if isinstance(difference, s.MatrixBase):
        ok = all(s.simplify(e) == 0 for e in difference)
    else:
        ok = s.simplify(difference) == 0
    if not ok:
        raise AssertionError(f'{label}: {s.simplify(difference)}')
    checks += 1
    print(f'EXACT {checks:02d}: {label}')

r = s.symbols('r', positive=True)
x,y,z = s.symbols('x y z', real=True)
X = s.Matrix([x,y,z])
R2=x*x+y*y+z*z

def curl(v):
    return s.Matrix([s.diff(v[2],y)-s.diff(v[1],z),
                     s.diff(v[0],z)-s.diff(v[2],x),
                     s.diff(v[1],x)-s.diff(v[0],y)])

def sphere_avg(poly):
    p=s.Poly(s.expand(poly),x,y,z)
    out=s.Integer(0)
    for powers,c in p.terms():
        if any(k % 2 for k in powers):
            continue
        numerator=s.prod(s.factorial2(k-1) for k in powers)
        out += c*numerator/s.factorial2(sum(powers)+1)
    return s.factor(out)

# Original radial kernel: positivity on a cone is not PSD.
Kmat=s.Matrix([[s.Rational(1,10),s.Rational(11,80)],
               [s.Rational(11,80),s.Rational(1,10)]])
check('two-radius positive eigenvector', Kmat*s.Matrix([1,1]),
      s.Rational(19,80)*s.Matrix([1,1]))
check('two-radius negative eigenvector', Kmat*s.Matrix([1,-1]),
      -s.Rational(3,80)*s.Matrix([1,-1]))
check('opposite radial atoms have negative quadratic value',
      (s.Matrix([1,-1]).T*Kmat*s.Matrix([1,-1]))[0],-s.Rational(3,40))
xi=s.symbols('xi',real=True)
ft=(s.Rational(1,10))*(6/(1+xi**2)-16/(16+xi**2))
check('exact log-radius Fourier multiplier',ft,
      (8-xi**2)/((1+xi**2)*(16+xi**2)))

# Outgoing source identities.
g=s.Function('g')(r); f=s.Function('f')(r)
h=s.Function('h')(r); p=s.Function('p')(r)
beta2=s.Rational(6,7)*(5*g*f+2*r*s.diff(g,r)*f+r*g*s.diff(f,r))
beta4=3*r*g*s.diff(f,r)-6*g*f-r*s.diff(g,r)*f
check('degree-two source is a weighted radial derivative',beta2,
      s.Rational(6,7)*r**(-4)/g*s.diff(r**5*g**2*f,r))
check('degree-four source is a weighted radial derivative',beta4,
      3*r**3*g**s.Rational(4,3)*s.diff(f/(r**2*g**s.Rational(1,3)),r))

# General diagonal A suffices by rotation covariance; test all five C channels.
a,b=s.symbols('a b',real=True)
A=s.diag(a,b,-a-b)
q=s.trace(A*A)
B=A*A-q*s.eye(3)/3
Y2=(X.T*A*X)[0]
H4=Y2**2-s.Rational(4,7)*R2*(X.T*B*X)[0]-s.Rational(2,15)*q*R2**2
Y4=Y2**2-s.Rational(4,7)*(X.T*B*X)[0]-s.Rational(2,15)*q
check('degree-four scalar polynomial is harmonic',sum(s.diff(H4,v,2) for v in (x,y,z)))
C2=X.cross(A*X)
C4=Y2*C2-s.Rational(2,7)*R2*X.cross(B*X)
Cs=[s.diag(1,-1,0),s.diag(1,0,-1),
    s.Matrix([[0,1,0],[1,0,0],[0,0,0]]),
    s.Matrix([[0,0,1],[0,0,0],[1,0,0]]),
    s.Matrix([[0,0,0],[0,0,1],[0,1,0]])]
for j,C in enumerate(Cs,1):
    YC=(X.T*C*X)[0]
    check(f'2x4 -> 2 scalar angular coefficient, channel {j}',
          sphere_avg(Y2*Y4*YC),s.Rational(24,245)*q*sphere_avg(Y2*YC))
check('toroidal degree-two norm',sphere_avg(C2.dot(C2)),q/5)
check('toroidal degree-four norm',sphere_avg(C4.dot(C4)),s.Rational(4,245)*q**2)

# Radial/angular derivation, including both source variations.
a2=-3*r*g; b2=-(3*r*g+r*r*s.diff(g,r))/2
a4=-5*r*p; b4=-(3*r*p+r*r*s.diff(p,r))/4
c=s.Rational(24,245)
alpha=10*c*(b2*h/4+b4*f/2)
beta=c*(-5*a2*h/12+a4*f/3)
C=15*g*h+6*r*s.diff(g,r)*h+3*r*g*s.diff(h,r)+p*f-r*s.diff(p,r)*f-4*r*p*s.diff(f,r)
check('full polarized return coefficient',2*(s.diff(r*beta,r)-alpha)/r,s.Rational(4,49)*C)
weighted=3*((3*r*g+r*r*s.diff(g,r))*h+(3*r*p+r*r*s.diff(p,r))*f)
check('integrated return has exact radial boundary term',r*C-weighted,
      s.diff(3*r*r*g*h-4*r*r*p*f,r))
central=15*g*h/r+3*s.diff(g,r)*h+p*f/r+3*s.diff(p,r)*f
check('instantaneous central return boundary term',C/r-central,s.diff(3*g*h-4*p*f,r))

# Direct Cartesian check, no spherical-curl formulas used in this calculation.
# Polynomial controls validate finite algebra, not decay of these test fields.
for A0 in [s.diag(-s.Rational(1,2),-s.Rational(1,2),1),s.diag(1,2,-3)]:
    q0=s.trace(A0*A0); B0=A0*A0-q0*s.eye(3)/3
    P2=X.cross(A0*X)
    P4=(X.T*A0*X)[0]*P2-s.Rational(2,7)*R2*X.cross(B0*X)
    u2=curl(R2*P2)    # g=r^2; f=-14r^2
    u4=curl(R2*P4)    # p=r^4; h=-22r^4
    omega2=curl(u2);omega4=curl(u4)
    ret=curl(u2.cross(omega4)+u4.cross(omega2))
    scalar=s.Rational(4,49)*q0*(39*(-22)+(-11)*(-14))
    for j,C0 in enumerate(Cs,1):
        TC=X.cross(C0*X)
        check(f'direct Cartesian return A={list(A0.diagonal())}, channel {j}',
              sphere_avg(ret.dot(TC)),scalar*sphere_avg(P2.dot(TC)))

# Green functions and exact return-memory kernel.
sr,tr=s.symbols('sr tr',positive=True)
g_in=1/(5*sr); g_out=sr**4/(5*r**5)
p_in=r**2/(9*tr**3);p_out=tr**6/(9*r**7)
for lab,gg in [('inside',g_in),('outside',g_out)]:
    check(f'quadrupole radial Green ODE {lab}',s.diff(gg,r,2)+6*s.diff(gg,r)/r)
for lab,pp in [('inside',p_in),('outside',p_out)]:
    check(f'degree-four radial Green ODE {lab}',s.diff(pp,r,2)+6*s.diff(pp,r)/r-14*pp/r**2)
check('quadrupole derivative jump',s.diff(g_out,r).subs(r,sr)-s.diff(g_in,r).subs(r,sr),-1/sr**2)
check('degree-four derivative jump',s.diff(p_out,r).subs(r,tr)-s.diff(p_in,r).subs(r,tr),-1/tr**2)
L_outer=(3*r*g_in+r*r*s.diff(g_in,r)).subs(r,tr)+(3*r*p_out+r*r*s.diff(p_out,r)).subs(r,sr)
L_inner=(3*r*g_out+r*r*s.diff(g_out,r)).subs(r,tr)+(3*r*p_in+r*r*s.diff(p_in,r)).subs(r,sr)
expected_outer=s.Rational(3,5)*tr/sr-s.Rational(4,9)*(tr/sr)**6
expected_inner=s.Rational(5,9)*(sr/tr)**3-s.Rational(2,5)*(sr/tr)**4
check('return-memory kernel, quadrupole outside fourth-degree shell',L_outer,expected_outer)
check('return-memory kernel, quadrupole inside fourth-degree shell',L_inner,expected_inner)
check('return kernel diagonal',L_outer.subs(tr,sr),s.Rational(7,45))
check('return kernel diagonal continuity',(L_outer-L_inner).subs(tr,sr))
check('outer-side diagonal slope',s.diff(L_outer,tr).subs(tr,sr)*sr,-s.Rational(31,15))
check('inner-side diagonal slope',s.diff(L_inner,tr).subs(tr,sr)*sr,-s.Rational(1,15))

# Same-source scalar memory identity.
W=s.Function('W')(r)
ibp=-( (9*g+4*r*s.diff(g,r))*W+3*r*g*s.diff(W,r))*f
check('same-source return integral boundary identity',beta4*W-ibp,
      s.diff(3*r*g*W*f,r))

# Source derivative bound used in the total-variation stack estimate.
hprime_reduced=(r*s.diff(beta4,r)).subs(s.diff(g,r,2),-6*s.diff(g,r)/r-f/r**2)
hprime_target=-3*r*g*s.diff(f,r)+2*r*r*s.diff(g,r)*s.diff(f,r)+3*r*r*g*s.diff(f,r,2)-r*s.diff(g,r)*f+f*f
check('radial outgoing derivative after the actual inverse ODE',hprime_reduced,hprime_target)

# Exact broad-profile sign control.
g0=(1+r*r)**(-2)
f0=s.factor(-r*r*s.diff(g0,r,2)-6*r*s.diff(g0,r))
h0=s.factor(3*r*g0*s.diff(f0,r)-6*g0*f0-r*s.diff(g0,r)*f0)
check('positive broad starting profile',f0,4*r*r*(r*r+7)/(1+r*r)**4)
check('negative degree-four injection for broad profile',h0,-8*r**4*(7*r*r+67)/(1+r*r)**7)

# Thin-shell exact asymptotic coefficient.
F=s.symbols('F',real=True)
lim_integrand=-((s.Rational(9,5)-4*F)*s.Rational(7,45)
                +s.Rational(3,5)*(-s.Rational(31,15)+2*F))
check('thin-shell limiting integrand',lim_integrand,s.Rational(24,25)-s.Rational(26,45)*F)
check('thin-shell limiting return value',s.integrate(lim_integrand,(F,0,1)),s.Rational(151,225))

j=s.symbols('j',integer=True,positive=True)
check('all cross-shell geometric return-memory sum',s.summation(j*j/16**j,(j,1,s.oo)),s.Rational(272,3375))

# Retained RH orientation control.
sigma,gamma,tt=s.symbols('sigma gamma tt',real=True)
U=s.diag(s.exp(-(sigma+s.I*gamma)*tt),s.exp(-(-sigma+s.I*gamma)*tt))
J=s.Matrix([[0,1],[1,0]])
H=J*U*J*U.inv()
check('RH reflection-scale loop orientation',H,s.diag(s.exp(2*sigma*tt),s.exp(-2*sigma*tt)))
check('RH loop is reciprocal metric defect',H,(s.conjugate(U).T*U).inv())
check('RH bidirectional positive defect',s.exp(2*sigma*tt)+s.exp(-2*sigma*tt)-2,4*s.sinh(sigma*tt)**2)
print(f'\nTOTAL: {checks} exact symbolic controls passed.')

# Numerical consistency checks, distinct from the proofs by signs/asymptotics.
def numerical_controls():
    import numpy as np
    from scipy.integrate import cumulative_trapezoid, trapezoid
    zgrid=np.linspace(-1,1,40001)
    phi=np.zeros_like(zgrid)
    middle=np.abs(zgrid)<1
    phi[middle]=np.exp(-1/(1-zgrid[middle]**2))
    phi/=trapezoid(phi,zgrid)
    for eps in [0.02,0.005,0.001]:
        rad=1+eps*zgrid
        # All integrals below are against f_epsilon dr = phi(z) dz.
        def lower(v):return cumulative_trapezoid(v,zgrid,initial=0)
        def upper(v):return -cumulative_trapezoid(v[::-1],zgrid[::-1],initial=0)[::-1]
        I4=lower(rad**4*phi);I3=lower(rad**3*phi)
        T1=upper(phi/rad);T6=upper(phi/rad**6)
        gg=(rad**-5*I4+T1)/5
        gp=-rad**-6*I4
        ww=3*rad*gg+rad**2*gp+(5/9)*rad**-3*I3-(4/9)*rad**6*T6
        wp=3*gg-rad*gp-(5/3)*rad**-4*I3-(8/3)*rad**5*T6
        val=-trapezoid(phi*((9*gg+4*rad*gp)*ww+3*rad*gg*wp),zgrid)
        if not val>0:raise AssertionError('thin-shell sign consistency failed')
        print(f'NUMERICAL: compact C-infinity thin shell eps={eps:g}, J24={val:.12g}; limit 151/225={151/225:.12g}')
    rad=np.exp(np.linspace(-12,12,100001))
    ff=4*rad**2*(rad**2+7)/(1+rad**2)**4
    hh=-8*rad**4*(7*rad**2+67)/(1+rad**2)**7
    gg=(1+rad**2)**-2; gp=-4*rad*(1+rad**2)**-3
    I3=cumulative_trapezoid(rad**3*ff,rad,initial=0)
    T6=-cumulative_trapezoid((ff/rad**6)[::-1],rad[::-1],initial=0)[::-1]
    ww=3*rad*gg+rad**2*gp+(5/9)*rad**-3*I3-(4/9)*rad**6*T6
    val=trapezoid(ww*hh,rad)
    if not val<0:raise AssertionError('broad-profile sign consistency failed')
    print(f'NUMERICAL: broad profile J24={val:.12g}<0')
    print('TOTAL: 4 numerical consistency checks passed; no PDE evolution was simulated.')

if __name__ == '__main__':
    numerical_controls()
