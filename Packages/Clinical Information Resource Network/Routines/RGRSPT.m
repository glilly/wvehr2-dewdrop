RGRSPT  ;ALB/RJS,CML-HIGH LEVEL ROUTINE FOR PARSING AND FILING ;06/25/98
        ;;1.0;CLINICAL INFO RESOURCE NETWORK;**1,3,7,8,52**;30 Apr 99;Build 2
        ;
        ;Parse Incoming Message, and file.
        ;
        ;
        Q:($G(HL("MTN"))'="ADT")
        N RGRSDFN,VAFCA,RGRS,VAFCA08,RGRSARAY,BOGUS,RGDC,SENSTVTY,CMORDISP
        N NAME,LASTNAME,SSN,ICN,CMOR,CMORIEN,OTHSITE,RGRSDATA,HERE,BULSUB,NODE
        S RGRSARAY="RGRS(2)"
        D INITIZE^RGRSUTIL ;copy HL7 message into local RGDC array
        S VAFCA=$$EN^RGRSMSH() ;parse MSH for filer
        D EN^RGRSPARS(RGRSARAY) ;parse HL7 message into local array RGRS
        I $$SKIP^RGRSZZPT(1,RGRSARAY) D  G EXIT ;skip if certain data is not there
        . D SKIPBULL^RGRSBULL(RGRSARAY)
        S RGRSDFN=$$GETDFN^MPIF001(@RGRSARAY@(991.01)) ;Get DFN from ICN
        Q:+$$SEND2^VAFCUTL1(RGRSDFN,"T")  ;safeguard to prevent the processing of test patients
        S OTHSITE=@RGRSARAY@("SITENUM")\1
        S HERE=$P($$SITE^VASITE,"^",3)\1
        ;
        ;If patient not known in site, send bulletin, go exit
        ;
        I +RGRSDFN=-1 D EXC^RGHLLOG(210,"Msg#"_$G(HL("MID"))_" Bad DFN#"_$G(RGRSDFN)_" for "_$G(@RGRSARAY@(.01))_" (ICN#"_$G(@RGRSARAY@(991.01))_")") D STOP^RGHLLOG(1) Q
        ;
        S NAME=$$GET1^DIQ(2,+RGRSDFN_",",.01)
        S LASTNAME=$P(NAME,",",1)
        S SSN=$$GET1^DIQ(2,+RGRSDFN_",",.09)
        S NODE=$$MPINODE^MPIFAPI(RGRSDFN)
        S ICN=$P(NODE,"^")
        S CMORIEN=$P(NODE,"^",3)
        S CMOR=$$NS^XUAF4(CMORIEN)
        S CMORDISP=$P(CMOR,"^",1)
        S CMOR=$P(CMOR,"^",2)
        ;
        S @RGRSARAY@("NAME")=@RGRSARAY@(.01)
        S @RGRSARAY@("SSN")=@RGRSARAY@(.09)
        S @RGRSARAY@("ICN")=@RGRSARAY@(991.01)
        S @RGRSARAY@("CMOR")=$P($$NS^XUAF4($$LKUP^XUAF4(OTHSITE)),"^")
        ;
        ;If ICN or CMOR don't match, send bulletin and go exit
        I '$$MATCH(RGRSDFN,RGRSARAY,,,ICN,CMOR,.BULSUB) D  G EXIT
        . D MTCHBULL^RGRSBULL(RGRSDFN,RGRSARAY,NAME,SSN,ICN,CMORDISP,BULSUB)
        ;
        ;if ICN and CMOR match, check for SSN edit from CMOR
        I @RGRSARAY@("SENDING SITE")=CMOR,(SSN'=@RGRSARAY@(.09)) D
        .D SSNBULL^RGRSBUL1(RGRSDFN,RGRSARAY,NAME,SSN,ICN,CMORDISP)
        ;
        ;If patient is Sensitive at other site but not here send bulletin
        S SENSTVTY=$G(@RGRSARAY@("SENSITIVITY"))
        I '$$SENSTIVE^RGRSENS(RGRSDFN),SENSTVTY D SENSTIVE^RGRSBUL1(RGRSDFN,RGRSARAY,NAME)
        ;
        ;MPIC_772 - **52; Commented out Remote Date of Death Indicated section.
        ;If patient has DATE OF DEATH (DOD) at remote site send bulletin
        ;Ignore time if present with date.
        ;S RMTDOD=@RGRSARAY@(.351),RMTDOD=$P(RMTDOD,".")
        ;S DFN=RGRSDFN D DEM^VADPT
        ;S LOCDOD=$P($P(VADM(6),"^"),".")
        ;If there is a remote DOD but no local DOD  OR
        ;if remote DOD is different from local DOD, send bulletin
        ;I RMTDOD D RMTDOD^RGRSBUL1(RGRSDFN,RGRSARAY,NAME,RMTDOD,LOCDOD)
        ;K LOCDOD,RMTDOD,VADM
        ;
        D  G EXIT ;**7
        . ;
        . ;IF it's the CMOR - review file
        . ;
        . I (OTHSITE)=(HERE) D  Q
        . . S VAFCA=VAFCA_"^"_RGRSDFN
        . . S VAFCA08=1 S BOGUS=$$ADD^VAFCEHU1(VAFCA,"RGRS")
        . ;
        . ;IF it's not the CMOR - Don't Rebroadcast
        . ;
        . I (OTHSITE)'=(HERE) D  Q
        . . S VAFCA08=1
        . . D EDIT^VAFCPTED(RGRSDFN,RGRSARAY,".01;.03;.09;.02;.2403") ;**7 broadcasted fields - removed .05,.08,.111;.112;.113;.114;.115;.1112;.117;.131;.132;.211;.219;.31115
EXIT    ;
        Q
        ;
MATCH(DFN,RGRSARAY,LASTNAME,SSN,ICN,CMOR,BULSUB)        ;
        Q:$G(DFN)=""!($G(RGRSARAY)="") 0
        N COUNT,TRUE S (COUNT,TRUE)=0
        S BULSUB=""
        I $D(LASTNAME) D
        . S COUNT=COUNT+1
        . I (LASTNAME'=""),(LASTNAME=$P(@RGRSARAY@(.01),",",1)) S TRUE=TRUE+1
        I $D(SSN) D
        . S COUNT=COUNT+1
        . I (SSN'=""),(SSN=$G(@RGRSARAY@(.09))) S TRUE=TRUE+1
        I $D(ICN) D
        . S COUNT=COUNT+1
        . I (ICN'=""),(ICN=$G(@RGRSARAY@(991.01))) S TRUE=TRUE+1 Q
        . S BULSUB=BULSUB_"ICN"
        I $D(CMOR) D
        . S COUNT=COUNT+1
        . I (CMOR'=""),(CMOR=$G(@RGRSARAY@("SITENUM"))) S TRUE=TRUE+1 Q
        . I BULSUB]"" S BULSUB=BULSUB_" & "
        . S BULSUB=BULSUB_"CMOR"
        I COUNT=TRUE Q 1
        Q 0
