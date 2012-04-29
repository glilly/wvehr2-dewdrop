XQALDATA        ;ISC-SF/JLI - PROVIDE DATA ON ALERTS ;4/9/07  13:39
        ;;8.0;KERNEL;**207,285,443**;Jul 10, 1995;Build 4
        Q
GETUSER(ROOT,XQAUSER,FRSTDATE,LASTDATE) ;
        N XREF,XVAL,X,X2,X3,I,NCNT ; P443
        S:$G(XQAUSER)'>0 XQAUSER=DUZ
        S:$G(FRSTDATE)'>0 FRSTDATE=0
        S:$G(LASTDATE)'>0 LASTDATE=0
        S NCNT=0 K @ROOT
        I FRSTDATE=0 D  Q
        . F I=0:0 S I=$O(^XTV(8992,XQAUSER,"XQA",I)) Q:I'>0  S X=^(I,0),X3=$G(^(3)),X2=$G(^(2)) D
        . . S NCNT=NCNT+1
        . . S @ROOT@(NCNT)=$S($P(X3,U)'="":"G  ",$P(X,U,7,8)="^ ":"I  ",1:"   ")_$P(X,U,3)_U_$P(X,U,2)_$S($P(X2,U,3)'="":U_$P(X2,U,3),1:"") ; P443
        . S @ROOT=NCNT
        S XREF="R"
        S XVAL=XQAUSER
        D CHKTRAIL
        Q
GETPAT(ROOT,PATIENT,FRSTDATE,LASTDATE)  ;
        N XREF,XVAL,NCNT
        S NCNT=0 K @ROOT
        I $G(PATIENT)'>0 S @ROOT=0 Q
        S XREF="C"
        S XVAL=PATIENT
        D CHKTRAIL
        Q
CHKTRAIL        ;
        N XQ1,X,X1,X2,X3
        ; ZEXCEPT: FRSTDATE,LASTDATE,NCNT,ROOT,XREF,XVAL  -- from GETPAT or GETUSER
        F XQ1=0:0 S XQ1=$O(^XTV(8992.1,XREF,XVAL,XQ1)) Q:XQ1'>0  D
        . S X=$G(^XTV(8992.1,XQ1,0)),X1=$G(^(1)),X3=$G(^(3)),X2=$G(^(2)) Q:X=""
        . I FRSTDATE'>0,'$D(^XTV(8992,"AXQA",$P(X,U))) Q
        . I FRSTDATE>0,$P(X,U,2)<FRSTDATE Q
        . I FRSTDATE>0,LASTDATE>0,$P(X,U,2)>LASTDATE Q
        . S NCNT=NCNT+1
        . S @ROOT@(NCNT)=$S($P(X3,U)'="":"G  ",$P(X1,U,2,3)="^":"I  ",$P(X1,U,2,3)="":"I  ",1:"   ")_$P(X1,U)_U_$P(X,U)_$S($P(X2,U,3)'="":U_$P(X2,U,3),1:"") ; P443
        S @ROOT=NCNT
        Q
GETUSER1(ROOT,XQAUSER,FRSTDATE,LASTDATE)        ;
        N NCNT,KEY
        S:$G(XQAUSER)'>0 XQAUSER=DUZ
        S:$G(FRSTDATE)'>0 FRSTDATE=0
        S:$G(LASTDATE)'>0 LASTDATE=0
        S NCNT=0 K @ROOT
        I FRSTDATE=0 D  Q
        . N X,X2,X3,X4,I S I="" F  S I=$O(^XTV(8992,XQAUSER,"XQA",I),-1) Q:I'>0  S X=^(I,0),X2=$G(^(2)),X3=$G(^(3)),X4=$D(^(4)) D
        . . I $P(X,U,4)'="" S $P(^XTV(8992,XQAUSER,"XQA",I,0),U,4)="" ; MARK SEEN
        . . S NCNT=NCNT+1
        . . S KEY=$S($P(X3,U)'="":"G  ",X4>1:"L  ",$P(X,U,7,8)="^ ":"I  ",1:"R  "),@ROOT@(NCNT)=KEY_$P(X,U,3)_U_$P(X,U,2)
        . . I X2'="" D
        . . . S NCNT=NCNT+1,@ROOT@(NCNT)=KEY_"-----Forwarded by: "_$$GET1^DIQ(200,($P(X2,U)_","),.01)_"   Generated: "_$$DAT8^XQALERT($P(X2,U,2),1)_U_$P(X,U,2)
        . . . I $P(X2,U,3)'="" S NCNT=NCNT+1,@ROOT@(NCNT)=KEY_"-----"_$P(X2,U,3)_U_$P(X,U,2)
        . . . Q
        . S @ROOT=NCNT
        . Q
        Q
