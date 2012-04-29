RMPRPCEA        ;HCIOFO/RVD - Prosthetics/PCE Interface; 05/31/01
        ;;3.0;PROSTHETICS;**62,82,78,114,120,128,131,133,145**;Feb 09, 1996;Build 6
        ;
        ; RMS  10/1/03 Patch 78 - Change Service connected, and environmental
        ;                         indicators (Agent Orange, Ionizing Radiation,
        ;                         Environmental Contaminants, Military Sexual
        ;                         Trauma, Head/Neck Cancer, and Combat Veteran
        ;                         Status) to come from new BA fields if they
        ;                         exist.
        ;
        ;This routine contains the code for sending a Prosthetic visit to PCE.
        ;
        ;DBIA #1889-A  - this API is used to add, edit and delete the
        ;                of encounter, provider, diagnosis and procedure
        ;                data to VISIT and V files in the PCE module.
        ; 04/23/2004 KAM RMPR*3*82 Make Background Message more Robust
        ;
        ;RMIE60 - ien in file #660
SENDPCE(RMIE60) ; send a Prosthetic Visit to PCE.
        ; D NEWVAR subroutine removed for functionality  01/31/05  WLC
        ;
        ;QUIT entered below to stop PCE processing for items
        Q 1
        N RMPCE,RME2,RMSENT,RMLOCK,RMERR,RMPKG,RMSRC,RMDIAG,RMQTY
        N RMSCAT,RMPROC,RMUPD,RMIEPCE,RMHLOC,RMLOC,RMPAT,RMDATE,RMINST
        N RMETYP,RMCDAT,RMPCAT,RMDANOW,DIE,DA,DIC,RMAO,RMEC,RMIR,DFN,RMSCON
        N RMMST,RMHNC,RMCBV,RMPRTPCE,STOP
        ; PATCH 78, RMS - 10/1/2003, Billing aware related variables
        N RMBASCON,RMBAAO,RMBAIR,RMBAEC,RMBAMST,RMBAHNC,RMBACBV,RMBAICD9,RMLOOP
        N RMPROV,RMCPDT,DXERR,SICD
        ;
        S RMERR=1
        S RMSRC="PROSTHETICS DATA"
        S RMPKG=$O(^DIC(9.4,"B","PROSTHETICS",0))
        I '$G(RMPKG) S RMERR=-2 G SENDPCEX
        S RMSTA=$P(^RMPR(660,RMIE60,0),U,10)
        S (RMLOC,RERRMSG,RERRMSG2)=""
        F I=0:0 S I=$O(^RMPR(669.9,"C",RMSTA,I)) Q:I'>0  D
        .I ($D(^RMPR(669.9,I,0))),($D(^RMPR(669.9,I,"PCE"))) S RMLOC=$P(^RMPR(669.9,I,"PCE"),U,3)
        ;exit if Hospital Location (clinic) not defined.
        I '$G(RMLOC) D  G SENDPCEX
        .S RMERR=-2
        .;RMPR*3*82 04/23/2004 KAM Added next 8 lines
        .N SPACES,VNAME,ENDAT
        .S VNAME=$$GET1^DIQ(2,$P(^RMPR(660,RMIE60,0),U,2),.01)
        .S ENDAT=$$GET1^DIQ(660,RMIE60,.01),SPACES=""
        .I $G(ENDAT)="" S ENDAT=" No Entry Data Found"
        .F I=1:1:42-($L(VNAME)+$L(ENDAT)) S SPACES=$G(SPACES)_" "
        .S RERRMSG="              *** NAME = "_VNAME_"   ENTRY DATE = "_ENDAT_SPACES
        .I $G(RMSTA),$D(^DIC(4,RMSTA,99)) S RMSTAW=$P(^DIC(4,RMSTA,99),U)
        .S RERRMSG=RERRMSG_"              *** Clinic is not defined....Please ask your ADPAC to enter a prosthetics      *** clinic in the Prosthetics Site Parameters file for station # = "_$G(RMSTAW)
        .S RERRMSG2="         *** Using option 'Enter/Edit Station Site Parameters'"
        .W !,"*** Clinic is not defined....."
        .W !,"*** Please ask your ADPAC to enter a prosthetics clinic in the"
        .W !,"*** Prosthetics Site Parameters file for station # = ",RMSTAW
        .W !,"*** Using option 'Enter/Edit Station Site Parameters'"
        S RMSENT=0,RMLOCK=0
        ; initialize temp file.
        K ^TMP("RMPRPCE1",$J),RMSTAW
        ;
        ; get the visit data (#660) and place in temp file.
        D GETDATA G:$G(DXERR) SENDPCEX   ;quit if inactive diagnosis RMPR*120
        ;don't create a PCE encounter if Date of Death is before the transaction
        I $D(VADM(6)),$P(VADM(6),U,1),$P(VADM(6),U,1)<(RMDATE) G SENDPCEX
        ;
        ; build the temp file for sending to PCE
        D BUILD
        ;
        ; now send
        D SENDIT
        ;
SENDPCEX        ; exit point
        ;
        ; clear the temp file
        K ^TMP("RMPRPCE1",$J)
        ;
        ; return
        Q RMERR
        ;
GETDATA ; get the visit data and place in temp file
        K RMDA,RMDA2
        S RMDA=$NA(^TMP("RMPRPCE1",$J,"RM"))
        D GETS^DIQ(660,RMIE60_",","*","I",RMDA,"")
        S RMDA2=$NA(^TMP("RMPRPCE1",$J,"RM",660,RMIE60_","))
        D NOW^%DTC
        S RMDANOW=%
        S RMDATE=@RMDA2@(.01,"I"),RMDATE=RMDATE_"."_$P(%,".",2)
        S (DFN,RMPAT)=@RMDA2@(.02,"I")
        S RMHLOC=RMLOC
        S RMINST=@RMDA2@(8.11,"I")
        S RMPCAT=@RMDA2@(62,"I")
        S RMSCON=0
        I (RMPCAT=1)!(RMPCAT=2) S RMSCON=1
        ;==============================
        S RMSCAT="A"
        S RMETYP="P"
        S RMUSER=@RMDA2@(27,"I")
        S RMDIAG=@RMDA2@(8.8,"I")
        S RMPROC=@RMDA2@(4.1,"I")
        S RMPROV=@RMDA2@(8.6,"I")
        S RMCPDT=@RMDA2@(8.4,"I")
        S RMQTY=@RMDA2@(5,"I")
        S RMCDAT=@RMDA2@(10,"I")
        S (RMPCE,RMIEPCE)=@RMDA2@(8.12,"I")
        ; PATCH 78, RMS - 10/1/2003, billing aware related variables
        K RMBAICD9,RMBAAO,RMBASCON,RMBAAIR,RMBAEC,RMBAMST,RMBAHNC,RMBACBV
        I '$D(^RMPR(660,RMIE60,"BA1")) G GTDT  ; no BA data, skip retrieval
        F RMLOOP=30:1:33 D
        . N RMBAREC S RMBAREC=RMLOOP-29
        . S RMBAICD9(RMBAREC)=@RMDA2@(RMLOOP,"I"),SICD=RMBAICD9(RMBAREC) I SICD'="" S:$P($G(^ICD9(SICD,0)),U,9) DXERR=1
        . S RMBAAO(RMBAREC)=@RMDA2@((RMLOOP+.1),"I")
        . S RMBAIR(RMBAREC)=@RMDA2@((RMLOOP+.2),"I")
        . S RMBASCON(RMBAREC)=@RMDA2@((RMLOOP+.3),"I")
        . S RMBAEC(RMBAREC)=@RMDA2@((RMLOOP+.4),"I")
        . S RMBAMST(RMBAREC)=@RMDA2@((RMLOOP+.5),"I")
        . S RMBAHNC(RMBAREC)=@RMDA2@((RMLOOP+.6),"I")
        . S RMBACBV(RMBAREC)=@RMDA2@((RMLOOP+.7),"I")
        ; Retrieve order number
GTDT    S RMPTR123=@RMDA2@(8.9,"I")
        S RMODENT=$$GET1^DIQ(123,RMPTR123_",",.03)
        ;get Date of Death.
        D DEM^VADPT
        ;get Agent Orange and Radiation.
        D SVC^VADPT S RMAO=VASV(2),RMIR=VASV(3)
        ;get environmental contaminants.
        S RMEC=$$GET1^DIQ(2,DFN,.322013,"I") I RMEC="Y" S RMEC=1
        S:RMEC'=1 RMEC=0
        ;
        S RMMST="",RMCBV="",RMHNC=""
        Q
        ;
BUILD   ; now build array for passing data to PCE
        K ^TMP("RMPRPCE1",$J,"PXAPI"),RMAPI
        S RMAPI=$NA(^TMP("RMPRPCE1",$J,"PXAPI"))
        ; ---------encounter date/time----------------
        S @RMAPI@("ENCOUNTER",1,"ENC D/T")=RMDATE
        ; --------------patient-----------------------
        S @RMAPI@("ENCOUNTER",1,"PATIENT")=RMPAT
        ; ---------------clinic-----------------------
        S @RMAPI@("ENCOUNTER",1,"HOS LOC")=RMHLOC
        ; -------------checkout date/time-------------
        S @RMAPI@("ENCOUNTER",1,"CHECKOUT D/T")=RMDATE
        ; ------------agent orange--------------------
        S @RMAPI@("ENCOUNTER",1,"AO")=RMAO
        ;--------------ionizing radiation-------------
        S @RMAPI@("ENCOUNTER",1,"IR")=RMIR
        ;-----------environmental contaminants--------
        S @RMAPI@("ENCOUNTER",1,"EC")=RMEC
        ; --------------service connected--------------
        S @RMAPI@("ENCOUNTER",1,"SC")=RMSCON
        ; ------------Military Sexual Trauma----------
        S @RMAPI@("ENCOUNTER",1,"MST")=RMMST
        ; -------------Head/Neck Cancer---------------
        S @RMAPI@("ENCOUNTER",1,"HNC")=RMHNC
        ; --------------Combat Veteran---------
        S @RMAPI@("ENCOUNTER",1,"CV")=RMCBV
        ; --------------service category--------------
        S @RMAPI@("ENCOUNTER",1,"SERVICE CATEGORY")=RMSCAT
        ; ---------------encounter type---------------
        S @RMAPI@("ENCOUNTER",1,"ENCOUNTER TYPE")=RMETYP
        ; ------------primary provider----------------
        S @RMAPI@("PROVIDER",1,"NAME")=RMUSER
        ; ----------------diagnosis------------------
        S @RMAPI@("DX/PL",1,"DIAGNOSIS")=RMDIAG
        S @RMAPI@("DX/PL",1,"PRIMARY")=1
        ; -------------- procedures -----------------
        S @RMAPI@("PROCEDURE",1,"PROCEDURE")=RMPROC
        ; ---------------- Quantity -----------------
        S @RMAPI@("PROCEDURE",1,"QTY")=RMQTY
        ; -------------- Procedures -----------------
        I ($D(RMBAICD9(1))&($P($G(RMBAICD9(1)),U)=""))!('$D(RMBAICD9(1))) D  Q
        . S @RMAPI@("PROCEDURE",1,"DIAGNOSIS")=RMDIAG
        ;
        F RMLOOP=1:1:99 Q:$G(RMBAICD9(RMLOOP))=""  D
        . S @RMAPI@("DX/PL",RMLOOP,"DIAGNOSIS")=$G(RMBAICD9(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL AO")=$G(RMBAAO(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL IR")=$G(RMBAIR(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL SC")=$G(RMBASCON(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL EC")=$G(RMBAEC(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL MST")=$G(RMBAMST(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL HNC")=$G(RMBAHNC(RMLOOP))
        . S @RMAPI@("DX/PL",RMLOOP,"PL CV")=$G(RMBACBV(RMLOOP))
        . I RMLOOP=1 D  Q
        . . S @RMAPI@("DX/PL",RMLOOP,"PRIMARY")=RMLOOP
        . . S RMDIAG=$G(RMBAICD9(RMLOOP))
        . . S @RMAPI@("PROCEDURE",1,"DIAGNOSIS")=$G(RMBAICD9(RMLOOP))
        . S @RMAPI@("PROCEDURE",1,"DIAGNOSIS "_RMLOOP)=$G(RMBAICD9(RMLOOP))  ; only one procedure per send
        ;
        ; -----------------procedures----------------
        S @RMAPI@("PROCEDURE",1,"PROCEDURE")=RMPROC
        S @RMAPI@("PROCEDURE",1,"ORD PROVIDER")=RMPROV
        S @RMAPI@("PROCEDURE",1,"EVENT D/T")=RMCPDT
        ; ------------- Order Reference -------------
        S @RMAPI@("PROCEDURE",1,"ORD REFERENCE")=RMODENT
        ; -----------------Quantity------------------
        S @RMAPI@("PROCEDURE",1,"QTY")=RMQTY
        ; -----------------diagnosis-----------------
        S @RMAPI@("PROCEDURE",1,"DIAGNOSIS")=RMDIAG
        Q
        ;
SENDIT  ; send the data to PCE. API (1891)
        K RMPROB,RMPRTPCE,RMPCE
        S (RMPRCPER,RMPROB,STOP)=0
        D PRV^RMPRPCED
        ; call the PCE package API.
        I RMERR'<1 S RMERR=$$DATA2PCE^PXAPI($NA(^TMP("RMPRPCE1",$J,"PXAPI")),RMPKG,RMSRC,.RMPCE,RMUSER,0,,"",.RMPROB)
        ;To check for returned error messages, list the RMPROB array.
        I RMERR<1 W !,"File #660 IEN="_RMIE60_" - Error in PCE interface !!!"
        ;delete PCE entry if Provider and CPT CODE error, but send an error
        ;message to RMPR PCE mailgroup.
        I $D(RMPROB($J)) D CHECK^RMPRPCED
        I $G(RMPCE),$G(RMPRCPER) S RMPRTPCE=RJ_"^"_RMHLOC,RMCHK=$$DELVFILE^PXAPI("ALL",.RMPCE,RMPKG,RMSRC,0,0,"") Q
        ;
        Q:'$G(RMPCE)
        ;update PCE pointer and date last sent in #660.
        K RMUPD
        S RMUPD(660,RMIE60_",",8.12)=RMPCE
        S RMUPD(660,RMIE60_",",8.13)=RMDANOW
        D FILE^DIE("","RMUPD","")
        Q
        ;
