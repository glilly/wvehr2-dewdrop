PPPEDT22 ;ALB/JFP - EDIT FF XREF ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; This routines control the changing of domains in the foreign facility 
 ; file.
 ;
CHNG ; -- EDIT FFX data
 ;
 N SNIFN2,PPPDOM,NEWDOM,OLDDOM
 N VALMY,SDI,SDAT,FFXIFN
 ;
 D EN^VALM2($G(XQORNOD(0)),"O")
 Q:'$D(VALMY)
 S SDI=""
 F  S SDI=$O(VALMY(SDI))  Q:SDI=""  D
 .S SDAT=$G(@IDXARRAY@(SDI))
 .S SNIFN2=$P(SDAT,"@",2)
 .S FFXIFN=$P(SDAT,"@",3)
 .S OLDDOM=$P(SDAT,"@",4)
 .D EDIT1
 D INIT^PPPEDT21
 S VALMBCK="R"
 Q
 ;
EDIT1 ; -- Edits entry in FFX file
 N NEWTO
 ;
 S PPPDOM=$$GETDOM^PPPGET3(+SNIFN2)
 S NEWTO=$S(PPPDOM=" ":" ?? for choices",1:" ")
 S DIR(0)="P^4.2:EQM"
 S DIR("A")="Change Domain Name in entry "_SDI_" from "_OLDDOM_" to"_NEWTO
 S DIR("B")=$S(PPPDOM'=" ":PPPDOM,1:"??")
 S DIR("?")="^D CLEAR^VALM1,HLPDOM1^PPPHLP01"
 S DIR("??")="^D CLEAR^VALM1,HLPD1^PPPHLP01"
 D ^DIR
 I $D(DIRUT) Q
 S NEWDOM=$P(Y,"^",2)
 K DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 I OLDDOM'=NEWDOM D  Q
 .S $P(^PPP(1020.2,FFXIFN,1),"^",5)=NEWDOM
 Q
 ;
CHNGA ; -- Changes all entries
 ;
 N SNIFN2,PPPDOM,NEWDOM,OLDDOM
 N SDI,SDAT,FFXIFN
 Q:'$D(^TMP("PPPIDX"))
 ;
 S PPPDOM=$$GETDOM^PPPGET3(+SNIFN) ; original institution
 S DIR(0)="P^4.2:EQM"
 S DIR("A")="Change ALL Domain Name listed to"
 S DIR("B")=$S(PPPDOM'=" ":PPPDOM,1:"Domain not found")
 S DIR("?")="^D CLEAR^VALM1,HLPDOM1^PPPHLP01"
 S DIR("??")="^D CLEAR^VALM1,HLPD1^PPPHLP01"
 D ^DIR
 I $D(DIRUT) Q
 S NEWDOM=$P(Y,"^",2)
 K DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 S SDI=""
 F  S SDI=$O(^TMP("PPPIDX",$J,SDI))  Q:SDI=""  D
 .S SDAT=$G(@IDXARRAY@(SDI))
 .S SNIFN2=$P(SDAT,"@",2)
 .S FFXIFN=$P(SDAT,"@",3)
 .S OLDDOM=$P(SDAT,"@",4)
 .I OLDDOM'=NEWDOM D  Q
 ..S $P(^PPP(1020.2,FFXIFN,1),"^",5)=NEWDOM
 D INIT^PPPEDT21
 S VALMBCK="R"
 Q
 ;
END ; -- End of code
 Q
 ;
