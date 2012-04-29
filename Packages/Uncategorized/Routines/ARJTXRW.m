ARJTXRW ;WV/TOAD - Routine Writing Tools ;12/23/2005  18:36
 ;;4.0T1;WORLDVISTA EHR+;;JAN 9, 2006;
 ; finally portable
 ;
 ; Change History:
 ;
 ; 2004 05 24  WV/TOAD - modify RSUM to handle GT.M version of %RSEL
 ; 2005 12 23  WV/TOAD - modify RSUM to use ^%ZOSF("RSEL") instead
 ;
SUMMARIZ(ROUTINE) ; summarize a routine
 ; ROUTINE = name of the routine
 ;
 N STATS
 D ANALYZE^ARJTXRD(ROUTINE,.STATS)
 N TOAD S TOAD=$P($P($G(STATS(1,0)),";",2),"-")["WV/TOAD"
 ;
 N NODE0 S NODE0=$G(STATS(0))
 W !,$P(NODE0,U)
 W ?9,$J($P(NODE0,U,3),4)
 W ?14,$J($P(NODE0,U,4),5)
 W ?20,$J($P(NODE0,U,5),10)
 W ?31
 N DESC S DESC=$P($P($G(STATS(1,0)),";",2),"-",2)
 F  Q:DESC=""  Q:$E(DESC)'=" "  S $E(DESC)=""
 W $E(DESC,1,47)
 N LOCAL S LOCAL=$$UP^XLFSTR($P($G(STATS(2,0)),";",7))
 S LOCAL=$S(LOCAL'["LOCAL":"",LOCAL["RTN":"Y",LOCAL["ROUTINE":"Y",1:"*")
 W ?79,LOCAL
 ; QUIT  ; for now. eventually, add a flag param here & a prompt in RSUM
 ;
 N SECTION
 N ALINE S ALINE=$NA(STATS("ALINE"))
 N SUBS S SUBS=$QL(ALINE)
 N NODE S NODE=ALINE
 F  S NODE=$Q(@NODE) Q:NODE=""  Q:$NA(@NODE,SUBS)'=ALINE  D
 . S SECTION=$QS(NODE,SUBS+3)
 . W !?10,SECTION
 . W ?20,$J($O(STATS("ASIZE",SECTION,0)),3)," lines"
 . W "  ",$$TRIM^XLFSTR($E($P(STATS($QS(NODE,2),0),";",2),1,49))
 ;
 QUIT
 ;
RSUM ; select a set of routines & summarize them
 ;
 W !!,"Routine Summary",!
 ;
 N ROUTINES D  Q:$O(ROUTINES(""))=""
 . N %UTILITY,%ZR K ^UTILITY($J)
 . X ^%ZOSF("RSEL") ; Kernel routine selection tool
 . K ^UTILITY($J,0)
 . M ROUTINES=^UTILITY($J)
 . K ^UTILITY($J)
 ;
 W !,"Name",?8,"Lines",?14,"Bytes",?22,"Checksum"
 W ?31,"Description",?74,"Local?"
 W !,"--------",?8,"-----",?14,"-----",?20,"----------",?31
 W "-------------------------------------------------"
 N R S R="" F  S R=$O(ROUTINES(R)) Q:R=""  D SUMMARIZ(R)
 Q
 ;
