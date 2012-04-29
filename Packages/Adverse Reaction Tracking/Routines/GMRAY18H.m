GMRAY18H ;SLC/DAN-CREATE NEW-STYLE XREF ;9/15/04  10:20
 ;;4.0;Adverse Reaction Tracking;**18**;Mar 29, 1996
 ;
 N GMRAXR,GMRARES,GMRAOUT
 S GMRAXR("FILE")=120.86
 S GMRAXR("NAME")="AHDR"
 S GMRAXR("TYPE")="MU"
 S GMRAXR("USE")="A"
 S GMRAXR("EXECUTION")="R"
 S GMRAXR("ACTIVITY")=""
 S GMRAXR("SHORT DESCR")="Sends updates to the patient's assessment to the HDR"
 S GMRAXR("DESCR",1)="Whenever a patient's assessment level changes, that updated"
 S GMRAXR("DESCR",2)="information is sent to the HDR in real time."
 S GMRAXR("SET")="Q:$D(DIU(0))  D SETAA^GMRAHDR"
 S GMRAXR("KILL")="Q:$D(DIU(0))  D KILLAA^GMRAHDR"
 S GMRAXR("WHOLE KILL")="Q"
 S GMRAXR("VAL",1)=.01
 S GMRAXR("VAL",1,"COLLATION")="F"
 S GMRAXR("VAL",2)=1
 S GMRAXR("VAL",2,"COLLATION")="F"
 S GMRAXR("VAL",3)=2
 S GMRAXR("VAL",3,"COLLATION")="F"
 S GMRAXR("VAL",4)=3
 S GMRAXR("VAL",4,"COLLATION")="F"
 D CREIXN^DDMOD(.GMRAXR,"k",.GMRARES,"GMRAOUT")
 Q
