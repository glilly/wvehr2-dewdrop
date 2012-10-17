CRHD8   ; CAIRO/CLC - RETURNS THE TEXTS OF AND ORDER ; 4/22/09 7:21am
        ;;1.0;CRHD;**2**;Jan 28, 2008;Build 11
        ;=================================================================
        ;12/14/2009 BAY/KAM CRHD*1*2 Remedy Call 264207 Correct HOT list
        ;                            duplicate patient name print issue
TEXT(ORTX,ORIFN,WIDTH)  ; -- Returns text of order ORIFN in ORTX(#)
        N CRHD0,CRHD3,CRHD6,CRHDORX,X,Y,CRHDFRST,CRHDI,CRHDJ,CRHDLG,X,CRHDACT
        N CRHDTA,XQAID,ORFLG
        K ORTX S:'$G(WIDTH) WIDTH=244
        S CRHDACT=+$P(ORIFN,";",2),ORIFN=+ORIFN
        I CRHDACT<1 S CRHDACT=+$P($G(^OR(100,ORIFN,3)),U,7) S:'CRHDACT CRHDACT=1
        S CRHD0=$G(^OR(100,ORIFN,0)),CRHD3=$G(^(3)),CRHD6=$G(^(6)),CRHDORX=$G(^(8,CRHDACT,0))
        S ORTX=1,ORTX(1)=""
        I $P($G(CRHD0),U,11)'="",($P($G(^ORD(100.98,$P(CRHD0,U,11),0)),U)="NON-VA MEDICATIONS") S X="Non-VA" D ADD^ORQ12
        G:$G(ORIGVIEW)>1 T1
        S:$P(CRHD0,U,14)=$O(^DIC(9.4,"C","OR",0)) ORTX(1)=">>" ;generic
        S X=$$ACTION^ORQ12($P(CRHDORX,U,2)) D:$L(X) ADD^ORQ12
        I $P(CRHDORX,U,2)="NW",$P(CRHD3,U,11),'$G(ORIGVIEW) D  ; Changed or Renewed
        . I $P(CRHD3,U,11)=2 S X="Renew" D ADD^ORQ12 Q
        . N CRHDIG,CRHDIGTA S CRHDIG=+$P(CRHD3,U,5) Q:'CRHDIG  Q:$P(CRHD3,U,11)'=1
        . S X="Change" D ADD^ORQ12 S CRHDI=0
        . I $G(IOST)'="P-OTHER" D
        . .S CRHDIGTA=$$LASTXT^ORQ12(CRHDIG) ;D:$O(^OR(100,CRHDIG,1,0)) CNV^ORY92(CRHDIG)
        . .F  S CRHDI=$O(^OR(100,CRHDIG,8,CRHDIGTA,.1,CRHDI)) Q:CRHDI'>0  S X=$G(^(CRHDI,0)) S:$E(X,1,3)=">> " X=$E(X,4,999) D ADD^ORQ12
        . .S X=" to" D ADD^ORQ12
T1      S CRHDTA=+$P(CRHDORX,U,14),CRHDFRST=+$O(^OR(100,ORIFN,8,CRHDTA,.1,0))
        S CRHDI=0 F  S CRHDI=$O(^OR(100,ORIFN,8,CRHDTA,.1,CRHDI)) Q:CRHDI'>0  S X=$G(^(CRHDI,0)) S:(CRHDFRST=CRHDI)&($E(X,1,3)=">> ") X=$E(X,4,999) D:$L(X) ADD^ORQ12
        Q:$G(ORIGVIEW)>1  ;contents of global only
        S CRHDLG=$P(CRHD0,U,5) K Y I CRHDLG,$P(CRHDLG,";",2)["101.41",$D(^ORD(101.41,+CRHDLG,9)) X ^(9) I $L($G(Y)) S X=Y D ADD^ORQ12 ; additional text
        ; I $P(CRHD3,U,11)=2 S X="(Renewal)" D ADD^ORQ12
        I $P(CRHDORX,U,4)=2 S X="*UNSIGNED*" D ADD^ORQ12
        I $P(CRHDORX,U,2)="DC"!("^1^13^"[(U_$P(CRHD3,U,3)_U)),$L(CRHD6) S X=" <"_$S($L($P(CRHD6,U,5)):$P(CRHD6,U,5),$P(CRHD6,U,4):$P($G(^ORD(100.03,+$P(CRHD6,U,4),0)),U),1:"")_">" D:$L(X)>3 ADD^ORQ12 ; DC Reason
        I $D(XQAID),$G(ORFLG)=12 S CRHDORX=$G(^OR(100,ORIFN,8,CRHDACT,3)) D
        .I $P(CRHDORX,U) S X=" Flagged "_$$DATETIME^ORQ12($P(CRHDORX,U,3))_$S($P(CRHDORX,U,4):" by "_$$NAME^ORQ12($P(CRHDORX,U,4)),1:"")_": "_$P(CRHDORX,U,5) D ADD^ORQ12 ;Flagged - show in FUP
        Q
SORT(CRHDRTN,CRHDPLST,CRHDFG,CRHDP)     ;SORT PRINT LIST
        N VAIN,CRHDV,CRHDV1,CRHDV2,CRHDCT,CRHDDFN,CRHDWARD
        N CRHDNAME,CRHDRM,CRHDN,CRHDWR,CRHDW,CRHDFLG,CRHDS,CRHDLG,CRHDLB
        K CRHDRTN
        I (CRHDP?1N.E)&($E(CRHDP,1)'=1) S CRHDP="1,"_CRHDP
        S CRHDP1=$P(CRHDP,"^",1)
        S CRHDLG=$P(CRHDP,"^",2)
        S CRHDLB=$P(CRHDP,"^",3)
        S CRHDV=0
        F  S CRHDV=$O(CRHDPLST(CRHDV)) Q:'CRHDV  D
        .S CRHDDFN=+CRHDPLST(CRHDV)
        .K CRHDRL,CRHDS
        .Q:'CRHDDFN
        .S CRHDS=CRHDDFN_"^"_CRHDP1_"^"_CRHDLG_"^"_CRHDLB
        .D PATDEMO^CRHDUT2(.CRHDRL,CRHDS)
        .S CRHDFLG=CRHDFG
        .S CRHDRM=$P($G(CRHDRL),"^",4)                              ;Room/Bed
        .I CRHDRM["RM : " S CRHDRM=$P(CRHDRM,": ",2)
        .S CRHDWARD=$P($G(CRHDRL),"^",5)                             ;Ward Location
        .I CRHDWARD["LOC: " S CRHDWARD=$P(CRHDWARD,": ",2)
        .S CRHDNAME=$P(^DPT(CRHDDFN,0),"^",1)
        .Q:CRHDNAME=""
        .I CRHDFLG=1 D
        ..I (CRHDWARD="") S CRHDWARD="UNK"  ;S CRHDFLG=0 Q
        ..I (CRHDRM="") S CRHDRM="UNK"      ;S CRHDFLG=2 Q
        ..;12/14/09 BAY/KAM CRHD*1*2 Remedy Call 264207 Concatenated CRHDDFN
        ..;                          to the next line for subscript
        ..;                          uniqueness
        ..;S CRHDWR(CRHDWARD,CRHDRM,CRHDNAME)=CRHDRL
        ..S CRHDWR(CRHDWARD,CRHDRM,CRHDNAME_CRHDDFN)=CRHDRL
        .I CRHDFLG=2 D
        ..I CRHDWARD="" S CRHDWARD="UNK"    ;S CRHDFLG=0 Q
        ..;12/14/09 BAY/KAM CRHD*1*2 Remedy Call 264207 Concatenated CRHDDFN
        ..;                          to the next line for subscript
        ..;                          uniqueness
        ..;S CRHDW(CRHDWARD,CRHDNAME)=CRHDRL
        ..S CRHDW(CRHDWARD,CRHDNAME_CRHDDFN)=CRHDRL
        .;12/14/2009 BAY/KAM CRHD*1*2 Remedy Call 264207 Concatenated CRHDDFN
        .;                            to the next line for subscript
        .;                            uniqueness
        .;I CRHDFLG=0 S CRHDN(CRHDNAME)=CRHDRL
        .I CRHDFLG=0 S CRHDN(CRHDNAME_CRHDDFN)=CRHDRL
        ;
        S CRHDCT=0
        S CRHDV=0
        I CRHDFG=0 D
        .F  S CRHDV=$O(CRHDN(CRHDV)) Q:CRHDV=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDN(CRHDV)
        .K CRHDN
        I CRHDFG=1 D
        .F  S CRHDV=$O(CRHDWR(CRHDV)) Q:CRHDV=""  S CRHDV1="" F  S CRHDV1=$O(CRHDWR(CRHDV,CRHDV1)) Q:CRHDV1=""  S CRHDV2="" F  S CRHDV2=$O(CRHDWR(CRHDV,CRHDV1,CRHDV2)) Q:CRHDV2=""   S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDWR(CRHDV,CRHDV1,CRHDV2)
        .K CRHDWR
        I CRHDFG=2 D
        .F  S CRHDV=$O(CRHDW(CRHDV)) Q:CRHDV=""  S CRHDV1="" F  S CRHDV1=$O(CRHDW(CRHDV,CRHDV1)) Q:CRHDV1=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDW(CRHDV,CRHDV1)
        .K CRHDW
        I '$D(CRHDRTN) D
        .S CRHDV=0
        .I $D(CRHDW) F  S CRHDV=$O(CRHDW(CRHDV)) Q:CRHDV=""  S CRHDV1="" F  S CRHDV1=$O(CRHDW(CRHDV,CRHDV1)) Q:CRHDV1=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDWR(CRHDV,CRHDV1)
        .I $D(CRHDN) F  S CRHDV=$O(CRHDN(CRHDV)) Q:CRHDV=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDN(CRHDV)
        Q
