ORAMY   ; ISL/JER - Anticoagulation Management Installation ;12/16/09  15:31
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**307**;Dec 17, 1997;Build 60
        ;;Per VHA Directive 2004-038, this routine should not be modified
        Q
POST    ; Post-install routine
        D ATTRPT
        D REGRPCS
        D PARAM
        Q
ATTRPT  ; Set Anticoagulation Flowsheet Report as item in ORRPW REPORT CATEGORIES
        N ORRIEN,ORRNM,ORERRF,ORFDA,ORAFIEN,ORAFNM,ORLNE
        N ORMSG,ORTXT
        K ORMSG
        D BMES^XPDUTL(" Attaching Anticoagulation Flowsheet to ORRPW REPORT CATEGORIES...")
        S ORRNM="ORRPW REPORT CATEGORIES"
        S ORRIEN=$$FIND1^DIC(101.24,"","X",ORRNM,"","","")
        ;If ORRPW REPORT CATEGORIES not found, error
        I ORRIEN'>0 D  I 1
        . S ORMSG(1)="**"
        . S ORMSG(2)="** "_ORRNM_" not found **"
        . S ORMSG(3)="**"
        . D MES^XPDUTL(.ORMSG) K ORMSG
        . S ORERRF=1
        ELSE  D
        . S ORAFNM="ORAM ANTICOAG REPORT"
        . S ORAFIEN=$$FIND1^DIC(101.24,"","X",ORAFNM,"","","")
        . ;If ORAM ANTICOAG REPORT not found, error
        . I ORAFIEN'>0 D  Q
        . . S ORMSG(1)="**"
        . . S ORMSG(2)="** "_ORAFNM_" not found **"
        . . S ORMSG(3)="**"
        . . D MES^XPDUTL(.ORMSG) K ORMSG
        . . S ORERRF=1
        . ;Attach ORAM ANTICOAG REPORT to ORRPW REPORT CATEGORIES
        . N ORFDA,ORIEN,ORMSG
        . S ORFDA(101.241,"?+10,"_ORRIEN_",",.01)=ORAFIEN
        . D UPDATE^DIE("","ORFDA","ORIEN","ORMSG")
        . ;Check for error
        . I $D(ORMSG("DIERR")) D  Q
        . . S ORMSG(1)="**"
        . . S ORMSG(2)="** Unable to attach "_ORAFNM_" to "_ORRNM_" **"
        . . S ORMSG(3)="**"
        . . D MES^XPDUTL(.ORMSG) K ORMSG
        . . S ORERRF=1
        . S ORMSG(1)=" "
        . S ORMSG(2)=" ... "_ORAFNM_$S($G(ORIEN(10,0))="?":" already",1:"")_" attached to "_ORRNM_" ..."
        . D MES^XPDUTL(.ORMSG) K ORMSG
        ;Check for error
        I $G(ORERRF) D
        . S ORMSG(1)="** Post-installation interrupted"
        . S ORMSG(2)="** Please contact Enterprise VistA Support"
        . D MES^XPDUTL(.ORMSG) K ORMSG
        Q
        ;
REGRPCS ; Register RPCS
        D BMES^XPDUTL(" Registering RPCs with Context Menu ORAM ANTICOAGULATION CONTEXT...")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","ORWPCE SCDIS")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","ORWPCE SCSEL")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","ORWTPP GETCOS")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","ORWTPP GETDCOS")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","TIU SIGN RECORD")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","TIU CREATE RECORD")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","TIU DELETE RECORD")
        D REGISTER("ORAM ANTICOAGULATION CONTEXT","TIU REQUIRES COSIGNATURE")
        Q
        ;
REGISTER(OPTION,RPC)    ; Call FM Updater to register each RPC
        ; Input  -- OPTION   Option file (#19) Name field (#.01)
        ;           RPC      RPC sub-file (#19.05) RPC field (#.01)
        ; Output -- None
        N FDA,FDAIEN,ERR,DIERR
        S FDA(19,"?1,",.01)=OPTION
        S FDA(19.05,"?+2,?1,",.01)=RPC
        D UPDATE^DIE("E","FDA","FDAIEN","ERR")
        Q
PARAM   ; main (initial) parameter transport routine
        N ORENT,IDX,ROOT,REF,ORVAL,I
        D BMES^XPDUTL(" Installing List of Indications for Care...")
        S ROOT=$NAME(^TMP("ORAMY",$J)) K @ROOT
        D LOAD(ROOT)
        S IDX=0,ORENT="PKG.ORDER ENTRY/RESULTS REPORTING"
        F  S IDX=$O(@ROOT@(IDX)) Q:'IDX  D
        . N ORPAR,ORINST,ORIVAL,OREVAL,ORERR
        . S ORPAR=$P(@ROOT@(IDX,"KEY"),U),ORINST=$P(^("KEY"),U,2)
        . S ORIVAL=$P(@ROOT@(IDX,"VAL"),U),OREVAL=$P(^("VAL"),U,2)
        . D BMES^XPDUTL(" Installing "_ORINST_" = "_OREVAL)
        . D EN^XPAR(ORENT,ORPAR,ORINST,ORIVAL,.ORERR)
        . I +$G(ORERR)>0 D BMES^XPDUTL(" Error Occurred for "_ORINST_" = "_OREVAL_": "_$P(ORERR,U,2))
        K @ROOT
        Q
LOAD(ROOT)      ; load data into ^TMP (expects ROOT to be defined)
        N I,REF
        S I=1,ROOT=$E(ROOT,1,$L(ROOT)-1)_","
        F  S REF=$P($T(DATA+I),";",3,999) Q:REF=""  D
        . N ORVAL
        . S ORVAL=$P($T(DATA+I+1),";",3,999)
        . S @(ROOT_REF)=ORVAL,I=I+2
        Q
DATA    ; parameter data
        ;;14701,"KEY")
        ;;ORAM INDICATIONS FOR CARE^A Fib
        ;;14701,"VAL")
        ;;`2557^427.31
        ;;14702,"KEY")
        ;;ORAM INDICATIONS FOR CARE^A Flutter
        ;;14702,"VAL")
        ;;`2558^427.32
        ;;14703,"KEY")
        ;;ORAM INDICATIONS FOR CARE^CVA
        ;;14703,"VAL")
        ;;`9069^436.
        ;;14704,"KEY")
        ;;ORAM INDICATIONS FOR CARE^DVT
        ;;14704,"VAL")
        ;;`15011^453.89
        ;;14705,"KEY")
        ;;ORAM INDICATIONS FOR CARE^Hypercoag State
        ;;14705,"VAL")
        ;;`13798^289.81
        ;;14706,"KEY")
        ;;ORAM INDICATIONS FOR CARE^PE
        ;;14706,"VAL")
        ;;`13157^415.19
        ;;14707,"KEY")
        ;;ORAM INDICATIONS FOR CARE^TIA
        ;;14707,"VAL")
        ;;`2591^435.9
        ;;14708,"KEY")
        ;;ORAM INDICATIONS FOR CARE^Valve-Tissue
        ;;14708,"VAL")
        ;;`11516^V42.2
        ;;14709,"KEY")
        ;;ORAM INDICATIONS FOR CARE^Valve-Mech
        ;;14709,"VAL")
        ;;`11527^V43.3
        ;;14710,"KEY")
        ;;ORAM INDICATIONS FOR CARE^L/T (Current) Anticoag Use
        ;;14710,"VAL")
        ;;`13194^V58.61
        ;;14711,"KEY")
        ;;ORAM INDICATIONS FOR CARE^Enctr for Tx Drug Monitoring
        ;;14711,"VAL")
        ;;`13529^V58.83
