DGLBPID ;DJW,TOAD; Health Record Number Identifier ;5/1/07  20:26
        ;;5.3;Registration;**634**;Aug 13, 1993;Build 38
        ; Copyright (C) 2007 WorldVistA
        ;
        ; This program is free software; you can redistribute it and/or modify
        ; it under the terms of the GNU General Public License as published by
        ; the Free Software Foundation; either version 2 of the License, or
        ; (at your option) any later version.
        ;
        ; This program is distributed in the hope that it will be useful,
        ; but WITHOUT ANY WARRANTY; without even the implied warranty of
        ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ; GNU General Public License for more details.
        ;
        ; You should have received a copy of the GNU General Public License
        ; along with this program; if not, write to the Free Software
        ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
        ;'Modified' MAS Patient Look-up Check Cross-References June 1987
        Q
        ;
        ;
ID(DFN) ;GFT/VW  IA 10035
        N ID S ID=$P($G(^DPT(DFN,.36)),U,3) ;PRIMARY LONG ID
        I ID="" S ID=$$HRN(DFN)
        I ID="" S ID=$P($G(^DPT(DFN,0)),U,9) I ID]"" S ID=$E(ID,1,3)_"-"_$E(ID,4,5)_"-"_$E(ID,6,99)
        I ID="" D
        .N I F I=0:0 S I=$O(^AUPNPAT(DFN,41,I)) Q:'I  I $P($G(^(I,0)),U,5)="" S ID=$P($G(^(0)),U,2) I ID]"" S ID=ID_" ("_$P($G(^DIC(4,I,0)),U,5)_")" Q
        I ID="" S ID="`"_DFN
        Q ID
        ;
        ;
        ;
        ;
HRN(DFN)        ;LOOKUP HEALTH RECORD NUMBER
        I '$G(DUZ(2)) Q ""
        Q $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
        ;
        ;
GOTIDQ(DFN)     ;Do we have the needed number for this guy?
        N T S T=$$REQID(DFN)
        I T="SSN" Q $P(^DPT(DFN,0),U,9)]""
        I T="HRN" Q:'$G(DUZ(2)) 0 Q $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)]""
        Q 1
        ;
        ;
REQID(DFN)      ;WHICH IDENTIFICATION FORMAT IS REQUIRED?
        N TYPE S TYPE=""
        D:$G(DFN)
        .S TYPE=+$G(^DPT(DFN,.361)) I TYPE S TYPE=$P($G(^DIC(8,TYPE,0)),U,9) ;try PRIMARY ELIGIBILITY CODE
        .I TYPE="" S TYPE=+$G(^DPT(DFN,"TYPE")) I TYPE S TYPE=+$G(^DG(391,TYPE,8.2)) ;try patient TYPE
        I 'TYPE S TYPE=$G(DUZ("AG")),TYPE=$S(TYPE="V":1,1:2) ;or just assume it's HRN if not VA
        Q $P("SSN^HRN",U,TYPE)
        ;
        ;
IDCAP() ;Returns 3 characters: " ID" or "SSN"
        I $G(DUZ("AG"))="E" Q " ID"
        Q "SSN"
        ;
        ;
        ;
        ;
        ;
        ;
LONGID  ;Called by ^DIC(8.2,2,"LONG") (assumes DA(1) is DFN!)
        N INSTITU,DFN,DFNID,SSNID,IHSID D GETALL
        S X=$S($G(IHSID("L"))'?."-":IHSID("L"),$G(SSNID("L"))'?."-":SSNID("L"),$G(DFNID("L"))'?."-":DFNID("L"),1:"")
        ;I X="" W 1/0  ;some LONGID must exist for a patient, else ERROR!
        Q
        ;
        ;
SHORTID ;Called by ^DIC(8.2,2,"SHORT") (assumes DA(1) is DFN!)
        N INSTITU,DFN,DFNID,SSNID,IHSID D GETALL
        S X=$S($G(IHSID("S"))'?."-":IHSID("S"),$G(SSNID("S"))'?."-":SSNID("S"),$G(DFNID("S"))'?."-":DFNID("S"),1:"")
        ;I X="" W 1/0  ;some SHORTID must exist for a patient, else ERROR!
        Q
        ;
        ;
IHSID   ;
        ;given INSTITU (current institution #)
        ;get HEALTH RECORD NUMBER (Multiple 4101, 9000001.41) associated
        ;with the institution
        S IHSID=$P($G(^AUPNPAT(DFN,41,+INSTITU,0)),"^",2)
        I IHSID'="" D
        . S IHSID("L")=IHSID ; $J(IHSID,12) ; if we want to zero pad then $TR($J(IHSID("L"),12)," ",0)
        . S IHSID("S")=$TR(IHSID("L"),$TR(IHSID("L"),9876543210))
        . S IHSID("S")=$TR($J(IHSID("S"),4)," ",0)
        . S IHSID("S")=$E(IHSID("S"),$L(IHSID("S"))-3,$L(IHSID("S")))
        ;now return Health Record Number
        Q
DFNID   S DFN=DA(1) ; IEN in patient file, with default institution from
        ;kernel system parameters file as prefix.
        ;8989.3,217    DEFAULT INSTITUTION of #8989.3 -- KERNEL SYSTEM PARAMETERS FILE
        S INSTITU=$P($G(^XTV(8989.3,1,"XUS")),U,17)
        ;150.9  VISIT TRACKING PARAMETERS :: DEFAULT INSTITUTION:
        I INSTITU="",$P($G(^DIC(150.9,1,0)),U,4)'="" S INSTITU=$P(^(0),U,4)
        ; if we have a medical record number in IHS PATIENT, for this
        I INSTITU'="",$P($G(^DIC(4,+INSTITU,99)),U)'="" S INSTITU("STA#")=$P(^(99),U)
        ; now put INSTITUtion STATION NUMBER as prefix to DFN as "DFNID"
        S DFNID("S")="`"_DFN,DFNID("L")=999_"-`"_DFN S:$D(INSTITU("STA#"))#2 DFNID("L")=INSTITU("STA#")_"-`"_DFN
        Q
SSNID   ;
        ;code scarfed from ^DIC(8.2,1,"LONG") - retrieving the SSN
        N X
        S SSNID("L")="" I $D(DFN),$D(^DPT(DFN,0)) S X=$P(^(0),U,9),SSNID("L")=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10)
        S SSNID("S")=$P(SSNID("L"),"-",3)
        Q
GETALL  ;
        ;Utility Subroutine to Getall the variables
        D DFNID,IHSID,SSNID
        ;K DFNID,SSNID ; kill because HRN is "required"
        Q
        ;
ENALL   ;RE-INDEX PHONE NUMBER (KIDS POST-INSTALL DG*5.3*634)
        K ^DPT("AZVWVOE")
        N DIK S DIK="^DPT(",DIK(1)=".131^251000" D ENALL^DIK
        Q
