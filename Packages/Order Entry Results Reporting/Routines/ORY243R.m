ORY243R  ;SLCOIFO - Pre and Post-init for patch OR*3*243 ;4/25/07  14:12
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
        ; DBIA 2336   EN^XPAR   ^TMP($J,"XPARRSTR")
        ;
PARAM   ; DO NOT REMOVE WITH VBECS - main (initial) parameter transport routine
        K ^TMP($J,"XPARRSTR")
        N ENT,IDX,ROOT,REF,VAL,I
        S ROOT=$NAME(^TMP($J,"XPARRSTR")),ROOT=$E(ROOT,1,$L(ROOT)-1)_","  ;DBIA 2336
        D LOAD
XX2     S IDX=0,ENT="PKG."_"ORDER ENTRY/RESULTS REPORTING"
        F  S IDX=$O(^TMP($J,"XPARRSTR",IDX)) Q:'IDX  D
        . N PAR,INST,ORVAL,ORERR K ORVAL
        . S PAR=$P(^TMP($J,"XPARRSTR",IDX,"KEY"),U),INST=$P(^("KEY"),U,2)
        . M ORVAL=^TMP($J,"XPARRSTR",IDX,"VAL")
        . D EN^XPAR(ENT,PAR,INST,.ORVAL,.ORERR)  ;DBIA 2336
        K ^TMP($J,"XPARRSTR")
        Q
LOAD    ; load data into ^TMP (expects ROOT to be defined)
        S I=1 F  S REF=$T(DATA+I) Q:REF=""  S VAL=$T(DATA+I+1) D
        . S I=I+2,REF=$P(REF,";",3,999),VAL=$P(VAL,";",3,999)
        . S @(ROOT_REF)=VAL
        Q
        ;
DATA    ; parameter data
        ;;7240,"KEY")
        ;;ORB ARCHIVE PERIOD^MEDICATIONS EXPIRING - OUTPT
        ;;7240,"VAL")
        ;;30
        ;;7241,"KEY")
        ;;ORB DELETE MECHANISM^MEDICATIONS EXPIRING - OUTPT
        ;;7241,"VAL")
        ;;All Recipients
        ;;7242,"KEY")
        ;;ORB FORWARD BACKUP REVIEWER^MEDICATIONS EXPIRING - OUTPT
        ;;7242,"VAL")
        ;;0
        ;;7243,"KEY")
        ;;ORB FORWARD SUPERVISOR^MEDICATIONS EXPIRING - OUTPT
        ;;7243,"VAL")
        ;;0
        ;;7244,"KEY")
        ;;ORB FORWARD SURROGATES^MEDICATIONS EXPIRING - OUTPT
        ;;7244,"VAL")
        ;;0
        ;;7245,"KEY")
        ;;ORB PROCESSING FLAG^MEDICATIONS EXPIRING - OUTPT
        ;;7245,"VAL")
        ;;Disabled
        ;;7246,"KEY")
        ;;ORB PROVIDER RECIPIENTS^MEDICATIONS EXPIRING - OUTPT
        ;;7246,"VAL")
        ;;OAPT
        ;;7247,"KEY")
        ;;ORB URGENCY^MEDICATIONS EXPIRING - OUTPT
        ;;7247,"VAL")
        ;;High
        ;;6064,"KEY")
        ;;ORWOR EXPIRED ORDERS^1
        ;;6064,"VAL")
        ;;72
        ;;11559,"KEY")
        ;;ORWLR LC CHANGED TO WC^1
        ;;11559,"VAL")
        ;;Please contact the ward staff to insure the specimen is collected.
        ;;11560,"KEY")
        ;;OR VBECS SUPPRESS NURS ADMIN
        ;;11560,"VAL")
        ;;0
