# Port of Kernel/TheInstalledOperationHasNoPervasionSoTheKernelMemorises.agda, section 3.
# An installed equation applies at every witnessed substitution of its lhs.
# The witness remains available; equal emissions do not identify substitutions.
import RewriteCertificate

type SchematicOperation:
  case @schema:
    lhs: Tm
    rhs: Tm
    meaning: all r: Env. Path(Nat, eval(lhs, r), eval(rhs, r))

def schemaLhs(o: SchematicOperation) -> Tm:
  match o: case @schema{lhs, rhs, meaning}: lhs
def schemaRhs(o: SchematicOperation) -> Tm:
  match o: case @schema{lhs, rhs, meaning}: rhs

def schemaControl(o: SchematicOperation, t: Tm) -> Set:
  any u: Tm. Path(Tm, t, subVar(u, schemaLhs(o)))

def schemaApply(o: SchematicOperation, t: Tm, c: schemaControl(o, t)) -> Tm:
  match c: case (u, p): subVar(u, schemaRhs(o))

def schemaApplySound(o: SchematicOperation, t: Tm, c: schemaControl(o, t), r: Env) -> Path(Nat, eval(t, r), eval(schemaApply(o, t, c), r)):
  match o:
    case @schema{lhs, rhs, meaning}:
      match c:
        case (u, p):
          compPath(Nat, eval(t, r), eval(subVar(u, lhs), r), eval(subVar(u, rhs), r),
            <i> eval(p @ i, r),
            compPath(Nat, eval(subVar(u, lhs), r), eval(lhs, setX(eval(u, r), r)), eval(subVar(u, rhs), r),
              eval_subVar(u, lhs, r),
              compPath(Nat, eval(lhs, setX(eval(u, r), r)), eval(rhs, setX(eval(u, r), r)), eval(subVar(u, rhs), r),
                meaning(setX(eval(u, r), r)), <i> eval_subVar(u, rhs, r) @ inot(i))))

def schemaInstance(o: SchematicOperation, u: Tm) -> schemaControl(o, subVar(u, schemaLhs(o))):
  (u, <_> subVar(u, schemaLhs(o)))

# Existing checked derivations install without an external acceptance gate.
def installSchema(lhs: Tm, rhs: Tm, d: Derivation(lhs, rhs)) -> SchematicOperation:
  @schema{lhs, rhs, lambda r. derivation_sound(lhs, rhs, d, r)}

def installInductionSchema(lhs: Tm, rhs: Tm, c: InductionCertificate(lhs, rhs)) -> SchematicOperation:
  @schema{lhs, rhs, lambda r. induction_sound(lhs, rhs, c, r)}

def plusOneSchema() -> SchematicOperation:
  installSchema(@add{@var, @suc{@zero}}, @suc{@var}, accepted())

# Both contexts from the Agda separation result use the same installed law.
def schemaZero() -> Path(Tm, schemaApply(plusOneSchema(), @add{@zero, @suc{@zero}}, schemaInstance(plusOneSchema(), @zero)), @suc{@zero}):
  <_> @suc{@zero}
def schemaSuccessor() -> Path(Tm, schemaApply(plusOneSchema(), @add{@suc{@zero}, @suc{@zero}}, schemaInstance(plusOneSchema(), @suc{@zero})), @suc{@suc{@zero}}):
  <_> @suc{@suc{@zero}}

# Consume the transported soundness path as running data.
def main() -> Nat:
  schemaApplySound(plusOneSchema(), @add{@suc{@zero}, @suc{@zero}}, schemaInstance(plusOneSchema(), @suc{@zero}), @env{4n, 0n, 0n, 0n, 0n, 0n}) @ i1
