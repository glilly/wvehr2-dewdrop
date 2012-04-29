GMRAHDR ;SLC/DAN - HDR calls for ART ;5/12/06  08:04
 ;;4.0;Adverse Reaction Tracking;**18,24,26**;Mar 29, 1996;Build 4
 ;
 ;The variable GMRADONT can be set before making a call to this
 ;routine if you'd like to be able to change data but not have it
 ;sent to the HDR.  If GMRADONT has a positive value then nothing
 ;will be queued to be sent to the HDR.
 ;A check will also be made for the existence of VAFCA08 to indicate
 ;whether a patient merge is taking place.  If so, then data isn't
 ;sent to the HDR.
 ;
SETADR ;Call here when updating data
 N IEN,OIEN
 I $G(GMRADONT)!($G(XDRDVALF)=1) Q  ;Don't send HDR information if variable is set
 S IEN=$S($D(DA)=1:DA,1:DA($O(DA("?"),-1)))
 I +$P($G(^GMR(120.8,IEN,0)),U,12)=0 Q  ;Stop if it isn't signed off yet
 I $$TESTPAT^VADPT($P(^GMR(120.8,IEN,0),U)) Q  ;24 Don't send data for test patients
 D TASK("ADR",IEN),UPDRDI ;26 Schedule entry to be sent to HDR, note new data for RDI
 I $P($G(^GMR(120.8,IEN,0)),U,6)="o" S OIEN=+$O(^GMR(120.85,"C",IEN,0)) I $D(^GMR(120.85,OIEN,0)),'+$G(^GMR(120.8,IEN,"ER")) D TASK("OBS",OIEN) ;If observed reaction, send observed data on sign off
 Q
 ;
KILLADR ;Call here when data is deleted
 N IEN
 I $G(GMRADONT)!($G(XDRDVALF)=1) Q  ;Don't send data to HDR if variable is set
 S IEN=$S($D(DA)=1:DA,1:DA($O(DA("?"),-1)))
 I $P($G(^GMR(120.8,IEN,0)),U,12)=0 Q  ;Stop if it isn't signed off yet
 I $$TESTPAT^VADPT($P(^GMR(120.8,IEN,0),U)) Q  ;24 Don't send data for test patients
 D TASK("ADR",IEN),UPDRDI ;26 Schedule entry to be sent to the HDR, note new data for RDI
 Q
 ;
SETAA ;Action taken when assessment is changed
 I $G(GMRADONT)!($G(XDRDVALF)=1) Q  ;Don't send data if variable is set
 I $$TESTPAT^VADPT(DA) Q  ;24 Don't send data for test patients
 D TASK("ASMT",DA)
 Q
 ;
KILLAA ;Action taken when value is deleted
 I $G(GMRADONT)!($G(XDRDVALF)=1) Q  ;Don't send data to HDR if variable is set
 I $$TESTPAT^VADPT(DA) Q  ;24 Don't send data for test patients
 D TASK("ASMT",DA)
 Q
 ;
SETOB ;Make call to HDR when observation data is added or edited
 N IEN,AIEN
 I $G(GMRADONT)!($G(XDRDVALF)=1) Q  ;Don't send data to HDR if variable is set
 S IEN=$S($D(DA)=1:DA,1:DA($O(DA("?"),-1)))
 S AIEN=+$P($G(^GMR(120.85,IEN,0)),U,15) Q:'+AIEN  ;Stop if there's no related reaction
 I $P($G(^GMR(120.8,AIEN,0)),U,12)=0 Q  ;Stop if related reaction not signed off
 I $$TESTPAT^VADPT($P(^GMR(120.8,AIEN,0),U)) Q  ;24 Don't send data for test patients
 D TASK("OBS",IEN)
 Q
 ;
KILLOB ;Action upon deletion of observation data
 N IEN,AIEN
 I $G(GMRADONT)!($G(XDRDVALF)=1) Q  ;Don't send data to HDR if variable is set
 S IEN=$S($D(DA)=1:DA,1:DA($O(DA("?"),-1)))
 S AIEN=+$P($G(^GMR(120.85,IEN,0)),U,15) Q:'AIEN  ;Quit if there's no related reaction
 I +$P($G(^GMR(120.8,AIEN,0)),U,12)=0 Q  ;Quit if related reaction not signed off
 I $$TESTPAT^VADPT($P(^GMR(120.8,AIEN,0),U)) Q  ;24 Don't send data for test patients
 D TASK("OBS",IEN)
 Q
 ;
TASK(TYPE,IEN) ;Create task, if needed, and add entry to list of items to be sent to HDR
 N ZTRTN,ZTDESC,ZTDTH,ZTSK,ZTIO
 L +^XTMP("GMRAHDR") ;Control global so no new entries are added
 I '$D(^XTMP("GMRAHDR")) S ^XTMP("GMRAHDR",0)=$$FMADD^XLFDT(DT,30)_U_$$NOW^XLFDT_U_"Send allergy data to HDR"
 I '$D(^XTMP("GMRAHDR","TASK")) D
 .S ZTRTN="DQ^GMRAHDR",ZTDESC="Transmit allergy data to HDR",ZTDTH=$$HADD^XLFDT($H,,,2),ZTIO="" D ^%ZTLOAD S ^XTMP("GMRAHDR","TASK")=ZTSK
 S ^XTMP("GMRAHDR",TYPE,IEN)="" ;Store off entry to be sent later
 L -^XTMP("GMRAHDR") ;Release lock
 Q
 ;
DQ ;Send data to HDR
 N TYPE,IEN,A
 L +^XTMP("GMRAHDR") ;Get control of global
 F TYPE="ADR","ASMT","OBS" I $D(^XTMP("GMRAHDR",TYPE)) D
 .S IEN=0 F  S IEN=$O(^XTMP("GMRAHDR",TYPE,IEN)) Q:'+IEN  I $L($T(QUEUE^VDEFQM)) S A=$$QUEUE^VDEFQM("ORU^R01","SUBTYPE="_$S(TYPE="ADR":"ALGY",TYPE="ASMT":"ADAS",1:"ADRA")_"^IEN="_IEN,.GMRAERR)
 K ^XTMP("GMRAHDR")
 L -^XTMP("GMRAHDR")
 Q
 ;
UPDRDI ;Create flag to let RDI know that patient data has changed
 N PIEN,ERR
 S PIEN=$P($G(^GMR(120.8,IEN,0)),U) Q:'+PIEN  ;Quit if no patient IEN
 I '$D(^XTMP("GMRAOC",PIEN)) Q  ;If no current patient data then no need to set flag
 L +^XTMP("GMRAOC",PIEN)
 S ERR=+$G(^GMR(120.8,IEN,"ER"))
 S ^XTMP("GMRAOC",PIEN,$S('ERR:"NEW",1:"ERROR"))=""
 L -^XTMP("GMRAOC",PIEN)
 Q
