VEQVIT  ; - Outgoing temperature readings ; 6/17/11 2:37pm
CHOOSE  ; entry point from option;;;;;Build 4
        N START,END,VITAL,NOW
        ; Choose vital reading
        S DIC=120.51,DIC("0")="AEM" D ^DIC Q:+Y<1  S VITAL=+Y
        D NOW^%DTC S NOW=%
        ; Choose start date/time
        S %DT="AERX",%DT("A")="Enter Start Date/time: ",%DT(0)=-NOW D ^%DT Q:Y<0  S START=Y
END     ; Choose end date/time
        S %DT="AERX",%DT("A")="Enter End Date/time: ",%DT(0)=-NOW D ^%DT Q:Y<0  S END=Y
        I START'<END W !,"Start date/time should be less than End date/time." G END
        ; If start date/time < end date/time, send all the vital readings
        I START<END D VITALSEND(VITAL,START,END) W !,"Vital readings generated successfully."
        Q
VITALSEND(VITAL,START,END)      ;
        N FLD,COM,SERVER,HL,HLA,HLERR,HLRST,DATE,IEN
        S SERVER="VEQ VITALS ORU R01 SERVER"
        D INIT^HLFNC2(SERVER,.HL)
        I $G(HLECH)="" N HLECH S HLECH="|"
        I $G(HLFS)="" N HLFS S HLFS="^"
        I $D(HL)'>1 W "ERROR setting up the HL7 PROTOCOLS" Q
        S DATE=START-.000001 F  S DATE=$O(^GMR(120.5,"B",DATE)) Q:(+DATE=0)!(+DATE>END)  D
        . S IEN="" F  S IEN=$O(^GMR(120.5,"B",DATE,IEN)) Q:+IEN=0  D
        . . I $P(^SC($P(^GMR(120.5,IEN,0),U,5),0),U,3)="C"&($P(^GMR(120.5,IEN,0),U,3)=VITAL) D MSG(IEN)
        Q
MSG(IEN)        ;Create the HL7 message for an unsolicited result and send it
        S HLA("HLS",1)=$$PID($P(^GMR(120.5,IEN,0),U,2))
        S HLA("HLS",2)=$$OBR(IEN)
        S HLA("HLS",3)=$$OBX(IEN)
        D:HLA("HLS",3)'="" SEND
        Q
        ;
PID(DFN)        ;Create an PID message
        N VAFPID,HLNAME,VAFSTR
        I $G(HLQ)="" N HLQ S HLQ=""
        I '$D(^DPT(+DFN)) Q ""
        S VAFSTR="2,3,4,5,6,7,8,10,11,12,13,14,19,"
        S VAFPID=$$EN^VAFHLPID(+DFN,VAFSTR) S:$P(VAFPID,HLFS,11) $P(VAFPID,HLFS,11)=$E($G(^DIC(10,+$O(^DIC(10,"C",$P(VAFPID,HLFS,11),0)),0))) ;RACE
        F VAFSTR=5,7,13 I $P(VAFPID,HLFS,VAFSTR)="""""" S $P(VAFPID,HLFS,VAFSTR)="" ;GET RID OF DOUBLE QUOTES(?)
        S $P(VAFPID,HLFS,2)=1
        Q VAFPID
OBR(IEN)        ;Create an OBR message
        N DATE,OBR,ODTE
        S CS=$E(HLECH,1)
        S $P(OBR,HLFS,1)="OBR"
        S $P(OBR,HLFS,2)=1
        S $P(OBR,HLFS,4)="GMRV"_IEN
        S $P(OBR,HLFS,5)=CS_CS_CS_"120.5"_CS_"VITAL MEASURMENT"_CS_"L"
        S ODTE=$P($G(^GMR(120.5,IEN,0)),U,1),ODTE=$$HL7DATE(ODTE)
        S $P(OBR,HLFS,8)=ODTE
        Q OBR
OBX(IEN)        ;Create the OBX message
        N OBX,DIC,DR,DA,DIQ,PROV,CS
        S OBX="",CS=$E(HLECH,1)
        I $D(^GMR(120.5,IEN,2)) Q OBX
        S $P(OBX,HLFS,1)="OBX"
        S $P(OBX,HLFS,2)=1
        S $P(OBX,HLFS,3)="ST"
        S $P(OBX,HLFS,4)=$$GET1^DIQ(120.5,IEN,.03,"E","","")
        S $P(OBX,HLFS,6)=$$GET1^DIQ(120.5,IEN,1.2,"E","","")
        S $P(OBX,HLFS,7)="" ;UNIT ;???????
        S $P(OBX,HLFS,12)="F"
        S PROV=$$GET1^DIQ(120.5,IEN,.06,"I","","")
        S $P(OBX,HLFS,17)=PROV_CS_$P($P(^VA(200,PROV,0),U,1),",")_CS_$P($P(^VA(200,PROV,0),U,1),",",2)
        Q OBX
SEND    ;Send the message
        I $D(HL)=1 D
        .S HLERR(1)=HL
        I $D(HL)>1,$D(HLA("HLS")) D
        .D GENERATE^HLMA(SERVER,"LM",1,.HLRST)
        .I +HLRST>0 D
        ..D OPEN^%ZISH("FILE1",$P($G(^XTV(8989.3,1,"DEV")),U,1),"vitals.txt","A") I POP W "Could not open HFS file "_$P($G(^XTV(8989.3,1,"DEV")),U,1)_"vitals.txt" Q   ;open HFS file in append mode
        ..U IO W !,$G(HLHDR(1))
        ..S INDEX=0 F  S INDEX=$O(HLA("HLS",INDEX)) Q:+INDEX=0  W !,HLA("HLS",INDEX)
        ..D CLOSE^%ZISH("FILE1")
        Q
HL7DATE(DATE,UP)        ; -- FM -> HL7 format
        S DATE=$P($$FMTHL7^XLFDT(DATE),"-")  ;TAKE OFF '-500'
        I $G(UP)]"",$E(DATE,9,99)?1.N S DATE=$E(DATE,1,8)_UP_$E($E(DATE,9,13)_"00000",1,6)
        Q DATE
