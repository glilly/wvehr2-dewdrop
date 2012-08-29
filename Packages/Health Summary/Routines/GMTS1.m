GMTS1   ; SLC/JER,KER - Health Summary Driver ; 05/22/2008
        ;;2.7;Health Summary;**7,16,24,28,37,49,58,89**;Oct 20, 1995;Build 61
        ;                    
        ; External References
        ;   DBIA 10076  ^XUSEC(
        ;   DBIA 10000  C^%DTC
        ;   DBIA 10000  NOW^%DTC
        ;               
EN      ; Entry Point to Generate a Summary
        ;               
        ;   Requires:  DFN, GMTSTITL, GMTSEG()
        ;              GMTSEGI(), GMTSEGC, DUZ(2)
        ;               
        ;   $I & IO MUST BE VALID, CALLER MUST CLOSE OUTPUT DEVICE
        ;               
START   ; Health Summary
        N GMSUPRES,GMTSICF,GMTSPXD1,GMTSPXD2,GMTSBEG,GMTSEND
        S GMSUPRES=$P($G(^GMT(142,+$G(GMTSTYP),0)),U,5)
        I $D(GMSUPRES),$D(GMTSOBJ),'$D(GMTSOBJ("SUPPRESS COMPONENTS")) S GMSUPRES="N"
        S:$D(GMTSOBJ("SUPPRESS COMPONENTS")) GMSUPRES="Y"
        U IO S GMTSLO=3,GMTSLPG=0
        D DEM^GMTSU
        W:$E(IOST)="C"&('$D(GMTSOBJ)) @IOF D OUTPUT
        K GMTSCVD,GMTSCKP,GMTSNPG,GMTSPG,GMTSQIT,GMTSHDR,GMTSHD2,GMTSBRK,GMTSLCMP,GMTSDTC
        K GMTSEGN,GMTSE,GMTSEGR,GMTSEQ,GMTSEGH,GMTSEGL,GMTSDLM,GMTSDLS,GMTSNDM,GMTSN,GMTSQ
        Q
        ;
OUTPUT  ; Loop through GMTSEG()
        D NOW^%DTC S X=% D REGDTM4^GMTSU S GMTSDTM=X
        I +$G(GMTSPX1)&+$G(GMTSPX2) D  ;   Allows date range for data
        . S GMTS2=9999999-$P(GMTSPX2,"."),GMTS1=9999999-$P(GMTSPX1,".")-.24
        . ;   For GMTS1 want to get everything till Midnight
        . S X=GMTSPX1 D REGDT4^GMTSU S GMTSPXD1=X
        . S X=GMTSPX2 D REGDT4^GMTSU S GMTSPXD2=X
        D HEADER^GMTSUP
        K GMTSQIT S GMTSEGN=""
        N STR
        F  S GMTSEGN=$O(GMTSEG(GMTSEGN)) Q:GMTSEGN=""  D  I $D(GMTSQIT),(GMTSQIT="") Q
        . K GMTSQIT S GMTSEQ=$P(GMTSEG(GMTSEGN),U,1)
        . S GMTSE=$P(GMTSEG(GMTSEGN),U,2) D SEGMNT D:GMTSEGN=GMTSEGC LASTPG
        I $D(GMTSOBJ),+($O(GMTSEG(0)))=0 D
        .S STR=$S(GMTSOBJ("NO DATA")'="":"  "_GMTSOBJ("NO DATA"),1:"  No data available")
        .W !,STR
        S GMTSHDR=$E(GMTSHDR,1,3)_" END "_$E(GMTSHDR,9,79)
        S:$D(GMTSOBJ) GMTSHDR=$E(GMTSHDR,1,74)
        S:$D(GMTSOBJE) GMTSHDR="",$P(GMTSHDR,"*",74)="*"
        I '$D(GMTSOBJ)!($D(GMTSOBJ("CONFIDENTIAL"))) W:$E(IOST)'="C" !,GMTSHDR,!
        I '$D(GMTSOBJ) H:$E(IOST)="C" 1
        W:'+$G(GMPSAP)&('$D(GMTSOBJ))&('$D(GMTSOBJE)) @IOF
        I $D(GMTSQIT) D EXIT
        Q
        ;
LASTPG  ; Allows User to branch to an earlier component (last page)
        Q:$E(IOST)'="C"!(IOT="HFS")!$D(GMTSQIT)
        I +$G(GMPSAP),IOSL>998,$G(GMPAT(+$O(GMPAT(0),-1)))'=DFN Q
        ;   No footer when IOSL > 998 and action profile is printed.
        I IOSL>998,+$G(GMPSAP) Q
        ;   No footer when IOSL > 998 and this isn't the last patient.
        I IOSL>998,$G(GMPAT(+$O(GMPAT(""),-1)))'=$G(DFN) Q
        I '$D(GMTSOBJ) F I=$Y:1:$S((IOSL-GMTSLO)'>64:(IOSL-GMTSLO),1:(24-GMTSLO)) W !
        I $D(GMTSQIT),(GMTSQIT>0) K GMTSQIT
        S GMTSLPG=1 D CKP^GMTSUP
        Q
EXIT    ; Clean up and quit
        K ZTSK
        Q
SEGMNT  ; Output a Component Type
        N GMTSLOCK,GMTSDBL,GMOOTXT,GMPXICDF,GMPXHLOC,GMPXNARR,GMPXCMOD,GMPXCM,GMTSWRIT,GMSEL
        I $D(GMTSQIT),(GMTSQIT]"") K GMTSQIT
        S X=^GMT(142.1,GMTSE,0)
        S GMTSEGH=$S($P(X,U,4)]"":$P(X,U,4)_" - ",1:"")_$S($P(GMTSEG(GMTSEGN),U,5)]"":$P(GMTSEG(GMTSEGN),U,5),$P(X,U,9)]"":$P(X,U,9),1:" "_$P(X,U,1)),GMTSEGR=$P(X,"^",2)
        Q:GMTSEGR=""
        S GMTSLOCK=$P(X,U,7),GMTSDBL=$P(X,U,6),GMOOTXT=$P(X,U,8),GMPXCM=$P(X,U,14)
        S GMPXHLOC=$P(GMTSEG(GMTSEGN),U,6),GMPXNARR=$P(GMTSEG(GMTSEGN),U,8)
        S GMPXCMOD=$P(GMTSEG(GMTSEGN),U,9) S:GMPXCM'="Y" GMPXCMOD="N"
        S GMPXICDF=$P(GMTSEG(GMTSEGN),U,7)
        S GMTSNDM=$P(GMTSEG(GMTSEGN),U,3),GMTSDLM=$P(GMTSEG(GMTSEGN),U,4) S:GMTSNDM="" GMTSNDM=-1
        ;   Allow for date range for data
        S:+$G(GMTSPX1)&+$G(GMTSPX2) GMTSDLM=""
        S GMTSDLS=""
        I GMTSDLM?1N.N!(GMTSDLM?1N.N1"D") S GMTSDLS=+GMTSDLM_" day"
        S:GMTSDLM?1N.N1"W" GMTSDLS=+GMTSDLM_" week",GMTSDLM=+GMTSDLM*7
        S:GMTSDLM?1N.N1"M" GMTSDLS=+GMTSDLM_" month",GMTSDLM=+GMTSDLM*30.4
        S:GMTSDLM?1N.N1"Y" GMTSDLS=+GMTSDLM_" year",GMTSDLM=+GMTSDLM*365.25
        S GMTSDLM=+GMTSDLM
        S:+GMTSDLS>1 GMTSDLS=GMTSDLS_"s"
        S GMTSEGL="" I GMTSNDM>0!(GMTSDLM>0) S GMTSEGL=" (max "_$S(GMTSNDM>0:GMTSNDM_$S(GMTSNDM=1:" occurrence",1:" occurrences")_$S(GMTSDLM>0:" or ",1:""),1:"")_$S(GMTSDLM>0:GMTSDLS,1:"")_")"
        K GMTSDLS,GMTSN
        D NOW^%DTC S GMTSDTC=%,DT=$P(%,".") K %,%H,%I
        ;   Use date range unless variables empty
        ;     GMTS1=Most recent inverted date
        ;     GMTS2=To date in the past in an inverted date format
        I +$G(GMTSPX1)'>0!(+$G(GMTSPX2)'>0) D
        . I GMTSDLM'>0 S (GMTS2,GMTSDLM)=9999999,GMTS1=6666666
        . E  S X1=GMTSDTC,X2=-GMTSDLM D C^%DTC S GMTSDLM=9999999-X,GMTS2=GMTSDLM,GMTS1=9999999-(GMTSDTC+.0001) K X1,X2
        ;   Set GMTSBEG to be GMTS2 uninverted
        S GMTSBEG=$S(GMTS2=9999999:1,1:9999999-GMTS2)
        ;   Set GMTSEND to be GMTS1 uninverted
        S GMTSEND=$S(GMTS1=6666666:9999999,1:$P(9999999-GMTS1,".")_".235959")
        ; GMTSWRIT is used to print component heading on 1st write
        S GMTSWRIT=1
        I GMTSDBL]"",("PT"[GMTSDBL) D  Q
        . D:GMTSDBL="T" TDISBLD^GMTS2
        . D:GMTSDBL="P"&$D(GMTSPRM) PDISBLD^GMTS2
        I GMTSLOCK]"",('$D(^XUSEC(GMTSLOCK,DUZ))) D NOMATCH^GMTS2 Q
        S GMSEL=$P($G(^GMT(142.1,GMTSE,1,1,0)),U)
        I GMSEL]"",$O(GMTSEG(GMTSEGN,GMSEL,0))'>0 D NOSELECT^GMTS2 Q
        S GMTSNPG=0,GMTSWRIT=1
        D @($P(GMTSEGR,";",1)_U_$P(GMTSEGR,";",2))
        D NODATA^GMTS2 S GMTSWRIT=1
        K GMTSDLM
        Q
