%ZISS1  ;AC/SFISC - Collect screen parameters 5/29/88  2:02 PM ;1/24/08  16:10
        ;;8.0;KERNEL;**69,440**;JUL 10, 1995;Build 13
        ;Per VHA Directive 2004-038, this routine should not be modified
VALID   ;
        N %ZISI,%ZISNP,ZISCH,ZISEND,ZISNUM,ZISQ,ZISXL,ZISXLN ;p440
        D L
        Q
        ;
SET2    ;
        S %ZISFN="" F %ZISZ=0:0 S %ZISFN=$O(%ZISZ(%ZISFN)) Q:%ZISFN=""  I $D(%ZISZ(%ZISFN))#2 S %ZISXX=%ZISZ(%ZISFN) D INDCK
        Q
INDCK   ;
        S %ZISY=""
        I "IOEFLD^IOSTBM"[%ZISFN S @%ZISFN=%ZISXX Q
        I %ZISXX]"" S @("%ZISY="_%ZISXX)
        ;E  S @("%ZISY="_"""""")
        I $E(%ZISFN,1,2)="IO" S @%ZISFN=%ZISY
        E  S @("IO"_$E(%ZISFN,1,6))=%ZISY
        Q:'$D(%ZIS)#2  Q:%ZIS'["I"  Q:'$D(%ZISZ(%ZISFN,1))
        ;
SRAY    ;
        S %=%ZISY,%ZISY=$A($E(%ZISY,1))
        F %1=2:1:$L(%) S %ZISY=%ZISY_$S($A(%,%1)<32:$A(%,%1),$A(%,%1)=127:127,1:$E(%,%1))
        S IOIS(%ZISY)=%ZISFN
        Q
CHECK   ;Entry point called from input transforms of fields in DEV/TT files.
        N %ZISXX,%ZISYY,%ZISI,%ZISNP,%ZISX1,%ZISX2,ZISCH,ZISNUM,ZISQ,ZISXL,ZISXLN ;p440
        S %ZISXX=X D L S X=%ZISYY
        Q
CHECK1  ;Entry point called from input transforms of fields in DEV/TT files.
        N %ZISXX,%ZISYY,%ZISI,%ZISNP,%ZISX1,%ZISX2,ZISCH,ZISNUM,ZISQ,ZISXL,ZISXLN ;p440
        S %ZISXX=$S(X?1"W ".E:$E(X,3,$L(X)),1:X)
        D L S X=$S(X?1"W ".E:"W "_%ZISYY,1:%ZISYY)
        Q
FORM    ;Entry point called from input transforms of fields in DEV/TT files.
        Q:$L(X,"_")'>1
        N %ZISSI,%ZISSY ;p440
        ;F %ZISSI=1:1:$L(X,"_") S %ZISX1=$P(X,"_",%ZISSI) I %ZISX1]"","#?!"[$E(%ZISX1) S X=$S(%ZISSI=1:"",1:$P(X,"_",1,%ZISSI-1)_",")_%ZISX1_$S(%ZISSI<$L(X,"_"):","_$P(X,"_",%ZISSI+1,255),1:"") W !,%ZISSI_"==>"_X
        S %ZISSY=""
        F %ZISSI=1:1:$L(X,"_") S %ZISSY=%ZISSY_$P(X,"_",%ZISSI)_$S($P(X,"_",%ZISSI+1)="":"","#?!"[$E($P(X,"_",%ZISSI+1)):",","#?!"[$E($P(X,"_",%ZISSI)):",",1:"_")
        S X=%ZISSY
        Q
        ;
L       S ZISQ="""",%ZISNP=0,ZISXLN=$L(%ZISXX) I 'ZISXLN S %ZISYY="" Q
        S ZISXL=0,%ZISYY="" F %ZISI=0:0 S ZISXL=ZISXL+1 S ZISCH=$E(%ZISXX,ZISXL) D L1 Q:ZISXL'<ZISXLN
        ;I $L(%ZISYY,"$C(")>2,%ZISYY[")_$C(" S %ZISXX=%ZISYY D L2,L3 S %ZISYY=%ZISXX Q
        S %ZISXX=%ZISYY D L2,L3 S %ZISYY=%ZISXX
        Q
L1      I ZISCH="_"!(ZISCH=",") S %ZISYY=%ZISYY_"_" Q
        I ZISCH=ZISQ D QUOTE Q
        I ZISCH="$" D DOLR Q
        I ZISCH="*" D STAR Q
        I ZISCH="(" D PAREN Q
        S %ZISYY=%ZISYY_ZISCH
        Q
L2      ;Find $C(x)_$C(y) and merge
        N I ;p440
        F I=1:1:$L(%ZISXX,"_") S %ZISX1=$P(%ZISXX,"_",I),%ZISX2=$P(%ZISXX,"_",I+1) I $E(%ZISX1,1,3)="$C(",$E(%ZISX2,1,3)="$C(" D S2
        Q
L3      ;
        N I
        F I=1:1:$L(%ZISXX,"_") I $P(%ZISXX,"_",I)["+","$("'[$E($P(%ZISXX,"_",I)),")"'[$E($P(%ZISXX,"_",I),$L($P(%ZISXX,"_",I))) S $P(%ZISXX,"_",I)="("_$P(%ZISXX,"_",I)_")"
        Q
STAR    ;S ZISNUM="" F %ZISI=0:0 S ZISXL=ZISXL+1 S ZISCH=$E(%ZISXX,ZISXL) S:ZISCH?1N ZISNUM=ZISNUM_ZISCH I ZISCH=""!(ZISCH=",") S %ZISYY=%ZISYY_"$C("_+ZISNUM_")",ZISXL=ZISXL-1 Q
        S ZISNUM="" F %ZISI=0:0 S ZISXL=ZISXL+1 S ZISCH=$E(%ZISXX,ZISXL) S:ZISCH'=""&(ZISCH'=",") ZISNUM=ZISNUM_ZISCH I ZISCH=""!(ZISCH=",") S %ZISYY=%ZISYY_"$C("_ZISNUM_")",ZISXL=ZISXL-1 Q
        Q
QUOTE   S %ZISYY=%ZISYY_ZISCH F %ZISI=0:0 S ZISXL=ZISXL+1 S ZISCH=$E(%ZISXX,ZISXL),%ZISYY=%ZISYY_ZISCH I ZISCH=ZISQ!(ZISXL'<ZISXLN) Q
        Q
DOLR    ;Looking for $C.
        I "IXY"[$E(%ZISXX,ZISXL+1) S %ZISYY=%ZISYY_"$"_$E(%ZISXX,ZISXL+1) S ZISXL=ZISXL+1 Q
        I "ACDEFJLNOPRSTV"[$E(%ZISXX,ZISXL+1)&($E(%ZISXX,ZISXL+2)="(") S %ZISYY=%ZISYY_"$"_$E(%ZISXX,ZISXL+1),ZISXL=ZISXL+2 D PAREN Q
        S %ZISYY=%ZISYY_"$" ;p440
        Q
PAREN   S %ZISYY=%ZISYY_"(",ZISEND=")",%ZISNP=%ZISNP+1 D SCAN S %ZISNP=%ZISNP-1
        Q
SCAN    F %ZISI=0:0 S ZISXL=ZISXL+1,ZISCH=$E(%ZISXX,ZISXL) D S1 Q:ZISXL'<ZISXLN!(ZISEND=ZISCH&(%ZISNP))
        Q
S1      I ZISCH=ZISQ D QUOTE Q
        I ZISCH="$" D DOLR Q
        I ZISCH="(" D PAREN Q
        S %ZISYY=%ZISYY_ZISCH
        Q
        ;
S2      ;MERGE $C
        S %ZISX1=$E(%ZISX1,1,$L(%ZISX1)-1),%ZISX2=","_$E(%ZISX2,4,$L(%ZISX2))
        S $P(%ZISXX,"_",I,I+1)=%ZISX1_%ZISX2
        N I D L2
        Q
