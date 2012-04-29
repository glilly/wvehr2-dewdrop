TMGGRC3        ;TMG/kst-Work with Growth Chart Data ;10/5/10 ; 5/31/11 4:09pm
               ;;1.0;TMG-LIB;**1**;10/5/10;Build 27
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
GLIB              ;
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
               ;;
               ;;
               ;;function Label() {
               ;;
               ;;        // x and y coordinate values of the label origin
               ;;
               ;;        this.x = 0;
               ;;        this.y = 0;
               ;;        this.rotation = 45;
               ;;        this.length = 0;
               ;;
               ;;        // Assign a label text
               ;;
               ;;        this.label = "";
               ;;
               ;;        // Assign VML properties for the label
               ;;
               ;;        this.labelcolor="red";        // label color
               ;;        this.labelsize="12";        // label size in "pt"
               ;;
               ;;        this.VMLpointshapetype="circle";        // [ diamond, square, triangle, circle, x, none ]
               ;;
               ;;        this.pointsize="6";          // shape display size in "pt"
               ;;        this.pointfillcolor="red";        // point fill color
               ;;        this.pointstrokecolor="black";        // point line color
               ;;
               ;;} // end function
               ;;
               ;;
               ;;
               ;;function XYGraph() {
               ;;
               ;;  // Data Properties
               ;;
               ;;        // The max and min values define the upper and lower axis values to display.
               ;;        // If not specified they will automatically fit to the data limits.
               ;;
               ;;        this.xmax=null;
               ;;        this.xmin=null;
               ;;        this.ymax=null;
               ;;        this.ymin=null;
               ;;
               ;;        // Graph titles
               ;;
               ;;        this.title=null;
               ;;        this.xaxis=null;
               ;;        this.yaxis=null;
               ;;
               ;;        // Tic scale spacing, if not specified it will be fit to the data.
               ;;
               ;;        this.xscale=null;
               ;;        this.yscale=null;
               ;;
               ;;        // Value where the axes cross.  Default is at 0,0
               ;;        // Set to "Number.NEGATIVE_INFINITY" to align with the minimum axis value.
               ;;        // Set to "Number.POSITIVE_INFINITY" to align with the maximum axis value.
               ;;
               ;;        this.xint=0;
               ;;        this.yint=0;
               ;;
               ;;        // The last plot string generated is maintained in memory
               ;;
               ;;        this.lastplot="";
               ;;
               ;;        // Tracks the changes made from additional plots for use with DeleteLast()
               ;;
               ;;        this.lastplotadded= new Array();
               ;;        this.numplots=0;
               ;;
               ;;  // Style Properties
               ;;
               ;;        this.gheight=200;        // Plotting height in "pt"
               ;;        this.gwidth=300;        // Plotting width in "pt"
               ;;        this.pad_top=10;        // Internal padding margins in "pt"
               ;;        this.pad_bottom=10;
               ;;        this.pad_left=10;
               ;;        this.pad_right=10;
               ;;
               ;;        this.ticsize=5;         // Tic size in "pt", set to "0" to turn off
               ;;        this.ticspaceavg=30;        // Average auto tic spacing in "pt"
               ;;        this.xticloc="auto";        // x-axis labels "top", "bottom", "auto" or "none"
               ;;        this.yticloc="auto";        // y-axis labels "right", "left", "auto" or "none"
               ;;        this.userxticlabels=null;        // allows the user to override x axis tic labels
               ;;        this.useryticlabels=null;        // allows the user to override y axis tic labels
               ;;
               ;;        this.VMLminorxaxisstroke = "weight='0.5pt'; color='#D3D3D3'; dashstyle='dash';";
               ;;        this.VMLminoryaxisstroke = "weight='0.5pt'; color='#D3D3D3'; dashstyle='dash';";
               ;;        this.VMLmajoraxisstroke = "weight='1pt'; color='black';";
               ;;        this.VMLbackgroundfill = "color='white'";
               ;;        this.VMLframestroke = "color='white'";
               ;;
               ;;        this.CSSticfont = "font: 8pt 'Arial';";
               ;;        this.CSStitlefont = "font: 10pt 'Arial'; font-weight: bold;";  // font sizes must be set in "pt"
               ;;        this.CSSxaxisfont = "font: 8pt 'Arial'; font-weight: bold;";
               ;;        this.CSSyaxisfont = "font: 8pt 'Arial'; font-weight: bold;";
               ;;        this.VMLyaxisfontcolor = "black";  // must specify y-axis title font color since it is VML object
               ;;
               ;;}
               ;;
               ;;XYGraph.prototype.toString = function() {return this.lastplot;} // The object will evaluate to the last plot
               ;;
               ;;
               ;;
               ;;XYGraph.prototype.Plot = function (XYLine) {
               ;;
               ;;// Parse input to determine x,y data limits and clip extreme values
               ;;        lines = arguments;
               ;;        xmax = Number.NEGATIVE_INFINITY; xmin = Number.POSITIVE_INFINITY;
               ;;        ymax = Number.NEGATIVE_INFINITY; ymin = Number.POSITIVE_INFINITY;
               ;;        clipxmax = (this.xmax ? Number(this.xmax) : 999E+9);
               ;;        clipxmin = (this.xmin ? Number(this.xmin) : -999E+9);
               ;;        clipymax = (this.ymax ? Number(this.ymax) : 999E+9);
               ;;        clipymin = (this.ymin ? Number(this.ymin) : -999E+9);
               ;;        clipped=false;
               ;;
               ;;// fix incorrect input
               ;;        this.yint = Number(this.yint); this.xint = Number(this.xint);
               ;;        this.ymin = Number(this.ymin); this.xmin = Number(this.xmin);
               ;;        this.ymax = Number(this.ymax); this.xmax = Number(this.xmax);
               ;;
               ;;        if (this.xmax < this.xmin && this.xmax) {temp=this.xmax; this.xmax=this.xmin; this.xmin=temp;}
               ;;        if (this.ymax < this.ymin && this.ymax) {temp=this.ymax; this.ymax=this.ymin; this.ymin=temp;}
               ;;
               ;;      xmax=this.xmax; xmin=this.xmin; ymax=this.ymax; ymin=this.ymin;
               ;;
               ;;  for (var n=0; n<lines.length; n++) {
               ;;        var j=0; tempx = new Array(); tempy = new Array(); templabels = new Array();
               ;;        linelen = (lines[n].y.length > lines[n].x.length ? lines[n].x.length : lines[n].y.length);
               ;;        for (var i=0; i<linelen; i++) {
               ;;         if ((lines[n].x[i] <= clipxmax)&&(lines[n].x[i] >= clipxmin)&&(lines[n].y[i] <= clipymax)&&(lines[n].y[i] >= clipymin)&&(i<=1000)) {
               ;;                 if (xmax < lines[n].x[i]) {xmax = lines[n].x[i]};
               ;;                 if (xmin > lines[n].x[i]) {xmin = lines[n].x[i]};
               ;;                 if (ymax < lines[n].y[i]) {ymax = lines[n].y[i]};
               ;;                 if (ymin > lines[n].y[i]) {ymin = lines[n].y[i]};
               ;;                 tempx[j]=lines[n].x[i];
               ;;                 tempy[j]=lines[n].y[i];
               ;;                 if(lines[n].drawlabels || lines[n].mouseoverlabels) {templabels[j]= lines[n].labels[j];}
               ;;                 j++;
               ;;         }
               ;;         else if (isNaN(lines[n].x[i]) || isNaN(lines[n].y[i])) {clipped=true;}
               ;;         else if (((lines[n].x[i+1] <= clipxmax)&&(lines[n].x[i+1] >= clipxmin)&&(lines[n].y[i+1] <= clipymax)&&(lines[n].y[i+1] >= clipymin)&&(i<=1000))) {
               ;;                 lastxy = this.Findedge(lines[n].x[i+1],lines[n].x[i],lines[n].y[i+1],lines[n].y[i],clipxmax,clipxmin,clipymax,clipymin);
               ;;                 if (Math.abs(lastxy[0]) < 999E+9 && Math.abs(lastxy[1]) < 999E+9) {
               ;;                  tempx[j]=lastxy[0]; tempy[j]=lastxy[1];
               ;;                  if(lines[n].drawlabels || lines[n].mouseoverlabels) {templabels[j]="";}
               ;;                  j++;
               ;;                 }
               ;;                 clipped=true;
               ;;         }
               ;;         else if (((lines[n].x[i-1] <= clipxmax)&&(lines[n].x[i-1] >= clipxmin)&&(lines[n].y[i-1] <= clipymax)&&(lines[n].y[i-1] >= clipymin))&&(i<=1000)) {
               ;;                 lastxy = this.Findedge(lines[n].x[i-1],lines[n].x[i],lines[n].y[i-1],lines[n].y[i],clipxmax,clipxmin,clipymax,clipymin);
               ;;                 if (Math.abs(lastxy[0]) < 999E+9 && Math.abs(lastxy[1]) < 999E+9) {
               ;;                  tempx[j]=lastxy[0]; tempy[j]=lastxy[1];
               ;;                  if(lines[n].drawlabels || lines[n].mouseoverlabels) {templabels[j]="";}
               ;;                  j++;
               ;;                 }
               ;;                 if (i+1 != linelen) {
               ;;                 lines.length += 1;
               ;;                 lines[(lines.length-1)] = new Array();
               ;;                 lines[(lines.length-1)].VMLstroke = lines[n].VMLstroke;
               ;;                 lines[(lines.length-1)].drawline = lines[n].drawline;
               ;;                 lines[(lines.length-1)].label = lines[n].label;
               ;;                 lines[(lines.length-1)].VMLpointshapetype = lines[n].VMLpointshapetype;
               ;;                 lines[(lines.length-1)].pointsize = lines[n].pointsize;
               ;;                 lines[(lines.length-1)].pointfillcolor = lines[n].pointfillcolor;
               ;;                 lines[(lines.length-1)].pointstrokecolor = lines[n].pointstrokecolor;
               ;;                 lines[(lines.length-1)].drawpoints = lines[n].drawpoints;
               ;;                 lines[(lines.length-1)].labelsize = lines[n].labelsize;
               ;;                 lines[(lines.length-1)].labelfont = lines[n].labelfont;
               ;;                 lines[(lines.length-1)].labelcolor = lines[n].labelcolor;
               ;;                 lines[(lines.length-1)].drawlabels = lines[n].drawlabels;
               ;;               lines[(lines.length-1)].mouseoverlabels = lines[n].mouseoverlabels;
               ;;                 lines[(lines.length-1)].x=lines[n].x.slice(i);
               ;;                 lines[(lines.length-1)].y=lines[n].y.slice(i);
               ;;                 lines[n].x=tempx; lines[n].y=tempy;
               ;;                 if(lines[n].drawlabels || lines[n].mouseoverlabels) {
               ;;                  lines[(lines.length-1)].labels=lines[n].labels.slice(i);
               ;;                  lines[n].labels=templabels;
               ;;                 }
               ;;                 clipped=true;
               ;;
               ;;                 break;
               ;;                 }
               ;;         }
               ;;         else if (i > 1000) {
               ;;                 lines[n].drawpoints = false;
               ;;                 lines[n].drawlabels = false;
               ;;                 lines.length += 1;
               ;;                 lines[(lines.length-1)] = new Array();
               ;;                 lines[(lines.length-1)].VMLstroke = lines[n].VMLstroke;
               ;;                 lines[(lines.length-1)].drawline = lines[n].drawline;
               ;;                 lines[(lines.length-1)].label = lines[n].label;
               ;;                 lines[(lines.length-1)].drawpoints = false;
               ;;                 lines[(lines.length-1)].drawlabels = false;
               ;;                 lines[(lines.length-1)].x=lines[n].x.slice(i-1);
               ;;                 lines[(lines.length-1)].y=lines[n].y.slice(i-1);
               ;;                 lines[n].x=tempx; lines[n].y=tempy;
               ;;
               ;;                 break;
               ;;         }
               ;;         else {clipped=true;}
               ;;        }
               ;;        lines[n].x=tempx; lines[n].y=tempy; lines[n].labels=templabels;
               ;;  }
               ;;
               ;;        if (this.xint == Number.NEGATIVE_INFINITY) {this.xint = xmin;}
               ;;        if (this.xint == Number.POSITIVE_INFINITY) {this.xint = xmax;}
               ;;        if (this.yint == Number.NEGATIVE_INFINITY) {this.yint = ymin;}
               ;;        if (this.yint == Number.POSITIVE_INFINITY) {this.yint = ymax;}
               ;;
               ;;// Intialize data
               ;;
               ;;if (this.lastplot == "") { // don't redraw graph background if called multiple times
               ;;
               ;;        xscale=Number(this.xscale); yscale=Number(this.yscale);
               ;;        xint=Number(this.xint); yint=Number(this.yint);
               ;;
               ;;        gheight=Number(this.gheight); gwidth=Number(this.gwidth);
               ;;        ticsize=Number(this.ticsize);
               ;;
               ;;        xticloc=this.xticloc; yticloc=this.yticloc;
               ;;
               ;;// Initialize parameters
               ;;
               ;;        gxpt=100;
               ;;        pad_t=gxpt*this.pad_top; pad_b=gxpt*this.pad_bottom; // padding
               ;;        pad_l=gxpt*this.pad_left; pad_r=gxpt*this.pad_right;
               ;;        gwt=Math.abs(Math.round(gwidth*gxpt)); // total graph width;
               ;;        ght=Math.abs(Math.round(gheight*gxpt)); // total graph height;
               ;;
               ;;        gstyle='position:absolute; width='+gwt+'; height='+ght; // repetitive string constant
               ;;        GXstyle=this.CSSticfont+'position:absolute;';
               ;;        GYstyle=this.CSSticfont+'position:absolute;';
               ;;        GYLstyle=this.CSSticfont+'position:absolute; text-align:right; width:'; // finished later
               ;;
               ;;// fix auto scale x axis
               ;;        if (xint < xmin) {xmin=xint;}
               ;;        if (xint > xmax) {xmax=xint;}
               ;;
               ;;// x auto tic scale
               ;;     if (xscale <= 0) {
               ;;        xticmax=(gwidth-(pad_r+pad_l)/gxpt)/this.ticspaceavg;
               ;;        ticdivision=[0.1,0.2,0.25,0.5];
               ;;        divpow=0;
               ;;        i=0;
               ;;          while ((xmax-xmin)/(ticdivision[i]*Math.pow(10,divpow)) > xticmax) {
               ;;            i++;
               ;;            if (!(i % ticdivision.length)) {divpow++; i=0;}
               ;;            if (divpow>1) {xticmax=(gwidth-(pad_r+pad_l)/gxpt)/(Number(this.ticspaceavg)+5);}
               ;;          }
               ;;        if (i==0 && divpow==0) {
               ;;          i=ticdivision.length-1; divpow=-1; xticmax=(gwidth-(pad_r+pad_l)/gxpt)/(Number(this.ticspaceavg)+10);
               ;;          while ((xmax-xmin)/(ticdivision[i]*Math.pow(10,divpow)) < xticmax) {
               ;;            i--;
               ;;            if (i==-1) {divpow--; i=ticdivision.length-1; xticmax=(gwidth-(pad_r+pad_l)/gxpt)/(Number(this.ticspaceavg)+30);}
               ;;          }
               ;;        }
               ;;        xscale=ticdivision[i]*Math.pow(10,divpow);
               ;;     }
               ;;
               ;;
               ;;// fix auto scale y axis
               ;;        if (yint < ymin) {ymin = yint;}
               ;;        if (yint > ymax) {ymax = yint;}
               ;;
               ;;// y auto tic scale
               ;;     if (yscale <= 0) {
               ;;        yticmax=(gheight-(pad_t+pad_b)/gxpt)/this.ticspaceavg;
               ;;        ticdivision=[0.1,0.2,0.25,0.5];
               ;;        divpow=0;
               ;;        i=0;
               ;;          while ((ymax-ymin)/(ticdivision[i]*Math.pow(10,divpow)) > yticmax) {
               ;;            i++;
               ;;            if (!(i % ticdivision.length)) {divpow++; i=0;}
               ;;            if (divpow>1) {yticmax=(gwidth-(pad_t+pad_b)/gxpt)/(Number(this.ticspaceavg)+5);}
               ;;          }
               ;;        if (i==0 && divpow==0) {
               ;;          i=ticdivision.length-1; divpow=-1; yticmax=(gheight-(pad_t+pad_b)/gxpt)/(this.ticspaceavg+10);
               ;;          while ((ymax-ymin)/(ticdivision[i]*Math.pow(10,divpow)) < yticmax) {
               ;;            i--;
               ;;            if (i==-1) {divpow--; i=ticdivision.length-1; yticmax=(gheight-(pad_t+pad_b)/gxpt)/(this.ticspaceavg+30);}
               ;;          }
               ;;        }
               ;;        yscale=ticdivision[i]*Math.pow(10,divpow);
               ;;     }
               ;;
               ;;// fix auto scale y axis
               ;;        if (!clipped) {
               ;;         ymin = (ymin%yscale ? ymin-ymin%yscale-yscale : ymin);
               ;;         ymax = (ymax%yscale ? ymax-ymax%yscale+yscale : ymax);
               ;;        }
               ;;
               ;;
               ;;// Determine x tic labels
               ;;
               ;;        xticlabels = new Array(); xticcharnum=1;
               ;;        numxticleft = Math.floor((xint-xmin)/xscale);
               ;;        numxtic = numxticleft+Math.floor((xmax-xint)/xscale)+1;
               ;;        for (var i=0; i<numxtic; i++) {
               ;;         xticlabel=(i-numxticleft)*xscale+xint;
               ;;         negstr=""; expstr=0;
               ;;         if (xticlabel < 0) {xticlabel*=-1; negstr="-";}
               ;;         switch (true) {
               ;;         case (xticlabel > 99999) :
               ;;                 while (xticlabel>=1000) {xticlabel/=1000; expstr++;}
               ;;                 xticlabel=String(xticlabel).slice(0,4);
               ;;                 xticlabels[i]=negstr+xticlabel+"E+"+(expstr*3);
               ;;                 break;
               ;;         case (xticlabel < 0.001 && xticlabel!=0) :
               ;;                 while (xticlabel<=0.001) {xticlabel*=1000; expstr++;}
               ;;                 xticlabel=(Math.round(xticlabel*Math.pow(10,4)))/Math.pow(10,4);
               ;;                 xticlabels[i]=negstr+xticlabel+"E-"+(expstr*3);
               ;;                 break;
               ;;         default:
               ;;                 xticlabel=(Math.round(xticlabel*Math.pow(10,3)))/Math.pow(10,3);
               ;;                 xticlabels[i]=negstr+String(xticlabel).slice(0,6);
               ;;                 break;
               ;;         }
               ;;         xticcharnum=Math.max(xticcharnum,String(xticlabels[i]).length);
               ;;        }
               ;;        xticcharnumlast=String(xticlabels[i-1]).length;
               ;;
               ;;        if (this.userxticlabels!=null) {
               ;;        len=Math.min(this.userxticlabels.length,xticlabels.length);
               ;;        for (var i=0; i<len; i++) {
               ;;         xticlabels[i]=this.userxticlabels[i];
               ;;        }}
               ;;
               ;;
               ;;// Determine y tic labels
               ;;
               ;;        yticlabels = new Array(); yticcharnum=0;
               ;;        numyticbot = Math.floor((yint-ymin)/yscale);
               ;;        numytic = numyticbot+Math.floor((ymax-yint)/yscale)+1;
               ;;        for (var i=0; i<numytic; i++) {
               ;;         yticlabel=(i-numyticbot)*yscale+yint;
               ;;         negstr=""; expstr=0;
               ;;         if (yticlabel < 0) {yticlabel*=-1; negstr="-";}
               ;;         switch (true) {
               ;;         case (yticlabel > 99999) :
               ;;                 while (yticlabel>=1000) {yticlabel/=1000; expstr++;}
               ;;                 yticlabel=String(yticlabel).slice(0,4);
               ;;                 yticlabels[i]=negstr+yticlabel+"E+"+(expstr*3);
               ;;                 break;
               ;;         case (yticlabel < 0.001 && yticlabel!=0) :
               ;;                 while (yticlabel<=0.001) {yticlabel*=1000; expstr++;}
               ;;                 yticlabel=(Math.round(yticlabel*Math.pow(10,4)))/Math.pow(10,4);
               ;;                 yticlabels[i]=negstr+yticlabel+"E-"+(expstr*3);
               ;;                 break;
               ;;         default:
               ;;                 yticlabel=(Math.round(yticlabel*Math.pow(10,3)))/Math.pow(10,3);
               ;;                 yticlabels[i]=negstr+String(yticlabel).slice(0,6);
               ;;                 break;
               ;;         }
               ;;         yticcharnum=Math.max(yticcharnum,String(yticlabels[i]).length);
               ;;        }
               ;;
               ;;        if (this.useryticlabels!=null) {
               ;;        len=Math.min(this.useryticlabels.length,yticlabels.length);
               ;;        for (var i=0; i<len; i++) {
               ;;         yticlabels[i]=this.useryticlabels[i];
               ;;        }}
               ;;
               ;;// Determine required extra padding and auto axis location
               ;;        tic_pt=Number((this.CSSticfont.slice(0,this.CSSticfont.indexOf("pt"))).slice(-2));
               ;;        GYLstyle+=tic_pt*(yticcharnum+1)*0.5+"pt;";
               ;;        if (yticloc!="none") {
               ;;          if (!numxticleft) {
               ;;         if (yticloc=="auto") {yticloc="left";}
               ;;         if (yticloc!="right") {
               ;;                 pad_l+=0.75*yticcharnum*tic_pt*gxpt;
               ;;                 if (this.yaxis) {pad_l+=0.5*this.pad_left*gxpt;}
               ;;         }
               ;;          }
               ;;          if (numxticleft == numxtic-1) {
               ;;         if (yticloc=="auto") {yticloc="right";}
               ;;         if (yticloc!="left") {pad_r+=0.75*yticcharnum*tic_pt*gxpt;}
               ;;          }
               ;;        }
               ;;
               ;;        if (xticloc!="none") {
               ;;          if (!numyticbot) {
               ;;         if (xticloc=="auto") {xticloc="bottom";}
               ;;         if (xticloc!="top") {pad_b+=0.75*tic_pt*gxpt;}
               ;;          }
               ;;          if (numyticbot == numytic-1) {
               ;;         if (xticloc=="auto") {xticloc="top";}
               ;;         if (xticloc!="bottom") {pad_t+=0.75*tic_pt*gxpt;}
               ;;          }
               ;;        if (!((numxticleft == numxtic-1) && (yticloc=="right"))) {pad_r+=0.25*xticcharnumlast*tic_pt*gxpt;}
               ;;        }
               ;;        if (this.title) {
               ;;         title_pt=Number((this.CSStitlefont.slice(0,this.CSStitlefont.indexOf("pt"))).slice(-2));
               ;;         pad_t+=1.25*title_pt*gxpt;
               ;;         if (xticloc=="top") pad_t+=0.75*tic_pt*gxpt;}
               ;;        if (this.xaxis) {
               ;;         xaxis_pt=Number((this.CSSxaxisfont.slice(0,this.CSSxaxisfont.indexOf("pt"))).slice(-2));
               ;;         pad_b-=0.25*pad_b;
               ;;         pad_b+=xaxis_pt*gxpt;
               ;;         if (xticloc=="bottom") pad_b+=0.75*tic_pt*gxpt;}
               ;;        if (this.yaxis) {
               ;;         yaxis_pt=Number((this.CSSyaxisfont.slice(0,this.CSSyaxisfont.indexOf("pt"))).slice(-2));
               ;;         pad_l-=0.25*pad_l;
               ;;         pad_l+=yaxis_pt*gxpt;}
               ;;
               ;;
               ;;        gw=gwt-pad_l-pad_r;
               ;;        gh=ght-pad_t-pad_b;
               ;;
               ;;        xscl=gw/(xmax-xmin);
               ;;        yscl=gh/(ymax-ymin);
               ;;
               ;;      this.xmin=xmin;
               ;;      this.xmax=xmax;
               ;;      this.ymin=ymin;
               ;;      this.ymax=ymax;
               ;;
               ;;        gxmin=pad_l;
               ;;        gxmax=gw+pad_l;
               ;;        gxint=(xint-xmin)*xscl+pad_l;
               ;;        gymin=gh+pad_t;
               ;;        gymax=pad_t;
               ;;        gyint=(ymax-yint)*yscl+pad_t;
               ;;        gytic=yscale*yscl;
               ;;        gxtic=xscale*xscl;
               ;;        gticsize=Math.abs(Math.round(ticsize*gxpt));
               ;;
               ;;        gstr='<v:group style="antialias:true; width='+gwidth+'pt; height='+gheight+'pt" coordsize="'+gwt+','+ght+'" coordorigin="0,0">';
               ;;        gstr+='<v:rect style="'+gstyle+'" ><v:stroke '+this.VMLframestroke+' /><v:fill '+this.VMLbackgroundfill+' /></v:rect>';
               ;;
               ;;// draw x-axis
               ;;        if(xscl!=Number.POSITIVE_INFINITY) {
               ;;         gstr+='<v:line from="'+gxmin+','+Math.round(gyint)+'" to="'+gxmax+','+Math.round(gyint)+'" ><v:stroke '+this.VMLmajoraxisstroke+' /></v:line>';
               ;;         }
               ;;// draw y-axis
               ;;        if(yscl!=Number.POSITIVE_INFINITY) {
               ;;         gstr+='<v:line from="'+Math.round(gxint)+','+gymin+'" to="'+Math.round(gxint)+','+gymax+'" ><v:stroke '+this.VMLmajoraxisstroke+' /></v:line>';
               ;;         }
               ;;// draw minor x-axis
               ;;        yticmin=gyint+numyticbot*gytic;
               ;;        for (var i=0; i<numytic; i++) {
               ;;          curint=Math.round(yticmin-gytic*i);
               ;;          if (curint!=Math.round(gyint)) {gstr+='<v:line from="'+gxmin+','+curint+'" to="'+gxmax+','+curint+'" ><v:stroke '+this.VMLminorxaxisstroke+' /></v:line>';}
               ;;        }
               ;;
               ;;// draw minor y-axis
               ;;        xticmin=gxint-numxticleft*gxtic;
               ;;        for (var i=0; i<numxtic; i++) {
               ;;          curint=Math.round(gxtic*i+xticmin);
               ;;          if (curint!=Math.round(gxint)) {gstr+='<v:line from="'+curint+','+gymin+'" to="'+curint+','+gymax+'" ><v:stroke '+this.VMLminoryaxisstroke+' /></v:line>';}
               ;;        }
               ;;
               ;;// draw x-axis tics
               ;;        gstr+='<v:shape style="'+gstyle+'"><v:path v="';
               ;;        for (var i=0; i<numxtic; i++) { gstr+='m '+Math.round(xticmin+i*gxtic)+','+Math.round(gyint)+' r 0,'+((xticloc=="top" ? -1 : 1)*gticsize)+' x ';}
               ;;        gstr+='e" /><v:stroke '+this.VMLmajoraxisstroke+' /><v:fill on="false" /></v:shape>';
               ;;
               ;;// draw y-axis tics
               ;;        gstr+='<v:shape style="'+gstyle+'"><v:path v="';
               ;;        for (var i=0; i<numytic; i++) { gstr+='m '+Math.round(gxint)+','+Math.round(yticmin-i*gytic)+' r '+((yticloc=="right" ? 1 : -1)*gticsize)+',0 x ';}
               ;;        gstr+='e" /><v:stroke '+this.VMLmajoraxisstroke+' /><v:fill on="false" /></v:shape>';
               ;;
               ;;// draw titles
               ;;        if (this.title) {
               ;;        nonchar=0;
               ;;        for (var i=0; i<this.title.length; i++) {if (this.title.charAt(i)==";") {nonchar++;}}
               ;;        gstr+='<span style="'+this.CSStitlefont+' position:absolute; text-align:center; top: '+0.5*this.pad_top;
               ;;        gstr+='pt; left: '+(0.5*gwt/gxpt-(this.title.length-5.5*nonchar)*title_pt*0.25)+'pt;">'+this.title+'</span>';
               ;;        }
               ;;        if (this.xaxis) {
               ;;        nonchar=0;
               ;;        for (var i=0; i<this.xaxis.length; i++) {if (this.xaxis.charAt(i)==";") {nonchar++;}}
               ;;        gstr+='<span style="'+this.CSSxaxisfont+' position:absolute; text-align:center; top: '+((gymin+0.5*(pad_b-xaxis_pt*gxpt))/gxpt+(xticloc=="bottom" ? 0.75*tic_pt:0));
               ;;        gstr+='pt; left: '+(0.5*gwt/gxpt-(this.xaxis.length-5.5*nonchar)*xaxis_pt*0.25)+'pt;">'+this.xaxis+'</span>';
               ;;        }
               ;;        if (this.yaxis) {
               ;;        gstr+='<v:shape style="'+gstyle;
               ;;        gstr+='" path="M '+((0.25*this.pad_left+0.5*yaxis_pt)*gxpt)+','+gymin+' L '+((0.25*this.pad_left+0.5*yaxis_pt)*gxpt)+','+gymax+'" fillcolor="'+this.VMLyaxisfontcolor+'">';
               ;;        gstr+='<v:stroke on="false" /><v:path textpathok="true" />';
               ;;        gstr+='<v:textpath on="true" style="'+this.CSSyaxisfont+'" string="'+this.yaxis+'" /></v:shape>';
               ;;        }
               ;;
               ;;} // end of draw graph background
               ;;
               ;;// hold on to previous plot
               ;;  if (this.lastplot != "") {
               ;;        gstr=this.lastplot.substring(0,this.lastplot.length-10);
               ;;        gstrtemp=gstr;
               ;;  }
               ;;
               ;;// draw lines
               ;;  for (var n=0; n<lines.length; n++) {
               ;;  if (lines[n].drawline && lines[n].x.length>1) {
               ;;        gstr+='<v:polyline points="';
               ;;        for (i=0; i<lines[n].x.length; i++) {gstr+= Math.round(gxmin+(lines[n].x[i]-xmin)*xscl)+" "+Math.round(gymin-(lines[n].y[i]-ymin)*yscl)+" ";}
               ;;        gstr+='" title="'+lines[n].label+'" ><v:stroke '+lines[n].VMLstroke+' /><v:fill on="false" /></v:polyline>';
               ;;  }}
               ;;
               ;;// draw points
               ;;  for (var n=0; n<lines.length; n++) {
               ;;  if (lines[n].drawpoints && lines[n].x.length>0) {
               ;;        gstr+=this.VMLpointshape(lines[n].VMLpointshapetype);
               ;;        for (i=0; i<lines[n].x.length; i++) {
               ;;         gstr+='<v:shape type="#'+(lines[n].VMLpointshapetype).toLowerCase()+'" style="width:'+lines[n].pointsize*gxpt+'; height:'+lines[n].pointsize*gxpt;
               ;;         gstr+='; top:'+Math.round(gymin-0.5*lines[n].pointsize*gxpt-(lines[n].y[i]-ymin)*yscl)+'; left:'+Math.round(gxmin-0.5*lines[n].pointsize*gxpt+(lines[n].x[i]-xmin)*xscl);
               ;;              ptitle = (lines[n].mouseoverlabels) ? lines[n].labels[i] : lines[n].x[i]+','+lines[n].y[i];
               ;;         gstr+='" title="'+ptitle+'" fillcolor="'+lines[n].pointfillcolor+'"';
               ;;         gstr+=' strokecolor="'+lines[n].pointstrokecolor+'" />';
               ;;        }
               ;;  }}
               ;;
               ;;// draw labels
               ;;  for (var n=0; n<lines.length; n++) {
               ;;  if (lines[n].drawlabels && lines[n].labels.length>0) {
               ;;        for (i=0; i<lines[n].labels.length; i++) {
               ;;         gstr+='<span style="font: '+lines[n].labelsize+'pt '+lines[n].labelfont+'; position:absolute;';
               ;;         gstr+=' top:'+Math.round((gymin-1.5*lines[n].labelsize*gxpt-(lines[n].y[i]-ymin)*yscl)/gxpt)+'pt; left:'+Math.round((gxmin+0.5*lines[n].labelsize*gxpt+(lines[n].x[i]-xmin)*xscl)/gxpt)+'pt; ';
               ;;         gstr+=' color:'+lines[n].labelcolor+'">'+lines[n].labels[i]+'</span>';
               ;;        }
               ;;  }}
               ;;
               ;;if (this.lastplot == "") { // don't redraw graph background if called multiple times
               ;;// draw x-axis labels
               ;;        if (xticloc!="none") {
               ;;        for (var i=0; i<numxtic; i++) {
               ;;           if (xticloc=="top") {
               ;;                 gstr+='<span style="'+GXstyle+' top: '+((gyint-gticsize*1.25)/gxpt-8)+'pt; left: '+((xticmin+i*gxtic-0.5*gticsize)/gxpt)+'pt;">';
               ;;           }
               ;;           else {
               ;;                 gstr+='<span style="'+GXstyle+' top: '+((gyint+gticsize*1.25)/gxpt)+'pt; left: '+((xticmin+i*gxtic-0.5*gticsize)/gxpt)+'pt;">';
               ;;           }
               ;;         gstr+=xticlabels[i]+'</span>';
               ;;        }}
               ;;
               ;;// draw y-axis labels
               ;;        if (yticloc!="none") {
               ;;        for (var i=0; i<numytic; i++) {
               ;;           if (yticloc=="right") {
               ;;                   gstr+='<span style="'+GYstyle+' top: '+((yticmin-i*gytic-gticsize)/gxpt)+'pt; left: '+((gxint+gticsize*1.5)/gxpt)+'pt;">';
               ;;           }
               ;;           else {
               ;;                   gstr+='<span style="'+GYLstyle+' top: '+((yticmin-i*gytic-gticsize)/gxpt)+'pt; left: '+((gxint-gticsize)/gxpt-0.5*(yticcharnum+1)*tic_pt)+'pt;">';
               ;;           }
               ;;           gstr+=yticlabels[i]+'</span>';
               ;;        }}
               ;;} // end of draw graph background
               ;;
               ;;// close and return output
               ;;        gstr+='</v:group>';
               ;;          if (this.numplots > 0) {this.lastplotadded[this.numplots]=gstr.length-gstrtemp.length;}
               ;;        else {this.lastplotadded[0]=gstr.length;}
               ;;        this.numplots++;
               ;;        this.lastplot=gstr;  // save this output in memory
               ;;
               ;;        return gstr;
               ;;
               ;;} // end function
               ;;
               ;;
               ;;
               ;;
               ;;// function to undo last added line, label or arrow from the plot
               ;;
               ;;XYGraph.prototype.DeleteLast = function () {
               ;;        if (this.numplots > 1) {
               ;;         gstr=this.lastplot.substring(0,this.lastplot.length-this.lastplotadded[this.numplots-1]+1);
               ;;         gstr+='</v:group>';
               ;;         this.lastplot=gstr;
               ;;         this.numplots--;
               ;;        }
               ;;        return gstr;
               ;;} // end function
               ;;
               ;;
               ;;
               ;;XYGraph.prototype.Findedge = function (x1,x2,y1,y2,xmax,xmin,ymax,ymin) {
               ;;
               ;;        x=0; y=0;
               ;;    if (!isNaN(x2)) {
               ;;        if (!isFinite(x2)) {
               ;;         switch (x2) {
               ;;                 case Number.POSITIVE_INFINITY: x2 = 999E+9; break;
               ;;                 case Number.NEGATIVE_INFINITY: x2 = -999E+9; break;
               ;;         }
               ;;        }
               ;;        if (!isFinite(y2)) {
               ;;         switch (y2) {
               ;;                 case Number.POSITIVE_INFINITY: y2 = 999E+9; break;
               ;;                 case Number.NEGATIVE_INFINITY: y2 = -999E+9; break;
               ;;         }
               ;;        }
               ;;
               ;;        angle = Math.atan2(y2-y1,x2-x1);
               ;;        angle += (angle > 0 ? 0 : 2*Math.PI);
               ;;
               ;;        slope = (y2-y1)/(x2-x1);
               ;;        Mxx = Math.atan2(ymax-y1,xmax-x1); Mxx += (Mxx > 0 ? 0 : 2*Math.PI);
               ;;        Mnx = Math.atan2(ymax-y1,xmin-x1); Mnx += (Mnx > 0 ? 0 : 2*Math.PI);
               ;;        Mnn = Math.atan2(ymin-y1,xmin-x1); Mnn += (Mnn > 0 ? 0 : 2*Math.PI);
               ;;        Mxn = Math.atan2(ymin-y1,xmax-x1); Mxn += (Mxn > 0 ? 0 : 2*Math.PI);
               ;;
               ;;        switch (true) {
               ;;         case (angle>=Mxx && angle<Mnx) :
               ;;                 y = ymax;
               ;;                 x = (ymax-y1)/slope+x1;
               ;;                 break;
               ;;         case (angle>=Mnx && angle<Mnn) :
               ;;                 x = xmin;
               ;;                 y = (xmin-x1)*slope+y1;
               ;;                 break;
               ;;         case (angle>=Mnn && angle<Mxn) :
               ;;                 y = ymin;
               ;;                 x = (ymin-y1)/slope+x1;
               ;;                 break;
               ;;         case (angle>=Mxn || angle<Mxx) :
               ;;                 x = xmax;
               ;;                 y = (xmax-x1)*slope+y1;
               ;;                 break;
               ;;        }
               ;;     }
               ;;
               ;;        return [x,y];
               ;;} // end function
               ;;
               ;;
               ;;
               ;;// point shapetype definitions, these can be modified and expanded
               ;;
               ;;XYGraph.prototype.VMLpointshape = function (shapename) {
               ;;        switch (shapename.toLowerCase()) {
               ;;
               ;;        case "diamond" :
               ;;         return '<v:shapetype id="diamond" coordsize="500,500" path=" m 250 500 l 500 250 250 0 0 250 x e" />';
               ;;        case "square" :
               ;;         return '<v:shapetype id="square" coordsize="350,350" path=" m 0 0 l 0 350 350 350 350 0 x e" />';
               ;;        case "triangle" :
               ;;         return '<v:shapetype id="triangle" coordsize="400,400" path=" m 200 0 l 400 400 0 400 x e" />';
               ;;        case "circle" :
               ;;         return '<v:shapetype id="circle" coordsize="350,350" path=" m 0 175 l 23 262 88 327 175 350 262 327 327 262 350 175 327 88 262 23 175 0 88 23 23 88 x e" />';
               ;;        case "x" :
               ;;         return '<v:shapetype id="x" coordsize="350,350" path=" m 0 0 l 350 350 e m 0 350 l 350 0 e" />';
               ;;        case "none" :
               ;;         return '<v:shapetype id="none" coordsize="350,350" filled="false" stroked="false" path=" m 0 0 l 0 350 350 350 350 0 x e" />';
               ;;        }
               ;;} // end function
               ;;
               ;;
               ;;
               ;;XYGraph.prototype.Drawarrow = function (arrowdef) {
               ;;
               ;;        gstr=gstr.substring(0,gstr.length-10);
               ;;        gstrtemp=gstr;
               ;;
               ;;        arrowdef.x = Number(arrowdef.x)
               ;;        arrowdef.y = Number(arrowdef.y)
               ;;        arrowdef.rotation = Number(arrowdef.rotation)
               ;;        arrowdef.length = Number(arrowdef.length)
               ;;        arrowdef.size = Number(arrowdef.size)
               ;;
               ;;        xpoint=Math.round(gxmin+(arrowdef.x-xmin)*xscl+0.5*arrowdef.size*gxpt*Math.sin(arrowdef.rotation*Math.PI/180));
               ;;        ypoint=Math.round(gymin-(arrowdef.y-ymin)*yscl-0.5*arrowdef.size*gxpt*Math.cos(arrowdef.rotation*Math.PI/180));
               ;;
               ;;        xpoint2=Math.round(xpoint+arrowdef.length*gxpt*Math.sin(arrowdef.rotation*Math.PI/180));
               ;;        ypoint2=Math.round(ypoint-arrowdef.length*gxpt*Math.cos(arrowdef.rotation*Math.PI/180));
               ;;
               ;;        gstr+='<v:line from="'+xpoint+','+ypoint+'" to="'+xpoint2+','+ypoint2+'" ><v:stroke weight="'+arrowdef.lineweight+'pt"; color="'+arrowdef.color+'"; dashstyle="'+arrowdef.dashstyle+'"; /></v:line>';
               ;;
               ;;        xpoint3=Math.round(xpoint2+1.25*arrowdef.labelsize*gxpt*Math.sin(arrowdef.rotation*Math.PI/180));
               ;;        ypoint3=Math.round(ypoint2-1.25*arrowdef.labelsize*gxpt);
               ;;
               ;;        if(Math.cos(arrowdef.rotation*Math.PI/180)>0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint3/gxpt)+'pt; left: '+Math.round(xpoint3/gxpt-0.25*arrowdef.label.length*arrowdef.labelsize)+'pt; ';}
               ;;        if(Math.cos(arrowdef.rotation*Math.PI/180)<0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint2/gxpt)+'pt; left: '+Math.round(xpoint3/gxpt-0.25*arrowdef.label.length*arrowdef.labelsize)+'pt; ';}
               ;;        if(Math.sin(arrowdef.rotation*Math.PI/180)>0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint2/gxpt-arrowdef.labelsize*(0.5+Math.cos(arrowdef.rotation*Math.PI/180)))+'pt; left: '+Math.round(xpoint3/gxpt-0.25*arrowdef.label.length*arrowdef.labelsize)+'pt; ';}
               ;;        if(Math.sin(arrowdef.rotation*Math.PI/180)<0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint2/gxpt-arrowdef.labelsize*(0.5+Math.cos(arrowdef.rotation*Math.PI/180)))+'pt; left: '+Math.round(xpoint3/gxpt-0.25*arrowdef.label.length*arrowdef.labelsize)+'pt; ';}
               ;;
               ;;        gstr+='<span style="font: '+arrowdef.labelsize+'pt Arial; font-weight:bold; position:absolute;';
               ;;        gstr+=position+'color:'+arrowdef.labelcolor+'">'+arrowdef.label+'</span>';
               ;;
               ;;        xpoint=Math.round(gxmin-0.5*arrowdef.size*gxpt+(arrowdef.x-xmin)*xscl+0.5*arrowdef.size*gxpt*Math.sin(arrowdef.rotation*Math.PI/180));
               ;;        ypoint=Math.round(gymin-0.5*arrowdef.size*gxpt-(arrowdef.y-ymin)*yscl-0.5*arrowdef.size*gxpt*Math.cos(arrowdef.rotation*Math.PI/180));
               ;;
               ;;        gstr+=arrowdef.arrowhead;
               ;;        gstr+='<v:shape type="#arrowhead" style="width:'+arrowdef.size*gxpt+'; height:'+arrowdef.size*gxpt;
               ;;        gstr+='; top:'+ypoint+'; left:'+xpoint;
               ;;        gstr+='" title="'+arrowdef.label+'" fillcolor="'+arrowdef.color+'"';
               ;;        gstr+='"; style= "rotation:'+arrowdef.rotation+'deg"';
               ;;        gstr+=' strokecolor="'+arrowdef.color+'" />';
               ;;
               ;;        gstr+='</v:group>';
               ;;        this.lastplot=gstr;
               ;;        this.lastplotadded[this.numplots]=gstr.length-gstrtemp.length;
               ;;        this.numplots++;
               ;;        return gstr;
               ;;
               ;;} // end function
               ;;
               ;;
               ;;
               ;;XYGraph.prototype.Drawlabel = function (labeldef) {
               ;;
               ;;        gstr=gstr.substring(0,gstr.length-10);
               ;;        gstrtemp=gstr;
               ;;
               ;;        labeldef.x = Number(labeldef.x)
               ;;        labeldef.y = Number(labeldef.y)
               ;;        labeldef.rotation = Number(labeldef.rotation)
               ;;        labeldef.length = Number(labeldef.length)
               ;;
               ;;        xpoint=Math.round(gxmin+(labeldef.x-xmin)*xscl+0.5*labeldef.labelsize*gxpt*Math.sin(labeldef.rotation*Math.PI/180));
               ;;        ypoint=Math.round(gymin-(labeldef.y-ymin)*yscl-0.5*labeldef.labelsize*gxpt*Math.cos(labeldef.rotation*Math.PI/180));
               ;;
               ;;        xpoint2=Math.round(xpoint+labeldef.length*gxpt*Math.sin(labeldef.rotation*Math.PI/180));
               ;;        ypoint2=Math.round(ypoint-labeldef.length*gxpt*Math.cos(labeldef.rotation*Math.PI/180));
               ;;
               ;;        xpoint3=Math.round(xpoint2+1.25*labeldef.labelsize*gxpt*Math.sin(labeldef.rotation*Math.PI/180));
               ;;        ypoint3=Math.round(ypoint2-1.25*labeldef.labelsize*gxpt);
               ;;
               ;;        if(Math.cos(labeldef.rotation*Math.PI/180)>0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint3/gxpt)+'pt; left: '+Math.round(xpoint3/gxpt-0.25*labeldef.label.length*labeldef.labelsize)+'pt; ';}
               ;;        if(Math.cos(labeldef.rotation*Math.PI/180)<0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint2/gxpt)+'pt; left: '+Math.round(xpoint3/gxpt-0.25*labeldef.label.length*labeldef.labelsize)+'pt; ';}
               ;;        if(Math.sin(labeldef.rotation*Math.PI/180)>0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint2/gxpt-labeldef.labelsize*(0.5+Math.cos(labeldef.rotation*Math.PI/180)))+'pt; left: '+Math.round(xpoint3/gxpt-0.25*labeldef.label.length*labeldef.labelsize)+'pt; ';}
               ;;        if(Math.sin(labeldef.rotation*Math.PI/180)<0.707)
               ;;         {position=' text-align:center; top:'+Math.round(ypoint2/gxpt-labeldef.labelsize*(0.5+Math.cos(labeldef.rotation*Math.PI/180)))+'pt; left: '+Math.round(xpoint3/gxpt-0.25*labeldef.label.length*labeldef.labelsize)+'pt; ';}
               ;;
               ;;        gstr+='<span style="font: '+labeldef.labelsize+'pt Arial; font-weight:bold; position:absolute;';
               ;;        gstr+=position+'color:'+labeldef.labelcolor+'">'+labeldef.label+'</span>';
               ;;
               ;;        gstr+=this.VMLpointshape(labeldef.VMLpointshapetype);
               ;;
               ;;        gstr+='<v:shape type="#'+(labeldef.VMLpointshapetype).toLowerCase()+'" style="width:'+labeldef.pointsize*gxpt+'; height:'+labeldef.pointsize*gxpt;
               ;;        gstr+='; top:'+Math.round(gymin-0.5*labeldef.pointsize*gxpt-(labeldef.y-ymin)*yscl,2)+'; left:'+Math.round(gxmin-0.5*labeldef.pointsize*gxpt+(labeldef.x-xmin)*xscl);
               ;;        gstr+='" fillcolor="'+labeldef.pointfillcolor+'"';
               ;;        gstr+=' strokecolor="'+labeldef.pointstrokecolor+'" />';
               ;;
               ;;        gstr+='</v:group>';
               ;;        this.lastplot=gstr;
               ;;        this.lastplotadded[this.numplots]=gstr.length-gstrtemp.length;
               ;;        this.numplots++;
               ;;        return gstr;
               ;;
               ;;} // end function
               ;;</script>
               ;;EOF
               ;"====================================================================
               ;
SCRIPT          ;
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
               ;;function AddLine(PatientValues)  {
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
               ;;    ALine.VMLpointshapetype="circle";
               ;;    ALine.VMLstroke="weight='2pt'; color='"+PointColor+"'; dashstyle='solid';";
               ;;    ALine.drawpoints=true;
               ;;    ALine.pointsize=5;
               ;;    ALine.pointfillcolor=PointColor;
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
               ;;  ALine.VMLstroke="weight='1pt'; color='grey'; dashstyle='solid';";
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
               DO SETITEM^TMGGRC2(.ROOT,"//========= GRAPH SPECIFIC VALUES ======================")
               DO SETITEM^TMGGRC2(.ROOT,"function SetupGraph() {")
               DO SETITEM^TMGGRC2(.ROOT,"  var Title="""_TITLE_""";")
               DO SETITEM^TMGGRC2(.ROOT,"  var XTitle="""_XTITLE_""";")
               DO SETITEM^TMGGRC2(.ROOT,"  var YTitle="""_YTITLE_""";")
               IF GRAPHTYP="WHO-HA-B5"  DO SETITEM^TMGGRC2(.ROOT,"  WHOLine();")
               IF GRAPHTYP="WHO-BA-B5"  DO SETITEM^TMGGRC2(.ROOT,"  WHOLine();")
               DO SETITEM^TMGGRC2(.ROOT,"  MyGraph = AssignGraph(Title,"_XMIN_","_XMAX_",XTitle,"_YMIN_","_YMAX_",YTitle,"_XINC_","_YINC_");")
               DO SETITEM^TMGGRC2(.ROOT,"  return MyGraph")
               DO SETITEM^TMGGRC2(.ROOT,"}")
               DO SETITEM^TMGGRC2(.ROOT,"   ")
               DO SETITEM^TMGGRC2(.ROOT,"function AddGraphDataSource() {")
               DO SETITEM^TMGGRC2(.ROOT,"   var s;")
               DO SETITEM^TMGGRC2(.ROOT,"   s = MyGraph;")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""<P><H6><U>Source of Normative Reference Values</U>:<BR>"";")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+"""_SOURCE_"<BR>"";")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""Accessed on "_ACCESSDT_""";")
               DO SETITEM^TMGGRC2(.ROOT,"   MyGraph=s;")
               DO SETITEM^TMGGRC2(.ROOT,"}")
               DO SETITEM^TMGGRC2(.ROOT,"    ")
               QUIT
                    ;
                    ;
STRTLINE(ROOT)            ;
               ;"Purpose: Start adding Data Set Line(s)
               ;"Input: ROOT -- The root to output to .
               ;"Results: none
               ;"Output: writes out data via SETITEM
               ;
               DO SETITEM^TMGGRC2(.ROOT,"//========= PATIENT SPECIFIC VALUES ======================")
               DO SETITEM^TMGGRC2(.ROOT,"function SetupLines() {")
               DO SETITEM^TMGGRC2(.ROOT,"  var ALine")
               DO SETITEM^TMGGRC2(.ROOT,"  ")
               DO SETITEM^TMGGRC2(.ROOT,"  ALine = AddLine(false)")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  ALine.x = [0,1];")
               DO SETITEM^TMGGRC2(.ROOT,"  ALine.y = [0,0];")
               DO SETITEM^TMGGRC2(.ROOT,"  ALine.labels = ['',''];")
               DO SETITEM^TMGGRC2(.ROOT,"  ")
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
               DO SETITEM^TMGGRC2(.ROOT,"  ALine = AddLine("_$SELECT(REFLINE=1:"false",1:"true")_")")
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
               DO SETITEM^TMGGRC2(.ROOT,SX)
               DO SETITEM^TMGGRC2(.ROOT,SY)
               DO SETITEM^TMGGRC2(.ROOT,SL)
               DO SETITEM^TMGGRC2(.ROOT,"   ")
               QUIT
               ;
ADDWHOL1(ROOT)   ;
               ;"Purpose: Draw Line in WHO Height/Length for Age(Birth to 5 Years) table
               ;"Input: ROOT -- The root to output to .
               ;"Results: none
               ;"Output: writes out table via SETITEM
               ;
               DO SETITEM^TMGGRC2(.ROOT,"//========= WHO LINE FOR HEIGHT FOR AGE ======================")
               DO SETITEM^TMGGRC2(.ROOT,"function WHOLine() {")
               DO SETITEM^TMGGRC2(.ROOT,"  var WHOLine")
               DO SETITEM^TMGGRC2(.ROOT,"  ")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.x = [25,25];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.y = [41,124];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.labels = ['',''];")
               ;
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.x = [18];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.y = [46];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.labels = ['Length'];")
               ;
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.x = [26];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.y = [46];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.labels = ['Height'];")
               DO SETITEM^TMGGRC2(.ROOT,"  }")
               QUIT
               ;
ADDWHOL2(ROOT)   ;
               ;"Purpose: Draw Line in WHO BMI for Age(Birth to 5 Years) to separate Height/Length table
               ;"Input: ROOT -- The root to output to .
               ;"Results: none
               ;"Output: writes out table via SETITEM
               ;
               DO SETITEM^TMGGRC2(.ROOT,"//========= WHO LINE FOR HEIGHT FOR AGE ======================")
               DO SETITEM^TMGGRC2(.ROOT,"function WHOLine() {")
               DO SETITEM^TMGGRC2(.ROOT,"  var WHOLine")
               DO SETITEM^TMGGRC2(.ROOT,"  ")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.x = [25,25];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.y = [10.5,21];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.labels = ['',''];")
               ;
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.x = [18];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.y = [12];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.labels = ['Length'];")
               ;
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine = AddWHOLN()")  ;"For some reason, graph didn't work right without this.
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.x = [26];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.y = [12];")
               DO SETITEM^TMGGRC2(.ROOT,"  WHOLine.labels = ['Height'];")
               DO SETITEM^TMGGRC2(.ROOT,"  }")
               QUIT
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
               DO SETITEM^TMGGRC2(.ROOT,"}")
               DO SETITEM^TMGGRC2(.ROOT,"    ")
               DO SETITEM^TMGGRC2(.ROOT,"function AddTableOfValues() {")
               DO SETITEM^TMGGRC2(.ROOT,"   var s;")
               DO SETITEM^TMGGRC2(.ROOT,"   s = MyGraph;")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""<BR><U>Table of Actual Patient Values</U>:<BR>"";")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""<table border=1>"";")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""<tr>"";")
               IF TTLCOL5="" DO  ;" Don't add column 5 unless
               . DO SETITEM^TMGGRC2(.ROOT,"   s=s+""   <th>Date:</th><th>"_TTLCOL2_":</th><th>"_TTLCOL3_"</th><th>"_TTLCOL4_"</th>"";")
               ELSE  DO
               . DO SETITEM^TMGGRC2(.ROOT,"   s=s+""   <th>Date:</th><th>"_TTLCOL4_":</th><th>"_TTLCOL2_"</th><th>"_TTLCOL3_"</th><th>"_TTLCOL5_"</th>"";")
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""</tr>"";")
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
               . DO SETITEM^TMGGRC2(.ROOT,"   s=s+""<tr align=center>"";")
               . IF TTLCOL5="" DO
               . . IF ROUND'=-1 SET X=$JUSTIFY(X,0,ROUND)
               . . DO SETITEM^TMGGRC2(.ROOT,"   s=s+""   <td>"_DATE_"</td><td>"_X_"</td><td>"_Y_"</td><td>"_TILE_"</td>"";")
               . ELSE  DO
               . . SET AGE=$JUSTIFY($PIECE(DATA,"^",5),0,0)
               . . DO SETITEM^TMGGRC2(.ROOT,"   s=s+""   <td>"_DATE_"</td><td>"_AGE_"</td><td>"_X_"</td><td>"_Y_"</td><td>"_TILE_"</td>"";")
               . DO SETITEM^TMGGRC2(.ROOT,"   s=s+""</tr>"";")
               ;
               ;
               DO SETITEM^TMGGRC2(.ROOT,"   s=s+""</table>"";")
               DO SETITEM^TMGGRC2(.ROOT,"   MyGraph=s;")
               QUIT
               ;
ENDLINES(ROOT)            ;
               ;"Purpose: End adding Data Set Line(s)
               ;"Input: ROOT -- The root to output to .
               ;"Results: none
               ;"Output: writes out data via SETITEM
               ;
               DO SETITEM^TMGGRC2(.ROOT,"}")
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
