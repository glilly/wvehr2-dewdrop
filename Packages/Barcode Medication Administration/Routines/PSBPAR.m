PSBPAR  ;BIRMINGHAM/EFC-BCMA PARAMETER MANAGEMENT ;Mar 2004
        ;;3.0;BAR CODE MED ADMIN;**13,28**;Mar 2004;Build 9
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
        ;
EN      ; Standard editting of parameters
        K PSBDIV,PSBLIST,DIC
        W !!,"BCMA Parameters Management",!!
        W "You are currently logged onto Division: "_DUZ(2)
        S DIC="^DIC(4,",DIC(0)="AEQM",DIC("A")="Select Division: " D ^DIC Q:+Y<1
        S PSBDIV=+Y_";DIC(4,"
        K DIR S DIR(0)="Y",DIR("A")="Edit Divisional Parameters",DIR("B")="Yes"
        D ^DIR K DIR I Y D TED^XPAREDIT("PSB DIVISION","AB",PSBDIV)
        K DIR S DIR(0)="Y",DIR("A")="Edit Default Lists",DIR("B")="Yes"
        D ^DIR K DIR D:Y
        .S DIR(0)="SO^1:Reasons Given PRN;2:Reasons Held;3:Reasons Refused;4:Injection Sites"
        .S DIR("A")="Select Default List"
        .F  W @IOF,!,"BCMA Default Lists",! D ^DIR Q:'Y  D
        ..N DIR
        ..I Y=1 D TED^XPAREDIT("PSB LIST REASONS GIVEN PRN","AB",PSBDIV) Q
        ..I Y=2 D TED^XPAREDIT("PSB LIST REASONS HELD","AB",PSBDIV) Q
        ..I Y=3 D TED^XPAREDIT("PSB LIST REASONS REFUSED","AB",PSBDIV) Q
        ..I Y=4 D TED^XPAREDIT("PSB LIST INJECTION SITES","AB",PSBDIV) Q
        Q
        ;
RPC(RESULTS,PSBCMD,PSBENT,PSBPAR,PSBINS,PSBVAL) ; Main RPC Hit Point
        ;
        ; RPC: PSB PARAMETER
        ;
        ; Description:
        ; Called by client to return or set parameters
        ;
        N PSBERR,PSBTMP
        D:PSBCMD="GETPAR" GETPAR(PSBENT,PSBPAR)
        D:PSBCMD="GETLST" GETLST(PSBENT,PSBPAR)
        D:PSBCMD="SETPAR" SETPAR(PSBENT,PSBPAR,PSBINS,PSBVAL)
        D:PSBCMD="DELLST" DELLST(PSBENT,PSBPAR)
        D:PSBCMD="GETDIV" GETDIV(PSBENT)
        S:'$D(RESULTS) RESULTS(0)="-1^Unknown Internal Error "_PSBCMD
        Q
        ;
GETDIV(PSBENT)  ; Return a valid Entity pointer from user input
        S X=$$FIND1^DIC(4,"","MX",PSBENT)
        I +X<1 S RESULTS(0)="-1^Error, Station # "_PSBENT_" not found." Q
        S RESULTS(0)="1^"_(+X)_";DIC(4,"
        S RESULTS(1)=$$GET1^DIQ(4,+X_",",.01)_" ("_$$GET1^DIQ(4,+X_",",99)_")"
        S RESULTS(2)=$$GET1^DIQ(4,+X_",",1.01)
        S RESULTS(3)=$$GET1^DIQ(4,+X_",",1.02)
        S RESULTS(4)=$$GET1^DIQ(4,+X_",",1.03)
        S RESULTS(5)=$$GET1^DIQ(4,+X_",",.02)
        S RESULTS(6)=$$GET1^DIQ(4,+X_",",1.04)
        S PSBEDIV=+X  ;do NOT kill this variable - needed until gui context ends
        Q
        ;
GETPAR(PSBENT,PSBPAR)   ; Return a parameter
        I PSBPAR="PSB 5 RIGHTS IV" S RESULTS(0)=$$GET^XPAR(PSBENT,PSBPAR,,"I") Q
        I PSBPAR="PSB 5 RIGHTS UNITDOSE" S RESULTS(0)=$$GET^XPAR(PSBENT,PSBPAR,,"I") Q
        S RESULTS(0)=$$GET^XPAR(PSBENT,PSBPAR,,"B")
        Q
        ;
GETLST(PSBENT,PSBPAR)   ; Return a parameter list
        D GETLST^XPAR(.PSBTMP,PSBENT,PSBPAR,,.PSBERR)
        I PSBERR S RESULTS(0)="-1^Error: "_(+PSBERR)_" "_$P(PSBERR,"^",2) Q
        S RESULTS(0)=PSBTMP
        F Y=0:0 S Y=$O(PSBTMP(Y)) Q:'Y  S RESULTS(Y)=$P(PSBTMP(Y),"^",2)
        Q
        ;
SETPAR(PSBENT,PSBPAR,PSBINS,PSBVAL)     ; Set a new parameter
        D EN^XPAR(PSBENT,PSBPAR,PSBINS,PSBVAL,.PSBERR)
        I 'PSBERR S RESULTS(0)="1^Success"
        E  S RESULTS(0)="-1^Error: "_(+PSBERR)_" "_$P(PSBERR,"^",2)
        Q
        ;
DELLST(PSBENT,PSBPAR)   ; Clear a list
        D NDEL^XPAR(PSBENT,PSBPAR,.PSBERR)
        I 'PSBERR S RESULTS(0)="1^Success"
        E  S RESULTS(0)="-1^Error: "_(+PSBERR)_" "_$P(PSBERR,"^",2)
        Q
        ;
USRDEF(PSBPAR)  ; Return a parameter for the user
        Q $$GET^XPAR("ALL",PSBPAR)
        ;
RSTUSR  ; Reset all a users parameters
        N PSBUSR,PSBENT,RESULTS
        S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="Select User to Reset: "
        D ^DIC K DIC Q:+Y<1  S PSBUSR=+Y
        W !!,"Are you sure you want to reset all parameters for this user"
        S %=2 D YN^DICN Q:%'=1
        W !,"Resetting..."
        S PSBENT=PSBUSR_";VA(200,"
        D DEL^XPAR(PSBENT,"PSB PRINTER USER DEFAULT",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL BLANKS",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL CONT",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL IV MEDS",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL ON-CALL",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL ONE-TIME",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL PRN",1)
        D DEL^XPAR(PSBENT,"PSB VDL INCL UD MEDS",1)
        D DEL^XPAR(PSBENT,"PSB VDL START TIME",1)
        D DEL^XPAR(PSBENT,"PSB VDL STOP TIME",1)
        D DEL^XPAR(PSBENT,"PSB WINDOW",1)
        D DEL^XPAR(PSBENT,"PSB UNIT DOSE COLUMN WIDTHS",1)
        D DEL^XPAR(PSBENT,"PSB VDL SORT COLUMN",1)
        D DEL^XPAR(PSBENT,"PSB VDL PB SORT COLUMN",1)
        D DEL^XPAR(PSBENT,"PSB VDL IV SORT COLUMN",1)
        D DEL^XPAR(PSBENT,"PSB IV COLUMN WIDTHS",1)
        D DEL^XPAR(PSBENT,"PSB IVPB COLUMN WIDTHS",1)
        D DEL^XPAR(PSBENT,"PSB HKEY",1)
        D DEL^XPAR(PSBENT,"PSB IDLE TIMEOUT",1)
        D DEL^XPAR(PSBENT,"PSB GUI DEFAULT PRINTER",1)
        D DEL^XPAR(PSBENT,"PSB COVERSHEET VIEWS COL SORT",1)
        D DEL^XPAR(PSBENT,"PSB COVERSHEET V1 COL WIDTHS",1)
        D DEL^XPAR(PSBENT,"PSB COVERSHEET V2 COL WIDTHS",1)
        D DEL^XPAR(PSBENT,"PSB COVERSHEET V3 COL WIDTHS",1)
        D DEL^XPAR(PSBENT,"PSB COVERSHEET V4 COL WIDTHS",1)
        W "Done.",!
        Q
        ;
