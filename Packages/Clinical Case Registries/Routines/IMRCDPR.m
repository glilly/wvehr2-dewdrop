IMRCDPR ;HCIOFO/NCA - Display Diseases For CDC Form ;7/10/95  14:33
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
DISP ; Display Diseases Currently Selected
 ; called from IMRCDCED routine
 S K=0 F I=1:1:26 D
 . S X1=$P(^DD(158,+$P(IMRIX,",",I),0),U,4),IMRXN=$P(^(0),U),X2=$P(X1,";"),J=+$P(X1,";",2) I $D(^IMR(158,DA,X2)) S X1=$P(^(X2),U,J)
 . I X1="D"!(X1="P")!(X1=1)!(X1=2) D
 . . S IMRX1=$S(X1="D"!(X1=1):"Definitive",1:"Presumptive")
 . . S IMRXD=108+(I+1/200),IMRXD=$S(I#2:IMRXD,1:IMRXD+.13)
 . . S J=IMRXD-108*100 S IMRD=$P($G(^IMR(158,DA,108)),U,J)
 . . S IMRSP="",$P(IMRSP," ",34)="",IMRXY=IMRXN_$E(IMRSP,1,($L(IMRSP)-$L(IMRXN)))
 . . S IMRDATA=$S(IMRD:$E(IMRD,4,5)_"/"_$E(IMRD,6,7)_"/"_$E(IMRD,2,3),1:"        ")_"  "_IMRXY_" - "_IMRX1_$S(IMRD:"",1:"  ** NO DATE **") S K=K+1
 . . S ^TMP($J,"IMRDIS",$S(IMRD:IMRD,1:9999999)_"~"_IMRXN)=IMRDATA
 . . Q
 . Q
 W !!,"Diseases Currently Selected:",!
 S X1="" F  S X1=$O(^TMP($J,"IMRDIS",X1)) Q:X1=""  S IMRX=$G(^(X1)) W !,IMRX
 W !
 K ^TMP($J,"IMRDIS")
 Q
