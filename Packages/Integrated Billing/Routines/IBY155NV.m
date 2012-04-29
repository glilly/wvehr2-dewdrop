IBY155NV ;ALB/ESG - IB*2*155 Environment Check ;8-Jun-2004
 ;;2.0;INTEGRATED BILLING;**155**; 21-MAR-94
 ;
 ; Check to make sure that IB patch 232 is really installed.
 ;
 I '$D(^IBA(364.7,1015)) S XPDQUIT=1       ; X12 version# field
 I $T(IBCEF2+1^IBCEF2)'[232 S XPDQUIT=1    ; output formatter rtn
 ;
 ; Display a message to the user if we can't install
 I $D(XPDQUIT) D
 . W !!,"The EDI enhancements patch - IB*2.0*232 - is not currently installed.  It may"
 . W !,"have been installed previously and then manually backed out."
 . W !!,"Patch 232 is required for the MRA functionality.  The installation of the MRA"
 . W !,"patch will now be terminated."
 . W !!
 . N DIR S DIR(0)="E" D ^DIR
 . Q
 ;
 Q
 ;
