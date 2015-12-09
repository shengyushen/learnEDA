Require Import Arith.
Require Import List.
Require Import Bool.
Import ListNotations.
Open Scope nat_scope.
Open Scope list_scope.

(*definition of the two data structure of tenary tree*)
Inductive DataNode : Set :=
D0
| DN : nat -> DataNode.

Inductive TreeNode : Set :=
T0 : TreeNode
| TN : TreeNode->DataNode->TreeNode->DataNode->TreeNode->TreeNode.

(*flattening the DataNode*)
Definition flatten_DataNode :=
fun dn:DataNode =>
  match dn with
  D0 => nil
  | DN n => cons n nil 
  end.

(*flattening the TreeNode*)
Fixpoint  flatten (tn:TreeNode) : list nat :=
  match tn with
  T0 => nil
  | TN lefttree leftdata midtree rightdata righttree => 
    let leftlist :=flatten lefttree in
    let midlist  :=flatten midtree in
    let rightlist:=flatten righttree in
    let leftdatalist := flatten_DataNode leftdata in
    let rightdatalist:= flatten_DataNode rightdata in
    leftlist++leftdatalist++midlist++rightdatalist++rightlist
  end.

(*a predicate meaning that n is in dn*)
Check (1=2).
Definition inDN (n:nat) (dn:DataNode) :Prop :=
  match dn with
  D0 => False
  | DN v => v=n
  end.
Fixpoint inTN (n:nat) (tn:TreeNode) :Prop :=
  match tn with
  T0 => False
  | TN lefttree leftdata midtree rightdata righttree =>
    (inTN n lefttree)\/
    (inTN n midtree)\/
    (inTN n righttree)\/
    (inDN n leftdata)\/
    (inDN n rightdata)
  end.


Lemma nl1_l2_eq_n_l1l1 :
  forall (n:nat) (l1 l2 :list nat),
    ((n::l1)++l2)=(n::(l1++l2)).
Proof.
intros.
induction l1.
auto.
rewrite app_comm_cons.
auto.
Qed.

Lemma list_in_or :
  forall (n:nat) (l1 l2 :list nat),
    (In n (l1++l2)) -> (In n l1)\/(In n l2).
Proof.
intros.
induction l1.
right.
auto.
rewrite <- in_app_iff.
assumption.
Qed.


Lemma inDN_in_flattenDataNode :
  forall (n:nat) (dn:DataNode),
    (inDN n dn) -> (In n (flatten_DataNode dn)).
Proof.
intros.
induction dn.
elim H.
elim H.
simpl.
auto.
Qed.

(*in operator is preserved by flatten
that is to say, some element in a TreeNode is also in its flatten result*)
Theorem in_trans_flatten :
  forall (n:nat) (tn:TreeNode),
    (inTN n tn) -> (In n (flatten tn)).
Proof.
intros.
induction tn.
auto.
simpl flatten.
repeat rewrite in_app_iff .
simpl inTN in H.
elim H.
intros.
left.
auto.
intros.
elim H0.
right.
right.
left.
auto.
intros.
elim H1.
intros.
repeat right.
auto.
intros.
elim H2.
intros.
right.
left.
apply inDN_in_flattenDataNode.
auto.
intros.
right.
right.
right.
left.
apply  inDN_in_flattenDataNode.
auto.
Qed.

