IMRLAB ;HCIOFO/SPS/FAI - LABORATORY DATA EXTRACT; 08/24/00  12:33
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**8,9,5,13,16,15**;Feb 09, 1998
CHK ; Called from IMRDAT1 routine
 N DA,DIE,DR,I,IMRCD4,IMRCD,IMRCDX,IMRCDXD,IMRCHL,IMRCST,IMRD
 N IMRLRTY,IMRNAM,IMRNLAB,IMRRD,IMRRFN,IMRRJ,IMRRJ1,IMRRK,IMRRL
 N IMRRTYP,IMRRX,IMRRX1,IMRRX2,IMRRX3,IMRRX4
 N IMRPR4,IMRSFLG,IMRTEXT,IMRTST,IMRVAL,IMRXCAT
 S IMRMI=0,IMRLAB=0
 Q:'$D(^DPT(DFN,"LR"))  ;quit if no lab data for patient
 ; gather data for CHL segment from File 63 (Lab Data)
 ; Restructering the data gathering of patient lab data
 ; 1) Loop through the lab file for all data for that patient and grab
 ; it.
 K ^TMP($J,"IMRCNT")
 S IMRRFN=^DPT(DFN,"LR"),I=0
 S IMRLABTR="CH^MI^"
 I +$G(IMRTRANS) S IMRLABTR=IMRLABTR_"SP^CY^"
 F I=1:1:$S($G(IMRTRANS)=1:7,1:2) S IMRRTYP=$P(IMRLABTR,U,I) Q:IMRRTYP=""  D LAB^IMRLAB(IMRRFN,IMRRTYP,IMRSD,IMRED)
 Q
 ;
LAB(IMRRFN,IMRRTYP,IMRSD,IMRED) ;
 ; This routine will Loop thourgh the lab global for the given
 ; type and process the data
 ; IMRRFN=Patient Lab DFN
 ; IMRRTYP=Type of lab test "CH,MI,..."
 ; IMRRD=the date to start the search in a reverse order
 ;
 N I,IMRLCT,IMRRD
 I IMRRTYP="MI" D MIFILE Q
 S IMRRD=(9999999-(IMRED+1))
 S IMRLCT=$P($G(^LR(IMRRFN,IMRRTYP,0)),U,3) Q:IMRLCT=""
 Q:IMRLCT<1
 S IMRLCT=(9999999-IMRLCT)
 Q:(IMRLCT<IMRSD)  ; There is no lab test after this date
 F  S IMRRD=$O(^LR(IMRRFN,IMRRTYP,IMRRD)) Q:IMRRD<1  D
 . N IMRDUZ,IMRH,IMRGD
 . I '$D(^LR(IMRRFN,IMRRTYP,IMRRD,0)) Q
 . S IMRGD=9999999-IMRRD
 . Q:(IMRGD<IMRSD)
 . Q:(IMRGD>IMRED)
 . S IMRD=+$P($G(^LR(IMRRFN,IMRRTYP,IMRRD,0)),"^",1) S:IMRD>IMRLAB IMRLAB=IMRD
 . S IMRTST=0
 . F  S IMRTST=$O(^LR(IMRRFN,IMRRTYP,IMRRD,IMRTST)) Q:IMRTST'>0  D
 .. I IMRTST'>1 Q
 .. S IMRVAL=$G(^LR(IMRRFN,IMRRTYP,IMRRD,IMRTST))
 .. Q:IMRVAL=""
 .. N IMRLINE,IMRNODE,IMRDD,IMRCDD,IMRDD
 .. I $P(IMRVAL,U)["canc" Q  ; test has been canceled.
 .. I $P(IMRVAL,U)["CANC" Q  ; test has been canceled.
 .. S IMRVALUE=$P(IMRVAL,U,1,2)
 .. S IMRLABT=$O(^LAB(60,"C",(IMRRTYP_";"_IMRTST_";1"),0)) ; get the lab test data name
 .. I IMRLABT="" S IMRLABT="**PANEL**",(IMRNAM,IMRCST,IMRNLAB)=""
 .. E  D
 ... S (IMNLT,IMWKL,IMRNAM,IMRCST,IMRNLAB)=""
 ... S IMRLINE=$G(^LAB(60,IMRLABT,0))
 ... Q:IMRLINE=""
 ... S IMRCST=$$GET1^DIQ(60,IMRLABT,1,"I")
 ... I IMRCST="" S IMRCST="COST UNKNOWN"
 ... S IMRNAM=$$GET1^DIQ(60,IMRLABT,.01,"I")
 ... Q:IMRNAM=""
 ... S IMWKL=$P($G(^LAB(60,IMRLABT,64)),U,1)
 ... S:IMWKL'="" IMNLT=$$GET1^DIQ(64,IMWKL,1,"E")
 ... S:$G(IMNLT)="" IMNLT="NONLT"
 ... D NLAB^IMRUTL ;get national lab name
 ... S IMNLT=$E(IMNLT,1,5) ; get National lab test pointer
 ... Q
 .. D FILE
 .. Q
 . Q
 Q
FILE ; File the code based on IMRRTYP
 K IMRHLDR
 I IMRRTYP="CH" D CHFILE
 I IMRRTYP="SP" D SPFILE
 I IMRRTYP="CY" D CYFILE
 Q
MIFILE ; the MI code to file it in temp
 N IMRX,IMRRX,IMRVALL
 S IMRRD=""
 F  S IMRRD=$O(^LR(IMRRFN,IMRRTYP,IMRRD)) Q:IMRRD=""  D
 .I '$D(^LR(IMRRFN,IMRRTYP,IMRRD,1)) Q
 .S IMRRCD=$G(^LR(IMRRFN,IMRRTYP,IMRRD,1))
 .Q:IMRRCD=""  Q:$P(IMRRCD,U,2)'="F"
 .S IMRRCD=$P(IMRRCD,U)
 .Q:IMRRCD<IMRSD
 .Q:IMRRCD>IMRED
 .S IMRVALL=$G(^LR(IMRRFN,IMRRTYP,IMRRD,0))
 .S IMRRX=IMRRTYP_U_(+$P(IMRVALL,U,1)\1)
 .S IMRRX=IMRRX_U_$P($G(^LAB(61,(+$P(IMRVALL,U,5)),0)),U)_U_$P($G(^LAB(62,(+$P(IMRVALL,U,11)),0)),U)
 .I $D(^LR(IMRRFN,IMRRTYP,IMRRD,1)) S IMRX=1 D BAC^IMRLAB2
 .I $D(^LR(IMRRFN,IMRRTYP,IMRRD,2,0)) S IMRX=2 D GRAM^IMRLAB2
 .I $D(^LR(IMRRFN,IMRRTYP,IMRRD,3,0)) S IMRX=3 D ORG^IMRLAB2
 .I $D(^LR(IMRRFN,IMRRTYP,IMRRD,6,0)) S IMRX=6 D PAR^IMRLAB2
 .I $D(^LR(IMRRFN,IMRRTYP,IMRRD,7,0)) S IMRX=7 D PARRPT^IMRLAB2
 .I $D(^LR(IMRRFN,IMRRTYP,IMRRD,99)) S IMRX=99 D COMSP^IMRLAB2
 S (IMRCHL,IMRSEND)=1
 Q
SPFILE ; the CH code to file it in temp
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)=$S(IMRRTYP="CH":"CHL",1:IMRRTYP)_U_(IMRD\1)_U_IMRNAM_U_IMRTST_U_IMRCST_U_IMRVALUE D LCHK^IMRDAT ;IMRVALUE is 2 pieces; data value and test result flag
 I $G(IMRTRANS)
 S (IMRCHL,IMRSEND)=1
 ; same as CH
 ;
 Q
CYFILE ; the CH code to file it in temp
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)=$S(IMRRTYP="CH":"CHL",1:IMRRTYP)_U_(IMRD\1)_U_IMRNAM_U_IMRTST_U_IMRCST_U_IMRVALUE D LCHK^IMRDAT ;IMRVALUE is 2 pieces; data value and test result flag
 I $G(IMRTRANS)
 S (IMRCHL,IMRSEND)=1
 ; same as CH
 Q
CHFILE ; the CH code to file it in temp
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)=$S(IMRRTYP="CH":"CHL",1:IMRRTYP)_U_(IMRD\1)_U_IMRNAM_U_IMRTST_U_IMRCST_U_IMRVALUE ;IMRVALUE is 2 pieces; data value and test result flag
 S $P(^TMP($J,"IMRX",IMRC),U,8)=IMRNLAB ;national lab name or pointer
 S $P(^TMP($J,"IMRX",IMRC),U,9)=IMNLT ; workload code
 D ^IMRLBTY
 D LCHK^IMRDAT
 I $G(IMRTRANS)
 S (IMRCHL,IMRSEND)=1
 ; piece 2 (IMRD)=date specimen taken
 ; piece 3 (IMRNAM)=name of test
 ; piece 4 (IMRTST)=node of test
 ; piece 5 (IMRCST)=test cost
 ; piece 6 & 7(IMRVALUE)=data value^test result flag
 ; piece 8 (IMRNLAB)=national lab name or pointer
 ; piece 9 (IMNLT)=workload code file 64
 Q
