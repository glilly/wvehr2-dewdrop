FHDSSAPI        ;Hines OIFO/RTK,JRC-DSS REQUESTED API's  ; 11/3/08 2:42pm
        ;;5.5;DIETETICS;**7,11,10,16,18**;Jan 28, 2005;Build 27
        ;11/22/2006 KAM/BAY Remedy Call 168346 Add Variable Cleanup from *7
        ;03/31/2008 GDU/SLC Remedy  226373, inpatient record selection for extract re-worked
DATA(FHSDT,FHEDT)       ;API for DSS extract of NFS data
        ; INPUT: START DATE, END DATE
        ; OUTPUT: ^TMP($J,"FH"
        ; Get inpatient meals
        I FHSDT>FHEDT W !!,"END DATE BEFORE START DATE!",! H 1 Q
        K ^TMP($J,"FH") S FHEDT=FHEDT_.99
        F FHDFN=0:0 S FHDFN=$O(^FHPT(FHDFN)) Q:FHDFN'>0  D
        . I '$D(^FHPT(FHDFN,0)) Q
        . D PATNAME^FHOMUTL
        . ;Check if patient is deceased. Quit if date of death is before start date
        . S FHDCEASE=$$GET1^DIQ(2,DFN,".351","I")
        . I FHDCEASE&(FHDCEASE<FHSDT) D CLEAN Q
        . D INPAT,CLEAN
        D OUTPAT
        K FHADM,FHDATE,FHDFN,FHDSEQ,FHEL,FHNODE,FHNODE2,FHNODE3,FHOMDT,FHRNUM
        K FHSDTX1,FHSF,FHSFDT,FHSO,FHSODT,FHTF,FHTFDT,FHTFPR,FHTUZN,FHZ,FHZN
        K FHCDATE,FHNUM,FHEFF,FHADTM,FHDDTM,FHLAST,X,X1,X2,FHDCEASE,FHSTOP
        Q
CLEAN   ;Clean up variables set by PATNAME^FHOMUTL
        K BID,DFN,FHAGE,FHDOB,FHPCZN,FHPTNM,FHSEX,FHSSN,FILE,PID,IEN
        Q
INPAT   ;Process inpatient data
        F FHADM=0:0 S FHADM=$O(^FHPT(FHDFN,"A",FHADM)) Q:FHADM'>0  D
        .S FHZN=$G(^FHPT(FHDFN,"A",FHADM,0)),FHLAST="",FHSTOP=0
        .S FHADTM=$P(FHZN,U,1) I $P(FHADTM,".")>FHEDT Q
        .;If no discharge date, pull discharge date from registration pacakge for this admission
        .;If no matching record in registration package for this admission continue to next admission record
        .I '$P(FHZN,U,14) D  I FHSTOP Q
        .. S VAINDT=FHADTM
        .. D INP^VADPT
        .. I VAIN(1)="" D KVAR^VADPT S FHSTOP=1 Q
        .. S VAIP("E")=VAIN(1),VAIP("M")=1
        .. D IN5^VADPT
        .. I +VAIP(2)=3 S $P(FHZN,U,14)=+VAIP(3)
        .. D KVAR^VADPT
        .;If no discharge date, set to date of death if patient is deceased
        .I '$P(FHZN,U,14),FHDCEASE S $P(FHZN,U,14)=FHDCEASE
        .S FHDDTM=$P(FHZN,U,14) I FHDDTM'="",FHDDTM<FHSDT Q
        .F FHDATE=0:0 S FHDATE=$O(^FHPT(FHDFN,"A",FHADM,"AC",FHDATE)) Q:FHDATE'>0!(FHDATE>FHEDT)  D
        ..S FHDSEQ=$P($G(^FHPT(FHDFN,"A",FHADM,"AC",FHDATE,0)),U,2)
        ..S FHNODE=$G(^FHPT(FHDFN,"A",FHADM,"DI",FHDSEQ,0))
        ..I $P(FHNODE,U,18)="",$P(FHZN,U,14)'="" S $P(FHNODE,U,18)=$P(FHZN,U,14)
        ..I FHDATE<FHSDT I FHLAST'="" K ^TMP($J,"FH",FHADM,FHDFN,FHLAST,"INP")
        ..S FHLAST=FHDATE
        ..S ^TMP($J,"FH",FHADM,FHDFN,FHDATE,"INP")=FHNODE I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        .; Get additional feedings for inpatient
        .; Get Early/Late trays
        .F FHDATE=0:0 S FHDATE=$O(^FHPT(FHDFN,"A",FHADM,"EL",FHDATE)) Q:FHDATE'>0!(FHDATE>FHEDT)  D
        ..S FHNODE=$G(^FHPT(FHDFN,"A",FHADM,"EL",FHDATE,0))
        ..I FHDATE<FHSDT Q  I FHLAST'="" K ^TMP($J,"FH",FHADM,FHDFN,FHLAST,"EL")
        ..S ^TMP($J,"FH",FHADM,FHDFN,FHDATE,"EL")=FHNODE
        .;Get Supplemental Feedings
        .S FHLAST="" F FHSF=0:0 S FHSF=$O(^FHPT(FHDFN,"A",FHADM,"SF",FHSF)) Q:FHSF'>0  D
        ..S FHNODE=$G(^FHPT(FHDFN,"A",FHADM,"SF",FHSF,0))
        ..I $P(FHNODE,U,32)="",$P(FHZN,U,14)'="" S $P(FHNODE,U,32)=$P(FHZN,U,14)
        ..S FHDATE=$P(FHNODE,U,2) I FHDATE>FHEDT Q
        ..S FHCDATE=$P(FHNODE,U,32) I FHCDATE'="" I FHCDATE<FHSDT Q
        ..I FHDATE<FHSDT I FHLAST'="" K ^TMP($J,"FH",FHADM,FHDFN,FHLAST,"SF")
        ..S FHLAST=FHDATE
        ..S ^TMP($J,"FH",FHADM,FHDFN,FHDATE,"SF")=FHNODE
        .;Get Standing Orders
        .S FHNUM=0 F FHSO=0:0 S FHSO=$O(^FHPT(FHDFN,"A",FHADM,"SP",FHSO)) Q:FHSO'>0  D
        ..S FHNODE=$G(^FHPT(FHDFN,"A",FHADM,"SP",FHSO,0))
        ..I $P(FHNODE,U,6)="",$P(FHZN,U,14)'="" S $P(FHNODE,U,6)=$P(FHZN,U,14)
        ..S FHDATE=$P(FHNODE,U,4) I FHDATE>FHEDT Q
        ..S FHCDATE=$P(FHNODE,U,6) I FHCDATE'="" I FHCDATE<FHSDT Q
        ..S FHNUM=FHNUM+1,^TMP($J,"FH",FHADM,FHDFN,FHDATE,"SO",FHNUM)=FHNODE
        .;Get Tube Feedings
        .S FHLAST="" F FHTF=0:0 S FHTF=$O(^FHPT(FHDFN,"A",FHADM,"TF",FHTF)) Q:FHTF'>0  D
        ..S FHNODE=$G(^FHPT(FHDFN,"A",FHADM,"TF",FHTF,0))
        ..I $P(FHNODE,U,11)="",$P(FHZN,U,14)'="" S $P(FHNODE,U,11)=$P(FHZN,U,14)
        ..S FHDATE=$P(FHNODE,U,1) I FHDATE>FHEDT Q
        ..S FHCDATE=$P(FHNODE,U,11) I FHCDATE'="" I FHCDATE<FHSDT Q
        ..I FHDATE<FHSDT I FHLAST'="" K ^TMP($J,"FH",FHADM,FHDFN,FHLAST,"TF")
        ..S FHLAST=FHDATE
        ..S ^TMP($J,"FH",FHADM,FHDFN,FHDATE,"TF")=FHNODE
        ..F FHTFPR=0:0 S FHTFPR=$O(^FHPT(FHDFN,"A",FHADM,"TF",FHTF,"P",FHTFPR)) Q:FHTFPR'>0  D
        ...S FHNODE=$G(^FHPT(FHDFN,"A",FHADM,"TF",FHTF,"P",FHTFPR,0))
        ...S ^TMP($J,"FH",FHADM,FHDFN,FHDATE,"TF",FHTFPR,"P")=FHNODE
        ...Q
        ..Q
        .Q
        Q
        ;
OUTPAT  ;Process outpatient data
        ; Get outpatient meals
        S X1=FHSDT,X2=-1 D C^%DTC S FHSDTX1=X_.99
        ; Get recurring meals
        F FHOMDT=FHSDTX1:0 S FHOMDT=$O(^FHPT("RM",FHOMDT)) Q:FHOMDT=""!(FHOMDT'<FHEDT)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("RM",FHOMDT,FHDFN)) Q:FHDFN=""  D
        ..I '$D(^FHPT(FHDFN,0)) Q
        ..F FHRNUM=0:0 S FHRNUM=$O(^FHPT("RM",FHOMDT,FHDFN,FHRNUM)) Q:FHRNUM=""  D
        ...S FHNODE=$G(^FHPT(FHDFN,"OP",FHRNUM,0)) I $P(FHNODE,U,15)="C" Q
        ...I $P($G(^FHPT(FHDFN,0)),U,3)="" Q
        ...S ^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"RM")=FHNODE I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        ...;
        ...; IF NON-VA LOC DIET(S) ARE IN FIELDS DIET1-DIET5
        ...;
        ...I $D(^FHPT(FHDFN,"OP",FHRNUM,2)) D
        ....S FHNODE2=$G(^FHPT(FHDFN,"OP",FHRNUM,2)) I $P(FHNODE2,U,6)="C" Q
        ....I $P($G(^FHPT(FHDFN,0)),U,3)="" Q
        ....S ^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"RMEL")=FHNODE2 I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        ...I $D(^FHPT(FHDFN,"OP",FHRNUM,3)) D
        ....S FHNODE3=$G(^FHPT(FHDFN,"OP",FHRNUM,3)) I $P(FHNODE3,U,5)="C" Q
        ....I $P($G(^FHPT(FHDFN,0)),U,3)="" Q
        ....S ^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"RMTF")=FHNODE3 I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        ....F FHZ=0:0 S FHZ=$O(^FHPT(FHDFN,"OP",FHRNUM,"TF",FHZ)) Q:FHZ'>0  D
        .....S FHTUZN=$G(^FHPT(FHDFN,"OP",FHRNUM,"TF",FHZ,0))
        .....S ^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"RMTF",FHZ)=FHTUZN I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        ...;fh*5.5*18
        ...;adding supplemental feedings for outpatient
        ...I $D(^FHPT(FHDFN,"OP",FHRNUM,"SF")) D
        ....S FHLAST="" F FHSF=0:0 S FHSF=$O(^FHPT(FHDFN,"OP",FHRNUM,"SF",FHSF)) Q:FHSF'>0  D
        .....S FHNODE=$G(^FHPT(FHDFN,"OP",FHRNUM,"SF",FHSF,0))
        .....S FHDATE=$P(FHNODE,U,2) I FHDATE>FHEDT Q
        .....S FHCDATE=$P(FHNODE,U,32) I FHCDATE'="" I FHCDATE<FHSDT Q
        .....I FHDATE<FHSDT I FHLAST'="" K ^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"SF")
        .....S FHLAST=FHDATE
        .....S ^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"RMSF")=FHNODE
        ...;adding standing orders for outpatient
        ...S FHNUM=0 F FHSO=0:0 S FHSO=$O(^FHPT(FHDFN,"OP",FHRNUM,"SP",FHSO)) Q:FHSO'>0  D
        ....S FHNODE=$G(^FHPT(FHDFN,"OP",FHRNUM,"SP",FHSO,0))
        ....S FHDATE=$P(FHNODE,U,4) I FHDATE>FHEDT Q
        ....S FHCDATE=$P(FHNODE,U,6) I FHCDATE'="" I FHCDATE<FHSDT Q
        ....S FHNUM=FHNUM+1,^TMP($J,"FH",FHOMDT,FHDFN,FHRNUM,"RMSO",FHNUM)=FHNODE
        ; Get special meals
        F FHOMDT=FHSDTX1:0 S FHOMDT=$O(^FHPT("SM",FHOMDT)) Q:FHOMDT=""!(FHOMDT'<FHEDT)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("SM",FHOMDT,FHDFN)) Q:FHDFN=""  D
        ..I '$D(^FHPT(FHDFN,0)) Q
        ..S FHNODE=$G(^FHPT(FHDFN,"SM",FHOMDT,0)) I $P(FHNODE,U,2)'="A" Q
        ..I $P($G(^FHPT(FHDFN,0)),U,3)="" Q
        ..S ^TMP($J,"FH",FHOMDT,FHDFN,"SM")=FHNODE I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        ; Get guest meals
        F FHOMDT=FHSDTX1:0 S FHOMDT=$O(^FHPT("GM",FHOMDT)) Q:FHOMDT=""!(FHOMDT'<FHEDT)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("GM",FHOMDT,FHDFN)) Q:FHDFN=""  D
        ..I '$D(^FHPT(FHDFN,0)) Q
        ..S FHNODE=$G(^FHPT(FHDFN,"GM",FHOMDT,0)) I $P(FHNODE,U,9)="C" Q
        ..I $P($G(^FHPT(FHDFN,0)),U,3)="" Q
        ..S ^TMP($J,"FH",FHOMDT,FHDFN,"GM")=FHNODE I '$D(^TMP($J,"FH","ZN",FHDFN)) S ^TMP($J,"FH","ZN",FHDFN)=^FHPT(FHDFN,0)
        Q
