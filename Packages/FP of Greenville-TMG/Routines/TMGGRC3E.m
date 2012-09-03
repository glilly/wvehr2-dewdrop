TMGGRC3E              ;TMG/kst-Growth Chart Javascript code ;7/17/12
                      ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
              ;
              ;"NOTE: JavaScript code below is a continuation of code from TMGGRC3C
GLIB      ;
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
