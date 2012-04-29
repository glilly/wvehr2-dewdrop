RMPRDDC ;VACO/HNC - SERVER ROUTINE FOR DALC RECORD IN 660 ; 11/01/2006
        ;;3.0;PROSTHETICS;**60,141**;Feb 09, 1996;Build 5
        ;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ;DBIA # 10072 - for routine REMSBMSG^XMA1C
        ;DBIA # ????? - for D FIND^DIC(2,,".09"
        ;
MAIN    ;main entry point
        ;loop msg
        K RMPRMSG
        N ERR
        S RMPRCNT=0
        S RMPRMSGC=0
        F  X XMREC Q:XMRG=""  D
        .S RMPRDATA=XMRG
        .Q:RMPRDATA="ENCRYPTED STRING"
        .S (RMPRTD,RMPRMPI,RMPRSSN,RMPRNAM,RMPRTRAN,RMPRCAT,RMPRPP,RMPRICD,RMPRITM,RMPRHCPE,RMPRHCP,RMPRSTN,RMPRCMT,RMPRCOST,RMPRQTY,RMPRREF,RMPRSRL,RMPRVND,RMPRDUN,RMPRTAX,RMPRRT,DFN)=""
        .;parse data string
        .S RMPRNPMN=$P(XQSUB,"#",2)
        .S RMPRMSGC=RMPRMSGC+1
        .S RMPRCNT=RMPRCNT+1
        .S RMPRFLG=$P($G(RMPRDATA),U,21)  ;retransmission flag Y or N
        .S X=$P($P($G(RMPRDATA),U,1),".",1)  ;transaction date
        .S X=$E(X,5,6)_"/"_$E(X,7,8)_"/"_$E(X,3,4) D ^%DT S RMPRTD=Y
        .I RMPRTD=-1 S RMPRTD=""
        .S RMPRMPI=$P($G(RMPRDATA),U,2)  ;MPI
        .S RMPRSSN=$P($G(RMPRDATA),U,3)  ;SSN
        .S RMPRPNAM=$P($G(RMPRDATA),U,4)  ;Patient Name
        .S RMPRTRAN=$P($G(RMPRDATA),U,5)  ;Type New or Repair
        .I RMPRTRAN="N" S RMPRTRAN="I"  ;new trans
        .I RMPRTRAN="R" S RMPRTRAN="X"  ;repair trans
        .S RMPRCAT=$P($G(RMPRDATA),U,6)  ;category NSC or SC
        .I RMPRCAT="NSC" S RMPRCAT=4
        .I RMPRCAT="SC" S RMPRCAT=1
        .S RMPRPP=$P($G(RMPRDATA),U,7)  ;Person placing order DALC STAFF or VET
        .S RMPRICD=$P($G(RMPRDATA),U,8)  ;ICD9 blank for now
        .S RMPRITM=$P($G(RMPRDATA),U,9)  ;Item HCPCS short desc
        .S RMPRHCPE=$P($G(RMPRDATA),U,10)  ;hcpcs
        .S RMPRHCP=""
        .S RMPRHCP=$O(^RMPR(661.1,"B",RMPRHCPE,RMPRHCP))
        .I RMPRHCP="" S RMPRITM=RMPRITM_" *NOT VALID"
        .S RMPRSTN=$P($G(RMPRDATA),U,11)  ;station billing number
        .S RMPRCMT=$P($G(RMPRDATA),U,12)  ;comment
        .S RMPRCOST=$P($G(RMPRDATA),U,13)  ;total cost
        .S RMPRQTY=$P($G(RMPRDATA),U,14)  ;qty
        .S RMPRREF=$P($G(RMPRDATA),U,15)  ;ddc internal reference
        .S RMPRSRL=$P($G(RMPRDATA),U,16)  ;serial number
        .S RMPRVND=$P($G(RMPRDATA),U,17)  ;vendor as text
        .S RMPRDUN=$P($G(RMPRDATA),U,18)  ;dun
        .S RMPRTAX=$P($G(RMPRDATA),U,19)  ;tax
        .; RMPRDAT,U,21 IS RESERVED FOR A RETURN NUMBER TBD SKIPPED
        .S RMPROS=$P($G(RMPRDATA),U,22)   ;ordering station
        .S RMPRSTA=$$FIND1^DIC(4,"","X",RMPROS,"D","","ERR")
        .I $D(ERR)!(RMPRSTA'>0) D
        .. S RMPR6699=$O(^RMPR(669.9,0)),RMPRSTA=$P(^RMPR(669.9,RMPR6699,0),U,2)
        .S X=$P($G(RMPRDATA),U,20)  ;return date
        .S X=$E(X,5,6)_"/"_$E(X,7,8)_"/"_$E(X,3,4) D ^%DT S RMPRRT=Y
        .I RMPRRT=-1 S RMPRRT=""
        .;file
        .D NOW^%DTC S RMPRWHN=$P(%,".",1)
        .;check to see if new
        .I $D(^RMPR(660,"DDC",RMPRREF)) S RMPRMSG(RMPRMSGC)="Record already on file, Not Processed: "_RMPRREF Q
        .;find patient
        .D FIND^DIC(2,,".09","PS",RMPRSSN,3,"SSN","","","RMPROUT")
        .I '$G(RMPROUT("DILIST","1",0)) S RMPRMSG(RMPRMSGC)="Patient Not Found Not Processed: "_RMPRREF Q
        .I $G(RMPROUT("DISLIST",2,0)) S RMPRMSG(RMPRMSGC)="More than one Patient with Same SSN, Patient Not Processed: "_RMPRREF Q  ;more than one with same ssn
        .S DFN=$P(RMPROUT("DILIST",1,0),U,1)
        .;check 665 if not there add it
        .;array to file
        .K RMPRERR,RMPR660
        .S RMPR660(660,"+1,",.01)=RMPRWHN
        .S RMPR660(660,"+1,",.02)=DFN
        .S RMPR660(660,"+1,",1)=RMPRTD
        .S RMPR660(660,"+1,",89.2)=RMPRTD
        .S RMPR660(660,"+1,",2)=RMPRTRAN
        .S RMPR660(660,"+1,",4.2)=RMPRPP
        .S RMPR660(660,"+1,",62)=RMPRCAT
        .S RMPR660(660,"+1,",89)=RMPRITM
        .S RMPR660(660,"+1,",24)=RMPRITM
        .S RMPR660(660,"+1,",16)=RMPRCMT
        .S RMPR660(660,"+1,",14)=RMPRCOST
        .S RMPR660(660,"+1,",5)=RMPRQTY
        .S RMPR660(660,"+1,",9)=RMPRSRL
        .S RMPR660(660,"+1,",91)=RMPRVND
        .S RMPR660(660,"+1,",92)=RMPRDUN
        .S RMPR660(660,"+1,",93)=RMPRTAX
        .S RMPR660(660,"+1,",17.5)=RMPRRT
        .S RMPR660(660,"+1,",17)=1
        .S RMPR660(660,"+1,",89.3)=RMPROS
        .S RMPR660(660,"+1,",90)=RMPRSTN
        .S RMPR660(660,"+1,",4.5)=RMPRHCP
        .S RMPR660(660,"+1,",89.1)=RMPRREF
        .S RMPR660(660,"+1,",11)=16
        .S RMPR660(660,"+1,",12)="V"  ;source
        .S RMPR660(660,"+1,",15)="*"  ;historical data flag
        .D UPDATE^DIE("","RMPR660","","RMPRERR")
        .I $D(RMPRERR) D
        .  .S RMPRMSG(RMPRMSGC)=$G(RMPRERR("DIERR","1","TEXT",1))_"Error Not Processed: "_RMPRREF
        .  .;S RMPRMSG(RMPRMSGC)="Error Not Processed: "_RMPRREF
        .  .S XMY("G.RMPR SERVER")=""
        .S RMPRMSG(RMPRMSGC)="Done: "_RMPRREF
        ;Send email to ddc with number of records processed
        S XMDUZ=.5
        S XMY("G.RMPR SERVER")=""
        S XMY("S.RMPRACKDALC@DDC.VA.GOV")=""
        S XMSUB="Prosthetics - DALC Interface Summary NPNM #"_RMPRNPMN
        S RMPRMSGC=RMPRMSGC+1
        S RMPRMSG(RMPRMSGC)="Total Records Received: "_RMPRCNT
        S XMTEXT="RMPRMSG("
        D ^XMD
        ;
EXIT    ;main exit point
        K RMPRTD,RMPRMPI,RMPRSSN,RMPRNAM,RMPRTRAN,RMPRCAT,RMPRPP,RMPRICD
        K RMPRITM,RMPRHCPE,RMPRHCP,RMPRSTN,RMPRCMT,RMPRCOST,RMPRQTY,RMPRREF
        K RMPRSRL,RMPRVND,RMPRDUN,RMPRTAX,RMPRRT,DFN,RMPR(660),RMPRCNT,RMPRDATA
        K RMPRFLG,RMPROUT,RMPRNAM,RMPRWHN,RMPRMSGC,RMPRPNAM,RMPRNPMN,RMPRSTA,RMPR6699
        ;purge server message
        S XMSER="S."_XQSOP,XMZ=XQMSG D REMSBMSG^XMA1C
        Q
        ;END
