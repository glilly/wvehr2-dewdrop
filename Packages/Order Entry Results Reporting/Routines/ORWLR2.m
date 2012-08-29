ORWLR2 ; slc/dcm -  VBEC Blood Bank Report ;01/16/03  15:02
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**172**;Dec 17, 1997
 ;from ORWLR1 - Re-write of ^LR7OSBR1
EN ;
 N %DT,A,B,C,CMT,H,ID,J,ORI,T,X,X0,Y,PARENT
 D H
 ;
 ;Get Antibodies
 D ABID^VBECA1(PATID,PATNAM,PATDOB,.PARENT,.ARR)
 I $O(ARR("ABID",0)) D
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(4,.CCNT,"Antibodies identified: ",.CCNT),ID=0
 . F  S ID=$O(ARR("ABID",ID)) Q:'ID  D
 .. I CCNT>(GIOM-15) D LN S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"   ",.CCNT)
 .. S ^TMP("ORLRC",$J,GCNT,0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(CCNT,.CCNT,$P(ARR("ABID",ID),"^"),.CCNT)_$$S^ORU4(CCNT,.CCNT," : "_$P(ARR("ABID",ID),"^",2),.CCNT)
 ;
 ;Get Transfusion reactions 
 ;Note TRRX API there's no way to differentiate between reactions with or without units identified.
 D TRRX^VBECA1(PATID,PATNAM,PATDOB,.PARENT,.ARR)
 I $O(ARR("TRRX",0)) D
 . D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM),LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(0,.CCNT,"TRANSFUSION REACTIONS",.CCNT)_$$S^ORU4(51,.CCNT,"UNIT ID",.CCNT)_$$S^ORU4(66,.CCNT,"COMPONENT",.CCNT)
 . S ID=0 F  S ID=$O(ARR("TRRX",ID)) Q:'ID  S X=ARR("TRRX",ID) D
 .. S Y=$TR($$FMTE^XLFDT(+X,"M"),"@"," ")
 .. D LN
 .. S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(0,.CCNT,Y,.CCNT)_$$S^ORU4(21,.CCNT,$P(X,U,2),.CCNT)_$$S^ORU4(51,.CCNT,$P(X,U,4),.CCNT)_$$S^ORU4(69,.CCNT,$P(X,U,3),.CCNT)
 .. I $O(ARR("TRRX",ID,0)) D
 ... S CMT=0 F  S CMT=$O(ARR("TRRX",ID,CMT)) Q:'CMT  S C=ARR("TRRX",ID,CMT) D
 .... D LN
 .... S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(0,.CCNT,"  "_C,.CCNT)
 D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM)
 ;
 ;Get Xmatched units, Component requests, AHG
 K ^TMP("BBD",$J)
 D DFN^VBECA3A(DFN),CPRS^VBECA3B
 D CX,C,TRAN,AHG
 ;
 ;Get Specimen Tests
 I '$O(^TMP("BBD",$J,"SPECIMEN",0)) Q
 S ORI=""
 F  S ORI=$O(^TMP("BBD",$J,"SPECIMEN",ORI),-1) Q:ORI=""  D
 . S ID=^TMP("BBD",$J,"SPECIMEN",ORI)
 . Q:'$L($P(ID,"^"))
 . S T=ORI
 . D T,LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(4,.CCNT,T,.CCNT)
 . D W
 K ^TMP("BBD",$J)
 Q
W ;
 S ^(0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(21,.CCNT,$J($P(ID,"^",3),2),.CCNT)
 S ^(0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(24,.CCNT,$E($P(ID,"^",9),1,3),.CCNT)
 F H=5,6,7,8,10 S Y=$P(ID,"^",H) S ^(0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4((30+$S(H=6:5,H=7:10,H=8:15,H=10:32,1:0)),.CCNT,$E(Y,1,3),.CCNT)
 F X=10.3,11.3,2.91 I $D(^TMP("BBD",$J,"SPECIMEN",ORI,X)) S J=0 D
 . I $D(^TMP("BBD",$J,"SPECIMEN",ORI,X))#2 D LN S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,ORN(X)_":"_^TMP("BBD",$J,"SPECIMEN",ORI,X),.CCNT)
 I $D(^TMP("BBD",$J,"SPECIMEN",ORI,"63.012,.01")) S J=0 F  S J=$O(^TMP("BBD",$J,"SPECIMEN",ORI,"63.012,.01",J)) Q:'J  D
 . S X=^TMP("BBD",$J,"SPECIMEN",ORI,"63.012,.01",J)
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"ELUATE ANTIBODY: "_X,.CCNT)
 ;
 I $D(^TMP("BBD",$J,"SPECIMEN",ORI,"63.46,.01")) S J=0 F  S J=$O(^TMP("BBD",$J,"SPECIMEN",ORI,"63.46,.01",J)) Q:'J  D
 . S X=^TMP("BBD",$J,"SPECIMEN",ORI,"63.46,.01",J)
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"SERUM ANTIBODY IDENTIFIED: "_X,.CCNT)
 ;
 I $D(^TMP("BBD",$J,"SPECIMEN",ORI,"63.01,8")) S J=0 F  S J=$O(^TMP("BBD",$J,"SPECIMEN",ORI,"63.01,8",J)) Q:'J  D
 . S X=^TMP("BBD",$J,"SPECIMEN",ORI,"63.01,8",J)
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"ANTIBODY SCREEN COMMENT: "_X,.CCNT)
 ;
 I $D(^TMP("BBD",$J,"SPECIMEN",ORI,"63.48,.01")) S J=0 F  S J=$O(^TMP("BBD",$J,"SPECIMEN",ORI,"63.48,.01",J)) Q:'J  D
 . S X=^TMP("BBD",$J,"SPECIMEN",ORI,"63.48,.01",J)
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"ANTIBODY SCREEN COMMENT: "_X,.CCNT)
 ;
 I $D(^TMP("BBD",$J,"SPECIMEN",ORI,"63.199,.01")) S J=0 F  S J=$O(^TMP("BBD",$J,"SPECIMEN",ORI,"63.199,.01",J)) Q:'J  D
 . S X=^TMP("BBD",$J,"SPECIMEN",ORI,"63.199,.01",J)
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(8,.CCNT,X,.CCNT)
 Q
T ;Set Date/time format
 S T=$$FMTE^XLFDT(T,2)
 Q
CX ;Crossmatch
 N A,CNT,F,LOCAT
 I '$O(^TMP("BBD",$J,"CROSSMATCH",0)) D  Q
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"No UNITS assigned/xmatched",.CCNT)
 . D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM)
 D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM),LN
 S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(6,.CCNT,"Unit assigned/xmatched:",.CCNT)_$$S^ORU4(46,.CCNT,"Exp date",.CCNT)_$$S^ORU4(64,.CCNT,"Loc",.CCNT)
 S (CNT,A)=0 F  S A=$O(^TMP("BBD",$J,"CROSSMATCH",A)) Q:'A  D
 . S F=^TMP("BBD",$J,"CROSSMATCH",A),CNT=CNT+1,LOCAT=$S($L($P(F,"^",7)):$P(F,"^",7),1:"BB-"_$P(F,"^",6))
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,$J(CNT,2)_")",.CCNT)_$$S^ORU4(6,.CCNT,$P(F,"^"),.CCNT)_$$S^ORU4(17,.CCNT,$E($P(F,"^",2),1,19),.CCNT)_$$S^ORU4(38,.CCNT,$P(F,"^",3)_" "_$E($P(F,"^",4),1,3),.CCNT)
 . S ^(0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(45,.CCNT,$P(F,"^",5),.CCNT)_$$S^ORU4(64,.CCNT,LOCAT,.CCNT)
 D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM)
 Q
C ;Component Request
 N %DT,A,F,T,X,Y
 I '$O(^TMP("BBD",$J,"COMPONENT REQUEST",0)) D  Q
 . D LN S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"No component requests",.CCNT)
 D LN
 S X="Component requests"
 S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,X,.CCNT)_$$S^ORU4(26,.CCNT,"Units",.CCNT)_$$S^ORU4(32,.CCNT,"Request date",.CCNT)_$$S^ORU4(49,.CCNT,"Date wanted",.CCNT)_$$S^ORU4(65,.CCNT,"Requestor",.CCNT)_$$S^ORU4(77,.CCNT,"By",.CCNT)
 S A=0 F  S A=$O(^TMP("BBD",$J,"COMPONENT REQUEST",A)) Q:'A  D
 . S F=^TMP("BBD",$J,"COMPONENT REQUEST",A),T="",%DT="T",X=$P(F,"^",3),Y=-1
 . I $L(X) D ^%DT
 . I Y'=-1 S T=Y D T
 . D LN
 . S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,$E($P(F,"^"),1,25),.CCNT)_$$S^ORU4(26,.CCNT,$J($P(F,"^",2),3),.CCNT)_$$S^ORU4(32,.CCNT,T,.CCNT)
 . S T="",%DT="T",X=$P(F,"^",4),Y=-1
 . I $L(X) D ^%DT
 . I Y'=-1 S T=Y D T
 . S X=$S($P(F,"^",6):$P(F,"^",6)_",",1:""),X=$S($L(X):$$GET1^DIQ(200,X,1),1:$P(F,"^",6))
 . S ^TMP("ORLRC",$J,GCNT,0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(49,.CCNT,T,.CCNT)_$$S^ORU4(65,.CCNT,$E($P(F,"^",5),1,10),.CCNT)_$$S^ORU4(77,.CCNT,X,.CCNT)
 Q
TRAN ;Transfusion Data
 K ^TMP("TRAN",$J)
 D TRAN^VBECA4(DFN,"TRAN")
 Q:'$O(^TMP("TRAN",$J,0))
 N ID,GMR,GMA,TD,C,BPN
 D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM),LN
 S X="Transfused Units ",^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,X,.CCNT),ID=0
 D LN
 F  S ID=$O(^TMP("TRAN",$J,ID)) Q:'ID  S GMR=^(ID) D
 . D PARSE^ORWLR1,WRT
 I $O(^TMP("TRAN",$J,"A"))'="" D
 . D LN
 . S X=" Blood Product Key: ",^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,X,.CCNT)
 S GMI="A",C=0
 F  S GMI=$O(^TMP("TRAN",$J,GMI)) Q:GMI=""  D
 . S X=GMI_" = "_$G(^TMP("TRAN",$J,GMI))
 . I C>0 D LN
 . S C=C+1,^TMP("ORLRC",$J,GCNT,0)=$G(^TMP("ORLRC",$J,GCNT,0))_$$S^ORU4(21,.CCNT,X,.CCNT)
 K ^TMP("TRAN",$J)
 Q
WRT  ; Sets the Transfusion Record for each day
  N GML,GMI1,GMI2,GMM,GMJ,CL
  S GMM=$S(BPN#4:1,1:0),GML=BPN\4+GMM
  D LN
  S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,TD,.CCNT)
  F GMI1=1:1:GML D
  . F GMI2=1:1:($S((GMI1=GML)&(BPN#4):BPN#4,1:4)) D
  .. S GMJ=((GMI1-1)*4)+GMI2,CL=(((GMI2-1)*15)+14)
  .. S ^TMP("ORLRC",$J,GCNT,0)=$G(^TMP("ORLRC",$J,GCNT,0))_$$S^ORU4(CL,.CCNT,GMA(GMJ),.CCNT)
  .. I $S(GMI2#4=0:1,GMI2=BPN:1,GMI2+(4*(GMI1-1))=BPN:1,1:0) D LN
  Q
H ;Header
 N X
 D LN
 S X=GIOM/2-(10/2+5),^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(X,.CCNT,"---- BLOOD BANK ----",.CCNT)
 D LN
 S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(1,.CCNT,"ABO Rh: "_ORABORH,.CCNT)
 Q
AHG ;AHG Data
 D LINE^ORU4("^TMP(""ORLRC"",$J)",GIOM),LN
 S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(30,.CCNT,"|---",.CCNT)_$$S^ORU4(39,.CCNT,"AHG(direct)",.CCNT)_$$S^ORU4(55,.CCNT,"---|",.CCNT)_$$S^ORU4(62,.CCNT,"|-AHG(indirect)-|",.CCNT)
 D LN
 S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(4,.CCNT,"Date/time",.CCNT)_$$S^ORU4(20,.CCNT,"ABO",.CCNT)_$$S^ORU4(24,.CCNT,"Rh",.CCNT)_$$S^ORU4(30,.CCNT,"POLY",.CCNT)_$$S^ORU4(35,.CCNT,"IgG",.CCNT)_$$S^ORU4(40,.CCNT,"C3",.CCNT)
 S ^(0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(45,.CCNT,"Interpretation",.CCNT)_$$S^ORU4(62,.CCNT,"(Antibody screen)",.CCNT)
 D LN
 S ^TMP("ORLRC",$J,GCNT,0)=$$S^ORU4(4,.CCNT,"---------",.CCNT)_$$S^ORU4(20,.CCNT,"---",.CCNT)_$$S^ORU4(24,.CCNT,"--",.CCNT)_$$S^ORU4(30,.CCNT,"----",.CCNT)_$$S^ORU4(35,.CCNT,"---",.CCNT)
 S ^(0)=^TMP("ORLRC",$J,GCNT,0)_$$S^ORU4(40,.CCNT,"---",.CCNT)_$$S^ORU4(45,.CCNT,"--------------",.CCNT)_$$S^ORU4(62,.CCNT,"-----------------",.CCNT)
 Q
LN ;Increment counts
 S GCNT=GCNT+1,CCNT=1
 Q
