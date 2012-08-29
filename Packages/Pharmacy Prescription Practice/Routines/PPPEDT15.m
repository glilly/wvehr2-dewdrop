PPPEDT15 ;ALB/JFP - EDIT FF XREF ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; This routines control the editing of entries in the foreign facility 
 ; file.
 ;
EDIT ; -- EDIT FFX data
 ;
 N DELENTRY,PATNAME,STANO,LOCKERR
 N VALMY,SDI,SDAT,FFXIFN,ERR,TMP,EDTENTRY
 ;
 S EDTENTRY=1002
 S LOCKERR=-9004
 ;
 D EN^VALM2($G(XQORNOD(0)),"S")
 Q:'$D(VALMY)
 S SDI=""
 F  S SDI=$O(VALMY(SDI))  Q:SDI=""  D
 .S SDAT=$G(@IDXARRAY@(SDI))
 .S FFXIFN=$P(SDAT,U,2)
 .S PATNAME=$P(SDAT,U,3)
 .S STANO=$P(SDAT,U,4)
 .D EDIT1
 .D INIT^PPPEDT12
 S VALMBCK="R"
 Q
 ;
EDIT1 ; -- Edits entry in FFX file
 S ERR=$$EDITFFX^PPPEDT1(FFXIFN)
 I ERR=LOCKERR D
 .W !,"File in use.  Please try again later."
 .R !,"Press <RETURN> to continue...",TMP:DTIME
 E  D
 .S TMP=$$STATUPDT^PPPMSC1(7,1)
 .S TMP=$$LOGEVNT^PPPMSC1(EDTENTRY,"EDIT_PPPEDT15",PATNAME_", "_STANO)
 .;W !,"Entry Updated."
 .;R !,"Press <RETURN> to continue...",TMP:DTIME
 Q
 ;
END ; -- End of code
 Q
 ;
