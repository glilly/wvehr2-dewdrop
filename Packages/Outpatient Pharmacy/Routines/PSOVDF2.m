PSOVDF2 ;BPOIFO/EL-OUTPATIENT PHARMACY (PRES, PREF, PPAR) HL7 MESSAGE ; 5/5/09 12:39pm
        ;;7.0;OUTPATIENT PHARMACY;**190,205,220,235,261,327**;DEC 1997;Build 4
        ;
        ; DBIAs:
        ; 2226-PS(51.2
        ; 221-PSDRUG
        ; 4248-VDEFEL
        ;
        Q
        ;
        ; Creates one of three Outpatient HL7 messages:
        ; RDE^O11^PRES, RDS^O13^PREF, or RDS^O13^PPAR
        ;
        ; Returns:
        ; Piece ^ 1 - "LM"-Local Array
        ; Piece ^ 2 - MSH segment, not set
        ; OUT - OUTPUT array includes HL7 message for every segment except MSH
        ;
        ; Message Body "MSH,PID,ORC1,RXE1,RXR1,FT1,OBX1,NTE1,ORC2,ORC3"
        ;
        ;
OUT     ; Output
        N WR K WR
        S L=1
        I $F(MSG,$C(13)) S MSG=$TR(MSG,$C(13)," ") ;Replace <CR> with space
        I $F(MSG,$C(10)) S MSG=$TR(MSG,$C(10)," ") ;Replace <LF> with space
OUT10   I $L(MSG)<247 S WR(L)=MSG
        I $L(MSG)>246 S WR(L)=$E(MSG,1,246),L=L+1,MSG=$E(MSG,247,99999) G OUT10
        ;
OUT20   ; VISTA HL7
        S X=""
        F I=1:1 S X=$G(WR(I)) Q:X=""  D
        .  I I=1 S OUT("HLS")=$G(OUT("HLS"))+1,OUT("HLS",OUT("HLS"))=X
        .  E  I I>1 S OUT("HLS",OUT("HLS"),I-1)=X
        Q
        ;
GET(GLOBAL,L,P) ; GET(GLOBAL,NODE,PIECE)
        I $G(GLOBAL(L))="" Q ""
        N RES
        S RES=$P(GLOBAL(L),U,P)
        Q RES
        ;
PUT(P)  ; Put in MSG
        I $G(VAL)="" Q
        S $P(MSG,SEPF,P)=VAL
        Q
        ;
PROCESS ;
ORC1    ; ORC ORIGINAL FILL
        S MSG="",CTR=0
        S VAL=$$GET(.GL,"OR1",2) I $G(VAL)'="" S VAL=$$REPL^PSOVDF1(VAL),VAL=VAL_SEPC_SRC_"_39.3" D PUT(2)
        S VAL=PSOVDFES_SEPC_SRC_"_.001" D PUT(3)
        S VAL="CM" D PUT(5)
        S (VAL,WR)="",WR=$$GET(.GL,2,2) I $G(WR)'="" D
        .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL^PSOVDF1(WR),$P(VAL,SEPC,4)=WR,$P(VAL,SEPC,7)="FILL"
        S WR=$$GET(.GL,2,6) I $G(WR)'="" D
        .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL^PSOVDF1(WR),$P(VAL,SEPC,5)=WR,$P(VAL,SEPC,7)=$P(VAL,SEPC,7)_"/EXPIRATION"
        I $G(VAL)'="" S CTR=CTR+1
        S (TP)="",WR=$$GET(.GL,0,13) I $G(WR)'="" D
        .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL^PSOVDF1(WR),$P(TP,SEPC,5)=WR,$P(TP,SEPC,7)="ISSUED" S CTR=CTR+1,$P(VAL,SEPR,CTR)=TP
        S (TP)="",WR=$$GET(.GL,2,5) I $G(WR)'="" D
        .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL^PSOVDF1(WR),$P(TP,SEPC,4)=WR,$P(TP,SEPC,7)="DISPENSED"
        ; (7~5|3-101)
        S WR=$$GET(.GL,3,1) I $G(WR)'="" D
        .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL^PSOVDF1(WR),$P(TP,SEPC,5)=WR,$P(TP,SEPC,7)=$P(TP,SEPC,7)_"/LAST DISPENSED"
        I $G(TP)'="" S CTR=CTR+1,$P(VAL,SEPR,CTR)=TP
        ; (7~5|4-26.1)
        S (TP)="",WR=$$GET(.GL,3,5) I $G(WR)'="" D
        .S WR=$$HLDATE^HLFNC(WR,"TS") I WR>0 S WR=$$REPL^PSOVDF1(WR),$P(TP,SEPC,5)=WR,$P(TP,SEPC,7)="CANCEL" S CTR=CTR+1,$P(VAL,SEPR,CTR)=TP
        I $G(VAL)'="" D PUT(7)
        ; (9-21)
        S VAL=$$GET(.GL,2,1),VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL^PSOVDF1(VAL) D PUT(9)
        ; (10-16)
        S VAL=$$GET(.GL,0,16) I $G(VAL)'="" S VAL=$$XCN200^VDEFEL(VAL) D PUT(10)
        ; (12|1-4)
        S WR="",VAL=$$GET(.GL,0,4) I $G(VAL)'="" D
        . S WR=$$XCN200^VDEFEL(VAL,"RE")
        ; (12|2-109)
        S TP="",VAL=$$GET(.GL,3,3) I $G(VAL)'="" D
        . S TP=$$XCN200^VDEFEL(VAL,"COSIGNER"),$P(WR,SEPR,2)=TP
        I $G(WR)'="" S VAL=WR D PUT(12)
        ; (13-5)
        S VAL=$$GET(.GL,0,5)
        I VAL'="" D ORC13^PSOVDF3,PUT(13)
        S (VAL,PSOVD59)=$$GET(.GL,2,9) I $G(VAL)'="" D
        .N PSONCOR,PSONCORP,PSOSINUM
        .S X=$G(^PS(59,VAL,0)),PSONCORP=$P($G(^("SAND")),"^",3)
        .S VAL=$P(X,U),(VAL,PSONCOR)=$$REPL^PSOVDF1(VAL) Q:VAL=""
        .S PSOSINUM=$P(X,U,6),PSOSINUM=$$REPL^PSOVDF1(PSOSINUM)
        .S VAL=PSOSINUM_SEPC_VAL_SEPC_SRC_"_20"
        .I PSONCORP'="" S PSONCORP=$$REPL^PSOVDF1(PSONCORP),VAL=VAL_SEPC_PSONCORP_SEPC_PSONCOR_SEPC_"NCPDP"
        .S PSOVDDIV(PSOVD59)=$G(VAL)
        .D PUT(17)
        S VAL=$G(PSOVDFIN) D PUT(21)
        N PSOVLV,PSOVAR,PSOVEN,DIC,DR,DA,DIQ D
        .I $D(GL(4)) D ORCCS^PSOVDF3
        .S DIC=52,DR="100",(DA,PSOVEN)=PSOVDFD0,DIQ="PSOVAR",DIQ(0)="IE" D EN^DIQ1
        .S VAL=$G(PSOVAR(52,PSOVEN,100,"I")) I VAL'="" D ORC25^PSOVDF3
        .I VAL="",'$D(VCMP) Q
        .S:VAL="" VAL=SEPC_SEPC
        .S VAL=VAL_$S($D(VCMP(0)):SEPC_VCMP(0),1:"") D PUT(25)
        I $G(MSG)="" G ORC1Q
        S $P(MSG,U)="RE"
        S MSG="ORC"_SEPF_MSG D OUT
ORC1Q   ; Q
        ;
RXE1    ; RXE ORIGINAL FILL
        S MSG=""
        ; (1~4-22)
        S (VAL,WR)="",CTR=0 I $D(GL(6)) K TEMP M TEMP=GL(6) S WR=$$DOSE^PSOVDF3(.TEMP) I $G(WR)'="" S VAL=WR
        D FINISH^PSOVDF3
        D PUT(1)
        N PSOV568,PSOVNAME,PSOVUIDN,PSOVLL,PSOVNND,PSOVNDF,PSONAM50,PSOVCMOP
        S (GIVECODE,P,PSOVNDF,PSOVDRUG,VAL,PSOVNND,PSOV568,PSOVNAME,PSOVLL,PSOVUIDN,PSOVCMOP,PSONAM50)="",PSOVDRUG=$$GET(.GL,0,6)
        I +$G(PSOVDRUG)'>0 G RXE1A
        S PSOVNND=$G(^PSDRUG(PSOVDRUG,"ND")),PSOV568=0
        I $P(PSOVNND,"^",10)'="" S PSOVCMOP=$$REPL^PSOVDF1($P(PSOVNND,"^",10))
        S PSOVNDF=$P(PSOVNND,"^",3),PSOVLL=$P(PSOVNND,"^") I +PSOVNDF>0 D
        .S PSOVUIDN=$$PROD0^PSNAPIS(+PSOVLL,+PSOVNDF),PSOVNAME=$P(PSOVUIDN,"^"),PSOVNAME=$$REPL^PSOVDF1(PSOVNAME) S PSOV568=$$GETVUID^XTID(50.68,,+PSOVNDF_",")
        I $P($G(PSOV568),"^")'=0 S PSOV568=$$REPL^PSOVDF1(PSOV568) S VAL=$G(PSOV568)_SEPC_$G(PSOVNAME)_SEPC_"99VA_52_6",GIVECODE=VAL G RXE1A
        S PSONAM50=$P($G(^PSDRUG(PSOVDRUG,0)),"^"),PSONAM50=$$REPL^PSOVDF1(PSONAM50) S VAL=SEPC_PSONAM50_SEPC_SRC_"_6",GIVECODE=VAL
        ; (2~4-API or 52_27 or 50_31)
RXE1A   S WR=""
        I $T(NDC^PSOHDR)]"" D
        .  S WR=$$NDC^PSOHDR(PSOVDFD0,0)
        E  S WR=$$GET(.GL,2,7) D
        .  I $G(WR)="",($G(PSOVDRUG)'="") S X=$G(^PSDRUG(PSOVDRUG,2)),WR=$P(X,U,4)
        I $G(WR)'="" S WR=$$REPL^PSOVDF1(WR),$P(VAL,SEPC,4)=WR,$P(VAL,SEPC,6)="NDC",DRCODE=VAL
        D PUT(2)
        N PSOLUN,PSOLUNI
        S (UNIT,VAL)="" I $G(PSOVNDF)'="" D
        .S PSOLUN=$$DFSU^PSNAPIS(PSOVLL,PSOVNDF)
        .I $G(PSOLUN)'="" N PSOUNTXT S PSOUNTXT=$P(PSOLUN,U,6),PSOUNTXT=$$REPL^PSOVDF1(PSOUNTXT),PSOLUNI=$P(PSOLUN,"^",5),PSOLUNI=$$REPL^PSOVDF1(PSOLUNI) S VAL=PSOLUNI_SEPC_PSOUNTXT_SEPC_SRC_"_6"
        I $G(VAL)="" S VAL="UNK"
        S UNIT=VAL D PUT(5)
        S VAL=0 D PUT(3)
        S VAL="" D RXE6^PSOVDF3 D PUT(6)
        S CTR=0,(VAL,WR)=""
        ; (7|3-113)
        I $D(GL(6)) K TEMP M TEMP=GL(6) S WR=$$NSET^PSOVDF3(.TEMP) I $G(WR)'="" S VAL=WR
        ;Don't piece out INS nodes, can possibly contain up-arrow from Provider Comments
        S WR=$G(GL("INS")) I $G(WR)'="" S WR=$$REPL^PSOVDF1(WR),CTR=CTR+1,WR=SEPC_WR_SEPC_SRC_"_114",$P(VAL,SEPR,CTR)=WR
        S WR=$$GET(.GL,"INSS",1) I $G(WR)'="" S WR=$$REPL^PSOVDF1(WR),CTR=CTR+1,WR=SEPC_WR_SEPC_SRC_"_114.1",$P(VAL,SEPR,CTR)=WR
        I $D(GL("INS1")) K TEMP M TEMP=GL("INS1") S WR=$$SSETX^PSOVDF3(.TEMP,SRC_"_115"),VAL=VAL_SEPR_WR
        D PUT(7)
        ; (8~6-11)
        S (WR,VAL)=""
        S WR=$$GET1^DIQ(52,PSOVDFD0_",",11,"","","PSOVERR") K PSOVERR I $G(WR)'="" S WR=$$REPL^PSOVDF1(WR),$P(VAL,SEPC,6)=WR D PUT(8)
        ; (10-7)
        S VAL=$$GET(.GL,0,7),VAL=$$REPL^PSOVDF1(VAL) D PUT(10)
        ; (12-9)
        S VAL=$$GET(.GL,0,9),VAL=$$REPL^PSOVDF1(VAL) D PUT(12)
        ; (14|1-23)
        S WR="",VAL=$$GET(.GL,2,3) I $G(VAL)'="" D
        . S WR=$$XCN200^VDEFEL(VAL,"PHARMACIST")
        ; (14|2-104)
        S TP="",VAL=$$GET(.GL,2,10) I $G(VAL)'="" D
        . S TP=$$XCN200^VDEFEL(VAL,"VERIFIER PHARM"),$P(WR,SEPR,2)=TP
        I $G(WR)'="" S VAL=WR D PUT(14)
        ; (15-.01)
        S VAL=$$GET(.GL,0,1),VAL=$$REPL^PSOVDF1(VAL) D PUT(15)
        ; (18-31)
        S VAL=$$GET(.GL,2,13) I $G(VAL)'="" S VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL^PSOVDF1(VAL) D PUT(18)
        ; (21|1-10.2=1 or 10)
        S VAL="" I '$D(GL("SIG")) G RXE1B
        I $P(GL("SIG"),U,2)=1 D
        . I $D(GL("SIG1")) K TEMP M TEMP=GL("SIG1") S VAL=$$SSETX^PSOVDF3(.TEMP,SRC_"_10.2")
        E  S VAL=$$GET(.GL,"SIG",1) I $G(VAL)'="" S VAL=$$REPL^PSOVDF1(VAL),VAL=VAL_SEPC_SEPC_SRC_"_10"
        D PUT(21)
RXE1B   ; (22-8)
        S VAL=$$GET(.GL,0,8) I $G(VAL)'="" S VAL="D"_VAL,VAL=$$REPL^PSOVDF1(VAL) D PUT(22)
        S WR="",VAL=$$GET(.GL,"TN",1)
        I $G(VAL)'="" S VAL=$$REPL^PSOVDF1(VAL),WR=VAL_SEPC_SEPC_SRC_"_6.5"
        D RXE1OF31^PSOVDF3,PUT(31)
        ;
        I $G(MSG)="" G RXE1Q
        S MSG="RXE"_SEPF_MSG D OUT
RXE1Q   ; Q
        ;
RXR1    ; RXR ORIGINAL FILL
        S MSG=""
        I '$D(GL(6)) G RXR1Q
        N PSOVRTE,PSORTX
        K TEMP M TEMP=GL(6)
        S PSORTX="",PSOVDFD1=0
RXR1A   S PSOVDFD1=$O(TEMP(PSOVDFD1)) G RXR1B:'PSOVDFD1
        S PSORTX=$P($G(TEMP(PSOVDFD1,0)),U,7)
        I $G(PSORTX)="" G RXR1A
        I '$D(^PS(51.2,PSORTX,0)) G RXR1A
        S PSOVRTE=$P(^PS(51.2,PSORTX,0),U),PSOVRTE=$$REPL^PSOVDF1(PSOVRTE),PSORTX=$$REPL^PSOVDF1(PSORTX)
        S VAL=PSORTX_SEPC_PSOVRTE_SEPC_HLINST_"_52.0113_6"
        I $G(MSG)'="" S MSG=MSG_SEPR_VAL
        E  S MSG=VAL
        G RXR1A
RXR1B   I $G(MSG)="" G RXR1Q
        S MSG="RXR"_SEPF_MSG D OUT
RXR1Q   ; Q
        ;
FT1     ;FT1 ORIGINAL FILL
        S (MSG)=""
        ; (4-22)
        S VAL=$$GET(.GL,2,2)
        I $G(VAL)'="" S VAL=$$HLDATE^HLFNC(VAL,"TS") I VAL>0 S VAL=$$REPL^PSOVDF1(VAL) D PUT(4)
        S VAL="CG" D PUT(6)
        S (VAL,VFT7)="" D FT1A7^PSOVDF3,PUT(7)
        ; (12-17)
        S VAL=$$GET(.GL,0,17),VAL=$$REPL^PSOVDF1(VAL) D PUT(12)
        ; (18-3)
        S TP="",TP=$$GET(.GL,0,3)
        I $G(TP)'="" S VAL=$P($G(^PS(53,TP,0)),U,2),VAL=$$REPL^PSOVDF1(VAL) D PUT(18)
        S VAL=$$GET(.GL,"OR1",5)
        I $G(VAL)'="" S VAL=$$XCN200^VDEFEL(VAL,SRC_"_38") D PUT(20)
        I $G(MSG)="" G FT1Q
        S (VAL,CTR)=1 D PUT(1)
        S MSG="FT1"_SEPF_MSG D OUT
FT1Q    ; 
        ;patch 261 - new FT1 seg seq 2 for original
        D FT1S2^PSOVDF3
        ;
OBX1    ; OBX ORIGINAL FILL
        S CTR=0
        F FIELD=41,42,116,117,118,119,120,121,201 D OBXLP
        G OBX1B
        ;
OBXLP   ;
        S MSG=""
        N DIC,DR,DA,DIQ,PSOOVAR,PSOOVEN
        S DIC=52,DR=FIELD,(DA,PSOOVEN)=PSOVDFD0,DIQ="PSOOVAR",DIQ(0)="IE" D EN^DIQ1 S VAL=$G(PSOOVAR(52,PSOOVEN,FIELD,"I"))
        I $G(VAL)="" Q
        N PSOOVALE S PSOOVALE=$G(PSOOVAR(52,PSOOVEN,FIELD,"E")),PSOOVALE=$$REPL^PSOVDF1(PSOOVALE)
        N PSOVLVU D
        .S PSOVLVU=$$GETVUID^XTID(52,FIELD,VAL) I $P($G(PSOVLVU),"^")'=0 S VAL=$$REPL^PSOVDF1(PSOVLVU)_SEPC_$G(PSOOVALE)_SEPC_"99VA_52_"_FIELD D PUT(5) Q
        .S VAL=$$REPL^PSOVDF1(VAL),VAL=VAL_SEPC_$G(PSOOVALE)_SEPC_SRC_"_"_FIELD D PUT(5)
        S CTR=CTR+1,VAL=CTR D PUT(1)
        S VAL="CE" D PUT(2)
        N DD D FIELD^DID(52,FIELD,"","LABEL","DD","ERR")
        S VAL=$G(DD("LABEL")),VAL=$$REPL^PSOVDF1(VAL) D PUT(3)
        S VAL="F" D PUT(11)
        S MSG="OBX"_SEPF_MSG D OUT
        Q
        ;
OBX1B   ;
        S MSG=""
        ; (5-301)
        S VAL=$$GET(.GL,"SAND",1)
        I $G(VAL)'="" D CLOZ^PSOVDF3
        ;
OBX1C   ;
        S MSG=""
        ; (5-302)
        S VAL=$$GET(.GL,"SAND",2)
        I $G(VAL)'="" D WBC^PSOVDF3
        ;
NTE1    ;
        D REM^PSOVDF3
        ;
NTE1B   ;
        D PRC^PSOVDF3
        ;
NTE1C   ;
        D DEL^PSOVDF3
NTE1Q   Q
