        ;;9:08 AM  20 Jun 2011
VWUTIL  ;WVEHR/Maury Pepper/Skip Ormsby- World VistA Utilities;11:37 AM  13 Apr 2011;;;;Build 6
        ;;1.0;WORLD VISTA;250001,250002;;Build 1
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
REGMU   ; Changes to Patient Registration for MU
        N X S X=+$O(^DIE("B","VW LOCAL REGISTRATION TEMPLATE",0)) Q:'X
        N DA,DIE,DR,DIC,DIQ
        S DA=DFN,DIE="^DPT(",DR="[VW LOCAL REGISTRATION TEMPLATE]"
        D ^DIE
        Q
