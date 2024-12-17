Require Import Naturelle.
Section Session1_2019_Logique_Exercice_2.

Variable A B : Prop.

Theorem Exercice_2_Coq : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
intros [na|b].
left.
exact na.
cut (A \/~A).
intros [a|na].
right.
split.
exact a.
exact b.
left.
exact na.
apply (classic A).
Qed.

Theorem Exercice_2_Naturelle : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
I_imp H.
E_ou (A) (~A).
TE.
I_imp a.
I_ou_d.
I_et.
Hyp a.
E_ou (~A) (B).
Hyp H.
I_imp na.
E_antiT.
E_non A.
exact a.
exact na.
I_imp b.
Hyp b.
I_imp na.
I_ou_g.
exact na.
Qed.
End Session1_2019_Logique_Exercice_2.

