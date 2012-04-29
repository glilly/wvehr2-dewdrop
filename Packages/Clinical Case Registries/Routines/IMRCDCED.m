IMRCDCED ;HCIOFO/FT/FAI-FIELDS FOR EDITING CDC FORM ;12/26/01  13:36
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**1,5,17,16**;Feb 09, 1998
CDC ; [IMR CDC ENTER/EDIT] - CDC Form Data Entry
 D EXIT S IMRNEW=0,IMRLOC="IMRCDCED"
 D CHK^IMREDIT K IMRNEW G:DA'>0 EXIT
 S IMRFN=DA,(IMRDFN,IMRP103)=+Y S DFN=+Y,IMRTSTLR=$P($G(^DPT(DFN,"LR")),U,1) D DEM^VADPT
 S:'$D(^IMR(158,DA,1)) ^(1)="" I $P(^(1),U,34)'=2,VADM(6)>0 S $P(^IMR(158,DA,1),U,34)=2 ;piece 34=Patient Status (1=alive,2=dead,9=unknown)
 K VA,VADM
 D CDC1
 D EXIT G CDC
CDC1 ; called from from above and IMREDIT routine
 W !!,"Select section of CDC form for editing:",!!?5,"    Patient ID Header (not edited)",!?5,"    Health Dept. Info (not edited)",!?5,"1.  Demographic Information",!?5,"2.  Facility of Diagnosis",!?5,"3.  Patient History"
 W !?5,"4.  Laboratory Data",!?5,"    Other Header Data (not edited)",!?5,"5.  Clinical Status",!?5,"6.  Treatment/Services Referrals"
 W !?5,"7.  Comments",!?5,"8.  The complete form (all of above)"
 R !!,"Select section (1 to 8): ",X:DTIME
 G:'$T!(X[U)!(X="") EXIT
 I X'=+X!(X<1!(X>8)) W $C(7),"  ??",!!,"Enter a number 1 to 8, or '^' or RETURN to quit" G CDC1
 S IMRCDC=X
 D:X<4!(X>4) ONSET
 D:(IMRCDC=4!(IMRCDC=8)) TESTS
 S IMRANS="" F IMRZ=1:1:7 I IMRZ=IMRCDC!(IMRCDC=8) D INPUT Q:IMRANS="^"
 G CDC1
 ;
INPUT ; Entry Point to the seven Input Templates
 ; CDC1 - Demographic information (III)
 ; CDC2 - Facility of Diagnosis
 ; CDC3 - Patient History (V)
 ; CDC4 - Lab Data (VI)
 ; CDC5 - Clinical Status (VIII)
 ; CDC6 - Treatment/Services Referrals (IX)
 ; CDC7 - CDC Additional info/comments
 S DIE=158,X="IMR"_$P(" CDC1^ CDC2^ CDC3^ CDC4^ CDC5^ CDC6^ CDC7",U,IMRZ)
 K DR S DR="["_X_"]" D ^DIE S:$D(Y)!($D(DTOUT)) IMRANS="^" Q:IMRANS="^"
 K Y0 I IMRZ=5 D CDC5
 Q
ONSET ;
 Q:'$D(DFN)
 S VAPA("P")="" Q:DFN=""  D ADD^VADPT,DEM^VADPT
 S IMRSEX=$P($G(VADM(5)),U) K VA,VADM
 I IMRCDC=4 K VAPA Q
 S IMRCTYON=VAPA(4),IMRCONON="U.S.A.",IMRSON=$P(VAPA(5),U,1),IMRCOUON=$P(VAPA(7),U,2),IMRZON=VAPA(6) K VAPA
 S IMRX=$S($D(^IMR(158,DA,1)):^(1),1:"")
 S:$P(IMRX,U,10)="" $P(IMRX,U,10)=IMRCTYON ;city at onset of illness
 S:$P(IMRX,U,11)="" $P(IMRX,U,11)=IMRCOUON ;county at onset
 S:$P(IMRX,U,12)="" $P(IMRX,U,12)=IMRSON ;state at onset
 S:$P(IMRX,U,13)="" $P(IMRX,U,13)=IMRCONON ;country at onset
 S:$P(IMRX,U,14)="" $P(IMRX,U,14)=IMRZON ;zip code at onset
 S ^IMR(158,DA,1)=IMRX
 K IMRX,IMRCTYON,IMRCONON,IMRCOUON,IMRZON,IMRSON
 Q
TESTS ; Get last Elisa and Western Blot tests
 D ^IMRTST
 Q
DX ; called from IMR CDC1 input template
 S IMRX=$S($D(^IMR(158.9,1,4)):^(4),1:"")
 S IMRY=$S($D(^IMR(158,DA,1)):^(1),1:"") S:'$D(^(2)) ^(2)=""
 S:$P(^IMR(158,DA,2),U,54)="" $P(^(2),U,54)=$P(IMRX,U,6) ;hospital where aids diagnosed
 S:$P(IMRY,U,16)="" $P(IMRY,U,16)=$P(IMRX,U,3) ;city where aids diagnosed
 S:$P(IMRY,U,17)="" $P(IMRY,U,17)=$P(IMRX,U,4) ;state where diagnosed
 S:$P(IMRY,U,18)="" $P(IMRY,U,18)="U.S.A" ;country where diagnosed
 S ^IMR(158,DA,1)=IMRY
 K IMRX,IMRY
 Q
CDC5 ; enter/edit diseases associated with patient
 Q:'$D(^XUSEC("IMRA",DUZ))
 W !!?10,"SELECT THE DISEASES THAT APPLY",!?10,"Enter 'N' to remove a disease incorrectly selected.",!!
ASK ;
 K IMRXA S IMRIX="7,8.2,7.1,8.3,102.15,8.4,7.2,8.5,7.3,102.16,7.4,8.6,7.5,8.7,7.6,8.8,7.7,102.17,7.8,8.9,7.9,9,8,9.1,8.1,9.2"
 W !! S IMRK=0 F IMRII=1:2:25 D
 . W ! S IMRK=IMRK+1 W $J(IMRK,2),".  ",$P(^DD(158,+$P(IMRIX,",",IMRII),0),U) S IMRIJ=IMRII+1,IMRK=IMRK+1 W ?40,$J(IMRK,2),".  ",$P(^DD(158,+$P(IMRIX,",",IMRIJ),0),U)
 R !!?10,"Select Disease: ",X:DTIME Q:'$T  G:X=""!(X[U) END I $E(X)="?" W !,"Enter the number or first couple of characters of the desired disease" G ASK
 I X=+X,X>0,X<27 S IMRX=$P(IMRIX,",",X) G EDIT
 I X=+X W $C(7),"   ??" G ASK
 I X?.E1L.E F I=1:1 S IMRXA=$E(X,I) Q:IMRXA=""  I IMRXA?1L S IMRXA=$C($A(IMRXA)-32),X=$E(X,1,I-1)_IMRXA_$E(X,I+1,$L(X))
 S IMRXJ=0 F I=1:1:26 S IMRXA=$P(^DD(158,+$P(IMRIX,",",I),0),U) I $E(IMRXA,1,$L(X))=X S IMRXJ=IMRXJ+1,IMRXA(IMRXJ)=I_U_IMRXA
 I IMRXJ=0 W $C(7),"  ??" G ASK
 I IMRXJ=1 S X=$O(IMRXA(0)),X=+IMRXA(X),IMRX=$P(IMRIX,",",X) G EDIT
 W !!,"Please select the desired disease by number:",! F I=1:1:IMRXJ W !,I,"  ",$P(IMRXA(I),U,2)
 W !!?10,"Select (1 to ",IMRXJ,"): " R X:DTIME Q:'$T
 I X'=+X!(X<1)!(X>IMRXJ) W $C(7),"  ??",! G ASK
 S X=+IMRXA(X),IMRX=$P(IMRIX,",",X) G EDIT
 G ASK
EDIT S IMRY=108+$S(X#2:(X+1/200),1:X/200+.13)
 K DR S DIE=158,DR=IMRX_"R;I X=""N"" S Y=""@1"";"_IMRY_"R;S Y=""@2"";@1;"_IMRY_"///@;@2" D ^DIE K DR
 G ASK
END ; Print Diseases Currently Selected
 D DISP^IMRCDPR
 Q
EXIT I $G(IMRNEW)'="" Q
 K %,%T,%X,%Y,C,D0,DFN,DI,DIC,DIPGM,DNAM,DQ,DSC,DTAA,DTR1,DTR2,DTRC,DTRD,DTOUT,IMRANS,IMREDIT,IMRSTN,IMRXA,IMRXJ,IMRBLOT,IMRBLOTD,ILR,IMLM,IMLO,IMRDFN,IMRTSTI,IMRTSTII,IMS,IMWK,LDAT,LDO,LDT,LGN,LIG,LLOC,LNM,LRES,TNN,UNN,UNS
 K IMRTSTLR,IMRFN,IMRSEX,IMRELISA,IMRELISD,DIE,DR,DA,IMRCDC,IMRII,IMRIJ,IMRIX,IMRLOC,IMRP103,IMRZ,I,J,K,X,X1,X2,IMRXN,Y,Y0,VAERR,DGA1,DGT,%DT,DISYS,DZ,POP
 K IMRDATA,IMRXD,IMRX1,IMRD,IMRX,IMRSP,IMRXY,IMRCD,IMRCD4,IMRCD4D,IMRCD4E,IMRCD4X,IMRED1,IMRK,IMRPN,IMRPRC,IMRY,Y3,D,D1
 Q
