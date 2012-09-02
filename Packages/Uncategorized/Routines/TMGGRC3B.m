TMGGRC3B              ;TMG/kst-Growth Chart Javascript code ;7/17/12
                      ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
          ;
          ;"NOTE: JavaScript code below is a continuation of code from TMGGRC3A
GLIB      ;
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
              ;;                 lines[(lines.length-1)].mouseoverlabels = lines[n].mouseoverlabels;
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
              ;;CONTINUED
              ;"NOTE: JavaScript code continues in TMGCRG3C
