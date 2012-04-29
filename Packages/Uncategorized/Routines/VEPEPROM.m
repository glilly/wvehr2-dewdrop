VEPEPROM ;DAOU/DLF Prompts for where to print/send EHR prescriptions ; 4/12/05 11:42am
 ;;7.0;OUTPATIENT PHARMACY;**10,22,32,40,120,208**;DEC 1997;Build 1
VERS ;
 ;Reference to ^PS(59.7 supported by DBIA 694
 ;Reference to ^PSX(550 supported by DBIA 2230
 ;Reference to ^%ZIS supported by DBIA 3435
 ;
 Q
GETRX ;Daou/DLF;Get the prescription number (manual) 4/22/2005
 I '$D(PSOPAR) D ^PSOLSET
 R "Enter the prescription number: ",PSOERX:DTIME
 G LBL
RX(PSORX) ;Called entry point from Complete orders from OERR (PSONEW)
LBL ;Daou/MRM ;Define device PSOPRDEV and prompt for Where to Fax/Send;  4/2/2005
 S DIR("A")="Enter type of output device",DIR("A",1)="",DIR("A",2)=""
 S DIR("A",3)="     1 Label    - for immediate dispensing"
 S DIR("A",4)="     2 Printer  - print prescription"
 S DIR("A",5)="     3 Fax      - fax prescription to pharmacy"
 S DIR("A",6)=""
 S DIR(0)="N",DIR("?")="Enter 1,2, or 3" D ^DIR
 I "123"'[Y W !,"Invalid response, please enter 1, 2, or 3" G LBL
 S PSOPRDEV=$S(Y=1:"L",Y=2:"P",Y=3:"F",1:"L")
 Q
VERIFY(VEPETST) ;
 ;Verify that the Fax directory exists
 ;
 S FIL=$$GET1^DIQ(59,"1,",92001.3)
 S FIL=FIL_"\TEST.DAT"
 S %ZIS="",%ZIS("HFSNAME")=FIL,%ZIS("HFSMODE")="W",IOP="HFS",(XPDSIZ,XPDSIZA)=0,XPDSEQ=1
 D ^%ZIS
 I POP=1 W !!,"Fax directory does not exist - please define it or correct it before faxing" H 3 Q 1
 Q 0
