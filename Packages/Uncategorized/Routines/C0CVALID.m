C0CVALID        ; C0C/OHUM/RUT - PROCESSING FOR DATE LIMITS, NOTES ; 22/12/2011
        ;;1.2;C0C;;May 11, 2012;Build 50;Build 2
        S ^TMP("C0CCCR","LABLIMIT")="",^TMP("C0CCCR","VITLIMIT")="",^TMP("C0CCCR","MEDLIMIT")="",^TMP("C0CCCR","TIULIMIT")=""
        S %DT="AEX",%DT("A")="LAB Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","LABLIMIT")=Y
        S %DT="AEX",%DT("A")="VITAL Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","VITLIMIT")=Y
        S %DT="AEX",%DT("A")="MEDICATION Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","MEDLIMIT")=Y
        ;S ^TMP("C0CCCR","RALIMIT")="",%DT="AEX",%DT("A")="RADIOLOGY Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","RALIMIT")=Y
        W !,"Do you want to include Notes: YES/NO? //NO" D YN^DICN I %=1 S %DT="AEX",%DT("A")="NOTE Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","TIULIMIT")=Y
        Q
HTOF(FLAGS)     ;Changing DATE in FILMAN's FORMAT
        N HORLOGDATECUR,COVDATE,HORLOGDATE,FDATE
        S HORLOGDATECUR=$P($H,",",1)
        S COVDATE=$P(FLAGS,"-",2)
        S HORLOGDATE=HORLOGDATECUR-COVDATE
        S (FDATE)=$$H2F^XLFDT(HORLOGDATE)
        K HORLOGDATECUR,COVDATE,HORLOGDATE
        Q FDATE
