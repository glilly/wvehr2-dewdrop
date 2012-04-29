IMRSHO ;ISC-SF/JLI,HCIOFO/FT-SHOW FEATURES OF ENCRYPTION FOR IMR PKG ;10/17/97  9:35
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ;[IMR SHOW CODE] - Encryption of Data (Demonstration)
 I '$D(^XUSEC("IMRA",DUZ)) S IMRLOC="IMRSHO" D ACESSERR^IMRERR,H^XUS K IMRLOC
 W !!,"This option demonstrates some of the encryption features for the IMR package",!,"No entries will be made in the Immunology Case Study file, so you can select",!,"any patient to see what he/she would look like.",!!
ASK S DIC=2,DIC(0)="AEQM" D ^DIC G:Y'>0 EXIT
 S (DFN,IMRDFN)=+Y D DEM^VADPT
 S IMRNAME=VADM(1),IMRSSN1=$P(VADM(2),U),IMRDOB1=$P(VADM(3),U)
 K DFN,VA,VADM
 W !!,"Patient's number in the Patient file: ",IMRDFN
 W !?32,"Name: ",IMRNAME
 W !?33,"SSN: ",IMRSSN1
 S X=IMRDOB1,X1=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 W !?23,"Date of Birth: ",X1
 S X=IMRDFN D ^IMRXOR S IMRX=X,X=+IMRSSN1 D ^IMRXOR
 S IMRSSN=X_$S(IMRSSN1["P":"P",1:""),X=$E(IMRDOB1,1,5)_"00" D ^IMRXOR
 S IMRDOB=X
 W !!,"Patient's id in the Immunology Case Study file: ",IMRX
 W !?37,"Coded SSN: ",IMRSSN
 W !?27,"Coded Date of Birth: ",IMRDOB,!
 G ASK
 ;
EXIT K C,DIC,%,%H,%Y,DIPGM,IMRSTN,IMRDFN,IMRNAME,IMRSSN1,IMRDOB1,IMRX,IMRSSN,IMRDOB,X,Y,X1,VAERR,DISYS,D,POP
 Q
