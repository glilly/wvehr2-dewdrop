PSN273E ;BHM/DB-Environment Check for PMI data updates ; 09 Feb 2011  9:59 AM
        ;;4.0; NATIONAL DRUG FILE;**273**; 30 Oct 98;Build 45
        ;
        I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
        E  W !,"You must be a valid user."
        Q
