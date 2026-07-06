Require Import Ring.
Require Import Setoid.

Parameter R : Type.
Parameter Radd : R -> R -> R.
Parameter Rmul : R -> R -> R.
Parameter Rzero : R.
Parameter Rone : R.
Definition Req := @eq R.

Notation "x + y" := (Radd x y) (at level 50, left associativity).
Notation "x * y" := (Rmul x y) (at level 40, left associativity).
Notation "0" := Rzero.
Notation "1" := Rone.
Notation "x == y" := (Req x y) (at level 70, no associativity).

Axiom Radd_0_l    : forall x : R, 0 + x == x.
Axiom Radd_sym    : forall x y : R, x + y == y + x.
Axiom Radd_assoc  : forall x y z : R, x + (y + z) == (x + y) + z.
Axiom Rmul_1_l    : forall x : R, 1 * x == x.
Axiom Rmul_0_l    : forall x : R, 0 * x == 0.
Axiom Rmul_sym    : forall x y : R, x * y == y * x.
Axiom Rmul_assoc  : forall x y z : R, x * (y * z) == ( x * y) * z.
Axiom Rdistr_l    : forall x y z : R, (x + y) * z == (x * z) + (y * z).

Lemma Abstract_semi_ring_theory : semi_ring_theory Rzero Rone Radd Rmul Req.
Proof.
  apply mk_srt.
  - apply Radd_0_l.
  - apply Radd_sym.
  - apply Radd_assoc.
  - apply Rmul_1_l.
  - apply Rmul_0_l.
  - apply Rmul_sym.
  - apply Rmul_assoc.
  - apply Rdistr_l.
Qed. 

Add Ring Abstract : Abstract_semi_ring_theory.

(* -------------------- TESTING ------------------- *)

Lemma addAssoc : forall x y z : R, x + (y + z) == (x + y) + z.
Proof.
  intros; ring.
Qed.

Lemma addComm : forall x y : R, x + y == y + x.
Proof.
  intros; ring.
Qed.

Lemma addLftNeutrality : forall x : R, 0 + x == x.
Proof.
  intros; ring.
Qed.

Lemma addRgtNeutrality : forall x : R, x + 0 == x.
Proof.
  intros; ring.
Qed.

Lemma mulAssoc : forall x y z : R, x * (y * z) == (x * y) * z.
Proof.
  intros; ring.
Qed.

Lemma mulComm : forall x y : R, x * y == y * x.
Proof.
  intros; ring.
Qed.

Lemma mulLftNeutrality : forall x : R, 1 * x == x.
Proof.
  intros; ring.
Qed.

Lemma mulRgtNeutrality : forall x : R, x * 1 == x.
Proof.
  intros; ring.
Qed.

Lemma distrLeft : forall x y z : R, x * (y + z) == x * y + x * z.
Proof.
  intros; ring.
Qed.

Lemma distrRight : forall x y z : R, (x + y) * z == x * z + y * z.
Proof.
  intros; ring.
Qed.

Lemma lftAnnihilation : forall x : R, 0 * x == 0.
Proof.
  intros; ring.
Qed.

Lemma rgtAnnihilation : forall x : R, x * 0 == 0.
Proof.
  intros; ring.
Qed.