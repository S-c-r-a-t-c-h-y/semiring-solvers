import Frex
import Frexlet.Monoid.Commutative
import Frexlet.Monoid.Commutative.Notation.Core

import Data.Order

------------------------ DEFINING THE COMBINATION ------------------------

DistrSig : Signature
DistrSig = CoproductSignature Signature Signature

DistrPres : Presentation
DistrPres = DistributiveCombinationTheory CommutativeMonoidTheory CommutativeMonoidTheory

CommutativeSemiringOver : (n : Nat) -> Free DistrPres (cast $ Fin n)
CommutativeSemiringOver n =
  let freeM : Free CommutativeMonoidTheory (cast $ Fin n)
      freeM = Finite.Free
      x_set : OrdSetoid
      x_set = MkOrdSetoid
        { setoid = cast freeM.Data.Model
        , decOrd = MkStrictOrd
          { lt = LtVect LT
          , ltDec = believe_me "ltDec"
          , ltIsOrder = believe_me "ltIsOrder"
          , compare = compareVect compareNat
          }
        }
      freeA : Free CommutativeMonoidTheory (cast freeM.Data.Model)
      freeA = Free x_set
  in
  FreeDistributiveCombination'
    {additive = Theory.CommutativeMonoidTheory} 
    {multiplicative = Theory.CommutativeMonoidTheory} 
    (cast $ Fin n) 
    (believe_me "AffinePresentation")
    (believe_me "CommutativeTheory")
    freeM freeA


FreeSemiring : Free DistrPres (cast $ Fin VAR_COUNT)
FreeSemiring = CommutativeSemiringOver VAR_COUNT

refl = (Pair (cast Finite.Free .Data.Model) NatSetoid).ListEqualityReflexive

plusT : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
plusT = call {sig = DistrSig} (Left Product)

timesT : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
timesT = call {sig = DistrSig} (Right Product)

O2 : Term DistrSig (Fin VAR_COUNT)
O2 = call {sig = DistrSig} (Left Neutral)

I2 : Term DistrSig (Fin VAR_COUNT)
I2 = call {sig = DistrSig} (Right Neutral)

parameters {TestRing : Model DistrPres}

  plusM : U TestRing -> U TestRing -> U TestRing
  plusM = TestRing .sem (Left Product)

  timesM : U TestRing -> U TestRing -> U TestRing
  timesM = TestRing .sem (Right Product)

  O1 : U TestRing
  O1 = TestRing .sem (Left Neutral)

  I1 : U TestRing
  I1 = TestRing .sem (Right Neutral)

  0 (~~) : U TestRing -> U TestRing -> Type
  (~~) term1 term2 = TestRing .rel term1 term2