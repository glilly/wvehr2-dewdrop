GMRADSP1        ;HIRMFO/WAA-DISPLAY ALLERGY ;11/13/07  08:07
        ;;4.0;Adverse Reaction Tracking;**41**;Mar 29, 1996;Build 8
DISBLD(IEN,ARRAY)       ; This subroutine will bulid the array that will
        ; be displayed for each reactant.  The IEN for each reactant in
        ; stored in GMRAPA.
        N CNT,X,NODE
        S NODE=$G(^GMR(120.8,IEN,0)) Q:NODE=""  S CNT=1
        I $L(GMRANAME)>50 S ARRAY(CNT)=$E(GMRANAME,1,50),CNT=CNT+1,ARRAY(CNT)=$E(GMRANAME,51,999)
        E  S ARRAY(CNT)=GMRANAME
ING     ;Find all the ingredents for a reactant.
        I $O(^GMR(120.8,IEN,2,0))>0 D
        .N GMRAFST,GMRAGBAL,GMRAING,GMRAINGR,GMRALLEG,GMRALST
        .S GMRAINGR=0,GMRALLEG=0
        .F  S GMRAINGR=$O(^GMR(120.8,IEN,2,GMRAINGR)) Q:GMRAINGR'>0  S GMRAGBAL=^GMR(120.8,IEN,2,GMRAINGR,0) D
        ..;--41-1
        ..D ZERO^PSN50P41(GMRAGBAL,"","","ENCAP")
        ..I '$D(^TMP($J,"ENCAP",GMRAGBAL)) K ^TMP($J,"ENCAP") Q
        ..;--41-1
        ..;--41-2
        ..I $P(NODE,U,2)=$P(^TMP($J,"ENCAP",GMRAGBAL,.01),U) Q
        ..;--41-2
        ..;--41-3
        ..S GMRALLEG(IEN,$P(^TMP($J,"ENCAP",GMRAGBAL,.01),U))="",GMRALLEG=GMRALLEG+1
        ..K ^TMP($J,"ENCAP")
        ..;--41-3
        ..Q
        .I GMRALLEG S (GMRAINGR,GMRAING)="",CNT=CNT+1,ARRAY(CNT)="",GMRAFST=1,GMRALST=0 F  S GMRAINGR=$O(GMRALLEG(IEN,GMRAINGR)) Q:GMRAINGR=""  D
        ..I $O(GMRALLEG(IEN,GMRAINGR))="" S GMRALST=1
        ..S GMRAING=GMRAINGR
        ..I GMRAFST S GMRAING=" ("_GMRAING,GMRAFST=0
        ..I 'GMRALST S GMRAING=GMRAING_", "
        ..I GMRALST S GMRAING=GMRAING_")"
        ..I $L(ARRAY(CNT)_GMRAING)>52 S CNT=CNT+1,ARRAY(CNT)="  "_GMRAING
        ..E  S ARRAY(CNT)=ARRAY(CNT)_GMRAING
        ..Q
        .Q
SIGN    ;Get all the patient Sign/Symptoms
        I $O(^GMR(120.8,IEN,10,0))>0 D
        .N GMRAFST,GMRALST,GMRAOTH,GMRAREAC,GMRAREAN,GMRATONS
        .S GMRAOTH=$O(^GMRD(120.83,"B","OTHER REACTION",0))
        .S GMRAFST=1,GMRALST=0,CNT=CNT+1,ARRAY(CNT)="    Reactions:"
        .S GMRAREAC=0 F  S GMRAREAC=$O(^GMR(120.8,IEN,10,GMRAREAC)) Q:GMRAREAC'>0  S GMRAREAN=$P($G(^GMR(120.8,IEN,10,GMRAREAC,0)),U) I GMRAREAN'="" D
        ..N GMRAREC
        ..I '$O(^GMR(120.8,IEN,10,GMRAREAC)) S GMRALST=1
        ..S GMRATONS=$S(GMRAREAN'=GMRAOTH:$P(^GMRD(120.83,GMRAREAN,0),U),1:$P(^GMR(120.8,IEN,10,GMRAREAC,0),U,2))
        ..S GMRAREC=GMRATONS
        ..I GMRAFST S GMRAREC=" "_GMRAREC,GMRAFST=0
        ..I 'GMRALST S GMRAREC=GMRAREC_", "
        ..I $L(ARRAY(CNT)_GMRAREC)>52 S CNT=CNT+1,ARRAY(CNT)="               "_GMRAREC
        ..E  S ARRAY(CNT)=ARRAY(CNT)_GMRAREC
        ..Q
        .Q
        S %=$S($P(NODE,U,16):"YES",1:" NO") I $P(NODE,U,16),$P(NODE,U,18)="" S %="AUTO"
        S ARRAY(1)=ARRAY(1)_$J(" ",(53-$L(ARRAY(1))))_%
        S %=$P(NODE,U,14),%=$S(%="P":"PHARM  ",%="A":"ALLERGY",%="U":"UNKNOWN ",1:""),ARRAY(1)=ARRAY(1)_$J(" ",(59-$L(ARRAY(1))))_%
        S %=$P(NODE,U,6),%=$S(%="o":"OBS",%="h":"HIST",1:""),ARRAY(1)=ARRAY(1)_$J(" ",(68-$L(ARRAY(1))))_%
TYPE    S %="" F X=1:1:($L(GMRATYPE)) D
        .S %=$P("^FOOD^DRUG^OTHER",U,$F("FDO",$E(GMRATYPE,X)))
        .S ARRAY(X)=$G(ARRAY(X))
        .S ARRAY(X)=ARRAY(X)_$J(" ",(74-$L(ARRAY(X))))_%
        .Q
        Q
