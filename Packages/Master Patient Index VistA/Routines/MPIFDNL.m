MPIFDNL ;OAK/TKW-CALL RPC TO ADD TO MPI DO NOT LINK FILE #985.28 ;12/29/08  16:13
        ;;1.0;MASTER PATIENT INDEX AUSTIN;**52**;30 Apr 99;Build 7
        ;
        ;Reference to ^XWB2HL7 supported by IA #3144
        ;Reference to ^XWBDRPC supported by IA #3149
        ;
CALLRPC(MPIFDUZ,MPIFSITE,MPIFFR,MPIFTO,MPIFINAC)        ; Activate (add if necessary) or
        ; inactivate entry on MPI DO NOT LINK file (#985.28)
        ;
        ; Called from option XDR VERIFY ALL when patient pair status set to VERIFIED, NOT A DUPLICATE
        ; Called from option XDR EDIT DUP RECORD STATUS when status set to POTENTIAL DUPLICATE, UNVERIFIED
        ;  MPIFDUZ = DUZ of current user (REQUIRED)
        ;  MPIFSITE = IEN from file 4 for current users institution (from DUZ(2)) (REQUIRED)
        ;  MPIFFR = First Patient IEN (DFN) from File 2 at the VistA site (REQUIRED)
        ;  MPIFTO = Second Patient IEN (DFN) from file 2 at the VistA site (REQUIRED)
        ;  MPIFINAC = If set to 1, entry will be inactivated (OPTIONAL)
        ;
        ; Call KERNEL routine to call remote RPC
        ; 1) Return array
        ; 2) Station number where RPC is to be executed (MPI="200M")
        ; 3) Name of RPC at VistA site
        ; 4) Version number
        ; 5) SOURCEID = TO_DFN~STATION~Assigning_Authority~Source_Type (Ex. 12345~500~USVHA~PI)
        ; 6) DNLSOURCEID = FROM_DFN~STATION~Assigning_Authority~Source_Type
        ; 7) DNLIDENTIFIEDBY = Name of person whose DUZ represents current user
        ; 8) DNLEVENT = "P" (KERNEL Duplicate Merge potential match resolution)
        ; 9) DNLIDENTIFYINGLOCATION = VistA station number
        ; 10) INACTIVATE_FLAG = (optional) set to "Y" if entry is to be inactivated.
        ; 
        N MPIFRTN,MPIFNAME,MPIFSTA,MPISTA,MPIFFRP,MPIFTOP,MPIFHNDL,MPIFUERR,X
        ; Set MPI station number
        S MPISTA="200M"
        ; Get current users name and current station number
        S MPIFDUZ=+$G(MPIFDUZ),MPIFSITE=+$G(MPIFSITE)
        S (MPIFNAME,MPIFSTA)=""
        I MPIFSITE,$D(^DIC(4,MPIFSITE,0)) S MPIFSTA=$$GET1^DIQ(4,+MPIFSITE_",",99)
        I MPIFSTA="" D  Q
        . D ERRMSG(MPIFNAME,MPIFSITE,MPIFFR,MPIFTO,"missing or invalid value in user's station DUZ(2) parameter")
        . Q
        I $D(^VA(200,MPIFDUZ,0)) S MPIFNAME=$$GET1^DIQ(200,MPIFDUZ_",",.01)
        I ('MPIFDUZ)!(MPIFNAME'?1U.E1","1U.E) D  Q
        . D ERRMSG(MPIFDUZ,MPIFSTA,MPIFFR,MPIFTO,"missing or invalid value in users DUZ variable")
        . Q
        S MPIFUERR=0
        S X=$$GET1^DIQ(200,MPIFDUZ_",",9)
        ; If station is not MANILA-RO, user must have an SSN.
        I MPIFSTA'=358,X'?9N D  Q
        . D ERRMSG(MPIFDUZ,MPIFSTA,MPIFFR,MPIFTO,"Current user has missing or invalid SSN")
        . Q
        S MPIFFR=+$G(MPIFFR),MPIFTO=+$G(MPIFTO)
        I ('$D(^DPT(MPIFFR,0)))!('$D(^DPT(MPIFTO,0))) D  Q
        . D ERRMSG(MPIFNAME,MPIFSTA,MPIFFR,MPIFTO,"invalid FROM or TO patient input variable")
        . Q
        ; Build FROM patient parameter
        S MPIFFRP=MPIFFR_"~"_MPIFSTA_"~USVHA~PI"
        ; Build TO patient parameter
        S MPIFTOP=MPIFTO_"~"_MPIFSTA_"~USVHA~PI"
        ; Call RPC to Activate or Inactivate the entry in the MPI DO NOT LINK file.
        I $G(MPIFINAC) D EN1^XWB2HL7(.MPIFRTN,MPISTA,"MPIF DNL ADD UPD",1,MPIFTOP,MPIFFRP,"P",MPIFSTA,MPIFNAME,"Y")
        I '$G(MPIFINAC) D EN1^XWB2HL7(.MPIFRTN,MPISTA,"MPIF DNL ADD UPD",1,MPIFTOP,MPIFFRP,"P",MPIFSTA,MPIFNAME)
        ; If RPC was not scheduled, return error.
        I $G(MPIFRTN(0))=""!($P($G(MPIFRTN(0)),U)=0)!(+$G(MPIFRTN(0))=-1) D  Q
        . S X=$P($G(MPIFRTN(0)),U,2)
        . S:X="" X=$P($G(MPIFRTN(1)),U,2)
        . D ERRMSG(MPIFNAME,MPIFSTA,MPIFFR,MPIFTO,X)
        . Q
        ; Schedule a taskman job to process results of RPC
        S MPIFHNDL=MPIFRTN(0)
        N ZTIO,ZTSK,ZTRTN,ZTDESC,ZTSAVE,ZTDTH,Y
        S ZTIO="",ZTRTN="CHKRSLT^MPIFDNL",ZTDTH=$H
        S ZTSAVE("MPIFHNDL")=MPIFHNDL,ZTSAVE("MPIFNAME")=MPIFNAME,ZTSAVE("MPIFSTA")=MPIFSTA
        S ZTSAVE("MPIFFR")=MPIFFR,ZTSAVE("MPIFTO")=MPIFTO
        S ZTDESC="Check Results from call to RPC MPIF DNL ADD UPD"
        D ^%ZTLOAD
        I '$G(ZTSK) D  Q
        . S MPIFMSG="Results not returned from RPC to log an MPI DO NOT LINK entry for User "_MPIFNAME_" at station "_MPIFSTA_", for "_MPIFFR_" and "_MPIFTO_"."
        . D EXC^RGHLLOG(208,MPIFMSG,MPIFTO)
        . D STOP^RGHLLOG(0)
        . Q
        Q
        ;
CHKRSLT ; Check results from calling RPC (QUEUED job)
        N MPIFCNT,MPIFRTN,MPIFDONE,X
        S MPIFDONE=0
        F MPIFCNT=1:1:20 D  Q:MPIFDONE
        . H 5
        . D RTNDATA^XWBDRPC(.MPIFRTN,MPIFHNDL)
        . Q:$P(MPIFRTN(0),U)=0  ; Not done
        . I $P(MPIFRTN(0),U)=-1 D  Q
        . . I MPIFRTN(0)["Not DONE" Q
        . . S X=$P($G(MPIFRTN(0)),U,2)
        . . S:X="" X=$P($G(MPIFRTN(1)),U,2)
        . . D ERRMSG(MPIFNAME,MPIFSTA,MPIFFR,MPIFTO,X)
        . . S MPIFDONE=1
        . . Q
        . ; Success.
        . S MPIFDONE=1 Q
        Q
        ;
ERRMSG(MPIFNAME,MPIFSTA,MPIFFR,MPIFTO,MPIFMSG)  ; Send error to CIRN HL7 EXCEPTION LOG (991.1)
        S MPIFMSG="User "_MPIFNAME_" at station "_MPIFSTA_" failed to log a DO NOT LINK event for "_MPIFFR_" and "_MPIFTO_" due to "_MPIFMSG
        ; If MPIFTO is invalid, set it to null so it won't cause a problem logging the error
        I '$D(^DPT(+MPIFTO,0)) S MPIFTO=""
        D EXC^RGHLLOG(208,MPIFMSG,MPIFTO)
        D STOP^RGHLLOG(0)
        Q
        ;
        ;
