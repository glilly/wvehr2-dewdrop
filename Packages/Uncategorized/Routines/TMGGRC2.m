TMGGRC2        ;TMG/kst-Work with Growth Chart Data ;10/5/10 ; 5/31/11 4:29pm
               ;;1.0;TMG-LIB;**1**;10/5/10;Build 27
               ;
               ;"Code for working with pediatric growth chart data.
               ;"This helps generate javascript code to pass back to WebBrowser
               ;
               ;"Kevin Toppenberg MD and Eddie Hagood
               ;"(C) 10/5/10
               ;"Released under: GNU General Public License (GPL)
               ;
               ;"=======================================================================
               ;" RPC -- Public Functions.
               ;"=======================================================================
               ;"TMGGRAPH(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Height %tile (child)
               ;"TMGGCLNI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Length %tile (infant)
               ;"TMGGCHTC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)-- Height %tile (child)
               ;"TMGGCHDC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Head circ %tile
               ;"TMGGCWTI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Wt %tile (infant)
               ;"TMGGCWTC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Wt %tile (child)
               ;"TMGGCBMI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --BMI percentile (infant) <-- not used (no LMS data avail from CDC)
               ;"TMGGCBMC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --BMI %tile (child)
               ;"TMGGCWHL(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Wt %tile for Length (infant)
               ;"TMGGCWHS(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --Wt %tile for Stature (child)
               ;"<============= WHO GRAPH ENTRY POINTS =================>
               ;"TMGWHOBA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO BMI for Age.
               ;"TMGWBAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO BMI Birth To 2 Years
               ;"TMGWBAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO BMI Birth To 5 Years
               ;"TMGWBA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO BMI 2 To 5 Years
               ;"
               ;"TMGWHOHA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Height for Age.
               ;"TMGWHAB6(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Height Birth to 6 Months.
               ;"TMGWHAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Height Birth to 2 Years.
               ;"TMGWHA62(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Height 6 Months to 2 Years.
               ;"TMGWHA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Height 2 Years to 5 Years.
               ;"TMGWHAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Height Birth to 5 Years.
               ;"
               ;"TMGWHOWA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight for Age.
               ;"TMGWWAB6(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight Birth to 6 Months.
               ;"TMGWWAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight Birth to 2 Years.
               ;"TMGWWA62(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight 6 Months to 2 Years.
               ;"TMGWWAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight Birth to 5 Years.
               ;"TMGWWA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight 2 Years to 5 Years.
               ;"
               ;"TMGWHOHC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Head Circumference for Age.
               ;"TMGWHCBT(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Head Circumference Birth to Thirteen.
               ;"TMGWHCB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Head Circumference Birth to 2 Years.
               ;"TMGWHCB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Head Circumference Birth to 5 Years.
               ;"
               ;"TMGWHOWL(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight for Length.
               ;"TMGWHOWS(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE) --WHO Weight from Stature.
               ;"ADDRPT(RESULT) -- install (add) the TMG GROWTH CHART MENU to ORWRP REPORT LIST.
               ;
               ;"=======================================================================
               ;"PRIVATE API FUNCTIONS
               ;"=======================================================================
               ;"TMGCOMGR(ROOT,GRAPHTYP) --Common graphic entry point
               ;"SETITEM(ROOT,X) -- set output into ROOT
               ;"ADDSECT(LABEL,ROOT) -- send out section of code, from LABEL until EOF found
               ;"GETPAT(DFN,AGE,GENDER,DOB,TMGERR)  -- ensure Patient variables are setup.
               ;"SETGRAPH(ROOT,AGEYR,GENDER,GRAPHTYP,TMGERR) --Setup labels, range etc for graph.
               ;"SETLINES(ROOT,DFN,DOB,AGEYR,GENDER,GRAPHTYP,TMGERR) -- send out data for REFERENCE lines.
               ;"SETRLINE(ROOT,AGEYR,GENDER,GRAPHTYP,TMGERR) -- send out data for REFERENCE lines.
               ;"SETPLINE(ROOT,DFN,DOB,AGEYR,GENDER,GRAPHTYP,TMGERR) -- send out data for PATIENT data line.
               ;"GETDATA(DFN,VITIEN,DOB,STARTDT,ENDDT,GRAPHTYP,ARRAY) --populate ARRAY with desired vitals data for date range
               ;"CVTMETRIC(VITIEN,DATA) -- convert English measurements to metric
               ;"GETDATES(DOB,MONMIN,MAXMON,STARTDT,ENDDT) --Convert DOB + age range into absolute starting and ending date
               ;
               ;"=======================================================================
               ;
TMGGRAPH(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"Input: ROOT -- Pass by NAME.  This is where output goes
               ;"       DFN -- Patient DFN ; ICN for foriegn sites
               ;"       ID --
               ;"       ALPHA -- Start date (lieu of DTRANGE)
               ;"       OMEGA -- End date (lieu of DTRANGE)
               ;"       DTRANGE -- # days back from today
               ;"       REMOTE --
               ;"       MAX    --
               ;"       ORFHIE --
               DO TMGCOMGR(.ROOT,"CH-HT")
               QUIT
               ;
TMGGCLNI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Length percentile for age (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               ;
               ;--TEMP!!!!
               ;"NEW TMGERR,AGE,GENDER,TMGERR,DOB
               ;"DO ADDSECT("TOP",.ROOT)
               ;"DO ADDSECT("GLIB2",.ROOT)
               ;"DO ADDSECT("XSCRIPT",.ROOT)
               ;"DO ADDSECT("ENDING",.ROOT)
               ;"QUIT
               ;
               DO TMGCOMGR(.ROOT,"INF-LN")
               QUIT
               ;
TMGGCWTI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for age (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"INF-WT")
               QUIT
               ;
TMGGCHDC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Head Circumference percentile for age
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"INF-HC")
               QUIT
               ;
TMGGCBMI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For BMI percentile for age (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"INF-BMI")
               QUIT
               ;
TMGGCWHL(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for Length (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"INF-WT4L")
               QUIT
               ;
TMGGCHTC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Height percentile for age (child)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"CH-HT")
               QUIT
               ;
TMGGCWTC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for age (child)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"CH-WT")
               QUIT
               ;
TMGGCBMC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For BMI percentile for age (child)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"CH-BMI")
               QUIT
               ;
TMGGCWHS(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for stature (child)
               ;"Input: (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"CH-WT4S")
               QUIT
               ;
               ;"WHO - BMI ENTRY POINTS
TMGWHOBA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-BA")
               QUIT
               ;
TMGWBAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-BA-B2")
               QUIT
               ;
TMGWBAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-BA-B5")
               QUIT
               ;
TMGWBA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-BA-25")
               QUIT
               ;
               ;"WHO - Height for Age Entry Points
TMGWHOHA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HA")
               QUIT
               ;
TMGWHAB6(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HA-B6")
               QUIT
               ;
TMGWHAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HA-B2")
               QUIT
               ;
TMGWHA62(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HA-62")
               QUIT
               ;
TMGWHA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HA-25")
               QUIT
               ;
TMGWHAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HA-B5")
               QUIT
               ;
               ;"WHO - Weight for age Entry Points
TMGWHOWA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WA")
               QUIT
               ;
TMGWWAB6(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WA-B6")
               QUIT
               ;
TMGWWAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WA-B2")
               QUIT
               ;
TMGWWA62(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WA-62")
               QUIT
               ;
TMGWWAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WA-B5")
               QUIT
               ;
TMGWWA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WA-25")
               QUIT
               ;
               ;"WHO - Head Circumference Entry Points
TMGWHOHC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HC")
               QUIT
               ;
TMGWHCBT(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HC-BT")
               QUIT
               ;
TMGWHCB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HC-B2")
               QUIT
               ;
TMGWHCB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-HC-B5")
               QUIT
               ;
TMGWHOWL(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight for Length
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WL")
               QUIT
               ;
TMGWHOWS(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight for Stature
               ;"Input (Same as TMGGRAPH, see above)
               DO TMGCOMGR(.ROOT,"WHO-WS")
               QUIT
               ;
TMGCOMGR(ROOT,GRAPHTYP)        ;
              ;"Purpose: Entry point, as called from CPRS REPORT system
              ;"Input: ROOT -- Pass by NAME.  This is where output goes
              ;"       GRAPHTYP -- Graph Type.  Legend:
              ;"              CH-HT  (1) -- Height percentile for age (child)
              ;"              INF-HC  (2) -- Head Circumference percentile for age
              ;"              CH-WT  (3) -- Weight percentile for age (child)
              ;"              CH-BMI (4) -- BMI percentile for age (child)
              ;"              INF-WT4L (5) -- Weight percentile for Length (infant)
              ;"              CH-WT4S (5.5)- Weight percentile for Stature (child)
              ;"              INF-BMI (6) -- BMI percentile for age (infant)
              ;"              INF-WT  (7) -- Weight percentile for age (infant)
              ;"              INF-LN  (8) -- Length percentile for age (infant)
               ;"         WHO-BA  (9) -- WHO BMI by Age
               ;"         WHO-HA  (10) -- WHO Height by Age
               ;"         WHO-WA        (11) -- WHO Weight by Age
               ;"         WHO-HC        (12) -- WHO Head Circumference by Age
               ;"         WHO-WL        (13) -- WHO Weight for Length
               ;"         WHO-WS        (14) -- WHO Weight for Stature
              ;"Results: None
              ;"Output: @ROOT is filled
              ;
              NEW TMGERR,AGE,GENDER,TMGERR,DOB
              DO GETPAT(.DFN,.AGE,.GENDER,.DOB,.TMGERR)
              DO CHECKTYP(.GRAPHTYP,.TMGERR) GOTO:($D(TMGERR)) TGERR
              DO ADDSECT("TOP",.ROOT)
              DO ADDSECT("GLIB",.ROOT)
              DO ADDSECT("SCRIPT",.ROOT)
              DO SETGRAPH(ROOT,AGE,GENDER,GRAPHTYP,.TMGERR) GOTO:($D(TMGERR)) TGERR
              DO SETLINES(ROOT,DFN,DOB,AGE,GENDER,GRAPHTYP,.TMGERR) GOTO:($D(TMGERR)) TGERR
              GOTO TGDN
TGERR    DO SETITEM(ROOT,.TMGERR)
TGDN      DO ADDSECT("ENDING",.ROOT)
              QUIT
              ;
CHECKTYP(GRAPHTYP,TMGERR)              ;
               SET GRAPHTYP=$GET(GRAPHTYP)
               IF ("INF;CH;WHO"'[$P(GRAPHTYP,"-",1))!("HT;HC;WT;BMI;WT4L;WT4S;LN;BA;HA;WA;WL;WS"'[$P(GRAPHTYP,";",2)) DO
               . SET TMGERR="<bold>Error</bold>: Invalid chart type request: '"_GRAPHTYP_"'"
               QUIT
               ;
SETITEM(ROOT,X)        ; -- set item in list
               SET @ROOT@($ORDER(@ROOT@(9999),-1)+1)=X
               QUIT
               ;
ADDSECT(LABEL,ROOT)            ;
               ;"Purpose: To send out section of code, from LABEL until EOF found
               ;"Input: LABEL -- e.g. "L1", "L2" etc.  Must match labels in TMGGRC3
               NEW I,LINE
               NEW DONE SET DONE=0
               FOR I=1:1 QUIT:DONE  DO
               . SET LINE=$TEXT(@LABEL+I^TMGGRC3)
               . IF LINE="" SET DONE=1 QUIT
               . SET LINE=$PIECE(LINE,";;",2,99)
               . IF $$TRIM^XLFSTR(LINE)="EOF" SET DONE=1 QUIT
               . DO SETITEM(.ROOT,LINE)
               QUIT
               ;
GETPAT(DFN,AGE,GENDER,DOB,TMGERR)               ;
               ;"Purpose: To ensure Patient variables are setup.
               ;"Input: DFN -- The patient to get info from
               ;"       AGE -- PASS BY REFERENCE, AN OUT PARAMETER
               ;"       GENDER -- PASS BY REFERENCE, AN OUT PARAMETER
               ;"       DOB -- PASS BY REFERENCE, AN OUT PARAMETER
               ;"       TMGERR -- PASS BY REFERENCE, AN OUT PARAMETER
               ;"Result: None
               IF +$GET(DFN)'>0 DO  QUIT
               . SET TMGERR="<bold>Error</bold>: Patient ID 'DFN' not defined.  Contact administrator."
               SET AGE=+$$GET1^DIQ(2,DFN_",",.033) ;"returns calculated field, INTEGER yrs
               SET DOB=$PIECE($GET(^DPT(DFN,0)),"^",3)
               IF AGE<18 DO
               . NEW %,X,X1,X2,%Y
               . DO NOW^%DTC
               . SET X1=X ;"now
               . SET X2=DOB
               . DO ^%DTC  ;"result out in X (days delta)
               . IF %Y=0 QUIT  ;"dates are unworkable
               . SET AGE=+$JUSTIFY(X/365,0,4)
               SET GENDER=$PIECE($GET(^DPT(DFN,0)),"^",2)
               IF GENDER="" DO  QUIT
               . SET TMGERR="<bold>Error</bold>: Patient SEX not defined."
               QUIT
               ;
SETGRAPH(ROOT,AGEYR,GENDER,GRAPHTYP,TMGERR)            ;
               ;"Purpose: Setup labels, range etc for graph.  This will customize
               ;"         The graph based on patients age--which will determine which
               ;"         which graph should be displayed.
               ;"Input: ROOT -- Pass by NAME.  This is where output goes
               ;"       AGEYR -- Patient age in *YEARS*
               ;"       GENDER -- Patient SEX -- Should be 'M' OR 'F'
               ;"       GRAPHTYP -- Graph Type, See above for documentation
               ;"       TMGERR -- PASS BY REFERENCE.  An OUT Parameter.
               ;"Results: None
               ;"Output: @ROOT is filled
               NEW TITLE,XMIN,XMAX,XTITLE,YMIN,YMAX,YTITLE,XINC,YINC
               SET XINC=1,YINC=5
               SET GRAPHTYP=$GET(GRAPHTYP)
               ;
               SET TITLE="PHYSICAL GROWTH PERCENTILES"
               IF GRAPHTYP["INF-" DO
               . SET XMIN=0,XMAX=36
               . SET XTITLE="AGE (MONTHS)"
               ELSE  DO
               . SET XMIN=1,XMAX=22
               . SET XTITLE="AGE (YEARS)"
               ;
               IF GRAPHTYP="INF-LN" DO
               . SET TITLE="LENGTH  "_TITLE
               . SET YTITLE="LENGTH (cm)"
               . SET YMIN=40,YMAX=110
               ELSE  IF GRAPHTYP="INF-WT" DO
               . SET TITLE="WEIGHT  "_TITLE
               . SET YTITLE="WEIGHT (kg)"
               . SET YMIN=2,YMAX=18
               . SET XMIN=0,XMAX=40
               ELSE  IF GRAPHTYP="INF-HC" DO
               . SET TITLE="HEAD CIRCUMFERENCE  "_TITLE
               . SET YMIN=30,YMAX=55
               . SET YTITLE="HEAD CIRC (cm)"
               . SET XMIN=0,XMAX=40
               ELSE  IF GRAPHTYP="INF-BMI" DO
               . SET TITLE="BODY MASS INDEX  "_TITLE
               . SET YTITLE="BMI (kg/m^2)"
               . SET YMIN=1,YMAX=20
               ELSE  IF GRAPHTYP="INF-WT4L" DO
               . SET TITLE="WEIGHT FOR LENGTH  "_TITLE
               . SET YTITLE="WEIGHT (kg)"
               . SET YMIN=10,YMAX=19
               . SET XTITLE="LENGTH (cm)"
               . SET XMIN=80,XMAX=100
               . SET XINC=1,YINC=1
               ELSE  IF GRAPHTYP="CH-HT" DO
               . SET TITLE="STATURE  "_TITLE
               . SET YTITLE="STATURE (cm)"
               . SET YMIN=70,YMAX=200
               ELSE  IF GRAPHTYP="CH-WT" DO
               . SET TITLE="WEIGHT  "_TITLE
               . SET YTITLE="WEIGHT (kg)"
               . SET YMIN=10,YMAX=100
               ELSE  IF GRAPHTYP="CH-BMI" DO
               . SET TITLE="BODY MASS INDEX  "_TITLE
               . SET YTITLE="BMI (kg/m^2)"
               . SET YMIN=13,YMAX=35
               ELSE  IF GRAPHTYP="CH-WT4S" DO
               . SET TITLE="WEIGHT FOR STATURE  "_TITLE
               . SET YTITLE="WEIGHT (kg)"
               . SET YMIN=0,YMAX=20
               . SET XTITLE="STATURE (cm)"
               . SET XMIN=60,XMAX=150
               ELSE  IF GRAPHTYP["WHO-BA" DO
               . IF $PIECE(GRAPHTYP,"-",3)="B2" DO
               . . SET TITLE="BMI-for-Age (Birth to 2 Years)"
               . . SET YMIN=1,YMAX=21
               . . SET XMIN=0,XMAX=25
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B5" DO
               . . SET TITLE="BMI-for-Age (Birth to 5 Years)"
               . . SET YMIN=10,YMAX=21
               . . SET XMIN=0,XMAX=61
               . . SET XINC=2,YINC=1
               . ELSE  DO
               . . SET TITLE="BMI-for-Age (2 Years to 5 Years)"
               . . SET YMIN=12,YMAX=20
               . . SET XMIN=23,XMAX=61
               . . SET XINC=2,YINC=1
               . SET YTITLE="BMI (kg/m^2)"
               . SET XTITLE="AGE (MONTHS)"
               ELSE  IF GRAPHTYP["WHO-HA" DO
               . IF $PIECE(GRAPHTYP,"-",3)="B6" DO
               . . SET TITLE="Length-for-Age (Birth to 6 Months)"
               . . SET YMIN=45,YMAX=76
               . . SET XMIN=0,XMAX=6
               . . SET XINC=1,YINC=5
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B2" DO
               . . SET TITLE="Length-for-Age (Birth to 2 Years)"
               . . SET YMIN=45,YMAX=95
               . . SET XMIN=0,XMAX=25
               . . SET XINC=1,YINC=5
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="62" DO
               . . SET TITLE="Length-for-Age (6 Months to 2 Years)"
               . . SET YMIN=60,YMAX=95
               . . SET XMIN=6,XMAX=25
               . SET XINC=1,YINC=5
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="25" DO
               . . SET TITLE="Length-for-Age (2 Years to 5 Years)"
               . . SET YMIN=75,YMAX=120
               . . SET XMIN=23,XMAX=61
               . . SET XINC=2,YINC=5
               . ELSE  DO
               . . SET TITLE="Length-for-Age (Birth to 5 Years)"
               . . SET YMIN=40,YMAX=125
               . . SET XMIN=0,XMAX=61
               . . SET XINC=2,YINC=5
               . SET YTITLE="LENGTH (cm)"
               . SET XTITLE="AGE (MONTHS)"
               ELSE  IF GRAPHTYP["WHO-WA" DO
               . IF $PIECE(GRAPHTYP,"-",3)="B6" DO
               . . SET TITLE="Weight-for-Age (Birth to 6 Months)"
               . . SET YMIN=0,YMAX=10
               . . SET XMIN=0,XMAX=6
               . . SET XINC=1,YINC=1
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B2" DO
               . . SET TITLE="Weight-for-Age (Birth to 2 Years)"
               . . SET YMIN=0,YMAX=16
               . . SET XMIN=0,XMAX=25
               . . SET XINC=1,YINC=1
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="62" DO
               . . SET TITLE="Weight-for-Age (6 Months to 2 Years)"
               . . SET YMIN=5,YMAX=16
               . . SET XMIN=6,XMAX=25
               . . SET XINC=1,YINC=1
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="25" DO
               . . SET TITLE="Weight-for-Age (2 Years to 5 Years)"
               . . SET YMIN=8,YMAX=26
               . . SET XMIN=23,XMAX=61
               . . SET XINC=2,YINC=1
               . ELSE  DO
               . . SET TITLE="Weight-for-Age (Birth to 5 Years)"
               . . SET YMIN=0,YMAX=25
               . . SET XMIN=0,XMAX=61
               . . SET XINC=2,YINC=2
               . SET YTITLE="WEIGHT (kg)"
               . SET XTITLE="AGE (MONTHS)"
               ELSE  IF GRAPHTYP["WHO-HC" DO
               . IF $PIECE(GRAPHTYP,"-",3)="BT" DO
               . . SET TITLE="Head circumference-for-Age (Birth to 13 Weeks)"
               . . SET YMIN=31,YMAX=43
               . . SET XMIN=0,XMAX=3.25
               . . SET XINC=.25,YINC=1
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B2" DO
               . . SET TITLE="Head circumference-for-Age (Birth to 2 Years)"
               . . SET YMIN=31,YMAX=51
               . . SET XMIN=0,XMAX=25
               . . SET XINC=2,YINC=1
               . ELSE  DO
               . . SET TITLE="Head circumference-for-Age (Birth to 5 Years)"
               . . SET YMIN=31,YMAX=53
               . . SET XMIN=0,XMAX=61
               . . SET XINC=2,YINC=2
               . SET YTITLE="HEAD CIRC (cm)"
               . SET XTITLE="AGE (MONTHS)"
               ELSE  IF GRAPHTYP["WHO-WL" DO
               . SET TITLE="Weight-for-height "
               . SET YTITLE="WEIGHT (kg)"
               . SET YMIN=5,YMAX=29
               . SET XTITLE="LENGTH (cm)"
               . SET XMIN=65,XMAX=130
               . SET XINC=5,YINC=2
               ELSE  IF GRAPHTYP["WHO-WS" DO
               . SET TITLE="WHO - WEIGHT FOR STATURE  "_TITLE
               . SET YTITLE="WEIGHT (kg)"
               . SET YMIN=0,YMAX=20
               . SET XTITLE="STATURE (cm)"
               . SET XMIN=60,XMAX=150
               . SET XMIN=0,XMAX=60
               . SET XTITLE="AGE (MONTHS)"
               ;
               NEW GENDERTITLE
               IF GENDER="F" SET GENDERTITLE="GIRLS "
               ELSE  SET GENDERTITLE="BOYS "
               IF $PIECE(GRAPHTYP,"-",1)="WHO" SET TITLE=TITLE_" -- "_GENDERTITLE_" -- WHO DATA"
               ELSE  SET TITLE=GENDERTITLE_TITLE
               ;
               NEW SOURCE,ACCESSDT
               IF GRAPHTYP["WHO" DO
               . SET SOURCE="http://www.who.int/childgrowth/standards/en/"
               . SET ACCESSDT="2/1/2011"
               ELSE  DO
               . SET SOURCE="http://www.cdc.gov/growthcharts/percentile_data_files.htm"
               . SET ACCESSDT="10/21/2010"
               DO SETGRAPH^TMGGRC3(.ROOT,TITLE,XMIN,XMAX,XTITLE,YMIN,YMAX,YTITLE,XINC,YINC,SOURCE,ACCESSDT,GRAPHTYP) ;
                  ;
                  ; JS to draw separation line below; not drawn here. Actual call in SetupGraph produced in TMGGRC3.
               IF GRAPHTYP="WHO-HA-B5" DO ADDWHOL1^TMGGRC3(.ROOT)  ; JS to Draw line to separate height/length (doesn't actually draw line)
                  IF GRAPHTYP="WHO-BA-B5" DO ADDWHOL2^TMGGRC3(.ROOT)  ; JS to Draw line to separate height/length (doesn't actually draw line)
               QUIT
               ;
SETLINES(ROOT,DFN,DOB,AGEYR,GENDER,GRAPHTYP,TMGERR)            ;
               ;"Purpose: to send out data for REFERENCE lines.
               ;"Input: ROOT -- Pass by NAME.  This is where output goes
               ;"       DFN -- Patient DFN
               ;"       DOB -- Patient DOB
               ;"       AGEYR -- Patient age in *YEARS*
               ;"       GENDER -- Patient SEX -- Should be 'M' OR 'F'
               ;"       GRAPHTYP -- Graph Type, See above for documentation
               ;"      TMGERR -- PASS BY REFERENCE.  An OUT Parameter.
               ;"Results: None
               ;"Output: @ROOT is filled
               DO STRTLINE^TMGGRC3(.ROOT)    ;
               DO SETRLINE(ROOT,AGE,GENDER,GRAPHTYP,.TMGERR)  QUIT:($D(TMGERR))
               DO SETPLINE(ROOT,DFN,DOB,AGE,GENDER,GRAPHTYP,.TMGERR)  QUIT:($D(TMGERR))
               DO ENDLINES^TMGGRC3(ROOT)    ;
               QUIT
               ;
SETRLINE(ROOT,AGEYR,GENDER,GRAPHTYP,TMGERR)            ;
               ;"Purpose: to send out data for REFERENCE lines.
               ;"Input: ROOT -- Pass by NAME.  This is where output goes
               ;"       AGEYR -- Patient age in *YEARS*
               ;"       GENDER -- Patient SEX -- Should be 'M' OR 'F'
               ;"       GRAPHTYP -- Graph Type, See above for documentation
               ;"      TMGERR -- PASS BY REFERENCE.  An OUT Parameter.
               ;"Results: None
               ;"Output: @ROOT is filled
               NEW ARRAY
               SET GRAPHTYP=$GET(GRAPHTYP)
               ;"Get normal curves values -- ARRAY(%tile,Age)=x^y
               IF GRAPHTYP["INF-" DO
               . IF GRAPHTYP="INF-LN" DO LENREF^TMGGRC1(1,GENDER,.ARRAY) QUIT
               . IF GRAPHTYP="INF-WT" DO WTREF^TMGGRC1(1,GENDER,.ARRAY) QUIT
               . IF GRAPHTYP="INF-HC" DO HCREF^TMGGRC1(1,GENDER,.ARRAY) QUIT
               . IF GRAPHTYP="INF-BMI" DO BMIREF^TMGGRC1(1,GENDER,.ARRAY,"5,10,25,50,60,75,80,85,90,95") QUIT
               . IF GRAPHTYP="INF-WT4L" DO WTLENREF^TMGGRC1(1,GENDER,.ARRAY,"5,10,25,50,75,80,90,95") QUIT
               ELSE  IF GRAPHTYP["WHO" DO
               . NEW MODE
               . IF $PIECE(GRAPHTYP,"-",3)="BT" SET MODE=8
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="62" SET MODE=7
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B2" SET MODE=4
               . ELSE  IF ($PIECE(GRAPHTYP,"-",3)="25")!(GRAPHTYP="WHO-WL") SET MODE=5
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B6" SET MODE=6
               . ELSE  SET MODE=3
               . IF GRAPHTYP["WHO-BA" DO WHOBMIREF^TMGGRC1(MODE,GENDER,.ARRAY,"3,15,50,85,97") QUIT
               . IF GRAPHTYP["WHO-HA" DO WHOHAREF^TMGGRC1(MODE,GENDER,.ARRAY,"3,15,50,85,97") QUIT
               . IF GRAPHTYP["WHO-WA" DO WHOWAREF^TMGGRC1(MODE,GENDER,.ARRAY,"3,15,50,85,97") QUIT
               . IF GRAPHTYP["WHO-HC" DO WHOHCREF^TMGGRC1(MODE,GENDER,.ARRAY,"3,15,50,85,97") QUIT
               . IF GRAPHTYP["WHO-WL" DO WHOWLREF^TMGGRC1(MODE,GENDER,.ARRAY,"3,15,50,85,97") QUIT
               . IF GRAPHTYP["WHO-WS" DO WHOWSREF^TMGGRC1(MODE,GENDER,.ARRAY,"3,15,50,85,97") QUIT
               ELSE  DO
               . IF GRAPHTYP="CH-HT" DO LENREF^TMGGRC1(2,GENDER,.ARRAY) QUIT
               . IF GRAPHTYP="CH-WT" DO WTREF^TMGGRC1(2,GENDER,.ARRAY,"5,10,25,50,60,75,80,85,90,95") QUIT
               . IF GRAPHTYP="CH-BMI" DO BMIREF^TMGGRC1(2,GENDER,.ARRAY,"5,10,25,50,60,75,80,85,90,95") QUIT
               . IF GRAPHTYP="CH-WT4S" DO WTLENREF^TMGGRC1(2,GENDER,.ARRAY) QUIT
               . IF GRAPHTYP="CH-WT4S" DO WTLENREF^TMGGRC1(2,GENDER,.ARRAY) QUIT
               ;
               NEW PCTL SET PCTL=0
               NEW LABLX SET LABLX=""
               ;"Loop through each normal line (e.g. 5th %tile, then 10th%tile etc...
               FOR  SET PCTL=$ORDER(ARRAY(PCTL)) QUIT:(PCTL="")  DO
               . NEW LINE
               . IF LABLX="" DO
               . . NEW J FOR J=1:1:2 SET LABLX=$ORDER(ARRAY(PCTL,LABLX),-1)
               . NEW X SET X=""  ;"X Usually stores months, except in Weight For Length/Stature graphs
               . FOR  SET X=$ORDER(ARRAY(PCTL,X)) QUIT:(X="")  DO
               . . NEW VAL SET VAL=ARRAY(PCTL,X)
               . . IF X=LABLX SET VAL=VAL_"^"_$$SETSUFFIX^TMGGRC1(PCTL)
               . . NEW XVAL SET XVAL=X
               . . IF GRAPHTYP["CH-" DO
               . . . SET XVAL=+$JUSTIFY(X/12,0,1)
               . . . SET $PIECE(VAL,"^",1)=XVAL
               . . SET LINE(XVAL)=VAL
               . ;"Add one reference/normal line
               . DO ADDLINE^TMGGRC3(.ROOT,.LINE,1)  ;" Add Data Set for a reference Line
               QUIT
               ;
SETPLINE(ROOT,DFN,DOB,AGEYR,GENDER,GRAPHTYP,TMGERR)            ;
               ;"Purpose: to send out data for PATIENT data line.
               ;"Input: ROOT -- Pass by NAME.  This is where output goes
               ;"       DFN -- Patient DFN
               ;"       DOB -- Patient DOB
               ;"       AGEYR -- Patient age in *YEARS*
               ;"       GENDER -- Patient SEX -- Should be 'M' OR 'F'
               ;"       GRAPHTYP -- Graph Type, See above for documentation
               ;"       TMGERR -- PASS BY REFERENCE.  An OUT Parameter.
               ;"Results: None
               ;"Output: @ROOT is filled
               ;
               NEW STARTDT,ENDDT,ARRAY,VITIEN,RESULT
               SET GRAPHTYP=$GET(GRAPHTYP)
               IF GRAPHTYP["INF-" DO
               . DO GETDATES(DOB,0,36,.STARTDT,.ENDDT) ;
               ELSE  IF GRAPHTYP["WHO" DO
               . IF $PIECE(GRAPHTYP,"-",3)="BT" DO GETDATES(DOB,0,3.25,.STARTDT,.ENDDT) ;
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="62" DO GETDATES(DOB,6,24,.STARTDT,.ENDDT) ;
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B2" DO GETDATES(DOB,0,24,.STARTDT,.ENDDT) ;
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="25" DO GETDATES(DOB,24,60,.STARTDT,.ENDDT) ;
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B6" DO GETDATES(DOB,0,7,.STARTDT,.ENDDT) ;
               . ELSE  IF $PIECE(GRAPHTYP,"-",3)="B5" DO GETDATES(DOB,0,60,.STARTDT,.ENDDT) ;
               . ELSE  IF GRAPHTYP["WHO-WL" DO GETDATES(DOB,24,60,.STARTDT,.ENDDT) ;
               ELSE  DO
               . DO GETDATES(DOB,24,240,.STARTDT,.ENDDT) ;
               ;
               IF (GRAPHTYP["-HT")!(GRAPHTYP["WHO-HA")!(GRAPHTYP["-LN") DO
               . SET VITIEN=+$ORDER(^GMRD(120.51,"B","HEIGHT",0))
               ELSE  IF (GRAPHTYP["-HC")!(GRAPHTYP["WHO-HC") DO
               . SET VITIEN=+$ORDER(^GMRD(120.51,"B","CIRCUMFERENCE/GIRTH",0))
               ELSE  IF (GRAPHTYP["-WT")!(GRAPHTYP["WHO-WA") DO
               . SET VITIEN=+$ORDER(^GMRD(120.51,"B","WEIGHT",0))
               ELSE  IF (GRAPHTYP["-BMI")!(GRAPHTYP["WHO-BA") DO
               . SET VITIEN="BMI"
               ELSE  SET VITIEN=0
               SET RESULT=$$GETDATA(DFN,VITIEN,DOB,STARTDT,ENDDT,GRAPHTYP,.ARRAY) ;
               ;"NEW MODE SET MODE=$SELECT(GRAPHTYP["-WT4":1,(1=1):2)
               DO ADDLINE^TMGGRC3(.ROOT,.ARRAY,0)  ;" Add PATIENT Data Set
               DO ADDTABLE^TMGGRC3(.ROOT,.ARRAY,GRAPHTYP)  ;" Add Table of Patient Data Set
               QUIT
               ;
GETDATA(DFN,VITIEN,DOB,STARTDT,ENDDT,GRAPHTYP,ARRAY)           ;
               ;"Purpose: To populate ARRAY with desired vitals data for date range
               ;"Input: DFN -- The IEN in PATIENT file for patient
               ;"       VITIEN -- The IEN in 120.51 specifying which vital type to return (e.g. HEIGHT, vs WEIGHT etc.
               ;"          There is no BMI vital type. If vital type is BMI then VITIEN will equal BMI.
               ;"       DOB -- Patient's DOB -- in FMDate format
               ;"       STARTDT -- Start of desired date range, in FMDate format
               ;"       ENDDT -- End of desired date range, in FMDate format
               ;"       GRAPHTYP -- Graph Type, See above for documentation
               ;"       ARRAY -- PASS BY REFERENCE, AN OUT PARAMETER.  See format below.
               ;"Result: RESULT: -1^MESSAGE  OR 1^MESSAGE
               ;"Output: ARRAY filled as follows.  Format:
               ;"           NOTE: AGE is in months if GRAPHTYP["INF-", otherwise it is in years
               ;"           ARRAY(Index#)=Age^ValueInMetric^^DateOfValue^^%tile
               ;"              or  ARRAY(Index#)=HeightOrStatureInCm^WeightInKg^^DateOfValue^Age^%tile  if GRAPHTYP["-WT4"
               ;"NOTE: Vitals are store in English format, and needs to be converted to metric
               ;"NOTE: If desired vital type is BMI, then it will have to be calculated here, I think...
               ;
               ;"Use index --> ^PXRMINDX(120.5,"PI",DFN,MEASUREMENT_IEN,DATE/TIME,IEN)
               ;" e.g. ^PXRMINDX(120.5,"PI",DFN,VITIEN,DATE/TIME,IENofStoredVitals
               NEW THISDT SET THISDT=0
               NEW IDX SET IDX=1
               KILL ARRAY
               NEW GENDER SET GENDER=$PIECE($GET(^DPT(DFN,0)),"^",2)
               SET RESULT="1^SUCCESSFUL"
               IF (VITIEN="BMI")!(GRAPHTYP["-WT4")!(GRAPHTYP["WHO-BA")!(GRAPHTYP["WHO-WL")!(GRAPHTYP["WHO-WS") DO
               . NEW HTTYPE,WTTYPE
               . SET HTTYPE=+$ORDER(^GMRD(120.51,"B","HEIGHT",0))
               . SET WTTYPE=+$ORDER(^GMRD(120.51,"B","WEIGHT",0))
               . FOR  SET THISDT=$ORDER(^PXRMINDX(120.5,"PI",DFN,WTTYPE,THISDT)) QUIT:(+THISDT'>0)!(+RESULT=-1)  DO
               . . NEW THISDTEX  DO
               . . . NEW Y SET Y=THISDT\1  ;"Trim off Time
               . . . X ^DD("DD")  ;"Y output as: e.g. "JUL 20,1969"
               . . . SET THISDTEX=Y
               . . NEW HTIEN,HTDATE,HEIGHT
               . . SET HTDATE=+$ORDER(^PXRMINDX(120.5,"PI",DFN,HTTYPE,THISDT\1)) QUIT:HTDATE'>0
               . . IF (HTDATE\1)'=(THISDT\1) QUIT
               . . SET HTIEN=+$ORDER(^PXRMINDX(120.5,"PI",DFN,HTTYPE,HTDATE,0))
               . . SET HEIGHT=$PIECE($GET(^GMR(120.5,HTIEN,0)),"^",8)  ;"English (not metric) units here
               . . IF HEIGHT'>0 DO  QUIT
               . . . SET RESULT="-1^NO HEIGHT RECORDED TO CALCULATE BMI"
               . . IF (THISDT'<STARTDT)&(THISDT'>ENDDT) DO
               . . . NEW RECIEN SET RECIEN=0
               . . . FOR  SET RECIEN=+$ORDER(^PXRMINDX(120.5,"PI",DFN,WTTYPE,THISDT,RECIEN)) QUIT:(+RECIEN'>0)  DO
               . . . . NEW X1,X2,METDATA
               . . . . SET X2=DOB
               . . . . SET X1=$PIECE($GET(^GMR(120.5,RECIEN,0)),"^",1)
               . . . . DO ^%DTC  ;"OUTPUT X=X1-X2, in days
               . . . . NEW AGE SET AGE=X  ;Days
               . . . . NEW AGEYR SET AGEYR=X/365    ;"+$JUSTIFY(X/365,0,1) ;"in years
               . . . . IF GRAPHTYP["CH-" SET AGE=AGEYR
               . . . . ELSE  SET AGE=X/30     ;"+$JUSTIFY(X/30,0,1) ;"in months
               . . . . NEW L SET L=+$ORDER(^PXRMINDX(120.5,"PI",DFN,WTTYPE,THISDT,0))
               . . . . NEW WEIGHT SET WEIGHT=$PIECE($GET(^GMR(120.5,L,0)),"^",8) ;"English units
               . . . . NEW PCTL SET PCTL=""
               . . . . IF (GRAPHTYP["-WT4")!(GRAPHTYP["WHO-WL")!(GRAPHTYP["WHO-WS") DO
               . . . . . SET METDATA=$$CVTMETRIC("W4LS",WEIGHT_"^"_HEIGHT)  ;"returns 'Ht^Wt'
               . . . . . SET PCTL=$$PCTILE(GRAPHTYP,AGEYR,GENDER,WEIGHT/2.2,HEIGHT*2.54)
               . . . . . SET ARRAY(IDX)=METDATA_"^^"_THISDTEX_"^"_AGE_"^"_PCTL     ;"HeightOrStatureInCm^WeightInKg^^DateOfValue^Age^%tile
               . . . . ELSE  DO  ;"BMI
               . . . . . SET METDATA=$$CVTMETRIC("BMI",WEIGHT_"^"_HEIGHT)
               . . . . . SET PCTL=$$PCTILE(GRAPHTYP,AGEYR,GENDER,METDATA)
               . . . . . SET ARRAY(IDX)=AGE_"^"_METDATA_"^^"_THISDTEX_"^^"_PCTL    ;"Age^ValueInMetric^^DateOfValue^^%tile
               . . . . SET IDX=IDX+1
               ELSE  DO
               . FOR  SET THISDT=$ORDER(^PXRMINDX(120.5,"PI",DFN,VITIEN,THISDT)) QUIT:(+THISDT'>0)  DO
               . . IF (THISDT'<STARTDT)&(THISDT'>ENDDT) DO
               . . . NEW THISDTEX  DO
               . . . . NEW Y SET Y=THISDT\1  ;"Trim off Time
               . . . . X ^DD("DD")  ;"Y output as: e.g. "JUL 20,1969"
               . . . . SET THISDTEX=Y
               . . . NEW RECIEN SET RECIEN=0
               . . . FOR  SET RECIEN=+$ORDER(^PXRMINDX(120.5,"PI",DFN,VITIEN,THISDT,RECIEN)) QUIT:(+RECIEN'>0)  DO
               . . . . NEW X1,X2,METDATA
               . . . . SET X2=DOB
               . . . . SET X1=$PIECE($GET(^GMR(120.5,RECIEN,0)),"^",1)
               . . . . DO ^%DTC
               . . . . NEW AGE SET AGE=X  ;Days
               . . . . NEW AGEYR SET AGEYR=X/365 ;"+$JUSTIFY(X/365,0,1) ;"in years
               . . . . IF GRAPHTYP["CH-" SET AGE=AGEYR
               . . . . ELSE  SET AGE=X/30 ;"+$JUSTIFY(X/30,0,1) ;"in months
               . . . . SET METDATA=$$CVTMETRIC(VITIEN,$PIECE($GET(^GMR(120.5,RECIEN,0)),"^",8))
               . . . . NEW PCTL SET PCTL=$$PCTILE(GRAPHTYP,AGEYR,GENDER,METDATA)
               . . . . SET ARRAY(IDX)=AGE_"^"_METDATA_"^^"_THISDTEX_"^^"_PCTL        ;"Age^ValueInMetric^^DateOfValue^^%tile
               . . . . SET IDX=IDX+1
               QUIT RESULT
               ;
PCTILE(GRAPHTYP,AGEYR,GENDER,VALUE,V2)  ;
               ;"Purpose: Return percentile of value for graph
               NEW RESULT SET RESULT=""
               IF GRAPHTYP["-LN" SET RESULT=$$LENPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["-WT4" SET RESULT=$$WTLENPCT^TMGGRC1(AGEYR,GENDER,VALUE,V2) GOTO PCTDN
               IF GRAPHTYP["-WT" SET RESULT=$$WTPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["-HC" SET RESULT=$$HCPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["-BMI" SET RESULT=$$BMIPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["-HT" SET RESULT=$$LENPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["WHO-BA" SET RESULT=$$WHOBAPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["WHO-HA" SET RESULT=$$WHOHAPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["WHO-WA" SET RESULT=$$WHOWAPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["WHO-HC" SET RESULT=$$WHOHCPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
               IF GRAPHTYP["WHO-WL" SET RESULT=$$WHOWLPCTL^TMGGRC1(AGEYR,GENDER,VALUE,V2) GOTO PCTDN
               IF GRAPHTYP["WHO-WS" SET RESULT=$$WHOWSPCTL^TMGGRC1(AGEYR,GENDER,VALUE) GOTO PCTDN
PCTDN            QUIT RESULT
               ;
               ;
CVTMETRIC(VITIEN,DATA)  ;
               ;"Purpose: To convert us measurements to metric
               ;"Input: VITIEN -- The IEN in 120.51 specifying which vital type to return (e.g. HEIGHT, vs WEIGHT etc.
               ;"          There is no BMI vital type. If vital type is BMI then VITIEN will equal BMI.
               ;"       DATA -- In US measurement.
               ;"        If VITIEN is BMI, then DATA is expected to equal WEIGHT(lbs)^HEIGHT(in)
               ;"Result: Data converted into metric measurement units
               ;"Output: None
               NEW VITTYPE,RESULT
               NEW HEIGHT,WEIGHT
               SET RESULT=DATA
               IF DATA=0  GOTO CMETQT
               IF +VITIEN=VITIEN DO
               . SET VITTYPE=$PIECE($GET(^GMRD(120.51,VITIEN,0)),"^",2)
               ELSE  DO
               . SET WEIGHT=$PIECE(DATA,"^",1)
               . SET HEIGHT=$PIECE(DATA,"^",2)
               . SET VITTYPE=VITIEN
               ;
               IF VITTYPE="HT" DO
               . SET RESULT=DATA*2.54   ;"in to cm
               . SET RESULT=$JUSTIFY(RESULT,0,0)  ;"round to nearest integer
               ELSE  IF VITTYPE="WT" DO
               . SET RESULT=DATA*0.45359237   ;"lbs to kg
                ; . SET RESULT=$JUSTIFY(RESULT,0,1)  ;"round to nearest tenth - smh
               ELSE  IF VITTYPE="CG" DO
               . SET RESULT=DATA*2.54   ;"in to cm
               . SET RESULT=$JUSTIFY(RESULT,0,1)  ;"round to nearest tenth
               ELSE  IF VITTYPE="BMI" DO
               . ;"NOTE:  BMI= weight(kg) / height(m) sq.
               . IF HEIGHT'>0 SET RESULT=0 QUIT
               . SET RESULT=(WEIGHT*0.4545)/((HEIGHT*0.0254)**2)
               . SET RESULT=$JUSTIFY(RESULT,0,1)  ;"round to nearest tenth
               ELSE  IF VITTYPE="W4LS" DO
               . SET RESULT=+$JUSTIFY(HEIGHT*2.54,0,1)_"^"_+$JUSTIFY(WEIGHT*0.4545,0,1)
CMETQT          QUIT RESULT
               ;
               ;
GETDATES(DOB,MONMIN,MAXMON,STARTDT,ENDDT)              ;
               ;"Purpose: Convert DOB + age range into absolute starting and ending date
               ;"Input: DOB -- The patient's date of birth, in FMDate format
               ;"       MONMIN -- the patient's age (months) at the beginning of desired date range
               ;"       MONMAX -- the patient's age (months) at the end of desired date range
               ;"       STARTDT -- PASS BY REFERENCE, AN OUT PARAMETERS
               ;"       ENDDT -- PASS BY REFERENCE, AN OUT PARAMETERS
               ;"Result: none
               ;"Output: STARTDT AND ENDDT are filled with beginning and ending dates, in FMDate format
               ;"
               NEW X1,X2
               ;"Calc Start Date
               SET X1=DOB
               SET X2=MONMIN*30  ;"Convert to num of days
               D C^%DTC
               SET STARTDT=X
               ;Calc End Date
               SET X1=DOB
               SET X2=MAXMON*30  ;"Convert to num of days
               D C^%DTC
               SET ENDDT=X
               QUIT
               ;
               ;
               ;"===================================================================
               ;"===================================================================
ADDRPT         ;
               ;"Purpose: Entry point not taking result variable, for KIDS
               NEW RESULT
               DO ADDRPT0(.RESULT)
               QUIT
               ;
               ;
ADDRPT0(RESULT)           ;" //elh
               ;"Purpose: To install (add) the TMG GROWTH CHART MENU to ORWRP REPORT LIST.
               ;"         This will make the reports show up in CPRS
               ;"         The heirarchy is: System(SYS),User,Package(PKG),Division(DIV). To ensure that the
               ;"         Menu is displayed, the entries will be tested top down until the highest
               ;"         heirarchy is found, excluding User. The entry will be placed there.
               ;"Input: None
               ;"Output: None
               ;"Result: 1^Successful or -1^Error Message
               NEW PKG SET PKG="DIC(9.4,"
               NEW SYS SET SYS="DIC(4.2,"
               NEW DIV SET DIV="DIC(4,"
               NEW DONE SET DONE=0
               NEW RPTIEN SET RPTIEN=+$ORDER(^XTV(8989.51,"B","ORWRP REPORT LIST",0))
               NEW FOUND SET FOUND=""
               NEW HIERARCHY
               ;"
               ;"GET THE HIERARCHY STRUCTURE
               NEW I SET I=0
               FOR  SET I=$ORDER(^XTV(8989.51,RPTIEN,30,I)) QUIT:+I'>0  DO
               . SET HIERARCHY(0)=$GET(^XTV(8989.51,RPTIEN,30,I,0))
               . SET HIERARCHY($PIECE(HIERARCHY(0),"^",1))=$PIECE(HIERARCHY(0),"^",2)
               ;"
               ;"SORT THROUGH THE HIERARCHY AND PLACE THE TOP TWO IN HIERARCHY(1) AND HIERARCHY(2) RESPECTIVELY
               SET I=0
               NEW COUNTER SET COUNTER=1
               NEW FILE
               FOR  SET I=$ORDER(HIERARCHY(I)) QUIT:+I'>0  DO
               . SET FILE=HIERARCHY(I)
               . IF FILE'=200 DO    ;"EXCLUDE THE USER REPORT MENU
               . . IF FILE[4.2 DO  ;"SYSTEM
               . . . SET HIERARCHY(COUNTER)=SYS_"^SYS"
               . . . SET COUNTER=COUNTER+1
               . . ELSE  IF FILE[9.4 DO  ;"PACKAGE
               . . . SET HIERARCHY(COUNTER)=PKG_"^PKG"
               . . . SET COUNTER=COUNTER+1
               . . ELSE  IF FILE[4 DO  ;"DIVISION
               . . . SET HIERARCHY(COUNTER)=DIV_"^DIV"
               . . . SET COUNTER=COUNTER+1
               ;"
               ;"TEST FOR HIGHEST USED HIERARCHY
               NEW DATA SET DATA=0
               NEW DATASTRING
               FOR  SET DATA=$ORDER(^XTV(8989.5,"AC",RPTIEN,DATA)) QUIT:(+DATA'>0)!DONE  DO
               . IF DATA[$PIECE(HIERARCHY(1),"^",1) DO
               . . SET FOUND=$PIECE(HIERARCHY(1),"^",2)
               . . SET DATASTRING=DATA
               . . SET DONE=1
               . ELSE  IF DATA[$PIECE(HIERARCHY(2),"^",1) DO
               . . SET FOUND=$PIECE(HIERARCHY(2),"^",2)
               . . SET DATASTRING=DATA
               . ELSE  DO
               . . SET DATASTRING=DATA
               IF FOUND="" SET FOUND=$PIECE(HIERARCHY(3),"^",2)
               ;"
        ;"TEST FOR EXISTENCE OF EITHER HEADING
        NEW BOOLCDCEXISTS SET BOOLCDCEXISTS=0
        NEW BOOLWHOEXISTS SET BOOLWHOEXISTS=0
        NEW SEQCOUNTER SET SEQCOUNTER=0
        NEW RPTTEXT,TEMPIEN
        FOR  SET SEQCOUNTER=$ORDER(^XTV(8989.5,"AC",RPTIEN,DATASTRING,SEQCOUNTER)) QUIT:+SEQCOUNTER'>0  DO
        . SET TEMPIEN=$GET(^XTV(8989.5,"AC",RPTIEN,DATASTRING,SEQCOUNTER))
        . SET RPTTEXT=$PIECE($GET(^ORD(101.24,TEMPIEN,0)),"^",1)
        . ;WRITE SEQCOUNTER_"-"_RPTTEXT,!
        . IF RPTTEXT="TMG GROWTH CHARTS" SET BOOLCDCEXISTS=1
        . IF RPTTEXT="TMG WHO GROWTH CHARTS" SET BOOLWHOEXISTS=1
        ;"
               ;"FIND THE FIRST AVAILABLE SEQUENCE
               SET COUNTER=0
               SET DONE=0
               NEW FIRSTSEQ SET FIRSTSEQ=0
               FOR  SET COUNTER=$ORDER(^XTV(8989.5,"AC",RPTIEN,DATASTRING,COUNTER)) QUIT:(+COUNTER'>0)!DONE  DO
               . SET FIRSTSEQ=FIRSTSEQ+1
               . IF COUNTER'=FIRSTSEQ SET DONE=1
               ;"
               ;"ATTEMPT ADDITIONS AND RETURN RESULTS
               NEW ERROR,TEMP
        IF BOOLCDCEXISTS=0 DO
        . D EN^XPAR(FOUND,"ORWRP REPORT LIST",FIRSTSEQ,"TMG GROWTH CHARTS",.ERROR)
               . IF ERROR=0 DO
               . . SET TEMP=1
               . ELSE  DO
               . . SET TEMP="-1^"_$PIECE(ERROR,"^",2)
        ELSE  DO
        . SET TEMP="-1^ALREADY EXISTS"
               ;"
               ;"FIND THE SECOND AVAILABLE SEQUENCE
               ;"SET DONE=0
               ;"SET COUNTER=0
               NEW SECONDSEQ SET SECONDSEQ=0
               ;"FOR  SET COUNTER=$ORDER(^XTV(8989.5,"AC",RPTIEN,DATASTRING,COUNTER)) QUIT:(+COUNTER'>0)!DONE  DO
               ;". SET SECONDSEQ=SECONDSEQ+1
               ;". IF COUNTER'=SECONDSEQ SET DONE=1
               ;"
               ;"ATTEMPT SECOND ADDITION
               ;"D EN^XPAR(FOUND,"ORWRP REPORT LIST",SECONDSEQ,"TMG WHO GROWTH CHARTS",.ERROR)
        IF BOOLWHOEXISTS=0 DO
               . SET SECONDSEQ=FIRSTSEQ_".1"
               . D EN^XPAR(FOUND,"ORWRP REPORT LIST",SECONDSEQ,"TMG WHO GROWTH CHARTS",.ERROR)
        ELSE  DO
        . SET ERROR="-1^ALREADY EXISTS"
               IF (ERROR=0)&(TEMP=1) DO
               . SET RESULT="1^SUCCESSFUL"
               ELSE  DO
               . SET RESULT="-1^"
               . IF TEMP'=1 DO
               . . SET RESULT=RESULT_"CDC-"_$PIECE(TEMP,"^",2)_" "
               . IF ERROR'=0 DO
               . . SET RESULT=RESULT_"WHO-"_$PIECE(ERROR,"^",2)
               QUIT
TEST
        new counter set counter=0
        for  set counter=$order(^ORD(101.24,counter)) quit:counter'>0  do
        . write $piece($get(^ORD(101.24,counter,0)),"^",1),!
        quit
