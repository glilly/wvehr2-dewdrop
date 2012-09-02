TMGGRC2        ;TMG/kst-Work with Growth Chart Data ;10/5/10 ; 9/27/11 9:41am
               ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
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
               ;"ADDRPT -- install (add) the TMG GROWTH CHART MENU to ORWRP REPORT LIST.
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
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"CH-HT")
               QUIT
               ;
TMGGCLNI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Length percentile for age (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               ;
               DO TMGCOMGR^TMGGRC2A(.ROOT,"INF-LN")
               QUIT
               ;
TMGGCWTI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for age (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"INF-WT")
               QUIT
               ;
TMGGCHDC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Head Circumference percentile for age
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"INF-HC")
               QUIT
               ;
TMGGCBMI(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For BMI percentile for age (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"INF-BMI")
               QUIT
               ;
TMGGCWHL(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for Length (infant)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"INF-WT4L")
               QUIT
               ;
TMGGCHTC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Height percentile for age (child)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"CH-HT")
               QUIT
               ;
TMGGCWTC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for age (child)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"CH-WT")
               QUIT
               ;
TMGGCBMC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For BMI percentile for age (child)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"CH-BMI")
               QUIT
               ;
TMGGCWHS(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"         For Weight percentile for stature (child)
               ;"Input: (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"CH-WT4S")
               QUIT
               ;
               ;"WHO - BMI ENTRY POINTS
TMGWHOBA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-BA")
               QUIT
               ;
TMGWBAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-BA-B2")
               QUIT
               ;
TMGWBAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-BA-B5")
               QUIT
               ;
TMGWBA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO BMI by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-BA-25")
               QUIT
               ;
               ;"WHO - Height for Age Entry Points
TMGWHOHA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HA")
               QUIT
               ;
TMGWHAB6(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HA-B6")
               QUIT
               ;
TMGWHAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HA-B2")
               QUIT
               ;
TMGWHA62(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HA-62")
               QUIT
               ;
TMGWHA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HA-25")
               QUIT
               ;
TMGWHAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Height by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HA-B5")
               QUIT
               ;
               ;"WHO - Weight for age Entry Points
TMGWHOWA(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WA")
               QUIT
               ;
TMGWWAB6(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WA-B6")
               QUIT
               ;
TMGWWAB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WA-B2")
               QUIT
               ;
TMGWWA62(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WA-62")
               QUIT
               ;
TMGWWAB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WA-B5")
               QUIT
               ;
TMGWWA25(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WA-25")
               QUIT
               ;
               ;"WHO - Head Circumference Entry Points
TMGWHOHC(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HC")
               QUIT
               ;
TMGWHCBT(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HC-BT")
               QUIT
               ;
TMGWHCB2(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HC-B2")
               QUIT
               ;
TMGWHCB5(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Head Circumference by Age
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-HC-B5")
               QUIT
               ;
TMGWHOWL(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight for Length
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WL")
               QUIT
               ;
TMGWHOWS(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)            ;
               ;"Purpose: Entry point, as called from CPRS REPORT system
               ;"           For WHO Weight for Stature
               ;"Input (Same as TMGGRAPH, see above)
               ;"Result: None.  Output goes into @ROOT
               DO TMGCOMGR^TMGGRC2A(.ROOT,"WHO-WS")
               QUIT
               ;
ADDRPT          ;
                      DO ADDRPT^TMGGRC2C
                      QUIT
