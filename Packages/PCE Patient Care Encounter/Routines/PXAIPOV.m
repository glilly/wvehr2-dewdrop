PXAIPOV ;ISL/JVS,ESW - SET THE DIAGNOSIS/PROBLEM LIST NODES ;6/25/03 2:05pm
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**28,73,69,108,112,130,124,174,168**;Aug 12, 1996;Build 14
        ;
        Q
POV     ;--CREATE DIAGNOSIS
        ;
SET     ;--SET AND NEW VARIABLES
        N AFTER0,AFTER12,AFTER800,AFTER801,AFTER811,AFTER802,AFTER812
        N BEFOR0,BEFOR12,BEFOR800,BEFOR801,BEFOR811,BEFOR802,BEFOR812
        N PXAA,PXAB,SUB,PIECE,PXAAX,IENB,STOP,VAR,AFTER8A
        N FPRI,J,LNARR,GMPSAVED,NOPLLIST,PXDIGNS,VAR,PRI
        N POVI,PRVDR,PXBCNT,PXBCNTPL,PXBKY,PXBPMT,PXBSAM,PXBSKY,PXKDONE
        ;
        K PXAERR
        S PXAERR(8)=PXAK
        S PXAERR(7)="DX/PL"
        ;
        S SUB="" F  S SUB=$O(@PXADATA@("DX/PL",PXAK,SUB)) Q:SUB=""  D
        .S PXAA(SUB)=@PXADATA@("DX/PL",PXAK,SUB)
        ;
        ;--VALIDATE ENOUGH DATA
        D VAL^PXAIPOVV Q:$G(STOP)
        ;
SETVARA ;--SET VISIT VARIABLES
        S $P(AFTER0,"^",1)=$G(PXAA("DIAGNOSIS"))
        I $G(PXAA("DELETE")) S $P(AFTER0,"^",1)="@"
        S $P(AFTER0,"^",2)=$G(PATIENT),PXAA("PATIENT")=$G(PATIENT)
        S $P(AFTER0,"^",3)=$G(PXAVISIT)
        S $P(AFTER0,"^",4)=$G(PXAA("NARRATIVE")) D
        .I $G(PXAA("NARRATIVE"))']""!($L($G(PXAA("NARRATIVE")))>245) D
        ..S PXAA("NARRATIVE")=$$EXTTEXT^PXUTL1($G(PXAA("DIAGNOSIS")),1,80,10,3) ;--TEXT OF NARRATIVE
        .S $P(AFTER0,"^",4)=+$$PROVNARR^PXAPI($G(PXAA("NARRATIVE")),9000010.07)
        ;PX*1*124
        S $P(AFTER0,"^",12)=$S($G(PXAA("PRIMARY"))=1:"P",$G(PXAA("PRIMARY"))="P":"P",1:"S")
        ;--ADDED FOR PATCH 28
        S $P(AFTER0,"^",15)=$G(PXAA("LEXICON TERM"))
        S $P(AFTER0,"^",16)=$G(PXAA("PL IEN"))
        S $P(AFTER0,"^",17)=$G(PXAA("ORD/RES"))
        ;--END OF NEW PATCH 28
        S $P(AFTER12,"^",1)=$G(PXAA("EVENT D/T"))
        S $P(AFTER12,"^",4)=$G(PXAA("ENC PROVIDER"))
        ;PX*1*108
        I $G(PXAA("ENC PROVIDER"))]"",'$G(PXAA("DELETE")) D
        .S ^TMP("PXAIADDPRV",$J,$G(PXAA("ENC PROVIDER")))=""
        ;
        I $G(PXAA("CATEGORY"))]"" S $P(AFTER802,"^",1)=+$$PROVNARR^PXAPI($G(PXAA("CATEGORY")),9000010.07)
        S $P(AFTER811,"^",1)=$G(PXAA("COMMENT"))
        ;
        S $P(AFTER800,"^",1)=$G(PXAA("PL SC"))
        S $P(AFTER800,"^",2)=$G(PXAA("PL AO"))
        S $P(AFTER800,"^",3)=$G(PXAA("PL IR"))
        S $P(AFTER800,"^",4)=$G(PXAA("PL EC"))
        S $P(AFTER800,"^",5)=$G(PXAA("PL MST"))
        S $P(AFTER800,"^",6)=$G(PXAA("PL HNC"))
        S $P(AFTER800,"^",7)=$G(PXAA("PL CV"))
        S $P(AFTER800,"^",8)=$G(PXAA("PL SHAD"))
        ;
        D SCC^PXUTLSCC(PATIENT,$P($G(^AUPNVSIT(PXAVISIT,0)),"^",1),$P($G(^AUPNVSIT(PXAVISIT,0)),"^",22),$G(PXAVISIT),AFTER800,.AFTER800)
        ;
        I $G(PXAA("PL SC"))="" S $P(AFTER800,"^",1)=""
        I $G(PXAA("PL AO"))="" S $P(AFTER800,"^",2)=""
        I $G(PXAA("PL IR"))="" S $P(AFTER800,"^",3)=""
        I $G(PXAA("PL EC"))="" S $P(AFTER800,"^",4)=""
        I $G(PXAA("PL MST"))="" S $P(AFTER800,"^",5)=""
        I $G(PXAA("PL HNC"))="" S $P(AFTER800,"^",6)=""
        I $G(PXAA("PL CV"))="" S $P(AFTER800,"^",7)=""
        I $G(PXAA("PL SHAD"))="" S $P(AFTER800,"^",8)=""
        ;
        S $P(AFTER812,"^",3)=$G(PXASOURC)
        S $P(AFTER812,"^",2)=$G(PXAPKG)
        ;
        D PL^PXAIPL
        ;
        ;
SETPXKA ;--SET PXK ARRAY AFTER
        S ^TMP("PXK",$J,"POV",PXAK,0,"AFTER")=$G(AFTER0)
        S ^TMP("PXK",$J,"POV",PXAK,12,"AFTER")=$G(AFTER12)
        S ^TMP("PXK",$J,"POV",PXAK,800,"AFTER")=$G(AFTER800)
        S ^TMP("PXK",$J,"POV",PXAK,802,"AFTER")=$G(AFTER802)
        S ^TMP("PXK",$J,"POV",PXAK,811,"AFTER")=$G(AFTER811)
        S ^TMP("PXK",$J,"POV",PXAK,812,"AFTER")=$G(AFTER812)
        ;
SETVARB ;--SET VARIABLES BEFORE
        ;
        ;--GET IEN FOR 'PXK NODE'
        D POV^PXBGPOV(PXAVISIT)
        I $D(^TMP("PXBGPOVMATCH",$J,$G(PXAA("DIAGNOSIS")))) D
        .S (^TMP("PXK",$J,"POV",PXAK,"IEN"),IENB)=$O(^TMP("PXBGPOVMATCH",$J,$G(PXAA("DIAGNOSIS")),0))
        K ^TMP("PXBGPOVMATCH",$J)
        ;
BEFOR   ;
        I $G(IENB) D
        .F PIECE=0,12,800,802,811 S ^TMP("PXK",$J,"POV",PXAK,PIECE,"BEFORE")=$G(^AUPNVPOV(IENB,PIECE))
        .K ^TMP("PXK",$J,"POV",PXAK,812)
        E  D
        .S (BEFOR0,BEFOR12,BEFOR800,BEFOR802,BEFOR811,BEFOR812)=""
        .;
SETPXKB .;--SET PXK ARRAY BEFORE
        .S ^TMP("PXK",$J,"POV",PXAK,0,"BEFORE")=$G(BEFOR0)
        .S ^TMP("PXK",$J,"POV",PXAK,12,"BEFORE")=$G(BEFOR12)
        .S ^TMP("PXK",$J,"POV",PXAK,800,"BEFORE")=$G(BEFOR800)
        .S ^TMP("PXK",$J,"POV",PXAK,802,"BEFORE")=$G(BEFOR802)
        .S ^TMP("PXK",$J,"POV",PXAK,811,"BEFORE")=$G(BEFOR811)
        .S ^TMP("PXK",$J,"POV",PXAK,812,"BEFORE")=$G(BEFOR812)
        .S ^TMP("PXK",$J,"POV",PXAK,"IEN")=""
        ;
MISC    ;--MISCELLANEOUS NODE
        ;
        Q
PRIM    ;--SET A PROVIDER AS PRIMARY
        N PXBCNT,PXBKY,PXBSAM,PXBSKY,PRVDR,FPRI ;108
        D PRV^PXBGPRV(PXAVISIT,.PXBSKY,.PXBKY,.PXBSAM,.PXBCNT,.PRVDR,.FPRI) ;108
        I $D(PRVDR) Q
        I '$D(PXBSKY) Q
        ;
        S $P(AFTER0,"^",1)=$P(^AUPNVPRV($O(PXBSKY(1,0)),0),"^",1)
        S $P(AFTER0,"^",2)=$P(^AUPNVSIT(PXAVISIT,0),"^",5)
        S $P(AFTER0,"^",3)=PXAVISIT
        S $P(AFTER0,"^",4)="P"
        S ^TMP("PXK",$J,"PRV",22222,0,"AFTER")=AFTER0
        S ^TMP("PXK",$J,"PRV",22222,0,"BEFORE")=$G(^AUPNVPRV($O(PXBSKY(1,0)),0))
        S ^TMP("PXK",$J,"PRV",22222,"IEN")=$O(PXBSKY(1,0))
        D EN1^PXKMAIN
        K PXRDR
        K ^TMP("PXBGPOVMATCH",$J)
        Q
