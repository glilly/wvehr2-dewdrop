ECXNUT1 ;ALB/JRC Nutrition DSS Extract ; 10/30/08 3:20pm
        ;;3.0;DSS EXTRACTS;**92,107,105,112**;Dec 22, 1997;Build 26
        Q
GETMEALS        ;get patient meals
        ; variable names:   ordate - regular diet order date
        ;                   sdate  - diet order npo/withhold date
        ;                   norder - "sf" or "so" order date
        ;                             note: there is a relationship
        ;                             between "sf", "so" and regular diets
        ;                   adate - admission date
        ;                   ddate - discharge date
        N I,J,P,D,ECXADM,FHDFN,ORDATE,DATES,NODE,SF,PRODUCT,ECXQTY,ORDER,ECXORDPH,ECXKEY,ECXFPD,ECXFDD,ECXFPF,ECXDLT,ECXDFL,MEAL,MEALS,SORDATE,NUMBER,TF,TFNODE,ECXTFU,SDATE,START
        ;set ecsd to first day of the month before setting meals array
        S ECSD=ECSD+.1,ECXTFU=""
        ;setup individual meals array for inpatients
        F I=ECSD:1:ECED F J=I+.0800,I+.1300,I+.1800 S MEALS(J)=J
        ;get "inp", "sf", and "so" inpatient meals
        S ECXADM=0 F  S ECXADM=$O(@ARRAY@(ECXADM)) Q:'ECXADM  D
        .S FHDFN=0 F  S FHDFN=$O(@ARRAY@(ECXADM,FHDFN)) Q:'FHDFN  D
        ..S ORDATE=0,(ADATE,DDATE,SDATE)=""
        ..F  S ORDATE=$O(@ARRAY@(ECXADM,FHDFN,ORDATE)) Q:'ORDATE  D
        ...Q:$P($G(^TMP($J,"FH",ECXADM,FHDFN,+ORDATE,"INP")),U,7)'=""
        ...S DATES=$$GETDATES(),SDATE=ORDATE
        ...;create regular diet individual meals
        ...S P="INP",D="PD"
        ...;get new order date and time if exist
        ...S NORDER=$$NEWORDER(P,ORDATE)
        ...S NODE=$G(^TMP($J,"FH",ECXADM,FHDFN,ORDATE,"INP")) Q:'NODE
        ...S PRODUCT=$P(NODE,U,13),ECXQTY=1,ORDER=""_$P(NODE,U,14)_","_""
        ...;Resolve feeder key for nutrition product
        ...S ECXKEY=$$NUTKEY^ECXUTL6(D,PRODUCT)
        ...I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        ...S MEAL=ORDATE F  S MEAL=$O(MEALS(MEAL)) Q:'MEAL  D
        ....I $P(DATES,U) Q:MEAL>$P(DATES,U)
        ....I NORDER]"" Q:MEAL>NORDER
        ....I $P(DATES,U,3) Q:MEAL>$P(DATES,U,3)
        ....S ECXORDPH=$$GET1^DIQ(100,+ORDER,1,"I")
        ....;Get additional data and file record.
        ....S DATE=MEAL D GET^ECXNUT
        ;create supplemental feeding meals if they exist
        S ECXADM=0 F  S ECXADM=$O(@ARRAY@(ECXADM)) Q:'ECXADM  D
        .S FHDFN=0 F  S FHDFN=$O(@ARRAY@(ECXADM,FHDFN)) Q:'FHDFN  D
        ..S ORDATE=0,(ADATE,DDATE,SDATE)=""
        ..F  S ORDATE=$O(@ARRAY@(ECXADM,FHDFN,ORDATE)) Q:'ORDATE  D
        ...S DATES=$$GETDATES()
        ...;get "sf" orders if they exist
        ...N SFNODE S (SFNODE,ECXORDPH,CDATE)=""
        ...S SFNODE=$G(@ARRAY@(ECXADM,FHDFN,ORDATE,"SF"))
        ...I +SFNODE D
        ....S P="INP",D="SF"
        ....;get new order date and time if exist
        ....S NORDER=$$NEWORDER(D,ORDATE),CDATE=$P(SFNODE,U,32)
        ....S START=$P(SFNODE,U,2) I START<ECSD S START=ECSD
        ....;order thru all "sf" product fields and generate records
        ....F SF=5:2:27 S PRODUCT=$P(SFNODE,U,SF) S ECXQTY=$P(SFNODE,U,(SF+1)) D
        .....Q:PRODUCT']""
        .....;Resolve external value for product key
        .....S ECXKEY=$$NUTKEY^ECXUTL6("SF",PRODUCT)
        .....I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        .....;create individual meals
        .....F MEAL=START:1:ECED D
        ......I CDATE]"" Q:MEAL>CDATE
        ......I NORDER]"" Q:MEAL>NORDER
        ......I $P(DATES,U,3)]"" Q:MEAL>$P(DATES,U,3)
        ......;Get additional data and file record.
        ......S DATE=$P(MEAL,".")_"."_$S("57911"[SF:10,"13151719"[SF:14,1:18)
        ......D GET^ECXNUT
        ;create standing order meals if they exist
        S ECXADM=0 F  S ECXADM=$O(@ARRAY@(ECXADM)) Q:'ECXADM  D
        .S FHDFN=0 F  S FHDFN=$O(@ARRAY@(ECXADM,FHDFN)) Q:'FHDFN  D
        ..S ORDATE=0,(ADATE,DDATE,SDATE)=""
        ..F  S ORDATE=$O(@ARRAY@(ECXADM,FHDFN,ORDATE)) Q:'ORDATE  D
        ...S DATES=$$GETDATES()
        ...N SONODE,NUM S (SONODE,ECXORDPH)="",NUM=0
        ...S NUM=$O(@ARRAY@(ECXADM,FHDFN,ORDATE,"SO",NUM)) Q:'NUM  D
        ....S SONODE=$G(@ARRAY@(ECXADM,FHDFN,ORDATE,"SO",NUM))
        ....I +SONODE D
        .....;create standing order meals
        .....N SMEAL S P="INP",D="SO"
        .....;get new order date and time if exist
        .....S NORDER=$$NEWORDER(D,ORDATE),SMEAL=$P(SONODE,U,3)
        .....S PRODUCT=$P(SONODE,U,2),ECXQTY=$P(SONODE,U,8)
        .....;Resolve feeder key for nutrition product
        .....S ECXKEY=$$NUTKEY^ECXUTL6(D,PRODUCT)
        .....I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        .....;create individual meals
        .....S MEAL=ORDATE F  S MEAL=$O(MEALS(MEAL)) Q:'MEAL  D
        ......N TIME S TIME=$P(MEALS(MEAL),".",2)
        ......Q:SMEAL'["B"&(TIME=08)
        ......Q:SMEAL'["N"&(TIME=13)
        ......Q:SMEAL'["E"&(TIME=18)
        ......I $P(DATES,U) Q:MEAL>$P(DATES,U)
        ......I NORDER]"" Q:MEAL>NORDER
        ......I $P(DATES,U,3) Q:MEAL>$P(DATES,U,3)
        ......;Get additional data and file record.
        ......S DATE=MEAL D GET^ECXNUT
        ;remove individual meals array
        K MEALS
        ;Get inpatient tube feedings
        N P1,PNODE,CDATE,ECXTFU,MEALS
        ;set daily meals array for inpatient tube feedings
        F I=ECSD:1:ECED S MEALS(I)=""
        S (FHDFN,DATE,P1,CDATE)=0,(ECXADM,NODE,ECXORDPH,PNODE)=""
        S P="INP",D="TF" F  S ECXADM=$O(^TMP($J,"FH",ECXADM)) Q:'ECXADM  D
        .F  S FHDFN=$O(^TMP($J,"FH",ECXADM,FHDFN))  Q:'FHDFN  D
        ..F  S DATE=$O(^TMP($J,"FH",ECXADM,FHDFN,DATE)) Q:'DATE  D
        ...S NODE=$G(^TMP($J,"FH",ECXADM,FHDFN,DATE,"TF")) Q:'NODE  D
        ....F  S P1=$O(^TMP($J,"FH",ECXADM,FHDFN,DATE,"TF",P1)) Q:'P1  D
        .....S PNODE=^TMP($J,"FH",ECXADM,FHDFN,DATE,"TF",P1,"P")
        .....S ORDATE=DATE,DATES=$$GETDATES(),CDATE=$P(NODE,U,11)
        .....S PRODUCT=$P(PNODE,U,1),ORDER=""_$P(NODE,U,14)_","_""
        .....S ECXQTY=$S($P(PNODE,U,3)["GM":$P(PNODE,U,3),1:$P(PNODE,U,4))
        .....S ECXTFU=$S($P(PNODE,U,3)["GM":"GM",1:"ML")
        .....;Resolve external value for product key
        .....S ECXKEY=$$NUTKEY^ECXUTL6(D,PRODUCT)
        .....I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        .....;create daily meals
        .....S MEAL=DATE F  S MEAL=$O(MEALS(MEAL)) Q:'MEAL  D
        ......I $P(DATES,U) Q:MEAL>$P(DATES,U)
        ......I CDATE]"" Q:MEAL>CDATE
        ......I $P(DATES,U,3) Q:MEAL>$P(DATES,U,3)
        ......S ECXORDPH=$$GET1^DIQ(100,ORDER,1,"I")
        ......;Get additional data and file record.
        ......S DATE=MEAL D GET^ECXNUT S DATE=ORDATE
        ;Get outpatient recurring meals
        S DATE=0,(ECXADM,NODE,ECXORDPH,ECXTFU)=""
        S P="OP",D="RM" F  S DATE=$O(^TMP($J,"FH",DATE)) Q:'DATE  D
        . S FHDFN=0 F  S FHDFN=$O(^TMP($J,"FH",DATE,FHDFN))  Q:'FHDFN  D
        .. S NUMBER=0 F  S NUMBER=$O(^TMP($J,"FH",DATE,FHDFN,NUMBER)) Q:'NUMBER  D
        ... S NODE=$G(^TMP($J,"FH",DATE,FHDFN,NUMBER,"RM")) Q:'NODE
        ... S PRODUCT=$P(NODE,U,2),ECXQTY=1,ORDER=""_$P(NODE,U,12)_","_""
        ... S PRODUCT=$$GET1^DIQ(111,PRODUCT,4,"I")
        ... S ECXORDPH=$$GET1^DIQ(100,ORDER,1,"I")
        ... ;Resolve external value for product key
        ... S ECXKEY=$$NUTKEY^ECXUTL6("PD",PRODUCT)
        ... I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        ... ;Get additional data and file record.
        ... D GET^ECXNUT
        ;Get outpatient standing orders
        S DATE=0,(ECXADM,NODE,ECXORDPH)=""
        S P="OP",D="SO" F  S DATE=$O(^TMP($J,"FH",DATE)) Q:'DATE  D
        . S FHDFN=0 F  S FHDFN=$O(^TMP($J,"FH",DATE,FHDFN))  Q:'FHDFN  D
        .. S NUMBER=0 F  S NUMBER=$O(^TMP($J,"FH",DATE,FHDFN,NUMBER)) Q:'NUMBER  D
        ... S FHNUM=0 F  S FHNUM=$O(^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMSO",FHNUM)) Q:FHNUM'>0  D
        ....N SMEAL S P="OP",D="SO"
        ....;get new order date and time if exist
        ....S SONODE=^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMSO",FHNUM)
        ....S NORDER=DATE,SMEAL=$P(SONODE,U,3)
        ....S PRODUCT=$P(SONODE,U,2),ECXQTY=$P(SONODE,U,8)
        ....;Resolve feeder key for nutrition product
        ....S ECXKEY=$$NUTKEY^ECXUTL6(D,PRODUCT)
        ....I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        ....;create individual meals
        ....S MEAL=NUMBER F  S MEAL=$O(MEALS(MEAL)) Q:'MEAL  D
        .....N TIME S TIME=$P(MEALS(MEAL),".",2)
        .....Q:SMEAL'["B"&(TIME=08)
        .....Q:SMEAL'["N"&(TIME=13)
        .....Q:SMEAL'["E"&(TIME=18)
        .....I $P(DATES,U) Q:MEAL>$P(DATES,U)
        .....I NORDER]"" Q:MEAL>NORDER
        .....I $P(DATES,U,3) Q:MEAL>$P(DATES,U,3)
        .....;Get additional data and file record.
        .....N ZDATE S ZDATE=DATE
        .....S DATE=MEAL D GET^ECXNUT
        .....S DATE=ZDATE
        ;Get outpatient supplemental feedings
        S DATE=0,(ECXADM,NODE,ECXORDPH)=""
        S P="OP",D="SO" F  S DATE=$O(^TMP($J,"FH",DATE)) Q:'DATE  D
        . S FHDFN=0 F  S FHDFN=$O(^TMP($J,"FH",DATE,FHDFN))  Q:'FHDFN  D
        .. S NUMBER=0 F  S NUMBER=$O(^TMP($J,"FH",DATE,FHDFN,NUMBER)) Q:'NUMBER  D
        ... Q:'$D(^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMSF"))  D
        ....N SMEAL S P="OP",D="SF"
        ....;get "sf" orders if they exist
        ....N SFNODE S (SFNODE,ECXORDPH,CDATE)=""
        ....S SFNODE=^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMSF")
        ....I +SFNODE D
        .....;get new order date and time if exist
        .....S NORDER=DATE,CDATE=$P(SFNODE,U,32)
        .....;order thru all "sf" product fields and generate records
        .....F SF=5:2:27 S PRODUCT=$P(SFNODE,U,SF) S ECXQTY=$P(SFNODE,U,(SF+1)) D
        ......Q:PRODUCT']""
        ......;Resolve external value for product key
        ......S ECXKEY=$$NUTKEY^ECXUTL6("SF",PRODUCT)
        ......I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        ......;create individual meals
        ......F MEAL=DATE
        ......I $P(DATES,U,3)]"" Q:MEAL>$P(DATES,U,3)
        ......;Get additional data and file record.
        ......N ZDATE S ZDATE=DATE
        ......S DATE=$P(MEAL,".")_"."_$S("57911"[SF:10,"13151719"[SF:14,1:18)
        ......D GET^ECXNUT
        ......S DATE=ZDATE
        ;Get outpatient tube feedings
        S DATE=0,(ECXADM,NODE,ECXORDPH)=""
        S P="OP",D="TF" F  S DATE=$O(^TMP($J,"FH",DATE)) Q:'DATE  D
        . S FHDFN=0 F  S FHDFN=$O(^TMP($J,"FH",DATE,FHDFN))  Q:'FHDFN  D
        .. S NUMBER=0 F  S NUMBER=$O(^TMP($J,"FH",DATE,FHDFN,NUMBER)) Q:'NUMBER  D
        ... S NODE=$G(^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMTF")) Q:NODE=""
        ... S TF=0 F  S TF=$O(^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMTF",TF)) Q:'TF  D
        .... S TFNODE=^TMP($J,"FH",DATE,FHDFN,NUMBER,"RMTF",TF)
        .... S PRODUCT=$P(TFNODE,U,1),ECXQTY=$P(TFNODE,U,4)
        .... ;Resolve external value for product key
        .... S ECXKEY=$$NUTKEY^ECXUTL6("TF",PRODUCT)
        .... I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        .... ;Get additional data and file record.
        .... D GET^ECXNUT
        ;Get outpatient special meals
        S (FHDFN,DATE)=0,(ECXADM,NODE,ECXORDPH)=""
        S P="OP",D="SM" F  S DATE=$O(^TMP($J,"FH",DATE)) Q:'DATE  D
        . F  S FHDFN=$O(^TMP($J,"FH",DATE,FHDFN)) Q:'FHDFN  D
        .. S NODE=$G(^TMP($J,"FH",DATE,FHDFN,"SM")) Q:'NODE
        .. S PRODUCT=$P(NODE,U,4),ECXQTY=1,ECXORDPH=$P(NODE,U,5)
        .. S PRODUCT=$$GET1^DIQ(111,PRODUCT,4,"I")
        .. ;Resolve external value for product key
        .. S ECXKEY=$$NUTKEY^ECXUTL6("SM",PRODUCT)
        .. I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        .. ;Get additional data and file record.
        .. D GET^ECXNUT
        ;Get outpatient guest meals
        S (FHDFN,DATE)=0,(ECXADM,NODE,ECXORDPH)=""
        S P="OP",D="GM" F  S DATE=$O(^TMP($J,"FH",DATE)) Q:'DATE  D
        . F  S FHDFN=$O(^TMP($J,"FH",DATE,FHDFN)) Q:'FHDFN  D
        .. S NODE=$G(^TMP($J,"FH",DATE,FHDFN,"GM")) Q:'NODE
        .. S PRODUCT=$P(NODE,U,13),ECXQTY=1
        .. ;Resolve external value for product key
        .. S ECXKEY=$$NUTKEY^ECXUTL6("GM",PRODUCT)
        .. I $$NUTLOC^ECXUTL6(P,D,.ECXFPD,.ECXFDD,.ECXFPF,.ECXDLT,.ECXDFL)
        .. ;Get additional data and file record.
        .. D GET^ECXNUT
        Q
GETDATES()      ;Get admit, discharge, npo/withhold dates,for "inp", "sf" and "so"
        ;  return in string i.e.  stop date^admission date^discharge date
        ;     input:    ecxadm  -  movement file ien
        ;               fhdfn   - nutrition patient file (#115)
        ;
        ;     output:   stop date  - npo/withhold date
        ;               admit date - admission date and time
        ;               discharge date - discharge date and time
        ;init variables
        N ADATE,DDATE,DATE,STDATE,NORDATE,IENS
        ;check input
        Q:'$G(ECXADM)!'$G(FHDFN) "0^0^0"
        ;get admission and discharge dates
        S (ADATE,DDATE,DATE,SDATE,NORDATE,STDATE)="",IENS=""_ECXADM_","_FHDFN_","_"",ADATE=$$GET1^DIQ(115.01,IENS,.01,"I"),DDATE=$$GET1^DIQ(115.01,IENS,18,"I")
        ;get "inp" order's npo/withhold date return it as 'stdate' if exist
        S DATE=ORDATE F  S DATE=$O(@ARRAY@(ECXADM,FHDFN,DATE)) Q:'DATE  D
        .I $P($G(@ARRAY@(ECXADM,FHDFN,+DATE,"INP")),U,7)'="" S STDATE=DATE
        Q STDATE_U_ADATE_U_DDATE
NEWORDER(TYPE,DATE)     ;Look for new order for inpatient meal type if exist
        ;    Input     ecxadm -  movement #
        ;              fhdfn  -  nutrition file (#115) fhdfn
        ;              date   -  starting order date to begin lookup
        ;              type   -  meal type "sf", "so", or "pd"
        ;    Output:   new order date and time for specific meal type
        ;init variables
        N NUMT
        S NORDER="",NUMT=0
        Q:$G(TYPE)']""!'$G(DATE) NORDER
        F  S DATE=$O(@ARRAY@(ECXADM,FHDFN,DATE)) Q:'DATE  Q:NORDER  D
        .I TYPE="SO" D  Q
        ..S NUMT=$O(^TMP($J,"FH",ECXADM,FHDFN,DATE,TYPE,NUMT)) Q:'NUMT
        ..S NODE=$G(^TMP($J,"FH",ECXADM,FHDFN,DATE,TYPE,NUMT)) Q:'+NODE
        ..S NORDER=DATE
        .S NODE=$G(^TMP($J,"FH",ECXADM,FHDFN,DATE,TYPE)) Q:'+NODE
        .S NORDER=DATE
        Q NORDER
