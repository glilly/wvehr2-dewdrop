IMRRISK ;HCIOFO/FT-Calculate Patient's Risk ;7/17/97  09:47
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
RISK ; set IMR RISK
 ; called from the IMR CDC3 input template
 S XC0=^IMR(158,DA,0),IMRX=+$P(XC0,U,42),XC1=$G(^(1)),XC2=$G(^(2)),XC102=$G(^(102)),XC110=$G(^(110)),IMRRISK=""
 I IMRSEX="M"!(IMRSEX=""),$P(XC2,U,21)="1" S IMRRISK=1 ;homosexual
 I $P(XC1,U,26)=1 S IMRRISK=$S(IMRRISK="":2,1:3) ;2=iv drugs, 3=iv drugs & homosexual
 I IMRRISK="",$P(XC1,U,21)=1 S IMRRISK=6 ;transfusion
 I IMRRISK="",$P(XC2,U,53)=1 S IMRRISK=4 ;clotting factor
 I IMRRISK="",$P(XC1,U,24)=1 S IMRRISK=7 ;work-health/clinical
 I IMRRISK="",$P(XC102,U,14)=1 S IMRRISK=6 ;tissue/organs/a.i.
 I IMRRISK="" F I=28:1:32 I $P(XC1,U,I)=1 S IMRRISK=5 Q  ;heterosexual
 I IMRRISK="",$P(XC1,U,33)=1 S IMRRISK=9 ;cannot be classified into known category
 I IMRRISK="",$P(XC110,U,3)=1 S IMRRISK=5 ;heterosexual
 I IMRRISK="",IMRSEX="M"!(IMRSEX=""),$P(XC2,U,23)=1 S IMRRISK=5 ;heterosexual
 I IMRRISK="" D  I IMRRISK'="" S IMRRISK=9 ;"UNKNOWN"
 . F I=21,23,53 Q:IMRRISK'=""  I $P(XC2,U,I)'="" S IMRRISK=1
 . F I=21,24,26,28:1:33 Q:IMRRISK'=""  I $P(XC1,U,I)'="" S IMRRISK=1
 . I $P(XC102,U,14)'=""!($P(XC110,U,3)'="") S IMRRISK=1
 . Q
 I IMRRISK="" S IMRRISK="" ;"UNREPORTED"
 S $P(^IMR(158,DA,0),U,45)=IMRRISK
 K XC0,XC1,XC2,XC102,XC110,IMRRISK
 Q
