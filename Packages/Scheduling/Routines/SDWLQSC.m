SDWLQSC        ;IOFO BAY PINES/TEH,DMR - WAITING LIST-SC PRIORITY BACKGROUND ;09/02/2004 2:10 PM [4/21/05 8:04pm]
 ;;5.3;scheduling;**327,394,467,446**;AUG 13, 1993;Build 77
 ;
 ;SD*5.3*327       EWL Updates Phase II - Addition of EWL notification messages.
 ;SD*5.3*394       New Routine for background update of SDWL(409.3) SC priorities.
 ;SD*5.3*467       Match canceled appts in 409.3            
 ;This routine will run as a background job to determine changes in SC disabilities and update
 ;the priority of the wait list visit. A mailman message will then be sent to the EWL mail group.
 ;Vars: SDWLDFN=EWL IEN
 ;      SDWLSC1=EWL RECORDED SC %
 ;      SDWLSC2=PATIENT FILE (2) CURRENT SC %          
 ;DBIAs: 1476 reference to PRIMARY ELIG. ^DPT(IEN,.372)
 ;        427 reference to ^DIC(8)                               
 Q
EN ;Use SDWL(409.3) to determine SC changes and priority.
 S SDWLDFN=0 F  S SDWLDFN=$O(^SDWL(409.3,"B",SDWLDFN)) Q:SDWLDFN<1  D
 .S SDWLDA=0,SDWLME=0 F  S SDWLDA=$O(^SDWL(409.3,"B",SDWLDFN,SDWLDA)) Q:SDWLDA=""  D
 ..L ^SDWL(409.3,SDWLDA):5 I '$T Q
 ..I $P($G(^SDWL(409.3,SDWLDA,0)),U,17)["C" Q  ;I EWL entry has been 'CLOSED' don't process.
 ..S SDWLME=SDWLME+1
 ..S SDWLSC1=+$P($G(^SDWL(409.3,SDWLDA,"SC")),U,1)
 ..S SDWLSC2=+$$GET1^DIQ(2,SDWLDFN_",",.302,,"SDWLX","")
 ..I SDWLSC1=SDWLSC2 S SDWLSC4=1 Q
 ..S SDWLSCX=0,SDWLSC3=0,SDWLSC4=0
 ..I SDWLSC2<50,SDWLSC1>49 D
 ...S SDWLSC3=1,SDWLSC4=1,DA=SDWLDA,DR="14////^S X=SDWLSC2",DIE=409.3 D ^DIE,SET1
 ..I SDWLSC2>49,SDWLSC1>49 S SDWLSCX=SDWLSC2 D SET0 Q
 ..I SDWLSC2>49,SDWLSC1<50 S SDWLSCX=SDWLSC2 D SET0,SET1 Q
 ..I SDWLSC2<50,SDWLSC1<50 S SDWLSC3=1,SDWLSC4=1,SDWLSCX=SDWLSC2 D SET0,SET1 Q
 ..I '$D(^SDWL(409.3,SDWLDA,"SC")) D
 ...I SDWLSC2>49 S SDWLSCX=SDWLSC2 D SET0,SET1 Q  ;Set "SC" node if not defined.
 ...I SDWLSC2<50 S SDWLSC3=1,SDWLSC4=1,DA=SDWLDA,DR="14////^S X=SDWLSC2",DIE=409.3 D ^DIE,SET1
 ..K SDWLSSN,SDWLSC2,SDWLSC1,SDWLSC3,SDWLSCP,SDWLX,SDWLI,SDWLSCX
 ..L  Q
 I $D(SDWLSC4),SDWLSC4 D
 .I $D(^TMP("SDWLQSC2",$J)) D MESS1^SDWLMSG
 I $D(^TMP("SDWLQSC1",$J)) D MESS^SDWLMSG
 K SDWLDA,SDWLDFN,SDWLSC1,SDWLSC2,SDWLSC3,SDWLSC4,DA,DR,DIC,DIE,X,SDWLX,SDWLNAM,SDWLSSN,SDWLSCX,SDWLWRT,SDWLME
 D EN2^SDWLQSC1 D EN3
 K IEN,DFN,APPT,WLAPPT,STOP,WLSTAT,STATUS,NN,SDREC,SDARRAY,SDAPPT,CL,CLINIC,SDC,SDDFN,SDNAME,SDAPPST,CIEN,SDWL
 K SDCL,SDIEN,CC,SDREACT,SDINACT,CLINICS,TEAM,TEAMN,WLOPEN,PIEN,POS,POSN,SDWLPOS,EDATE,DOD,DIS,NAME,MAX,AVAL,SDFORM
 Q
SET0 ;Set EWL file with current SC percentage.
 S DA=SDWLDA,DR="14////^S X=SDWLSCX",DIE=409.3 D ^DIE
 I SDWLSC2=50!(SDWLSC2>50) S DR="15////^S X=1" D ^DIE
 K DA,DR,X,DIE
 Q
SET1 ;Set temporary file for message.
 F SDWLI=.01,.09 S SDWLX(SDWLI)=$$GET1^DIQ(2,SDWLDFN_",",SDWLI,,"SDWLX","")
 S SDWLNAM=$E($G(SDWLX(.01)),1,27),SDWLSSN=$E($G(SDWLX(.09)),6,99)
 S SDWLSCP=$$GET1^DIQ(409.3,SDWLDA_",",15,,"SDWLSCP","")
 S SDWLWRT=SDWLNAM,SDWLWRT=SDWLWRT_$J(SDWLSSN,(35-$L(SDWLNAM)))
 S SDWLWRT=SDWLWRT_$J(SDWLSC1,8),SDWLWRT=SDWLWRT_$J(SDWLSC2,16-$L(SDWLSC1))
 I 'SDWLSC3 S SDWLWRT=SDWLWRT_$J(SDWLSCP,15)
 I SDWLSC3 S SDWLWRT=SDWLWRT_$J($S(SDWLME>1:"YES",1:"NO"),15)
 I SDWLSC3 S ^TMP("SDWLQSC2",$J,SDWLDFN)=SDWLWRT Q
 S ^TMP("SDWLQSC1",$J,SDWLDFN)=SDWLWRT
 Q
APPT(CLINIC,IEN) ;
 S (SDREC,SDARRAY)=""
 S SDARRAY(1)=WLAPPT_";"_WLAPPT
 S SDARRAY(4)=DFN
 S SDARRAY("FLDS")="3;2;4;1"
 S SDREC=$$SDAPI^SDAMA301(.SDARRAY)
 IF SDREC>0 D
 .S (CL,SDC,SDDFN,SDNAM,SDAPPT,SDAPPST,NN)=""
 .S CL=$O(^TMP($J,"SDAMA301",DFN,"")) Q:CL=""  ;Current Clinic
 .S SDAPPST=$P($G(^TMP($J,"SDAMA301",DFN,CL,WLAPPT)),"^",3),SDAPPST=$P(SDAPPST,";")  ;Appt Status
 .I CL'=CLINIC!(SDAPPST="CC") D
 ..S SDDFN=$P($G(^TMP($J,"SDAMA301",DFN,CL,WLAPPT)),"^",4) IF SDDFN'="" S SDNAM=$P($G(SDDFN),";",2),SDNAM=$E(SDNAM,1,30)
 ..S SDC=$P($G(^TMP($J,"SDAMA301",DFN,CL,WLAPPT)),"^",2)
 ..S SDC=$$GET1^DIQ(44,CL_",",.01),SDC=$E(SDC,1,25)
 ..S Y=WLAPPT D DD^%DT S SDAPPT=Y
 ..IF CL'=CLINIC S SDC=SDC_"(new)"  ;to distinguish another clinic"
 ..S SDFORM=$$FORM^SDFORM(SDNAM,32,SDC,27,SDAPPT,21)
 ..S NN=NN+1,^TMP("SDWLQSC3",$J,NN)=SDFORM
 ..S DIE="^SDWL(409.3,",DA=IEN,DR="23////^S X=""O""" D ^DIE
 ..S DR="13.8////^S X=""CC""" D ^DIE
 ..S DR="29////^S X=""CA""" D ^DIE
 ..S DR="19///@;20///@;21///@" D ^DIE
 ..S DR="13///@;13.1////@;13.2///@;13.3///@;13.4///@;13.5///@;13.6///@;13.8///@;13.7///@" D ^DIE ;SD/467
 Q
EN3 ;Inactive clinics
 S (CIEN,IEN,APPT,DFN,WLSTAT,SDCL,SDIEN,CC,SDREACT,SDINACT,CLINICS,SDFORM)=""
 F  S CIEN=$O(^SDWL(409.3,"SC",CIEN)) Q:CIEN<1  S CC=0 D
 .S SDINACT=$$GET1^DIQ(44,CIEN_",",2505,"I"),SDREACT=$$GET1^DIQ(44,CIEN_",",2506,"I")
 .Q:SDINACT=""&(SDREACT="")  D 
 ..S IEN="" F  S IEN=$O(^SDWL(409.3,"SC",CIEN,IEN)) Q:IEN<1  S WLSTAT=$$GET1^DIQ(409.3,IEN_",",23,"I") D
 ...Q:WLSTAT'="O"
 ...Q:SDINACT<SDREACT&((SDREACT+.01)>DT)
 ...Q:SDINACT<DT&(SDREACT>SDINACT)
 ...Q:SDINACT>(DT+.01)
 ...S CC=CC+1
 .IF CC>0 D
 ..S CLINIC=$$GET1^DIQ(44,CIEN_",",.01),CLINIC=$E(CLINIC,1,30)
 ..S SDFORM=$$FORM^SDFORM(CLINIC,40,CC,20),^TMP("SDWLQSC4",$J,CIEN)=SDFORM
 ..S REC="",REC=$O(^SDWL(409.32,"B",CIEN,REC),-1)
 ..IF REC'="" D
 ...S SDINACT=$$GET1^DIQ(44,CIEN_",",2505,"I")
 ...S DIE="^SDWL(409.32,",DA=REC,DR="3////^S X=SDINACT" D ^DIE
 ...S DR="4////^S X=.5" D ^DIE
 IF $D(^TMP("SDWLQSC4",$J)) D MESS3^SDWLMSG
 D EN4
 Q
EN4 ;PCMM Team inactivated
 S (IEN,TIEN,TEAM,TEAMN,DFN,CC,STATUS,WLOPEN,SDFORM)="" S CC="0"
 F  S TEAM=$O(^SDWL(409.3,"D",TEAM)) Q:TEAM<1  S CC=0 D
 .S IEN="" F  S IEN=$O(^SDWL(409.3,"D",TEAM,IEN)) Q:IEN<1  S WLOPEN=$$GET1^DIQ(409.3,IEN_",",23,"I") D
 ..Q:WLOPEN="C"  S TIEN="",TIEN=$O(^SCTM(404.58,"B",TEAM,TIEN),-1) IF TIEN'="" D
 ...S STATUS=$$GET1^DIQ(404.58,TIEN_",",.03,"I")
 ...Q:STATUS="1"
 ...IF STATUS="0" S CC=CC+1
 .IF CC>0 D 
 ..S TEAMN=$$GET1^DIQ(404.51,TEAM_",",.01) S TEAMN=$E(TEAMN,1,30)
 ..S SDFORM=$$FORM^SDFORM(TEAMN,40,CC,20),^TMP("SDWLQSC5",$J,TEAM)=SDFORM
 IF $D(^TMP("SDWLQSC5",$J)) D MESS4^SDWLMSG
 D EN5
 Q
EN5 ;PCMM Position inactivated
 S (IEN,PIEN,POS,POSN,STATUS,WLOPEN,SDWLPOS,SDFORM,TEAM)=""
 S SDWLPOS="" F  S IEN=$O(^SDWL(409.3,"SP",IEN)) Q:IEN<1  D
 .S POS="" F  S POS=$O(^SDWL(409.3,"SP",IEN,POS)) Q:POS<1  D
 ..S WLOPEN=$$GET1^DIQ(409.3,IEN_",",23,"I")
 ..Q:WLOPEN="C"
 ..S PIEN="",PIEN=$O(^SCTM(404.59,"B",POS,PIEN),-1) IF PIEN'="" D
 ... S POSN=$$GET1^DIQ(404.57,POS_",",.01)
 ...IF PIEN'="" S STATUS=$$GET1^DIQ(404.59,PIEN_",",.03,"I")
 ...Q:STATUS="1"
 ...IF STATUS="0" D
 ....S:'$D(SDWLPOS(POS)) SDWLPOS(POS)=0 S SDWLPOS(POS)=SDWLPOS(POS)+1,POSN=$E(POSN,1,30)
 ....S TEAM=$$GET1^DIQ(404.57,POS_",",.02),TEAM=$E(TEAM,1,25)
 ....S SDFORM=$$FORM^SDFORM(POSN,32,TEAM,27,SDWLPOS(POS),21)
 ....S ^TMP("SDWLQSC6",$J,POS)=SDFORM
 IF $D(^TMP("SDWLQSC6",$J)) D MESS5^SDWLMSG
 D EN6
 Q
EN6 ;Date of Death
 S (IEN,SDDFN,DIS,DOD,NAME)=""
 F  S SDDFN=$O(^SDWL(409.3,"B",SDDFN)) Q:SDDFN<1  D
 .S IEN="" F  S IEN=$O(^SDWL(409.3,"B",SDDFN,IEN)) Q:IEN<1  D
 ..S DIS=$$GET1^DIQ(409.3,IEN_",",21,"I") IF DIS="D" D
 ...S DOD=$$GET1^DIQ(2,SDDFN_",",.351) Q:DOD'=""  D
 ....S DIE="^SDWL(409.3,",DA=IEN,DR="23////^S X=""O""" D ^DIE
 ....S DR="19///@" D ^DIE
 ....S DR="20///@" D ^DIE
 ....S DR="21///@" D ^DIE
 ....S DR="29////^S X=""DE""" D ^DIE
 ....S NAME=$$GET1^DIQ(2,SDDFN_",",.01) S ^TMP("SDWLQSC7",$J,SDDFN)=NAME
 IF $D(^TMP("SDWLQSC7",$J)) D MESS6^SDWLMSG
 D EN7
 Q
EN7 ;PCMM Team open slots
 S (IEN,TIEN,TEAMN,CC,WLOPEN,MAX,AVAL,SDFORM,TEAM,STATUS)=""
 F  S TEAM=$O(^SDWL(409.3,"D",TEAM)) Q:TEAM<1  S CC=0 D
 .S IEN="" F  S IEN=$O(^SDWL(409.3,"D",TEAM,IEN)) Q:IEN<1  S WLOPEN=$$GET1^DIQ(409.3,IEN_",",23,"I") D
 ..Q:WLOPEN="C"  S CC=CC+1
 .IF CC>0 D
 ..S TIEN="",TIEN=$O(^SCTM(404.58,"B",TEAM,TIEN),-1) IF TIEN'="" D
 ...S STATUS=$$GET1^DIQ(404.58,TIEN_",",.03,"I")
 ...Q:STATUS="0"
 ...S MAX=$$GET1^DIQ(404.51,TEAM_",",.08)
 ...S TEAMC=$$TEAMCNT^SCAPMCU1(TEAM,DT)
 ...Q:(TEAMC+.01)>MAX  S AVAL=MAX-TEAMC,TEAMN=$$GET1^DIQ(404.51,TEAM_",",.01)
 ...S TEAMN=$E(TEAMN,1,30),SDFORM=$$FORM^SDFORM(TEAMN,35,AVAL,22,CC,12)
 ...S ^TMP("SDWLQSC8",$J,TIEN)=SDFORM
 IF $D(^TMP("SDWLQSC8",$J)) D
 .S SDFORM=$$FORM^SDFORM("TEAM",35,"SLOTS AVAILIABLE",22,"EWL ENTRIES",12)
 .S ^TMP("SDWLQSC8",$J,.06)=SDFORM
 .D MESS7^SDWLMSG
 D EN8
 Q
EN8 ;PCMM Position open slots
 S (IEN,PIEN,POS,POSN,STATUS,WLOPEN,EDATE,SDWLPOS,SDWL,SDFORM)="" K SDWLPOS
 S SDWLPOS="" F  S IEN=$O(^SDWL(409.3,"SP",IEN)) Q:IEN<1  D
 .S POS="" F  S POS=$O(^SDWL(409.3,"SP",IEN,POS)) Q:POS<1  D
 ..S PIEN="",PIEN=$O(^SCTM(404.59,"B",POS,PIEN),-1) IF PIEN'="" D
 ...S STATUS=$$GET1^DIQ(404.59,PIEN_",",.03,"I")
 ...S WLOPEN=$$GET1^DIQ(409.3,IEN_",",23,"I"),EDATE=$$GET1^DIQ(404.59,PIEN_",",.02,"I")
 ...Q:WLOPEN="C"
 ...Q:((EDATE+.01)<DT&(STATUS="0"))
 ...S:'$D(SDWLPOS(POS)) SDWLPOS(POS)=0 S SDWLPOS(POS)=SDWLPOS(POS)+1
 S (IEN,POS,POSN,MAX,AVAL,CC,TEAM)=""
 F  S POS=$O(SDWLPOS(POS)) Q:POS<1  D
 .S MAX=$$GET1^DIQ(404.57,POS_",",.08),SDWL=$$PCPOSCNT^SCAPMCU1(POS,DT)
 .Q:(SDWL+.01)>MAX
 .S TEAM=$$GET1^DIQ(404.57,POS_",",.02),TEAM=$E(TEAM,1,23)
 .S AVAL=MAX-SDWL,POSN=$$GET1^DIQ(404.57,POS_",",.01)
 .S POSN=$E(POSN,1,23),SDFORM=$$FORM^SDFORM(POSN,25,TEAM,25,AVAL,14,SDWLPOS(POS),11)
 .S ^TMP("SDWLQSC9",$J,POS)=SDFORM
 IF $D(^TMP("SDWLQSC9",$J)) D
 .S SDFORM=$$FORM^SDFORM("POSITION",25,"TEAM",25,"SLOTS AVAIL",14,"EWL ENTRIES",11)
 .S ^TMP("SDWLQSC9",$J,.06)=SDFORM
 .D MESS8^SDWLMSG
 Q
