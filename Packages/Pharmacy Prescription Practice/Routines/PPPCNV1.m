PPPCNV1 ;ALB/DMB - PRESC. PRACT. CONVERSION ROUTINES ;1/24/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
I2EDT(FMDT) ; Convert FileMan date to external format
 ;
 N Y
 ;
 S Y=FMDT X ^DD("DD") Q Y
 ;
E2IDT(EXTDT) ; Convert External Date To FileMan Format.
 ;
 N X,Y,DTOUT
 ;
 S X=EXTDT,%DT="" D ^%DT
 Q Y
 ;
DIFFDT(FMD1,FMD2) ;Return the difference between two fileman dates
 ;
 N X1,X2,X,%Y
 ;
 I +FMD2=0 Q FMD1
 S X1=FMD1,X2=FMD2
 D ^%DTC
 Q:'%Y -1
 Q:%Y X
 ;
DIFFTM(FMD1,FMD2) ;Return the time difference between two fileman dates
 ;
 N S1,S2,T1,T2,X1,X2,X,%Y,TIMEDIFF
 ;
 ; Get the difference in days
 ;
 S X1=$P(FMD1,"."),X2=$P(FMD2,".")
 D ^%DTC
 Q:'%Y -1
 S TIMEDIFF=X*24*60*60
 ;
 ; Now get the difference in times
 ;
 S T1=$P(FMD1,".",2)_"000000"
 S S1=($E(T1,1,2)*3600)+($E(T1,3,4)*60)+$E(T1,5,6)
 S T2=$P(FMD2,".",2)_"000000"
 S S2=($E(T2,1,2)*3600)+($E(T2,3,4)*60)+$E(T2,5,6)
 S TIMEDIFF=TIMEDIFF+(S1-S2)
 Q TIMEDIFF
 ;
SLASHDT(FMDT) ; Convert Fileman date to MM/DD/YYYY
 ;
 N YR,MO,DY
 ;
 S YR=1700+$E(FMDT,1,3) Q:YR<1701 -1
 S MO=$E(FMDT,4,5) Q:MO<1 -1
 S DY=$E(FMDT,6,7) Q:DY<1 -1
 Q MO_"/"_DY_"/"_YR
 ;
NOW() ; Get the current date/time
 ;
 N %,%H,%I,X
 ;
 D NOW^%DTC
 Q %
