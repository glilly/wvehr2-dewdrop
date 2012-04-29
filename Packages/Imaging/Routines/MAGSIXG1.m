MAGSIXG1        ;WOIFO/EdM/GEK/SEB - RPCs for Document Imaging ; 04/29/2002  16:15
        ;;3.0;IMAGING;**8,48,59**;Nov 27, 2007;Build 20
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;; +---------------------------------------------------------------+
        ;; | Property of the US Government.                                |
        ;; | No permission to copy or redistribute this software is given. |
        ;; | Use of unreleased versions of this software requires the user |
        ;; | to execute a written test agreement with the VistA Imaging    |
        ;; | Development Office of the Department of Veterans Affairs,     |
        ;; | telephone (301) 734-0100.                                     |
        ;; |                                                               |
        ;; | The Food and Drug Administration classifies this software as  |
        ;; | a medical device.  As such, it may not be changed in any way. |
        ;; | Modifications to this software may result in an adulterated   |
        ;; | medical device under 21CFR820, the use of which is considered |
        ;; | to be a violation of US Federal Statutes.                     |
        ;; +---------------------------------------------------------------+
        ;;
        Q
        ;
        ; OUT  =  Output array.
        ;   OUT(0)        ->  1|0 ^ message
        ;   OUT(1)        ->  Field Headers
        ;       '^' delimited list of column headers used in cMagListView
        ;   OUT(2..n) ->  each line is information on 1 image.
        ;       piece '|' 1 is '^' delimited data to be displayed in columns.
        ;       piece '|' 2  is data that is used internally by App.
        ;
        ; PKG   - Package fld 40
        ; CLS   - Class   fld 41
        ; TYPE  - Type    fld 42
        ; EVENT - Proc/Event         fld 43
        ; SPEC  - Spec/SubSpecialty  fld 44
        ; FROM  - Date to search from
        ; UNTIL - Date to search to
        ; ORIGIN - Origin fld 45
        ; DATA  -  Future
        ; FLGS  -  Future
        ;
PGI(OUT,DFN,PKG,CLS,TYPE,EVENT,SPEC,FROM,UNTIL,ORIGIN,DATA,FLGS)        ;RPC [MAG4 PAT GET IMAGES]
        ; Get Images for Patient.
        ; New call in Patch 3.0.8 uses Image Filter to get list of images
        N C,DAT1,DAT2,E,IMAGE,N,OK,P,RDT,RESULT,S,T,V,CT,PKG1,CLS1,TYPE1,EVENT1,SPEC1,FLTX,FLTY,CAPDUZ,CAPDT,MAGVR,FNL
        S FROM=$G(FROM),UNTIL=$G(UNTIL)
        D REVDT(FROM,UNTIL,.DAT1,.DAT2)
        S RESULT="OUT" K OUT,^TMP($T(+0),$J)
        S PKG=$G(PKG),CLS=$G(CLS),EVENT=$G(EVENT),SPEC=$G(SPEC),TYPE=$G(TYPE),ORIGIN=$G(ORIGIN)
        I PKG'="" D PKG^MAGSIXGT Q:$D(OUT(0))
        I CLS'="" D CLS^MAGSIXGT Q:$D(OUT(0))
        I EVENT'="" D EVENT^MAGSIXGT Q:$D(OUT(0))
        I SPEC'="" D SPEC^MAGSIXGT Q:$D(OUT(0))
        I TYPE'="" D TYPE^MAGSIXGT Q:$D(OUT(0))
        I ORIGIN'="" D ORIGIN^MAGSIXGT Q:$D(OUT(0))
        I +DFN'=DFN S @RESULT@(0)="0^Invalid Patient Number: """_DFN_"""." Q
        I '$D(^DPT(DFN,0))#2 S @RESULT@(0)="0^No Such Patient: """_DFN_"""." Q
        S N=0
        D NETPLCS^MAGGTU6
        ;3.0.8/gek, Quit searching all images, just do the date range.
        S RDT=DAT1 F  S RDT=$O(^MAG(2005,"APDTPX",DFN,RDT)) Q:(RDT="")!(RDT>DAT2)  D
        . K ^TMP($J,"MAGSIX")
        . N COUNT,PRX,X0,X2,X40,I1,X01
        . S PRX="" F  S PRX=$O(^MAG(2005,"APDTPX",DFN,RDT,PRX)) Q:PRX=""  M ^TMP($J,"MAGSIX")=^MAG(2005,"APDTPX",DFN,RDT,PRX)
        . S IMAGE="" F  S IMAGE=$O(^TMP($J,"MAGSIX",IMAGE),-1) Q:IMAGE=""  D
        . . S X0=$G(^MAG(2005,IMAGE,0))
        . . Q:$P(X0,"^",10)  ; child of Group
        . . S X2=$G(^MAG(2005,IMAGE,2)),X40=$G(^MAG(2005,IMAGE,40)),I1=$O(^MAG(2005,IMAGE,1,0))
        . . S P=$P(X40,U),C=$P(X40,"^",2),T=$P(X40,"^",3),E=$P(X40,"^",4),S=$P(X40,"^",5)
        . . ;Patch 59.  Treat Class as a computed Field.  Arrange with Mike to change DB.
        . . S C=$S('T:"",'$D(^MAG(2005.83,T,0)):"",1:$P(^(0),"^",2))
        . . S V=$S($P(X40,"^",6)="":"V",1:$P(X40,"^",6)) ; P48T1 show VA for Null
        . . D CHK^DIE(2005,45,"E",V,.MAGVR) I MAGVR'="^" S V=MAGVR(0) ; P48T1 show External Value
        . . I PKG'="",P'="",'$D(OK(5,P)) Q
        . . I ORIGIN'="",V'="",'$D(OK(6,V)) Q
        . . I CLS'="",C'="",'$D(OK(1,C)) Q
        . . I EVENT'="",E,'$D(OK(2,E)) Q
        . . ;3.0.8 Stop list entries with no Event, if Event is in Search Specs
        . . I EVENT'="",E="" Q
        . . I SPEC'="",S,'$D(OK(3,S)) Q
        . . ;3.0.8 Stop list entries with no Spec, if Spec is in Search Specs
        . . I SPEC'="",S="" Q
        . . I TYPE'="",T,'$D(OK(4,T)) Q
        . . ; Get Count of Images in Group, use 4th piece of ,1,0) multiple
        . . S COUNT=$S($P($G(^MAG(2005,IMAGE,1,0)),"^",4):$P($G(^MAG(2005,IMAGE,1,0)),"^",4),1:1)
        . . S FLTX=""
        . . ; PUT in Site Code as 2nd piece.
        . . S X01=$S(I1:$G(^MAG(2005,+$G(^MAG(2005,IMAGE,1,I1,0)),0)),1:X0)
        . . S FNL=$S(+$P(X01,"^",3):$P(X01,"^",3),1:+$P(X01,"^",5))
        . . S FLTX=$P($G(MAGJOB("NETPLC",FNL)),"^",2)
        . . I FLTX="" S FLTX=$G(MAGJOB("PLCODE"))
        . . S FLTX=FLTX_"^"_$$RPTITLE($P(X2,"^",6),$P(X2,"^",7))
        . . S X=$$FMTE^XLFDT($P(X2,"^",5),"5Z")
        . . S X=$P(X,"@",1)_" "_$S($L($P(X,"@",2)):$P(X,"@",2),1:"00:01")
        . . S FLTX=FLTX_"^"_X
        . . S FLTX=FLTX_"^"_$P(X0,"^",8)_"^"_COUNT_"^"_$P(X2,"^",4)
        . . S FLTX=FLTX_"^"_P
        . . S FLTX=FLTX_"^"_$P($G(^MAG(2005.82,+C,0)),"^",1)
        . . S FLTX=FLTX_"^"_$P($G(^MAG(2005.83,+T,0)),"^",1)
        . . S FLTX=FLTX_"^"_$P($G(^MAG(2005.84,+S,0)),"^",1)
        . . S FLTX=FLTX_"^"_$P($G(^MAG(2005.85,+E,0)),"^",1)
        . . S FLTX=FLTX_"^"_V
        . . ;S FLTX=FLTX_"^"_$P($$FMTE^XLFDT($P(X2,"^",1),"5Z"),"@",1)
        . . S X=$$FMTE^XLFDT($P(X2,"^",1),"5Z")
        . . S X=$P(X,"@",1)_" "_$S($L($P(X,"@",2)):$P(X,"@",2),1:"00:01")
        . . S FLTX=FLTX_"^"_X
        . . ;;;;;;;;;
        . . ; P8T36 gek. Fix Error caused if $P(X2,"^",2) "ImageSavedBy" is null
        . . S FLTX=FLTX_"^"_$$GET1^DIQ(200,+$P(X2,"^",2)_",",.01)
        . . N MAGFILE,MAGXX
        . . S MAGXX=IMAGE D INFO^MAGGTII
        . . S FLTX=FLTX_"^"_$P(MAGFILE,"^",1)
        . . S N=N+1,@RESULT@(N+1)=N_"^"_FLTX_"|"_MAGFILE
        . . Q:N<76  Q:RESULT["^"
        . . ; Image count is getting big, switch from array to Global return type
        . . S ^TMP($T(+0),$J)=""
        . . M ^TMP($T(+0),$J)=OUT
        . . K OUT
        . . S X=$$RTRNFMT^XWBLIB("GLOBAL ARRAY",1)
        . . S RESULT=$NA(^TMP($T(+0),$J))
        . . S OUT=$NA(^TMP($T(+0),$J)) ;GEK 10/01/02
        . . Q
        . ;Q
        . Q
        S FLTY=$$FLTDESC(X)
        I 'N S @RESULT@(0)="0^No images for filter: "_FLTY  Q
        S @RESULT@(0)="1^"_FLTY
        S @RESULT@(1)="Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0"
        ;S @RESULT@(1)="Item~S2^Site^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0"
        Q
RPTITLE(FILE,IEN)       ;
        I FILE=8925,$D(^TIU(8925,IEN,0)) Q $P(^TIU(8925.1,$P(^TIU(8925,IEN,0),"^",1),0),"^",1)
        ;I FILE=8925,$D(^TIU(8925,IEN,0)) Q $$GET1^DIQ(FILE,IEN,".01:.01")
        E  Q "   "
FLTDESC(X)      ;
        N FLT
        S FLT=""
        ; Package
        S FLT=FLT_$S(PKG="":"",1:"Pkg: "_PKG_" - ")
        ; Class
        S FLT=FLT_$S(CLS="":"",CLS="ADMIN,ADMIN/CLIN,CLIN/ADMIN":"Class: ADMIN - ",CLS="CLIN,CLIN/ADMIN,ADMIN/CLIN":"Class: CLIN - ",1:"Class: "_CLS_" - ")
        ; Type
        F CT=1:1:$L(TYPE,",") D
        . S TYPE1=$P(TYPE,",",CT) I TYPE1'="" S TYPE1=$P($G(^MAG(2005.83,TYPE1,0)),"^")
        . S $P(TYPE,",",CT)=$E(TYPE1)_$$LOW^XLFSTR($E(TYPE1,2,999))
        S FLT=FLT_$S(TYPE="":"",1:"Type: "_TYPE_" - ")
        ; Specialty/SubSpecialty
        F CT=1:1:$L(SPEC,",") D
        . S SPEC1=$P(SPEC,",",CT) I SPEC1'="" S SPEC1=$P($G(^MAG(2005.84,SPEC1,0)),"^")
        . S $P(SPEC,",",CT)=$E(SPEC1)_$$LOW^XLFSTR($E(SPEC1,2,999))
        S FLT=FLT_$S(SPEC="":"",1:"Spec.: "_SPEC_" - ")
        ; Procedure/Event
        F CT=1:1:$L(EVENT,",") D
        . S EVENT1=$P(EVENT,",",CT) I EVENT1'="" S EVENT1=$P($G(^MAG(2005.85,EVENT1,0)),"^")
        . S $P(EVENT,",",CT)=$E(EVENT1)_$$LOW^XLFSTR($E(EVENT1,2,999))
        S FLT=FLT_$S(EVENT="":"",1:"Event: "_EVENT_" - ")
        ; Origin
        S FLT=FLT_$S(ORIGIN="":"",1:"Origin: "_ORIGIN_" - ")
        ; Date Range - From
        S FROM=$S($G(FROM)="":"",1:" from "_FROM)
        ; Date Range - Until
        S UNTIL=$S($G(UNTIL)="":"",1:" to "_UNTIL)
        S FLT=FLT_$G(FROM)_$G(UNTIL)
        ; If No Filter.  Then get All.
        I FLT="" S FLT="All Images"
        Q FLT
REVDT(FROM,UNTIL,DAT1,DAT2)     ; Calculate the Reverse Dates and switch for $O
        ; for $O( through a data cross reference that is reversed, i.e. X=9999999.9999-DT
        ; FROM  = Date in External or Internal
        ; UNTIL = Date in External or Internal
        ; DAT1  = Reverse the two dates, FROM and UNTIL, equal to the earliest
        ; DAT2  = Reverse the two dates, FROM and UNTIL, equal to the latest
        ;
        S DAT1=$$E2I^MAGSIXGT($G(FROM))
        S DAT2=$$E2I^MAGSIXGT($G(UNTIL))
        I 'DAT2 S DAT2=9999999.9999
        S DAT1=9999999.9999-DAT1
        S DAT2=9999999.9999-DAT2
        I DAT1]DAT2 S X=DAT1,DAT1=DAT2,DAT2=X
        S DAT1=DAT1\1,$P(DAT2,".",2)="9999"
        Q
