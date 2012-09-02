TMGGRC3D              ;TMG/kst-Growth Chart Javascript code ;7/17/12
                      ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
              ;
              ;"NOTE: JavaScript code below is a continuation of code from TMGGRC3C
GLIB      ;
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
              ;;CONTINUED
              ;"NOTE: JavaScript code continues in TMGCRG3E
