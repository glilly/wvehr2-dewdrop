RTCR1 ; ;09/19/10
 S X=DG(DQ),DIC=DIE
 S ^RT("ABOR",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "Q:'$D(^RT(DA,""CL""))!('$D(^(0)))  Q:X=$P(^(0),""^"",6)!('$P(^(""CL""),""^"",6))  S ^RT(""AC"",+$P(^(""CL""),""^"",6),DA)="""""
