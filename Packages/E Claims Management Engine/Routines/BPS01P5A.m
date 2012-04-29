BPS01P5A        ;BHAM ISC/BEE - Post-Install for BPS*1*5 (cont) ;13-DEC-06
        ;;1.0;E CLAIMS MGMT ENGINE;**5**;JUN 2004;Build 5;WorldVistA 30-Jan-08
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
        ; Called by the BPS*1.0*5 Post-Install routine BPS01P5.
        ;
        ; This routine will convert or delete the invalid usage of globals
        ;   ^BPSECX and ^BPSECP
        ; It will also delete several ECME files that are now obsolete
        ;
        ; ^BPSECX cleanup - Here are the nodes and what should be done
        ;    "BPSOSRX" is the processing queue - Convert to XTMP and delete
        ;    "R" is the BPS Report Master database (obsolete) and will be
        ;       deleted by BPSO1P5
        ;    "S" is the BPS Statistics database and should not be deleted
        ;    "POS", "BPSOSQ3", and $J were for HL7 packet creation.  They
        ;       do not need to be converted and can just be killed.
        ;
        ;
        ; ^BPSECP cleanup - Here are the nodes and what should be done
        ;    "CHECKTIM" - Used for queuing BPSOSQ1.  This is no longer
        ;       needed and can just be killed.
        ;    "LOG" - Convert to BPS Log file and then delete.
        ;
EN      ;
        ; Remove XTMP global used for logging errors
        K ^XTMP("BPS01P5A")
        ;
        ; First convert ^BPSECP("BPSOSRX") into XTMP and delete it
        M ^XTMP("BPS-PROC")=^BPSECP("BPSOSRX")
        K ^BPSECP("BPSOSRX")
        ; If the global has been created but the zero node is missing, set it
        I $D(^XTMP("BPS-PROC")),'$D(^XTMP("BPS-PROC",0)) D
        . N X,X1,X2
        . S X1=DT,X2=30 D C^%DTC
        . S ^XTMP("BPS-PROC",0)=X_U_DT_U_"ECME PROCESSING QUEUE"
        ;
        ; Second, kill off unneeded ^BPSECX nodes
        ; Note that we need to loop because of the $J nodes.
        N SUB
        S SUB=""
        F  S SUB=$O(^BPSECX(SUB)) Q:SUB=""  I SUB'="S",SUB'="RPT" K ^BPSECX(SUB)
        ;
        ; Third, kill ^BPSECP("CHECKTIM")
        K ^BPSECP("CHECKTIM")
        ;
        ; Fourth, convert ^BPSECP("LOG")
        ; Note that we are only converting the transaction log (pattern match .N1"."5N)
        ;   and purge logs (type=5).  Other communication logs are being deleted.
        N SLOT,TXTIEN,PURGE,LOGIEN,PDT
        N TXTIEN,TM,TMP,TXT,TXT1,TXT2,PDTM
        S SLOT=""
        F  S SLOT=$O(^BPSECP("LOG",SLOT)) Q:SLOT=""  D
        . ; Set PURGE equal to whether the SLOT if a Purge Log
        . S PURGE=$P(SLOT,".",2)=5
        . ; If not transaction log or purge log, delete it and go on
        . I SLOT'?.N1"."5N,'PURGE K ^BPSECP("LOG",SLOT) Q
        . ; Create/find LOG IEN
        . S LOGIEN=$$LOG(SLOT)
        . I LOGIEN=-1 Q
        . S PDT="",PDTM=""
        . I PURGE S PDT=$P(SLOT,".",1)
        . S TXTIEN=0 F  S TXTIEN=$O(^BPSECP("LOG",SLOT,TXTIEN)) Q:TXTIEN=""  D
        .. ; Get data
        .. S X=$G(^BPSECP("LOG",SLOT,TXTIEN))
        .. S TM=$P($$HTFM^XLFDT(+$H_","_$P(X,U,1)),".",2),TXT=$P(X,U,2),TXT1=$$UP(TXT)
        .. ; If it is a transaction log, get the purge date
        .. I 'PURGE D
        ... I TXT1["BEFORE SUBMIT OF CLAIM" S TMP=$P($P(TXT1," - ",2)," BEFORE",1) I TMP?1"30"5N S PDT=TMP
        ... I TXT1["BEFORE SUBMIT OF REVERSAL" S TMP=$P($P(TXT1," - ",2)," BEFORE",1) I TMP?1"30"5N S PDT=TMP
        ... I TXT1["START OF CLAIM" S X=$P($P(TXT1,"START OF CLAIM - ",2),"@"),PDT=$$CDT(X,PDT)
        ... I TXT1["LOG TIME STAMP" D
        .... S X=$P(TXT1,"LOG TIME STAMP",2)
        .... I $E(X,1)=" " S X=$E(X,2,999)
        .... S X=$P($P(X," ",1,2),"@",1),PDT=$$CDT(X,PDT)
        ... S TXT2=","_$E(TXT1,1,3)_","
        ... I ",JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC,"[TXT2 S X=$P($P(TXT1," ",1,2),"@",1),PDT=$$CDT(X,PDT)
        .. I PDT="" S ^XTMP("BPS01P5A",1,SLOT,TXTIEN)=TXT Q
        .. S PDTM=PDT_"."_TM
        .. D FILE1(LOGIEN,TXTIEN,PDTM,TXT)
        . I PDTM="" S PDTM=$$NOW^XLFDT(),^XTMP("BPS01P5A",2,SLOT)=PDTM
        . D FILE2(LOGIEN,PDTM)
        . K ^BPSECP("LOG",SLOT)
        ;
        ; If XTMP("BPS01P5A") global created, add top node with purge date
        I $D(^XTMP("BPS01P5A")) D
        . N X,X1,X2
        . S X1=DT,X2=60 D C^%DTC
        . S ^XTMP("BPS01P5A",0)=X_U_DT_U_"BPS Log Conversion"
        ;
        ; Kill the top node of ^BPSECP if that is all there is left
        I $D(^BPSECP("LOG"))=1 K ^BPSECP("LOG")
        Q
        ;
LOG(X)  ; Create or find slot in BPS LOG
        N DIC,DLAYGO,Y
        S DIC=9002313.12,DIC(0)="LBO",DLAYGO=DIC
        D ^DIC
        I Y=-1 S ^XTMP("BPS01P5A",3,X)=Y
        Q +Y
        ;
FILE1(LOGIEN,TXTIEN,PDTM,TXT)   ; Create multiple entry
        N FN,FDA,MSG
        S FN=9002313.1201
        S FDA(FN,"+1,"_LOGIEN_",",.01)=PDTM
        S FDA(FN,"+1,"_LOGIEN_",",1)=$TR($E(TXT,1,200),"^","~")
        D UPDATE^DIE("","FDA","","MSG")
        I $D(MSG) S ^XTMP("BPS01P5A",4,LOGIEN,TXTIEN)=PDTM_U_TXT M ^XTMP("BPS01P5A",4,LOGIEN,"MSG")=MSG
        Q
        ;
FILE2(LOGIEN,PDTM)      ; Update LAST UPDATE field with the last date
        N FDA,MSG,FN
        S FN=9002313.12
        S FDA(FN,LOGIEN_",",.02)=PDTM
        D FILE^DIE("","FDA","MSG")
        I $D(MSG) S ^XTMP("BPS01P5A",5,LOGIEN)=PDTM M ^XTMP("BPS01P5A",5,LOGIEN,"MSG")=MSG
        Q
        ;
CDT(X,PDT)      ; Convert external date to internal
        ; If date evaluates to -Y, use default date (PDT)
        N %DT,Y
        S %DT="" D ^%DT
        I Y=-1 S Y=PDT
        Q Y
        ;
UP(X)   ; Convert text to uppercase
        Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        ;
        ;DELETE OBSOLETE FILES
        ;  For BPSCOMB and BPSEI, we need to delete each node manually
        ;  to prevent global protection errors.
        ;
DEL     N DIU,X
        ;
        ;Turn global protection off (SACC Exemption has been granted to use $ZU)
        I $P(^%ZOSF("OS"),"^",2)=3 S X=$ZU(68,28,0)
        ;
        ;Remove BPS COMBINED INSURANCE (#9002313.1), which uses an unsubscripted global
        ;reference to store the data
        S DIU="^BPSCOMB(",DIU(0)="DS" D EN^DIU2
        ;
        ;Remove BPS INSURER (#9002313.4), which uses an unsubscripted global reference to store
        ;the data
        S DIU="^BPSEI(",DIU(0)="DS" D EN^DIU2
        ;
        ;Turn global protection back on
         I $P(^%ZOSF("OS"),"^",2)=3 S X=$ZU(68,28,1)
        ;
        ;BPS DATA INPUT (#9002313.51)
        S DIU="^BPS(9002313.51,",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS ORIGIN OF INPUT (#9002313.516)
        S DIU="^BPS(9002313.516,",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS DIALOUT (#9002313.55)
        S DIU="^BPS(9002313.55,",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS INPUT USER PREF (#9002313.515)
        S DIU="^BPS(9002313.515,",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS INSURANCE RULES (#9002313.94)
        S DIU="^BPSF(9002313.94,",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS PRICING TABLES (#9002313.53)
        S DIU="^BPS(9002313.53,",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS REPORT MASTER (#9002313.61)
        S DIU="^BPSECX(""RPT"",",DIU(0)="DS" D EN^DIU2
        ;
        ;BPS TRANSLATE (#9002313.81)
        S DIU="^BPSF(9002313.81,",DIU(0)="DS" D EN^DIU2
        ;
        K DIU,X
        ;
        Q
        ;
        ;BPS SETUP (#9002313.99)
99      N IEN
        ;
        S IEN=0 F  S IEN=$O(^BPS(9002313.99,IEN)) Q:'IEN  D
        .;
        .;'2' Node
        .K ^BPS(9002313.99,IEN,2)
        .;
        .;'BPSOS6*' Node
        .K ^BPS(9002313.99,IEN,"BPSOS6*")
        .;
        .;'BPSOSM1' Node
        .K ^BPS(9002313.99,IEN,"BPSOSM1")
        .;
        .;'BPSOSR1' Node
        .K ^BPS(9002313.99,IEN,"BPSOSR1")
        .;
        .;'BPSOSX' Node
        .K ^BPS(9002313.99,IEN,"BPSOSX")
        .;
        .;'A/R INTERFACE' Node
        .K ^BPS(9002313.99,IEN,"A/R INTERFACE")
        .;
        .;'BILLING' Node
        .K ^BPS(9002313.99,IEN,"BILLING")
        .;
        .;'BILLING - NEW' Node
        .K ^BPS(9002313.99,IEN,"BILLING - NEW")
        .;
        .;'BILLING LOG FILE' Node
        .K ^BPS(9002313.99,IEN,"BILLING LOG FILE")
        .;
        .;'CREATING A/R' Node
        .K ^BPS(9002313.99,IEN,"CREATING A/R")
        .;
        .;'DIAL-OUT DEFAULT' Node
        .K ^BPS(9002313.99,IEN,"DIAL-OUT DEFAULT")
        .;
        .;'EOB-SCREEN' Node
        .K ^BPS(9002313.99,IEN,"EOB-SCREEN")
        .;
        .;'FORMS - NCPDP' Node
        .K ^BPS(9002313.99,IEN,"FORMS - NCPDP")
        .;
        .;'FORMS - PREBILL' Node
        .K ^BPS(9002313.99,IEN,"FORMS - PREBILL")
        .;
        .;'INPUT' Node
        .K ^BPS(9002313.99,IEN,"INPUT")
        .;
        .;'INS' Node
        .K ^BPS(9002313.99,IEN,"INS")
        .;
        .;'INS BASE SCORES'
        .K ^BPS(9002313.99,IEN,"INS BASE SCORES")
        .;
        .;'INS RULES' Node
        .K ^BPS(9002313.99,IEN,"INS RULES")
        .;
        .;'NULL FILE' Node
        .K ^BPS(9002313.99,IEN,"NULL FILE")
        .;
        .;'OUTSIDE LINE' Node
        .K ^BPS(9002313.99,IEN,"OUTSIDE LINE")
        .;
        .;'POSTAGE' Node
        .K ^BPS(9002313.99,IEN,"POSTAGE")
        .;
        .;'RX A/R TYPE' Node
        .K ^BPS(9002313.99,IEN,"RX A/R TYPE")
        .;
        .;'RECEIPT' Node
        .K ^BPS(9002313.99,IEN,"RECEIPT")
        .;
        .;'SPECIAL' Node
        .K ^BPS(9002313.99,IEN,"SPECIAL")
        .;
        .;'STARTUP' Node
        .K ^BPS(9002313.99,IEN,"STARTUP")
        .;
        .;'UNBILLABLE NDC #' Node
        .K ^BPS(9002313.99,IEN,"UNBILLABLE NDC #")
        .;
        .;'UNBILLABLE DRUG NAME' Node
        .K ^BPS(9002313.99,IEN,"UNBILLABLE DRUG NAME")
        .;
        .;'UNBILLABLE OTC' Node
        .K ^BPS(9002313.99,IEN,"UNBILLABLE OTC")
        .;
        .;'WRITEOFF-SCREEN' Node
        .K ^BPS(9002313.99,IEN,"WRITEOFF-SCREEN")
        .;
        .;'WRITEOFF-SCREEN ARTYPE' Node
        .K ^BPS(9002313.99,IEN,"WRITEOFF-SCREEN ARTYPE")
        .;
        .;'WRITEOFF-SCREEN BATCH' Node
        .K ^BPS(9002313.99,IEN,"WRITEOFF-SCREEN BATCH")
        .;
        .;'WRITEOFF-SCREEN CLINIC' Node
        .K ^BPS(9002313.99,IEN,"WRITEOFF-SCREEN CLINIC")
        .;
        .;'WRITEOFF-SCREEN DIAG' Node
        .K ^BPS(9002313.99,IEN,"WRITEOFF-SCREEN DIAG")
        .;
        .;'WRITEOFF-SCREEN INSURER' Node
        .K ^BPS(9002313.99,IEN,"WRITEOFF-SCREEN INSURER")
        .;
        .;'WINNOW' Node
        .N X
        .S X=$P($G(^BPS(9002313.99,IEN,"WINNOW")),U)
        .I X'=0,X'=1 S X=$P($G(^BPS(9002313.99,IEN,"WINNOW TESTING")),U),X=$S(X=1:1,1:0)
        .S ^BPS(9002313.99,IEN,"WINNOW")=X_"^^365"
        .K X
        .;
        .;'WINNOW TESTING' Node
        .K ^BPS(9002313.99,IEN,"WINNOW TESTING")
        .;
        .;'WINNOW LOG' Node
        .K ^BPS(9002313.99,IEN,"WINNOW LOG")
        .;
        .;'WORKERS COMP' Node
        .K ^BPS(9002313.99,IEN,"WORKERS COMP")
        .;
        .;'WRITE OFF INSURER' Node
        .K ^BPS(9002313.99,IEN,"WRITE OFF INSURER")
        .;
        .;'WRITE OFF SELF PAY' Node
        .K ^BPS(9002313.99,IEN,"WRITE OFF SELF PAY")
        .;
        .;'NCPDP51' Node
        .K ^BPS(9002313.99,IEN,"NCPDP51")
        .;
        .;'WINNOW LOGS' Node
        .K ^BPS(9002313.99,IEN,"WINNOW LOGS")
        ;
        K IEN
        ;
        Q
