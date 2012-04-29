OOPSDOL1        ;WIOFO/CAH-CA1 EXTRACT FOR DOL ;3/15/00
        ;;2.0;ASISTS;**4,7,17**;Jun 03, 2002;Build 2
EN      ; Entry
        N OCC,NAME,FN,KK,D62,D123,D124,D126,WITN
        S OOPSAR("CA")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA")))
        S OOPSAR(0)=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,0)))
        S OOPSAR("CA1A")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1A")))
        S OOPSAR("CA1B")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1B")))
        S OOPSAR("CA1C")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1C")))
        S OOPSAR("CA1D")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1D")))
        S OOPSAR("CA1ES")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1ES")))
        S OOPSAR("CA1F")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1F")))
        S OOPSAR("CA1G")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1G")))
        S OOPSAR("CA1H")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1H")))
        S OOPSAR("CA1I")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1I")))
        S OOPSAR("CA1J")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1J",0)))
        S OOPSAR("CA1K")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1K",0)))
        S OOPSAR("CA1L")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1L")))
        S OOPSAR("CA1M")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1M")))
        S OOPSAR("CA1N")=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1N")))
        ; get witness data once
        S WITN=$O(^OOPS(2260,OOPDA,"CA1W",0))
        I $G(WITN)'="" D
        . S OOPSAR("CA1W",0)=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1W",WITN,0)))
        . S OOPSAR("CA1W",1)=$$UP^OOPSUTL4($G(^OOPS(2260,OOPDA,"CA1W",WITN,1)))
OP02    ; Seg OP02
        K OPX
        N OFF
        S OFF=$$GET1^DIQ(2260,OOPDA,"73:1")
        S OPX="OP02^"_$E("00",$L(OFF)+1,2)_OFF
        S OPX=OPX_U_$P(OOPSAR("CA1M"),U,1)_U_$P(OOPSAR("CA1M"),U,2)
        S OPX=OPX_U_$P(OOPSAR("CA1M"),U,3)_U_$$GET1^DIQ(2260,OOPDA,"179:1")
        S OPX=OPX_U_$E($P(OOPSAR("CA1M"),U,5),1,5)_U_$P(OOPSAR("CA1F"),U,1)
        S OPX=OPX_U_$P(OOPSAR("CA1F"),U,2)_U_$P(OOPSAR("CA1F"),U,3)
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"133:1")_U_$E($P(OOPSAR("CA1F"),U,5),1,5)
        S OPX=OPX_U_U_U_"^|"
        D STORE^OOPSDOLX
OP03    ; Seg OP03
        K OPX
        S OPX="OP03^"_$$GET1^DIQ(2260,OOPDA,60,"E")
        S OPX=OPX_U_$P(OOPSAR("CA"),U,5)
        S D62=$$GET1^DIQ(2260,OOPDA,"62:1"),D123=$$GET1^DIQ(2260,OOPDA,"123:1")
        S D124=$$GET1^DIQ(2260,OOPDA,"124:1"),D126=$$GET1^DIQ(2260,OOPDA,"126:1")
        S OPX=OPX_U_$E("000",$L(D123)+1,3)_D123
        S OPX=OPX_U_$E("0000",$L(D124)+1,4)_D124
        S OPX=OPX_U_$E("00",$L(D62)+1,2)_D62
        S OPX=OPX_U_$E("00",$L(D126)+1,2)_D126
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA1L"),U,7))
        S NAME=$$GET1^DIQ(2260,OOPDA,"169:.01"),FN=$P(NAME,",",2)
        S OPX=OPX_U_$E($P(NAME,","),1,20)
        F KK=1:0:1 Q:$E(FN,KK)'=" "  S FN=$E(FN,KK+1,$L(FN))
        S OPX=OPX_U_$E($P(FN," "),1,10)_U_$E($P(FN," ",2),1,10)
        S OPX=OPX_U_$P(OOPSAR("CA1L"),U,4)_U_$$MKNUM^OOPSUTL2($P(OOPSAR("CA1L"),U,5))
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA1ES"),U,6))
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA1I"),U,6))
        S OPX=OPX_U_$$DC^OOPSUTL3($P($P(OOPSAR(0),U,5),"."))_"^|"
        D STORE^OOPSDOLX
OP04    ; Seg OP04
        K OPX
        N CAT,GRD,STP,PAYP
        S CAT=$$GET1^DIQ(2260,OOPDA,2,"I"),PAYP=$P(OOPSAR(0),U,13)
        S GRD=$P(OOPSAR("2162A"),U,12),STP=$P(OOPSAR("2162A"),U,13)
        I STP="N" S STP=" N"  ; special case on step
        S OPX="OP04^"_$$DC^OOPSUTL3($P(OOPSAR("CA1ES"),U,3))
        I $P(OOPSAR("CA1F"),U,13) D
        .S Y=$P(OOPSAR("CA1F"),U,13) D DD^%DT S Y=$P($TR(Y,":",""),"@",2)
        .S OPX=OPX_U_$$DC^OOPSUTL3($P($P(OOPSAR("CA1F"),U,13),"."))_Y
        I '$P(OOPSAR("CA1F"),U,13) S OPX=OPX_U
        I $P(OOPSAR("CA1G"),U,3) D
        .S Y=$P(OOPSAR("CA1G"),U,3) D DD^%DT S Y=$P($TR(Y,":",""),"@",2)
        .S OPX=OPX_U_$$DC^OOPSUTL3($P($P(OOPSAR("CA1G"),U,3),"."))_Y
        I '$P(OOPSAR("CA1G"),U,3) S OPX=OPX_U
        I $P(OOPSAR("CA1G"),U,2) D
        .S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA1G"),U,2))
        I '$P(OOPSAR("CA1G"),U,2) S OPX=OPX_U
        S RPOL=$P(OOPSAR("CA1A"),U,13)
        S VAL=$S(RPOL="COP":"RS",RPOL="L":"ZZ",1:"NU")
        S OPX=OPX_U_VAL_U_$P(OOPSAR("CA1I"),U,7)
        S OPX=OPX_U_$E($P(OOPSAR(0),U,13),1,2)
        ; V2.0 - fix Grade/Step, send nill if Volunteer or Fee Basis
        I CAT=2!(PAYP="OT") S OPX=OPX_U_""
        E  S OPX=OPX_U_$E("00",$L(GRD)+1,2)_GRD
        I (CAT=2)!(PAYP="OT") S OPX=OPX_U_""
        E  S OPX=OPX_U_$E("00",$L(STP)+1,2)_STP
        I $P(OOPSAR("CA1A"),U,8)=1!($P(OOPSAR("CA1A"),U,8)=4)!($P(OOPSAR("CA1A"),U,8)=5)!($P(OOPSAR("CA1A"),U,8)=7) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $P(OOPSAR("CA1A"),U,8)=2!($P(OOPSAR("CA1A"),U,8)=4)!($P(OOPSAR("CA1A"),U,8)=6)!($P(OOPSAR("CA1A"),U,8)=7) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        I $P(OOPSAR("CA1A"),U,8)=3!($P(OOPSAR("CA1A"),U,8)=5)!($P(OOPSAR("CA1A"),U,8)=6)!($P(OOPSAR("CA1A"),U,8)=7) S OPX=OPX_U_"Y"
        E  S OPX=OPX_U_"N"
        S OPX=OPX_U_"Y^Y^Y^Y"
        I $G(WITN) D
        . S NM=$P($G(OOPSAR("CA1W",0)),U)
        . S:$G(NM)'="" OPX=OPX_U_"Y" S:$G(NM)="" OPX=OPX_U_"N"
        . S WS=$P($G(OOPSAR("CA1W",0)),U,6)
        . S:$G(WS) OPX=OPX_U_"Y" S:'$G(WS) OPX=OPX_U
        . K NM,WS
        I '$G(WITN) S OPX=OPX_"^N^N"
        S OPX=OPX_U_"ASISTS^C2^Y^"
        S OPX=OPX_$$DC^OOPSUTL3($P(OOPSAR("CA1A"),U,11))
        S OPX=OPX_U_$P(OOPSAR("CA1A"),U,9)
        S OPX=OPX_U_$P(OOPSAR("CA1N"),U)
        S OPX=OPX_U_$P(OOPSAR("CA1N"),U,2)
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"185:1")
        S OPX=OPX_U_$E($P(OOPSAR("CA1A"),U,14),1,5)_"^|"
        D STORE^OOPSDOLX
OP05    ; Seg OP05
        ;V2.0 if Pay Plan="OT" emp is Fee Basis send "C" in PPER
        N PPER
        S PPER=$P(OOPSAR("CA1L"),U,2) I (PAYP="OT") S PPER="C"
        K OPX
        S OPX="OP05^"_$P(OOPSAR("CA1G"),U,8)_U_$P(OOPSAR("CA1H"),U)
        S OPX=OPX_U_$P(OOPSAR("CA1H"),U,2)_U_$P(OOPSAR("CA1H"),U,3)
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"154:1")_U_$E($P(OOPSAR("CA1H"),U,5),1,5)
        I $P(OOPSAR("CA1I"),U)'="" D
        .S OPX=OPX_U_1
        .S NAME=$P(OOPSAR("CA1I"),U),FN=$P(NAME,",",2)
        .F KK=1:0:1 Q:$E(FN,KK)'=" "  S FN=$E(FN,KK+1,$L(FN))
        .S OPX=OPX_U_$E($P(NAME,","),1,20)
        .S OPX=OPX_U_$E($P(FN," "),1,10)_U_$E($P(FN," ",2),1,10)
        .S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"182:1")
        I $P(OOPSAR("CA1I"),U)="" S OPX=OPX_U_"3^^^^"
        S OPX=OPX_U_$P(OOPSAR("CA1I"),U,2)_U_$P(OOPSAR("CA1I"),U,3)
        S OPX=OPX_U_$$GET1^DIQ(2260,OOPDA,"159:1")_U_$E($P(OOPSAR("CA1I"),U,5),1,5)
        ; if the claim is for a volunteer both the pay rate and the pay period
        ; should be blank - llh 12/29/03
        I CAT=2 S OPX=OPX_U_U_"^|"
        E  S OPX=OPX_U_$P(OOPSAR("CA1L"),U)_U_PPER_"^|"
        D STORE^OOPSDOLX
OP06    ; Seg OP06
        S DATA=$$CONV^OOPSUTL5($P(OOPSAR("CA1F"),U,11))
        K OPX
        S OPX="OP06"
        F X=1:1:7 D
        .I DATA[X D
        ..S OPX=OPX_U_"Y"
        ..S OPX=OPX_U_$$HM^OOPSUTL3($P(OOPSAR("CA1F"),U,9))
        ..S OPX=OPX_U_$$HM^OOPSUTL3($P(OOPSAR("CA1F"),U,10))
        .I DATA'[X S OPX=OPX_"^N^^"
        ; Generate Occ Code for DOL transfer
        S OCC=$$GET1^DIQ(2260,OOPDA,15)      ; Occupation code from PAID
        S OCC=$S(OCC<2300:"G"_OCC,(OCC>2499&(OCC<9001)):"W"_OCC,(OCC=9999):"Z"_OCC,1:"")
        S OPX=OPX_U_OCC_U_$P(OOPSAR("CA1A"),U,12)_"^|"
        D STORE^OOPSDOLX
        K DATA
OP07    ; Seg OP07
        K OPX
        I $L($P(OOPSAR("CA1B"),U))<133 D
        .S OPX="OP07^1^1^"_$P(OOPSAR("CA1B"),U)_"^|"
        .D STORE^OOPSDOLX
        I $L($P(OOPSAR("CA1B"),U))>132 D
        .S OPX="OP07^1^2^"_$E($P(OOPSAR("CA1B"),U),1,132)_"^|"
        .D STORE^OOPSDOLX
        .K OPX
        .S OPX="OP07^2^2^"_$E($P(OOPSAR("CA1B"),U),133,200)_"^|"
        .D STORE^OOPSDOLX
OP08    ; Seg OP08
        N BK36 S BK36="" K OPX
        S OPX="OP08^"_$S($P(OOPSAR("CA1G"),U,4)="N":"NW",1:"")
        S OPX=OPX_U_$S($P(OOPSAR("CA1G"),U,6)="Y":"WM",1:"")
        S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA1G"),U))
        I $G(OOPSAR("CA1K"))'="",($P(OOPSAR("CA1K"),U,4)'=0) S BK36="E5"
        ;I $G(OOPSAR("CA1I"))'="",($P(OOPSAR("CA1I"),U,12)'="") S BK36="E5"
        I $G(OOPSAR("CA1I"))'="" D
        .I $P(OOPSAR("CA1I"),U,12)'="" S BK36="E5"
        .I $P(OOPSAR("CA1I"),U,13)'="" S BK36="E5"
        S OPX=OPX_U_BK36_U
        I $P(OOPSAR("CA1I"),U,8)="N" S OPX=OPX_U_"CN"
        E  S OPX=OPX_U
        I $P(OOPSAR("CA1L"),U,3)'="" S OPX=OPX_U_97
        E  S OPX=OPX_U
        I $G(OOPSAR("CA1W",0))'="" D
        . S OPX=OPX_U_"Y"
        . S NAME=$P(OOPSAR("CA1W",0),U),FN=$P(NAME,",",2)
        . F KK=1:0:1 Q:$E(FN,KK)'=" "  S FN=$E(FN,KK+1,$L(FN))
        . S OPX=OPX_U_$E($P(NAME,","),1,20)
        . S OPX=OPX_U_$E($P(FN," "),1,10)_U
        . S OPX=OPX_U_$P(OOPSAR("CA1W",0),U,2)
        . S OPX=OPX_U_$P(OOPSAR("CA1W",0),U,3)
        . S OPX=OPX_U_$$GET1^DIQ(5,$P(OOPSAR("CA1W",0),U,4),1)  ; State Code
        . S OPX=OPX_U_$E($P(OOPSAR("CA1W",0),U,5),1,5)
        . S OPX=OPX_U_$$DC^OOPSUTL3($P(OOPSAR("CA1W",0),U,6))
        I $G(OOPSAR("CA1W",0))="" S OPX=OPX_U_"^^^^^^^^"
        S FL174=$P(OOPSAR("CA1L"),U,6)  ;FILING INSTRUCTION
        S CATY=$S(FL174=1:"2^0",FL174=2:"2^1",FL174=3:"1^",FL174=4:"6^",1:"")
        S OPX=OPX_U_CATY_"^|"
        D STORE^OOPSDOLX
OP09    ; Seg OP09
        I $P(OOPSAR("CA1G"),U,4)="N" D
        .K OPX
        .S OPX="OP09^1^1^"_$P(OOPSAR("CA1G"),U,5)_"^|" D STORE^OOPSDOLX
OP10    ; Seg OP10
        I $P(OOPSAR("CA1G"),U,7)'="" D
        .K OPX
        .S OPX="OP10^1^1^"_$P(OOPSAR("CA1G"),U,7)_"^|" D STORE^OOPSDOLX
OP11    ; Seg OP11 - Reason for Convert (Word Processing)
        I ($G(OOPSAR("CA1K"))'="")!($P($G(OOPSAR("CA1I")),U,12)'="") D
        .S OPFLD=165,SEG="OP11" D WP^OOPSDOLX
OP12    ; Seg OP12 - Supervisor not agree explain (Word Processing)
        I $G(OOPSAR("CA1J"))'="" D
        .S OPFLD=164,SEG="OP12" D WP^OOPSDOLX
OP13    ; Seg OP13 - Nature of Injury
        I $P(OOPSAR("CA1C"),U)'="" D
        .K OPX
        .S OPX="OP13^1^1^"_$P(OOPSAR("CA1C"),U)_"^|" D STORE^OOPSDOLX
OP14    ; Seg OP14 - Supervisor Exception
        I $P(OOPSAR("CA1L"),U,3)'="" D
        .K OPX
        .S OPX="OP14^1^1"
        .S OPX=OPX_U_$P(OOPSAR("CA1L"),U,3)_"^|" D STORE^OOPSDOLX
OP20    ; Seg OP20
        K OPX
        I $P(OOPSAR("2162B"),U,4)'="" D
        .S OPX="OP20^"_"P"_U_$$GET1^DIQ(2260,OOPDA,"30:1")_"^|" D STORE^OOPSDOLX
        .Q
OP21    ; Seg OP21 Defined for future use
OP22    ; Seg OP22 Defined for future use
OP23    ; Seg OP23 - Statement of Witness (Not yet used)
        I $G(OOPSAR("CA1W",1))'="" D
        . I $L(OOPSAR("CA1W",1))<133 D
        .. K OPX
        .. S OPX="OP23^1^1^"_OOPSAR("CA1W",1)_"^|"
        .. D STORE^OOPSDOLX
        . I $L(OOPSAR("CA1W",1))>132 D
        .. K OPX
        .. S OPX="OP23^1^2^"_$E(OOPSAR("CA1W",1),1,132)_"^|"
        .. D STORE^OOPSDOLX
        .. K OPX
        .. S OPX="OP23^2^2^"_$E(DATA,133,264)_"^|"
        .. D STORE^OOPSDOLX
        ;
EXIT    ; End of routine
        K WITN
        Q
