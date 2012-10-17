BPSRPT3 ;BHAM ISC/BEE - ECME REPORTS ;14-FEB-05
        ;;1.0;E CLAIMS MGMT ENGINE;**1,3,5,7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
        ; Select the ECME Pharmacy or Pharmacies
        ; 
        ; Input Variable -> none
        ; Return Value ->   "" = Valid Entry or Entries Selected
        ;                                        ^ = Exit
        ;                                       
        ; Output Variable -> BPPHARM = 1 One or More Pharmacies Selected
        ;                          = 0 User Entered 'ALL'
        ;                            
        ; If BPPHARM = 1 then the BPPHARM array will be defined where:
        ;    BPPHARM(ptr) = ptr ^ BPS PHARMACY NAME and
        ;    ptr = Internal Pointer to BPS PHARMACIES file (#9002313.56)
        ;                    
SELPHARM()      N DIC,DIR,DIRUT,DTOUT,DUOUT,X,Y
        ;
        ;Reset BPPHARM array
        K BPPHARM
        ;
        ;First see if they want to enter individual divisions or ALL
        S DIR(0)="S^D:DIVISION;A:ALL"
        S DIR("A")="Select Certain Pharmacy (D)ivisions or (A)LL"
        S DIR("L",1)="Select one of the following:"
        S DIR("L",2)=""
        S DIR("L",3)="     D         DIVISION"
        S DIR("L",4)="     A         ALL"
        D ^DIR K DIR
        ;
        ;Check for "^" or timeout, otherwise define BPPHARM
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        E  S BPPHARM=$S(Y="A":0,1:1)
        ;
        ;If division selected, ask prompt
        I $G(BPPHARM)=1 F  D  Q:Y="^"!(Y="") 
        .;
        .;Prompt for entry
        .K X S DIC(0)="QEAM",DIC=9002313.56,DIC("A")="Select ECME Pharmacy Division(s): "
        .W ! D ^DIC
        .;
        .;Check for "^" or timeout 
        .I ($G(DUOUT)=1)!($G(DTOUT)=1) K BPPHARM S Y="^" Q
        .;
        .;Check for blank entry, quit if no previous selections
        .I $G(X)="" S Y=$S($D(BPPHARM)>9:"",1:"^") K:Y="^" BPPHARM Q
        .;
        .;Handle Deletes
        .I $D(BPPHARM(+Y)) D  Q:Y="^"  I 1
        ..N P
        ..S P=Y  ;Save Original Value
        ..S DIR(0)="S^Y:YES;N:NO",DIR("A")="Delete "_$P(P,U,2)_" from your list?"
        ..S DIR("B")="NO" D ^DIR
        ..I ($G(DUOUT)=1)!($G(DTOUT)=1) K BPPHARM S Y="^" Q
        ..I Y="Y" K BPPHARM(+P),BPPHARM("B",$P(P,U,2),+P)
        ..S Y=P  ;Restore Original Value
        ..K P
        .E  D
        ..;Define new entries in BPPHARM array
        ..S BPPHARM(+Y)=Y
        ..S BPPHARM("B",$P(Y,U,2),+Y)=""
        .;
        .;Display a list of selected divisions
        .I $D(BPPHARM)>9 D
        ..N X
        ..W !,?2,"Selected:"
        ..S X="" F  S X=$O(BPPHARM("B",X)) Q:X=""  W !,?10,X
        ..K X
        .Q
        ;
        K BPPHARM("B")
        Q Y
        ;
        ; Display (S)ummary or (D)etail Format
        ; 
        ; Input Variable -> DFLT = 1 Summary
        ;                          2 Detail
        ;                          
        ; Return Value ->   1 = Summary
        ;                   0 = Detail
        ;                   ^ = Exit
        ;
SELSMDET(DFLT)  N DIR,DIRUT,DTOUT,DUOUT,X,Y
        S DFLT=$S($G(DFLT)=1:"Summary",$G(DFLT)=0:"Detail",1:"Detail")
        S DIR(0)="S^S:Summary;D:Detail",DIR("A")="Display (S)ummary or (D)etail Format",DIR("B")=DFLT
        D ^DIR
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        S Y=$S(Y="S":1,Y="D":0,1:Y)
        Q Y
        ;
        ; Display (C)MOP or (M)ail or (W)indow or (A)ll
        ; 
        ;    Input Variable -> DFLT = C CMOP
        ;                             W Window
        ;                             M Mail
        ;                             A All
        ;                          
        ;    Return Value ->   C = CMOP
        ;                      W = Window
        ;                      M = Mail
        ;                      A = All
        ;                      ^ = Exit
        ; 
SELMWC(DFLT)    N DIR,DIRUT,DTOUT,DUOUT,X,Y
        S DFLT=$S($G(DFLT)="C":"CMOP",$G(DFLT)="W":"Window",$G(DFLT)="M":"Mail",1:"ALL")
        S DIR(0)="S^C:CMOP;M:Mail;W:Window;A:ALL"
        S DIR("A")="Display (C)MOP or (M)ail or (W)indow or (A)LL",DIR("B")=DFLT
        D ^DIR
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        Q Y
        ;
        ; Display (R)ealTime Fills or (B)ackbills or (A)LL
        ;
        ;    Input Variable -> DFLT = 3 Backbill
        ;                             2 Real Time Fills
        ;                             1 ALL
        ;                          
        ;    Return Value ->   3 = Backbill (manually)
        ;                      2 = Real Time Fills (automatically during FINISH)
        ;                      1 = ALL
        ;                      ^ = Exit
        ;
SELRTBCK(DFLT)  N DIR,DIRUT,DTOUT,DUOUT,X,Y
        S DFLT=$S($G(DFLT)=2:"Real Time",$G(DFLT)=3:"Backbill",1:"ALL")
        S DIR(0)="S^R:Real Time Fills;B:Backbill;A:ALL"
        S DIR("A")="Display (R)ealTime Fills or (B)ackbills or (A)LL",DIR("B")=DFLT
        D ^DIR
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        S Y=$S(Y="A":1,Y="R":2,Y="B":3,1:Y)
        Q Y
        ;
        ; Display Specific (D)rug or Drug (C)lass
        ; 
        ;    Input Variable -> DFLT = 3 Drug Class
        ;                             2 Drug
        ;                             1 ALL
        ;                          
        ;     Return Value ->   3 = Drug Class
        ;                       2 = Drug
        ;                       1 = ALL
        ;                       ^ = Exit
        ;                       
SELDRGAL(DFLT)  N DIR,DIRUT,DTOUT,DUOUT,X,Y
        S DFLT=$S($G(DFLT)=2:"Drug",$G(DFLT)=3:"Drug Class",1:"ALL")
        S DIR(0)="S^D:Drug;C:Drug Class;A:ALL"
        S DIR("A")="Display Specific (D)rug or Drug (C)lass or (A)LL",DIR("B")=DFLT
        D ^DIR
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        S Y=$S(Y="A":1,Y="D":2,Y="C":3,1:Y)
        Q Y
        ;
        ; Select Drug
        ; 
        ; Input Variable -> none
        ; 
        ; Return Value -> ptr = pointer to DRUG file (#50)
        ;                   ^ = Exit
        ;                   
SELDRG()        N DIC,DIRUT,DUOUT,X,Y
        ;
        ;Prompt for entry
        W ! D SELDRG^BPSRPT6
        ;
        ;Check for "^", timeout, or blank entry
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        ;
        ;Check for Valid Entry
        I +Y>0 S Y=+Y
        ;
        Q Y
        ;
        ; Select Drug Class
        ; 
        ; Input Variable -> none
        ; 
        ; Return Value -> ptr = pointer to VA DRUG CLASS file (#50.605)
        ;                   ^ = Exit
        ;
SELDRGCL()      N DIC,DIRUT,DUOUT,Y
        ;
        ;Prompt for entry
        W ! D SELDRGC^BPSRPT6
        ;
        ;Check for "^", timeout, or blank entry
        I ($G(DUOUT)=1)!($G(DTOUT)=1)!($G(Y)="") S Y="^"
        ;
        Q Y
        ;
        ; Enter Date Range
        ;
        ; Input Variable -> TYPE = 7 CLOSE REPORT
        ;                          1-6 OTHER REPORTS
        ;
        ; Return Value -> P1^P2
        ; 
        ;           where P1 = From Date
        ;                    = ^ Exit
        ;                 P2 = To Date
        ;                    = blank for Exit
        ;                 
SELDATE(TYPE)   N BPSIBDT,DIR,DIRUT,DTOUT,DUOUT,VAL,X,Y
        S TYPE=$S($G(TYPE)=7:"CLOSE",1:"TRANSACTION")
SELDATE1        S VAL="",DIR(0)="DA^:DT:EX",DIR("A")="START WITH "_TYPE_" DATE: ",DIR("B")="T-1"
        W ! D ^DIR
        ;
        ;Check for "^", timeout, or blank entry
        I ($G(DUOUT)=1)!($G(DTOUT)=1)!($G(X)="") S VAL="^"
        ;
        I VAL="" D
        .S $P(VAL,U)=Y
        .S DIR(0)="DA^"_VAL_":DT:EX",DIR("A")="  GO TO "_TYPE_" DATE: ",DIR("B")="T"
        .D ^DIR
        .;
        .;Check for "^", timeout, or blank entry
        .I ($G(DUOUT)=1)!($G(DTOUT)=1)!($G(X)="") S VAL="^" Q
        .;
        .;Define Entry
        .S $P(VAL,U,2)=Y
        ;
        Q VAL
        ;
        ; Select to Include Eligibility of (V)eteran, (T)ricare, or (A)ll
        ; 
        ; Input Variable -> DFLT = 0 = All
        ;                          1 = Veteran
        ;                          2 = Tricare
        ;                          3 = ChampVA (Reserved for future use)
        ; 
        ; Return Value ->  V, T, or 0 for All
SELELIG(DFLT)   N DIC,DIR,DIRUT,DUOUT,X,Y
        ;
        S DFLT=$S($G(DFLT)=1:"V",$G(DFLT)=2:"T",$G(DFLT)=3:"C",1:"A")
        S DIR(0)="S^V:VETERAN;T:TRICARE;A:ALL"
        S DIR("A")="Include Certain Eligibility Type or (A)ll",DIR("B")=DFLT
        D ^DIR
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        ;
        S Y=$S(Y="A":0,1:Y)
        Q Y
        ;
        ; Select to Include Open or Closed or All claims
        ; 
        ; Input Variable -> DFLT = 0 = All
        ;                          1 = Closed
        ;                          2 = Open
        ; 
        ; Return Value -> 0 = All, 1 = Closed, 2 = Open
SELOPCL(DFLT)   N DIC,DIR,DIRUT,DUOUT,X,Y
        ;
        S DFLT=$S($G(DFLT)=1:"C",$G(DFLT)=2:"O",1:"A")
        S DIR(0)="S^O:OPEN;C:CLOSED;A:ALL"
        S DIR("A")="Include (O)pen, (C)losed, or (A)ll Claims",DIR("B")=DFLT
        D ^DIR
        I ($G(DUOUT)=1)!($G(DTOUT)=1) S Y="^"
        ;
        S Y=$S(Y="C":1,Y="O":2,1:0)
        Q Y
        ;
