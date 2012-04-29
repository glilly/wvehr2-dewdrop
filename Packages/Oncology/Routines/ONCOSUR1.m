ONCOSUR1 ;Hines OIFO/RTK - ONCOSUR CONTINUED ;1/13/98
 ;;2.11;ONCOLOGY;**15,18,19,22,36,38,40,41**;Mar 07, 1995
 ;
SCIT ;SCOPE OF LN SURGERY (R) (165.5,138) INPUT TRANSFORM
 S NTXDD=$G(NTXDD) I NTXDD="" Q
 S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" K X Q
 S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W "  No topography" K X Q
 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" K X Q
 ;pre-2003 C76.0-C76.8, C80.9 cases
 ;see ROADS page D-cxliii
 I ($G(FIELD)=138)!($G(FIELD)=138.1),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141 K FIELD
 S FOUND=0
 F XSC=0:0 S XSC=$O(^ONCO(164,ICD,"SC5",XSC)) Q:XSC'>0!(FOUND=1)  D
 .I $P(^ONCO(164,ICD,"SC5",XSC,0),U,2)=X S X=XSC,FOUND=1 Q
 I FOUND=0 K X Q
 W "  ",$P(^ONCO(164,ICD,"SC5",X,0),U,1)
 I $D(X),NTXDD=1 S V=0 D NT^ONCODSR
 K FOUND,ICD,SCDXDT,TOP,XSC Q
 ;
SCOT ;SCOPE OF LN SURGERY (R) (165.5,138) OUTPUT TRANSFORM
 Q:Y=""
 S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" S Y="" Q
 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
 ;pre-2003 C76.0-C76.8, C80.9 cases
 ;see ROADS page D-cxliii
 I ($G(FIELD)=138)!($G(FIELD)=138.1),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141 K FIELD
 S Y=$P($G(^ONCO(164,ICD,"SC5",Y,0)),U,1)
 K ICD,TOP Q
 ;
SCHP ;SCOPE OF LN SURGERY (R) (165.5,138) HELP
 S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No topography" Q
 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" W !,"No ICD Codes" Q
 ;pre-2003 C76.0-C76.8, C80.9 cases
 ;see ROADS page D-cxliii
 I ($G(FIELD)=138)!($G(FIELD)=138.1),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141 K FIELD
 W !?3,"Select from the following list:",!
 F XSC=0:0 S XSC=$O(^ONCO(164,ICD,"SC5",XSC)) Q:XSC'>0  W !?6,$P($G(^ONCO(164,ICD,"SC5",XSC,0)),U,2),?12,$P($G(^ONCO(164,ICD,"SC5",XSC,0)),U,1)
 K ICD,TOP,XSC Q
 ;
SOIT ;SURG OF OTHER SITES/NODES (165.5,139) INPUT TRANSFORM
 S NTXDD=$G(NTXDD) I NTXDD="" Q
 S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W "  No topography" K X Q
 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" K X Q
 ;pre-2003 C76.0-C76.8, C80.9 cases
 ;see ROADS page D-cxliii
 I ($G(FIELD)=139)!($G(FIELD)=139.1),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141 K FIELD
 S FOUND=0
 F XSO=0:0 S XSO=$O(^ONCO(164,ICD,"SO5",XSO)) Q:XSO'>0!(FOUND=1)  D
 .I $P(^ONCO(164,ICD,"SO5",XSO,0),U,2)=X S X=XSO,FOUND=1 Q
 I FOUND=0 K X Q
 W "  ",$P(^ONCO(164,ICD,"SO5",X,0),U,1)
 I $D(X),NTXDD=1 S V=0 D NT^ONCODSR
 K FOUND,ICD,TOP,XSO Q
 ;
SOOT ;SURG OF OTHER SITES/NODES (165.5,139) OUTPUT TRANSFORM
 Q:Y=""
 S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" S Y="" Q
 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
 ;pre-2003 C76.0-C76.8, C80.9 cases
 ;see ROADS page D-cxliii
 I ($G(FIELD)=139)!($G(FIELD)=139.1),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141 K FIELD
 S Y=$P($G(^ONCO(164,ICD,"SO5",Y,0)),U,1)
 K ICD,TOP Q
 ;
SOHP ;SURG OF OTHER SITES/NODES (165.5,139) HELP
 S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No topography" Q
 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" W !,"No ICD Codes" Q
 ;pre-2003 C76.0-C76.8, C80.9 cases
 ;see ROADS page D-cxliii
 I ($G(FIELD)=139)!($G(FIELD)=139.1),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141 K FIELD
 W !?3,"Select from the following list:",!
 F XSO=0:0 S XSO=$O(^ONCO(164,ICD,"SO5",XSO)) Q:XSO'>0  W !?6,$P($G(^ONCO(164,ICD,"SO5",XSO,0)),U,2),?12,$P($G(^ONCO(164,ICD,"SO5",XSO,0)),U,1)
 K ICD,TOP,XSO Q
 Q
 ;
NRIT ;NUMBER OF NODES REMOVED (165.5,140) INPUT TRANSFORM
 S NTXDD=$G(NTXDD) I NTXDD="" Q
 S X=+X
 I $L(X)=1 S X="0"_X
 I X="00" W "  No nodes removed"
 I X=90 W "  90 or more nodes removed"
 I X=95 W "  No nodes removed, aspiration performed"
 I X=96 W "  Node removal as a sampling, number unknown"
 I X=97 W "  Node removal as dissection, number unknown"
 I X=98 W "  Nodes surgically removed, number unknown"
 I X=99 W "  Unknown, not stated, death cert ONLY"
 I $D(X),NTXDD=1 S V=0 D NT^ONCODSR
 Q
 ;
NROT ;NUMBER OF NODES REMOVED (165.5,140) OUTPUT TRANSFORM
 Q:Y=""
 S Y=+Y
 I Y=0 S Y="No nodes removed"
 I ((Y>0)&(Y<90))!((Y>90)&(Y<95)) S:$L(Y)=1 Y=0_Y
 I Y=90 S Y="90 or more nodes removed"
 I Y=95 S Y="No nodes removed, aspiration performed"
 I Y=96 S Y="Node removal as a sampling, number unknown"
 I Y=97 S Y="Node removal as dissection, number unknown"
 I Y=98 S Y="Nodes surgically removed, number unknown"
 I Y=99 S Y="Unknown, not stated, death cert ONLY"
 Q
 ;
TOPIT ;PRIMARY SITE (165.5,20) INPUT TRANSFORM
 ;If PRIMARY SITE is changed, delete site-specific fields
 I X=67999 K X D  Q
 .W !!,"     UNKNOWN C99.9 is not allowed.  It is for"
 .W !,"     1997 Non-Hodgkin's Lymphoma PCE use only."
 .W !,"     (Item 12. Personal History of Any Cancer)"
 .W !,"     Use UNKNOWN PRIMARY C80.9",!
 I X=67888 K X D  Q
 .W !!,"     NA C88.8 is not allowed.  It is for"
 .W !,"     1997 Non-Hodgkin's Lymphoma PCE use only."
 .W !,"     (Item 12. Personal History of Any Cancer)",!
 S OLDTOP=$P($G(^ONCO(165.5,D0,2)),U,1) I OLDTOP="" D KILL Q
 S MSSG=0
 I X=OLDTOP Q
 S $P(^ONCO(165.5,D0,8),U,1)=""
 D ^ONCOSUR2
 S TOP=X,TOPCOD="",TOPNAM=""
 I TOP'="" S TOPNAM=$P(^ONCO(164,TOP,0),U,1),TOPCOD=$P(^ONCO(164,TOP,0),U,2)
 S SITTAB=79-$L($G(SITEGP)),TOPTAB=79-$L(TOPNAM_" "_TOPCOD)
 S NOS=TOPTAB-$L($G(PATNAM)),NOS=NOS-1 K SPACES S $P(SPACES," ",NOS)=" "
 D KILL Q
 ;
COCIT ;CLASS OF CASE (165.5,.04) INPUT TRANSFORM
 ;If Class of Case is changed, delete the existing @FAC fields
 S OLDCOC=$P($G(^ONCO(165.5,D0,0)),U,4) I OLDCOC="" K OLDCOC Q
 I OLDCOC=X Q
 I ((OLDCOC=1)!(OLDCOC=2))&((X=1)!(X=2)) Q
 I ((OLDCOC=0)!(OLDCOC=3)!(OLDCOC=6))&((X=0)!(X=3)!(X=6)) Q
 F PIECE=5:1:21 S $P(^ONCO(165.5,D0,3.1),U,PIECE)=""
 S $P(^ONCO(165.5,D0,3.1),U,23)=""
 S $P(^ONCO(165.5,D0,3.1),U,25)=""
 S $P(^ONCO(165.5,D0,3.1),U,30)=""
 S $P(^ONCO(165.5,D0,3.1),U,32)=""
 S $P(^ONCO(165.5,D0,3.1),U,34)=""
 K ATX,OLDCOC,PIECE Q
KILL ;
 K ICD,NEWSCG,NEWTNM,OLDCOC,OLDTNM,OLDTOP,OLDSCG,PIECE
 K SUBSITE,SITE,TXDT
 Q
