import Frex
import Frexlet.Monoid.Commutative
import Frexlet.Monoid.Commutative.Notation.Core

import Data.Order

%default total

------------------------ DEFINING THE COMBINATION ------------------------

CommutativeSemiringOver : (n : Nat) -> (DistributiveCombinationTheory CommutativeMonoidTheory CommutativeMonoidTheory) `ModelOver` (cast $ Fin n)
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
  in
  DistributiveCombination' 
    {additive = Theory.CommutativeMonoidTheory} 
    {multiplicative = Theory.CommutativeMonoidTheory} 
    (cast $ Fin n) freeM (Free x_set)

TestSemiring : (DistributiveCombinationTheory CommutativeMonoidTheory CommutativeMonoidTheory) `ModelOver` (cast $ Fin VAR_COUNT)
TestSemiring = CommutativeSemiringOver VAR_COUNT

(.+.) : U TestSemiring .Model -> U TestSemiring .Model -> U TestSemiring .Model
(.+.) = TestSemiring .Model.sem (Left Product)

(.*.) : U TestSemiring .Model -> U TestSemiring .Model -> U TestSemiring .Model
(.*.) = TestSemiring .Model.sem (Right Product)

O1 : U TestSemiring .Model
O1 = TestSemiring .Model.sem (Left Neutral)

I1 : U TestSemiring .Model
I1 = TestSemiring .Model.sem (Right Neutral)

0 (=-=) : U TestSemiring .Model -> U TestSemiring .Model -> Type
(=-=) term1 term2 = TestSemiring .Model.rel term1 term2

refl : (x : U TestSemiring .Model) -> x =-= x
refl x = TestSemiring .Model.equivalence.reflexive x

VAR_DECL