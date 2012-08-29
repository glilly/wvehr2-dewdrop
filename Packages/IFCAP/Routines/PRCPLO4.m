PRCPLO4 ;WOIFO/DAP- Option to allow users to set CLRS parameters ; 10/19/06 8:44am
V ;;5.1;IFCAP;**83,98**;Oct 20, 2000;Build 37
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
ENT ;This allows users to enter new values for the parameters associated 
 ;with the Clinical Logistics Report Server by prompting them for 
 ;a new value for each parameter after presenting the current value.  
 ;Values are screened for validity and errors in setting the parameters 
 ;are returned to the screen. IA #2263 can be referenced for further 
 ;information on the ^XPAR calls utilized here.
 ;  
 N PRCP1,PRCP2,PRCP3,PRCP4,PRCP5,PRCP6,PRCPW,PRCPU,PRCPV,PRCPX,PRCPY,PRCPZ,ERR
 D PRR I ERR Q
 D PGR I ERR Q
 D PIR I ERR Q
 D PED I ERR Q
 ;
 ;*98 Added logic for modification of PRC CLRS ADDRESS and 
 ;PRC CLRS OUTLOOK MAILGROUP parameters
 ;
 D PAD I ERR Q
 D POG I ERR Q
 Q
 ;
PRR ;Provide current value of and then prompt to modify the PRCPLO REPORT RANGE parameter
 ;
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 S ERR=0
 S DIR(0)="NOA^0:999",DIR("A")="Stock On Hand Report Range: "
 S PRCP1=$$GET^XPAR("SYS","PRCPLO REPORT RANGE",1,"Q")
 I PRCP1'="" S DIR("B")=PRCP1
 S DIR("?")="Please enter a number between 0 and 999 with no decimal digits"
 D ^DIR I $D(DUOUT)!$D(DTOUT) S ERR=1 Q
 I PRCP1=X Q
 I X'="@" S PRCP1=X
 I X="@" D EN^DDIOL("Deletions not allowed") G PRR
 K DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 D EN^XPAR("SYS","PRCPLO REPORT RANGE",1,PRCP1,.PRCPX)
 I PRCPX=0 W ! D EN^DDIOL("Stock on Hand Report Range successfully set to "_PRCP1)
 I PRCPX'=0 W ! D EN^DDIOL("Error while trying to edit the Stock on Hand Report Range:") W ! D EN^DDIOL($P(PRCPX,"^",2))
 Q
 ;
PIR ;Provide current value of and then prompt to modify the PRCPLO INACTIVITY RANGE parameter
 ;
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 S ERR=0
 S DIR(0)="NOA^0:999",DIR("A")="Stock Status Report Inactivity Range: "
 S PRCP2=$$GET^XPAR("SYS","PRCPLO INACTIVITY RANGE",1,"Q")
 I PRCP2'="" S DIR("B")=PRCP2
 S DIR("?")="Please enter a number between 0 and 999 with no decimal digits"
 D ^DIR I $D(DUOUT)!$D(DTOUT) S ERR=1 Q
 I PRCP2=X Q
 I X'="@" S PRCP2=X
 I X="@" D EN^DDIOL("Deletions not allowed")  G PIR
 K DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 D EN^XPAR("SYS","PRCPLO INACTIVITY RANGE",1,PRCP2,.PRCPY)
 I PRCPY=0 W ! D EN^DDIOL("Stock Status Report Inactivity Range successfully set to "_PRCP2)
 I PRCPY'=0 W ! D EN^DDIOL("Error while trying to edit the Stock Status Report Inactivity Range:") W ! D EN^DDIOL($P(PRCPY,"^",2))
 Q
 ;
PGR ;Provide current value of and then prompt to modify the PRCPLO GREATER THAN RANGE parameter
 ;
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 S ERR=0
 S DIR(0)="NOA^0:999",DIR("A")="Stock On Hand Report Greater Than Range: "
 S PRCP3=$$GET^XPAR("SYS","PRCPLO GREATER THAN RANGE",1,"Q")
 I PRCP3'="" S DIR("B")=PRCP3
 S DIR("?")="Please enter a number between 0 and 999 with no decimal digits"
 D ^DIR I $D(DUOUT)!$D(DTOUT) S ERR=1 Q
 I PRCP3=X Q
 I X'="@" S PRCP3=X
 I X="@" D EN^DDIOL("Deletions not allowed") G PGR
 K DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 D EN^XPAR("SYS","PRCPLO GREATER THAN RANGE",1,PRCP3,.PRCPZ)
 I PRCPZ=0 W ! D EN^DDIOL("Stock on Hand Report Greater Than Range successfully set to "_PRCP3)
 I PRCPZ'=0 W ! D EN^DDIOL("Error while trying to edit the Stock on Hand Report Greater Than Range:") W ! D EN^DDIOL($P(PRCPZ,"^",2))
 ;
 Q
 ;
PED ;Provide current value of and then prompt to modify the PRCPLO EXTRACT DIRECTORY parameter
 ;
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 S ERR=0
 S DIR(0)="FOr^1:245",DIR("A")="CLRS Extract Directory"
 S PRCP4=$$GET^XPAR("SYS","PRCPLO EXTRACT DIRECTORY",1,"Q")
 I PRCP4'="" S DIR("B")=PRCP4
 S DIR("?")="Please enter free text character string between 1 and 245 characters"
 D ^DIR I $D(DUOUT)!$D(DTOUT) S ERR=1 Q
 I PRCP4=X Q
 I X'="@" S PRCP4=X
 I X="@" D EN^DDIOL("Deletions not allowed") G PED
 K DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 D EN^XPAR("SYS","PRCPLO EXTRACT DIRECTORY",1,PRCP4,.PRCPV)
 I PRCP4="@" Q
 I PRCPV=0 W ! D EN^DDIOL("CLRS Extract Directory successfully set to "_PRCP4)
 I PRCPV'=0 W ! D EN^DDIOL("Error while trying to edit the CLRS Extract Directory:") W ! D EN^DDIOL($P(PRCPV,"^",2))
 ;
 Q
 ;
PAD ;Provide current value of and then prompt to modify the PRC CLRS ADDRESS parameter
 ;
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 S ERR=0
 S DIR(0)="FOr^1:245",DIR("A")="CLRS Address"
 S PRCP5=$$GET^XPAR("SYS","PRC CLRS ADDRESS",1,"Q")
 I PRCP5'="" S DIR("B")=PRCP5
 S DIR("?")="Please enter free text character string between 1 and 245 characters"
 D ^DIR I $D(DUOUT)!$D(DTOUT) S ERR=1 Q
 I PRCP5=X Q
 S PRCP5=X
 K DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 D EN^XPAR("SYS","PRC CLRS ADDRESS",1,PRCP5,.PRCPW)
 I PRCP5="@" D EN^DDIOL("  <PRC CLRS ADDRESS deleted>") Q
 I PRCPW=0 W ! D EN^DDIOL("CLRS Address successfully set to "_PRCP5)
 I PRCPW'=0 W ! D EN^DDIOL("Error while trying to edit the CLRS Address:") W ! D EN^DDIOL($P(PRCPW,"^",2))
 ;
 Q
 ;
POG ;Provide current value of and then prompt to modify the PRC CLRS OUTLOOK MAILGROUP parameter
 ;
 N DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 S ERR=0
 S DIR(0)="FOr^1:245",DIR("A")="CLRS Outlook Mail Group"
 S PRCP6=$$GET^XPAR("SYS","PRC CLRS OUTLOOK MAILGROUP",1,"Q")
 I PRCP6'="" S DIR("B")=PRCP6
 S DIR("?")="Please enter free text character string between 1 and 245 characters"
 D ^DIR I $D(DUOUT)!$D(DTOUT) S ERR=1 Q
 I PRCP6=X Q
 S PRCP6=X
 K DIR,DIROUT,DIRUT,DUOUT,DTOUT,X,Y
 D EN^XPAR("SYS","PRC CLRS OUTLOOK MAILGROUP",1,PRCP6,.PRCPU)
 I PRCP6="@" D EN^DDIOL("  <PRC CLRS OUTLOOK MAILGROUP deleted>") Q
 I PRCPU=0 W ! D EN^DDIOL("CLRS Outlook Mail Group successfully set to "_PRCP6)
 I PRCPU'=0 W ! D EN^DDIOL("Error while trying to edit the CLRS Outlook Mail Group:") W ! D EN^DDIOL($P(PRCPU,"^",2))
 ;
 Q
