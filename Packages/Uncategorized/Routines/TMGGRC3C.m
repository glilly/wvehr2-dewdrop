TMGGRC3C             ;TMG/kst-Growth Chart Javascript code ;7/17/12
                      ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
          ;
          ;"NOTE: JavaScript code below is a continuation of code from TMGGRC3B
GLIB      ;   
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
              ;;CONTINUED
              ;"NOTE: JavaScript code continues in TMGCRG3D
