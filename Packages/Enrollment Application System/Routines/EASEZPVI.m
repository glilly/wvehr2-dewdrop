EASEZPVI        ;ALB/AMA,ERC; GATHER VISTA INSURANCE DATA TO PRINT FROM DG OPTIONS ; 06 Jul 2005  1:45 PM
        ;;1.0;ENROLLMENT APPLICATION SYSTEM;**57,70**;Mar 15, 2001;Build 26
        ;
        Q
        ;
INSUR(EASDFN)   ;GET INSURANCE DATA
        ;   INPUT:
        ;      EASDFN - POINTER TO THE PATIENT FILE
        ;
        ;IF THEY EXIST, FIND INSURANCE COMPANY NAME(S), ADDRESS,
        ;CITY, STATE, ZIP, PHONE, GROUP CODE(S), POLICY NUMBER(S),
        ;NAME(S) OF INSURED, MEDICARE PART A/B, AND EFFECTIVE DATE(S)
        ;
        N KEY,VDATA,MULTIPLE,INDA,IENS,INSUR,INSORT,FLD,TYPE,IEN,INPTR,NAME
        N STREET,CITY,STPTR,STATE,ZIP,PHONE,GRPCD,POLNO,INNAME,KEYNM,M,CAT
        S KEY=+$$KEY711^EASEZU1("APPLICANT HAS INSURANCE")
        S VDATA=$$GET^EASEZC1(EASDFN,"2^2^.3192")
        I (VDATA=-1)!(VDATA="") S ^TMP("EZDATA",$J,KEY,1,2)="UNKNOWN"
        I (VDATA'=-1),(VDATA'="") S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
        Q:VDATA'="YES"
        ;
        S MULTIPLE=0
        S INDA=0 F  S INDA=$O(^DPT(EASDFN,.312,INDA)) Q:'INDA  D
        . D GETS^DIQ(2.312,INDA_","_EASDFN,"**","IE","INSUR")
        S IENS="" F  S IENS=$O(INSUR(2.312,IENS)) Q:IENS=""  D
        . S FLD=0 F  S FLD=$O(INSUR(2.312,IENS,FLD)) Q:'FLD  D
        . . F TYPE="E","I" S INSORT(2.312,+IENS,FLD,TYPE)=$G(INSUR(2.312,IENS,FLD,TYPE))
        K INSUR
        S IEN=0 F  S IEN=$O(INSORT(2.312,IEN)) Q:'IEN  D
        . Q:'$G(INSORT(2.312,IEN,.18,"I"))
        . S INPTR=INSORT(2.312,IEN,.18,"I")
        . Q:$$GET1^DIQ(355.3,INPTR,.11,"I")   ;INACTIVE FLAG
        . I DT'>$G(INSORT(2.312,IEN,3,"I")) Q   ;INSUR EXPIRATION DATE
        . S NAME=$G(INSORT(2.312,IEN,.18,"E"))
        . S STREET=$$GET1^DIQ(36,INPTR,.111),CITY=$$GET1^DIQ(36,INPTR,.114)
        . S STPTR=$$GET1^DIQ(36,INPTR,.115,"I"),STATE=$$GET1^DIQ(5,STPTR,1)
        . S ZIP=$$GET1^DIQ(36,INPTR,.116),PHONE=$$GET1^DIQ(36,INPTR,.131)
        . S GRPCD=$$GET1^DIQ(355.3,INPTR,.04),POLNO=$G(INSORT(2.312,IEN,1,"E"))
        . S INNAME=$G(INSORT(2.312,IEN,17,"E"))
        . S MULTIPLE=MULTIPLE+1
        . I MULTIPLE=1 S KEYNM="APPLICANT",M=1
        . E  S KEYNM="OTHER(N)",M=MULTIPLE-1
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE COMPANY")
        . I NAME]"" S ^TMP("EZDATA",$J,KEY,M,2)=NAME
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE ADDRESS")
        . I STREET]"" S ^TMP("EZDATA",$J,KEY,M,2)=STREET
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE CITY")
        . I CITY]"" S ^TMP("EZDATA",$J,KEY,M,2)=CITY
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE STATE")
        . I STATE]"" S ^TMP("EZDATA",$J,KEY,M,2)=STATE
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE ZIP")
        . I ZIP]"" S ^TMP("EZDATA",$J,KEY,M,2)=ZIP
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE PHONE")
        . I PHONE]"" S ^TMP("EZDATA",$J,KEY,M,2)=PHONE
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE GROUP CODE")
        . I GRPCD]"" S ^TMP("EZDATA",$J,KEY,M,2)=GRPCD
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE POLICY HOLDER")
        . I INNAME]"" S ^TMP("EZDATA",$J,KEY,M,2)=INNAME
        . S KEY=+$$KEY711^EASEZU1(KEYNM_" INSURANCE POLICY NUMBER")
        . I POLNO]"" S ^TMP("EZDATA",$J,KEY,M,2)=POLNO
        . ;
        . I $$GET^EASEZC1(INPTR,"355.3^355.3^.09")="MEDICARE (M)" D
        . . S CAT=$$GET^EASEZC1(INPTR,"355.3^355.3^.14")
        . . I (CAT'="MEDICARE PART A"),(CAT'="MEDICARE PART B") Q
        . . S KEY=+$$KEY711^EASEZU1(CAT)
        . . S ^TMP("EZDATA",$J,KEY,M,2)="YES"
        . . S VDATA=$$GET^EASEZC1(EASDFN_";"_INDA,"2^2.312^8")
        . . Q:VDATA=""  Q:VDATA=-1
        . . S KEY=+$$KEY711^EASEZU1(CAT_" EFFECTIVE DATE")
        . . S ^TMP("EZDATA",$J,KEY,M,2)=VDATA
        ;
        Q
        ;
I408(EASDFN,MTDT,EASARRAY)      ;retrieve ien(s) to files #408.12,#408.13,#408.21,#408.22
        ;   Modified from I408^EASEZI, called from V408^EASEZPV2
        ;input EASDFN    = ien to #2
        ;        MTDT    = Means Test date
        ;output EASARRAY = ien(s) to files; passed by reference
        ;   array(408,"V",1) = ien_#408.12^ien_#408.13^ien_#408.21^ien#408.22 ;veteran data
        ;   array(408,"S",1) = ien_#408.12^ien_#408.13^ien_#408.21^ien#408.22 ;spouse data
        ;   array(408,"C",multiple) = ien_#408.12^ien_#408.13^ien_#408.21^ien#408.22 ;child data
        ;where ien_#408.13 = ien;global_root
        ;
        N Y,%F,X,%DT,MTDATE
        N SUB1,SUB2,INCYR,DGINC,DGREL,DGINR
        N I21,I22
        ;
        Q:'EASDFN
        S Y=MTDT,%F=5,X=$$FMTE^XLFDT(Y,%F),X=+$P(X,"/",3)-1,%DT="P"
        D ^%DT S MTDATE=Y
        ;retrieve all associated 408 records; refer to api call for docu
        I MTDT D ALL^DGMTU21(EASDFN,"VSC",MTDT)
        ;massage "V" and "S" nodes for clear use in for loop below
        S:$D(DGINC("V")) DGINC("V",1)=DGINC("V")
        S:$D(DGINR("V")) DGINR("V",1)=DGINR("V")
        S:$D(DGREL("V")) DGREL("V",1)=DGREL("V")
        S:$D(DGINC("S")) DGINC("S",1)=DGINC("S")
        S:$D(DGINR("S")) DGINR("S",1)=DGINR("S")
        S:$D(DGREL("S")) DGREL("S",1)=DGREL("S")
        ;
        F SUB1="V","S","C" D
        . Q:'$D(DGREL(SUB1))
        . S SUB2=0
        . F  S SUB2=$O(DGREL(SUB1,SUB2)) Q:'SUB2  D
        . . S EASARRAY(408,SUB1,SUB2)=DGREL(SUB1,SUB2)
        . . S I21=$G(DGINC(SUB1,SUB2))  ; 408.21 ien
        . . Q:'I21
        . . S INCYR=$$GET1^DIQ(408.21,I21_",",.01,"I")
        . . ;NOTE: The following two quit conditions are probably not
        . . ;      not necessary given the arrays being returned from
        . . ;      ALL^DGMTU21
        . . Q:'MTDT
        . . Q:(INCYR<MTDATE)
        . . S I22=$G(DGINR(SUB1,SUB2))  ;408.22 ien
        . . Q:$G(^DGMT(408.22,+I22,"MT"))=""
        . . ;
        . . S EASARRAY(408,SUB1,SUB2)=EASARRAY(408,SUB1,SUB2)_U_I21_U_I22
        Q
        ;
