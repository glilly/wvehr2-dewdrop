IMRXDRPT ;SF-IRMFO.SEA/JLI,HCIOFO/DDA - ROUTINE TO MERGE ENTRIES IN ICR FILE FOR PATIENT MERGE ;5/19/98  08:55
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**2**;Feb 09,1998
EN(ARRAY) ; Entry point for merging.  Array is the NAME of array in which from and to entries are indicated.
 ;
 N FROMX,TO,X,FROMXA,TOA,ARRAY1,FRX,TOX,FROM
 S ARRAY1=$NA(^TMP($J,"IMRMRG1"))
 K @ARRAY1
 S FROM=ARRAY1
 F FROMX=0:0 S FROMX=$O(@ARRAY@(FROMX)) Q:FROMX'>0  D
 . S TO=$O(@ARRAY@(FROMX,0))
 . S FRX=$O(@ARRAY@(FROMX,TO,""))
 . S TOX=$O(@ARRAY@(FROMX,TO,FRX,""))
 . S X=FROMX D XOR^IMRXOR S FROMXA=+$O(^IMR(158,"B",X,""))
 . S X=TO D XOR^IMRXOR S TOA=+$O(^IMR(158,"B",X,""))
 .  ; Quit if there are no equivalent IMR records.
 . Q:(FROMXA'>0)&(TOA'>0)
 .  ; If there is only a 'to' IMR record, nil tracking dates and quit
 . I FROMXA'>0 D NIL(TOA) Q
 .  ; If there is only a 'from' IMR record, create one to merge 'to'
 . I TOA'>0 D
 .. N IMRFDA,IMRIEN
 .. S X=TO D XOR^IMRXOR
 .. S IMRFDA(158,"+1,",.01)=X
 .. D UPDATE^DIE("","IMRFDA","IMRIEN","")
 .. S TOA=IMRIEN(1)
 .. Q
 . S @ARRAY1@(FROMXA,TOA,FRX,TOX)=""
 . Q
 D EN^XDRMERG(158,ARRAY1)
 I '$D(XDRERR) D
 . S FR158IEN=0
 . F  S FR158IEN=$O(@ARRAY1@(FR158IEN)) Q:FR158IEN'>0  D
 ..;Reset merged-to entry tracking dates to nil, insuring accurate
 ..;  roll-up of data to the national data set.
 .. S TO158IEN=$O(@ARRAY1@(FR158IEN,0))
 .. D NIL(TO158IEN)
 ..;Call logic to safely DELETE Immunology record.  This also sends a
 ..;  delete request to the national data set.
 .. S FROMDFN=+$O(@ARRAY1@(FR158IEN,TO158IEN,""))
 .. D EN^IMRDEL(FR158IEN,FROMDFN)
 .. Q
 . K FR158IEN,FROMDFN,TO158IEN
 . Q
 K @ARRAY1
 Q
NIL(DA) S DIE="^IMR(158,"
 S DR="101.01///@;101.02///@;101.03///@;101.04///@;101.05///@;101.06///@;101.07///@;101.08///@;101.09///@;101.1///@;101.11///@;101.12///@;101.13///@;101.14///@;101.15///@;101.16///@;101.17///@"
 L +^IMR(158,DA) D ^DIE L -^IMR(158,DA)
 K DA,DIE,DR,DTOUT
