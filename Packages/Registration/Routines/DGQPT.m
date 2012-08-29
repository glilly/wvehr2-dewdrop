DGQPT   ; SLC/MKB - Patient Selection ;8/8/97  13:07
        ;;5.3;Registration;**447,796**;Aug 13, 1993;Build 6
        ;
        ; SLC/PKS - 3/2000: Modified to deal with "Combinations."
        ;
EN      ; -- main entry point for DG PATIENT SELECTION
        I $G(DGVP),'($D(DGPNM)&$D(DGSSN)) K DGVP ; reset
        D EN^VALM("DG PATIENT SELECTION")
        Q
        ;
HDR     ; -- header code
        N X I '$G(DGVP) S X="** No patient selected **"
        E  S X=$G(DGPNM)_"   "_$G(DGSSN)
        S VALMHDR(1)="Current patient: "_X
        Q
        ;
INIT    ; -- init variables and list array
        ; Modifications for multiple "Combination" lists by PKS.
        ;
        ; PARAM herein might end up as: DGLP DEFAULT CLINIC WEDNESDAY
        ;    (Param Name and current DOW)
        ; DGY might end up passed as:  5^5^C;1;T-360;T+60;A
        ;    (#lines^#pts^source;serviceSection;startDate;stopDate;sort)
        ;
        N DGY,DGX,PARAM,DGYZB,DGYZE
        ;
        ;added by CLA 12/12/96 - gets SERVICE/SECTION of user:
        N DGSRV S DGSRV=$G(^VA(200,DUZ,5)) I +DGSRV>0 S DGSRV=$P(DGSRV,U)
        ;
        S DGY=$$GET^XPAR("USR^SRV.`"_$G(DGSRV),"DGLP DEFAULT LIST SOURCE",1,"I") ; Gets default list source for this user.
        I $L(DGY) D  S DGY=DGY_";"_DGX
        . ; PKS: Set "PARAM" var to parameter name in param def file:
        . S PARAM="DGLP DEFAULT "_$S(DGY="T":"TEAM",DGY="S":"SPECIALTY",DGY="P":"PROVIDER",DGY="W":"WARD",DGY="C":"CLINIC",DGY="M":"COMBINATION",1:"")
        . S:DGY="C" PARAM=PARAM_" "_$$UP^XLFSTR($$DOW^XLFDT(DT)) ; For clinics, add current DOW.
        . S DGX=$$GET^XPAR("USR^SRV.`"_$G(DGSRV),PARAM,1,"I") ; Source param.
        . ; Next lines modified by PKS for "Combinations" and dates:
        . I (DGY="C")!(DGY="M") D
        . . S DGYZB=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT CLINIC START DATE",1,"I")) ; Gets clinic start date.
        . . I DGYZB="T+0" S DGYZB=$$FMTE^XLFDT(DT,DGYZB)
        . . S DGX=DGX_";"_DGYZB
        . . S DGYZE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT CLINIC STOP DATE",1,"I")) ; Add ";" & stop date.
        . . I DGYZE="T+0" S DGYZE=$$FMTE^XLFDT(DT,DGYZE)
        . . S DGX=DGX_";"_DGYZE
        S $P(DGY,";",5)=$$GET^XPAR("USR^SRV.`"_$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT LIST ORDER",1,"I") ; Add default sort order.
        ;
        ; Call tag that builds the actual Patient Selection List:
        D BUILD(DGY)
        Q
        ;
DEFAULT()       ; -- Returns default action
        I '$P($G(^TMP("DG",$J,"PATIENTS",0)),U,2) Q "Change View"
        I XQORM("B")="Quit" Q "Close"
        Q "Next Screen"
        ;
MSG()   ; -- Lmgr msg bar
        Q "Enter the number of the patient chart to be opened"
        ;
HELP    ; -- help code
        N X D FULL^VALM1 S VALMBCK="R"
        W !!,"Enter the display number of the patient whose chart you wish to open"
        W !,"or enter a patient name, SSN, or initial/last 4 combination.  To"
        W !,"change the list of patients displayed on this screen, enter CV.  To"
        W !,"have the new list automatically displayed when selecting a new patient,"
        W !,"enter SV.  Enter FD to search by patient name or identifier."
        W !!,"Press <return> to continue ..." R X:DTIME
        Q
        ;
EXIT    ; -- exit code
        K ^TMP("DG",$J,"PATIENTS"),XQORM("ALT")
        Q
        ;
BUILD(LIST)     ; -- build list in ^TMP("DG",$J,"PATIENTS")
        N DGI,DGX,DGY,LCNT,NUM,DFN,NAME,TYPE,PTR,BEG,END,SORT,DOB,RBED,%DT,X,Y,TITLE,PTID,SENS
        S TYPE=$E(LIST),PTR=+$P(LIST,";",2),SORT=$P(LIST,";",5)
        ; Next 5 lines added by PKS:
        I ((SORT="S")&(TYPE'="M")) S SORT="A"    ; Reset invalid sorts.
        I TYPE="M" D                             ; Deal with combinations.
        .I ((SORT="P")!(SORT="A")!(SORT="S")) Q  ; P,A,S are acceptable.
        .S SORT="A"                              ; Default.
        S $P(LIST,";",5)=SORT                    ; Reset in case of change.
        S BEG=$P(LIST,";",3) I $L(BEG) S X=BEG,%DT="X" D ^%DT S BEG=Y
        S END=$P(LIST,";",4) I $L(END) S X=END,%DT="X" D ^%DT S END=Y
        I TYPE="T" D TEAMPTS^DGQPTQ1(.DGY,PTR) S TITLE="Team "_$P($G(^OR(100.21,+PTR,0)),U)
        I TYPE="P" D PROVPTS^DGQPTQ2(.DGY,PTR) S TITLE="Provider "_$P($G(^VA(200,+PTR,0)),U)
        I TYPE="S" D SPECPTS^DGQPTQ2(.DGY,PTR) S TITLE="Specialty "_$P($G(^DIC(45.7,+PTR,0)),U)
        I TYPE="W" D WARDPTS^DGQPTQ2(.DGY,PTR) S TITLE="Ward "_$P($G(^DIC(42,+PTR,0)),U)
        I TYPE="C" D CLINPTS^DGQPTQ2(.DGY,PTR,BEG,END) S TITLE="Clinic "_$P($G(^SC(+PTR,0)),U)
        ; Next line added by PKS for "Combinations:"
        I TYPE="M" N MSG D COMBPTS^DGQPTQ6(1,PTR,BEG,END) S TITLE="Combination List" ; Sets MSG,LCNT,NUM, and writes ^TMP("DG",$J,"PATIENTS").
        ; Next section added by PKS for "Combinations:"
        I TYPE="M" D  G BQ    ; Check MSG var, then go to BQ tag.
        .I MSG'="" D          ; Did call to COMBPTS assign an error message?
        ..S LCNT=1,NUM=0      ; Set defaults.
        ..S ^TMP("DG",$J,"PATIENTS",1,0)="     "_MSG ; Write error msg.
        D CLEAN^VALM10 S (LCNT,NUM)=0 ; All but "M" types reset, go on to B1.
        ;
B1      S DGI=0 F  S DGI=$O(DGY(DGI)) Q:DGI'>0  I DGY(DGI) D  ; sort
        . S DFN=+DGY(DGI)
        . ;sort logic added by CLA 7/23/97:
        . S DGX=""
        . I SORT="P",(TYPE="C") S DGX=$P($G(DGY(DGI)),U,4) D
        .. S $P(DGX,".",2)=$E($P(DGX,".",2)_"000",1,4)
        ..S DGX=DGX_U_$P(DGY(DGI),U,2)
        . I SORT="R",(TYPE'="C") S DGX=$P($G(^DPT(+DGY(DGI),.101)),U)_U_$P(DGY(DGI),U,2)
        . I SORT="T" S DGX="" ; Need to add terminal digit sorting.
        . ; If no sort specified, default to alphabetic (plus app't if clinic type):
        . I DGX="" S DGX=$P(DGY(DGI),U,2)_U_$P($G(DGY(DGI)),U,4)
        . S ^TMP("DG",$J,"PATIENTS","B",DGX_DFN)=DGY(DGI) ; DFN ^ Name
        I '$D(^TMP("DG",$J,"PATIENTS")) D  G BQ
        . N MSG
        . S MSG="No patients found"
        . S LCNT=1,NUM=0
        . I $D(DGY(1)) S MSG=$P(DGY(1),"^",2) ; error message from search
        . S ^TMP("DG",$J,"PATIENTS",1,0)="     "_MSG
B2      S DGX="" F  S DGX=$O(^TMP("DG",$J,"PATIENTS","B",DGX)) Q:DGX=""  S DGY=^(DGX) D
        . S DFN=+DGY,NAME=$P(DGY,U,2)
        . S DOB=$$FMTE^XLFDT($P($G(^DPT(DFN,0)),U,3))
        . S:(TYPE'="C") RBED=$P($G(^DPT(DFN,.101)),U)
        . I (TYPE="C") S RBED=$S(SORT="P":$$FMTE^XLFDT($P(DGX,U)),1:$$FMTE^XLFDT($P(^TMP("DG",$J,"PATIENTS","B",DGX),U,4)))
        . ;Q:RBED=""  removed by CLA 7/23/97 to prevent blank lines
        . S LCNT=LCNT+1,NUM=NUM+1
        . S ^TMP("DG",$J,"PATIENTS","IDX",NUM)=DGY ; DFN ^ NAME
        . ; Next lines modified/added by PKS on 1/24/2001:
        . ; Check for "sensitive" patients:
        . S PTID=""
        . S PTID=$$ID(DFN)
        . S SENS=$$SSN^DPTLK1(DFN)
        . I SENS["*" S PTID=""
        . S DOB=$$DOB^DPTLK1(DFN)
        . S ^TMP("DG",$J,"PATIENTS",LCNT,0)=$$LJ^XLFSTR(NUM,5)_$$LJ^XLFSTR(NAME,31)_$$LJ^XLFSTR(PTID,10)_$$LJ^XLFSTR(DOB,15)_$G(RBED)
        . D CNTRL^VALM10(LCNT,1,5,IOINHI,IOINORM)
BQ      S ^TMP("DG",$J,"PATIENTS",0)=LCNT_U_NUM_U_$G(LIST) ; #lines^#pts^context
        S ^TMP("DG",$J,"PATIENTS","#")=$O(^ORD(101,"B","ORQPT SELECT PATIENT",0))_"^1:"_NUM
        S RBED=$S(TYPE="C":"Appointment Date",TYPE="M":"Source   Other",1:"Room-Bed")
        D CHGCAP^VALM("ROOM-BED",RBED) K VALMHDR
        S VALMCNT=LCNT,VALMBG=1,VALMBCK="R" S:$L($G(TITLE)) VALM("TITLE")=TITLE
        Q
        ;
ID(DFN) ; -- Returns short ID for patient ID
        N ID S ID=$P($G(^DPT(DFN,.36)),U,4) ; short ID
        I '$L(ID) S ID=$E($P($G(^DPT(DFN,0)),U,9),6,9) ; last 4 of SSN
        Q "("_$E(NAME)_ID_")"
        ;
APPT(DFN,CLINIC,FROM,TO)        ; -- Return [next?] clinic appointment
        N VASD,VAERR K ^UTILITY("VASD",$J)
        S VASD("F")=FROM,VASD("T")=TO,VASD("C",CLINIC)=""
        D SDA^VADPT S NEXT=+$O(^UTILITY("VASD",$J,0)),NEXT=$P($G(^(NEXT,"I")),U)
        K ^UTILITY("VASD",$J)
        Q NEXT
        ;
ALT     ; -- XQORM("ALT") code to search File 2 for patient X
        N DIC,DFN,Y,DGX S DGX=X D FULL^VALM1
        S DIC=2,DIC(0)="EQM",X=$S($D(XQORMRCL):" ",1:DGX)
        D ^DIC I Y'>0 S VALMBCK="R" Q  ;S XQORMERR=1 Q
        S DGX=+$G(^DPT(+Y,.35)) I DGX,'$$OK(DGX) S VALMBCK="R" Q
        S DFN=+Y G:DFN'=+$G(DGVP) SLCT1 ; set patient variables
        Q
        ;
FIND    ; -- find patient in ^DPT
        N X,Y,DIC,DGX,DFN
        S DIC=2,DIC(0)="AEQM" D FULL^VALM1
        D ^DIC I Y'>0 S VALMBCK="R" Q
        S DGX=+$G(^DPT(+Y,.35)) I DGX,'$$OK(DGX) S VALMBCK="R" Q
        S DFN=+Y G:DFN'=+$G(DGVP) SLCT1 ; set patient variables
        Q
        ;
SELECT  ; -- select patient from list
        N NMBR,X,Y,Z,DIC,DFN,DGX S NMBR=+$P(XQORNOD(0),"=",2)
        S Y=$G(^TMP("DG",$J,"PATIENTS","IDX",NMBR)),DFN=+Y
        I 'DFN W $C(7),!!,NMBR_" is not a valid selection.",! S VALMBCK="" H 1 Q
        ;W "   "_$P(Y,U,2) S ^DISV(DUZ,"^DPT(")=DFN
        D FULL^VALM1 S DIC=2,DIC(0)="EQM",X="`"_DFN D ^DIC I Y<0 S VALMBCK="R" Q
        S DGX=+$G(^DPT(+Y,.35)) I DGX,'$$OK(DGX) S VALMBCK="R" Q
SLCT1   ; -- may enter here with DFN from FIND
        N VADM,VAEL,VAIN,VA,VAERR,LOC,ORCNV
        D OERR^VADPT,ELIG^VADPT
        S LOC=+$G(^DIC(42,+VAIN(4),44))_";SC(" I 'LOC,'$D(XQAID) D
        . I $G(NMBR) N X S X=$$CONTEXT^DGQPT1 I $E(X)="C" S LOC=$P(X,";",2)_";SC(" Q:LOC  ; use clinic if selected from list, else ask
        . S LOC=""
        S DGL=LOC,DGL(0)=$P($G(^SC(+DGL,0)),U),DGL(1)=VAIN(5)
        S DGVP=DFN_";DPT(",DGPNM=VADM(1),DGSSN=$P(VADM(2),U,2)
        S DGDOB=$P(VADM(3),U,2),DGAGE=VADM(4),DGSEX=$P(VADM(5),U)
        S DGTS=+VAIN(3),DGWARD=VAIN(4),DGATTEND=+VAIN(11),DGSC=$G(VAEL(3))
        I $P($G(^DGSL(38.1,+DGVP,0)),"^",2),($G(^DPT(+DGVP,.1))]""!$D(^XUSEC("DG SENSITIVITY",DUZ))) D
        . ; if senstive patient and (patient inpatient or user holds key)
        . ; prevents sensitive patient warning from scrolling off screen
        . N X
        . W !!,"Press <return> to continue ..."
        . R X:DTIME
SLCT2   ; -- convert patient's orders, if not already done
        ;ORDERS NO LONGER BEING CONVERTED 
        ;S DGCNV=$$OTF^OR3CONV(+DGVP) Q:'DGCNV  I DGCNV>0 W !,"DONE" H 1 Q
        ;I DGCNV<0 W $C(7),!!,$P(DGCNV,U,2) H 2 S VALMBCK="R" Q
        Q
        ;
OK(DATE)        ; -- Patient is deceased; ok to continue?
        N X,Y,DIR S DIR(0)="YA",DIR("B")="NO"
        S DIR("A")="Do you wish to continue? "
        W $C(7),!!,"This patient died "_$$FMTE^XLFDT(DATE)_"!"
        D ^DIR
        Q +Y
