PSXBLD2 ;BIR/EJW-New warning label Data for Transmission ;10/26/04
 ;;2.0;CMOP;**54**;11 Apr 97;Build 6
 ;
 ;Reference to  ^PS(55,    supported by DBIA #2228
 ;Reference to WTEXT^PSSWRNA supported by DBIA #4444
NEWWARN ;
 N J,TEXT,W
 F J=1:1:5 S W=$P(WARN,",",J) Q:W=""  D
 .S TEXT=$$WTEXT^PSSWRNA(W) I TEXT'="" S MSG=MSG+1,PSXORD(MSG)="NTE|11|"_$P(RXY,"^")_"|ENG|"_W_"|"_TEXT
 I $P($G(^PS(55,DFN,"LAN")),"^",2)'=2 Q
 I '$P($G(^PS(55,DFN,"LAN")),"^") Q  ; DON'T SEND SPANISH WARNING LABELS UNLESS PATIENT ALSO HAS OTHER LANGUAGE PREFERENCE 
 ; SEND SPANISH WARNINGS ALSO
 F J=1:1:5 S W=$P(WARN,",",J) Q:W=""  D
 .S TEXT=$$WTEXT^PSSWRNA(W,2) I TEXT'="" S MSG=MSG+1,PSXORD(MSG)="NTE|11|"_$P(RXY,"^")_"|SPA|"_W_"|"_TEXT
 Q
