GMRAOR3 ;HIRMFO/RM,WAA-ORDERABLE LIST UTILITIES ; 11/29/07 12:17pm
        ;;4.0;Adverse Reaction Tracking;**13,41**;Mar 29, 1996;Build 8
        ;;THIS ROUTINE IS NO LONGER IN USE THUS THE REFERENCES TO PHARMACY
        ;;GLOBALS DO NOT NEED TO BE REMOVED
        ;;THIS ROUTINE MAY BE DELETED ON SOME FUTURE DATE
        ;
EN1(START,NUM,ARRAY)    ; ENTRY POINT WHERE ALL VARIABLES ARE OPTIONAL.
        ;  START IS THE STARTING POINT OF LIST TO BE RETURNED, NUM IS
        ;  THE NUMBER OF ENTRIES FROM STARTING POINT TO INCLUDE IN LIST,
        ;  AND ARRAY IS THE ADDRESS OF THE ARRAY LIST IS TO BE RETURNED.
        ;
        K:$G(START)="" START ; Force list to start at "A" and skip num./punc.
        S START=$G(START,"A"),NUM=$G(NUM),ARRAY=$G(ARRAY,"GMRALST")
        K ^TMP($J,"GMRALST")
NODE    ;Loop through each file in order of X-ref.
        ;
        ; Loop through GMR Allergies file.
        S GMRAST=START
        F GMRACNT=1:1 Q:NUM&(GMRACNT>NUM)  S GMRAST=$O(^GMRD(120.82,"B",GMRAST)) Q:GMRAST=""  S GMRAIEN=$O(^(GMRAST,"")) I GMRAIEN>0 D FILE("ALL",0)
        ;
        ; Loop through VA Drug Class file.
        ; THIS ROUTINE IS NOT IN USE THUS THE DIRECT PHARMACY READ DOES NOT
        ; NEED TO BE UPDATED
        S GMRAST=START
        F GMRACNT=1:1 Q:NUM&(GMRACNT>NUM)  S GMRAST=$O(^PS(50.605,"C",GMRAST)) Q:GMRAST=""  S GMRAIEN=$O(^(GMRAST,"")) I GMRAIEN>0 D FILE("PSC",0)
        ;
        ; Loop through NDF File (B X-ref)
        ; $$B^PSNAPIS returns NDF version dependent root of "B" x-ref
        ; THIS ROUTINE IS NOT IN USE THUS THE DIRECT PHARMACY READ DOES NOT
        ; NEED TO BE UPDATED
        S GMRAST=START
        F GMRACNT=1:1 Q:NUM&(GMRACNT>NUM)  S GMRAST=$O(@($$B^PSNAPIS)@(GMRAST)) Q:GMRAST=""  S GMRAIEN=$O(^(GMRAST,"")) I GMRAIEN>0 D FILE("NDF",0)
        ;
        ; Loop through NDF file (T X-ref)
        ; $$T^PSNAPIS returns NDF version dependent root of "T" x-ref
        ; THIS ROUTINE IS NOT IN USE THUS THE DIRECT PHARMACY READ DOES NOT
        ; NEED TO BE UPDATED
        S GMRAST=START K ^TMP($J,"GMRAT")
        F GMRACNT=1:1 Q:NUM&(GMRACNT>NUM)  S GMRAST=$O(@($$T^PSNAPIS)@(GMRAST))  Q:GMRAST=""  S GMRAIEN=$$TGTOG^PSNAPIS(GMRAST) I GMRAIEN>0 D FILE("NDF",1)
        ; Set the return array.
        S GMRACNT=1,GMRAST="" F  S GMRAST=$O(^TMP($J,"GMRALST",GMRAST)) Q:GMRAST=""  D  I NUM'="" Q:GMRACNT>NUM
        .S @ARRAY@(GMRACNT)=^TMP($J,"GMRALST",GMRAST),GMRACNT=GMRACNT+1
        .Q
        K ^TMP($J,"GMRALST"),^TMP($J,"GMRAT"),GMRACNT,GMRAIEN,GMRAST
        Q
FILE(GMRATAB,GMRAT)     ;File away a found entry
        ;    GMRATAB is the table entry in from OE3 HL7 spec.
        ;    GMRAT is (0/1) indicating whether to check for dups of same entry.
        ;
        I GMRAT Q:$D(^TMP($J,"GMRAT",GMRAIEN))  S ^(GMRAIEN)=""
        I '$D(^TMP($J,"GMRALST",GMRAST)) S ^(GMRAST)=GMRAIEN_U_GMRAST_U_"99"_GMRATAB
        K GMRAT,GMRATAB
        Q
