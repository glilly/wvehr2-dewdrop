GMTSLRT ; SLC/JER,KER - Blood Bank Transfusion       ; 11/26/2002
 ;;2.7;Health Summary;**28,47,59**;Oct 20, 1995
 ;                   
 ; External References
 ;   DBIA    525  ^LR( all fields
 ;   DBIA   2056  $$GET1^DIQ (file 2)
 ;   DBIA   3176  TRAN^VBECA4
 ;                   
MAIN ; Blood Transfusion
 N GMA,GMI,GMR,IX,MAX,A,R,TD,BPN,LOC
 S LOC="LRT",LRDFN=$$GET1^DIQ(2,+($G(DFN)),63,"I")
 ;                    
 ; Get Transfusion Records
 ;   Blood Bank Package  TRANS^VBECA4
 ;   Lab Package         ^GMTSLRTE
 ;                    
 D:+($$ROK^GMTSU("VBECA4"))>0 TRAN^VBECA4(DFN,LOC,GMTS1,GMTS2)
 D:+($$ROK^GMTSU("VBECA4"))'>0 ^GMTSLRTE
 Q:'$D(^TMP("LRT",$J))
 S MAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:999),IX=GMTS1
 F GMI=1:1:MAX S IX=$O(^TMP("LRT",$J,IX)) Q:IX=""!(IX>GMTS2)  D
 . S GMR=^TMP("LRT",$J,IX) D PRSREC,WRT
 I $O(^TMP("LRT",$J,"A"))'="" D
 . D CKP^GMTSUP Q:$D(GMTSQIT)  W !
 . D CKP^GMTSUP Q:$D(GMTSQIT)  W " Blood Product Key: "
 S GMI="A" F  S GMI=$O(^TMP("LRT",$J,GMI)) Q:GMI=""  D
 . D CKP^GMTSUP Q:$D(GMTSQIT)
 . W ?21,GMI," = ",$G(^TMP("LRT",$J,GMI)),!
 K ^TMP("LRT",$J)
 Q
PRSREC ; Parses Record for presentation
 N GMI,X S X=$P(GMR,U) D REGDT4^GMTSU S TD=X
 S GMA(1)=$P(GMR,U,2),BPN=$L(GMA(1),";")
 I $P(GMA(1),";",BPN)="" S BPN=BPN-1
 F GMI=2:1:BPN S GMA(GMI)="("_$P($P(GMA(1),";",GMI),"\")_") "_$P($P(GMA(1),";",GMI),"\",2)
 S GMA(1)="("_$P($P(GMA(1),";",1),"\")_") "_$P($P(GMA(1),";",1),"\",2)
 Q
WRT ; Writes the Transfusion Record for each day
 N GML,GMI1,GMI2,GMM,GMJ S GMM=$S(BPN#4:1,1:0),GML=BPN\4+GMM
 D CKP^GMTSUP Q:$D(GMTSQIT)  W TD
 F GMI1=1:1:GML D  Q:$D(GMTSQIT)
 . F GMI2=1:1:($S((GMI1=GML)&(BPN#4):BPN#4,1:4)) D  Q:$D(GMTSQIT)
 . . S GMJ=((GMI1-1)*4)+GMI2 D CKP^GMTSUP Q:$D(GMTSQIT)
 . . W ?(((GMI2-1)*15)+10),GMA(GMJ)
 . . I $S(GMI2#4=0:1,GMI2=BPN:1,GMI2+(4*(GMI1-1))=BPN:1,1:0) W !
 Q
