ECUTL1 ;ALB/ESD - Event Capture Classification Utilities ;19 May 98
 ;;2.0; EVENT CAPTURE ;**10,13,17,42,54**;8 May 96
 ;
ASKCLASS(DFN,ECANS,ERR,ECTOPCE,ECPATST,ECHDA) ;  Ask classification questions (Agent Orange, Ionizing Radiation, Environmental Contaminants, Service Conn)
 ;
 ;   Input:
 ;      DFN     - IEN of Patient file (#2)
 ;      ECTOPCE - Variable which indicates if DSS Unit is sending to PCE
 ;      ECPATST - Inpatient/outpatient status
 ;      ECHDA   - IEN in file #721 if editing existing record [optional]
 ;
 ;  Output:
 ;      ECANS - array subscripted by classification abbreviation
 ;              (i.e. ECANS("AO")) and passed by reference containing:
 ;                 field # of class from EC Patient file (#721)^answer
 ;      ERR   - Error indicator if user uparrows or times out (set to 1)
 ;
 ;      Function value - 1 if successful, 0 otherwise
 ;
 N ANS,DIR,ECCL,ECCLFLD,SUCCESS,ECVST,ECVSTDT,ECPXB,PXBDATA,ECNT,ECOLD,ECPIECE,ECXX
 S (ECANS,ECCL)=""
 S ERR=0
 S SUCCESS=1
 S DFN=+$G(DFN)
 S ECTOPCE=$G(ECTOPCE)
 I ECTOPCE["~" S ECTOPCE=$P(ECTOPCE,"~",2)
 S ECPATST=$G(ECPATST)
 ;- Drop out if invalid condition found OR if DSS Unit not sending to
 ;  PCE or patient is an inpatient
 I ('DFN)!(ECTOPCE="")!(ECPATST="")!(ECTOPCE="N")!(ECPATST="I") S SUCCESS=0 Q SUCCESS
 D NOW^%DTC S ECVSTDT=$S(+$G(ECDT):ECDT,1:%),ECVST="" ;modified to use event date;JAM/11/24/03
 ;- If editing an existing record, get visit data & display classification
 I $G(ECHDA) D
 .S ECVSTDT=$P($G(^ECH(ECHDA,0)),U,3)
 .S ECVST=$P($G(^ECH(ECHDA,0)),U,21)
 .F ECCL="AO","IR","EC","SC","MST","HNC","CV" D
 ..S ECCLFLD=$S(ECCL="AO":"Agent Orange",ECCL="IR":"Ionizing Radiation",ECCL="EC":"Environmental Contaminants",ECCL="SC":"Service Connected",ECCL="HNC":"Head/Neck Cancer",ECCL="CV":"Combat Veteran",1:"Military Sexual Trauma")
 ..S ECPIECE=$S(ECCL="AO":3,ECCL="IR":4,ECCL="EC":5,ECCL="SC":6,ECCL="MST":9,ECCL="HNC":10,1:11)
 ..S ECXX=$P($G(^ECH(ECHDA,"P")),U,ECPIECE),ECXX=$S(ECXX="Y":"YES",ECXX="N":"NO",1:"")
 ..I ECXX]"" S ECOLD(ECCL)=ECCLFLD_": "_ECXX
 .I $D(ECOLD) D
 ..W !,"*** Current encounter classification ***",!
 ..F ECCL="SC","CV","AO","IR","EC","MST","HNC" D
 ...I $D(ECOLD(ECCL)) W !?4,ECOLD(ECCL)
 ;- Ask user classification question
 D CLASS^PXBAPI21("",DFN,ECVSTDT,1,ECVST) W !
 ;- Check error; exit if error condition
 I $D(PXBDATA("ERR")) D  I ERR S SUCCESS=0 Q SUCCESS
 .F ECPXB=1:1:4 I $D(PXBDATA("ERR",ECPXB)) D
 ..I (PXBDATA("ERR",ECPXB)=1)!(PXBDATA("ERR",ECPXB)=4) S ERR=1
 ;- Otherwise, continue to setup ecans array, i.e., new classification data
 F ECCL="AO","IR","SC","EC","MST","HNC","CV" D
 .S ECCLFLD=$S(ECCL="AO":21,ECCL="IR":22,ECCL="EC":23,ECCL="SC":24,ECCL="MST":35,ECCL="HNC":39,1:40)
 .S ECPXB=$S(ECCL="AO":1,ECCL="IR":2,ECCL="EC":4,ECCL="SC":3,ECCL="MST":5,ECCL="CV":7,1:6)
 .S ANS=$P($G(PXBDATA(ECPXB)),U,2),ANS=$S(ANS=1:"Y",ANS=0:"N",1:"")
 .S ECANS(ECCL)=ECCLFLD_"^"_ANS
 ;- Delete old data if it exists
 I $G(ECHDA) D DELCLASS(ECHDA)
 Q SUCCESS
 ;
 ;
EDCLASS(ECIEN,ECANS) ;  Edit classifications fields in EC Patient
 ;                  file (#721)
 ;
 ;   Input:
 ;      ECIEN - EC Patient record (#721) IEN
 ;      ECANS - Array of answers to classification questions asked
 ;
 ;  Output:
 ;      Classification fields 21,22,23,24,35,39,40 edited in file #721
 ;
 N DA,DIE,DR,ECCL
 S (DR,ECCL)=""
 ;
 ;- Drops out if invalid condition found
 D
 . I '$G(ECIEN)!('$D(ECANS)) Q
 . ;
 . ;- Lock main node
 . I '$$LOCK(ECIEN) Q
 . S DA=ECIEN
 . S DIE="^ECH("
 . ;
 . ;- Edit classification fields (AO, IR, EC, SC, MST, HNC, CV)
 . F  S ECCL=$O(ECANS(ECCL)) Q:ECCL=""  S DR=DR_+$P($G(ECANS(ECCL)),"^")_"////"_$P($G(ECANS(ECCL)),"^",2)_";"
 . ;
 . ;- Remove last ";" from DR string before editing
 . S DR=$E(DR,1,($L(DR)-1))
 . D ^DIE
 ;
 ;- Unlock main node
 D UNLOCK(ECIEN)
 ;
 Q
 ;
 ;
SETCLASS(ECANS) ;  Set answers to classification questions in EC variables
 ;          (used in EC data entry options when filing EC Patient record)
 ;
 ;   Input:
 ;      ECANS - array of answers to class questions asked containing:
 ;                 field number of class ques from file #721^answer
 ;
 ;  Output:
 ;      EC classification var - ECAO,ECIR,ECZEC,ECSC,ECMST,ECHNC,ECCV
 ;
 N ECCL,ECCLFLD
 S (ECCL,ECAO,ECIR,ECZEC,ECSC,ECMST,ECHNC,ECCV)=""
 ;
 ;- Drops out if invalid condition found
 D
 . ;
 . ;- If array containing class flds^answers is not created, exit
 . I '$D(ECANS) Q
 . F  S ECCL=$O(ECANS(ECCL)) Q:ECCL=""  D
 .. ;
 .. ;- Get field number of classification
 .. S ECCLFLD=+$P($G(ECANS(ECCL)),"^")
 .. ;
 .. ;- Agent Orange variable
 .. S:ECCLFLD=21 ECAO=$P(ECANS(ECCL),"^",2)
 .. ;
 .. ;- Ionizing Radiation variable
 .. S:ECCLFLD=22 ECIR=$P(ECANS(ECCL),"^",2)
 .. ;
 .. ;- Environmental Contaminants variable
 .. S:ECCLFLD=23 ECZEC=$P(ECANS(ECCL),"^",2)
 .. ;
 .. ;- Service Connected variable
 .. S:ECCLFLD=24 ECSC=$P(ECANS(ECCL),"^",2)
 .. ;
 .. ;- Military Sexual Trauma variable
 .. S:ECCLFLD=35 ECMST=$P(ECANS(ECCL),"^",2)
 .. ;
 .. ;- Head/Neck Cancer
 .. S:ECCLFLD=39 ECHNC=$P(ECANS(ECCL),"^",2)
 .. ;
 .. ;- Combat Veteran
 .. S:ECCLFLD=40 ECCV=$P(ECANS(ECCL),"^",2)
 Q
 ;
 ;
DELCLASS(ECIEN) ;  Delete classification fields in EC Patient file (#721)
 ;
 ;   Input:
 ;      ECIEN - EC Patient record (#721) IEN
 ;
 ;  Output:
 ;      Classification fields 21,22,23,24,35,39,40 deleted in file #721
 ;
 N DA,DIE,DR,ECCL
 S DR=""
 ;
 ;- Drops out if invalid condition found
 D
 . I '$G(ECIEN) Q
 . ;
 . ;- Lock main node
 . I '$$LOCK(ECIEN) Q
 . S DA=ECIEN
 . S DIE="^ECH("
 . ;
 . ;- Delete classification fields (AO, IR, EC, SC, MST, HNC, CV)
 . F ECCL=21:1:24,35,39,40 S DR=DR_ECCL_"////@;"
 . ;
 . ;- Remove last ";" from DR string before editing
 . S DR=$E(DR,1,($L(DR)-1))
 . D ^DIE
 ;
 ;- Unlock main node
 D UNLOCK(ECIEN)
 ;
 Q
 ;
 ;
LOCK(ECIEN) ;  Lock EC Patient record
 ;
 ;   Input:
 ;      ECIEN - EC Patient record IEN
 ;
 ;  Output:
 ;      Function Value - 1 if record can be locked, 0 otherwise
 ;
 I $G(ECIEN) L +^ECH(ECIEN):5
 Q $T
 ;
 ;
UNLOCK(ECIEN) ;  Unlock EC Patient record
 ;
 ;   Input:
 ;      ECIEN - EC Patient record IEN
 ;
 ;  Output:
 ;      EC Patient record unlocked
 ;
 I $G(ECIEN) L -^ECH(ECIEN)
 Q
