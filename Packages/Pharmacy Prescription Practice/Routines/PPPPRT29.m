PPPPRT29 ;ALB/JFP - PPP,FFX DISPLAY DATA (GENERIC);01MAR93
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
EP ; -- Main entry point for the list processor
 ; (only kill on the first screen in)
 K XQORS,VALMEVL
 ;
 N X,HDRLN
 ;
 D EN^VALM("PPP FFX REPORTS")
 QUIT
 ;
INIT ; -- Initializes variables and defines screen
 I '$D(^TMP("PPPL6",$J)) D  QUIT
 .S VALMCNT=0
 .S X=$$SETSTR^VALM1(" ","",1,79) D TMP
 .S X=$$SETSTR^VALM1("  ** No Data to Display ... <Return> to exit ","",1,79)
 .D TMP
 QUIT
 ;
TMP ; -- Set the array used by list processor
 S VALMCNT=VALMCNT+1
 S ^TMP("PPPL6",$J,VALMCNT,0)=$E(X,1,79)
 QUIT
 ;
HDR ; -- Make header line for list processor
 ;
 I '$D(^TMP("PPPL6",$J,"HDR")) QUIT
 S HDRLN=""
 F HDRLN=0:0 S HDRLN=$O(^TMP("PPPL6",$J,"HDR",HDRLN))  Q:HDRLN=""  D
 .S VALMHDR(HDRLN)=^TMP("PPPL6",$J,"HDR",HDRLN)
 QUIT
 ;
FNL ; -- Note: The list processor cleans up its own variables.
 ;          All other variables cleaned up here.
 ;
 K ^TMP("PPPL6",$J)
 K VALMCNT
 QUIT
 ;
END ; -- End of code
 QUIT
