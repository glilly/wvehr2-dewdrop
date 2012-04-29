ONCPCS  ;Hines OIFO/GWB - COLLABORATIVE STAGING PRINT;03/04/04
        ;;2.11;ONCOLOGY;**40,48**;Mar 07, 1995;Build 13
        ;
        S SECTION="Collaborative Staging" D SECTION^ONCOAIP
PRT     N DI,DIC,DR,DA,DIQ,ONC
        S DIC="^ONCO(165.5,"
        S DR="29.2;30.2;29.1;31.1;32.1;32;33;34.3;34.4;44.1;44.2;44.3;44.4;44.5;44.6;160;161;162;163;164;165;166;167;168;169"
        S DA=D0,DIQ="ONC",DIQ(0)="IE" D EN^DIQ1
        K DASHES S $P(DASHES,"-",80)="-"
        I $L(ONC(165.5,D0,32,"I"))=1 S ONC(165.5,D0,32,"I")="0"_ONC(165.5,D0,32,"I")
        I $L(ONC(165.5,D0,33,"I"))=1 S ONC(165.5,D0,33,"I")="0"_ONC(165.5,D0,33,"I")
        ;F I=29,30.2,29.1,31.1,32.1,32,33,34.3,34.4,44.1,44.2,44.3,44.4,44.5,44.6,160,161,162,163,164,165,166,167,168 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
        W !," CS Input values",?35,"Derived CS Output values"
        W !,"---------------------------------","  ","---------------------------------------------"
        W !," Tumor Size (CS).........: ",ONC(165.5,D0,29.2,"I"),?35,"T...........: ",ONC(165.5,D0,160,"E")
        W !," Extension (CS)..........: ",ONC(165.5,D0,30.2,"I"),?35,"T Descriptor: ",ONC(165.5,D0,161,"E")
        W !," Tumor Size/Ext Eval (CS): ",ONC(165.5,D0,29.1,"I"),?35,"N...........: ",ONC(165.5,D0,162,"E")
        W !," Lymph Nodes (CS)........: ",ONC(165.5,D0,31.1,"I"),?35,"N Descriptor: ",ONC(165.5,D0,163,"E")
        W !," Reg Nodes Eval (CS).....: ",ONC(165.5,D0,32.1,"I"),?35,"M...........: ",ONC(165.5,D0,164,"E")
        W !," Regional Nodes Examined.: ",ONC(165.5,D0,33,"I"),?35,"M Descriptor: ",ONC(165.5,D0,165,"E")
        W !," Regional Nodes Positive.: ",ONC(165.5,D0,32,"I"),?35,"Stage Group.: ",ONC(165.5,D0,166,"E")
        W !," Mets at DX (CS).........: ",ONC(165.5,D0,34.3,"I"),?35,"SS1977......: ",ONC(165.5,D0,167,"E")
        W !," Mets Eval (CS)..........: ",ONC(165.5,D0,34.4,"I"),?35,"SS2000......: ",ONC(165.5,D0,168,"E")
        W !," Site-Specific Factor 1..: ",ONC(165.5,D0,44.1,"I"),?35,"CS version..: ",ONC(165.5,D0,169,"E")
        W !," Site-Specific Factor 2..: ",ONC(165.5,D0,44.2,"I")
        W !," Site-Specific Factor 3..: ",ONC(165.5,D0,44.3,"I")
        W !," Site-Specific Factor 4..: ",ONC(165.5,D0,44.4,"I")
        W !," Site-Specific Factor 5..: ",ONC(165.5,D0,44.5,"I")
        W !," Site-Specific Factor 6..: ",ONC(165.5,D0,44.6,"I")
        W !,DASHES
        Q
TXT     S (TXT1,TXT2)="",LOS=$L(TXT) I LOS<LEN S TXT1=TXT Q
        S NOP=$L($E(TXT,1,LEN)," ")
        S TXT1=$P(TXT," ",1,NOP-1),TXT2=$P(TXT," ",NOP,999)
        Q
        ;
UCASE   S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        Q
