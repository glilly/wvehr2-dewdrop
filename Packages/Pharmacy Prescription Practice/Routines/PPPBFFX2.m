PPPBFFX2 ;BHM/DB-Build off of CD_ROM continued ;3JUL97
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**11,17,26**;APR 7, 1995
 D NOW^%DTC,YX^%DTC
 D TXT S ^TMP($J,"PPPERR",ERRTXT)=" "
 D TXT S ^TMP($J,"PPPERR",ERRTXT)=" RESULTS FROM BUILD PROCESS"
 D TXT S ^TMP($J,"PPPERR",ERRTXT)=" Build Started at   : "_STRTTM
 D TXT S ^TMP($J,"PPPERR",ERRTXT)=" Build Finished at  : "_Y
 D TXT S ^TMP($J,"PPPERR",ERRTXT)=" Last SSN processed : "_PPPEND
 D TXT S ^TMP($J,"PPPERR",ERRTXT)=" Processed "_$S($G(SSNCNT)'>0:0,1:$G(SSNCNT))_" out of "_$S($G(CNTR1)'>0:0,1:$G(CNTR1))_" SSNs"
 I $D(FACADD) D TXT S ^TMP($J,"PPPERR",ERRTXT)=" These facilities were not located in the PPP DOMAIN FILE." S X="" F  S X=$O(FACADD(X)) Q:X=""  D TXT S ^TMP($J,"PPPERR",ERRTXT)=" SITE: "_X_"  Domain: "_$S(FACADD(X)="":"Unknown",1:FACADD(X))
 ;
 I $D(FACADD) D TXT S ^TMP($J,"PPPERR",ERRTXT)=" " D TXT S ^TMP($J,"PPPERR",ERRTXT)=" Please add the above entries to the PPP DOMAIN File (#1020.8)."
SNDMAIL ;Send mail message
 S XMSUB="PHARMACY PRESCRIPTION PRACTICES",XMTEXT="^TMP("_$J_","_"""PPPERR"""_","
 S XMDUZ=.5,XMY(PPPRCVD)=""
 D ^XMD K XMDUZ
Q D Q^PPPBFFX K ^TMP($J),^TMP("PPP",$J) S ZTREQ="@" Q
TXT S ERRTXT=$G(ERRTXT)+1 Q
