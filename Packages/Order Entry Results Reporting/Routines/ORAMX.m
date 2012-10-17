ORAMX   ;POR/RSF - ADDITIONAL ANTICOAGULATION CALLS ;12/08/09  16:26
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**307**;Dec 17, 1997;Build 60
        ;;Per VHA Directive 2004-038, this routine should not be modified
        Q
        ;
COMPRPT  ; Complications Report [ORAM COMPLICATIONS REPORT]
        N DIRUT,ORAMSDT,ORAMEDT,ORAMSD,ORAMED,ORAMM,ORAMDL,ORAMT,ORAFMT,ORAMDFN,ORAMCNT,ORAMARR,ORAMINCM,ORAMSORT
        S (ORAMED,ORAMSD)="",ORAMINCM=1
        W !!,"Anticoagulation Complications Report",!
        F  D  Q:+ORAMED>+ORAMSD!+$G(DIRUT)
        . S ORAMSD=+$$READ("DA^::E","    Please Enter START Date: ","T-90","Enter a start date for the report")
        . Q:'ORAMSD
        . S ORAMED=+$$READ("DA^::E","      Please Enter END Date: ","T","Enter an INCLUSIVE end date for the report")
        . Q:'ORAMED
        . I $L(ORAMED,".")=1 S ORAMED=ORAMED_".2359"
        . I ORAMSD>ORAMED W !,"END DATE must be more recent than the START DATE" S (ORAMSD,ORAMED)=""
        Q:$S(ORAMSD'>0:1,ORAMED'>0:1,1:0)
        S ORAMSDT=$$FMTE^XLFDT(ORAMSD,2),ORAMEDT=$$FMTE^XLFDT(ORAMED,2)
        W ! S ORAFMT=$$READ("SA^r:Report;e:Export to Spreadsheet","      Please Specify Format: ","Report")
        Q:+$G(DIRUT)
        S:"Ee"[$P(ORAFMT,U) ORAMDL=1 S:"Rr"[$P(ORAFMT,U) ORAMDL=0
        W ! S ORAMSORT=$$READ("SA^c:Clinic;d:Division","              Sort/Tally By: ","Clinic")
        Q:+$G(DIRUT)
        S ORAMSORT=$P(ORAMSORT,U)
        W ! S ORAMINCM=+$$READ("YA","Include Minor Complications? ","YES")
        Q:+$G(DIRUT)
        S (ORAMCNT,ORAMDFN)=0
        F  S ORAMDFN=$O(^ORAM(103,ORAMDFN)) Q:'$G(ORAMDFN)  D
        . N ORAMFS S ORAMFS=" "
        . F  S ORAMFS=$O(^ORAM(103,ORAMDFN,3,ORAMFS),-1) Q:'+$G(ORAMFS)  D
        .. N ORAMCP
        .. I $P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U)<ORAMSD Q
        .. I $P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U)>ORAMED Q
        .. S ORAMCP=$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,2)
        .. I +$G(ORAMCP) D
        ... N ORAMLOC,ORAMM,ORAMCLNO,ORAMCLNM,ORAMDIVN,ORAMDIV
        ... I (+ORAMINCM'>0),(ORAMCP>2) Q
        ... S ORAMCLNO=+$P($G(^ORAM(103,ORAMDFN,6)),U,2)
        ... I ORAMCLNO>0 D
        .... S ORAMDIVN=+$P($G(^SC(ORAMCLNO,0)),U,15)
        .... S ORAMCLNM=$$EXTERNAL^DILFD(103,101,"",ORAMCLNO) S:$G(ORAMCLNM)="" ORAMCLNM="CLINIC UNKNOWN"
        .... S ORAMDIV=$$EXTERNAL^DILFD(44,3.5,"",ORAMDIVN) S:$G(ORAMDIV)="" ORAMDIV="DIVISION UNKNOWN"
        ... E  S ORAMCLNM="CLINIC UNKNOWN",ORAMDIV="DIVISION UNKNOWN"
        ... S ORAMLOC=$S(ORAMSORT="c":ORAMCLNM,1:ORAMDIV)
        ... S ORAMARR(ORAMLOC,0)=$G(ORAMARR(ORAMLOC,0))+1
        ... S ORAMM=$E($P(^DPT($G(ORAMDFN),0),U),1,10)_" ("_$E($P(^(0),U,9),6,9)_")"
        ... I ORAMCP=1!(+ORAMINCM&(ORAMCP=3)) D
        .... S ORAMARR(ORAMLOC,"B",0)=$G(ORAMARR(ORAMLOC,"B",0))+1
        .... S ORAMARR(ORAMLOC,"B",ORAMDFN,$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U)_ORAMFS,1)=ORAMM_": INR Draw date - "_$$FMTE^XLFDT($P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U),"2P")
        .... N ORAMJ S ORAMJ=0
        .... F  S ORAMJ=$O(^ORAM(103,ORAMDFN,3,ORAMFS,2,ORAMJ)) Q:+ORAMJ'>0  D
        ..... N ORAMCMPL,ORAMFS0
        ..... S ORAMFS0=$G(^ORAM(103,ORAMDFN,3,ORAMFS,0))
        ..... S ORAMCMPL=$G(^ORAM(103,ORAMDFN,3,ORAMFS,2,ORAMJ,0))
        ..... S:$L(ORAMCMPL,":")>1 ORAMCMPL=$S($P(ORAMCMPL,":")="MB":"Major Bleed: ",$P(ORAMCMPL,":")="C":"  ",1:ORAMCMPL)_$P(ORAMCMPL,":",2)
        ..... S ORAMARR(ORAMLOC,"B",ORAMDFN,$P(ORAMFS0,U)_ORAMFS,1_"."_ORAMJ)=$S(ORAMJ=1:"Complication date: ",1:"")_ORAMCMPL
        ..... S ORAMARR(ORAMLOC,"BX",ORAMDFN,$P(ORAMFS0,U)_ORAMFS,99)=$TR(ORAMLOC,";",",")_";"_$S(ORAMCP=3:"Minor Bleed",1:"Hemorrhagic")_";"_ORAMM_";"_$$FMTE^XLFDT($P(ORAMFS0,U),"2P")_";"
        ..... S ORAMARR(ORAMLOC,"BX",ORAMDFN,$P(ORAMFS0,U)_ORAMFS,99)=ORAMARR(ORAMLOC,"BX",ORAMDFN,$P(ORAMFS0,U)_ORAMFS,99)_$G(^ORAM(103,ORAMDFN,3,ORAMFS,2,1,0))
        ... I ORAMCP=2 D
        .... S ORAMARR(ORAMLOC,"C",0)=$G(ORAMARR(ORAMLOC,"C",0))+1
        .... S ORAMARR(ORAMLOC,"C",ORAMDFN,$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U)_ORAMFS,1)=ORAMM_": INR Draw date - "_$$FMTE^XLFDT($P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U),"2P")
        .... N ORAMJ S ORAMJ=0
        .... F  S ORAMJ=$O(^ORAM(103,ORAMDFN,3,ORAMFS,2,ORAMJ)) Q:'+$G(ORAMJ)  D
        ..... N ORAMCMPL,ORAMFS0
        ..... S ORAMFS0=$G(^ORAM(103,ORAMDFN,3,ORAMFS,0))
        ..... S ORAMCMPL=^ORAM(103,ORAMDFN,3,ORAMFS,2,ORAMJ,0)
        ..... S:$L(ORAMCMPL,":")>1 ORAMCMPL=$S($P(ORAMCMPL,":")="MB":"Major Bleed: ",$P(ORAMCMPL,":")="C":"  ",1:ORAMCMPL)_$P(ORAMCMPL,":",2)
        ..... S ORAMARR(ORAMLOC,"C",ORAMDFN,$P(ORAMFS0,U)_ORAMFS,1_"."_ORAMJ)=$S(ORAMJ=1:"Complication date: ",1:"")_ORAMCMPL
        ..... S ORAMARR(ORAMLOC,"CX",ORAMDFN,$P(ORAMFS0,U)_ORAMFS,99)=$TR(ORAMLOC,";",",")_";Thrombotic;"_ORAMM_";"_$$FMTE^XLFDT($P(ORAMFS0,U),"2P")_";"_$G(^ORAM(103,ORAMDFN,3,ORAMFS,2,1,0))
        I ORAMDL=0 D COMP0(.ORAMARR,ORAMSDT,ORAMEDT,ORAMINCM)
        I ORAMDL=1 D COMP1(.ORAMARR,ORAMSDT,ORAMEDT,ORAMINCM,ORAMSORT)
        Q
COMP0(ORAMARR,ORAMSDT,ORAMEDT,ORAMINCM) ; Print Report Format
        N OCLINIC
        W @IOF,"COMPLICATIONS REPORT - ANTICOAGULATION: ",ORAMSDT," - ",ORAMEDT,!,$S('ORAMINCM:"  (** EXCLUDING MINOR COMPLICATIONS **)"_$C(13)_$C(10),1:"")
        I '$D(ORAMARR) W !,?5,"No Complications Noted."  Q
        S OCLINIC=""
        F  S OCLINIC=$O(ORAMARR(OCLINIC)) Q:OCLINIC']""  D
        . W !!,?5,OCLINIC,": Total Complications - ",ORAMARR(OCLINIC,0)
        . I $G(ORAMARR(OCLINIC,"B",0))>0 D  ;BLEEDS FOR THIS CLINIC
        .. N ODFN
        .. W !!,?7," Bleeds (",ORAMARR(OCLINIC,"B",0),")",!
        .. W !,?7," Details:"
        .. S ODFN=0 F  S ODFN=$O(ORAMARR(OCLINIC,"B",ODFN)) Q:+ODFN'>0  D
        ... N OCDATE S OCDATE=0
        ... F  S OCDATE=$O(ORAMARR(OCLINIC,"B",ODFN,OCDATE)) Q:+OCDATE'>0  D
        .... N OCNT S OCNT=0 W !
        .... F  S OCNT=$O(ORAMARR(OCLINIC,"B",ODFN,OCDATE,OCNT)) Q:+OCNT'>0  D
        ..... W !,?8,ORAMARR(OCLINIC,"B",ODFN,OCDATE,OCNT)
        . I $G(ORAMARR(OCLINIC,"C",0))>0 D  ;CLOTS FOR THIS CLINIC
        .. N ODFN
        .. W !!,?7," Clots (",ORAMARR(OCLINIC,"C",0),")",!
        .. W !,?7," Details:"
        .. S ODFN=0 F  S ODFN=$O(ORAMARR(OCLINIC,"C",ODFN)) Q:+ODFN'>0  D
        ... N OCDATE S OCDATE=0
        ... F  S OCDATE=$O(ORAMARR(OCLINIC,"C",ODFN,OCDATE)) Q:+OCDATE'>0  D
        .... N OCNT S OCNT=0 W !
        .... F  S OCNT=$O(ORAMARR(OCLINIC,"C",ODFN,OCDATE,OCNT)) Q:+OCNT'>0  D
        ..... W !,?8,ORAMARR(OCLINIC,"C",ODFN,OCDATE,OCNT)
        Q
COMP1(ORAMARR,ORAMSDT,ORAMEDT,ORAMINCM,ORAMSORT)        ; Print Export Format
        N OCLINIC
        W @IOF,"COMPLICATIONS REPORT - ANTICOAGULATION: ",ORAMSDT," - ",ORAMEDT,!,$S('ORAMINCM:"  (** EXCLUDING MINOR COMPLICATIONS **)"_$C(13)_$C(10),1:"")
        I '$D(ORAMARR) W !,?5,"No Complications Noted."  Q
        W !,$S(ORAMSORT="c":"Clinic",1:"Division"),";Event;Patient;INR Draw Date;Complication Date"
        S OCLINIC="" F  S OCLINIC=$O(ORAMARR(OCLINIC)) Q:OCLINIC']""  D
        . I $D(ORAMARR(OCLINIC,"BX")) D  ;BLEEDS FOR THIS CLINIC
        .. N ODFN S ODFN=0 F  S ODFN=$O(ORAMARR(OCLINIC,"BX",ODFN)) Q:'+$G(ODFN)  D
        ... N OCDATE S OCDATE=0 F  S OCDATE=$O(ORAMARR(OCLINIC,"BX",ODFN,OCDATE)) Q:'+$G(OCDATE)  D
        .... W !,ORAMARR(OCLINIC,"BX",ODFN,OCDATE,99)
        . I $D(ORAMARR(OCLINIC,"CX")) D  ;CLOTS FOR THIS CLINIC
        .. N ODFN S ODFN=0 F  S ODFN=$O(ORAMARR(OCLINIC,"CX",ODFN)) Q:'+$G(ODFN)  D
        ... N OCDATE S OCDATE=0 F  S OCDATE=$O(ORAMARR(OCLINIC,"CX",ODFN,OCDATE)) Q:'+$G(OCDATE)  D
        .... W !,ORAMARR(OCLINIC,"CX",ODFN,OCDATE,99)
        Q
        ;
CONSULT(RESULT,ORAMDFN,ORAMCNM) ; Called from RPC=ORAMX CONSULT
        I '+$G(ORAMDFN) S RESULT(0)=0 Q
        I $G(ORAMCNM)="" S RESULT(0)=0 Q
        N ORAMCLST S ORAMCLST(0)=0
        D RPCLIST^GMRCTIU(.ORAMCLST,ORAMDFN)
        Q:ORAMCLST(0)=0  ;SHOULD BE NUMBER IN THE ARRAY
        I ORAMCLST(0)>0 D
        . N ORAMC S ORAMC=0 F  S ORAMC=$O(ORAMCLST(ORAMC)) Q:'+$G(ORAMC)  D
        .. Q:ORAMCNM'=$P(ORAMCLST(ORAMC),U,3)
        .. N ORAMK S ORAMK=0
        .. I $P(ORAMCLST(ORAMC),U,5)="PENDING" S ORAMK=1
        .. I $P(ORAMCLST(ORAMC),U,5)="ACTIVE" S ORAMK=1
        .. Q:'+ORAMK
        .. N ORAMD S ORAMD=$$FMTE^XLFDT($P(ORAMCLST(ORAMC),U,2),"2P")
        .. S RESULT(ORAMC)=ORAMD_":  "_$P(ORAMCLST(ORAMC),U,3)_"  ^"_$P(ORAMCLST(ORAMC),U,1)
        Q
PCESET(RESULT,ORAMDFN,ORAMD1,ORAMSC44,ORAMEDT,ORAMSVC,ORAMNARR,ORAMPDX) ; RPC to file PCE Data
        ; RPC = ORAMX PCESET
        ; ORAMDFN  = Pt. ID
        ; ORAMD1   = Data string e.g., 1143|300|99363|427.31|^SC~0^IR~0^EC~1^MST~0^HNC~1^SHAD~0
        ; ORAMSC44 = Hospital Location IEN
        ; ORAMEDT  = Encounter Date/Time
        ; ORAMSVC  = Service Category (e.g., "A"mbulatory or "T"elecommunications)
        ; ORAMNARR = Provider Narrative for Dx
        ; ORAMPDX  = Automatic Primary Indication code for Clinic
        ;
        I '+$G(ORAMDFN) S RESULT=99 Q
        I '+$G(ORAMSC44) S RESULT=99 Q
        I $G(ORAMD1)']"" S RESULT=99 Q
        N ORAMNOW,ORAMDAY S ORAMNOW=$$NOW^XLFDT
        S RESULT=0,ORAMEDT=$G(ORAMEDT,ORAMNOW),ORAMDAY=$P(ORAMEDT,"."),ORAMSVC=$G(ORAMSVC,"A")
        I $G(ORAMD1)'="" D
        . N ORAMDUZ,ORAMCPT,ORAMSC,ORAMDX,ORAMQ,ORAMVST,ERRARR,ERRPROB,ORAMPDXC,ORAMPDXT,ORAMPDXN
        . S ORAMDUZ=$P(ORAMD1,"|"),ORAMSC=$P(ORAMD1,"|",2),ORAMCPT=$P(ORAMD1,"|",3),ORAMQ=$P(ORAMD1,"|",5)
        . S ORAMDX=+$$CODEN^ICDCODE($P(ORAMD1,"|",4),80)
        . I +ORAMDX'>0 S RESULT=99 Q
        . I $G(ORAMPDX)]"" D
        . . S ORAMPDXC=$P(ORAMPDX,U),ORAMPDXT=$P(ORAMPDX,U,2)
        . . S ORAMPDXN=+$$CODEN^ICDCODE(ORAMPDXC,80)
        . . S ^TMP("ORAMPCE",$J,"DX/PL",1,"DIAGNOSIS")=$G(ORAMPDXN)
        . . S ^TMP("ORAMPCE",$J,"DX/PL",1,"PRIMARY")="P"
        . . S:ORAMPDXT]"" ^TMP("ORAMPCE",$J,"DX/PL",1,"NARRATIVE")=ORAMPDXT
        . . S ^TMP("ORAMPCE",$J,"DX/PL",2,"DIAGNOSIS")=$G(ORAMDX)
        . . S ^TMP("ORAMPCE",$J,"DX/PL",2,"PRIMARY")="S"
        . . S:$G(ORAMNARR)]"" ^TMP("ORAMPCE",$J,"DX/PL",2,"NARRATIVE")=ORAMNARR
        . E  D
        . . S ^TMP("ORAMPCE",$J,"DX/PL",1,"DIAGNOSIS")=$G(ORAMDX)
        . . S ^TMP("ORAMPCE",$J,"DX/PL",1,"PRIMARY")="P"
        . . S:$G(ORAMNARR)]"" ^TMP("ORAMPCE",$J,"DX/PL",1,"NARRATIVE")=ORAMNARR
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"DSS ID")=$G(ORAMSC)  ;STOP CODE 40.7
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"ENC D/T")=ORAMEDT
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"HOS LOC")=ORAMSC44  ;9727 ;8005
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"PATIENT")=ORAMDFN
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"ENCOUNTER TYPE")="P"  ;PRIMARY OR ANCILLARY
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"SERVICE CATEGORY")=ORAMSVC
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"CHECKOUT D/T")=$$NOW^XLFDT
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"PROCEDURE")=$G(ORAMCPT)
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"DIAGNOSIS")=$S($G(ORAMPDXN)]"":ORAMPDXN,1:$G(ORAMDX))
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"EVENT D/T")=ORAMEDT
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"QTY")=1
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"ENC PROVIDER")=$G(ORAMDUZ)  ;FILE 200
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"PRIMARY")=1
        . S ^TMP("ORAMPCE",$J,"PROCEDURE",1,"DEPARTMENT")=$G(ORAMSC)  ;STOP CODE 40.7
        . ;comes in like: ^SC~0^IR~0^EC~1^MST~0
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"SC")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"AO")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"IR")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"EC")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"MST")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"HNC")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"CV")=""
        . S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,"SHAD")=""
        . N ORAMCNT,I S ORAMCNT=$L(ORAMQ,U)
        . I +$G(ORAMCNT) F I=2:1:ORAMCNT D
        .. N T S T=$P(ORAMQ,U,I) Q:$G(T)=""
        .. I $P(T,"~",1)'="" S ^TMP("ORAMPCE",$J,"ENCOUNTER",1,$P(T,"~",1))=$P(T,"~",2)
        . S RESULT=$$DATA2PCE^PXAPI("^TMP(""ORAMPCE"",$J)","ORAM","ORAM ANTICOAGULATION MANAGEMENT PROGRAM",.ORAMVST,DUZ,,.ERRARR,,.ERRPROB)
        Q
WRAP(TEXT,LENGTH)       ; Breaks text string into substrings of length LENGTH
        N ORAMI,ORAMJ,LINE,ORAMX,ORAMX1,ORAMX2,ORAMY
        I $G(TEXT)']"" Q ""
        F ORAMI=1:1 D  Q:ORAMI=$L(TEXT," ")
        . S ORAMX=$P(TEXT," ",ORAMI)
        . I $L(ORAMX)>LENGTH D
        . . S ORAMX1=$E(ORAMX,1,LENGTH),ORAMX2=$E(ORAMX,LENGTH+1,$L(ORAMX))
        . . S $P(TEXT," ",ORAMI)=ORAMX1_" "_ORAMX2
        S LINE=1,ORAMX(1)=$P(TEXT," ")
        F ORAMI=2:1 D  Q:ORAMI'<$L(TEXT," ")
        . S:$L($G(ORAMX(LINE))_" "_$P(TEXT," ",ORAMI))>LENGTH LINE=LINE+1,ORAMY=1
        . S ORAMX(LINE)=$G(ORAMX(LINE))_$S(+$G(ORAMY):"",1:" ")_$P(TEXT," ",ORAMI),ORAMY=0
        S ORAMJ=0,TEXT="" F ORAMI=1:1 S ORAMJ=$O(ORAMX(ORAMJ)) Q:+ORAMJ'>0  S TEXT=TEXT_$S(ORAMI=1:"",1:"|")_ORAMX(ORAMJ)
        Q TEXT
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN)   ; Calls reader, returns response
        N DIR,X,Y
        S DIR(0)=TYPE
        I $D(SCREEN) S DIR("S")=SCREEN
        I $G(PROMPT)]"" S DIR("A")=PROMPT
        I $G(DEFAULT)]"" S DIR("B")=DEFAULT
        I $D(HELP) S DIR("?")=HELP
        D ^DIR
        I $G(X)="@" S Y="@" G READX
        I Y]"",($L($G(Y),U)'=2) S Y=Y_U_$G(Y(0),Y)
READX   Q Y
NAME(X,FMT)     ; Call with X="LAST,FIRST MI", FMT=Return Format ("LAST, FI")
        N ORLAST,ORLI,ORFIRST,ORFI,ORMI,ORI
        I X']"" S FMT="" G NAMEX
        I $S('$D(FMT):1,'$L(FMT):1,1:0) S FMT="LAST,FIRST"
        S FMT=$$LOW^XLFSTR(FMT)
        S ORLAST=$P(X,","),ORLI=$E(ORLAST),ORFIRST=$P(X,",",2)
        S ORFI=$E(ORFIRST)
        S ORMI=$S($P(ORFIRST," ",2)'="NMI":$E($P(ORFIRST," ",2)),1:"")
        S ORFIRST=$P(ORFIRST," ")
        F ORI="last","li","first","fi","mi" I FMT[ORI S FMT=$P(FMT,ORI)_@("OR"_$$UP^XLFSTR(ORI))_$P(FMT,ORI,2)
NAMEX   Q FMT
PATIENT()       ; Select a patient
        N X,DIC,Y
        S DIC=2,DIC(0)="AEMQ" D ^DIC
        Q Y
VALIDORD(ORDA)  ; Screen Orderable for INR
        N ORDNM,ORY,ORDGDA,ORID S ORDNM="",ORY=0
        ; if orderable item inactive, exclude it
        I +$G(^ORD(101.43,+ORDA,.1))>0 G VOX
        ; if display group is not LABORATORY, exclude it
        S ORDGDA=$P($G(^ORD(101.43,+ORDA,0)),U,5)
        I $S(+ORDGDA'>0:1,$P($G(^ORD(100.98,+ORDGDA,0)),U)'="LABORATORY":1,1:0) G VOX
        ; if ID not valid, exclude it
        S ORID=+$P($G(^ORD(101.43,+ORDA,0)),U,2)
        I '$$VALIDLAB(ORID) G VOX
        ; otherwise, allow selection
        S ORY=1
VOX     Q ORY
VALIDLAB(ORID)  ; Is lab test valid?
        N ORY S ORY=0
        I $S(+ORID'>0:1,'$D(^LAB(60,+ORID,0)):1,1:0) G VLX
        ; if entry in LABORATORY TEST file (#60) doesn't have a LOCATION (DATA NAME), exclude it
        I '$L($P($G(^LAB(60,+ORID,0)),U,5)) G VLX
        ; otherwise, allow selection
        S ORY=1
VLX     Q ORY
TEAMLIST(ORLIST)        ; Team List Reports
        N DIC,DHD,FLDS,L,FR,BY,TO,ORCL,ORPAR,ORALIST,ORCLIST
        S DIC="^OR(100.21,",L=0,FLDS="[ORAM TEAM LIST]",BY="[ORAM TEAM LIST]"
        W !!,"List of ",$S(ORLIST="A":"ALL",1:"COMPLEX")," Anticoagulation Patients for a Clinic",!
        S ORCL=$$SELLOC^ORAMSET
        I +ORCL'>0 D  Q
        . W $C(7),!!,"You must select a Clinic to proceed...",!
        D GET^ORAMSET(.ORPAR,ORCL)
        S ORALIST=$P($G(ORPAR(0)),U,2),ORCLIST=$P($G(ORPAR(0)),U,3)
        S:+ORALIST ORALIST=$P($G(^OR(100.21,ORALIST,0)),U)
        S:+ORCLIST ORCLIST=$P($G(^OR(100.21,ORCLIST,0)),U)
        S (FR,TO,DHD)=$S(ORLIST="A":ORALIST,1:ORCLIST)
        I FR']"" D  Q
        . W !,"You must define a list for ",$S(ORLIST="A":"ALL",1:"COMPLEX")," Anticoagulation Patients."
        . W $$READ("EA","Press Return to Continue...")
        D EN1^DIP
        Q
NEXTLAB ; Next Lab Report
        N DIC,DHD,FLDS,L,FR,BY,TO,ORCL,OREDT,ORLDT
        S DIC="^ORAM(103,",L=0,FLDS="[ORAM TEAM LIST]",BY="@CLINIC,NEXT LAB,@PATIENT",(OREDT,ORLDT)=""
        W !!,"List Anticoagulation Patients with Pending Lab Draws",!
        S ORCL=$$SELLOC^ORAMSET
        I +ORCL'>0 D  Q
        . W $C(7),!!,"You must select a Clinic to proceed...",!
        S ORCL=$P($G(^SC(+ORCL,0)),U)
        F  D  Q:+ORLDT>+OREDT!$D(DIRUT)
        . S OREDT=+$$READ("DA^::E","Please Enter START Date: ","T","Enter a start date for the report")
        . Q:'OREDT
        . S ORLDT=+$$READ("DA^::E","  Please Enter END Date: ","T+14","Enter an INCLUSIVE end date for the report")
        . Q:'ORLDT
        . I $L(ORLDT,".")=1 S ORLDT=ORLDT_".2359"
        . I OREDT>ORLDT W !,"END DATE must be more recent than the START DATE" S (OREDT,ORLDT)=""
        Q:$S(OREDT'>0:1,ORLDT'>0:1,1:0)
        S OREDT=$$FMTE^XLFDT(OREDT,2),ORLDT=$$FMTE^XLFDT(ORLDT,2)
        S DHD=ORCL_" Next Lab Report"
        S FR=ORCL_","_OREDT,TO=ORCL_","_ORLDT
        D EN1^DIP
        Q
