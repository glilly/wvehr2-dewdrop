GMRCHL7A        ;SLC/DCM,MA - Receive HL-7 Message from OERR ; 6/2/10 3:21pm
        ;;3.0;CONSULT/REQUEST TRACKING;**1,5,12,15,21,22,33,68**;DEC 27, 1997;Build 21
        ;
        ; This routine invokes IA #2849
        ;
URG(X)  ;Return Urgency give Z-code from HL-7 segment; see ORC+9
        S X=$S(X="S":"STAT",X="R":"ROUTINE",X="ZT":"TODAY",X="Z24":"WITHIN 24 HOURS",X="Z48":"WITHIN 48 HOURS",X="Z72":"WITHIN 72 HOURS",X="ZW":"WITHIN 1 WEEK",X="ZM":"WITHIN 1 MONTH",X="ZNA":"NEXT AVAILABLE",1:X)
        I $E(X,1)="Z" S X=$S(X="ZT":"TODAY",X="ZE":"EMERGENCY",1:"")
        Q X
        ;
ORC(GMRCORC)    ;Get fields from ORC segment and set into GMRC variables
        ;GMRCTRLC=ORC control code from HL7 Table 119
        ;GMRCURGI=priority/urgency     GMRCPLCR=who entered the order
        ;GMRCORNP=provider             GMRCNATO=nature of order
        ;GMRCAD=date of request        GMRCOCR=order request reason
        ;GMRCORFN=oe/rr file number    GMRCO=file 123 IEN - if not a new order
        ;GMRCS38=order status - taken from Table 38, HL7 standard
        S GMRCTRLC=$P(GMRCORC,SEP1,2),GMRCORFN=$P(GMRCORC,SEP1,3),GMRCORFN=$P($P(GMRCORFN,SEP2,1),";",1),GMRCAPP=$P($P(GMRCORC,SEP1,3),SEP2,2)
        S GMRCS38=$P(GMRCORC,SEP1,6),GMRCURGI=$P($P(GMRCORC,SEP1,8),SEP2,6),GMRCPLCR=$P(GMRCORC,SEP1,11),GMRCORNP=$P(GMRCORC,SEP1,13)
        I $L(GMRCURGI) S GMRCURGI="GMRCURGENCY - "_$$URG(GMRCURGI),GMRCURGI=$O(^ORD(101,"B",GMRCURGI,0))
        S GMRCO=+$P($P(GMRCORC,SEP1,4),SEP2,1)
        S GMRCODT=$P(GMRCORC,SEP1,16),GMRCAD=$$FMDATE^GMRCHL7(GMRCODT)
        S GMRCOCR=$P(GMRCORC,SEP1,17),GMRCNATO=$P(GMRCOCR,SEP2,5)
        Q
OBR(GMRCOBR)    ;Get fields from OBR segment and set into GMRC variables
        ;GMRCTYPE=GMRC consult or GMRC request  GMRCSS=To Service
        ;GMRCPLI=place of consultation          GMRCODT=observation date/time
        ;GMRCATN=person to alert (attention)    GMRCSTDT=status change date/time
        ;GMRCS123=results status (table 123)    GMRCINTR=results interpreter
        ;GMRCPRI=procedure from file ^ORD(101,  
        ;GMRCXMF=foreign consult service
        ;        a flag that tells the HL7 routine that
        ;        consults does not need to return CPRS a file
        ;        IEN for file 123. See routine ^GMRCXMF
        S GMRCPR=$P($P(GMRCOBR,SEP1,5),SEP2,6)
        S GMRCTYPE=$S(GMRCPR="99PRC":"P",1:"C")
        S GMRCPRI="",GMRCSS=""
        I GMRCPR="99PRC" D
        . S GMRCPRI=$P($P(GMRCOBR,SEP1,5),SEP2,4)
        . S GMRCPRI=$S(+GMRCPRI:GMRCPRI_";GMR(123.3,",1:"")
        . Q
        ;
        S GMRCOTXT=$P($P(GMRCOBR,SEP1,5),SEP2,5) ;consult type or service name
        S GMRCODT=$P(GMRCOBR,SEP1,7) I GMRCODT]"" S GMRCODT=$$FMDATE^GMRCHL7(GMRCODT)
        S GMRCPLI=$P(GMRCOBR,SEP1,19) I GMRCPLI]"" S GMRCPLI="GMRCPLACE - "_$S(GMRCPLI="OC":"ON CALL",GMRCPLI="B":"BEDSIDE",GMRCPLI="E":"EMERGENCY ROOM",1:GMRCPLI),GMRCPLI=$O(^ORD(101,"B",GMRCPLI,0))
        S GMRCATN=$P(GMRCOBR,SEP1,20),GMRCSTDT=$P(GMRCOBR,SEP1,23),GMRCSTDT=$$FMDATE^GMRCHL7(GMRCSTDT)
        S GMRCS123=$P(GMRCOBR,SEP1,26),GMRCINTR=$P(GMRCOBR,SEP1,33)
        Q
ZSV(GMRCZSV)    ;Get service from ZSV segment and set into GMRCSS
        S GMRCZSS=$P($P(GMRCZSV,SEP1,2),SEP2,4)
        I +$G(GMRCZSS) S GMRCSS=+$G(GMRCZSS) ;Set the service if ZSV provided
        I $L($P(GMRCZSV,"|",3)) S GMRCOTXT=$P(GMRCZSV,"|",3) ;consult type
        Q
OBX(GMRCOBX)    ;Get fields from OBX segment and set into GMRC variables
        ;GMRCVTYP=Value type from table 123 - i.e. TX(text), ST(string data),etc.
        ;GMRCOID=observation id identifying value in seg. 5
        ;GMRCVAL=observation value coded by segment 3
        ;GMRCPRDG=provisional diagnosis
        ;    free text or code^free text^I9C
        S GMRCMSG=MSG(GMRCOBX)
        S GMRCVTYP=$P(GMRCMSG,SEP1,3),GMRCOID=$P($P(GMRCMSG,SEP1,4),SEP2,2),GMRCVAL=$P(GMRCOID,SEP2,3)
        I GMRCOID="REASON FOR REQUEST" D
        .S GMRCRFQ(1)=$P(GMRCMSG,SEP1,6)
        .S LN=0 F  S LN=$O(MSG(GMRCOBX,LN)) Q:LN=""  S GMRCRFQ(LN+1)=MSG(GMRCOBX,LN)
        .Q
        I GMRCOID="PROVISIONAL DIAGNOSIS" D  Q
        . I GMRCVTYP="TX" D  Q
        .. S GMRCPRDG=$P(GMRCMSG,SEP1,6)
        .. S GMRCPRDG=$TR(GMRCPRDG,$C(9,10,13)," ") Q
        . I GMRCVTYP="CE" D  Q
        .. N PRDXSEG S PRDXSEG=$P(GMRCMSG,SEP1,6)
        .. S GMRCPRDG=$TR($P(PRDXSEG,"^",2),$C(9,10,13),"")_"("_$P(PRDXSEG,"^")_")"
        .. S GMRCPRCD=$P(PRDXSEG,"^")
        I GMRCOID["COMMENT" D
        .S GMRCCMT(1)=$P(GMRCMSG,SEP1,6)
        .S LN=0 F  S LN=$O(MSG(GMRCOBX,LN)) Q:LN=""  S GMRCCMT(LN+1)=MSG(GMRCOBX,LN)
        .Q
        K LN
        Q
EN(MSG) ;Entry point to routine
        ;MSG = local array which contains the HL-7 segments
        ;GMRCSEND=sending application   GMRCFAC=sending facility
        ;GMRCMTP=message type
        N DFN,GMRCACT,GMRCADD,GMRCFAC,GMRCMTP,GMRCPNM,GMRCO,GMRCOCR,GMRCORNP
        N GMRCORFN,GMRCPLCR,GMRCRB,GMRCSEND,GMRCSTS,GMRCTRLC,GMRCWARD,ORIFN
        N GMRCTRLC,GMRCAD,ORC,GMRCSBR,GMRCZSS,GMRCSS,GMRCOTXT,GMRCPRCD
        N GMRCREJ,GMRCRECV
        S GMRCMSG="",GMRCNOD=0 F  S GMRCNOD=$O(MSG(GMRCNOD)) Q:GMRCNOD=""  S GMRCMSG=MSG(GMRCNOD) I $E(GMRCMSG,1,3)="MSH" D INIT^GMRCHL7U(GMRCMSG) D  Q
        .S GMRCSEND=$P(GMRCMSG,SEP1,3),GMRCFAC=$P(GMRCMSG,SEP1,4)
        .S GMRCMTP=$P(GMRCMSG,SEP1,9),GMRCRECV=$P(GMRCMSG,SEP1,5)
        .Q
        I $G(GMRCRECV)'="CONSULTS" Q  ;not intended for Consults
        S GMRCMSG="",GMRCNOD=0
        F  S GMRCNOD=$O(MSG(GMRCNOD)) Q:GMRCNOD=""  S GMRCMSG=MSG(GMRCNOD) D
        .I $E(GMRCMSG,1,3)="PID" D PID^GMRCHL7U(GMRCMSG) Q
        .I $E(GMRCMSG,1,3)="PV1" D PV1^GMRCHL7U(GMRCMSG) Q
        .I $E(GMRCMSG,1,3)="ORC" D ORC(GMRCMSG) Q
        .I $E(GMRCMSG,1,3)="OBR" D OBR(GMRCMSG) Q
        .I $E(GMRCMSG,1,3)="ZSV" D ZSV(GMRCMSG) Q
        .I $E(GMRCMSG,1,3)="OBX" D OBX(GMRCNOD) Q
        .I $E(GMRCMSG,1,3)="NTE" D NTE^GMRCHL7U(.MSG,GMRCNOD,GMRCO,GMRCTRLC) Q
        .I $E(GMRCMSG,1,3)="ZXX" S GMRCOFN=+$P(GMRCMSG,SEP1,2) K MSG(GMRCNOD) Q
        .Q
        ;Note, ZXX is not used yet; planned for future sharing consults with foreign facilities.
        I '$D(GMRCTRLC) D EXIT^GMRCHL7U Q
        I GMRCTRLC="Z@" D CPRSPURG^GMRCPURG(+GMRCO),EXIT^GMRCHL7U Q
        I GMRCTRLC="NW" D NEW^GMRCHL7B(.GMRCREJ) D
        . I $G(GMRCO) D RETURN^GMRCHL7U(GMRCO,GMRCTRLC) Q
        . D REJECT^GMRCHL7U(.MSG,$G(GMRCREJ))
        I '$D(GMRCO) D EXIT^GMRCHL7U Q
        I $S(GMRCTRLC="CA":1,GMRCTRLC="DC":1,1:0) D DC^GMRCHL7B(GMRCO,GMRCTRLC),RETURN^GMRCHL7U(GMRCO,GMRCTRLC)
        I GMRCTRLC="NA" D RTN(GMRCORFN,GMRCO)
        I GMRCTRLC="XX" D MODIFY^GMRCHL7B ;Not currently returned by CPRS
        ; If consults sends an XX, CPRS returns an NA.
        D EXIT^GMRCHL7U
        Q
RTN(GMRCORN,DA) ;Put ^OR(100, ien for order into ^GMR(123, 
        S DIE="^GMR(123,",DR=".03////^S X=GMRCORN"
        L +^GMR(123,DA) D ^DIE L -^GMR(123,DA)
        K DIE,DR
        Q
