PSN168P ;BIR/DMA-REMOVE AMASTERVUID CROSS REFERENCES ; 29 Feb 2008  1:10 PM
        ;;4.0; NATIONAL DRUG FILE;**168**; 30 Oct 98;Build 8
        ;
        N FILE,SPEC,X,Y
        S SPEC("{pending directive #}")="2005-044"
        F FILE=50.416,50.6,50.605,50.68 S X="^DIC("_FILE_",""%D"")" F  S X=$Q(@X) Q:X'["%D"  S Y=@X I Y["{" S Y=$$REPLACE^XLFSTR(Y,.SPEC),@X=Y
        F FILE=50.416,50.605,50.6,50.68 D DELIX^DDMOD(FILE,99.98,1)
        F FILE=50.416,50.605 S X="^PS("_FILE_","_"""AMASTERVUID"")" F  S X=$Q(@X) Q:X'["AMASTERVUID"  I $QL(X)'=5 K @X
        F FILE=50.6,50.68 S X="^PSNDF("_FILE_","_"""AMASTERVUID"")" F  S X=$Q(@X) Q:X'["AMASTERVUID"  I $QL(X)'=5 K @X
        K FILE,SPEC,X,Y Q
