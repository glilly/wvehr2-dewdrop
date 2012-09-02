TMGGRC3F              ;TMG/kst-Growth Chart Javascript code ;7/17/12
                      ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
              ;
SCRIPT  ;
              ;;<script type="text/javascript">
              ;;
              ;;
              ;;var MyLines = [];  //new empty array, global scope
              ;;var MyGraph;
              ;;
              ;;function AssignGraph(Title,XMin,XMax,XTitle,YMin,YMax,YTitle,XInc,YInc) {
              ;;  AGraph = new XYGraph(); // define new XYGraph object
              ;;  AGraph.CSSticfont="font: 8pt 'Arial';";
              ;;  AGraph.CSStitlefont="font: 12pt 'Arial'; font-weight: bold;";
              ;;  AGraph.CSSxaxisfont="font: 8pt 'Arial'; font-weight: bold;";
              ;;  AGraph.CSSyaxisfont="font: 8pt 'Arial'; font-weight: bold;";
              ;;  AGraph.VMLbackgroundfill="color='white';";
              ;;  AGraph.VMLframestroke="color='white';";
              ;;  AGraph.VMLmajoraxisstroke="weight='1pt'; color='black';";
              ;;  AGraph.VMLminorxaxisstroke="weight='0.5pt'; color='#D3D3D3'; dashstyle='dash';";
              ;;  AGraph.VMLminoryaxisstroke="weight='0.5pt'; color='#D3D3D3'; dashstyle='dash';";
              ;;  AGraph.VMLyaxisfontcolor="color='black';";
              ;;  AGraph.gheight=500;
              ;;  AGraph.gwidth=450;
              ;;  AGraph.pad_bottom=10;
              ;;  AGraph.pad_left=10;
              ;;  AGraph.pad_right=10;
              ;;  AGraph.pad_top=10;
              ;;  AGraph.ticsize=5;
              ;;  AGraph.ticspaceavg=30;
              ;;  AGraph.title=Title;
              ;;  AGraph.xaxis=XTitle;
              ;;  AGraph.xint=XMin;
              ;;  AGraph.xmax=XMax;
              ;;  AGraph.xmin=XMin;
              ;;  AGraph.xscale=XInc;
              ;;  AGraph.xticloc="auto";
              ;;  AGraph.yaxis=YTitle;
              ;;  AGraph.yint=YMin;
              ;;  AGraph.ymax=YMax;
              ;;  AGraph.ymin=YMin;
              ;;  AGraph.yscale=YInc;
              ;;  AGraph.yticloc="auto";
              ;;  return AGraph
              ;;}
              ;;
              ;;function AddLine(PatientValues,Refline)  { // EHS adding Refline argument 
              ;;  var ALine = new XYLine();
              ;;  var PointColor="blue"
              ;;  ALine.drawline=true;
              ;;  ALine.label="control";
              ;;  ALine.labelcolor="black";
              ;;  ALine.labelfont="'Arial'";
              ;;  ALine.labelsize="10";
              ;;  ALine.drawlabels=true;
              ;;  ALine.pointstrokecolor="black";
              ;;  if (PatientValues==true) {
              ;;    if (Refline==2) { // EHS adding the IF statment to change the color of the 50%tile line and patient values lines
              ;;      ALine.VMLpointshapetype="dash"; // EHS changed from "circle" to "dash"
              ;;      ALine.VMLstroke="weight='2pt'; color='red'; dashstyle='solid';"; // EHS
              ;;      ALine.pointfillcolor="red"; // EHS
              ;;    }
              ;;    else {
              ;;      ALine.VMLpointshapetype="circle"; // EHS
              ;;      ALine.VMLstroke="weight='2pt'; color='"+PointColor+"'; dashstyle='solid';";
              ;;      ALine.pointfillcolor=PointColor;
              ;;    }
              ;;    ALine.drawpoints=true;
              ;;    ALine.pointsize=5;
              ;;  } else {
              ;;    ALine.VMLstroke="weight='1pt'; color='grey'; dashstyle='dash';";
              ;;    ALine.drawpoints=false;
              ;;    ALine.pointfillcolor="grey";
              ;;  }
              ;;  MyLines.push(ALine);
              ;;  return ALine
              ;;}
              ;;
              ;;function AddWHOLN() {
              ;;  var ALine = new XYLine();
              ;;  var PointColor="blue"
              ;;  ALine.drawline=true;
              ;;  ALine.label="control";
              ;;  ALine.labelcolor="black";
              ;;  ALine.labelfont="'Arial'";
              ;;  ALine.labelsize="10";
              ;;  ALine.pointstrokecolor="black";
              ;;  ALine.VMLpointshapetype="circle";
              ;;  ALine.VMLstroke="weight='2pt'; color='grey'; dashstyle='solid';";
              ;;  ALine.pointsize=5;
              ;;  ALine.drawpoints=false;
              ;;  ALine.pointfillcolor="grey";
              ;;  ALine.drawlabels=true;
              ;;
              ;;  MyLines.push(ALine);
              ;;  return ALine
              ;;}
              ;;
              ;;function LoadGraph() {
              ;;  MyGraph=SetupGraph();
              ;;  SetupLines() ;
              ;;  for (var i=0; i<MyLines.length; i++) {
              ;;    MyGraph.Plot(MyLines[i]);
              ;;   }
              ;;   AddTableOfValues();
              ;;   AddGraphDataSource();
              ;;   graphdiv.innerHTML=MyGraph;
              ;;}
              ;;EOF
                   ;
                   ;
SETGRAPH(ROOT,TITLE,XMIN,XMAX,XTITLE,YMIN,YMAX,YTITLE,XINC,YINC,SOURCE,ACCESSDT,GRAPHTYP)              ;
              ;"Purpose: Send out Graph specific set up code.
              DO SETITEM^TMGGRC2A(.ROOT,"//========= GRAPH SPECIFIC VALUES ======================")
              DO SETITEM^TMGGRC2A(.ROOT,"function SetupGraph() {")
              DO SETITEM^TMGGRC2A(.ROOT,"  var Title="""_TITLE_""";")
              DO SETITEM^TMGGRC2A(.ROOT,"  var XTitle="""_XTITLE_""";")
              DO SETITEM^TMGGRC2A(.ROOT,"  var YTitle="""_YTITLE_""";")
              IF GRAPHTYP="WHO-HA-B5"  DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine();")
              IF GRAPHTYP="WHO-BA-B5"  DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine();")
              DO SETITEM^TMGGRC2A(.ROOT,"  MyGraph = AssignGraph(Title,"_XMIN_","_XMAX_",XTitle,"_YMIN_","_YMAX_",YTitle,"_XINC_","_YINC_");")
              DO SETITEM^TMGGRC2A(.ROOT,"  return MyGraph")
              DO SETITEM^TMGGRC2A(.ROOT,"}")
              DO SETITEM^TMGGRC2A(.ROOT,"   ")
              DO SETITEM^TMGGRC2A(.ROOT,"function AddGraphDataSource() {")
              DO SETITEM^TMGGRC2A(.ROOT,"   var s;")
              DO SETITEM^TMGGRC2A(.ROOT,"   s = MyGraph;")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""<P><H6><U>Source of Normative Reference Values</U>:<BR>"";")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+"""_SOURCE_"<BR>"";")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""Accessed on "_ACCESSDT_""";")
              DO SETITEM^TMGGRC2A(.ROOT,"   MyGraph=s;")
              DO SETITEM^TMGGRC2A(.ROOT,"}")
              DO SETITEM^TMGGRC2A(.ROOT,"    ")
              QUIT
                   ;
                   ;
STRTLINE(ROOT)            ;
              ;"Purpose: Start adding Data Set Line(s)
              ;"Input: ROOT -- The root to output to .
              ;"Results: none
              ;"Output: writes out data via SETITEM
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"//========= PATIENT SPECIFIC VALUES ======================")
              DO SETITEM^TMGGRC2A(.ROOT,"function SetupLines() {")
              DO SETITEM^TMGGRC2A(.ROOT,"  var ALine")
              DO SETITEM^TMGGRC2A(.ROOT,"  ")
              DO SETITEM^TMGGRC2A(.ROOT,"  ALine = AddLine(false,0)")  ;"For some reason, graph didn't work right without this. ; EHS adding 0 to compatible with AddLine signature 
              DO SETITEM^TMGGRC2A(.ROOT,"  ALine.x = [0,1];")
              DO SETITEM^TMGGRC2A(.ROOT,"  ALine.y = [0,0];")
              DO SETITEM^TMGGRC2A(.ROOT,"  ALine.labels = ['',''];")
              DO SETITEM^TMGGRC2A(.ROOT,"  ")
              QUIT
                   ;
                   ;
ADDLINE(ROOT,ARRAY,REFLINE)               ;" Add Data Set for a Line
              ;"Purpose: OutPut 1 dataset
              ;"Input: ROOT -- The root to output to .
              ;"       ARRAY -- Array of data points. Format:
              ;"               ARRAY(#)=x^y^Label^DateOfValue^[Age]
              ;"       REFLINE -- 0 if patient data line, 1 if normal curve line
              ;"Results: none
              ;"Output: writes out data via SETITEM
              ;
              NEW SX,SY,SL,LINE
              NEW NUM SET NUM=0
              DO SETITEM^TMGGRC2A(.ROOT,"  ALine = AddLine("_$SELECT(REFLINE=1:"false",1:"true")_","_REFLINE_")") ; EHS
              ;
              SET SX="  ALine.x =["
              SET SY="  ALine.y =["
              SET SL="  ALine.labels =["
              NEW I SET I=0
              FOR  SET I=$ORDER(ARRAY(I)) QUIT:+I'>0  DO
              . NEW DATA SET DATA=$GET(ARRAY(I))
              . NEW X,Y,LBL
              . SET X=$PIECE(DATA,"^",1)
              . IF $LENGTH($PIECE(X,".",2))>1 SET X=$JUSTIFY(X,0,1)
              . SET Y=$P(DATA,"^",2)
              . IF $LENGTH($PIECE(Y,".",2))>1 SET Y=$JUSTIFY(Y,0,1)
              . SET LBL=$P(DATA,"^",3)
              . IF $EXTRACT(SX,$LENGTH(SX))'="[" SET SX=SX_","
              . SET SX=SX_X
              . IF $EXTRACT(SY,$LENGTH(SY))'="[" SET SY=SY_","
              . SET SY=SY_Y
              . IF $EXTRACT(SL,$LENGTH(SL))'="[" SET SL=SL_","
              . SET SL=SL_"'"_LBL_"'"
              SET SX=SX_"];"
              SET SY=SY_"];"
              SET SL=SL_"];"
              ;
              ;
              DO SETITEM^TMGGRC2A(.ROOT,SX)
              DO SETITEM^TMGGRC2A(.ROOT,SY)
              DO SETITEM^TMGGRC2A(.ROOT,SL)
              DO SETITEM^TMGGRC2A(.ROOT,"   ")
              QUIT
                   ;
                   ;
ADDWHOL1(ROOT)   ;
              ;"Purpose: Draw Line in WHO Height/Length for Age(Birth to 5 Years) table
              ;"Input: ROOT -- The root to output to .
              ;"Results: none
              ;"Output: writes out table via SETITEM
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"//========= WHO LINE FOR HEIGHT FOR AGE ======================")
              DO SETITEM^TMGGRC2A(.ROOT,"function WHOLine() {")
              DO SETITEM^TMGGRC2A(.ROOT,"  var WHOLine")
              DO SETITEM^TMGGRC2A(.ROOT,"  ")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.x = [25,25];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.y = [41,124];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.labels = ['',''];")
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.x = [18];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.y = [46];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.labels = ['Length'];")
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.x = [26];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.y = [46];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.labels = ['Height'];")
              DO SETITEM^TMGGRC2A(.ROOT,"  }")
              QUIT
                   ;
                   ;
ADDWHOL2(ROOT)   ;
              ;"Purpose: Draw Line in WHO BMI for Age(Birth to 5 Years) to separate Height/Length table
              ;"Input: ROOT -- The root to output to .
              ;"Results: none
              ;"Output: writes out table via SETITEM
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"//========= WHO LINE FOR HEIGHT FOR AGE ======================")
              DO SETITEM^TMGGRC2A(.ROOT,"function WHOLine() {")
              DO SETITEM^TMGGRC2A(.ROOT,"  var WHOLine")
              DO SETITEM^TMGGRC2A(.ROOT,"  ")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.x = [25,25];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.y = [10.5,21];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.labels = ['',''];")
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.x = [18];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.y = [12];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.labels = ['Length'];")
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.x = [26];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.y = [12];")
              DO SETITEM^TMGGRC2A(.ROOT,"  WHOLine.labels = ['Height'];")
              DO SETITEM^TMGGRC2A(.ROOT,"  }")
              QUIT
                   ;
                   ;
ADDTABLE(ROOT,ARRAY,GRAPHTYP)    ;
              ;"Purpose: Output data in a table
              ;"Input: ROOT -- The root to output to .
              ;"       ARRAY -- Array of data points. Format:
              ;"                ARRAY(#)=x^y^Label^DateOfValue^[Age]^%tile
              ;"       GRAPHTYP -- Type of graph
              ;"            (see documention in TMGGRC2.m)
              ;"Results: none
              ;"Output: writes out table via SETITEM
              ;
              NEW TTLCOL2,TTLCOL3,TTLCOL4,TTLCOL5,ROUND
              ;" Determine what the X value is
              IF GRAPHTYP["CH-" DO
              . SET TTLCOL2="Age (yrs)"
              . SET ROUND=1
              . SET TTLCOL4="%tile"
              . SET TTLCOL5=""
              ELSE  IF (GRAPHTYP'["WT4")&(GRAPHTYP'["WHO-WL") DO
              . SET TTLCOL2="Age (mos)"
              . SET ROUND=0
              . SET TTLCOL4="%tile"
              . SET TTLCOL5=""
              ELSE  DO  ;" if WT4 , process X Y and AGE here
              . SET TTLCOL2="Length (cm)"
              . SET TTLCOL3="Weight (kg)"
              . SET ROUND=0
              . SET TTLCOL5="%tile"
              . SET TTLCOL4="Age (mos)"
              ;
              ;" Determine what the Y value is
              IF (GRAPHTYP["HT")!(GRAPHTYP["LN")!(GRAPHTYP["WHO-HA") DO
              . SET TTLCOL3="Height/Length (cm)"
              ELSE  IF (GRAPHTYP["HC")!(GRAPHTYP["WHO-HC") DO
              . SET TTLCOL3="Head Circumference (cm)"
              ELSE  IF (GRAPHTYP["BMI")!(GRAPHTYP["WHO-BA") DO
              . SET TTLCOL3="BMI"
              ELSE  IF ((GRAPHTYP["WT")&(GRAPHTYP'["WT4"))!(GRAPHTYP["WHO-W") DO
              . SET TTLCOL3="Weight (kg)"
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"}")
              DO SETITEM^TMGGRC2A(.ROOT,"    ")
              DO SETITEM^TMGGRC2A(.ROOT,"function AddTableOfValues() {")
              DO SETITEM^TMGGRC2A(.ROOT,"   var s;")
              DO SETITEM^TMGGRC2A(.ROOT,"   s = MyGraph;")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""<BR><U>Table of Actual Patient Values</U>:<BR>"";")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""<table border=1>"";")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""<tr>"";")
              IF TTLCOL5="" DO  ;" Don't add column 5 unless
              . DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""   <th>Date:</th><th>"_TTLCOL2_":</th><th>"_TTLCOL3_"</th><th>"_TTLCOL4_"</th>"";")
              ELSE  DO
              . DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""   <th>Date:</th><th>"_TTLCOL4_":</th><th>"_TTLCOL2_"</th><th>"_TTLCOL3_"</th><th>"_TTLCOL5_"</th>"";")
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""</tr>"";")
              ;
              NEW I SET I=0
              FOR  SET I=$ORDER(ARRAY(I)) QUIT:+I'>0  DO
              . NEW DATA SET DATA=$GET(ARRAY(I))
              . NEW X,Y,DATE,AGE,TILE
              . SET X=$PIECE(DATA,"^",1)
              . SET Y=$PIECE(DATA,"^",2)
              . IF GRAPHTYP["BMI" SET Y=$JUSTIFY(Y,0,3)
                 . IF GRAPHTYP["WA"!(GRAPHTYP["WT") SET Y=$JUSTIFY(Y,0,1)  ;round out weights to 1 dp
              . SET TILE=$PIECE(DATA,"^",6)
              . SET DATE=$PIECE(DATA,"^",4)
              . DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""<tr align=center>"";")
              . IF TTLCOL5="" DO
              . . IF ROUND'=-1 SET X=$JUSTIFY(X,0,ROUND)
              . . DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""   <td>"_DATE_"</td><td>"_X_"</td><td>"_Y_"</td><td>"_TILE_"</td>"";")
              . ELSE  DO
              . . SET AGE=$JUSTIFY($PIECE(DATA,"^",5),0,0)
              . . DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""   <td>"_DATE_"</td><td>"_AGE_"</td><td>"_X_"</td><td>"_Y_"</td><td>"_TILE_"</td>"";")
              . DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""</tr>"";")
              ;
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"   s=s+""</table>"";")
              DO SETITEM^TMGGRC2A(.ROOT,"   MyGraph=s;")
              QUIT
              ;
ENDLINES(ROOT)            ;
              ;"Purpose: End adding Data Set Line(s)
              ;"Input: ROOT -- The root to output to .
              ;"Results: none
              ;"Output: writes out data via SETITEM
              ;
              DO SETITEM^TMGGRC2A(.ROOT,"}")
                   ;
                   ;
ENDING   ;
              ;;</script>
              ;;
              ;;<div id="graphdiv"></div>
              ;;<p><H6>Graphs developed by Family Physicians of Greeneville (TMG),
              ;; utilizing XYGraph.js by J. Gebelein
              ;;</p>
              ;;</body>
              ;;</html>
              ;;EOF
              ;
XSCRIPT ;
              ;;<script type="text/javascript">
              ;;
              ;;function LoadGraph() {
              ;;   graphdiv.innerHTML="Hello World!";
              ;;}
              ;;
              ;;EOF
