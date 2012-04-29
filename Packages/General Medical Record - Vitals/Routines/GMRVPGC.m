GMRVPGC ;DBA/CJS - Pediatric Growth Chart HTML generator ;8/29/07  09:08
 ;;5.0;GEN. MED. REC. - VITALS;**[patch list]**;Oct 31, 2002;Build 11
 ;
EN(DFN) ;
 N BMI,DIC,DIV,IO,LABEL,LINE,MAXAGE,NAME,NONE,POP,REF,ROOT,SERVER,SEX,STYLE,TMP,TYPE,VAL,VDT,XPARSYS,XQDIC,XQPSM,XQVOL,XVALS,YVALS
 S SERVER=$$GET^XPAR("SYS","GMRV PED GROWTH CHART SERVER")
 S ROOT=$$GET^XPAR("SYS","GMRV PED GROWTH CHART FOLDER")
 ;
 S D=^DPT(DFN,0),NAME=$P(D,U),SEX=$P(D,U,2),SEX=$S(SEX="M":1,SEX="F":2,1:0),DOB=$P(D,U,3),DOD=$P($G(^DPT(DFN,.35)),U),PID=$P($G(^DPT(DFN,.36)),U,3)
 S Y=DOB D DD^%DT S BIRTH=Y,MAXAGE=$$MNTHSOLD($S(DOD="":DT,DOD'="":DOD),DOB)
 ;
 ; See if there are any pediatric vitals to be had
 ; ^GMR(120.5,"AA",GMRVDFN,GMRVTYP,9999999-GMRVDT,DA)=""  "rate" on 0 node piece 8
 ; types:  8 = Height,  9 - Weight,  20 = Circumference/Girth,  73 - Head qualifier
 S NONE=1 F TYPE=8,9,20 D
 . S XVALS(TYPE)="",YVALS(TYPE)=""
 . S VDT=0 F  S VDT=$O(^GMR(120.5,"AA",DFN,TYPE,VDT)) Q:VDT'>0  D
 . . S DA=+$O(^GMR(120.5,"AA",DFN,TYPE,VDT,0))
 . . I TYPE=20 Q:'$D(^GMR(120.5,DA,5,"B",73))  ; Quit if not "HEAD"
 . . Q:+$G(^GMR(120.5,DA,2))  ; Quit if Entered in Error
 . . S AGE=$$MNTHSOLD(9999999-VDT,DOB),NONE=0
 . . S XVALS(TYPE)=XVALS(TYPE)_","_AGE
 . . S VAL=$P(^GMR(120.5,DA,0),U,8),VAL=$S("8,20"[TYPE:VAL*2.54,TYPE=9:VAL/2.2),VAL=$$ROUND(VAL)
 . . I TYPE=8!(TYPE=9) S BMI(AGE,TYPE)=VAL
 . . S YVALS(TYPE)=YVALS(TYPE)_","_VAL
 . . Q
 . Q
 ;
 ; BMI=WEIGHT/(HEIGHT**2) Weight in Kg, Height in cm
 S AGE="",XVALS("BMI")="",YVALS("BMI")="",XVALS("WTHT")="",YVALS("WTHT")=""
 F  S AGE=$O(BMI(AGE)) Q:AGE'>0  I $D(BMI(AGE,8)),$D(BMI(AGE,9)) D
 . S DIV=BMI(AGE,9)**2
 . S:DIV'=0 XVALS("BMI")=XVALS("BMI")_","_AGE,YVALS("BMI")=YVALS("BMI")_","_$$ROUND(10000*BMI(AGE,9)/DIV)
 . S XVALS("WTHT")=XVALS("WTHT")_","_BMI(AGE,8),YVALS("WTHT")=YVALS("WTHT")_","_BMI(AGE,9)
 . Q
 ;
 ; Establish HTML doctype & head
 S LINE=0 F  S LINE=LINE+1,TMP(LINE)=$P($T(HEAD+LINE),";",3) Q:TMP(LINE)=""
 ;
 ; Set up the href links
 S TMP(LINE)="<P>"_NAME_"</P><P>DOB:  "_BIRTH_"</P>",LINE=LINE+1
 S REF="<P><a href="""
 S LABEL(0)=$S(SEX=1:"Male",1:"Female")_" Age in months vs. Weight kg.</a></P>"
 S LABEL(1)=$S(SEX=1:"Male",1:"Female")_" Age in months vs. Height cm. 0-36 months</a></P>"
 S LABEL(2)=$S(SEX=1:"Male",1:"Female")_" Age in months vs Head Circumference in cm. 0-36 months</a></p>"
 S LABEL(4)=$S(SEX=1:"Male",1:"Female")_" Age in months vs. Height cm. over 36 months</a></P>"
 S LABEL(5)=$S(SEX=1:"Male",1:"Female")_" Body Mass Index-for age</a></P>"
 S LABEL(6)=$S(SEX=1:"Male",1:"Female")_" Weight vs Stature</a></P>"
 S LABEL(7)=$S(SEX=1:"Male",1:"Female")_" Weight vs Length</a></P>"
 F STYLE=0,1,2,4,5,6,7 S TYPE=$$TYPE(STYLE) D:$L(XVALS(TYPE))
 . Q:("456"[STYLE)&(MAXAGE<36)
 . S TMP(LINE)=REF_SERVER_"?style="_$$STRING(STYLE)_"&sex="_SEX_"&maxage="_$$AGE(MAXAGE,STYLE)_"&xvals="_$P(XVALS(TYPE),",",2,99)_"&yvals="_$P(YVALS(TYPE),",",2,99)_""">"_LABEL(STYLE)
 . S LINE=LINE+1
 . Q
 ;
 S:NONE TMP(LINE)="<P>THERE ARE NO GROWTH VITALS TO PLOT.</P>",LINE=LINE+1
 ; last of the labels
 S TMP(LINE)="<P>Note: should any xvals or yvals value be inappropriate, or there be an unequal number of values in both lists,",LINE=LINE+1
 S TMP(LINE)="the patient plot will be ignored, and a ""blank"" growth chart with percentile values only will be shown.</P>",LINE=LINE+1
 S TMP(LINE)="</body>"
 S TMP(LINE+1)="</html>"
 ;
 ; Write out the file
 D OPEN^%ZISH("OUTFILE",ROOT,DFN_".html","W") S:POP GMRVPGC="ERROR"
 Q:POP
 U IO
 S LINE=0 F  S LINE=$O(TMP(LINE)) Q:LINE'>0  W TMP(LINE),!
 D CLOSE^%ZISH("OUTFILE")
 Q
 ;
 ; convert age to months
MNTHSOLD(DATE,DOB) ;
 S X1=DATE,X2=DOB D ^%DTC S X=X/30.42,X=$$ROUND(X)
 Q X
 ;
ROUND(X) ;
 Q $P(X,".")_"."_$E($P(X,".",2),1,2)
 ;
TYPE(STYLE) ;
 Q $S(STYLE=0:9,STYLE=1:8,STYLE=2:20,STYLE=4:8,STYLE=5:"BMI",1:"WTHT")
 ;
AGE(MAXAGE,STYLE) ;
 I MAXAGE<36 Q MAXAGE
 I "0456"[STYLE Q MAXAGE
 Q 36
 ;
STRING(STYLE) ;
 I STYLE=0 Q "weight-age"
 I STYLE=1 Q "length-age"
 I STYLE=2 Q "head-age"
 I STYLE=4 Q "stature-age"
 I STYLE=5 Q "bmi-age"
 I STYLE=6 Q "weight-stature"
 I STYLE=7 Q "weight-length"
 Q 0 ;oops!
 ;
HEAD ;;
 ;;<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 ;; "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 ;;<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
 ;;<head>
 ;; <title>Growth Chart Example</title>
 ;; <meta http-equiv="Content-Type" CONTENT="text/html; charset=UTF-8">
 ;; <meta http-equiv="Expires" CONTENT="0">
 ;; <meta http-equiv="Cache-Control" CONTENT="no-cache">
 ;; <meta http-equiv="PRAGMA" CONTENT="NO-CACHE">
 ;;</head>
 ;;<body>
 ;;Click on any one of the following to display the available growth charts for your patient.  Use the back button to return to the main page.
 ;;
