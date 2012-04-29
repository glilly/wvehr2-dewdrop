VEPER7EX ;RSL/DAOU; HL7 EXTRACT FROM FILE; 05/20/2005  10:24 ; 8/23/05 11:29am
 ;;1.0;VISTA EHR DOQ IT HL7 extraction using Clinical Reminders; 05/20/05 ;;Build 1
 ;This is the beginning of the extraction from the extract file
 ;
 ;VARIABLE LIST
 Q
EXTRACT(VBDT,VEDT,PXRMLIST) ;
 N FHSC,BHSC,MSHC,RXAC,HL7DIR,HL7FN,DFN,NPID,PCID,PROD,SF,VID,BDT,EDT
 N CONFIG,HL7DIR,HL7FN,TOPTYP,TOPIND,INST,FNMID,TTIEN,TODAY,DFNSQ
 S (FHSC,BHSC,MSHC,RXAC,ORCC)=0 ;Initialize counts
 ;
 ;****  Switch from Test to Production  ****
 S PROD=0
 ;******************************************
 ;
 S CFGIEN="1,"
 K CONFIG D GETS^DIQ(19904.5,CFGIEN,"**","","CONFIG")
 S INSTIEN=DUZ(2)_","
 K INST D GETS^DIQ(4,INSTIEN,"**","","INST")
 ; ---- ** Need to build and fetch area for Client Start date and end date
 S CLSTDT=""
 S CLENDDT=""
 S %DT="T",X="N" D ^%DT S TODAY=$P(Y,".")
 S BDT=$S(VBDT:VBDT,1:0),EDT=$S(VEDT:VEDT,1:TODAY)
 S HL7DIR=CONFIG(19904.5,CFGIEN,1) ;Directory from Configuration where to place the HL7 files
 S SF=INST(4,INSTIEN,.01) ;Sending Facility Name
 S FNMID=INST(4,INSTIEN,52)
 I HL7DIR="" D  Q
 . W "HL7 directory is not defined.  Quiting.",!!
 . W "Please enter HL7 send directory into configuration."
 S %DT="T",X="N" D ^%DT
 N DTZ S DTZ=$$FMTHL7^XLFDT(Y),DTZ=$P(DTZ,"-")
 S HL7FN="DOQITHL7_"_DTZ_".DAT"
 W !!,"HL7 DOQ IT file name for transmission will be:",!
 W HL7DIR_HL7FN,!!
 W "Status messages will be sent to Mail Group: ",CONFIG(19904.5,"1,",2),!!
 S ZTER="OPENERR",POP=0
 D OPEN^%ZISH("",HL7DIR,HL7FN,"W") Q:POP
 U IO
 ;-Verify Values
 S TOPTYP=$S(ID[" CAD ":"CAD",ID[" HTN ":"HTN",ID[" DM ":"DM",ID[" HF ":"HF",1:"PC"),TTIEN=$O(^DOQIT(19904.6,"B",TOPTYP,""))_","
 K TDATA D GETS^DIQ(19904.6,TTIEN,"**","","TDATA")
 S DFNSQ=0 F  S DFNSQ=$O(^PXRMXP(810.5,PXRMLIST,30,DFNSQ)) Q:DFNSQ=""!(DFNSQ'?.N)  S DFN=$P(^(DFNSQ,0),"^"),X=$$PTPROCES(DFN) I X D
 . I X=1 W !,"ERROR:  Patient DFN # is not in file #2 for IEN #",IEN,"." Q
 ;
 I BHSC D BTS^VEPER7SG(MSHC)
 I FHSC D FTS^VEPER7SG(BHSC)
 ;End of EXTRACT  *********
 D CLOSE^%ZISH("")
 K ^TMP("VEPER7EX",$J)
 Q
 ;
PTPROCES(DFN) ;Process Patient information out to DOQ IT HL7 file.
 ;
 ; DFN - Patient Identification Number for link to DPT file #2.
 ;
 N IDXSQ,VEPER7PT,TOPIND,TTP,ALERGY,ORC,ENEFFDT,ENCLSDT,DTTM
 I '$D(^DPT(DFN)) Q 1 ;DFN is not on file in #2.
 ;
 ;
 K VEPER7PT S DFN=DFN_"," D GETS^DIQ(2,DFN,"**","","VEPER7PT")
 D GETS^DIQ(2,DFN,.03,"I","VEPER7PT")
 K DOQREG D GETS^DIQ(19904.4,DFN,"**","","DOQREG")
 S ALERGY=0
 S ENEFFDT=$$DTCALC^VEPER7SG("","")
 S ENCLSDT=""
 ;
 ;-----  Follow links to fetch Institution Name & Info
 ;
 ;K MCDIVA,INSTLNK,INST
 ;S X=$O(VEPER7PT(2.101,"")),X=X_","
 ;K MCDIVA D GETS^DIQ(2.101,X,"3","I","MCDIVA")
 ;S MCDIV=MCDIVA(2.101,X,3,"I")_","
 ;K INSTLNK D GETS^DIQ(40.8,MCDIV,".07","I","INSTLNK")
 ;S INSTNO=INSTLNK(40.8,MCDIV,.07,"I")
 ;K INST D GETS^DIQ(4,INSTNO,"**","","INST")
 ;
 ;------ End of Institution links for data  -------
 ;
 ;-------- Follow links for Primary Physician Info  --------
 ;
 S X=$O(VEPER7EX(2.312,""))
 K PPIEN I X'="" D
 . D GETS^DIQ(2.312,X,"4.01","I","PPIEN")
 . S PPIEN=$G(PPIEN(2.312,X,4.01,"I"))_","
 . K PRIPHN D GETS^DIQ(200,PPIEN,53.2,"","PRIPHN")
 I X="" S PPIEN=","
 K PRIPHN S PRIPHN(200,PPIEN,53.2)="" I PPIEN'="," D GETS^DIQ(200,PPIEN,"**","","PRIPHN")
 ;
 ;---------  End of Primary Physician Info Link  -------
 ;
 ;S TOPI=TTIEN F  S TOPI=$O(TDATA(19904.62,TOPI)) Q:TOPI=""  S TOPIND=$P(TOPI,",") D
 S TOPI=1 F  S TOPI=$O(TDATA(19904.62,TOPI)) Q:TOPI=""  I $P(TOPI,",",2)=$P(TTIEN,",") D
 .S TOPIND=$P(TOPI,",")
 .S TTP=TOPIND-2*2+1
 .I TTP>0 S FLD=$S(TOPTYP="CAD":.2,TOPTYP="DM":.3,TOPTYP="HTN":.4,TOPTYP="HF":.5,1:.6)_(TOPIND-1)
 .I TTP<0 S FLD=$S(TOPTYP="CAD":.02,TOPTYP="DM":.03,TOPTYP="HTN":.04,TOPTYP="HF":.05,1:.06)
 .I DOQREG(19904.4,DFN,FLD)?1"C".E,DOQREG(19904.4,DFN,FLD_1)="" D  Q
 ..D CANCEL^VEPER7SB
 ..N UPDTREG,ERR
 ..K UPDTREG S UPDTREG(19904.4,DFN,FLD_1)=TODAY
 ..D FILE^DIE("","UPDTREG","ERR")
 ..K UPDTREG,ERR
 .I DOQREG(19904.4,DFN,FLD)'?1"R".E Q  ;If patient not registered then stop processing
 .I DOQREG(19904.4,DFN,FLD_1)="" D
 ..D REGISTER^VEPER7SB
 ..N UPDTREG,ERR
 ..K UPDTREG S UPDTREG(19904.4,DFN,FLD_1)=TODAY
 ..D FILE^DIE("","UPDTREG","ERR")
 ..K UPDTREG,ERR
 .;
 .;--- Fetch visit records for patient to process ---
 .;
 .D VISIT^VEPEREX($E(DFN,1,$L(DFN)-1),20,BDT,EDT,.NFOUND,.TEST,.DATE,.DATA,.TEXT)
 .S VSTNO="" F  S VSTNO=$O(DATA(VSTNO)) Q:VSTNO=""  S VSTIEN=DATA(VSTNO)_"," D
 ..I $D(^TMP("VEPER7EX",$J,"V",DFN,VSTNO)) Q  ;Don't process 2ce
 ..K VISIT D GETS^DIQ(9000010,VSTIEN,.01,"I","VISIT")
 ..D PTVISIT^VEPER7SB
 ..S ^TMP("VEPER7EX",$J,"V",DFN,VSTNO)=""
 .S BVDATE=9999998-EDT,EVDATE=9999999-BDT
 .S VAX="" F  S VAX=$O(^AUPNVIMM("AA",DFN,VAX)) Q:VAX=""  D
 ..S BVDATE=$O(^AUPNVIMM("AA",DFN,VAX,BVDATE)) Q:BVDATE=""!(BVDATE>EVDATE)  D
 ...S VIMMIEN="" F  S VIMMEIN=$O(^AUPNVIMM("AA",DFN,VAX,BVDATE,VIMMIEN)) Q:VIMMEIN=""  D
 ....I $D(^TMP("VEPER7EX",$J,DFN,VAX,BVDATE,VIMMIEN)) Q  ;Don't process a 2nd time
 ....K VIMM D GETS^DIQ(9000010.11,VIMMIEN_",","**","","VIMM")
 ....D GETS^DIQ(9000010.11,VIMMIEN_",",1201,"I","VIMM")
 ....D VAXMSG^VEPER7SB
 ....S ^TMP("VEPER7EX",$J,DFN,VAX,BVDATE,VIMMIEN)=""
 ....K VIMM
 .S BVDATE=9999998-EDT
 .S MED="" F  S MED=$O(^AUPNVMED("AA",DFN,MED)) Q:MED=""  D
 ..S BVDATE=$O(^AUPNVMED("AA",DFN,MED,BVDATE)) Q:BVDATE=""!(BVDATE>EVDATE)  D
 ...S VMEDIEN="" F  S VMEDIEN=$O(^AUPNVMED("AA",DFN,MED,BVDATE,VMEDIEN)) Q:VMEDIEN=""  D
 ....I $D(^TMP("VEPER7EX",$J,DFN,MED,BVDATE,VMEDIEN)) Q  ;Don't process a 2nd time
 ....K VMED D GETS^DIQ(9000010.14,VMEDIEN_",","**","","VMED")
 ....D PXTRTOM^VEPER7SB
 ....S ^TMP("VEPER7EX",$J,DFN,MED,BVDATE,VMEDIEN)=""
 ....K VMED
 Q 0
 ;
 ;
