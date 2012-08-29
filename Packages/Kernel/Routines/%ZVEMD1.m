%ZVEMD1 ;DJB,VEDD**Main Menu, Headings [09/25/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
HD ;
 W @VEE("IOF"),!?65,"David Bolduc"
 W !!!!?34,"V E D D",!?34,"~~~~~~~",!?35,"~~~~~",!?36,"~~~",!?37,"~"
 W !!!?25,"VElectronic Data Dictionary"
 W !!!?22,"*",?25,"Everything you ever wanted",?53,"*",!?22,"*",?25,"to know about a file but",?53,"*",!?22,"*",?25,"were afraid to ask.",?53,"*"
 W !!
 Q
HD1 ;Heading for Top of Main Menu
 W @VEE("IOF"),!?2,"A.) FILE NAME:------------- ",ZNAM
 W !?48,"F.) FILE ACCESS:"
 W !?2,"B.) FILE NUMBER:----------- ",ZNUM
 W ?53,"DD______ ",$S($D(^DIC(ZNUM,0,"DD")):^("DD"),1:"")
 W !?53,"Read____ ",$S($D(^DIC(ZNUM,0,"RD")):^("RD"),1:"")
 W !?2,"C.) NUM OF FLDS:----------- ",^TMP("VEE","VEDD",$J,"TOT")
 W ?53,"Write___ ",$S($D(^DIC(ZNUM,0,"WR")):^("WR"),1:"")
 W !?53,"Delete__ ",$S($D(^DIC(ZNUM,0,"DEL")):^("DEL"),1:"")
 W !?2,"D.) DATA GLOBAL:----------- ",ZGL
 W ?53,"Laygo___ ",$S($D(^DIC(ZNUM,0,"LAYGO")):^("LAYGO"),1:"")
 W !!?2,"E.) TOTAL GLOBAL ENTRIES:-- "
 S ZZGL=ZGL_"0)",ZZGL=@ZZGL W $S($P(ZZGL,U,4)]"":$P(ZZGL,U,4),1:"Blank")
 I PRINTING="YES" W ?48,"G.) PRINTING STATUS:-- ",$S(FLAGP:"On",1:"Off")
 W !,$E(VEELINE1,1,VEE("IOM"))
 Q
MENU ;Main Menu
 S (FLAGE,FLAGG,FLAGM,FLAGQ,FLAGP1)=0
 I $G(FLAGPRM)="VEDD",$G(%2)]"" G MENU1
 D HD1
MENU1 ;Parameter passing
 D ^%ZVEMDM G:FLAGP1 MENU I FLAGP S:$E(VEEIOST,1,2)="P-" FLAGQ=1 D PRINT^%ZVEMDPR ;Turn off printing
 I $G(FLAGPRM)="VEDD",$G(%2)]"" S FLAGE=1 Q
 Q:FLAGM!FLAGE  G:FLAGQ MENU
 I $Y'>VEESIZE F I=$Y:1:VEESIZE W !
 W !!?2 S Z1=$$CHOICE^%ZVEMKC("MAIN_MENU^EXIT",1) I Z1'=1 S FLAGE=1 Q
 G MENU
