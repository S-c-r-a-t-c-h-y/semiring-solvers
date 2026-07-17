Require Import Ring.

Parameter R : Type.
Parameter Radd : R -> R -> R.
Parameter Rsub : R -> R -> R.
Parameter Rmul : R -> R -> R.
Parameter Rzero : R.
Parameter Rone : R.
Parameter Ropp : R -> R.
Definition Req := @eq R.

Notation "x + y" := (Radd x y) (at level 50, left associativity).
Notation "x * y" := (Rmul x y) (at level 40, left associativity).
Notation "0" := Rzero.
Notation "1" := Rone.
Notation "- 1" := (Ropp Rone).
Notation "x == y" := (Req x y) (at level 70, no associativity).
Notation "- x" := (Ropp x) (at level 35, right associativity).
Notation "x - y" := (Rsub x y) (at level 50, left associativity).

Axiom Radd_0_l    : forall x : R, 0 + x == x.
Axiom Radd_sym    : forall x y : R, x + y == y + x.
Axiom Radd_assoc  : forall x y z : R, x + (y + z) == (x + y) + z.
Axiom Rmul_1_l    : forall x : R, 1 * x == x.
Axiom Rmul_sym    : forall x y : R, x * y == y * x.
Axiom Rmul_assoc  : forall x y z : R, x * (y * z) == ( x * y) * z.
Axiom Rdistr_l    : forall x y z : R, (x + y) * z == (x * z) + (y * z).
Axiom Rsub_def    : forall x y : R, x - y == x + -y.
Axiom Ropp_def    : forall x : R, x + (- x) == 0.

Lemma Abstract_ring_theory : ring_theory Rzero Rone Radd Rmul Rsub Ropp Req.
Proof.
  apply mk_rt.
  - apply Radd_0_l.
  - apply Radd_sym.
  - apply Radd_assoc.
  - apply Rmul_1_l.
  - apply Rmul_sym.
  - apply Rmul_assoc.
  - apply Rdistr_l.
  - apply Rsub_def.
  - apply Ropp_def.
Qed. 

Add Ring Abstract : Abstract_ring_theory.