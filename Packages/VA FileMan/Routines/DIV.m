DIV ;SFISC/GFT-VERIFY FLDS ;10:06 AM  28 Jun 1999
 ;;22.0;VA FileMan;**7**;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 N DIUTIL,DIVDAT,DIVFIL,DIVMODE,DIVPG,POP S DIUTIL="VERIFY FIELDS"
 K J
 S Q="""",S=";",V=0,P=0,I(0)=DIU,@("(A,J(0))=+$P("_DIU_"0),U,2)")
 I $O(^(0))'>0 W $C(7),"  NO ENTRIES ON FILE!" Q
DIC S DIC="^DD(A,",DIC(0)="EZ",DIC("W")="W:$P(^(0),U,2) ""  (multiple)"""
 S DIC("S")="S %=$P(^(0),U,2) I %'[""C"",$S('%:1,1:$P(^DD(+%,.01,0),U,2)'[""W"")"
 W !,"VERIFY WHICH "_$P(^DD(A,0),U)_": " R X:DTIME Q:U[X
 I X="ALL" D ALL G Q:$D(DIRUT) I Y S DIVMODE="A" D DEVSEL G:$G(POP) Q D INIT,FLDS G Q^DIVR:DQI'>0!$D(DIRUT)
 D ^DIC K DQI,^UTILITY("DIVR",$J)
 I Y<0 W:X?1."?" !?3,"You may enter ALL to verify every field at this level of the file.",! G DIC
 S DR=$P(Y(0),U,2) I DR S J(V)=A,P=+Y,V=V+1,A=+DR,I(V)=$P($P(Y(0),U,4),S,1) S:+I(V)'=I(V) I(V)=Q_I(V)_Q G DIC
 D DEVSEL G:$G(POP) Q D INIT
1 F T="N","D","P","S","V","F" Q:DR[T
 F W="FREE TEXT","SET OF CODES","DATE","NUMERIC","POINTER","VARIABLE POINTER","K" I T[$E(W) S:W="K" W="MUMPS" W "   ",W Q
 K DA S DIVZ=$P(Y(0),U,3),DDC=$P(Y(0),U,5,99),(DIFLD,DA)=+Y
 G ^DIVR
 ;
Q K DIR,DIRUT,N,P,Q,S,V,C
 Q
 ;
ALL S DIR(0)="Y",DIR("??")="^D H^DIV"
 S DIR("A")="DO YOU MEAN ALL THE FIELDS IN THE FILE"
 D ^DIR K DIR S X="ALL"
 Q
 ;
FLDS S DQI=0 F  S DQI=$O(^DD(A,DQI)) Q:DQI'>0  S Y=DQI,Y(0)=^(Y,0),DR=$P(Y(0),U,2) D  Q:$D(DIRUT)
 .I DR,$P(^DD(+DR,.01,0),U,2)["W" Q
 .I DR D NEXTLVL Q
 .I DR'["C" D  Q:$D(DIRUT)  W "--",$P(Y(0),U),"--" D 1 Q
 .. N DIVI F DIVI=1:1:3 D LF^DIVR Q:$D(DIRUT)
 Q
NEXTLVL ;
 N A,P,DE,DA,DQI,I,J,V S DQI=0
 S A=+DR,P=+Y N Y,DR D IJ^DIVU(A)
 D FLDS
 Q
H W !!?5,"YES means that every field at this level in the file will"
 W !?5,"be checked to see if it conforms to the input transform."
 W !!?5,"NO means that ALL will be used to lookup a field in the"
 W !?5,"file which begins with the letters ALL, e.g., ALLERGIES."
 Q
VER(DIVRFILE,DIVRREC,DIVRDR,DIVROUT) ;
 ;DIVRFILE = (sub)file number
 ;DIVRREC = template, or ien-string of records to be verified
 ;DIVRDR = list of fields to be verified (defaults to ALL)
 ;DIVROUT = output array listing the records that had problems
 G ^DIVR1
DIVROUT I $G(DIVROUT)="" D X Q
 I $E(DIVROUT)="[" D  Q
 . N Y,COUNT,Z
 . D DIBT^DIVU(DIVROUT,.Y,DIVRFI0) Q:Y'>0
 . K ^DIBT(+Y,1)
 . S (COUNT,Z)=0
 . F  S Z=$O(^TMP("DIVR1",$J,Z)) Q:Z=""  S COUNT=COUNT+1,^DIBT(+Y,1,Z)=""
 . I COUNT S ^DIBT(+Y,"QR")=DT_U_COUNT
 . D X
 M @DIVROUT@(1)=^TMP("DIVR1",$J)
X K ^TMP("DIVR1",$J)
 Q
 ;
INIT ;Get header info and print first header
 N %,%H,X,Y
 K DIRUT
 ;
 S %H=$H D YX^%DTC
 S DIVDAT=$P(Y,"@")_"  "_$P($P(Y,"@",2),":",1,2)_"    PAGE "
 ;
 I $D(^DIC(A,0))#2 S DIVFIL=$P(^(0),U)_" FILE (#"_A_")"
 E  I $D(^DD(A,0,"NM")) S DIVFIL=$O(^("NM",""))_" SUB-FILE (#"_A_")"
 E  S DIVFIL=""
 ;
 U IO
 W:IOST?1"C-".E @IOF
 D HDR^DIVR
 Q
 ;
DEVSEL ;Prompt for device
 D  Q:$G(POP)
 . N %ZIS,A,I,J,T,V,X,Y,Z
 . S %ZIS=$E("Q",$D(^%ZTSK)>0)
 . W ! D ^%ZIS
 ;
 I $D(IO("Q")),$D(^%ZTSK) D  S POP=1
 . S ZTRTN="ENQUEUE^DIV"
 . S ZTDESC="Verify Fields Report for File #"_A
 . N %,DIVA,DIVI,DIVJ,DIVT,DIVV,DIVY,DIVZ
 . M DIVA=A,DIVI=I,DIVJ=J,DIVT=T,DIVV=V,DIVY=Y,DIVZ=Z
 . F %="DIU","DIUTIL","DIVMODE","DIVA","DIVI","DIVI(","DIVJ","DIVJ(","DIVV","DIVZ" S ZTSAVE(%)=""
 . I $G(DIVMODE)'="A" F %="DIVY","DIVY(","DR" S ZTSAVE(%)=""
 . I $G(DIVMODE)="C" F %="DA","DDC","DIFLD","DIVT" S ZTSAVE(%)=""
 . D ^%ZTLOAD
 . I $D(ZTSK)#2 W !,"Report queued!",!,"Task number: "_$G(ZTSK),!
 . E  W !,"Report canceled!",!
 . K ZTSK
 . S IOP="HOME" D ^%ZIS
 Q
 ;
ENQUEUE ;Entry point for queued reports
 M A=DIVA,I=DIVI,J=DIVJ,T=DIVT,V=DIVV,Y=DIVY,Z=DIVZ
 K DIVA,DIVI,DIVJ,DIVT,DIVV,DIVY,DIVZ
 S Q="""",S=";"
 ;
 D INIT
 I $G(DIVMODE)="A" D FLDS,Q^DIVR Q
 I $G(DIVMODE)="C" D ^DIVR Q
 D 1
 Q
