VWUTIL  ;WVEHR/Maury Pepper/Skip Ormsby- World VistA Utilities;9:05 AM  2 Aug 2011
        ;;1.0;WORLD VISTA;250001,250002;;Build 21
        ;
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
        ;
        Q
        ;*WVEHR - 250001*
Q(V,D)  ; Function to return $QUERY for variable V and direction D.
        ; Replacement for Reverse $Q Function
        ; 1/8/08 MLP
        ;This function can be called for $Query -- either forward or reverse.
        ;In place of $Q(V,D), use $$Q^ZDQ($NA(V),D)
        ;Note: the 2nd argument is optional.
        ;
        S D=+$G(D,1)
        Q:D=1 $Q(@V)         ;Forward $Q
        IF D'=-1 Q           ;Will cause error due to no argument.
        N S
TOP     IF $QL(V)=0 Q ""     ;done if unsubscripted
BKU     S S=$O(@V,-1)        ;backup to previous node on current level
        S V=$NA(@V,$QL(V)-1) ;remove last subscript
        IF S="" G DAT        ;go chk for data if backed up all the way
        S V=$NA(@V@(S))      ;add the subscript found when backing up.
        IF $D(@V)>9 S V=$NA(@V@("")) G BKU  ;if downpointer, descend and repeat
DAT     IF $D(@V)#2=1 Q V    ;if a data node, return with current name
        G TOP
        ;
        ;*WVEHR 250002*
DD2     ;Weston/SO Make certain Required Fields in Patient File NOT required
        ;06/30/2008
        ;Fields:
        ;SOCIAL SECURITY NUMBER(#.09)
        ;SERVICE CONNECTED?(#.301)
        ;TYPE(#391)
        ;VETERAN (Y/N)?(#1901)
        ;
        D DT^DICRW ;Make sure FM variables are set up
        F I="SOCIAL SECURITY NUMBER","SERVICE CONNECTED?","TYPE","VETERAN (Y/N)?" D
        .N FIELD S FIELD=+$O(^DD(2,"B",I,0)) Q:'FIELD  ;Get field number
        .N X S X=$P(^DD(2,FIELD,0),U,2) ;Get field properties
        .S X=$TR(X,"R","") ;Remove the 'R'equired flag
        .S $P(^DD(2,FIELD,0),U,2)=X ;Re-Set field properties
        .K ^DD(2,"RQ",FIELD) ;Kill off the ReQuired Xref
        .S ^DD(2,FIELD,"DT")=DT ;Set the date Last Edited
        .;
        .;Re-Compile any Input Templates
        .D
        ..N IEN S IEN=0
        ..F  S IEN=$O(^DIE("AF",2,FIELD,IEN)) Q:'IEN  D
        ...N X,Y,DMAX
        ...I '$D(^DIE(IEN,"ROU")) Q  ;Not compiled
        ...S X=^DIE(IEN,"ROU")
        ...I X="" Q  ;No routine specified
        ...S X=$P(X,U,2),Y=IEN,DMAX=$$ROUSIZE^DILF
        ...D EN^DIEZ
        ...Q
        ..Q
        .;
        .;Re-Compile any Print Templates
        .D
        ..N IEN S IEN=0
        ..F  S IEN=$O(^DIPT("AF",2,FIELD,IEN)) Q:'IEN  D
        ...N X,Y,DMAX
        ...I '$D(^DIPT(IEN,"ROU")) Q  ;Not compiled
        ...S X=^DIPT(IEN,"ROU")
        ...I X="" Q  ;No routine specified
        ...S X=$P(X,U,2),Y=IEN,DMAX=$$ROUSIZE^DILF
        ...D EN^DIPZ
        ..Q
        .Q
        Q
        ;
PMI     ;Remove PMI values from file #50.68
        N %I
        S %I=0 F  S %I=$O(^PSNDF(50.68,%I)) Q:%I'>0  S $P(^PSNDF(50.68,%I,1),"^",5,7)="^^"
        Q
        ;
POSTM   ;Multi-build clean up
        D DD2
        D PMI
        Q
AMA1    ;Display the AMA Copyright for 1 second
        N VW S VW=0,VW=+$O(^ICPT(VW))
        I 'VW Q  ;No CPT Codes
        N X W !,"CPT copyright AMA ",$E($$FMTE^XLFDT($$FMADD^XLFDT(DT,-365),7),1,4)," American Medical Association.   All rights reserved."
        R X#1:1
        Q
AMA10   ;Display the AMA Copyright for 10 seconds
        N VW S VW=0,VW=+$O(^ICPT(VW))
        I 'VW Q  ;No CPT Codes
        N X W !,"CPT copyright AMA ",$E($$FMTE^XLFDT($$FMADD^XLFDT(DT,-365),7),1,4)," American Medical Association.   All rights reserved."
        W !," Press any key to continue."
        R X#1:10
        Q
        ;
DGRP1   ;Called from VW^DGRP1
        N DGLABEL S DGLABEL="^ Given^Middle^Prefix^Suffix^Degree" ; labels
        N DGCOMP S DGCOMP=+$G(^DPT(DFN,"NAME"))_"," ; Name Components fd (1.01)
        I DGCOMP D GETS^DIQ(20,DGCOMP,"1:6",,"DGCOMP") ; Name Components file
        ; loads Family (Last) Name (1), Given (First) Name (2),
        ; Middle Name (3), Prefix (4), Suffix (5), and Degree (6)
        ; field groups 1 & 2 part 3: load aliases
        N DGCOUNT S DGCOUNT=0 ; how many aliases do we find
        N DGALIAS S DGALIAS=0 ; IEN of Alias subfile (1/2.01) of Patient fl (2)
        ;                       and array of aliases found
        S DGALIAS=0 F  D  Q:'DGALIAS
        . ;
        . S DGALIAS=$O(^DPT(DFN,.01,DGALIAS))
        . Q:'DGALIAS  ; out of alias subrecords
        . N DGNODE S DGNODE=$G(^DPT(DFN,.01,DGALIAS,0)) ; 0-node of subrecord
        . Q:'$L(DGNODE)  ; bad node
        . ;
        . S DGCOUNT=DGCOUNT+1 ; another valid alias
        . I DGCOUNT=6 S DGALIAS=0 Q  ; can't show > 5, need to know if 6 or >
        . ;
        . S DGALIAS(DGCOUNT)=$P(DGNODE,U) ; Alias fld (.01)
        . ;
        . N DGSSN S DGSSN=$P(DGNODE,U,2) ; Alias SSN fld (1)
        . I $L(DGSSN) D
        . . S DGSSN=" "_$E(DGSSN,1,3)_"-"_$E(DGSSN,4,5)_"-"_$E(DGSSN,6,10)
        . . ; incl leading space to separate from alias name
        . . ; incl 10 chars to allow for P of pseudo-SSNs
        . . S $E(DGALIAS(DGCOUNT),20)=DGSSN ; truncate alias name & append SSN
        . ;
        . S DGALIAS(DGCOUNT)=$E(DGALIAS(DGCOUNT),1,32) ; truncate alias
        ;
        I DGCOUNT=0 S DGALIAS(1)="< No alias entries on file >"
        I DGCOUNT=6 S DGALIAS(5)="< More alias entries on file >"
        K DGCOUNT
        ;
        ; field groups 1 & 2 part 4: show 1st name component, and IDs HRN & Sex
        W !?5,"Family: "
        W $E($G(DGCOMP(20,DGCOMP,1)),1,27)
        ;
        I "EI"[$G(DUZ("AG")),$G(DUZ(2)) D
        . N DGNODE S DGNODE=$G(^AUPNPAT(DFN,41,DUZ(2),0)) ; get 0-node for the
        . ; current Facility from the Health Record No. multiple field
        . ; (4101/9000001.41) for DFN in the IHS Patient file (9000001)
        . N DGHRN S DGHRN=$P(DGNODE,U,2) ; Health Record No. (.02)
        . W ?42," HRN: ",DGHRN
        ;
        D
        . N DGSEX S DGSEX=$P(DGRP(0),U,2) ; Sex fld (.02) of Patient file (2)
        . W ?61,"Sex: ",$S(DGSEX="M":"MALE",DGSEX="F":"FEMALE",1:"UNANSWERED")
        ;
        ; field groups 1 & 2 part 5: show remaining name components and aliases
        N DGCOUNT F DGCOUNT=2:1:6 D
        . W !?5,$P(DGLABEL,U,DGCOUNT),": "
        . N DGNAME S DGNAME=$G(DGCOMP(20,DGCOMP,DGCOUNT)) ; next name component
        . W $E(DGNAME,1,$S(DGCOUNT=2:23,1:27)) ; 1st line leaves room for "[2]"
        . I DGCOUNT=2 D  ; header for aliases
        . . W ?37 N DGRPW,Z S DGRPW=0,Z=2 D WW^DGRPV ; write [2], suppress LF
        . . W " Alias: "
        . W ?47,$G(DGALIAS(DGCOUNT-1)) ; show next alias
        . Q
        Q
        ;
