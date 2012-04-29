PXRMTIU ;SLC/RMS,PKR - Clinical Reminder TIU routines. ; 07/21/2008
        ;;2.0;CLINICAL REMINDERS;**4,12**;Feb 04, 2005;Build 73
        ;==========================================================
NOTE(DFN,NGET,BDT,EDT,NFOUND,TEST,DATE,DATA,TEXT)       ;Computed finding
        ;for note title.
        S NFOUND=0
        Q:(TEST="")!(NGET=0)
        N ADDDATA,AUTH,DONE,EDTT,INVDATE,NGETABS,PIEN
        N SDIR,STATUS,TEMP,TIEN,TITLE,TYPE
        S TITLE=$P(TEST,U),STATUS=$P(TEST,U,2),ADDDATA=+$P(TEST,U,3)
        I STATUS="" S STATUS=7  ;COMPLETED IS THE DEFAULT
        S EDTT=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
        ;Invert and switch beginning and ending dates because the TIU index
        ;uses inverse dates.
        S INVDATE=BDT,BDT=9999999-EDTT,EDTT=9999999-INVDATE
        S SDIR=$S(NGET>0:1,1:-1)
        S INVDATE=$S(SDIR=+1:BDT-.000001,1:EDTT)
        S NGETABS=$S(NGET<0:-NGET,1:NGET)
        ;See if the note is passed as a title or an IEN.
        S (DONE,TIEN)=0
        I $E(TITLE,1)="`" D
        . S TIEN=$P(TITLE,"`",2)
        .;DBIA #2321
        . S TYPE=$P(^TIU(8925.1,TIEN,0),U,4)
        . I TYPE="DOC" S DONE=1,TITLE=$P(^TIU(8925.1,TIEN,0),U,1)
        E  D
        .;Find the ien for the title.
        .;DBIA #2321
        . F  Q:DONE  S TIEN=$O(^TIU(8925.1,"B",TITLE,TIEN)) Q:TIEN=""  D
        .. S TYPE=$P(^TIU(8925.1,TIEN,0),U,4)
        .. I TYPE="DOC" S DONE=1
        I 'DONE Q
        ;DBIA #2937
        F  S INVDATE=$O(^TIU(8925,"APT",DFN,TIEN,STATUS,INVDATE),SDIR)  Q:$S(INVDATE=0:1,NFOUND=NGETABS:1,INVDATE<BDT:1,INVDATE>EDTT:1,1:0)  D
        . S PIEN=$O(^TIU(8925,"APT",DFN,TIEN,STATUS,INVDATE,0)) Q:'+PIEN
        . S NFOUND=NFOUND+1
        . S TEST(NFOUND)=1
        . S DATE(NFOUND)=$P(^TIU(8925,PIEN,13),U)
        . S DATA(NFOUND,"VALUE")=TITLE
        . S DATA(NFOUND,"TITLE")=TITLE
        . S AUTH=+$P($G(^TIU(8925,PIEN,12)),U,2)
        . S AUTH=$S(AUTH>0:$$GET1^DIQ(200,AUTH,.01),1:"MISSING")
        . S DATA(NFOUND,"AUTH")=AUTH
        . S TEXT(NFOUND)="Author: "_AUTH
        . I ADDDATA D
        ..;DBIA #2834
        .. S TEMP=$$RESOLVE^TIUSRVLO(PIEN)
        .. S DATA(NFOUND,"DISPLAY NAME")=$P(TEMP,U,1)
        .. S DATA(NFOUND,"HOSPITAL LOCATION")=$P(TEMP,U,5)
        .. S DATA(NFOUND,"EPISODE BEGIN DATE/TIME")=$P(TEMP,U,7)
        .. S DATA(NFOUND,"EPISODE END DATE/TIME")=$P(TEMP,U,8)
        .. S DATA(NFOUND,"REQUESTING PACKAGE")=$P(TEMP,U,9)
        .. S DATA(NFOUND,"NUMBER OF IMAGES")=$P(TEMP,U,10)
        .. S DATA(NFOUND,"SUBJECT")=$P(TEMP,U,11)
        Q
        ;
