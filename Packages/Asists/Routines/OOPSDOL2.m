OOPSDOL2        ;WIOFO/CAH-CA2 EXTRACT FOR DOL ;3/15/00
        ;;2.0;ASISTS;**17**;Jun 03, 2002;Build 2
EN      ; Entry
        N OCC,NAME,FN,KK,D62,D126,D226,D227
        S OOPSAR("CA")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA")))
        S OOPSAR("CA2A")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2A")))
        S OOPSAR("CA2B")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2B")))
        S OOPSAR("CA2C")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2C",0)))
        S OOPSAR("CA2D")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2D",0)))
        S OOPSAR("CA2E")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2E",0)))
        S OOPSAR("CA2ES")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2ES")))
        S OOPSAR("CA2F")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2F",0)))
        S OOPSAR("CA2G")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2G",0)))
        S OOPSAR("CA2H")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2H")))
        S OOPSAR("CA2I")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2I")))
        S OOPSAR("CA2J")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2J")))
        S OOPSAR("CA2K")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2K",0)))
        S OOPSAR("CA2L")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA2L")))
OP02    ; Seg OP02
        K OPX
        N OFF
        S OFF=$$GET1^DIQ(2260,OOPDA,"73:1")
        S OPX="OP02^"_$E("00",$L(OFF)+1,2)_OFF
        S OPX=OPX_U_$P(OOPSAR("CA2I"),U,1)_U_$P(OOPSAR("CA2I"),U,2)
        S OPX=OPX_U_$P(OOPSAR("CA2I"),U,3)_U_$$GET1^DIQ(2260,OOPDA,"240:1")
        S OPX=OPX_U_$E($P(OOPSAR("CA2I"),U,5),1,5)_U_$P(OOPSAR("CA2H"),U,1)
        S OPX=OPX_U_$P(OOPSAR("CA2H"),U,2)_U_$P(OOPSAR("CA2H"),U,3)
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"233:1")_U_$E($P(OOPSAR("CA2H"),U,5),1,5)
        S OPX=OPX_U_U_U_"^|"
        D STORE^OOPSDOLX
OP03    ; Seg OP03
        K OPX
        S OPX="OP03^"_$$GET1^DIQ(2260,OOPDA,60,"E")
        S OPX=OPX_U_$P(OOPSAR("CA"),U,5)
        S D62=$$GET1^DIQ(2260,OOPDA,"62:1")
        S D126=$$GET1^DIQ(2260,OOPDA,"126:1")
        S D226=$$GET1^DIQ(2260,OOPDA,"226:1")
        S D227=$$GET1^DIQ(2260,OOPDA,"227:1")
        S OPX=OPX_U_$E("000",$L(D226)+1,3)_D226
        S OPX=OPX_U_$E("0000",$L(D227)+1,4)_D227
        S OPX=OPX_U_$E("00",$L(D62)+1,2)_D62
        S OPX=OPX_U_$E("00",$L(D126)+1,2)_D126
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA2J"),U,8))
        ; V2_P15 - name fix to remove spaces and dashes
        S NAME=$$NAMEFIX^OOPSDOLX($$GET1^DIQ(2260,OOPDA,"265:.01"))
        S OPX=OPX_U_$P(NAME,U,1)_U_$P(NAME,U,2)_U_$P(NAME,U,3)
        S OPX=OPX_U_$P(OOPSAR("CA2H"),U,8)_U_$$MKNUM^OOPSUTL2($P(OOPSAR("CA2H"),U,9))
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA2ES"),U,6))
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA2J"),U,6))_U_"^|"
        D STORE^OOPSDOLX
OP04    ; Seg OP04
        K OPX
        N CAT,GRADE,STEP
        S CAT=$$GET1^DIQ(2260,OOPDA,2,"I")
        S GRADE=$P(OOPSAR("2162A"),U,12),STEP=$P(OOPSAR("2162A"),U,13)
        I STEP="N" S STEP=" N"  ; special case on step = N
        S OPX="OP04^"_$$DC^OOPSUTL3($P(OOPSAR("CA2ES"),U,3))
        I $P(OOPSAR("CA2J"),U,9) D
        .S Y=$P(OOPSAR("CA2J"),U,9) D DD^%DT S Y=$P($TR(Y,":",""),"@",2)
        .S OPX=OPX_U_$$DC^OOPSUTL3($P($P(OOPSAR("CA2J"),U,9),"."))_Y
        I '$P(OOPSAR("CA2J"),U,9) S OPX=OPX_U
        I $P(OOPSAR("CA2J"),U,12) D
        .S Y=$P(OOPSAR("CA2J"),U,12) D DD^%DT S Y=$P($TR(Y,":",""),"@",2)
        .S OPX=OPX_U_$$DC^OOPSUTL3($P($P(OOPSAR("CA2J"),U,12),"."))_Y
        I '$P(OOPSAR("CA2J"),U,12) S OPX=OPX_U
        S OPX=OPX_"^^^"_$P(OOPSAR("CA2J"),U,7)
        S OPX=OPX_U_$E($P(OOPSAR(0),U,13),1,2)
        ;V2.0 1/9/02 - fix Grade/Step, send nill if Volunteer or Fee Basis
        I (CAT=2)!($$GET1^DIQ(2260,OOPDA,63)="OT") S OPX=OPX_U_""
        E  S OPX=OPX_U_$E("00",$L(GRADE)+1,2)_GRADE
        I (CAT=2)!($$GET1^DIQ(2260,OOPDA,63)="OT") S OPX=OPX_U_""
        E  S OPX=OPX_U_$E("00",$L(STEP)+1,2)_STEP
        I $P(OOPSAR("CA2A"),U,8)=1!($P(OOPSAR("CA2A"),U,8)=4)!($P(OOPSAR("CA2A"),U,8)=5)!($P(OOPSAR("CA2A"),U,8)=7) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $P(OOPSAR("CA2A"),U,8)=2!($P(OOPSAR("CA2A"),U,8)=4)!($P(OOPSAR("CA2A"),U,8)=6)!($P(OOPSAR("CA2A"),U,8)=7) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $P(OOPSAR("CA2A"),U,8)=3!($P(OOPSAR("CA2A"),U,8)=5)!($P(OOPSAR("CA2A"),U,8)=6)!($P(OOPSAR("CA2A"),U,8)=7) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        S OPX=OPX_U_"Y^Y^Y^Y"
        S OPX=OPX_U_"^^ASISTS^C2^Y"
        S OPX=OPX_U                         ;Date of this Notice
        S OPX=OPX_U_$P(OOPSAR("CA2B"),U)    ;Illness Occurred Location
        S OPX=OPX_U_$P(OOPSAR("CA2B"),U,2)  ;Illness Occurred Address
        S OPX=OPX_U_$P(OOPSAR("CA2B"),U,3)  ;Illness Occurred City
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"212:1") ;Illness Occurred State
        S OPX=OPX_U_$E($P(OOPSAR("CA2B"),U,5),1,5)_"^|"
        D STORE^OOPSDOLX
OP05    ; Seg OP05
        K OPX
        S OPX="OP05^"_$P(OOPSAR("CA2L"),U)
        ;V2_P15 - name fix to remove spaces and dashes - not needed here
        ;      as name sent in 1 field, put in for consistency
        S NAME=$$NAMEFIX^OOPSDOLX($P(OOPSAR("CA2L"),U,2))
        S OPX=OPX_U_$E($P(NAME,U,1)_","_$P(NAME,U,2)_" "_$P(NAME,U,3),1,35)
        S OPX=OPX_U_$P(OOPSAR("CA2L"),U,3)_U_$P(OOPSAR("CA2L"),U,4)
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"262:1")_U_$E($P(OOPSAR("CA2L"),U,6),1,5)
        I $P(OOPSAR("CA2J"),U)'="" S OPX=OPX_U_1
        E  S OPX=OPX_U
        ;V2_P15 - name fix to remove spaces and dashes
        S NAME=$$NAMEFIX^OOPSDOLX($P(OOPSAR("CA2J"),U))
        S OPX=OPX_U_$P(NAME,U,1)_U_$P(NAME,U,2)_U_$P(NAME,U,3)
        I $P(OOPSAR("CA2J"),U)'="" S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"270:1")
        I $P(OOPSAR("CA2J"),U,2)'="" D
        .S OPX=OPX_U_$P(OOPSAR("CA2J"),U,2)_U_$P(OOPSAR("CA2J"),U,3)
        .S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"248:1")_U_$E($P(OOPSAR("CA2J"),U,5),1,5)
        I $P(OOPSAR("CA2J"),U,2)="" S OPX=OPX_"^^^^"
        S OPX=OPX_U_"^^|"
        D STORE^OOPSDOLX
OP06    ; Seg OP06
        S DATA=$$CONV^OOPSUTL5($P(OOPSAR("CA2I"),U,8))
        K OPX
        S OPX="OP06"
        F X=1:1:7 D          ;Loop for seven days of the week
        .I DATA[X D
        ..S OPX=OPX_U_"Y"
        ..S OPX=OPX_U_$$HM^OOPSUTL3($P(OOPSAR("CA2I"),U,6))_U_$$HM^OOPSUTL3($P(OOPSAR("CA2I"),U,7))
        .I DATA'[X S OPX=OPX_"^N^^"
        ; Generate Occ Code for DOL transfer
        S OCC=$$GET1^DIQ(2260,OOPDA,15)      ; Occupation code from PAID
        S OCC=$S(OCC<2300:"G"_OCC,(OCC>2499&(OCC<9001)):"W"_OCC,(OCC=9999):"Z"_OCC,1:"")
        S OPX=OPX_U_OCC_U_$P(OOPSAR("CA2A"),U,9)_"^|"
        D STORE^OOPSDOLX
OP07    ; Seg OP07 RELATIONSHIP OF ILLNESS TO EMP (Word Processing)
        I $G(OOPSAR("CA2C"))'="",($P(OOPSAR("CA2C"),U,4)'=0) D
        . S OPFLD=216,SEG="OP07"
        . D WP^OOPSDOLX
OP08    ; Seg OP08
        K OPX
        S OPX="OP08^^^^^^^"
        I $P(OOPSAR("CA2L"),U,7)'="" S OPX=OPX_97_U
        E  S OPX=OPX_U
        ; patch 11 - moved Witness indicator to correct piece
        S OPX=OPX_"N^^^^^^^^^^^|"
        D STORE^OOPSDOLX
OP13    ; Seg OP13 Nature of Disease/Illness (Word Processing)
        I $G(OOPSAR("CA2D"))'="",($P(OOPSAR("CA2D"),U,4)'=0) D
        .S OPFLD=217,SEG="OP13"
        .D WP^OOPSDOLX
OP14    ;Seg OP14 Supervisor Exception
        S S97=$P(OOPSAR("CA2L"),U,7)     ; patch 11, don't send if only a space
        I (S97'=""),(S97'=" ") D
        .K OPX
        .S OPX="OP14^1^1^"_S97_"^|"   ;Supervisor Exception
        .D STORE^OOPSDOLX
        K S97
OP15    ; Seg OP15
        K OPX
        S OPX="OP15^"_$$DC^OOPSUTL3($P(OOPSAR("CA2J"),U,11))
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA2B"),U,6))
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA2B"),U,7))
        S OPX=OPX_U_$$DC^OOPSUTL3($P($P(OOPSAR("CA2J"),U,10),"."))
        S Y=$P(OOPSAR("CA2J"),U,10) D DD^%DT S Y=$P($TR(Y,":",""),"@",2)
        S OPX=OPX_Y
        I $G(OOPSAR("CA2C"))'="",($P(OOPSAR("CA2C"),U,4)'=0) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $G(OOPSAR("CA2K"))'="",($P(OOPSAR("CA2K"),U,4)'=0) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $G(OOPSAR("CA2E"))'="",($P(OOPSAR("CA2E"),U,4)'=0) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $G(OOPSAR("CA2G"))'="",($P(OOPSAR("CA2G"),U,4)'=0) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $G(OOPSAR("CA2F"))'="",($P(OOPSAR("CA2F"),U,4)'=0) S OPX=OPX_U_"Y^|"
        E  S OPX=OPX_U_"N^|"
        D STORE^OOPSDOLX
OP16    ; Seg OP16 Work Duty Changed (Word Processing)
        I $G(OOPSAR("CA2K"))'="",($P(OOPSAR("CA2K"),U,4)'=0) D
        .S OPFLD=257,SEG="OP16"
        .D WP^OOPSDOLX
OP17    ; Seg OP17 Claim not Filed (Word Processing)
        I $G(OOPSAR("CA2E"))'="",($P(OOPSAR("CA2E"),U,4)'=0) D
        .S OPFLD=218,SEG="OP17"
        .D WP^OOPSDOLX
OP18    ; Seg OP18 Medical Report Delay (Word Processing)
        I $G(OOPSAR("CA2G"))'="",($P(OOPSAR("CA2G"),U,4)'=0) D
        .S OPFLD=220,SEG="OP18"
        .D WP^OOPSDOLX
OP19    ; Seg OP19 Employee Statement Delayed (Word Processing)
        I $G(OOPSAR("CA2F"))'="",($P(OOPSAR("CA2F"),U,4)'=0) D
        .S OPFLD=219,SEG="OP19"
        .D WP^OOPSDOLX
OP20    ; Seg OP20
        K OPX
        I $P(OOPSAR("2162B"),U,4)'="" D
        .S OPX="OP20^"_"P"_U_$$GET1^DIQ(2260,OOPDA,"30:1")_"^|" D STORE^OOPSDOLX
        .Q
        ; Only send Primary Body part at this time - per AAC 6/30/2000
        ; I $P(OOPSAR("2162B"),U,8)'="" D
        ; . N OPX
        ; . S OPX="OP20^"_"S"_U_$$GET1^DIQ(2260,OOPDA,"30.1:1")_"^|" D STORE^OOPSDOLX
        ; . Q
OP21    ; Seg OP21 Define for future use
OP22    ; Seg OP22 Define for future use
EXIT    ; exit the routine
        K IEN,DATA,MAX
        Q
