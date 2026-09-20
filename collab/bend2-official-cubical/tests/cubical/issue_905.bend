# #905: two ~ binders of one name are two opaque constants, not one: the
# cast through them is refused where it is written
type Empty is Data:

type Bit is Data:
  False{}
  True{}

def cast(~T: Type, ~x: T, ~T: Type) -> T:
  x

type Bad is Type:
  MkBad{apply: @+x: cast(~Type, ~Bad, ~Data) -> Empty}

def Bad.apply(b: Bad) -> (@+x: cast(~Type, ~Bad, ~Data) -> Empty):
  match b:
    case MkBad{f}:
      f

def step(+b: cast(~Type, ~Bad, ~Data)) -> Empty:
  Bad.apply(b)(MkBad{Bad.apply(b)})

def boom() -> Empty:
  step(MkBad{step})

def absurd(-A: Type, e: Empty) -> A:
  match e:

def false_theorem() -> {False{} == True{} : Bit}:
  absurd({False{} == True{} : Bit}, boom())
#|Error:
#|- expected : cast~2~T
#|- observed : cast~T
#|Location: cast
#| 9 | def cast(~T: Type, ~x: T, ~T: Type) -> T:
#|10>|   x
#|11 |
#|exit 1
