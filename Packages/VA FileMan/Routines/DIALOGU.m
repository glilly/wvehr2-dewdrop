DIALOGU ;SFISC/MMW - FUNCTIONS FOR DIALOGS ;11/21/94  13:26
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q  ;not for interactive use
OUT(Y,DIALF,%F) ;convert FileMan Data to language dependant output format
 ;Y is the value to transform, DIALF is the type of data
 ;%F Only for "FMTE" node. Passed from FMTE^DILIBF, indicates date format.
 ;DIALF must correspond to at least a subscript in the language file
 ;for the english language (entry #1) but may also have corresponding
 ;entries for other languages
 I $D(Y)[0!($G(DIALF)="") Q ""
 N DINAKED,DIY S DINAKED=$$LGR^%ZOSV
 N DILANG S DILANG=+$G(DUZ("LANG")) S:DILANG<1 DILANG=1
 S DIY=$G(^DI(.85,DILANG,DIALF)) I DIY="" S:DILANG'=1 DIY=$G(^DI(.85,1,DIALF)) I DIY="" S Y="" G Q
 X DIY
Q D:DINAKED]""
 . I DINAKED["(" Q:$O(@(DINAKED))  Q
 . I $D(@(DINAKED))
 . Q
 Q Y
 ;
PRS(D0,X) ;parse language dependant user input
 ;D0 is an entry in the DIALOG file
 ;X is the user input
 ;the function returns the number of the matching command word
 ;plus the corresponding english text. If no match was found -1 will
 ;be returned. If there is no user input the function returns the
 ;null string.
 N DINAKED,Y S DINAKED=$$LGR^%ZOSV
 I '$D(^DI(.84,+$G(D0)))!($G(X)']"") S Y=0 G Q
 N R,I,I1,IL,T,W,%,DILANG
 S DILANG=+$G(DUZ("LANG")) S:DILANG<1 DILANG=1
 I DILANG>1,'$O(^DI(.84,D0,4,DILANG,1,0)) S DILANG=1
 S X=$$OUT(X,"UC"),U="^"
 S R=$S(DILANG=1:"^DI(.84,"_D0_",2)",1:"^DI(.84,"_D0_",4,"_DILANG_",1)")
 S (I,I1,%)=0 F  S I=$O(@R@(I)) Q:'I!%  S T=$$OUT(@R@(I,0),"UC") D
 .F IL=1:1 S W=$P(T,U,IL) Q:W=""!%  S I1=I1+1 S:$E(W,1,$L(X))=X %=I1_U_$P(@R@(I,0),U,IL)
 I '% S Y=-1 G Q
 I DILANG=1 S Y=% G Q
 S (I,I1)=0,%=+% F  S I=$O(^DI(.84,D0,2,I)) Q:'I!(I1=%)  S T=^(I,0) D
 .F IL=1:1 Q:$P(T,U,IL)=""!(I1=%)  S I1=I1+1,W=$P(T,U,IL)
 S Y=%_U_$G(W) G Q
