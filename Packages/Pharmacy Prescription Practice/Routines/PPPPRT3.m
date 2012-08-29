PPPPRT3 ;ALB/GGP - PPP PRINT ROUTINE 3 ; 03/12/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ; PRINT ROUTINES FOR PHARMACY PRACTICES PROJECT
PRSTAT ;
 ;
 ; This function prints the pharmacy project statistics.
 ; fileman# 1020.3.
 ;
 N L,DIC,FLDS,BY,FR,TO,DHD,DIOEND
 ;
 S L=0,DIC="^PPP(1020.3,"
 S FLDS="[PPPSTAP]",BY="@ONE"
 S FR="",TO=""
 S DIOEND="I $E(IOST,1,2)=""C-"" W !!,""LISTING COMPLETE."" R !,""Press <RETURN> to continue..."",PPPX:DTIME K PPPX"
 D EN1^DIP
 Q 
PRLOG ;
 ; This function prints the pharmacy project logfile.
 ; fileman# 1020.4
 ;
 N L,DIC,FLDS,BY,DHD,DIOEND
 ;
 S L=0,DIC="^PPP(1020.4,"
 S FLDS="[PPP LOGP]",BY="@DATE"
 S DIOEND="I $E(IOST,1,2)=""C-"" W !!,""LISTING COMPLETE."" R !,""Press <RETURN> to continue..."",PPPX:DTIME K PPPX"
 D EN1^DIP
 Q
