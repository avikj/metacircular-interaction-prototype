# a copyable proof function (into an equation, over a Data domain) may not
# take the datatype it is a field of: that is the omega attack, refused
import Base

type T is Data:
  mk{f: @w: T -> {w == w : T}}

#|Error:
#|- expected : a positive occurrence of T (a copyable proof function may not take the family it lives in)
#|- observed : @w:T -> {w == w : T}
#|Location: mk
#|5 | type T is Data:
#|6>|   mk{f: @w: T -> {w == w : T}}
#|7 | 
#|exit 1
