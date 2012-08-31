PSN214E ;BHM/DB-Environment Check for PMI data updates ; 11 Aug 2009  9:46 AM
        ;;4.0; NATIONAL DRUG FILE;**214**; 30 Oct 98;Build 34
        ;
        I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
        E  W !,"You must be a valid user."
        Q
