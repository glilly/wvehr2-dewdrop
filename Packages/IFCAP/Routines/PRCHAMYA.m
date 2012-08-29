PRCHAMYA ;WISC/DJM-MOVING AMENDMENT INFO FROM 443.6 TO 442 ;3/23/95  2:01 PM
V ;;5.1;IFCAP;**6,21,59,74**;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
CHECK(PRCHPO,PRCHAM,FLAG) ;CHECK OUT EACH 'CHANGES' ENTRY.  IF THE OLD DATA AND THE NEW DATA
 ;ARE THE SAME REMOVE THE 'CHANGES' ENTRY.
 ;'PRCHPO' IS THE RECORD IN FILE 443.6 THAT WAS JUST OBLIGATED.
 ;'PRCHAM' IS THE AMENDMENT ,IN 'PRCHPO', THAT WAS JUST OBLIGATED.
 ;'FLAG' IS AN ERROR FLAG.  FOR NOW 'FLAG' WILL ONLY RETURN 1.
 N PRCI,CERT,CHANGS,PRCI,DIQ,DIC,PRCJ,J1,J2,J3,J4,DR,VAL,DIE,FX,PRCHTOTQ,PRCHXXXX,%X,%Y,HOLD,NEW,PRCSUM,PRCSIG,ROUTINE,ITEM,DISCNT,PROMPT,DIR,CHECK,DA,FIELD,FLAG,PRCJ1,PRCJ2,VAL1,EXIT,DIWL,DIWR,DIWF,TYPAM,VALFLG,PPFLG,LINE,ITEM1
 K PRCHNORE
 S PRCI=0,DIQ(0)="I",VALFLG=0
 ;LEAVE 'CHANGES' ENTRY 1 (THE ORGINAL VALUE OF THE 'NET AMOUNT' FIELD) ALONE.
 ;THIS ENTRY MUST STAY IN THE 'CHANGES' MULTIPLE BECAUSE IT IS NEEDED
 ;TO BE ABLE TO UPDATE THE FUND CONTROL POINT BALANCE AFTER THIS
 ;AMENDMENT IS OBLIGATED/SIGNED OFF.
 F  S PRCI=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,PRCI)) G:PRCI'>0 COPY S DA=PRCHPO,DIC=443.6 D:PRCI>1
 .S PRCJ=$G(^PRC(443.6,PRCHPO,6,PRCHAM,3,PRCI,0))
 .S J1=$P(PRCJ,U,3)
 .S J2=$P(J1,":",2),J3=$P($P(J1,";",2),":"),J4=$P(J1,";")
 .Q:$P(J3,".")=442
 .K DR
 .I J2>0 S DR=J2,DR(J3)=J4,DA(J3)=$P(PRCJ,U,4)
 .I J2="" S DR=J4
 .I $P(PRCJ,U,7)>0 S DIC=J3,DA=$P(PRCJ,U,7)
 .S DIQ="FIELD" D EN^DIQ1
 .I J2=40,J4=1 K ^UTILITY($J,"W"),^TMP($J,"W") S EXIT=0,VAL1=0,DIWL=1,DIWR=80,DIWF="C80|",PRCJ1=$P(PRCJ,U,4),PRCJ1(PRCJ1)="" D  G FIX:EXIT=1,REMOVE
 ..F  S VAL1=$O(FIELD(443.61,PRCJ1,1,VAL1)) Q:VAL1'>0  S X=$G(FIELD(443.61,PRCJ1,1,VAL1)) D ^DIWP
 ..S %X="^UTILITY($J,""W"",",%Y="^TMP($J,""W""," D %XY^%RCR
 ..S VAL1=0 K ^UTILITY($J,"W")
 ..F  S VAL1=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,PRCI,1,VAL1)) Q:VAL1'>0  S X=(^(VAL1,0)) D ^DIWP
 ..I ^TMP($J,"W",1)'=^UTILITY($J,"W",1) S EXIT=1 Q
 ..S VAL1=0 F  S VAL1=$O(^TMP($J,"W",1,VAL1)) Q:VAL1'>0  I $G(^TMP($J,"W",1,VAL1,0))'=$G(^UTILITY($J,"W",1,VAL1,0)) S EXIT=1 Q
 ..Q
 .S VAL=$G(FIELD($S(J3>0:J3,1:443.6),$S(J3["443.6":$P(PRCJ,U,4),J3["441.7":$P(PRCJ,U,7),1:PRCHPO),J4,"I"))
 .S CHECK=^PRC(443.6,PRCHPO,6,PRCHAM,3,PRCI,1,1,0)
 .I CHECK'=VAL,VAL'="" D  G FIX
 ..;
 ..;Update contract changes (See MEM-0596-70183)
 ..I $P($P(PRCJ,U,2,3),":")="23^4;443.61" D  ;
 ...KILL ^PRC(442,PRCHPO,2,"AC",CHECK,$P(PRCJ,U,4))
 ...S ^PRC(442,PRCHPO,2,"AC",VAL,$P(PRCJ,U,4))=""
 .;
 .I CHECK'=VAL,VAL="" S TYPAM=$P($G(PRCJ),U,2)
 .S VALFLG=0
 .S PPFLG=0
 .I $G(TYPAM)=28,(VAL="") S VALFLG=1
 .I $G(TYPAM)=33,(VAL="") S PPFLG=1
 .I $G(TYPAM) I TYPAM=28!(TYPAM=29)!(TYPAM=37) G FIX
REMOVE .S DR=".01///@",DIE="^PRC(443.6,"_PRCHPO_",6,"_PRCHAM_",3,",DA(2)=PRCHPO,DA(1)=PRCHAM,DA=PRCI D ^DIE Q
FIX .S J3=$S(J3=443.61:442.01,J3=443.66:442.06,J3=443.67:442.07,J3=443.624:442.15,J3=443.63:442.03,J3=441.7:442.8,1:"")
 .S FX=J4_";"_J3_":"_J2,$P(^PRC(443.6,PRCHPO,6,PRCHAM,3,PRCI,0),U,3)=FX
COPY ;THIS STEP WILL COPY THE P.O. FROM 443.6 BACK TO 442.
 ;FIRST GET THE PRESENT 'TOTAL AMOUNT' FIELD, #91.
 ;THIS VALUE IS NEEDED TO CALCULATE THE AMOUNT CHANGED.  THIS CHANGE
 ;WILL BE ENTERED INTO THE 'AMOUNT CHANGED' FIELD, FIELD 50 - SUBFIELD
 ;2, FOR THIS AMENDMENT.
 ;LATER ON, WITHIN THESE ROUTINES, THE 'TOTAL AMOUNT' FIELD WILL BE
 ;UPDATED.  THUS, SAVING IT HERE.
 S PRCHTOTQ=$P(^PRC(442,PRCHPO,0),U,15)
 K PRCHXXXX S %X="^PRC(443.6,"_PRCHPO_",",%Y="^PRC(442,"_PRCHPO_","
C2 ;ENTER HERE TO COPY NEW P.O. BACK INTO 442.  BOTH %X AND %Y NEED TO
 ;BE SET WHEN USING THIS ENTRY POINT.  'PRCHPO' NEEDS TO BE SET TO THE
 ;RECORD THAT IS TO BE COPIED.
 I $G(VALFLG) K ^PRC(442,PRCHPO,15) S VALFLG=0
 I $G(PPFLG) K ^PRC(442,PRCHPO,5) S PPFLG=0
 ;
 ;Delete current PO item description in file 442, so that it is
 ;properly updated with an amended item description from file 443.6
 ;See NOIS CTX-0296-70401 
 I J2=40,J4=1 D  ;
 . S ITEM1=""
 . F  S ITEM1=$O(PRCJ1(ITEM1)) Q:'ITEM1  D  ;
 . . S LINE=0 F  S LINE=$O(^PRC(442,PRCHPO,2,ITEM1,1,LINE)) Q:'LINE  D  ;
 . . . I $D(^PRC(442,PRCHPO,2,ITEM1,1,LINE,0)) D  ;  
 . . . . KILL ^PRC(442,PRCHPO,2,ITEM1,1,LINE,0)
 ;
 S HOLD=$G(^PRC(442,PRCHPO,6,0)) D %XY^%RCR
 ;
 ;The copy from 443.6 to 442 is done.  If an item does not have a
 ;contract number, but it has an AC cross reference then remove it.
 ;See NOIS: MEM-0596-70183
 I $D(^PRC(442,PRCHPO,2,"AC")) D  ;
 . NEW CONTRACT
 . S CONTRACT=""
 . F  S CONTRACT=$O(^PRC(442,PRCHPO,2,"AC",CONTRACT)) Q:CONTRACT=""  D
 . . I '$D(^PRC(443.6,PRCHPO,2,"AC",CONTRACT)) D
 . . . KILL ^PRC(442,PRCHPO,2,"AC",CONTRACT)
 ;
 ;There has been a change in vendor.  Update the files.
 ;See NOIS FGH-1202-32075
 N NEWVEN,OLDVEN,NODE,AMEND
 S NEWVEN=$G(FIELD(443.6,PRCHPO,5,"I"))
 I NEWVEN D  ;
 . S AMEND=$P(^PRC(443.6,PRCHPO,6,0),U,3)
 . S NODE=$O(^PRC(443.6,PRCHPO,6,AMEND,3,"AC",31,5,""))
 . S OLDVEN=^PRC(443.6,PRCHPO,6,AMEND,3,NODE,1,1,0)
 . I OLDVEN KILL ^PRC(442,"D",OLDVEN,PRCHPO)
 . S DA=PRCHPO,DR="5////"_NEWVEN,DIE="^PRC(442,"
 . D ^DIE
 ;
 ;There has been a change in Purchase Order number.
 ;See NOIS LOM-0302-62930
 I $P(PRCJ,U,2)=32 D  ;
 . NEW CP,NEWPO,VENDOR
 . S NEWPO=$P($G(^PRC(443.6,PRCHPO,23)),U,4)
 . Q:NEWPO=""
 . S VENDOR=$P($G(^PRC(443.6,PRCHPO,1)),U)
 . S CP=$P(PRC("CP")," ")          ;Control point
 . S ^PRC(442,"D",VENDOR,NEWPO)="" ;Set up "D" X-ref for PO display
 . S ^PRC(442,"E",CP,NEWPO)=""     ;Set up "E" X-ref for PO display
 . S CP=PRC("SITE")_CP             ;Station & control point
 . ;
 . ;Get items from PO to setup item master file history
 . NEW CNT,ITEM,ITEMNUM
 . S ITEMNUM=0
 . F  S ITEMNUM=$O(^PRC(443.6,PRCHPO,2,ITEMNUM)) Q:'ITEMNUM  D
 . . S ITEM=$P(^PRC(443.6,PRCHPO,2,ITEMNUM,0),U,5)
 . . QUIT:ITEM=""
 . . S ^PRC(441,ITEM,4,CP,1,NEWPO,0)=NEWPO
 . . S ^PRC(441,ITEM,4,CP,1,"AC",9999999-PRC("PODT"),NEWPO)=""
 . . S $P(^PRC(441,ITEM,4,CP,1,0),U,3)=NEWPO
 . . S CNT=$P(^PRC(441,ITEM,4,CP,1,0),U,4)
 . . S $P(^PRC(441,ITEM,4,CP,1,0),U,4)=CNT+1
 ;
 I HOLD]"" S $P(HOLD,U,3)=PRCHAM,$P(HOLD,U,4)=$P(HOLD,U,4)+1,$P(HOLD,U,2)=$P(^DD(442,50,0),U,2),^PRC(442,PRCHPO,6,0)=HOLD
 S NEW=$G(^PRC(443.6,PRCHPO,23))
 S PRCSUM=$$SUM^PRCUESIG(PRCHPO_"^"_$$STRING^PRCHES5(^PRC(442,PRCHPO,0),^PRC(442,PRCHPO,1),^PRC(442,PRCHPO,12)))
 S PRCSIG="" D RECODE^PRCHES5(PRCHPO,PRCSUM,.PRCSIG) S ROUTINE="PRCHAMYA"
 G:PRCSIG<1 QQ K PRCSUM
 ;AFTER MOVING INTO 442 NOW UPDATE ANY ZERO NODE OF A MULTIPLE FIELD
 ;FROM THE 'DD'
 S ITEM=$G(^PRC(442,PRCHPO,2,0)),$P(ITEM,U,2)=$P(^DD(442,40,0),U,2),^PRC(442,PRCHPO,2,0)=ITEM
 S DISCNT=$G(^PRC(442,PRCHPO,3,0)) I DISCNT]"" S $P(DISCNT,U,2)=$P(^DD(442,14,0),U,2),^PRC(442,PRCHPO,3,0)=DISCNT
 S PROMPT=$G(^PRC(442,PRCHPO,5,0)) I PROMPT]"" S $P(PROMPT,U,2)=$P(^DD(442,9.2,0),U,2),^PRC(442,PRCHPO,5,0)=PROMPT
 S CHANGS=$G(^PRC(442,PRCHPO,6,0)) I CHANGS]"" S $P(CHANGS,U,2)=$P(^DD(442,50,0),U,2),^PRC(442,PRCHPO,6,0)=CHANGS
 S CHANGS=$G(^PRC(442,PRCHPO,6,PRCHAM,3,0)) I CHANGS]"" S $P(CHANGS,U,2)=$P(^DD(442.07,14,0),U,2),^PRC(442,PRCHPO,6,PRCHAM,3,0)=CHANGS
 S CERT=$G(^PRC(442,PRCHPO,15,0)) I CERT]"" S $P(CERT,U,2)=$P(^DD(442,24,0),U,2),^PRC(442,PRCHPO,15,0)=CERT
 I NEW]""&($P(NEW,U,4)>0)&($P(NEW,U,4)'=PRCHPO) S PRCHXXXX=PRCHPO,PRCHPO=$P(NEW,U,4),%X="^PRC(443.6,"_PRCHPO_",",%Y="^PRC(442,"_PRCHPO_"," G C2
 S PRCHPO=$S($D(PRCHXXXX):PRCHXXXX,1:PRCHPO)
 S DA(1)=PRCHPO,N=0,DIK(1)=".01^C" F  S N=$O(^PRC(442,DA(1),2,N)) Q:'N  D
 .S DA=N,DIK="^PRC(442,"_DA(1)_",2," D EN^DIK
 K DA,DIK,N
 G ^PRCHAMYB
QQ W !!,$$ERR^PRCHQQ(ROUTINE,PRCSIG) W:PRCSIG=0!(PRCSIG=-3) !,"Notify Application Coordinator!"  S DIR(0)="EAO",DIR("A")="Press <Return> to continue " D ^DIR S FLAG=1 Q
