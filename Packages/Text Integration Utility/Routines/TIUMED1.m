TIUMED1 ; BP/AJB - Mobile Elec. Doc ; 08/04/10
        ;;1.0;TEXT INTEGRATION UTILITIES;**244,257**;Jun 20, 1997;Build 18
        Q
ACTLOC(TIULOC)  ; IA # 10040
        N D0,X I +$G(^SC(TIULOC,"OOS")) Q 0
        S D0=+$G(^SC(TIULOC,42)) I D0 D WIN^DGPMDDCF Q 'X  ; IA # 1246
        S X=$G(^SC(TIULOC,"I")) I +X=0 Q 1
        I DT>$P(X,U)&($P(X,U,2)=""!(DT<$P(X,U,2))) Q 0
        Q 1
CLINLOC(TIUY,TIUF,TIUDIR)       ; returns a set of clinics from HOSPITAL LOCATION
        N TIUCNT,TIUDT,TIUIEN,TIUQUIT
        S TIUCNT=0
        F  Q:TIUCNT'<44  S TIUF=$O(^SC("B",TIUF),TIUDIR) Q:TIUF=""  D  ; IA # 10040
        . S TIUIEN="" F  S TIUIEN=$O(^SC("B",TIUF,TIUIEN),TIUDIR) Q:'TIUIEN  D
        . . I ($P($G(^SC(TIUIEN,0)),U,3)'="C") Q
        . . I '+$$ACTLOC(TIUIEN) Q
        . . S TIUCNT=TIUCNT+1,TIUY(TIUCNT)=TIUIEN_"^"_TIUF
        Q
GETHS(TIUY,TIUDFN)      ; get health summary
        N IO,POP,TIUHF,TIUHS,TIULOC,TIUX
        S TIUHS=$$GET^XPAR(DUZ_";VA(200,","TIU MED HSTYPE",1,"Q") ; IA # 2263
        I '+TIUHS D
        . N TIU,TIUDIV,TIUSRV,TIUSYS D USERINFO^XUSRB2(.TIU)
        . S TIUDIV=+TIU(3),TIUSRV=$$LU^TIUPS244(49,TIU(5),"X")
        . S TIUHS=$$GET^XPAR(TIUSRV_";DIC(49,","TIU MED HSTYPE",1,"Q")
        . S:'+TIUHS TIUHS=$$GET^XPAR(TIUDIV_";DIC(4,","TIU MED HSTYPE",1,"Q")
        . I '+TIUHS D
        . . S TIUSYS=$$KSP^XUPARAM("WHERE") ; IA # 2541
        . . S TIUSYS=$$LU^TIUPS244(4.2,TIUSYS)
        . . S TIUHS=$$GET^XPAR(TIUSYS_";DIC(4.2,","TIU MED HSTYPE",1,"Q")
        S TIUHF=$$DEFDIR^%ZISH("") ; use default directory IA # 2320
        I '+TIUHS S ^TMP("TIUMED",$J,0)="No Default Health Summary Selected" M TIUY=^TMP("TIUMED",$J) K ^TMP("TIUMED",$J) Q
        S TIULOC=TIUDFN_$J_".DAT"
        D OPEN^%ZISH("TIUMED_"_$J,TIUHF,TIULOC,"W")
        Q:+POP
        U IO
        D ENX^GMTSDVR(TIUDFN,TIUHS,0,0) ; IA # 744
        D CLOSE^%ZISH("TIUMED_"_$J)
        K ^TMP("TIUMED",$J)
        I '+$$FTG^%ZISH(TIUHF,TIULOC,$NA(^TMP("TIUMED",$J,0)),3) Q
        S TIUX(TIULOC)="" I $$DEL^%ZISH(TIUHF,$NA(TIUX))
        M TIUY=^TMP("TIUMED",$J)
        K ^TMP("TIUMED",$J)
        Q
GETOBJ(TIUY,TIUDFN,TIUOBJ)      ; get patient data object
        N DFN,TIUX,VA,VADM,VAERR
        K ^TMP("TIUMED",$J) S TIUY=$NA(^TMP("TIUMED",$J))
        S TIUOBJ="|"_TIUOBJ_"|"
        S DFN=$G(TIUDFN) I '+DFN Q
        S TIUX=$$BOIL^TIUSRVD(TIUOBJ,"")
        I TIUX["~@" S TIUX=$P(TIUX,"~@",2) M @TIUY=@TIUX K @TIUX Q
        M @TIUY@(0)=TIUX
        Q
GETPATDT(TIUY,TIUDFN,TIUSEC,TIUGHS)     ; get patient data
        I +$D(TIUDFN)=1,+$G(TIUDFN) S TIUDFN(0)=TIUDFN
        N TIULIST
        S TIULIST="" F  S TIULIST=$O(TIUDFN(TIULIST)) Q:TIULIST=""  D
        . N TIU,TIUERR
        . D FIND^DIC(2,,".01;.02I;.03I;.09","AXQ",$G(TIUDFN(TIULIST)),1,,,,"TIU","TIUERR")
        . S TIU("NAME")=$G(TIU("DILIST","ID",1,.01))
        . S TIU("SEX")=$G(TIU("DILIST","ID",1,.02))
        . S TIU("DOB")=$G(TIU("DILIST","ID",1,.03))
        . S TIU("SSN")=$G(TIU("DILIST","ID",1,.09))
        . S TIU("SECURITY")=+$$GET1^DIQ(38.1,$G(TIUDFN(TIULIST)),2,"I")
        . I '+$G(TIUSEC),+TIU("SECURITY") S (TIU("SEX"),TIU("DOB"),TIU("SSN"))="*SENSITIVE*"
        . I +$G(TIUGHS) D GETHS(.TIUY,$G(TIUDFN(TIULIST)))
        . S TIUY(TIULIST)=$G(TIUDFN(TIULIST))_U_TIU("NAME")_U_TIU("SEX")_U_TIU("SSN")_U_TIU("DOB")_U_TIU("SECURITY")
        Q
LAST5(TIUY,TIUID)       ; IA # 3291
        D LAST5^ORWPT(.TIUY,TIUID)
        Q
LISTALL(TIUY,TIUFROM,TIUDIR)    ; IA # 1685
        D LISTALL^ORWPT(.TIUY,TIUFROM,TIUDIR)
        Q
DELPARM ;
        N DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,POP,TIUANS,TIUERR,TIUSYS,X,Y
DCONT   K DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,POP,TIUANS,TIUERR,TIUSYS,X,Y
        S TIUSYS=$$KSP^XUPARAM("WHERE") ; IA # 2541
        S TIUSYS=$$LU^TIUPS244(4.2,TIUSYS)_U_TIUSYS
        S DIR(0)="SO^1:User;2:Service;3:Division;4:System"
        S DIR("L",1)="Delete a Health Summary for one the following:"
        S DIR("L",2)=""
        S DIR("L",3)="     1   User       [choose from NEW PERSON]"
        S DIR("L",4)="     2   Service    [choose from SERVICE/SECTION]"
        S DIR("L",5)="     3   Division   [choose from INSTITUTION]"
        S DIR("L")="     4   System     ["_$P(TIUSYS,U,2)_"]"
        S DIR("A")="Enter Selection"
        W @IOF
        D ^DIR Q:$D(DIRUT)
        S TIUANS=$S(Y=1:"VA(200,",Y=2:"DIC(49,",Y=3:"DIC(4,",Y=4:"DIC(4.2,")
        S DIC(0)="AE",DIC=U_TIUANS
        S DIC("A")="Please select a "_$$UP^XLFSTR(Y(0))_": "
        I Y'=4 W ! D ^DIC Q:$D(DIRUT)
        I +Y'>0 G DCONT
        S TIUANS=TIUANS_U_$S(Y=4:TIUSYS,1:Y)
        W !!,"Delete the Health Summary for "_$$UP^XLFSTR(Y(0))_" ["_$P(TIUANS,U,3)_"]",!
        I '+$$READ^TIUU("YA","Are you sure? ","NO") G DCONT
        D DEL^XPAR($P(TIUANS,U,2)_";"_$P(TIUANS,U),"TIU MED HSTYPE")
        W !!,"Parameter Deleted.",! I $$READ^TIUU("EA","RETURN to continue...")
        D DCONT
        Q
PARMEDIT        ;
        N DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,POP,TIUANS,TIUERR,TIUSYS,X,Y
CONT    K DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,POP,TIUANS,TIUERR,TIUSYS,X,Y
        S TIUSYS=$$KSP^XUPARAM("WHERE") ; IA # 2541
        S TIUSYS=$$LU^TIUPS244(4.2,TIUSYS)_U_TIUSYS
        S DIR(0)="SO^1:User;2:Service;3:Division;4:System"
        S DIR("L",1)="TIU MED HSTYPE may be set for the following:"
        S DIR("L",2)=""
        S DIR("L",3)="     1   User       [choose from NEW PERSON]"
        S DIR("L",4)="     2   Service    [choose from SERVICE/SECTION]"
        S DIR("L",5)="     3   Division   [choose from INSTITUTION]"
        S DIR("L")="     4   System     ["_$P(TIUSYS,U,2)_"]"
        S DIR("A")="Enter Selection"
        W @IOF
        D ^DIR Q:$D(DIRUT)
        S TIUANS=$S(Y=1:"VA(200,",Y=2:"DIC(49,",Y=3:"DIC(4,",Y=4:"DIC(4.2,")
        S DIC(0)="AE",DIC=U_TIUANS
        S DIC("A")="Please select a "_$$UP^XLFSTR(Y(0))_": "
        I Y'=4 W ! D ^DIC Q:$D(DIRUT)
        I +Y'>0 G CONT
        S TIUANS=TIUANS_U_$S(Y=4:TIUSYS,1:Y)
        S DIC="^GMT(142,",DIC("A")="Enter a HS for "_$$UP^XLFSTR(Y(0))_" ["_$S(Y(0)="System":$P(TIUSYS,U,2),1:$P(TIUANS,U,3))_"]: "
        S DIC("B")=$$GET^XPAR($P(TIUANS,U,2)_";"_$P(TIUANS,U),"TIU MED HSTYPE",1,"Q") ; IA # 2263
        W ! D ^DIC
        I +Y>0 D EN^XPAR($P(TIUANS,U,2)_";"_$P(TIUANS,U),"TIU MED HSTYPE",1,+Y,.TIUERR) ; IA # 2263
        G CONT
        Q
PATMAN(TIUY)    ;
        N TIUP S TIUY=0
        D OWNSKEY^XUSRB(.TIUP,"TIU MED MANUAL PATIENT") I +TIUP(0) S TIUY=1
        D OWNSKEY^XUSRB(.TIUP,"TIU MED MANUAL OVERRIDE") I +TIUP(0) S TIUY=2
        Q
PLISTMEM(TIUY,TIULIST)  ;
        N TIU,TIUDFN,TIUERR,TIUI,TIUJ
        S TIUI=$NA(TIU(100.2101))
        D GETS^DIQ(100.21,$G(TIULIST),"10*","I","TIU","TIUERR")
        S TIUJ="" F  S TIUJ=$O(@TIUI@(TIUJ)) Q:'TIUJ  S TIUDFN(+TIUJ)=+@TIUI@(TIUJ,.01,"I")
        D GETPATDT(.TIUY,.TIUDFN)
        Q
PLISTS(TIUY)    ;
        N TIU,TIUERR,TIUI,TIUJ,TIUX
        S TIUI=$NA(TIU("DILIST")),TIUJ=$NA(^OR(100.21))
        D FIND^DIC(100.21,,"-.01","AXQ",DUZ,,"C","I $P($G(^OR(100.21,Y,0)),U,2)=""P""",,"TIU")
        I '+$G(@TIUI@(0)) Q
        S TIUX="" F  S TIUX=$O(@TIUI@("2",TIUX)) Q:'+TIUX  S TIUY(TIUX)=@TIUI@("2",TIUX)_U_@TIUJ@(@TIUI@("2",TIUX),0)
        Q
