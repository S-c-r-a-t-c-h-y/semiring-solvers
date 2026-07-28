import Frex
import Frexlet.Monoid.Commutative
import Frexlet.Group.Abelian
import Frexlet.Group.Abelian.Notation.Core

import Data.Order

------------------------ DEFINING THE COMBINATION ------------------------

DistrSig : Signature
DistrSig = CoproductSignature Frexlet.Group.Theory.Signature Frexlet.Monoid.Theory.Signature

CommutativeRing : (n : Nat) -> Free (DistributiveCombinationTheory AbelianGroupTheory CommutativeMonoidTheory) (cast $ Fin n)
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


TestRing : Free (DistributiveCombinationTheory AbelianGroupTheory CommutativeMonoidTheory) (cast $ Fin VAR_COUNT)
TestRing = CommutativeRing VAR_COUNT

(.+.) : U TestRing .Data.Model -> U TestRing .Data.Model -> U TestRing .Data.Model
(.+.) = TestRing .Data.Model.sem (Left (Mono Product))

(:+:) : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
(:+:) = call {sig = DistrSig} (Left (Mono Product))

(.*.) : U TestRing .Data.Model -> U TestRing .Data.Model -> U TestRing .Data.Model
(.*.) = TestRing .Data.Model.sem (Right Product)

(:*:) : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
(:*:) = call {sig = DistrSig} (Right Product)

neg : U TestRing .Data.Model -> U TestRing .Data.Model
neg = TestRing .Data.Model.sem (Left Inverse)

negT : Term DistrSig (Fin VAR_COUNT) -> Term DistrSig (Fin VAR_COUNT)
negT = call {sig = DistrSig} (Left Inverse)

O1 : U TestRing .Data.Model
O1 = TestRing .Data.Model.sem (Left (Mono Neutral))

O2 : Term DistrSig (Fin VAR_COUNT)
O2 = call {sig = DistrSig} (Left (Mono Neutral))

I1 : U TestRing .Data.Model
I1 = TestRing .Data.Model.sem (Right Neutral)

I2 : Term DistrSig (Fin VAR_COUNT)
I2 = call {sig = DistrSig} (Right Neutral)

0 (~~) : U TestRing .Data.Model -> U TestRing .Data.Model -> Type
(~~) term1 term2 = TestRing .Data.Model.rel term1 term2

refl : (x : U TestRing .Data.Model) -> x ~~ x
refl x = TestRing .Data.Model.equivalence.reflexive x

VAR_DECL