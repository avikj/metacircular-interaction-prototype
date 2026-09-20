# a system whose branches DISAGREE on their overlap is rejected
def clash(i: Interval, x: Bool, y: Bool) -> Partial(i1, Bool):
  system([(i1, x), (i1, y)])
# a system that does NOT cover the face is rejected
def gap(A: Set, i: Interval, x: A) -> Partial(i1, A):
  system([(i, x)])
# pout where the face is not true is rejected
def early(A: Set, i: Interval, x: A) -> A:
  pout(system([(i, x)]))
