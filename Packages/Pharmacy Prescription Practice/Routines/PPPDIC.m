PPPDIC ;;OIFIO BAY PINES/ELR - UPDATE DESCRIPTION OF FILE 1020.2 - 8/11/2003
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**38**;APR 7,1995
 Q
START ;
 I '$D(^DIC(1020.2)) D ZTQUE Q
 K ^XTMP("PPPDIC",$J)
 S ^XTMP("PPPDIC",$J,1)=""
 S ^XTMP("PPPDIC",$J,2)="This file contains SSN, last date of visit at each facility, and other"
 S ^XTMP("PPPDIC",$J,3)="data for patients who have visited other VA facilities. This file is"
 S ^XTMP("PPPDIC",$J,4)="created everytime PPP Build FFX is run.  It is updated everytime"
 S ^XTMP("PPPDIC",$J,5)="PPP Batch is run. This file contains approximately 10% of the VA"
 S ^XTMP("PPPDIC",$J,6)="patient population.  This file excludes local facility data."
 S ^XTMP("PPPDIC",$J,7)=""
 S ^XTMP("PPPDIC",$J,8)="Per VHA Directive 10-93-142, this file definition should not be modified."
 S PPPDA="1020.2"
 D FDA
 D SET
 K ^XTMP("PPPDIC",$J)
 K PPPDA,PPPIENS
 Q
FDA ;
 S PPPIENS=$$IENS^DILF(.PPPDA)
 D FDA^DILF(1,PPPIENS,4,"","^XTMP(""PPPDIC"",$J)","FDA(1020.2)")
 Q
SET D UPDATE^DIE("","FDA(1020.2)","PPPIENS")
 I $G(^TMP("DIERR",$J,1)) D ZTQUE
 Q
BULL ; Bulletin for failed update
 N PPPLN,PPPMSG S PPPLN=0
 K ^TMP("PPPDIC",$J)
 S XMSUB="DICITONARY MAINTENANCE (FILE 1020.2) " K XMY
 S XMTEXT="^TMP(""PPPDIC"",$J,"
 S XMY($S(DUZ:DUZ,1:.5))=""
 S XMDUZ=.5 D NOW^%DTC
 S PPPMSG=" " D SETLN
 S PPPMSG="The update of file PPP FOREIGN FACILITY XREF (1020.2) description failed." D SETLN
 S PPPMSG=" " D SETLN
 D ^XMD
 K ^TMP("PPPDIC",$J),XMY,XMTEXT,XMSUB
 Q
SETLN ; Setting TMP global for bulletin
 S PPPLN=PPPLN+1
 S ^TMP("PPPDIC",$J,PPPLN)=PPPMSG
 Q
ZTQUE   ;
 N ZTIO,ZTDTH,ZTDESC,ZTRTN,ZTSAVE
 S ZTIO="",ZTDTH=$H,$P(ZTDTH,",",2)=$P(ZTDTH,",",2)+60,ZTDESC="PPPDIC ERROR"
 S ZTRTN="BULL^PPPDIC"
 D ^%ZTLOAD
 Q
