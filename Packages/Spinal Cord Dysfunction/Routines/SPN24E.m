SPN24E ;SD/CM- ENVIRONMENT CHECK FOR SPN*2.0*24;1/11/2005
 ;;2.0;Spinal Cord Dysfunction;**24**;01/02/97
 ;
EN ;ENTRY
 N ROU,TEST,VER,X,ZAP,P23
 S ROU="SPNOBJ"
 D CHK
 I $G(ZAP)=1 S XPDABORT=2 W !,"***SPN*2.0*24 ABORTED***",! D EXIT Q
 I $G(ZAP)=1 S XPDABORT=2 W !,"***SPN*2.0*24 ABORTED***",! D EXIT Q
 W !,"***Environment is fine***",!
 K ROU,TEST,VER,ZAP,P23
 Q
CHK ;CHECK FOR PATCH SPN*2*23
 S X="S TEST=$T(+2^"_ROU_")" X X
 S VER=$P(TEST,";",3),P23=$P(TEST,";",5)
 I VER="" W !,"This account is missing some SPN routines!" S ZAP=1 Q
 I VER'[2 W !,"This is not the current version of Spinal Cord!" S ZAP=1 Q
 I P23'[23 W !,"Routine: ",ROU," is missing patch SPN*2*23" S ZAP=1
 Q
EXIT ;
 K ROU,TEST,VER,ZAP,P23
 Q
