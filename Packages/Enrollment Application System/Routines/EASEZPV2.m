EASEZPV2        ;ALB/AMA/GTS/CMF - GATHER VISTA MEANS TEST DATA TO PRINT FROM DG OPTIONS ; 8/1/08 1:27pm
        ;;1.0;ENROLLMENT APPLICATION SYSTEM;**57,66,70**;Mar 15, 2001;Build 26
        ;
V408(EASDFN,EASMTIEN)   ;GATHER MEANS TEST DATA -- CALLED FROM VISTA^EASEZPVD
        ;   INPUT:
        ;      EASDFN - POINTER TO PATIENT FILE (#2)
        ;      EASMTIEN - MeansTestIEN (#408.31)
        N MTIFN,MTDT,INCREL
        S MTIFN=+$G(EASMTIEN)
        S MTDT=$$GET1^DIQ(408.31,MTIFN_",",.01,"I")
        ;
        ;GET DATA FROM FILES 408.12, 408.13, 408.21, AND 408.22
        D I408^EASEZPVI(EASDFN,MTDT,.INCREL)
        I $D(INCREL)>1 D
        . ;MODIFIED FROM A408^EASEZC2
        . N IENS,B,FILE,M,MM,TYPE,IEN,NSD,FLD,IEN2
        . N FFF,PERS,GRP,GRP1,SUBF,SUBIEN,WHERE
        . S IENS=$G(INCREL(408,"V",1))
        . ;ADD "INCOME YEAR" AND "DECLINES TO GIVE INFO" INTO ^TMP GLOBALS
        . N EZTMPIEN
        . S EZTMPIEN=$O(^TMP("EZDATA",$J,""),-1)+1
        . S ^TMP("EZDATA",$J,EZTMPIEN)="408.21^408.21^.01^IIC;999^Income Year"
        . S ^TMP("EZINDEX",$J,"A",408.21,408.21,.01,EZTMPIEN)=EZTMPIEN_"^APPLICANT INCOME YEAR"
        . S EZTMPIEN=EZTMPIEN+1
        . S ^TMP("EZDATA",$J,EZTMPIEN)="408.31^408.31^.14^IIC;998^Declines To Give Info"
        . S ^TMP("EZINDEX",$J,"A",408.31,408.31,.14,EZTMPIEN)=EZTMPIEN_"^APPLICANT DECLINES TO GIVE INFO"
        . I MTIFN>0 S B=0 D GET408(408.31,"A",MTIFN)
        . S IEN=$P(IENS,U,3),IEN2=$P(IENS,U,4)   ;EAS*66 - GENERATE ADJ EXP
        . I +IEN,+IEN2 D GROSS^DGMTSCU4(IEN,EASDFN,MTDT,IEN2)
        . ;
        . I IENS S B=0 F FILE=408.12,2,408.21,408.22 D GET408(FILE,"A",IENS)
        . ;MODIFIED FROM SP408^EASEZC2
        . S IENS=$G(INCREL(408,"S",1))
        . I IENS S B=0 F FILE=408.12,408.13,408.21,408.22 D GET408(FILE,"S",IENS)
        . ;EAS*1.0*70 -- GET SPOUSE GROSS ANNUAL INCOME AND NET WORTH
        . D SPGAINW
        . ;
        . ;MODIFIED FROM C1N408^EASEZC2
        . S (M,MM)=0 F  S M=$O(INCREL(408,"C",M)) Q:'M  D
        . . S IEN=+$P(INCREL(408,"C",M),U,2)
        . . S NSD="" F FLD=.01,.09,.03 D
        . . . S FFF=408.13_U_408.13_U_FLD,VDATA=$$GET^EASEZC1(IEN,FFF)
        . . . I FLD=.09 S VDATA=$$SSNOUT^EASEZT1(VDATA)
        . . . I FLD=.03 S VDATA=$$XDATE^EASEZT1(VDATA)
        . . . S NSD=NSD_VDATA_U
        . . I MM=0 D  I 1
        . . . S MM=1
        . . . S PERS("EZ","CHILD1",1)=NSD
        . . . S PERS("EZ","CHILD1",1,"IENS")=INCREL(408,"C",M)
        . . E  D
        . . . S PERS("EZ","CHILD(N)",MM)=NSD
        . . . S PERS("EZ","CHILD(N)",MM,"IENS")=INCREL(408,"C",M)
        . . . S MM=MM+1
        . ;
        . ;get identifying data for child in database
        . ;EAS*1.0*70 - duplicate the gross annual income entries
        . ;             for CHILD1, using the CHILD(N) index IENs
        . F FLD=.08,.14,.17 D
        . . S KEY=$O(^TMP("EZINDEX",$J,"CN",408.21,408.21,FLD,0)) Q:'KEY
        . . S ^TMP("EZINDEX",$J,"C1",408.21,408.21,FLD,KEY)=^TMP("EZINDEX",$J,"CN",408.21,408.21,FLD,KEY)
        . ;
        . F TYPE="CHILD1","CHILD(N)" S M=0 F  S M=$O(PERS("EZ",TYPE,M)) Q:'M  D
        . . S IENS=$G(PERS("EZ",TYPE,M,"IENS")) Q:IENS=""
        . . S GRP=$S(TYPE="CHILD1":"C1",1:"CN")
        . . ;associate each ien with file/subfile
        . . S B=0 F FILE=408.12,408.13,408.21,408.22 D
        . . . S B=B+1,IEN=+$P(IENS,U,B) Q:'IEN
        . . . I 'MTDT,((FILE=408.21)!(FILE=408.22)) Q
        . . . D CONT
        . . ;EAS*1.0*70
        . . S IEN=$P($G(PERS("EZ",TYPE,M,"IENS")),U,4) Q:'IEN
        . . N IATY S IATY=$$GET^EASEZC1(IEN,"408.22^408.22^.12")
        . . I IATY'="YES" D  Q
        . . . I EASVRSN>5.99,(TYPE="CHILD(N)") D DELETE(GRP,(M+1))
        . . . E  D DELETE(GRP,M)
        Q
        ;
GET408(FILE,SRCE,IENS)  ;GATHER THE DATA FROM THE 408 FILES
        ;   INPUT:
        ;      FILE - FILE TO SEARCH
        ;      SRCE - SOURCE OF DATA ("A"PPLICANT, "S"POUSE)
        ;      IENS - IEN FROM THE INCREL ARRAY
        ;
        N IEN,FLD,MAP,VDATA,KEY
        ;IF NO MEANS TEST, THEN DON'T GATHER ANY MONEY AMOUNTS
        I 'MTDT,((FILE=408.21)!(FILE=408.22)) Q
        S B=B+1,IEN=+$P(IENS,U,B) Q:'IEN  Q:FILE=2
        I (FILE=408.22),('MTIFN!($P($G(^DGMT(FILE,+IEN,"MT")),U)'=MTIFN)) Q
        S FLD=0 F  S FLD=$O(^TMP("EZINDEX",$J,SRCE,FILE,FILE,FLD)) Q:'FLD  D
        . S MAP=FILE_U_FILE_U_FLD
        . S VDATA=$$GET^EASEZC1(IEN,MAP)
        . I (FILE=408.31),(FLD=.14) D
        . . I (VDATA="")!(VDATA=0) S VDATA="NO"
        . . I VDATA=1 S VDATA="YES"
        . I (FILE=408.21) D
        . . I (FLD=.08) S VDATA=$$SUMSSI^EASEZT2(VDATA,IEN)
        . . I (FLD=2.01) S VDATA=$$SUMCASH^EASEZT2(VDATA,IEN)
        . . I (FLD=2.04) S VDATA=$$SUMPROP^EASEZT2(VDATA,IEN)
        . . Q
        . Q:VDATA=-1  Q:VDATA=""
        . I (SRCE="S"),(FILE=408.13),(FLD=.09) S VDATA=$$SSNOUT^EASEZT1(VDATA)
        . I (SRCE="S"),(FILE=408.13),(FLD=.03) S VDATA=$$XDATE^EASEZT1(VDATA)
        . S KEY=0 F  S KEY=$O(^TMP("EZINDEX",$J,SRCE,FILE,FILE,FLD,KEY)) Q:'KEY  D
        . . S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
        . . I (FILE=408.21),(SRCE="A") D
        . . . I ";2.01;2.03;2.04;"'[(";"_FLD_";") Q
        . . . N TEXT,NEWKEY
        . . . I FLD=2.01 S TEXT="APPLICANT CASH IN BANK2"
        . . . I FLD=2.03 S TEXT="APPLICANT REAL PROPERTY LESS MORTGAGES2"
        . . . I FLD=2.04 S TEXT="APPLICANT STOCKS BONDS ASSETS LESS DEBTS2"
        . . . S NEWKEY=+$$KEY711^EASEZU1(TEXT)
        . . . S ^TMP("EZDATA",$J,NEWKEY,1,2)=VDATA
        ;
        I (FILE=408.12),(SRCE="S") D
        . S SUBF=408.1275
        . S FLD=0 F  S FLD=$O(^TMP("EZINDEX",$J,SRCE,FILE,SUBF,FLD)) Q:'FLD  D
        . . S SUBIEN=$$I1275^EASEZI(IEN)
        . . S MAP=FILE_U_SUBF_U_FLD,WHERE=IEN_";"_SUBIEN
        . . S VDATA=$$GET^EASEZC1(WHERE,MAP)
        . . Q:VDATA=-1  Q:VDATA=""
        . . S KEY=0 F  S KEY=$O(^TMP("EZINDEX",$J,SRCE,FILE,SUBF,FLD,KEY)) Q:'KEY  D
        . . . S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
        Q
        ;
CONT    ;CONTINUATION OF CHILD FINANCIAL DATA
        ;
        I (FILE=408.22),('MTIFN!'IEN!($P($G(^DGMT(FILE,+IEN,"MT")),U)'=MTIFN)) Q
        S FLD=0 F  S FLD=$O(^TMP("EZINDEX",$J,GRP,FILE,FILE,FLD)) Q:FLD=""  D
        . S MAP=FILE_U_FILE_U_FLD
        . S GRP1=GRP I (EASVRSN>5.99),(FILE=408.21),("^.08^.14^.17^2.01^2.03^2.04^"[("^"_FLD_"^")) S GRP1="CN"
        . S VDATA=$$GET^EASEZC1(IEN,MAP)
        . I (FILE=408.21) D
        . . I (FLD=.08) S VDATA=$$SUMSSI^EASEZT2(VDATA,IEN)
        . . I (FLD=2.01) S VDATA=$$SUMCASH^EASEZT2(VDATA,IEN)
        . . I (FLD=2.04) S VDATA=$$SUMPROP^EASEZT2(VDATA,IEN)
        . . Q
        . Q:VDATA=-1  Q:VDATA=""
        . I (FILE=408.13),(FLD=.09) S VDATA=$$SSNOUT^EASEZT1(VDATA)
        . I (FILE=408.13),(FLD=.03) S VDATA=$$XDATE^EASEZT1(VDATA)
        . ;store link in all 1010EZ elements associated with this file/subfile
        . S KEY=$O(^TMP("EZINDEX",$J,GRP1,FILE,FILE,FLD,0)) Q:'KEY
        . S MM=M I EASVRSN>5.99,FILE=408.21,"^.08^.14^.17^2.01^2.03^2.04^"[("^"_FLD_"^") S:(TYPE="CHILD(N)") MM=M+1
        . S ^TMP("EZDATA",$J,KEY,MM,2)=VDATA
        ;get data in subfile #408.1275
        I FILE=408.12 S SUBF=408.1275 D
        . S FLD=0 F  S FLD=$O(^TMP("EZINDEX",$J,GRP,FILE,SUBF,FLD)) Q:FLD=""  D
        . . S SUBIEN=$$I1275^EASEZI(IEN)
        . . S MAP=FILE_U_SUBF_U_FLD,WHERE=IEN_";"_SUBIEN
        . . S VDATA=$$GET^EASEZC1(WHERE,MAP)
        . . Q:VDATA=-1  Q:VDATA=""
        . . ;store link in all 1010EZ elements associated with this file/subfile
        . . S KEY=0 F  S KEY=$O(^TMP("EZINDEX",$J,GRP,FILE,SUBF,FLD,KEY)) Q:'KEY  D
        . . . S ^TMP("EZDATA",$J,KEY,MM,2)=VDATA
        Q
SPGAINW ;Determine when to print Spouse's
        ;Gross Annual Income and Net Worth Amounts
        N IEN,MLY,LWSP,ACTSP
        S IEN=$P($G(INCREL(408,"V",1)),U,4) Q:'IEN
        S MLY=$$GET^EASEZC1(IEN,"408.22^408.22^.05")
        I MLY'="YES" D DELETE("S",1) Q
        ;
        S LWSP=$$GET^EASEZC1(IEN,"408.22^408.22^.06")
        S ACTSP=+$$GET^EASEZC1(IEN,"408.22^408.22^.07")
        I (LWSP'="YES"),(ACTSP<600) D DELETE("S",1) Q
        Q
DELETE(SRCE,MULT)       ;Delete dependent's GAI and NW amounts
        N FILE,FLD,KEY,X
        S FILE=408.21 F FLD=.08,.14,.17,2.01,2.03,2.04 D
        . S KEY=0 F  S KEY=$O(^TMP("EZINDEX",$J,SRCE,FILE,FILE,FLD,KEY)) Q:'KEY  D
        . . F X=1,2 K ^TMP("EZDATA",$J,KEY,MULT,X)
        Q
