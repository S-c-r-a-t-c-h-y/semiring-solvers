import Frex
import Frexlet.Monoid.Commutative
import Frexlet.Group.Abelian
import Frexlet.Group.Abelian.Notation.Core

import Data.Order

------------------------ DEFINING THE COMBINATION ------------------------

DistrSig : Signature
DistrSig = CoproductSignature Frexlet.Group.Theory.Signature Frexlet.Monoid.Theory.Signature

DistrPres : Presentation
DistrPres = DistributiveCombinationTheory AbelianGroupTheory CommutativeMonoidTheory

CommutativeRingOver : (n : Nat) -> Free DistrPres (cast $ Fin n)
CommutativeRingOver n =
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
      freeA : Free AbelianGroupTheory (cast freeM.Data.Model)
      freeA = Free x_set
  in
  FreeDistributiveCombination'
    {additive = Theory.AbelianGroupTheory} 
    {multiplicative = Theory.CommutativeMonoidTheory} 
    (cast $ Fin n) 
    (believe_me "AffinePresentation")
    (believe_me "CommutativeTheory")
    freeM freeA


FreeRing : Free DistrPres (cast $ Fin VAR_COUNT)
FreeRing = CommutativeRingOver VAR_COUNT

refl = (Pair (cast Finite.Free .Data.Model) NZIntSetoid).ListEqualityReflexive

negT : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
negT = call {sig = DistrSig} (Left Inverse)

plusT : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
plusT = call {sig = DistrSig} (Left (Mono Product))

timesT : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
timesT = call {sig = DistrSig} (Right Product)

O2 : Term DistrSig (Fin VAR_COUNT)
O2 = call {sig = DistrSig} (Left (Mono Neutral))

I2 : Term DistrSig (Fin VAR_COUNT)
I2 = call {sig = DistrSig} (Right Neutral)

parameters {TestRing : Model DistrPres}

  plusM : U TestRing -> U TestRing -> U TestRing
  plusM = TestRing .sem (Left (Mono Product))

  timesM : U TestRing -> U TestRing -> U TestRing
  timesM = TestRing .sem (Right Product)

  neg : U TestRing -> U TestRing
  neg = TestRing .sem (Left Inverse)

  O1 : U TestRing
  O1 = TestRing .sem (Left (Mono Neutral))

  I1 : U TestRing
  I1 = TestRing .sem (Right Neutral)

  0 (~~) : U TestRing -> U TestRing -> Type
  (~~) term1 term2 = TestRing .rel term1 term2
