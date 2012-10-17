GMVHS1  ;HIOFO/FT-RETURN PATIENT DATA UTILITY (cont.) ;10/3/07
        ;;5.0;GEN. MED. REC. - VITALS;**3,23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ;  #4290 - ^PXRMINDX global     (controlled)
        ;
CALCBMI(GMVNODE)        ; Calculate BMI for a record
        ; GMVNODE = FILE 120.5 zero node of patient's weight
        N GMVADATE,GMVAHGT,GMVBDATE,GMVBHGT,GMVBMI,GMVDFN,GMVH,GMVHTI,GMVIEN,GMVHGT,GMVWDATE,GMVWTI
        S GMVHTI=$$GETTYPEI^GMVHS("HT") ;height ien
        S GMVWTI=$$GETTYPEI^GMVHS("WT") ;weight ien
        S GMVBMI="^",GMVNODE=$G(GMVNODE)
        I $P(GMVNODE,U,3)'=GMVWTI Q GMVBMI  ;not a weight reading
        I $P(GMVNODE,U,8)'>0 Q GMVBMI  ;weight'>0
        S GMVDFN=$P(GMVNODE,U,2)
        I 'GMVDFN Q GMVBMI
        S GMVWDATE=$P(GMVNODE,U,1) ;date/time of weight
        S GMVHGT=0
        ; Look for exact date/time match for height entry
        S GMVIEN=$O(^PXRMINDX(120.5,"PI",GMVDFN,GMVHTI,GMVWDATE,0))
        I GMVIEN'="" S GMVHGT=$$HEIGHT(GMVIEN)
        I $P(GMVHGT,U,1) S GMVBMI=$$CALC($P(GMVNODE,U,8),$P(GMVHGT,U,1)) Q GMVBMI
        ; get height and date/time taken before weight
        S GMVBDATE=GMVWDATE,GMVBHGT=0
        F  S GMVBDATE=$O(^PXRMINDX(120.5,"PI",GMVDFN,GMVHTI,GMVBDATE),-1) Q:GMVBDATE'>0!(+GMVBHGT)  D
        .S GMVIEN=0
        .F  S GMVIEN=$O(^PXRMINDX(120.5,"PI",GMVDFN,GMVHTI,GMVBDATE,GMVIEN)) Q:$L(GMVIEN)'>0!(+GMVBHGT)  D
        ..S GMVBHGT=$$HEIGHT(GMVIEN)
        ..Q
        .Q
        ; get height and date/time taken after weight
        S GMVADATE=GMVWDATE,GMVAHGT=0
        F  S GMVADATE=$O(^PXRMINDX(120.5,"PI",GMVDFN,GMVHTI,GMVADATE)) Q:GMVADATE'>0!(+GMVAHGT)  D
        .S GMVIEN=0
        .F  S GMVIEN=$O(^PXRMINDX(120.5,"PI",GMVDFN,GMVHTI,GMVADATE,GMVIEN)) Q:$L(GMVIEN)'>0!(+GMVAHGT)  D
        ..S GMVAHGT=$$HEIGHT(GMVIEN)
        ..Q
        .Q
        S GMVBDATE=$P(GMVBHGT,U,2),GMVBHGT=$P(GMVBHGT,U,1)
        S GMVADATE=$P(GMVAHGT,U,2),GMVAHGT=$P(GMVAHGT,U,1)
        I $P(GMVBDATE,".",1)=$P(GMVWDATE,".",1) S GMVBMI=$$CALC($P(GMVNODE,U,8),GMVBHGT) Q GMVBMI
        I $P(GMVADATE,".",1)=$P(GMVWDATE,".",1) S GMVBMI=$$CALC($P(GMVNODE,U,8),GMVAHGT) Q GMVBMI
        S GMVH=$S(GMVBHGT>0:GMVBHGT,GMVAHGT>0:GMVAHGT,1:"")
        I GMVH="" Q GMVBMI
        S GMVBMI=$$CALC($P(GMVNODE,U,8),GMVH) Q GMVBMI
        Q GMVBMI
        ;
HEIGHT(GMVIEN)  ; Does record have a useable height value? Is yes, return that value.
        ; GMVIEN = File 120.5 entry number
        N GMVCLIO,GMVX
        S GMVIEN=$G(GMVIEN),GMVX=0
        I GMVIEN=+GMVIEN D
        .D F1205^GMVUTL(.GMVCLIO,GMVIEN)
        I GMVIEN'=+GMVIEN D
        .D CLIO^GMVUTL(.GMVCLIO,GMVIEN)
        S GMVCLIO(0)=$G(GMVCLIO(0))
        S GMVX=$P(GMVCLIO(0),U,8)
        I GMVX'>0 Q GMVX
        S GMVX=GMVX_U_$P(GMVCLIO(0),U,1)
        Q GMVX
        ;
CALC(GMVWT,GMVHT)       ; Crunch the numbers, return bmi score
        ; GMVWT (lb)
        ; GMVHT (in)
        N GMVX
        S GMVWT=$G(GMVWT),GMVHT=$G(GMVHT)
        I 'GMVWT!(GMVHT'>0) Q ""
        S GMVWT=GMVWT/2.2,GMVHT=GMVHT*2.54/100
        S GMVX=$J(GMVWT/(GMVHT*GMVHT),0,0) S GMVX=GMVX_$S(GMVX>27:"*",1:"")
        Q GMVX
        ;
ABNORMAL        ; Is reading outside of normal range?
        N GMVASTRK,GMVDIA,GMVSYS
        S GMVASTRK=""
        I GMVTYPE="T" D
        .S:GMVRATE>$P(GMVABNML("T"),U,1) GMVASTRK="*"
        .S:GMVRATE<$P(GMVABNML("T"),U,2) GMVASTRK="*"
        .Q
        I GMVTYPE="P" D
        .S:GMVRATE>$P(GMVABNML("P"),U,1) GMVASTRK="*"
        .S:GMVRATE<$P(GMVABNML("P"),U,2) GMVASTRK="*"
        .Q
        I GMVTYPE="R" D
        .S:GMVRATE>$P(GMVABNML("R"),U,1) GMVASTRK="*"
        .S:GMVRATE<$P(GMVABNML("R"),U,2) GMVASTRK="*"
        .Q
        I GMVTYPE="BP" D
        .S GMVSYS=$P(GMVRATE,"/",1)
        .S GMVDIA=$S($P(GMVRATE,"/",3)="":$P(GMVRATE,"/",2),1:$P(GMVRATE,"/",3))
        .S:GMVSYS>$P(GMVABNML("BP"),U,1) GMVASTRK="*"
        .S:GMVSYS<$P(GMVABNML("BP"),U,2) GMVASTRK="*"
        .S:GMVDIA>$P(GMVABNML("BP"),U,3) GMVASTRK="*"
        .S:GMVDIA<$P(GMVABNML("BP"),U,4) GMVASTRK="*"
        .Q
        I GMVTYPE="CVP" D
        .S:GMVRATE>$P(GMVABNML("CVP"),U,1) GMVASTRK="*"
        .S:GMVRATE<$P(GMVABNML("CVP"),U,2) GMVASTRK="*"
        .Q
        I GMVTYPE="PO2" D
        .S:GMVRATE<$P(GMVABNML("PO2"),U,2) GMVASTRK="*"
        .Q
        S $P(GMVDATA,U,12)=GMVASTRK
        Q
TEXT(RATE)      ; Is rate a text code?
        ; Returns 0 if RATE has a text code and 1 if a numeric reading
        N GMVYES
        S RATE=$G(RATE),GMVYES=1
        I "REFUSEDPASSUNAVAILABLE"[$$UP^XLFSTR(RATE) S GMVYES=0
        Q GMVYES
        ;
RANGE   ; Find normal ranges and store in array
        N GMVPIEN,GMVPNODE
        S GMVABNML("T")="0^0" ;high^low
        S GMVABNML("P")="0^0" ;high^low
        S GMVABNML("R")="0^0" ;high^low
        S GMVABNML("CVP")="0^0" ;high^low
        S GMVABNML("PO2")="0^0" ;low
        S GMVABNML("BP")="0^0^0^0" ;sys high^sys low^dia high^dia low
        S GMVPIEN=$O(^GMRD(120.57,0))
        Q:'GMVPIEN
        S GMVPNODE=$G(^GMRD(120.57,GMVPIEN,1))
        S GMVABNML("T")=$P(GMVPNODE,U,1)_U_$P(GMVPNODE,U,2)
        S GMVABNML("P")=$P(GMVPNODE,U,3)_U_$P(GMVPNODE,U,4)
        S GMVABNML("R")=$P(GMVPNODE,U,5)_U_$P(GMVPNODE,U,6)
        S GMVABNML("BP")=$P(GMVPNODE,U,7)_U_$P(GMVPNODE,U,9)_U_$P(GMVPNODE,U,8)_U_$P(GMVPNODE,U,10)
        S GMVABNML("CVP")=$P(GMVPNODE,U,11)_U_$P(GMVPNODE,U,12)
        S GMVABNML("PO2")=""_U_$P(GMVPNODE,U,13)
        Q
