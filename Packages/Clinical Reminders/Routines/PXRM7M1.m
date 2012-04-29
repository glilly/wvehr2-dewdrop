PXRM7M1 ;SLC/JVS HL7 PUT MESSAGE IN 772 FILE; 06/01/2007  15:26
        ;;2.0;CLINICAL REMINDERS;**6**;Feb 04, 2005;Build 123
        ;This routine will use the HL7 Package commands to gather the message
        ;into the file 772
        Q
EN(ID)  ;Entry Point
        ;
        S (PROTIEN,PXRM7,PXRM7R,PXRM77,PXRM7ID)=""
        S PROTIEN=$O(^ORD(101,"B","PXRM7 RECO SERVER",PROTIEN))
        S HL("EID")=PROTIEN
        D INIT^HLFNC2(PROTIEN,.PXRM7)
        S PXRM7("PID")="HI^D"
        S HLA("HLS",1)=PXRM77
        D GENERATE^HLMA(HL("EID"),"GM",1,.PXRM7R,.PXRM7ID,)
        D STORE^PXRM7API
        S ID=ZMID
        Q
