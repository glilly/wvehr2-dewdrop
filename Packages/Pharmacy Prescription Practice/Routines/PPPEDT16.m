PPPEDT16 ;ALB/JFP - EDIT FF XREF ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; This routines control the deleting of entries in the foreign facility 
 ; file.
 ;
DEL ; -- Deletes FFX data
 ;
 N DELENTRY,PATNAME,STANO,DA,DIK
 N VALMY,SDI,SDAT,FFXIFN,ERR,TMP
 ;
 S DELENTRY=1003
 ;
 D EN^VALM2($G(XQORNOD(0)),"S")
 Q:'$D(VALMY)
 S SDI=""
 S SDI=$O(VALMY(SDI))  Q:SDI=""
 S SDAT=$G(@IDXARRAY@(SDI))
 S FFXIFN=$P(SDAT,U,2)
 S PATNAME=$P(SDAT,U,3)
 S STANO=$P(SDAT,U,4)
 D DEL1
 D INIT^PPPEDT12
 S VALMBCK="R"
 Q
 ;
DEL1 ; -- Deletes entry in FFX file
 S DIK="^PPP(1020.2,"
 S DA=FFXIFN
 L +(^PPP(1020.2,FFXIFN)):5
 I '$T D
 .W !,*7,"File in use.  Try again later"
 .R !,"Press <RETURN> to continue...",TMP:DTIME
 E  D
 .D ^DIK
 .L -(^PPP(1020.2,FFXIFN)):5
 .S TMP=$$STATUPDT^PPPMSC1(6,1)
 .S TMP=$$LOGEVNT^PPPMSC1(DELENTRY,"DEL_PPPEDT16",PATNAME_", "_STANO)
 .;W !,"Entry Deleted."
 .;R !,"Press <RETURN> to continue...",TMP:DTIME
 Q
 ;
END ; -- End of code
 Q
 ;
