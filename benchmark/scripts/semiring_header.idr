import Frex
import Frexlet.Monoid.Commutative
import Frexlet.Monoid.Commutative.Notation.Core

import Data.Order

------------------------ DEFINING THE COMBINATION ------------------------

DistrSig : Signature
DistrSig = CoproductSignature Signature Signature

CommutativeSemiringOver : (n : Nat) -> Free (DistributiveCombinationTheory CommutativeMonoidTheory CommutativeMonoidTheory) (cast $ Fin n)
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


TestSemiring : Free (DistributiveCombinationTheory CommutativeMonoidTheory CommutativeMonoidTheory) (cast $ Fin VAR_COUNT)
TestSemiring = CommutativeSemiringOver VAR_COUNT

(.+.) : U TestSemiring .Data.Model -> U TestSemiring .Data.Model -> U TestSemiring .Data.Model
(.+.) = TestSemiring .Data.Model.sem (Left Product)

(:+:) : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
(:+:) = call {sig = DistrSig} (Left Product)

(.*.) : U TestSemiring .Data.Model -> U TestSemiring .Data.Model -> U TestSemiring .Data.Model
(.*.) = TestSemiring .Data.Model.sem (Right Product)

(:*:) : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
(:*:) = call {sig = DistrSig} (Right Product)

O1 : U TestSemiring .Data.Model
O1 = TestSemiring .Data.Model.sem (Left Neutral)

O2 : Term DistrSig (Fin VAR_COUNT)
O2 = call {sig = DistrSig} (Left Neutral)

I1 : U TestSemiring .Data.Model
I1 = TestSemiring .Data.Model.sem (Right Neutral)

I2 : Term DistrSig (Fin VAR_COUNT)
I2 = call {sig = DistrSig} (Right Neutral)

0 (~~) : U TestSemiring .Data.Model -> U TestSemiring .Data.Model -> Type
(~~) term1 term2 = TestSemiring .Data.Model.rel term1 term2

refl : (x : U TestSemiring .Data.Model) -> x ~~ x
refl x = TestSemiring .Data.Model.equivalence.reflexive x

VAR_DECL