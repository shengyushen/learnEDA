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

(*test drive on the flatten algorithm*)
Eval compute in flatten (TN T0 D0 T0 (DN 1) T0).
Eval compute in flatten 
(TN
  (TN T0 (DN 1) T0 (DN 2) T0)
  (DN 3)
  (TN
    (TN T0 (DN 4) T0 D0 T0)
    (DN 5)
    T0
    (DN 6)
    (TN T0 (DN 7) T0 D0 T0)
  )
  (DN 8)
  (TN T0 (DN 9) T0 D0 T0)
).

(*a predicate meaning that n is in dn*)
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
    (inDN n leftdata)\/
    (inTN n midtree)\/
    (inDN n rightdata)\/
    (inTN n righttree)
  end.

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
simpl in *.
repeat rewrite in_app_iff .
elim H.
intros.
left.
auto.
intros.
right.
elim H0.
intros.
left.
apply inDN_in_flattenDataNode.
auto.
intros.
right.
elim H1.
intros.
left.
apply IHtn2.
auto.
intros.
right.
elim H2.
intros.
left.
apply inDN_in_flattenDataNode.
auto.

intros.
right.
apply IHtn3.
auto.
Qed.

Lemma in_flattenDataNode_inDN :
  forall (n:nat) (dn:DataNode),
    (In n (flatten_DataNode dn)) -> (inDN n dn).
Proof.
intros.
(*once again induction can expand dn on both hyp and goal
while case cab only expand goal*)
induction dn.
auto.
simpl.
elim H.
auto.
simpl.
intro.
elim H0.
Qed.



Lemma in_3 :
  forall (a :nat) (l1 l2 l3: list nat),
    (In a (l1++l2++l3)) -> (In a l1)\/(In a l2)\/(In a l3).
Proof.
intros.
induction l1.
(*this is simply in all place*)
simpl  in *.
right.
apply in_app_or.
assumption.
elim H.
intros.
left.
rewrite H0.
apply in_eq.
intros.
(*very useful in using hyps IHl0 with "A-> B" and H0 with "A"*)
destruct (IHl1 H0).
left.
apply in_cons.
assumption.
right.
assumption.
Qed.

Lemma in_4 :
  forall (a :nat) (l1 l2 l3 l4: list nat),
    (In a (l1++l2++l3++l4)) -> (In a l1)\/(In a l2)\/(In a l3)\/(In a l4).
Proof.
intros.
induction l1.
simpl in *.
right.
apply in_3.
assumption.
elim H.
intros.
left.
rewrite H0.
apply in_eq.
intros.
destruct (IHl1 H0).
left.
apply in_cons.
auto.
right.
auto.
Qed.


Lemma in_5 :
  forall (a :nat) (l1 l2 l3 l4 l5: list nat),
    (In a (l1++l2++l3++l4++l5)) -> (In a l1)\/(In a l2)\/(In a l3)\/(In a l4)\/(In a l5).
Proof.
intros.
induction l1.
simpl in *.
right.
apply in_4.
auto.
elim H.
intros.
left.
rewrite H0.
apply in_eq.
intros.
destruct (IHl1 H0).
left.
apply in_cons.
auto.
right.
auto.
Qed.

Theorem in_trans_flatten_rev :
  forall (n:nat) (tn:TreeNode),
    (In n (flatten tn)) -> (inTN n tn).
Proof.
intros.
induction tn.
auto.
simpl in *.
destruct ((in_5 n (flatten tn1) (flatten_DataNode d) (flatten tn2) (flatten_DataNode d0) (flatten tn3)  )H).
left.
apply IHtn1.
auto.
right.
(*another powerful trick that break A \/B\/... into A and B\/...*)
induction H0.
left.
apply in_flattenDataNode_inDN .
auto.
elim H0.
intros.
right.
left.
apply IHtn2.
auto.
intro.
right.
right.
elim H1.
intros.
left.
apply in_flattenDataNode_inDN .
auto.
intros.
right.
apply IHtn3.
auto.
Qed.







