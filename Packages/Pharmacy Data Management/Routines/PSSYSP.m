PSSYSP  ;BIR/WRT-Pharmacy system site parameters routine ;5/22/08 11:00am
        ;;1.0;PHARMACY DATA MANAGEMENT;**20,38,87,120,137,140**;9/30/97;Build 9
        ; CHANGE TYPE OF ORDER (FINISH) FROM OERR
        W ! S DIE="^PS(59.7,",DR="13;14;16;16.1;16.2;40.16;80.7",DA=1 D ^DIE
        K DIE,DA,DR W !
        Q
