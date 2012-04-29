DGRP1   ;ALB/MRL,ERC,BAJ - DEMOGRAPHIC DATA ;10:55 AM  3 Jan 2010
        ;;5.3;Registration;**109,161,506,244,546,570,629,638,649,700,653,688,634**;Aug 13, 1993;Build 38;WorldVistA 30-June-08
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
        ;
EN      ;
        S (DGRPS,DGRPW)=1 D H^DGRPU F I=0,.11,.121,.122,.13,.15,.24,57,"SSN" S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
        I $P(DGRP(.15),"^",2)]"" S Z="APPLICANT IS LISTED AS 'INELIGIBLE' FOR TREATMENT!",DGRPCM=1 D WW^DGRPV S DGRPCM=0
        ;I $P(DGRP(.15),"^",3)]"" S Z="APPLICANT IS LISTED AS 'MISSING'.  NOTIFY APPROPRIATE PERSONNEL!",DGRPCM=1 D WW^DGRPV S DGRPCM=0
        ;Begin WorldVistA Change ;DG*5.3*634
        I $G(DUZ("AG"))="E" D
        . W !?58,"Reg Dt: ",$$FMTE^XLFDT($P(DGRP(0),U,16),"2D")
        ;End WorldVistA Change
        ;Retrieve SSN Verification status DG*5.3*688 BAJ 11/22/2005
        N SSNV D GETSTAT(.SSNV)
        W ! S Z=1 D WW^DGRPV W "    Name: " S Z=$P(DGRP(0),"^",1),Z1=31 D WW1^DGRPV
        ;Display SSN and SSN Verification status DG*5.3*688 BAJ 11/22/2005
        W "SS: " S X=$P(DGRP(0),"^",9),Z=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10),Z1=13 D WW1^DGRPV W SSNV
        W ! S Z="",Z1=8 D WW1^DGRPV S Y=$P(DGRP(0),"^",3) X ^DD("DD") W "DOB: ",Y
        ;add Pseuso SSN Reason - DG*5.3*653, ERC
        I $P(DGRP(0),U,9)["P" D
        . N DGSPACE
        . S DGSPACE=10-$L(Y) ;adjust to maintain spacing on screen
        . S Z1=12+DGSPACE D WW1^DGRPV W "PSSN Reason: "
        . I $P(DGRP(0),U,9)["P" D
        . . N DGREAS D SSNREAS(.DGREAS)
        . . Q:$G(DGREAS)']""
        . . W DGREAS
        ;Begin WorldVistA Change ;DG*5.3*634
        ;D GETNCAL  ;Display name component, sex, and alias information
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
        ;End WorldVistA Change
        S Z=3,DGRPX=DGRP(0) D WW^DGRPV W " Remarks: ",$S($P(DGRPX,"^",10)]"":$E($P(DGRPX,"^",10),1,65),1:"NO REMARKS ENTERED FOR THIS PATIENT") S DGAD=.11,(DGA1,DGA2)=1 D A^DGRPU I $P(DGRP(.121),"^",9)="Y" S DGAD=.121,DGA1=1,DGA2=2 D A^DGRPU
        S Z=4 D WW^DGRPV W " Permanent Address: " S Z=" ",Z1=17
        D WW1^DGRPV S Z=5,DGRPW=0 D WW^DGRPV W " Temporary Address: "
        W !?9
        S Z1=39,Z=$S($D(DGA(1)):DGA(1),1:"NONE ON FILE") D WW1^DGRPV W $S($D(DGA(2)):DGA(2),1:"NO TEMPORARY ADDRESS")
        ; loop through DGA array beginning with DGA(2) and print data at ?9 (odds) and ?48 (evens)
        S I=2 F I1=0:0 S I=$O(DGA(I)) Q:I=""  W:(I#2)!($X>50) !?9 W:'(I#2) ?48 W DGA(I)
        D COUNTY(.DGRP)  ; print County if applicable
        W !?4,"Phone: ",$S($P(DGRP(.13),U,1)]"":$P(DGRP(.13),U,1),1:DGRPU),?44,"Phone: ",$S($P(DGRP(.121),U,9)'="Y":"NOT APPLICABLE",$P(DGRP(.121),U,10)]"":$P(DGRP(.121),U,10),1:DGRPU)
        S X="NOT APPLICABLE" I $P(DGRP(.121),U,9)="Y" S Y=$P(DGRP(.121),U,7) X:Y]"" ^DD("DD") S X=$S(Y]"":Y,1:DGRPU)_"-",Y=$P(DGRP(.121),U,8) X:Y]"" ^DD("DD") S X=X_$S(Y]"":Y,1:DGRPU)
        W !?3,"Office: ",$S($P(DGRP(.13),U,2)]"":$P(DGRP(.13),U,2),1:DGRPU),?42,"From/To: ",X
        ;Begin WorldVistA Change ;DG*5.3*634
        I $G(DUZ("AG"))="E" D
        . W !?1,"Alt Ph: ",$P($G(^DPT(DFN,.13)),U,4)
        ;End WorldVistA Change
        W !?1,"Bad Addr: ",$$EXTERNAL^DILFD(2,.121,"",$P(DGRP(.11),U,16))
        ;
        ; ***  Additional displays added for Pre-Registration
        I $G(DGPRFLG)=1 D
        . W !
        . N I,MIS1,X,X1,SA1,TP1,X2,X3,ES1
        . I $D(^DIA(2,"B",DFN)) S X="" F I=1:1 S X=$O(^DIA(2,"B",DFN,X)) Q:X<1  I $P(^DIA(2,X,0),U,3)=.05 S MIS1=$P(^DIA(2,X,0),U,2)
        . W:$D(MIS1)>0 !," [MARITAL STATUS CHANGED:] "_$$FMTE^XLFDT(MIS1,"5D")
        . I $D(^DIA(2,"B",DFN)) S X1="" F I=1:1 S X1=$O(^DIA(2,"B",DFN,X1)) Q:X1<1  S:$P(^DIA(2,X1,0),U,3)=.111 SA1=$P(^DIA(2,X1,0),U,2)
        . W:$D(SA1)>0 !," [STREET ADDRESS LAST CHANGED:] "_$$FMTE^XLFDT(SA1,"5D")
        . I $D(^DIA(2,"B",DFN)) S X2="" F I=1:1 S X2=$O(^DIA(2,"B",DFN,X2)) Q:X2<1  S:$P(^DIA(2,X2,0),U,3)=.131 TP1=$P(^DIA(2,X2,0),U,2)
        . W:$D(TP1)>0 !," [HOME PHONE NUMBER CHANGED:] "_$$FMTE^XLFDT(TP1,"5D")
        . I $D(^DIA(2,"B",DFN)) S X3="" F I=1:1 S X3=$O(^DIA(2,"B",DFN,X3)) Q:X3<1  S:$P(^DIA(2,X3,0),U,3)=.31115 ES1=$P(^DIA(2,X3,0),U,2)
        . W:$D(ES1)>0 !," [EMPLOYMENT STATUS CHANGED:] "_$$FMTE^XLFDT(ES1,"5D")
        . ; The IB Insurance API does not provide date entered or edited information, so this information will not be displayed for preregistration
        . I $$INSUR^IBBAPI(DFN,"","AR",.DGDATA,"1,10,11") F DGI=0:0 S DGI=$O(DGDATA("IBBAPI","INSUR",DGI)) Q:'DGI  D
        .. W !," [INSURANCE:] ",$P(DGDATA("IBBAPI","INSUR",DGI,1),U,2)
        .. W "  EFFECTIVE DATE: ",$$FMTE^XLFDT(DGDATA("IBBAPI","INSUR",DGI,10),"5D"),"  EXPIRATION DATE: ",$$FMTE^XLFDT(DGDATA("IBBAPI","INSUR",DGI,11),"5D")
        ;
        G ^DGRPP
        ;
GETNCAL ;Get name component values
        N DGCOMP,DGNC,DGI,DGA,DGALIAS,DGX,DGRPW
        S DGNC="Family^Given^Middle^Prefix^Suffix^Degree"
        S DGCOMP=+$G(^DPT(DFN,"NAME"))_","
        I DGCOMP D GETS^DIQ(20,DGCOMP,"1:6",,"DGCOMP")
        ;Get alias values
        S DGA=0 F DGI=1:1:5 D  Q:'$D(DGALIAS(DGI))
A2      .S DGA=$O(^DPT(DFN,.01,DGA))
        .I 'DGA D:DGI=1  Q
        ..S DGALIAS(DGI)="< No alias entries on file >" Q
        .I DGI=5 S DGALIAS(DGI)="< More alias entries on file >" Q
        .S DGX=$G(^DPT(DFN,.01,DGA,0)) G:'$L(DGX) A2
        .S DGALIAS(DGI)=$P(DGX,U),DGX=$P(DGX,U,2)
        .I $L(DGX) D
        ..S DGX=" "_$E(DGX,1,3)_"-"_$E(DGX,4,5)_"-"_$E(DGX,6,9)
        ..; BAJ DG*5.2*700 retrofit 06/22/06
        ..S DGALIAS(DGI)=$E(DGALIAS(DGI),1,19)
        ..S $E(DGALIAS(DGI),20)=DGX Q
        .S DGALIAS(DGI)=$E(DGALIAS(DGI),1,32)
        .Q
        ;Display name component, sex, multiple birth indicator and alias data
        F DGI=1:1:6 D
        .W !?5,$J($P(DGNC,U,DGI),6),": ",$E($G(DGCOMP(20,DGCOMP,DGI)),1,$S(DGI=1:23,1:27))
        .; BAJ DG*5.3*700 retrofit 06/22/06
        .I DGI=1 S (Z,DGRPW)=1 W ?43,"Sex: " S X=$P(DGRP(0),"^",2),Z=$S(X="M":"MALE",X="F":"FEMALE",1:DGRPU),Z1=3 D WW1^DGRPV
        .I DGI=1 S (Z,DGRPW)=1 W ?56,"MBI: " S X=$P($G(^DPT(DFN,"MPIMB")),U),Z=$S(X="N":"NO",X="Y":"*MULTIPLE BIRTH*",1:DGRPU),Z1=16 D WW1^DGRPV
        .I DGI=2 S DGRPW=0,Z=2 W ?37 D WW^DGRPV W " Alias: "
        .I DGI>1 W ?47,$G(DGALIAS(DGI-1))
        .Q
        Q
GETSTAT(SSNV)   ;get SSN VERIFIED STATUS DG*5.3*688 BAJ 11/22/2005
        N T
        S T=$P($G(^DPT(DFN,"SSN")),"^",2)
        S SSNV=$S(T=2:"INVALID",T=4:"VERIFIED",1:"")
        Q
        ;
SSNREAS(DGREAS) ;get Pseuso SSN Reason - DG*5.3*653, ERC
        S DGREAS=$P(DGRP("SSN"),U)
        I $G(DGREAS)']"" Q
        S DGREAS=$S(DGREAS="R":"Refused to Provide",DGREAS="S":"SSN Unknown/Follow-up Required",DGREAS="N":"No SSN Assigned",1:"< None Entered >")
        Q
COUNTY(DGRP)    ;retrieve and print County info if a US address
        N DGCC,CNODE,FNODE,FPCE,FILE,IEN,CNTRY,PLINE
        ; data location of Permanent Address County info
        S FNODE=.11,FPCE=10,DGCC=""
        ; only print county info if it's a US address
        S IEN=$P(DGRP(FNODE),U,FPCE) I '$$FORIEN^DGADDUTL(IEN) D
        . S DGCC=$S($D(^DIC(5,+$P(DGRP(FNODE),U,5),1,+$P(DGRP(FNODE),U,7),0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)]"":" ("_$P(^(0),U,3)_")",1:""),1:DGRPU)
        S PLINE=$S(DGCC]"":"County: "_DGCC,1:"")
        W !?3,PLINE
        S DGCC=""
        ; data location of Temporary address County info
        S CNODE=.121,FNODE=.122,FPCE=3
        ; only print county info if it's a US address
        S IEN=$P(DGRP(FNODE),U,FPCE) I '$$FORIEN^DGADDUTL(IEN) D
        . S DGCC=$S($P(DGRP(CNODE),U,9)'="Y":"NOT APPLICABLE",$D(^DIC(5,+$P(DGRP(CNODE),U,5),1,+$P(DGRP(CNODE),U,11),0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)]"":" ("_$P(^(0),U,3)_")",1:""),1:DGRPU)
        S PLINE=$S(DGCC]"":"County: "_DGCC,1:"")
        W ?43,PLINE
        Q
        ;
