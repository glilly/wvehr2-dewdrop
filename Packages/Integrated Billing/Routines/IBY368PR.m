IBY368PR        ;YMG/BP - Environment check for IB patch 368 ;04-Apr-2007
        ;;2.0;INTEGRATED BILLING;**368**;04-APR-2007;Build 21
        ;
EN      ; Standard Entry Point
        D CHECK
        Q
        ;
CHECK   ; check for correct time window
        ; patch should be installed between 3pm CST and 9am CST in production
        ; no check necessary if test account - if that's the case, bail out
        Q:'$$PROD^XUPROD(1)
        N CTS,DATE,ETIME,ETS,STIME,STS,TZ,Z
        S Z=$$NOW^XLFDT(),CTS=Z-(Z\1),DATE=$P(Z,".") ; get current date and time
        ; pick either CDT or CST timesone (in 2007 daylight saving time ends on Nov 4, at 2 am)
        S TZ=$S(Z>3071104.02:"-0500",1:"-0600")
        S STS=$$HL7TFM^XLFDT("090000"_TZ,"L",1),ETS=$$HL7TFM^XLFDT("150000"_TZ,"L",1)
        I CTS>STS&(CTS<ETS) D
        .S STIME=$$HLDATE^HLFNC(DATE_STS,"TM"),ETIME=$$HLDATE^HLFNC(DATE_ETS,"TM")
        .W !,"This patch has to be installed between "_$E(ETIME,1,2)_":"_$E(ETIME,3,4)_" and "_$E(STIME,1,2)_":"_$E(STIME,3,4)_"...Installation aborted."
        .S XPDQUIT=2
        .Q
        Q
