VAFHUTL9 ;ALB/RJS - UTILTIES FOR ADT/R HL7 INTERFACE - 6/15/95
 ;;5.3;Registration;**91**;Jun 06, 1996
 ;
 ;This Routine contains several utilities used by the PIMS
 ;HL7 ADT software 
 ;
SEG(SEGMENT,PIECE,CODE) ;Return segment from VADC array and kill node
 N VANODE,VADATA,VADONE K VADONE
 S VANODE=0
 F  S VANODE=$O(VADC(VANODE)) Q:VANODE=""!($D(VADONE))  D
 .S VADATA=VADC(VANODE)
 .I ($P(VADATA,HLFS,1)=SEGMENT)&($P($P(VADATA,HLFS,PIECE),VAC,1)=CODE) S VADONE=1 K VADC(VANODE)
 Q:$D(VADONE) $G(VADATA)
 Q ""
SEG1(SEGMENT,PIECE,CODE) ;Return segment from VADC array 
 N VANODE,VADATA,VADONE K VADONE
 S VANODE=0
 F  S VANODE=$O(VADC(VANODE)) Q:VANODE=""!($D(VADONE))  D
 .S VADATA=VADC(VANODE)
 .I ($P(VADATA,HLFS,1)=SEGMENT) S VADONE=1
 Q:$D(VADONE) $G(VADATA)
 Q ""
INITIZE(HLDA) ;Initialize VADC array with incoming message
 N VANODE S VANODE=0
 F  S VANODE=$O(^HL(772,HLDA,"IN",VANODE)) Q:VANODE'>0  D
 .S VADC(VANODE)=^HL(772,HLDA,"IN",VANODE,0)
 Q
INIT1 ;
 F I=1:1 X HLNEXT Q:HLQUIT'>0  S X(I)=HLNODE MERGE X(I)=HLNODE
 MERGE VADC=X
 Q
SSNDFN(SSN) ;Input ssn output DFN
 Q:$G(SSN)="" -1
 S DFN=$O(^DPT("SSN",+SSN,0))
 Q:$L(DFN) DFN
 S DFN=$O(^DPT("SSN",SSN,0))
 Q:$L(DFN) DFN
 Q -1
