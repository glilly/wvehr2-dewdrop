SDRRISB ;10N20/MAH;Recall Reminder appointments ;01/15/2008 07:35
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ; 
        ; 
CLINLIST(SDRRCLIST)     ;
        N SDRRDIEN,SDRRCLIN
        S (SDRRDIEN,SDRRCLIN)=""
        F  S SDRRDIEN=$O(^TMP("SDRR",$J,"DIV",SDRRDIEN)) Q:SDRRDIEN=""  D
        . F  S SDRRCLIN=$O(^TMP("SDRR",$J,"DIV",SDRRDIEN,"CLIN",SDRRCLIN)) Q:SDRRCLIN=""  S SDRRCLIST(+^(SDRRCLIN))=SDRRCLIN
        Q
