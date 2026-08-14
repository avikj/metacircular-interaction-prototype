-- V3 ledger root: machine-checked targets from notes/VV.md
import Pairfield.SumRigidity
import Pairfield.Lorentz
import Pairfield.ReversalRigidity
import Pairfield.CharacterAnchor
import Pairfield.FiniteInformation
import Pairfield.FutureBehavior
import Pairfield.PointwiseRevision
import Pairfield.Lowenheim
import Pairfield.ResourceBalance
import Pairfield.MyhillNerodeAdapter
import Pairfield.SmithCertificate
import Pairfield.ComputableSmith2x2
import Pairfield.ComputableSmith2x2Adapter
import Pairfield.DirectSmith2x2
import Pairfield.SmithPresentation
import Pairfield.GeneralSmith2x2
import Pairfield.SmithContent
import Pairfield.CertificateSource
import Pairfield.RankOneSmith2x2
import Pairfield.RankOneWitness
import Pairfield.LeastNonDivisor
import Pairfield.FrontierOptimality
import Pairfield.WalkFalsifier
-- `Pairfield.ArbitrarySmithClosure` inhabits `CapabilityGraph`'s named open
-- edge.  It is kept out of the default target for the same reason
-- `Pairfield.CapabilityGraph` always was: that module imports all of Mathlib.
-- Replay it with
--   lake build Pairfield.ArbitrarySmithClosure
import Pairfield.SmithMemory
