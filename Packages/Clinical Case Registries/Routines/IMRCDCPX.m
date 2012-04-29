IMRCDCPX ;ISC-SF/JLI-FUNCTION HANDLING FOR PRINTING CDC FORMS ;5/22/95  12:04
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ; called from IMRCDP* routines & from IMR function calls
VAL(FLD,X) ; FLD IS FIELD TO BE TESTED, X IS VALUE TO BE TESTED AGAINST
 N Y S Y="?" I IMRPT="" S Y="" G EXIT
 I $D(^DD(158,FLD,0)) S Y=$P(^(0),U,4) D
 .I $P(Y,";")'=" " S Y=$P($G(^IMR(158,IMRPT,$P(Y,";"))),U,+$P(Y,";",2)) S:Y'>0 Y=$S(Y="D":1,Y="P":2,Y="N":0,Y="Y":1,1:Y) Q
 .S Y=X S X=$$GET1^DIQ(158,IMRPT,FLD,"E") S:X="MALE" X=1 S:X="FEMALE" X=2 Q
 S Y=$S(Y=X:Y,Y="?":"?",FLD=112.06:"  ",1:" ")
EXIT Q Y
DAT(FLD) ; FLD IS FIELD TO BE DISPLAYED AS MO YR
 N Y S Y="?" I IMRPT="" S Y="" G EXIT1
 I $D(^DD(158,FLD,0)) S Y=$P(^(0),U,4) D
 .I $P(Y,";")'=" " S Y=$P($G(^IMR(158,IMRPT,$P(Y,";"))),U,+$P(Y,";",2)) Q
 .S X=$$GET1^DIQ(158,IMRPT,FLD,"E") S Y=X Q
 S Y=$S(Y="":"      ",$E(Y,1,7)?7N:$E(Y,4,5)_"  "_$E(Y,2,3),1:"??  ??")
EXIT1 Q Y
FIELD(FILE,ENTRY,FLD,FLG) ; FLD will contain the data of the file.
 S Y=$$GET1^DIQ(FILE,ENTRY,FLD,FLG)
 Q Y
