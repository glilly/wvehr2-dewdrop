ONCOCOF ;Hines OIFO/GWB - [RS Registry Summary Reports - Follow Up] ;06/23/10
        ;;2.11;ONCOLOGY;**13,25,28,39,41,45,51**;Mar 07, 1995;Build 65
        ;
FR      ;[RS Registry Summary Reports - Follow Up]
        N AA,AB,AC,AD,AE,AF,AG,AN,AS,BEH,CC,MO,ONCODF,PA,PB,PC,PD,PE,PL,PP,PSFC
        N SFC,SITECODE,SITENAME,SUMSTG,T,VV
        F SITENAME="CERVIX","SKIN" D
        .S DIC=164.2,DIC(0)="O",X=SITENAME
        .D ^DIC K DIC,X
        .S SITECODE(SITENAME)=+Y
        K ^TMP($J)
        S (T,AB,AC,AS,AF,AN,AA,CC)=0
        D TOTCASE
        S T=AA+AN
        S X0=0 F  S X0=$O(^TMP($J,X0)) Q:X0'>0  D
        .S ST=$P($G(^ONCO(165.5,X0,0)),U)
        .S MO=$$HIST^ONCFUNC(X0)
        .S SUMSTG=$P($G(^ONCO(165.5,X0,2)),U,17)
        .S BEH=$E(MO,5)
        .D SUB
        S AA=AA-AB-AC-AS-CC
        S FR=T_U_AB_U_AC_U_AS
        S (AB,AC,AD,AE,AF)=0
        S X0=0 F  S X0=$O(^TMP($J,X0)) Q:X0'>0  S PP=$P(^ONCO(165.5,X0,0),U,2),VV=$G(^ONCO(160,PP,1)),ONCODF=$P(VV,U,2),AS=$P(VV,U,7),VV=$P(VV,U) D F
        S AC=AA-AB
        I AA S PB=$J(AB/AA,0,2)*100,PC=$J(AC/AA,0,2)*100,PD=$J(AD/AA,0,2)*100,PE=$J(AE/AA,0,2)*100
        E  S (PB,PC,PD,PE)="N/A" ;avoid division by zero
        I AC S PA=$J(AD/AC,0,2)*100,PL=$J(AE/AC,0,2)*100
        E  S (PA,PL)="N/A" ;avoid division by zero
        S SFC=AA-AE
        S PSFC=$J(SFC/AA,0,2)*100
        S FR=FR_U_AF_U_AN_U_AA_U_AB_U_AC_U_PC_U_PB_U_AD_U_PD_U_AE_U_PE_U_PA_U_PL_U_SFC_U_PSFC_U_CC
        S AS=$O(^ONCO(160.1,"C",DUZ(2),0))
        I AS="" S AS=$O(^ONCO(160.1,0))
        S ^ONCO(160.1,AS,"FR")=FR
        N IOP
        I ONCOS("F")=1 S DIC=160.2,DIC(0)="",X="FOLLOWUP RATE REPORT 1" D ^DIC K DIC,X
        I ONCOS("F")=2 S DIC=160.2,DIC(0)="",X="FOLLOWUP RATE REPORT" D ^DIC K DIC,X
        S IOP=ION
        S DIWF="^ONCO(160.2,"_(+Y)_",1,",DIWF(1)="160.1"
        S BY="NUMBER"
        S (FR,TO)=$O(^ONCO(160.1,"C",DUZ(2),0))
        I FR="" S (FR,TO)=$O(^ONCO(160.1,0))
        W !!
        D EN2^DIWF K DIWF,BY,FR,TO S IOP=ION D ^%ZIS
        K PA,PB,PC,PD,PE,PL,X0
        Q
        ;
TOTCASE ;AA = Analytic (CLASS OF CASE 00-22)
        ;AN = Non-analytic (CLASS OF CASE 23-99)
        N COC,DATEDX,EOF,MINUS5,ONCOPARS,REFDATE,VASITE,XD0,XD1
        S VASITE=$O(^ONCO(160.1,"C",DUZ(2),0))
        I VASITE="" S VASITE=$O(^ONCO(160.1,0))
        S ONCOPARS=$G(^ONCO(160.1,VASITE,0))
        S REFDATE=$P(ONCOPARS,U,4)
        S XD0=REFDATE,EOF=0
        S MINUS5=DT-50000
        I ONCOS("F")=2,MINUS5>REFDATE S XD0=MINUS5
        F  D  Q:EOF
        .S XD1=""
        .F  S XD1=$O(^ONCO(165.5,"ADX",XD0,XD1)) Q:'XD1  I $$DIV^ONCFUNC(XD1)=DUZ(2) D
        ..I $P($G(^ONCO(165.5,XD1,7)),U,2)="A" Q
        ..S DATEDX=$P($G(^ONCO(165.5,XD1,0)),U,16)
        ..S COC=$E($$GET1^DIQ(165.5,XD1,.04),1,2)
        ..I COC>22 S AN=AN+1
        ..E  S AA=AA+1,^TMP($J,XD1)=""
        .S XD0=$O(^ONCO(165.5,"ADX",XD0))
        .I 'XD0 S EOF=1
        Q
        ;
SUB     ;Subtract non-reportables
        I ST="" S AA=AA-1 D KILL Q  ;No SITE/GP
        I BEH=0!(BEH=1) S AB=AB+1 D KILL Q
        I ST=SITECODE("CERVIX"),BEH=2 S AC=AC+1 D KILL Q
        I ST=SITECODE("SKIN"),MO>80699,MO<80944,(BEH=0)!(BEH=1)!(BEH=2)!(BEH=3),(SUMSTG=0)!(SUMSTG=1) S AS=AS+1 D KILL Q
        S DATEDX=$P($G(^ONCO(165.5,X0,0)),U,16)
        S COC=$E($$GET1^DIQ(165.5,X0,.04),1,2)
        I (COC="00")&(DATEDX>3051231) S CC=CC+1 D KILL
        Q
        ;
F       ;Subtract NEXT FOLLOW-UP SOURCE (160.04,6) = 8
        ;Foreign residents (not followed)
        ;Subtract STATUS = 0 (Dead) and LTF (Lost to followup)
        N FS,LC,X1,X2
        I VV&'AS S X1=$O(^ONCO(160,PP,"F","AA",0)) I X1'="" S LC=$O(^(X1,0)),FS=$P(^ONCO(160,PP,"F",LC,0),U,6) I FS=8 S AF=AF+1,AA=AA-1 D KILL Q
        I 'VV S AB=AB+1 D KILL Q
        S X2=ONCODF,X1=DT D ^%DTC I X<91.25 S AD=AD+1 Q
        S AE=AE+1
        Q
        ;
KILL    ;Remove non-reportable entry
        K ^TMP($J,X0)
        Q
        ;
MTS     ;MULTIPLE TUMOR STATUS (DEATH) (160,70) 'COMPUTED-FIELD' EXPRESSION
        ;MULTIPLE PRIMARY STATUS (160.04,9) 'COMPUTED-FIELD' EXPRESSION
        ;Displays SITE/GP (165.5,.01): LAST TUMOR STATUS (165.5,95)
        Q:$P($G(^ONCO(160,D0,1)),U,1)
        N PD0,ST,TS
        I '$D(^ONCO(165.5,"C",D0)) W !,"No primaries for this patient" Q
        S PD0=0
        F  S PD0=$O(^ONCO(165.5,"C",D0,PD0)) Q:PD0'>0  I $$DIV^ONCFUNC(PD0)=DUZ(2) D
        .S ST=$P(^ONCO(164.2,$P(^ONCO(165.5,PD0,0),U,1),0),U,1)
        .S TS=+$P($G(^ONCO(165.5,PD0,7)),U,6)
        .S TS=$P($G(^ONCO(164.42,TS,0)),U,1)
        .W !,ST_": "_TS
        Q
        ;
NM      ;HOSPITAL NAME (160,1000) 'COMPUTED-FIELD' EXPRESSION
        N XD0
        S XD0=$O(^ONCO(160.1,"C",DUZ(2),0))
        I XD0="" S XD0=$O(^ONCO(160.1,0))
        I XD0'="" S X=$P(^ONCO(160.1,XD0,0),U,1)
        Q
        ;
ADD     ;HOSPITAL STREET ADDRESS (160,1001) 'COMPUTED-FIELD' EXPRESSION
        N XD0
        S XD0=$O(^ONCO(160.1,"C",DUZ(2),0))
        I XD0="" S XD0=$O(^ONCO(160.1,0))
        I XD0'="" S X=$P(^ONCO(160.1,XD0,0),U,2)
        Q
        ;
ZIP     ;HOSPITAL CITY,ST ZIP (160,1002) 'COMPUTED-FIELD' EXPRESSION
        N CITY,STATE,STP,XD0,ZIP
        S XD0=$O(^ONCO(160.1,"C",DUZ(2),0))
        I XD0="" S XD0=$O(^ONCO(160.1,0))
        I XD0'="" D
        .S ZIP=$P(^ONCO(160.1,XD0,0),U,3)
        .S ZIP1=$$GET1^DIQ(160.1,XD0,.03)
        .S CITY=$$GET1^DIQ(5.11,ZIP,1)
        .S STATE=$$GET1^DIQ(5.11,ZIP,3)
        .S X=CITY_", "_STATE_" "_ZIP1
        Q
        ;
ZIP1    ;CITY,ST ZIP (160.1,.031) 'COMPUTED-FIELD' EXPRESSION
        N CITY,STATE,ZIP,ZIP1
        S ZIP=$P(^ONCO(160.1,D0,0),U,3)
        S ZIP1=$$GET1^DIQ(160.1,D0,.03)
        S CITY=$$GET1^DIQ(5.11,ZIP,1)
        S STATE=$$GET1^DIQ(5.11,ZIP,3)
        S X=CITY_", "_STATE_" "_ZIP1
        Q
        ;
CLEANUP ;Cleanup
        K D0,DATEDX,ONCOS,Y
