DGBT1P16        ;RLS/RLS - BENE TRAVEL RATES UPDATE DGBT*1*16 POST-INIT ; 10/14/08 10:45
        ;;1.0;Beneficiary Travel;**16**;September 25, 2001;Build 1
        ;
        Q
EN      ;
        D START,UPDATE,FINISH
        Q
        ;
START   D BMES^XPDUTL("Insert Bene Travel 2009 rates, Post-Install Starting")
        Q
        ;
FINISH  D BMES^XPDUTL("Insert Bene Travel 2009 rates, Post-Install Complete")
        Q
        ;
UPDATE  ;Insert 11172008 record
        ;ESTABLISH THE RECORD
        N DO,DIC,DIE,X,Y,DINUM,DR,DA
        I $D(^DG(43.1,6918882.9999,0)) D  Q  ;9'S INVERSE OF EFFECTIVE DATE
        . D BMES^XPDUTL("Rate record already exists, exiting")
        S DIC="^DG(43.1,",DIC(0)="E",X=3081117,DINUM=9999999.9999-X
        D FILE^DICN
        ;
        ;NOW EDIT THE REST OF THE FIELDS
        S DIE=DIC,DR="30.01///15.54;30.02///46.62;30.03///.415;30.05///.415"
        S DA=+Y
        D ^DIE
        D BMES^XPDUTL("Added 11172008 RATES record to MAS EVENT RATES file")
        Q
        ;
