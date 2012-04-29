DIARCALC ;SFISC/TKW,WISC/CAP-ARCHIVING Variables Doc / Misc Calc. ;10/7/95  07:29
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;COMPUTE BOUNDARIES
FROM ;SELECT FROM VALUE 4 SORT
 S X="F" D G
 I $D(DIARS) S:A="" A=$P(DIARS,U,2) S:A="" A="FIRST" G Q
 D H Q:X=""  S DIARS=Y_U_X Q
TO ;SELECT TO VALUE 4 SORT
 S X="T" D G
 I $D(DIARE) S:A="" A=$P(DIARE,U,2) S:A="" A="LAST" G Q
 D H Q:X=""  S DIARE=Y_U_X Q
G S DIART=L,L=0 I $D(DIPP(DJ,X)) S A=$P(DIPP(DJ,X),U,2) Q
 I $D(DPP(DJ,X)) S A=$P(DPP(DJ,X),U,2) Q
 S A="" Q
H ;
 S %=X,%1=DISV
 I +%1,$D(^DIBT(%1,2,DJ,%)) S (X,%2)=$P(^(%),U,2) I "z"'[X
 E  S %2=$S(%="T":"LAST",1:"FIRST"),X=""
 I X="",'$D(DIAR) S A=%2,L=DIART G Q
 D CK:X'=""
 S L=DIART,A=$S(%="F"&(X]%2):X,%="T"&(%2]X)&(X'=""):X,A'="":A,1:%2)
Q K %,%1,%2,DIART Q
 ;
NEW ;SET UP INITIAL ARCHIVAL ACTIVITY
 D NOW^%DTC
 S X=$P(^DIAR(1.11,0),U,3) F X=X:1 L +^DIAR(1.11,X):0 Q:$T&'$D(^(X))  L -^DIAR(1.11,X)
 S Z="1////"_DIART_";4////"_DT_$S($D(^VA(200)):";8////"_DUZ,1:"")_";30////"_DIARF_";13////"_DIAR_";14////"_%_$S($D(^VA(200)):";15////"_DUZ,1:"")_";16////"_$S($D(DIAX):1,1:0)
 I $D(DIARF0) S Z=Z_";31////"_DIARF0
 S DINUM=X,DIC("DR")=Z
 S DIC="^DIAR(1.11,",DIC(0)="EF"
 K DO D FILE^DICN S DIARC=+Y K DR
 Q
 ;
CK S DIART=%_U_%2_U_A D CK^DIP12
 S %=$P(DIART,U,1),%2=$P(DIART,U,2),A=$P(DIART,U,3) Q
VAR ;
 ;DIAR0 = List of human readable conditions from ^DOPT("DIS" in ^ pieces
 ;DIARC = Internal record number of Archival Activity
 ;DIARD = Array of information from default package archival search
 ;        template for this file.  (Created in DIAR0)
 ;DIARDC= Number of default conditions
 ;DIARE = To value in DIP sort questions
 ;DIARF = Internal number of file being archived
 ;DIARF0= Subfile List or DIAR/DIBT INDEX
 ;DIARI = SEARCH TEMPLATE USED
 ;DIARF1=Level # that search is on
 ;DIARP = Internal record no. of Filegram template
 ;DIARS = Temporary value / From value in DIP sort questions
 ;DIART = Temporary storage variable
 ;DIARU = Internal number of Select Criteria Template
 ;DIARST = Archival Activity upon entry to archival option
