EAS1071C        ;ALB/PJH - ESR and HEC Messaging ; 11/27/07 3:02pm
        ;;1.0;ENROLLMENT APPLICATION SYSTEM;**71**;15-MAR-01;Build 18
        ;
LINK    ;Link QRY Z10/Z11 protocols to shared servers
        N ERROR,FILE,IEN101,LINE,LNCNT,RETURN,SIEN101,SNAM
        S LNCNT=1
        F  S LINE=$T(PROTDAT1+LNCNT) Q:$P(LINE,";",3)="END"  D  Q:STOP
        .S NAM=PREFHEC_$P(LINE,";",3)_" SERVER"
        .S IEN101=$O(^ORD(101,"B",NAM,0))
        .I +IEN101=0 D  Q
        ..S ERROR="IEN OF RECORD TO BE UPDATED NOT FOUND"
        ..S RETURN=-1_"^"_ERROR
        ..D ABORT2^EAS1071A(RETURN,"Event Driver:"_NAM)
        .;
        .;Client Protocol
        .S SNAM=@("PREF"_SYS)
        .S SNAM=SNAM_$P(LINE,";",3)_" CLIENT"
        .S SIEN101=$O(^ORD(101,"B",SNAM,0))
        .I +SIEN101=0 D  Q
        ..S ERROR="IEN OF RECORD TO BE UPDATED NOT FOUND"
        ..S RETURN=-1_"^"_ERROR
        ..D ABORT2^EAS1071A(RETURN,"Subscriber:"_SNAM)
        .;Skip if already present
        .I $D(^ORD(101,IEN101,775,"B",SIEN101)) D  Q
        ..D WARN^EAS1071A(NAM,SNAM)
        ..S LNCNT=LNCNT+1
        .;Add subscriber to event driver
        .S RETURN=$$SUBSCR^EAS1071A(IEN101,SIEN101)
        .I +RETURN<0 D ABORT2^EAS1071A(RETURN,"driver with Subscriber:"_SNAM) Q
        .S LNCNT=LNCNT+1
        Q
        ;
UNLINK(PREF)    ;Remove Z10/Z11 client subscriber protocols from shared servers
        F LCT=1:1 S LINE=$T(PROTDAT1+LCT) Q:$P(LINE,";",3)="END"  D  Q:STOP
        .S NAM=PREF_$P(LINE,";",3)_" CLIENT"
        .S SIEN101=$O(^ORD(101,"B",NAM,0))
        .I +SIEN101=0 D  Q
        ..S ERROR="IEN OF RECORD TO BE UPDATED NOT FOUND"
        ..S RETURN=-1_"^"_ERROR
        ..D ABORT2^EAS1071A(RETURN,"Event Driver:"_NAM)
        .;If this is a SUBSCRIBER remove from SERVER
        .I $O(^ORD(101,"AB",SIEN101,0)) D REMOVE^EAS1071A(SIEN101,NAM)
        Q
        ;
PROTDAT1        ;
        ;;QRY-Z10
        ;;QRY-Z11
        ;;END
        ;
SOR(PREF,PREFHEC)       ;Check if SOR
        N IENC,IENS,NAMC,NAMS
        S NAMS=PREFHEC_"QRY-Z10 SERVER"
        ;get server ien
        S IENS=$O(^ORD(101,"B",NAMS,0)) Q:'IENS 0
        ;check subscriber protocols
        S IENC=+$G(^ORD(101,IENS,775,1,0)) Q:'IENC 0
        ;Check subscriber if is for this system
        I $P($G(^ORD(101,IENC,0)),U)[PREF Q 1
        ;
        Q 0
        ;
Z07(PREF,PREFHEC)       ;Check if Z07 messaging is set up
        N IENC,IENS,FOUND,NAMC,NAMS
        S NAMC=PREF_"ORU-Z07 CLIENT",NAMS=PREFHEC_"ORU-Z07 SERVER"
        ;get server ien
        S IENS=$O(^ORD(101,"B",NAMS,0)) Q:'IENS 0
        ;check subscriber protocols
        S IENC=0,FOUND=0
        F  S IENC=$O(^ORD(101,IENS,775,"B",IENC)) Q:'IENC  D  Q:FOUND
        .;Check subscriber if is for this system
        .S:$P($G(^ORD(101,IENC,0)),U)=NAMC FOUND=1
        ;
        Q FOUND
