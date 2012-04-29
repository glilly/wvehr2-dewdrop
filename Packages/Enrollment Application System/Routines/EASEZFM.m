EASEZFM ;ALB/jap - Filing 1010EZ Data to Patient Database ;10/12/00  13:08
 ;;1.0;ENROLLMENT APPLICATION SYSTEM;;Mar 15, 2001
 ;
QUE ;entry point from queued background job
 ;
 ;check signature verification before continuing
 Q:'$G(EASAPP)
 Q:'$D(^EAS(712,EASAPP,0))
 S EASEZNEW=$P(^EAS(712,EASAPP,0),U,11)
 S X=$G(^EAS(712,EASAPP,1))
 ;recheck signature status
 I ('$P(X,U,1))&('$P(X,U,2)) D  Q
 .;remove filing date if can't continue
 .S FDT=$P(^EAS(712,EASAPP,2),U,5),$P(^EAS(712,EASAPP,2),U,5)="",$P(^EAS(712,EASAPP,2),U,6)="",$P(^EAS(712,EASAPP,2),U,11)=""
 .I FDT K ^EAS(712,"FIL",FDT,EASAPP)
 .D APPINDEX^EASEZU2(EASAPP)
 ;
 L +^EAS(712,EASAPP)
 ;check incoming data
 D CHECK
 ;
 ;get EZ1010 data into ^TMP("EZDATA" array
 D EN^EASEZC1(EASAPP,.EASDFN)
 ;
 ;store file #2 data
 D F2^EASEZF1(EASDFN)
 ;
 ;store file #408.12, #408.13, #408.21, #408.22 data
 D F408^EASEZF2(EASAPP,EASDFN)
 ;
 ;store file #355.33 data;
 ;call IB API to file health insurance and Medicare data
 D IBINS^EASEZF5(EASAPP,EASDFN)
 ;
 ;update 'new patient' remark
 I EASEZNEW D
 .S REM="New Patient record added by ELECTRONIC 10-10EZ."
 .S DA=EASDFN,DIE="^DPT(",DR=".091///^S X=REM"
 .D ^DIE
 ;update processing status if not already done
 I $P($G(^EAS(712,EASAPP,2)),U,5)="" D SETDATE^EASEZU2(EASAPP,"FIL")
 ;remove the task id
 S $P(^EAS(712,EASAPP,2),U,11)=""
 L -^EAS(712,EASAPP)
 Q
 ;
CHECK ;check data
 ;returns '0' if any invalid data found; otherwise '1'
 N SUBIEN,X,CHK,DIK,DA
 ;remove any 'noise' from incoming data
 S SUBIEN=0 F  S SUBIEN=$O(^EAS(712,EASAPP,10,SUBIEN)) Q:+SUBIEN=0  D
 .S CHK=$P($G(^EAS(712,EASAPP,10,SUBIEN,1)),U,1)
 .I (CHK="/")!(CHK="//")!(CHK="-")!(CHK="--")!(CHK=" ")!(CHK="") D
 ..S DA=SUBIEN,DA(1)=EASAPP,DIK="^EAS(712,"_DA(1)_",10,"
 ..D ^DIK
 Q
 ;
CLEAN ; cleanup
 K ^TMP("EZDATA",$J),^TMP("EZINDEX",$J),^TMP("EZTEMP",$J),^TMP("EZDISP",$J)
 Q
