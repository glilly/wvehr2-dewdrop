DGPTAEE1        ;ALB/MTC - Austin Edits EAL Listing Continued ; 14 DEC 92
        ;;5.3;Registration;**338,565,678,729,664**;Aug 13, 1993;Build 15
        ;
H101(REC)       ;-- 101 header
        ; INPUT : REC - Node that contains the error
        N I,X,X1,X2
        S X="ADM    SSN       ADM-DATE-TIME LAST-NAME     INIT SOU FROM  SOP POW MS SX"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,1,4)_"  "_$E(REC,5,14)_SP_$E(REC,15,16)_SP_$E(REC,17,18)_SP_$E(REC,19,20)_SP_$E(REC,21,24)_SP_$E(REC,31,42)_"   "_$E(REC,43,44)_"   "_$E(REC,45,46)_SP_$E(REC,47,52)_SP_$E(REC,53)_"   "_$E(REC,54)_"   "_$E(REC,55)_"  "_$E(REC,56)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")<12 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="BIRTHDATE    POS AGO ION ST-CNTY  ZIP   MT INCOME MST CV CV-END SHAD ERI CNTRY"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,57,58)_SP_$E(REC,59,60)_SP_$E(REC,61,64)_"   "_$E(REC,65,66)_"    "_$E(REC,67)_"   "_$E(REC,68)_"  "_$E(REC,69,73)_"  "_$E(REC,74,78)_"  "_$E(REC,79,80)_SP_$E(REC,81,86)_"  "_$E(REC,87)_"   "_$E(REC,88)_" "_$E(REC,89,94)
        S X=X_"    "_$E(REC,95)_"  "_$E(REC,96)_"   "_$E(REC,97,99)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")>11 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        D WRER^DGPTAEE
        Q
        ;
H401(REC)       ;-- 401 header
        ; INPUT : REC - Node that contains the error
        N X,X1,X2
        S X="SURG   SSN       ADM-DATE-TIME SURG-DATE-TIME  SPEC CATEG TECH SOP"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,1,4)_"  "_$E(REC,5,14)_SP_$E(REC,15,16)_SP_$E(REC,17,18)_SP_$E(REC,19,20)_SP_$E(REC,21,24)_"  "_$E(REC,31,32)_SP_$E(REC,33,34)_SP_$E(REC,35,36)_SP_$E(REC,37,40)_"   "
        S X=X_$E(REC,41,42)_"  "_$E(REC,43)_"   "_$E(REC,44)_"   "_$E(REC,45)_"   "_$E(REC,46)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")<9 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="------------SURGICAL CODES-------------  PHY SSN   TRNSPLNT"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,47,53)_SP_$E(REC,54,60)_SP_$E(REC,61,67)_SP_$E(REC,68,74)_SP_$E(REC,75,81)_"  "_$E(REC,82,90)_"     "_$E(REC,91)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")>8 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        D WRER^DGPTAEE
        Q
        ;
H501(REC)       ;-- 501 header
        ; INPUT : REC - Node that contains the error
        N X,X1,X2
        S X="DIAG   SSN       ADM-DATE-TIME MOVE DATE-TIME MPCR CODE SPC LVE PASS SCI"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,1,4)_"  "_$E(REC,5,14)_SP_$E(REC,15,16)_SP_$E(REC,17,18)_SP_$E(REC,19,20)_SP_$E(REC,21,24)_SP_$E(REC,31,32)_SP_$E(REC,33,34)_SP_$E(REC,35,36)_SP_$E(REC,37,40)_SP
        S X=X_"  "_$E(REC,41,46)_"  "_$E(REC,47,48)_"  "_$E(REC,49,51)_"  "_$E(REC,52,54)_"  "_$E(REC,55)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")<10 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="-----------DIAGNOSTIC CODES------------"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,56,62)_SP_$E(REC,63,69)_SP_$E(REC,70,76)_SP_$E(REC,77,83)_SP_$E(REC,84,90)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")=10 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="SSN ATTY PHY PHY LOC  CDE BSI LI SI DRUG A4 A5   SC AO IR SWAC"
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X=$E(REC,91,99)_"    "_$E(REC,100,105)_"    "_$E(REC,106,107)_"  "_$E(REC,108)_"   "_$E(REC,109)_"  "_$E(REC,110)_SP_$E(REC,111,114)_"  "_$E(REC,115)_SP_$E(REC,116,119)_"  "_$E(REC,120)_"  "_$E(REC,121)_"  "_$E(REC,122)_"  "_$E(REC,123)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        S X="",$P(X," ",80)=" " F X1=1:1 S I=$P(DGER,",",X1) Q:I=""  I $P(I,":")>10 S X2=+$P(I,":",2),X=$E(X,1,X2-1)_"#"_$E(X,X2+1,80)
        S VALMCNT=VALMCNT+1,^TMP("AD",$J,VALMCNT,0)=X
        D WRER^DGPTAEE
        Q
        ;
