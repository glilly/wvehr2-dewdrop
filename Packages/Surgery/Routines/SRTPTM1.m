SRTPTM1 ;BIR/SJA - TRANSPLANT TRANSMISSION ;04/29/08
        ;;3.0; Surgery ;**167**;24 Jun 93;Build 27
        ;
        N SRDTH,SRPID
        F I=0,.01,.02,.1,.11,.5,.55,1,3,10,11,"RA" S SRA(I)=$G(^SRT(SRTPP,I))
        S DFN=$P(SRA(0),"^") N I D DEM^VADPT S SRANAME=VADM(1),SEX=$P(VADM(5),"^"),Z=$P(VADM(3),"^"),SRSDATE=$E($P(SRA(0),"^",2),1,12),Y=$E(SRSDATE,1,7),AGE=$E(Y,1,3)-$E(Z,1,3)-($E(Y,4,7)<$E(Z,4,7))
        S SRPID=VA("PID"),SRPID=$TR(SRPID,"-","") ; remove hyphens from PID
        S SRDIV=$P($G(^SRT(SRTPP,8)),"^"),SRDIV=$S(SRDIV:$$GET1^DIQ(4,SRDIV,99),1:SRASITE)
        S SRCASE=$P(SRA(0),"^",3),SRTYPE=$P(SRA("RA"),"^",2),SRNOVA=$P(SRA("RA"),"^",5)
LN1     S SRSHEMP="#"_$J(SRASITE,3)_$J(SRTPP,7)_"  1"_DT_$J(AGE,3)_$J(SEX,1)_$J(SRSDATE,7)_$J(SRPID,20)_$J(SRDIV,6)_$J(SRCASE,10)
        S SRSHEMP=SRSHEMP_$J(SRTYPE,2)_$J(SRNOVA,1)_$J($P(SRA(.01),"^",11),6)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN2     S SRSHEMP=$E(SRSHEMP,1,11)_"  2",SRACNT=SRACNT+1
        S SRHD=$P(SRA(0),"^",4) I SRHD["C" S SRH="C",SRHD=$E(SRHD,1,$L(SRHD)-1)
        E  S SRH=" "
        S SRWD=$P(SRA(0),"^",5) I SRWD["K" S SRW="K",SRWD=$E(SRWD,1,$L(SRWD)-1)
        E  S SRW=" "
        S SRSHEMP=SRSHEMP_$J(SRHD,3)_SRH_$J(SRWD,3)_SRW
        S SRSHEMP=SRSHEMP_$J($P(SRA(0),"^",9),1)_$J($P(SRA(0),"^",10),2)_$J($P(SRA(0),"^",12),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(0),"^",13),14)_$J($P(SRA(0),"^",14),14)_$J($P(SRA(0),"^",15),14)
        S SRSHEMP=SRSHEMP_$J($P(VADM(3),"^"),7)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN3     S SRSHEMP=$E(SRSHEMP,1,11)_"  3",SRACNT=SRACNT+1
        S SRSDATE=$P(SRA(0),"^",11) S SRSHEMP=SRSHEMP_$J(SRSDATE,7)_$J($P(SRA(0),"^",19),3)_$J($P(SRA(0),"^",20),3)
        S SRSHEMP=SRSHEMP_$J($P(SRA(0),"^",21),2)_$J($P(SRA(0),"^",22),2)_$J($P(SRA(0),"^",23),2)_$J($P(SRA(.01),"^",10),2)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.01),"^",9),2)_$J($P(SRA(0),"^",8),2)
        S SRSDATE=$P(SRA(.01),"^") S SRSHEMP=SRSHEMP_$J(SRSDATE,7)_$J($P(SRA(.01),"^",2),1)_$J($P(SRA(.01),"^",3),2)_$J($P(SRA(.01),"^",4),2)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.01),"^",5),3)_$J($P(SRA(.01),"^",6),3)_$J($P(SRA(.01),"^",7),5)_$J($P(SRA(.01),"^",8),5)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN4     S SRSHEMP=$E(SRSHEMP,1,11)_"  4",SRACNT=SRACNT+1
        S SRSHEMP=SRSHEMP_$J($P(SRA(0),"^",6),3)_$J($P(SRA(0),"^",7),3)
        F I=1:1:11,13:1:24,26,27 S SRSHEMP=SRSHEMP_$J($P(SRA(.1),"^",I),1)
        F I=1:1:14,16:1:23 S SRSHEMP=SRSHEMP_$J($P(SRA(.11),"^",I),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.1),"^",12),1)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN5     S SRSHEMP=$E(SRSHEMP,1,11)_"  5",SRACNT=SRACNT+1
        S SRSHEMP=SRSHEMP_$J($P(SRA(.1),"^",25),50) F I=1:1:9 S SRSHEMP=SRSHEMP_$J($P(SRA(.5),"^",I),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.5),"^",10),2) F I=11:1:13 S SRSHEMP=SRSHEMP_$J($P(SRA(.5),"^",I),1)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN6     S SRSHEMP=$E(SRSHEMP,1,11)_"  6",SRACNT=SRACNT+1
        F I=14:1:23,25 S SRSHEMP=SRSHEMP_$J($P(SRA(.5),"^",I),1)
        F I=1:1:5 S NYUK=$P(SRA(.55),"^",I) D ONE S SRSHEMP=SRSHEMP_$J(MOE,1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.55),"^",6),2)
        F I=7:1:12 S SRSHEMP=SRSHEMP_$J($P(SRA(.55),"^",I),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.55),"^",13),4)_$J($P(SRA(.55),"^",14),3)_$J($P(SRA(.55),"^",15),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(.55),"^",16),1)_$J($P(SRA(.55),"^",17),2)
        F I=18:1:23 S SRSHEMP=SRSHEMP_$J($P(SRA(.55),"^",I),1)
        S SRHD=$P(SRA(1),"^",2) I SRHD["C" S SRH="C",SRHD=$E(SRHD,1,$L(SRHD)-1)
        E  S SRH=" "
        S SRWD=$P(SRA(1),"^",3) I SRWD["K" S SRW="K",SRWD=$E(SRWD,1,$L(SRWD)-1)
        E  S SRW=" "
        S SRSHEMP=SRSHEMP_$J(SRHD,3)_SRH_$J(SRWD,3)_SRW
        S SRSHEMP=SRSHEMP_$J($P(SRA(1),"^",5),1)_$J($P(SRA(1),"^",6),3)_$J($P(SRA(1),"^",8),2)_$J($P(SRA(1),"^",9),1)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN7     S SRSHEMP=$E(SRSHEMP,1,11)_"  7",SRACNT=SRACNT+1
        F I=10:1:13 S SRSHEMP=SRSHEMP_$J($P(SRA(1),"^",I),14)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN8     S SRSHEMP=$E(SRSHEMP,1,11)_"  8",SRACNT=SRACNT+1
        S SRSHEMP=SRSHEMP_$J($P(SRA(1),"^",14),14)_$J($P(SRA(1),"^",15),14)
        S NYUK=$P(SRA(1),"^",4) D ONE S SRSHEMP=SRSHEMP_MOE
        ;Multiple races for donor
        S SRORCE=0,SRORAC="",SRORACE="",SRORCD=""
        F  S SRORCE=$O(^SRT(SRTPP,44,SRORCE)) Q:'SRORCE  D
        .S SRORAC=$G(^SRT(SRTPP,44,SRORCE,0))
        .S SRORACE=SRORACE_$J(SRORAC,1)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP_SRORACE
LN9     S SRSHEMP=$E(SRSHEMP,1,11)_"  9",SRACNT=SRACNT+1
        S SRSHEMP=SRSHEMP_$J($P(SRA(3),"^",4),4)_$J($P(SRA(3),"^",5),4)_$J($P(SRA(3),"^",6),4)_$J($P(SRA(3),"^",7),1)_$J($P(SRA(1),"^",1),7)
        S NYUK=$J($P(SRA(3),"^"),1) D ONE S SRSHEMP=SRSHEMP_MOE S NYUK=$J($P(SRA(3),"^",2),1) D ONE S SRSHEMP=SRSHEMP_MOE
        S NYUK=$P(SRA(3),"^",3) D ONE S SRSHEMP=SRSHEMP_MOE
        F I=1:1:12 S SRSHEMP=SRSHEMP_$J($P(SRA(10),"^",I),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(10),"^",13),7) F I=14:1:18 S SRSHEMP=SRSHEMP_$J($P(SRA(10),"^",I),1)
        S SRSHEMP=SRSHEMP_$J($P(SRA(10),"^",19),12)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN10    S SRSHEMP=$E(SRSHEMP,1,11)_" 10",SRACNT=SRACNT+1
        F I=1:1:9 S NYUK=$P(SRA(11),"^",I) D ONE S SRSHEMP=SRSHEMP_$J(MOE,$S(I=2:3,I=3:3,I=5:4,I=6:4,I=7:4,1:1))
        ;Ethnicity contained in VADM(11)
        N SROETCD,SROPTF S SROETCD="",SROPTF=""
        S SROETCD=$P($G(VADM(11,1)),U,1)            ;Ethnicity code
        S SROPTF=$$PTR2CODE^DGUTL4(SROETCD,2,4)     ;PTF Ethnicity code
        S SRSHEMP=SRSHEMP_$J($G(SROPTF),1)   ;Ethnicity
        ;Multiple races contained in VADM(12)
        N SRORAC,SRORCD,SRORCE S SRORCE=0,SRORAC="",SRORACE="",SRORCD=""
        F  S SRORCE=$O(VADM(12,SRORCE)) Q:SRORCE=""  D
        .S SRORAC=$P($G(VADM(12,SRORCE)),U,1)        ;Race code
        .S SRORCD=$$PTR2CODE^DGUTL4(SRORAC,1,4)     ;PTF race code
        .S SRORACE=SRORACE_$J(SRORCD,1)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP_SRORACE
LN11    S SRSHEMP=$E(SRSHEMP,1,11)_" 11",SRACNT=SRACNT+1
        F I=16:1:18 S SRSHEMP=SRSHEMP_$J($P(SRA(0),"^",I),14)
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP
LN12    S SRSHEMP=$E(SRSHEMP,1,11)_" 12",SRACNT=SRACNT+1
        ; Transplant Comments field
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP_$E($P(SRA(.02),"^"),1,66)
LN13    S SRSHEMP=$E(SRSHEMP,1,11)_" 13",SRACNT=SRACNT+1
        S TMP("SRA",$J,SRAMNUM,SRACNT,0)=SRSHEMP_$E($P(SRA(.02),"^"),67,130)
        D ^SRTPTM2
        Q
ONE     S MOE=$S(NYUK="NS":"S",NYUK="":" ",1:NYUK)
        Q
