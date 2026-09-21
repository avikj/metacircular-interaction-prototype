# the interval is the free De Morgan algebra: the De Morgan laws and the
# lattice laws hold by conversion, and the Boolean law i /\ -i == i0 does
# not (a two-valued table would accept it; DM4 refuses it)
import Base

def dm(-i: Interval, -j: Interval) -> {-(i /\ j) == -i \/ -j : Interval}:
  {==}

def idem(-i: Interval) -> {i /\ i == i : Interval}:
  {==}

def absorb(-i: Interval, -j: Interval) -> {i \/ (i /\ j) == i : Interval}:
  {==}

def invol(-i: Interval) -> {--i == i : Interval}:
  {==}

def bad(-i: Interval) -> {i /\ -i == i0 : Interval}:
  {==}

def main() -> Unit:
  Unit{}
#|Error:
#|- expected : i /\ -i
#|- observed : i0
#|Context:
#|- i : Interval
#|Location: bad
#|18 | def bad(-i: Interval) -> {i /\ -i == i0 : Interval}:
#|19>|   {==}
#|20 |
#|exit 1
