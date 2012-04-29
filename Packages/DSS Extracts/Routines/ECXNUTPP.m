ECXNUTPP ;ALB/JRC - Nut Production Worksheet Print ; 11/2/06 8:41am
 ;;3.0;DSS EXTRACTS;**92**;Dec 22, 1997;Build 30
 ;
EN ;entry point from option
 ;Queue Report
 N ZTDESC,ZTIO,ZTSAVE
 S ZTIO=""
 S ZTDESC="Nutrition Division Worksheet for DSS"
 D EN^XUTMDEVQ("EN1^ECXNUTPP",ZTDESC,.ZTSAVE)
 Q
EN1 ;Tasked entry point
 ;Declare variables
 N STOP,PAGE,TDIET,TTDIET,LTYPE,LN
 S (STOP,PAGE,LTYPE)=0,(TDIET)=""
 K ^TMP($J)
 F  S TDIET=$O(^ECX(728.45,"B",TDIET)) Q:TDIET=""!STOP  D
 .S IEN=0,IEN=$O(^ECX(728.45,"B",TDIET,IEN))
 .S TTDIET=$$GET1^DIQ(728.45,IEN,.01)
 .D HEADER I STOP D EXIT Q
 .D GETDATA I STOP D EXIT Q
 .I '$O(^TMP($J,"ECX",0)) D  Q
 ..W !
 ..W !,"***********************************************************"
 ..W !,"*  NOTHING TO REPORT FOR "_TTDIET_" CATEGORY",?58,"*"
 ..W !,"***********************************************************"
 ..D WAIT
 .D DETAIL I STOP D EXIT Q
 .D FOOTER I STOP D EXIT Q
 .D WAIT I STOP D EXIT Q
 .K ^TMP($J,"ECX")
EXIT K ^TMP($J,"ECX")
 Q
GETDATA ;Get data
 ;Init variables
 N IEN,DIET,EDIET,DIEN,IENS,PRODUCT
 S (IEN,DIET,EDIET,DIEN,IENS,PRODUCT)=""
 F  S IEN=$O(^ECX(728.45,"B",TDIET,IEN)) Q:'IEN  F  S DIET=$O(^ECX(728.45,IEN,1,"B",DIET)) Q:DIET=""  F  S DIEN=$O(^ECX(728.45,IEN,1,"B",DIET,DIEN)) Q:'DIEN   D
 .S IENS=""_DIEN_","_IEN_","_""
 .S PRODUCT=$$GET1^DIQ(728.451,IENS,1,"E")
 .S EDIET=$$GET1^DIQ(728.451,IENS,.01,"E")
 .S ^TMP($J,"ECX",IEN)=""
 .S ^TMP($J,"ECX",IEN,DIEN)=EDIET_U_PRODUCT
 Q
HEADER ;print header
 S PAGE=$G(PAGE)+1
 S $P(LN,"=",15)=""
 W @IOF
 W ?1,"RUN DATE: ",$$FMTE^XLFDT(DT,"5H"),?70,"PAGE ",PAGE
 W !,?23,"NUTRITION PRODUCT WORKSHEET"
 W !!,?27,TTDIET
 W !!,?1,$P(TTDIET," ",1),?36,"ASSIGNED"
 W !,?1,$P(TTDIET," ",2),?36,"PRODUCT"
 W !,?1,LN,?36,LN
 Q
 ;
DETAIL ;Print detailed line
 ;Input  :  ^TMP("ECXDSS",$J) full global reference
 ;                    DIET - File 116.2, 118, 118.2, 118.3, NAME
 ;                    PRODUCT - Assigned DSS product
 ;Output  : None
 ;
 N NUMBER,RECORD,NODE
 S (NUMBER,RECORD)=0,NODE=""
 F  S NUMBER=$O(^TMP($J,"ECX",NUMBER)) Q:'NUMBER!STOP  D
 .F  S RECORD=$O(^TMP($J,"ECX",NUMBER,RECORD)) Q:'RECORD!STOP  D
 ..S NODE=$G(^TMP($J,"ECX",NUMBER,RECORD))
 ..W !,?1,$P(NODE,U),?36,$P(NODE,U,2)
 ..I $Y>(IOSL-5) D WAIT Q:STOP  D HEADER
 .Q
 Q
 ;
WAIT ;End of page logic
 ;Input   ; None
 ;Output  ; STOP - Flag indicating if printing should continue
 ;                 1 = Stop     0 = Continue
 ;
 S STOP=0
 ;CRT - Prompt for continue
 I $E(IOST,1,2)="C-"&(IOSL'>24) D  Q
 .F  Q:$Y>(IOSL-3)  W !
 .N DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 .S DIR(0)="E"
 .D ^DIR
 .S STOP=$S(Y'=1:1,1:0)
 ;Background task - check taskman
 S STOP=$$S^%ZTLOAD()
 I STOP D
 .W !,"*********************************************"
 .W !,"*  PRINTING OF REPORT STOPPED AS REQUESTED  *"
 .W !,"*********************************************"
 Q
 ;
FOOTER ;Print footer
 N SCREEN
 S SCREEN=$E($P(TTDIET," ",1),1,1)_$E($P(TTDIET," ",2),1,1)
 D FHEADER
 D DSSPRO
 Q
 ;
FHEADER ;Footer header
 W !!!,?1,"DSS PRODUCTS",!,?1,LN
 Q
 ;
DSSPRO ;DSS standardized products
 N OFF,TEXT,DSSCAT,DSSPRO
 F OFF=1:1 S TEXT=$P($T(PRODUCTS+OFF),";;",2) Q:TEXT="END"!STOP  D
 .S DSSCAT=$P(TEXT,U),DSSPRO=$P(TEXT,U,2)
 .Q:DSSCAT'=SCREEN
 .W !,?1,DSSPRO
 .I $Y>(IOSL-5) D WAIT Q:STOP  D HEADER,FHEADER
 Q
 ;
PRODUCTS ;Standardized assigned products for nutrition diets
 ;;PD^REGULAR
 ;;PD^FULL LIQS
 ;;PD^CLEAR LIQS
 ;;PD^PUREE DYSPH
 ;;SF^SUPP FEED
 ;;SF^SUPP FEED NC
 ;;TF^TF LESS 1
 ;;TF^TF MORE 1
 ;;TF^TF MIX LESS 1
 ;;TF^TF MIX MORE 1
 ;;SO^ST ORDER
 ;;SO^ST ORDER NC
 ;;END
