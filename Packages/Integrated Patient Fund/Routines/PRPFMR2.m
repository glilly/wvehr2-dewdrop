PRPFMR2 ;BAYPINES/MJE  VPFS APP PROXY CREATOR ;06/15/05
        ;;3.0;PATIENT FUNDS - MIGRATION 5.0;**16**;JUNE 1, 1989
        ;ENTRY AT LINETAG ONLY
        Q
ADDPROXY        ; add VPFS application proxy user account if not present
        ; depends on XU*8*361
        N XOBID
        W !,""
        W !," ****************** PROXY INSTALL RESULT ******************************"
        S XOBID=$$CREATE^XUSAP("VPFS,APPLICATION PROXY","","DGRR PATIENT SERVICE QUERY","")
        I (+XOBID)>0 D
        .W !," THE VPFS APPLICATION PROXY USER ACCOUNT HAS BEEN SUCCESSFULLY CREATED!"
        I (+XOBID)=0 D
        .W !," WARNING: THE VPFS APPLICATION PROXY USER ACCOUNT ALREADY PRESENT!!"
        I (+XOBID)<0 D
        .W !," ERROR: THE VPFS APPLICATION PROXY USER ACCOUNT COULD NOT BE CREATED!!!"
        W !," **********************************************************************"
        W !,""
        K XOBID
