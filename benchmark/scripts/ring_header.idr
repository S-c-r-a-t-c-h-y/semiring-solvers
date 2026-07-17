import Frex
import Frexlet.Monoid.Commutative
import Frexlet.Group.Abelian
import Frexlet.Group.Abelian.Notation.Core

import Data.Order

%default total

------------------------ DEFINING THE COMBINATION ------------------------

CommutativeRing : (n : Nat) -> (DistributiveCombinationTheory AbelianGroupTheory CommutativeMonoidTheory) `ModelOver` (cast $ Fin n)
CommutativeRing n =
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
    {additive = Theory.AbelianGroupTheory} 
    {multiplicative = Theory.CommutativeMonoidTheory} 
    (cast $ Fin n) freeM (Free x_set)


TestRing : (DistributiveCombinationTheory AbelianGroupTheory CommutativeMonoidTheory) `ModelOver` (cast $ Fin VAR_COUNT)
TestRing = CommutativeRing VAR_COUNT

(.+.) : U TestRing .Model -> U TestRing .Model -> U TestRing .Model
(.+.) = TestRing .Model.sem (Left (Mono Product))

(.*.) : U TestRing .Model -> U TestRing .Model -> U TestRing .Model
(.*.) = TestRing .Model.sem (Right Product)

neg : U TestRing .Model -> U TestRing .Model
neg = TestRing .Model.sem (Left Inverse)

O1 : U TestRing .Model
O1 = TestRing .Model.sem (Left (Mono Neutral))

I1 : U TestRing .Model
I1 = TestRing .Model.sem (Right Neutral)

0 (=-=) : U TestRing .Model -> U TestRing .Model -> Type
(=-=) term1 term2 = TestRing .Model.rel term1 term2

refl : (x : U TestRing .Model) -> x =-= x
refl x = TestRing .Model.equivalence.reflexive x

VAR_DECL