Require Import ZArith.

Open Scope Z_scope.

Lemma addAssoc : forall x y z : Z, x + (y + z) = (x + y) + z.
Proof.
  intros; ring.
Qed.

Lemma addComm : forall x y : Z, x + y = y + x.
Proof.
  intros; ring.
Qed.

Lemma addLftNeutrality : forall x : Z, 0 + x = x.
Proof.
  intros; ring.
Qed.

Lemma addRgtNeutrality : forall x : Z, x + 0 = x.
Proof.
  intros; ring.
Qed.

Lemma addLftInverse : forall x : Z, - x + x = 0.
Proof.
  intros; ring.
Qed.

Lemma addRgtInverse : forall x : Z, x + - x = 0.
Proof.
  intros; ring.
Qed.

Lemma mulAssoc : forall x y z : Z, x * (y * z) = (x * y) * z.
Proof.
  intros; ring.
Qed.

Lemma mulComm : forall x y : Z, x * y = y * x.
Proof.
  intros; ring.
Qed.

Lemma mulLftNeutrality : forall x : Z, 1 * x = x.
Proof.
  intros; ring.
Qed.

Lemma mulRgtNeutrality : forall x : Z, x * 1 = x.
Proof.
  intros; ring.
Qed.

Lemma distrLeft : forall x y z : Z, x * (y + z) = x * y + x * z.
Proof.
  intros; ring.
Qed.

Lemma distrRight : forall x y z : Z, (x + y) * z = x * z + y * z.
Proof.
  intros; ring.
Qed.

Lemma lftAnnihilation : forall x : Z, 0 * x = 0.
Proof.
  intros; ring.
Qed.

Lemma rgtAnnihilation : forall x : Z, x * 0 = 0.
Proof.
  intros; ring.
Qed.

Lemma invProductLeft : forall x y : Z, (-x) * y = - (x * y).
Proof.
  intros; ring.
Qed.

Lemma invProductRight : forall x y : Z, x * (-y) = - (x * y).
Proof.
  intros. ring.
Qed.