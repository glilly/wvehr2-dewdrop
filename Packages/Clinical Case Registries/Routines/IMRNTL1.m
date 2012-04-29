IMRNTL1 ;HIOFOC/NCA,FT-Immunology National Data Base Inquiry (Cont.) ;9/24/97  11:36
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
PA ; Patient Inquiry
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PA"_"^"_IMRSSN
 D SEND
 Q
CAT ; Breakdown of Patient by Category
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="CAT"_"^"_IMRSD_"^"_IMRED_"^"_IMRTEST_"^"_IMRMC_"^"_IMRDL
 D SEND
 Q
LAB ; Laboratory Utilization Data Report
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="LAB"_"^"_IMRSD_"^"_IMRED_"^"_IMRN1_"^"_IMR2C_"^"_IMRRMAX_"^"_IMRDL
 D SEND
 Q
PH ; Pharmacy Prescription Utilization Data Report
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PH"_"^"_IMRSD_"^"_IMRED_"^"_IMRN1_"^"_IMRN2_"^"_IMR2C_"^"_IMRRMAX_"^"_IMRDL
 D SEND
 Q
FOL ; Follow Up Report
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="FOL"_"^"_IMRDAY_"^"_IMRDL
 D SEND
 Q
LABS ; Utilization of Specific Lab Test Report
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="LABS"_"^"_IMRSD_"^"_IMRED_"^"_IMRDL
 F IMRRI=0:0 S IMRRI=$O(^TMP($J,"IMRLAB",IMRRI)) Q:IMRRI<1  S IMRX=$P($G(^LAB(60,IMRRI,0)),"^",1) I IMRX'="" S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="LA"_"^"_IMRX
 D SEND
 Q
PHS ; Drug Specification Utilization Report
 D REQUEST
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PHS"_"^"_IMRSD_"^"_IMRED_"^"_IMRDL
 F IMRRI=0:0 S IMRRI=$O(^TMP($J,"IMRRX",IMRRI)) Q:IMRRI<1  S IMRX=$$GET1^DIQ(50,IMRRI,.01,"E") I IMRX'="" S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DRUG"_"^"_IMRX
 D SEND
 Q
REQUEST ; Build First Line
 I '$D(IMRSTN) D IMROPN^IMRXOR Q:'$D(IMRSTN)
 K ^TMP($J,"IMRX")
 W !!,"Sending Request Message to the National Registry..."
 S IMRC=1,^TMP($J,"IMRX",IMRC)="REQUEST"_"^"_IMRSTN_"^"_DT_"^"_DUZ_"^"_$P($G(^VA(200,DUZ,0)),"^",1)
 Q
SEND ; Send Message To National Registry
 S X="N",%DT="T" D ^%DT S IMRDTT=Y,IMRSET=1
 D DOMAIN^IMRUTL ;get the domain name for ICR
 S IMRDOMN="S.IMRHDATA@"_IMRDOMN ;append domain to server name
 K XMY
 F IMRGI=0:0 S IMRGI=$O(^IMR(158.9,1,1,IMRGI)) Q:IMRGI'>0  I $P(^(IMRGI,0),"^",2)=1 S XMY(+^(0))=""
 S XMTEXT="^TMP($J,""IMRX"",",XMSUB="IMMUNOLOGY REPORT REQUEST. "_IMRSTN_" "_$E(IMRDTT,4,5)_"-"_$E(IMRDTT,6,7)_"-"_$E(IMRDTT,2,3)_" ("_IMRSET_")",XMDUZ=.5,XMY(IMRDOMN)="" D ^XMD
 W !,"Done..."
 K ^TMP($J,"IMRX"),IMRDOMN,XMTEXT,XMDUZ,XMY,XMSUB,IMRGI
 Q
