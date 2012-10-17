SDWLRP4 ;IOFO BAY PINES/TEH - WAITING LIST - MERGE RPC;06/28/2002 ; 26 Aug 2002  1:25 PM
        ;;5.3;scheduling;**263**;AUG 13 1993;Build 18
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
INPUT(SDWLRES,SDWLSTR)  ;
        ;
        ;     
        ; Input:
        ;   SDWLSTR = location of data = ^TMP("SDWLG",$J,i,0)
        ;   (R) = Required Field
        ;   (O) = Optional
        ;   
        ;   .01                2             3        4          5           9               10        11           23       22
        ;  SSN (R)^ORIGINATING DATE^INSTITUTION^TYPE (R)^^TYPE MOD^ORGINATING USER (R)^PRIORITY^REQUEST BY^CURRENT STATUS^DESIRED DATE
        ;    1              2                3        4        6/7/8/9       10               11       12              17    16   
        ;
        ;  Output:
        ;               SDWLRES  =  -1^MESSAGE      Failed
        ;               SDWLRES  =  1^IEN  Saved to ^SDWL(409.3,IEN,0)            
        ;
        ;
        K ^TMP("SDWLIN",$J),^TMP("SDWLOUT",$J),^TMP("DIERR",$J),D
        I '$G(SDWLSTR) S SDWLRES="-1^Data String Missing^Failed" Q
        I $P(SDWLSTR,U)="" S SDWLRES="-1^No SSN^Failed" Q
        I $P(SDWLSTR,U,3)="" S SDWLRES="-1^No Insitution^Failed" Q
        I $P(SDWLSTR,U,4)="" S SDWLRES="-1^No Type^Failed" Q
        I $P(SDWLSTR,U,6)="",$P(SDWLSTR,U,7)="",$P(SDWLSTR,U,8)="",$P(SDWLSTR,U,9)="" S SDWLRES="-1^No Type Modifier^Failed" Q
        I $P(SDWLSTR,U,11)'="",$$DCHK($P(SDWLSTR,U,11))<1 S SDWLRES="-1^Invalid Date^Failed" Q
        S $P(SDWLSTR,U)=$TR($P(SDWLSTR,U),"-","")
        D NEW
        I $P(SDWLRES,U,1)<0 Q
        D FDA I SDWLRES<0 D DEL Q
        D SET I SDWLRES<0 D DEL Q
        D CLEAN^DILF K ^TMP("SDWLIN",$J),^TMP("SDWLOUT",$J)
        Q
NEW     ;Get IEN from ^SDWL(409.3,IEN,0).
        N SDWLTP,SDWL6,SDWL6P,SDWL7,SDWL7P,SDWL8,SDWL8P,SDWL9,SDWL9P,SDWLMOD,SDWLTP,SDWLIN,SDWLDFN
        N SDWLPRI,SDWLODUZ,SDWLRBY
        S SDWLRES=""
        I $P(SDWLSTR,U,4) D
        .S SDWLTP=+$P(SDWLSTR,U,4),(SDWL6,SDWL7,SDWL8,SDWL9)="",SDWLMOD=0 D
        ..I SDWLTP=1 S SDWL6=$P(SDWLSTR,U,6),SDWL6=$O(^SCTM(404.51,"B",SDWL6,"")) I SDWL6'="" S SDWL6P=$O(^SCTM(404.51,"B",SDWL6,0)),SDWLMOD=1
        ..I SDWLTP=2 S SDWL7=$P(SDWLSTR,U,7),SDWL7=$O(^SCTM(404.57,"B",SDWL7,"")) I SDWL7'="" S SDWL7P=$O(^SCTM(404.57,"B",SDWL7,0)),SDWLMOD=1
        ..I SDWLTP=3 S SDWL8=$P(SDWLSTR,U,8),SDWL80="" F  S SDWL80=$O(^DIC(40.7,"B",SDWL8,SDWL80))  Q:SDWL80=""  D
        ...I $D(^SDWL(409.31,"B",SDWL80)) S SDWL8=$O(^SDWL(409.31,"B",SDWL80,0)),$P(SDWLSTR,U,8)=SDWL8,SDWLMOD=1
        ..I SDWLTP=4 S SDWL9=$P(SDWLSTR,U,9),SDWL90="" F SDWL90=$O(^SC("B",SDWL9,SDWL90)) Q:SDWL90=""  D
        ...I $D(^SDWL(409.32,"B",SDWL90)) S SDWL9=$O(^SDWL(409.32,"B",SDWL90,0)),$P(SDWLSTR,U,9)=SDWL9,SDWLMOD=1
        I 'SDWLMOD S SDWLRES="-1^No Type Mod found^Failed" Q
        S SDWLIN=$P(SDWLSTR,U,3) I SDWLIN="" S SDWLRES="-1^No Institution^Failed" Q
        S SDWLIN=$O(^DIC(4,"B",SDWLIN,0)) I SDWLIN="" S SDWLRES="-1^Invalid Institution^Failed" Q
        S SDWLDFN=$P(SDWLSTR,U,1) S D="SSN",DIC(0)="MNZ",X=SDWLDFN,D="SSN",DIC=2 D IX^DIC I Y<0 S SDWLRES="-1^SSN failed" Q
        S SDWLDFN=+Y
        I SDWLDFN="" S SDWLRES="-1^Invalid SSN^Failed" Q
        I $$DUP(SDWLDFN) S SDWLRES="-1^Duplicate^Failed" Q
        S SDWLPRI=$S($P(SDWLSTR,U,11)="":"A",1:"F")
        S SDWLODUZ=.5,SDWLRBY=2
        I SDWLTP=1!(SDWLTP=2) S SDWLPRI="A",SDWLRBY=""
        S SDWLSTRN=SDWLTP_"^"_SDWLPRI_"^"_SDWLODUZ_"^"_SDWLRBY_"^"_SDWL6_"^"_SDWL7_"^"_SDWL8_"^"_SDWL9
        S DIC(0)="LX",X=SDWLDFN,DIC="^SDWL(409.3," D FILE^DICN I Y<0 S SDWLRES="-1^IEN failed^Failed" Q
        S SDWLDFN=$P(Y,U,2),SDWLDA=+Y,SDWLDUZ=$P(SDWLSTR,U,9)
        S DIE="^SDWL(409.3,",DA=SDWLDA
        I SDWLPRI="F" D
        .S DR="22///"_$P(SDWLSTR,U,11) D ^DIE
        I SDWLPRI="A",SDWLTP=3!(SDWLTP=4) D
        .S DR="22///^S X=DT" D ^DIE
        S DR="1////^S X=DT" D ^DIE
        S DR="2////^S X=SDWLIN" D ^DIE
        S DR="23////^S X=""O""",DIE="^SDWL(409.3," D ^DIE K DIE,DR,DA
        ;
        ;SET DATE OF DEATH
        ;
        S X=$$GET1^DIQ(2,SDWLDFN_",",".351") I X'="" D
        .S DA=SDWLDA
        .S DR="19////^S X=DT",DIE="^SDWL(409.3," D ^DIE
        .S DR="20////^S X=DUZ" D ^DIE
        .S DR="23////^S X=""C""" D ^DIE
        .S DR="21////^S X=""D""" D ^DIE K DIE,DR,DA
        ;
        ;DETERMINE ENROLLEE STATUS
        ;
        ;SDWLE=1 = NEW ENROLLEE
        ;SDWLE=2 = ESTABLISHED
        ;SDWLE=3 = PRIOR ENROLLEE
        ;SDWLE=4 = UNDETERMINED
        ;
        S SDWLDE=+$H,SDWLE=1,SDWLEE=0 D SB1
        G SB0:SDWLE=2
        S SDWLRNE=$$ENROLL^EASWTAPI(SDWLDFN) S SDWLRNED=$P(SDWLRNE,U,3)
        I SDWLRNED S X=SDWLRNED D H^%DTC S SDWLDS=%H S SDWLDE=+$H,SDWLDET=SDWLDE-SDWLDS I SDWLDET<366 S SDWLE=1
        I $D(SDWLDET),SDWLDET>365 S SDWLE=3
        I 'SDWLRNE S SDWLE=4
SB0     S SDWLRNE=$S(SDWLE=1:"N",SDWLE=2:"E",SDWLE=3:"P",SDWLE=4:"U")
        ;-Code here for filling in 409.3
        S DR="27////^S X=SDWLRNE",DIE="^SDWL(409.3,",DA=SDWLDA D ^DIE
        S DR="9////^S X=DUZ" D ^DIE K DIE,DA,DR,%H
        Q
SB1     I '$D(^DGCN(391.91,"B",SDWLDFN)) S SDWLE=3 Q
        S SDWLX="" F  S SDWLX=$O(^DGCN(391.91,"B",SDWLDFN,SDWLX)) Q:SDWLX=""  D
        .S SDWLY=$G(^DGCN(391.91,SDWLX,0)),SDWLD=$P(^(0),U,3) I SDWLD S X=SDWLD D H^%DTC S SDWLEE=SDWLDE-%H I SDWLEE<730 S SDWLE=2
        .I $D(SDWLEE),SDWLEE>730 S SDWLE=3
        Q
FDA     ;Get data from SDWLSTR string and set FDA.
        S SDWLF=409.3
        S SDWLVAL="" F SDWLI=1,2,3,4,5,6,7,8 S SDWLVAL=$P(SDWLSTRN,"^",SDWLI) D
        .S SDWLFLD=SDWLI D
        ..S SDWLFLD=$S(SDWLFLD=1:4,SDWLFLD=2:10,SDWLFLD=3:9,SDWLFLD=4:11,SDWLFLD=5:5,SDWLFLD=6:6,SDWLFLD=7:7,SDWLFLD=8:8)
        .S SDWLFLG="F",SDWLIEN=$$IENS^DILF(SDWLDA) ;,SDWLVAL=$$EXTERNAL^DILFD(SDWLF,SDWLFLD,,SDWLVAL,"SDWLMSG")
        .I $D(SDWLMSG) M SDWLRES=SDWLMSG S SDWLRES=-1 Q
        .D FDA^DILF(SDWLF,SDWLIEN,SDWLFLD,"",SDWLVAL,"^TMP(""SDWLIN"",$J)")
        .S SDWLRES=1 M SDWLRES("SDWLIN")=^TMP("SDWLIN",$J)
        Q
VAL     ;Validate fields
        ;
        D VALS^DIE(,"^TMP(""SDWLIN"",$J)","^TMP(""SDWLOUT"",$J)","SDWLMSG")
        I $G(SDWLMSG("DIERR")) S SDWLRES=-1 Q
        M SDWLRES("SDWLOUT")=^TMP("SDWLOUT",$J)
        Q
        ;
SET     ;Input data to file ^SDWL(409.3,IEN,0)
        D UPDATE^DIE(,"^TMP(""SDWLIN"",$J)","SDWLMSG")
        I $G(SDWLMSG("DIERR")) S SDWLRES=-1 Q
        K DIC,DA
        S SDWLRES=1_"^"_$G(SDWLDA)
        Q
DEL     S DA=SDWLDA,DIK="^SDWL(409.3," D ^DIK K DIK,DA
        S SDWLRES="-1^Entry "_SDWLDA_" Deleted"
        Q
DUP(IEN)        ;Duplicate Check
        ;if institution, wait list type, and wait list modifier are the same it's a duplicate
        ;SDWLV1  :  IEN in 409.3
        ;SDWLV2  :  Zero node of 409.3
        ;SDWLV3  :  Wait List Type Modifier value passed in
        ;SDWLV4  :  Wait List Type Modifier value in current record
        ;SDWLIN  :  Institution value passed in checked against piece 3 of current record
        ;SDWLSTR :  Incoming value string
        ;           Wait List Type piece 4 of SDWLSTR (incoming value) checked against piece 5
        ;           of SDWLV2 (zero node of current record
        N SDWLV1,SDWLV2,SDWLV3,SDWLV4,SDWLV5
        S (SDWLV1,SDWLV5)=0
        F  S SDWLV1=$O(^SDWL(409.3,"B",IEN,SDWLV1)) Q:('SDWLV1!SDWLV5)  D
        . S SDWLV2=$G(^SDWL(409.3,SDWLV1,0)) Q:SDWLV2=""
        . S SDWLV3=$S($P(SDWLSTR,U,4)=1:SDWL6,$P(SDWLSTR,U,4)=2:SDWL7,$P(SDWLSTR,U,4)=3:SDWL8,$P(SDWLSTR,U,4)=4:SDWL9,1:0)
        . S SDWLV4=$S($P(SDWLV2,U,5)=1:$P(SDWLV2,U,6),$P(SDWLV2,U,5)=2:$P(SDWLV2,U,7),$P(SDWLV2,U,5)=3:$P(SDWLV2,U,8),$P(SDWLV2,U,5)=4:$P(SDWLV2,U,9),1:0)
        . I $P(SDWLV2,U,3)=SDWLIN,$P(SDWLSTR,U,4)=$P(SDWLV2,U,5),SDWLV3=SDWLV4 S SDWLV5=1 Q
        Q SDWLV5
DCHK(VALID)     ;Check for valid DESIRED DATE
        N X
        S X=VALID,%DT="X" D ^%DT
        Q Y
