DGPTAEE2        ;ALB/MTC - Austin Edits EAL Report Continued ; 14 DEC 92
        ;;5.3;Registration;**8,338,415,565,729,664**;Aug 13, 1993;Build 15
        ;
H601(REC)       ;-- 601 error processing
        ; INPUT : REC - Record that contains the errors
        N X,X1
        S X="PROC     SSN     ADM-DATE-TIME PROC-DATE-TIME SPC  TYPE TRT"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,1,4)_"  "_$E(REC,5,14)_SP_$E(REC,15,16)_SP_$E(REC,17,18)_SP_$E(REC,19,20)_SP_$E(REC,21,24)_SP_$E(REC,31,32)_SP_$E(REC,33,34)_SP_$E(REC,35,36)_SP_$E(REC,37,40)_"  "
        S X=X_$E(REC,41,42)_"     "_$E(REC,43)_"  "_$E(REC,44,46)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="-----------PROCEDURE CODES-------------"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,47,53)_SP_$E(REC,54,60)_SP_$E(REC,61,67)_SP_$E(REC,68,74)_SP_$E(REC,75,81)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        D WRER^DGPTAEE
        Q
        ;
H701(REC)       ;-- 701 header
        ; INPUT : REC - Record that contains the errors
        N X,X1,X2
        S X="DISP   SSN       ADM-DATE-TIME DIS-DATE-TIME SPC  TYPE OP/RX VA/AUS PLACE RECVNG"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,1,4)_"  "_$E(REC,5,14)_SP_$E(REC,15,16)_SP_$E(REC,17,18)_SP_$E(REC,19,20)_SP_$E(REC,21,24)_SP_$E(REC,31,32)_SP_$E(REC,33,34)_SP_$E(REC,35,36)_SP_$E(REC,37,40)_SP
        S X=X_$E(REC,41,42)_"    "_$E(REC,43)_"     "_$E(REC,44)_"     "_$E(REC,45)_"      "_$E(REC,46)_"   "_$E(REC,47,52)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")<11 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="ASIH XXXX C/P  DXLS   ODX  MPCR CODE   PHY LOC  %SC LI SI DRUG A4 A5"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,53,55)_"    "_$E(REC,56)_"   "_$E(REC,57)_"   "_$E(REC,58,64)_"  "_$E(REC,65)_"  "_$E(REC,66,71)_"       "_$E(REC,72,73)_"     "_$E(REC,74,76)_"  "_$E(REC,77)_"  "_$E(REC,78)_SP_$E(REC,79,82)_"  "_$E(REC,83)_SP_$E(REC,84,87)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")>10 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="SC AO IR SWAC MST HNC ETH RACE         CV SHAD"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,88)_"  "_$E(REC,89)_"  "_$E(REC,90)_"  "_$E(REC,91)_"     "_$E(REC,92)_"   "_$E(REC,93)_"  "_$E(REC,94,95)_"  "_$E(REC,96,107)_"  "_$E(REC,108)_"  "_$E(REC,109)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        D WRER^DGPTAEE
        Q
        ;
H702(REC)       ;-- 702 header
        ; INPUT : REC - Record that contains the errors
        N X,X1
        S X="ADM    SSN       ADM-DATE-TIME DIS-DATE-TIME"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,1,4)_"  "_$E(REC,5,14)_SP_$E(REC,15,16)_SP_$E(REC,17,18)_SP_$E(REC,19,20)_SP_$E(REC,21,24)_SP_$E(REC,31,32)_SP_$E(REC,33,34)_SP_$E(REC,35,36)_SP_$E(REC,37,40)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="----------------------------DIAGNOSTIC CODES----------------------------"
        S X=$E(REC,41,47)_SP_$E(REC,48,54)_SP_$E(REC,55,61)_SP_$E(REC,62,68)_SP_$E(REC,69,75)_SP_$E(REC,76,82)_SP_$E(REC,83,89)_SP_$E(REC,90,96)_SP_$E(REC,97,103)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        D WRER^DGPTAEE
        Q
        ;
