TMGGRC3A              ;TMG/kst-Growth Chart Javascript code ;7/17/12
                      ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
             ;
             ;"Code for working with pediatric growth chart data.
             ;"This is javascript code that is sent to WebBrowser in CPRS
             ;
             ;"Eddie Hagood and Kevin Toppenberg MD
             ;"(C) 10/5/10
             ;"Released under: GNU General Public License (GPL)
             ;
             ;"=======================================================================
             ;" RPC -- Public Functions.
             ;"=======================================================================
             ;
TOP                ;                                          
              ;;<head>
              ;;<title>PATIENT GROWTH CHART</title>
              ;;
              ;;<!-- Style behavior tag is required to show the VML and must appear in the document HEAD -->
              ;;<style type="text/css">v\:* { behavior: url(#default#VML); }</style>
              ;;
              ;;</head>
              ;;
              ;;<body onload="LoadGraph()">
              ;;EOF
GLIB             ;
              ;;<script type="text/javascript">
              ;;
              ;;/*================================================================================
              ;;
              ;; XYGraph.js : v2.3
              ;;
              ;; by J. Gebelein, Last Updated 2006.01.11
              ;;
              ;; Contact: info@Structura.info
              ;;
              ;; All rights reserved. Copyright 2006 Structura.info
              ;;
              ;;
              ;; This script generates an XY Graph using Vector Markup Language (VML) and returns
              ;; an html string for display via Javascript.  Labels for points on a line, individual
              ;; labels and arrows may be drawn with fully customizable features.  Multiple lines
              ;; with unlimited points and customizable formats can be drawn on the same plot with
              ;; intelligent data axes that provide a best fit to the data for simple, dynamic
              ;; programming.
              ;;
              ;; The VML used by this script is fully supported by Internet Explorer 5 or later,
              ;; and will run on any website or intranet, online or offline.  Data for the graph
              ;; may be generated from static or dynamic Javascript and user form interfaces, or
              ;; even from complex active server database programs.
              ;;
              ;; Use of this code is free for all non-commercial websites.  If you find this code
              ;; to be useful, I will gladly accept PayPal donations to info@Structura.info. I
              ;; provide free email support and will try to accomodate your various needs into
              ;; improving this program.
              ;;
              ;; For commercial use I ask for a one time licensing fee of $39.95 per domain, or
              ;; $99.95 for an unlimited license. Both will cover all future version upgrades and
              ;; allow for customization of the source code. An unlimited license will allow
              ;; unrestricted use by a single organization including redistribution or resale as
              ;; supporting code for a software product.
              ;;
              ;; Please leave this header intact if you intend on sharing this code.
              ;;
              ;;==================================================================================
              ;;
              ;;"XYGraph" object documentation
              ;;
              ;;Initialize:
              ;;        var MyGraph = new XYGraph();
              ;;        MyGraph.xmax = 10; // set properties as desired
              ;;
              ;;Properties:
              ;;        See constructor script with inline comments below.
              ;;
              ;;Methods:
              ;;        MyGraph.Plot(XYLine [, XYLine_1, ...]) // returns html code for display
              ;;
              ;;Notes:
              ;;
              ;; Input x,y coordinate pairs using the "XYLine" object found in this script.
              ;;
              ;; The only required input is the x and y data, all formatting and other
              ;; parameters either have default values defined in this script, or are
              ;; automatically calculated as required to best display the data.
              ;;
              ;; Multiple XYLine objects may be passed to the Plot function for graphing.
              ;;
              ;; Extreme values +/-999E+9 and "NaN" are clipped from the data set.
              ;;
              ;; Unlike standard XY graphs, lines are drawn point to point in any direction
              ;; without limitation.  This allows step functions, circles, shapes, etc.
              ;;
              ;; This script does not optimize data for better resolution, it is up to the
              ;; programmer to input the data spacing as desired.
              ;;
              ;; Generating smooth output requires increasing the number of data points at the
              ;; expense of computation time.  Generally, 1000 points or less is adequate.
              ;;
              ;; Formatting for text may be modified using CSS.
              ;;
              ;; Formatting for the axes and lines may be modified using VML styles, for more
              ;; information on VML see the W3C definition page: http://www.w3.org/TR/NOTE-VML
              ;;
              ;;==================================================================================
              ;;
              ;;"XYLine" object documentation
              ;;
              ;;Initialize:
              ;;        var MyLine = new XYLine();
              ;;        MyLine.x = [1, 2, 3, 4]; // set x and y data points
              ;;        MyLine.label = "plot 1"; // set properties as desired
              ;;
              ;;Properties:
              ;;        See constructor script with inline comments below.
              ;;
              ;;================================================================================*/
              ;;
              ;;
              ;;function XYLine() {
              ;;
              ;;        // Arrays for holding x, y coordinate values and point labels
              ;;
              ;;        this.x = new Array();
              ;;        this.y = new Array();
              ;;        this.labels = new Array();
              ;;
              ;;        // Assign VML compliant properties for the line.
              ;;        // Note that non-primary colors must be in #hex or rbg(r,g,b) format.
              ;;
              ;;        this.VMLstroke = "weight='1pt'; color='blue'; dashstyle='solid';";
              ;;        this.drawline=true;        // set to true or false
              ;;
              ;;        // Assign a label for the line
              ;;
              ;;        this.label = "line";        // displayed when mouse is over line
              ;;        this.labelfont = "'Arial'";
              ;;        this.labelsize = "8"; // font size in "pt"
              ;;        this.labelcolor = "black";
              ;;
              ;;        // Assign a VML shapetype for plotting data points, see definitions at bottom of script.
              ;;        // Using the 'none' shapetype plots invisible points and allows coordinates to be
              ;;        // shown when the mouse is over the point.  Set 'drawpoints' to false to turn off
              ;;        // the points completely and speed up graphing for extensive data sets.  The graph script
              ;;        // automatically turns off points if the data set has more than 1000 points.
              ;;
              ;;        this.VMLpointshapetype="diamond";        // [ diamond, square, triangle, circle, x, none ]
              ;;        this.drawpoints=true;          // set to true or false
              ;;        this.drawlabels=false;         // set to true or false
              ;;      this.mouseoverlabels=false;     // true will show the "labels" on mouseover, false will show x,y coor
              ;;
              ;;        // Assign VML properties for the points
              ;;
              ;;        this.pointsize="5";          // shape display size in "pt"
              ;;        this.pointfillcolor="blue";        // point fill color
              ;;        this.pointstrokecolor="black";        // point line color
              ;;}
              ;;
              ;;
              ;;function Arrow() {
              ;;
              ;;        // x and y coordinate values of arrow origin
              ;;
              ;;        this.x = 0;
              ;;        this.y = 0;
              ;;        this.rotation = 45;
              ;;        this.length = 25;
              ;;
              ;;        // Assign a label for the arrow
              ;;
              ;;        this.label = "Test";
              ;;
              ;;        // Assign VML properties for the arrow
              ;;
              ;;        this.size="10";          // shape display size in "pt"
              ;;        this.color="red";        // arrow color
              ;;        this.labelcolor="red";        // label color
              ;;        this.labelsize="12";        // label size in "pt"
              ;;        this.lineweight="2";  // line weight in "pt"
              ;;        this.dashstyle="solid"; // line style
              ;;
              ;;        // Arrow head shape definition
              ;;
              ;;        this.arrowhead='<v:shapetype id="arrowhead" coordsize="500,500" path=" m 0 0 l 250 500 500 0 250 100 x e" />';
              ;;
              ;;} // end function
              ;;
              ;;CONTINUED
              ;"NOTE: Javascript code continued in TMGGRC3B   
