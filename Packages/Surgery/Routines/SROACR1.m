SROACR1 ;BIR/MAM - OPERATIVE DATA, PAGE 1 ;06/28/06
 ;;3.0; Surgery ;**38,71,93,95,99,125,153**;24 Jun 93;Build 11
 ;
 S SRA(206)=$G(^SRF(SRTN,206)),SRA(209)=$G(^SRF(SRTN,209))
 S SRA(207)=$G(^SRF(SRTN,207)),SRA(207.1)=$G(^SRF(SRTN,207.1)) I $P(SRA(207),"^",27)="" K DA,DIE,DR S DA=SRTN,DIE=130,DR="469////5" D ^DIE K DA,DIE,DR S SRA(207)=$G(^SRF(SRTN,207))
 S SRAO(1)=$P(SRA(207),"^")_"^365",SRAO(2)=$P(SRA(207),"^",2)_"^366",SRAO(3)=$P(SRA(207),"^",24)_"^464",SRAO(4)=$P(SRA(207),"^",25)_"^465",SRAO(5)=$P(SRA(207),"^",20)_"^416"
 S NYUK=$P(SRA(207),"^",3) D YN S SRAO(6)=SHEMP_"^367",NYUK=$P(SRA(207),"^",4) D YN S SRAO(7)=SHEMP_"^368",NYUK=$P(SRA(207),"^",5) D YN S SRAO(8)=SHEMP_"^369"
 S NYUK=$P(SRA(207),"^",6) S SRAO(9)=$S(NYUK="Y":"YES",NYUK="N":"NO",NYUK=1:"AORTIC",NYUK=2:"MITRAL",NYUK=3:"TRICUSPID",NYUK=4:"OTHER/COMBINATION",NYUK=5:"NONE",1:"")_"^370"
 S NYUK=$P(SRA(207),"^",7) D YN S SRAO(10)=SHEMP_"^371",NYUK=$P(SRA(209),"^",9) D YN S SRAO(11)=SHEMP_"^481"
 S NYUK=$P(SRA(209),"^",11) D YN S SRAO(12)=SHEMP_"^483"
 S NYUK=$P(SRA(209),"^",14) S SHEMP=$S(NYUK="F":"FULL MAZE",NYUK="N":"NO MAZE PERFORMED",NYUK="M":"MINI MAZE",1:"") S SRAO(13)=SHEMP_"^512"
 S NYUK=$P(SRA(207),"^",12) D YN S SRAO(14)=SHEMP_"^376"
 S NYUK=$P(SRA(207),"^",13) D YN S SRAO(15)=SHEMP_"^380"
 S NYUK=$P(SRA(207),"^",16) D YN S SRAO(16)=SHEMP_"^378"
 S NYUK=$P(SRA(207),"^",14) D YN S SRAO(17)=SHEMP_"^377"
 S NYUK=$P(SRA(207),"^",18) D YN S SRAO(18)=SHEMP_"^379"
 S NYUK=$P(SRA(207),"^",9) D YN S SRAO(19)=SHEMP_"^373"
 S NYUK=$P(SRA(207),"^",8) D YN S SRAO(20)=SHEMP_"^372"
 S NYUK=$P(SRA(207.1),"^",2) D YN S SRAO(21)=SHEMP_"^505"
 S SRAO(22)=$P($G(^SRF(SRTN,209)),"^",13)_"^502"
 ;
DISP S SRPAGE="PAGE: 1 OF 2" D HDR^SROAUTL
 W "Cardiac surgical procedures with or without cardiopulmonary bypass "
 ;W ! F MOE=1:1:80 W "-"
 W !,"CABG distal anastomoses:",?40,"11. Bridge to transplant/Device:",?75,$P(SRAO(11),"^")
 W !," 1. Number with vein:",?34,$P(SRAO(1),"^"),?40,"12. TMR:",?75,$P(SRAO(12),"^")
 W !," 2. Number with IMA:",?34,$P(SRAO(2),"^"),?40,"13. Maze procedure:",?61,$J($P(SRAO(13),"^"),17)
 W !," 3. Number with Radial Artery:",?34,$P(SRAO(3),"^"),?40,"14. ASD repair:",?75,$P(SRAO(14),"^")
 W !," 4. Number with Other Artery:",?34,$P(SRAO(4),"^"),?40,"15. VSD repair:",?75,$P(SRAO(15),"^")
 W !," 5. Number with Other Conduit:",?34,$P(SRAO(5),"^"),?40,"16. Myectomy for IHSS:",?75,$P(SRAO(16),"^")
 W !,?40,"17. Myxoma resection:",?75,$P(SRAO(17),"^")
 W !," 6. Aortic Valve Replacement:",?34,$P(SRAO(6),"^"),?40,"18. Other tumor resection:",?75,$P(SRAO(18),"^")
 W !," 7. Mitral Valve Replacement:",?34,$P(SRAO(7),"^"),?40,"19. Cardiac transplant:",?75,$P(SRAO(19),"^")
 W !," 8. Tricuspid Valve Replacement:",?34,$P(SRAO(8),"^"),?40,"20. Great Vessel Repair:",?75,$P(SRAO(20),"^")
 W !," 9. Valve Repair:  ",$J($P(SRAO(9),"^"),18),?40,"21. Endovascular Repair:",?75,$P(SRAO(21),"^")
 W !,"10. LV Aneurysmectomy:",?34,$P(SRAO(10),"^"),?40,"22. Other cardiac procedures:" S X=$P(SRAO(22),"^") W ?75,$S(X="N":"NO",X="Y":"YES",1:""),!
 S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P($G(^SRF(SRTN,209.1)),"^") I X'="",X'="NS" S SRQ=0 W !,IORVON_"* Other cardiac procedures (specify): " W:$L(X)<56 X,! I $L(X)>55 S Z=$L(X) D
 .I X'[" " W ?27,X Q
 .S I=0,LINE=1 F  S SRL=$S(LINE=1:39,1:80) D  Q:SRQ
 ..I $E(X,1,SRL)'[" " W X,! S SRQ=1 Q
 ..S J=SRL-I,Y=$E(X,J),I=I+1 I Y=" " W $E(X,1,J-1),! S X=$E(X,J+1,Z),Z=$L(X),I=0,LINE=LINE+1 I Z<SRL W X,! S SRQ=1 Q
 W IORVOFF
 W ! F MOE=1:1:80 W "-"
 Q
CHCK ; compare ischemic time to CPB time
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 N SRISCH,SRCPB S SRISCH=$P(SRA(206),"^",36),SRCPB=$P(SRA(206),"^",37)
 I SRISCH,SRCPB,SRISCH>SRCPB W !,IORVON_"***  NOTE: Ischemic Time is greater than CPB Time!!  Please check.  ***"_IORVOFF,!
 F MOE=1:1:80 W "-"
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
SURE W ! K DIR S DIR("A")="   Sure you want to delete all Misc. Cardiac Procedures information ? ",DIR("B")="NO",DIR(0)="YA" D ^DIR W ! K DIR S SRYN=Y I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
