PSGOE41 ;BIR/CML3-REGULAR ORDER ENTRY (CONT.) ;09 JAN 97 / 9:13 AM 
 ;;5.0; INPATIENT MEDICATIONS ;**50,63,64,69,58,111,136**;16 DEC 97
 ;
 ; Reference to %DT is supported by DBIA 10003.
 ; Reference to %DTC is supported by DBIA 10000.
 ; Reference to ^DICN is supported by DBIA 10009.
 ;
39 ; admin times
 G:$P(PSGNEDFD,"^",3)="P" 8
 I $$ODD^PSGS0(PSGS0XT) G 8
 W !,"ADMIN TIMES: "_$S(PSGS0Y:PSGS0Y_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
 I X="",($G(PSGS0XT)'="D") S PSGFOK(39)="" G 8
 I X="",$G(PSGS0XT)="D" I $L(PSGSCH,"@")=2,$P(PSGSCH,"@",2) S (PSGAT,PSGS0Y)=$P(PSGSCH,"@",2) G 8
 S PSGF2=39 I $E(X)="^" D FF G:Y>0 @Y G 39
 I (PSGS0XT="D")&('$G(X)!(X["@"&($P($G(X),"@",2)))) I ((",P,R,")'[(","_$G(PSGST)_",")) D  G 39
 .W $C(7),"  ??" S X="?" W !,"This is a 'DAY OF THE WEEK' schedule and MUST have admin times." D ENHLP^PSGOEM(53.1,39)
 ;I X="@",'PSGS0Y!(PSGS0XT="D")!(PSGSCH["@") W $C(7),"  ??" S X="?" W:PSGS0XT="D"!(PSGSCH["@") !,"This is a 'DAY OF THE WEEK' schedule and MUST have admin times." D ENHLP^PSGOEM(53.1,39) G 39
 I X="@" D DEL G:%'=1 39 S (PSGFOK(39),PSGS0Y)="" G 8
 I X?1."?" D ENHLP^PSGOEM(53.1,39) G 39
 D ENCHK^PSGS0 I '$D(X) W $C(7),"  ??" S X="?" D ENHLP^PSGOEM(53.1,39) G 39
 S (PSGAT,PSGS0Y)=X,PSGFOK(39)=""
 ;
8 ; special instructions
 W !,"SPECIAL INSTRUCTIONS: "_$S(PSGSI]"":$P(PSGSI,"^")_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
 I X="" S X=PSGSI I X="" S PSGFOK(8)="" G:'$G(PSGOE3) 10
 S PSGF2=8 I $E(X)="^" D FF G:Y>0 @Y G 8
 I X="@",PSGSI="" W $C(7),"  ??" S X="?" D ENHLP^PSGOEM(53.1,8) G 8
 I X="@" D DEL G:%'=1 8 S (PSGFOK(8),PSGSI)="" G:'$G(PSGOE3) 10
 I X?1."?" D ENHLP^PSGOEM(53.1,8) G 8
 D ^PSGSICHK I '$D(X) W $C(7)," ??" S X="?" D ENHLP^PSGOEM(53.1,8) G 8
 S PSGSI=X I PSGSI]"" S PSGSI=$$ENBCMA^PSJUTL("U"),PSGFOK(8)=""
 Q:$G(PSGOE3)
 ;
10 ; start date/time
 D ^PSGNE3
 S:'$D(PSGNESDO) PSGNESDO=$$ENDD^PSGMI(PSGNESD) S PSGSD=PSGNESDO
A10 W !,"START DATE/TIME: "_PSGSD_"// " R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
 I X="",PSGNESD W "  "_PSGSD G O25
 I X="P" D ENPREV^PSGDL W:'$D(X) $C(7) G:'$D(X) A10 S PSGNESD=+X,PSGSD=$$ENDD^PSGMI(+X) W "  ",PSGSD G O25
 S PSGF2=10 I X="@"!(X?1."?") W:X="@" $C(7),"  (Required)" S:X="@" X="?" D ENHLP^PSGOEM(53.1,10)
 I $E(X)="^" D FF G:Y>0 @Y G A10
 NEW TMPX S TMPX=X,X1=PSGDT,X2=-7 D C^%DTC K %DT S %DT="ERTX",%DT(0)=X,X=TMPX D ^%DT K %DT I Y'>0 D ENHLP^PSGOEM(53.1,10) G A10
 S PSGNESD=+Y,PSGSD=$$ENDD^PSGMI(+Y),(PSGNEFD,PSGFD)=""
 ;
O25 ;
 S PSGFOK(10)="" I $P(PSGNEDFD,"^",3)="O" S PSGNEFD=$$ENOSD^PSJDCU(PSJSYSW0,PSGNESD,PSGP) I PSGNEFD]"" S PSGFD=$$ENDD^PSGMI(PSGNEFD)
 ;
25 ; stop date
 Q:$G(PSGOE3)
 I 'PSGNEFD D ENFD^PSGNE3(PSGDT) S PSGFD=PSGNEFDO
A25 W !,"STOP DATE/TIME: "_$S(PSGFD]"":PSGFD_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
 I X="",PSGNEFD W "   "_PSGFD S PSGFOK(25)=""  G W25
 S PSGF2=25 I $E(X)="^" D FF G:Y>0 @Y G A25
 ;I X=+X,(X'>0) S X="?"
 I X="@"!(X?1."?") W:X="@" $C(7),"  (Required)" S:X="@" X="?" D ENHLP^PSGOEM(53.1,25)
 I X=+X,(X>0),(X'>2000000) G A25:'$$ENDL^PSGDL(PSGSCH,X) K PSGDLS S PSGDL=X W " ...dose limit..." D EN1^PSGDL
 K %DT S %DT="ERTX",%DT(0)=PSGNESD D ^%DT K %DT G:Y'>0 A25 S PSGNEFD=+Y,PSGFD=$$ENDD^PSGMI(+Y),PSGFOK(25)=""
W25 I PSGNEFD<PSGDT W $C(7),!!?13,"*** WARNING! THE STOP DATE ENTERED IS IN THE PAST! ***",!
 ;Display Expected First Dose;BHW;PSJ*5*136
 D EFDNEW^PSJUTL
 ;
NEXT ;
 ;G:$S($D(PSJOERR):0,+PSJSYSU=3:1,1:'$P(PSJSYSU,";",2)) 1^PSGOE42 G:$P(PSJSYSW0,"^",24) 5^PSGOE42 G:PSGOEORF&'$P(PSJSYSU,";",2) 106^PSGOE42
 G 1^PSGOE42
 ;
DONE ;
 I PSGOROE1 K Y W $C(7),"  ...order not entered..."
 K F,F0,F1,PSGF2,F3,PSG,SDT Q
 ;
FF ; up-arrow to another field
 D ENFF^PSGOEM I Y>0,Y'=39,Y'=8,Y'=10,Y'=25 S Y=Y_"^PSGOE4"_$S("^109^13^3^7^26^"[("^"_Y_"^"):"",1:2) S:$P(Y,U)=2 FB=PSGF2_"^PSGOE41"
 Q
 ;
DEL ; delete entry
 W !?3,"SURE YOU WANT TO DELETE" S %=0 D YN^DICN I %'=1 W $C(7),"  <NOTHING DELETED>"
 Q
