IMRCDP8 ;HCIOFO/NCA - Display CDC Form (Cont.) ;6/18/97  16:31
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !,"================================================================================================================================="
 S LN="",$P(LN,"_",130)=""
 W !,"X. COMMENTS:"
 W ! S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,10.01,"E"),1:"") W X_$P(LN,"_",1,(130-$L(X)))
 W ! S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,11.01,"E"),1:"") W X_$P(LN,"_",1,(130-$L(X)))
 W ! S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,12.01,"E"),1:"") W X_$P(LN,"_",1,(130-$L(X)))
 W:($E(IOST,1,2)'="C-"&IMRCOPI'=IMRCOPY) @IOF
 Q
