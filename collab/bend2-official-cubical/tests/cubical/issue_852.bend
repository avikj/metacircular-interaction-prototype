# #852: a nat-literal pattern is checked against its constructor's arity,
# so no non-decreasing self-call slips past it and no closed term
# inhabits Empty
type U is Data:
  Un{}

type N is Data:
  Zero{w: U}
  Succ{p: N}

type D is Data:
  K{z: N}

type Empty is Data:

def f(b: N) -> Empty:
  match b:
    case U32.to_nat(0):
      {\{K: q => w => f(q)} : D -> U -> Empty}(K{Zero{Un{}}})
    case Succ{p}:
      f(p)

def boom() -> Empty:
  f(Zero{Un{}})
#|Error:
#|- message  : a Zero pattern with 1 field
#|Location:
#|17 |   match b:
#|18>|     case U32.to_nat(0):
#|19 |       {\{K: q => w => f(q)} : D -> U -> Empty}(K{Zero{Un{}}})
#|exit 1
