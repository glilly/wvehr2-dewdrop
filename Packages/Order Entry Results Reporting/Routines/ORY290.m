ORY290  ;SLCOIFO - Post-init for patch OR*3*336 ; 8/3/10 1:41pm
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**336**;Dec 17, 1997;Build 24
        ;
        ; DBIA 2336   EN^XPAR   ^TMP($J,"XPARRSTR")
        ;
PRE     ; initiate pre-init environment check
        N A,I,X
        S X="VEXRX" X ^%ZOSF("TEST") E  Q
        X "ZL VEXRX F I=1:1 S A=$T(+I) Q:A=""""  I A[""^APU"" W !!,""Wrong version of VEXRX is installed."" S XPDABORT=1 Q"
        Q
POST    ; initiate post-init processes
        ;
        D PARAM
        Q
        ;
PARAM   ; parameter transport routine
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
DATA    ; parameter data
        ;;7340,"KEY")
        ;;ORB ARCHIVE PERIOD^OP RX RENEWAL REQUEST
        ;;7340,"VAL")
        ;;30
        ;;7341,"KEY")
        ;;ORB DELETE MECHANISM^OP RX RENEWAL REQUEST
        ;;7341,"VAL")
        ;;All Recipients
        ;;7342,"KEY")
        ;;ORB FORWARD BACKUP REVIEWER^OP RX RENEWAL REQUEST
        ;;7342,"VAL")
        ;;0
        ;;7343,"KEY")
        ;;ORB FORWARD SUPERVISOR^OP RX RENEWAL REQUEST
        ;;7343,"VAL")
        ;;0
        ;;7344,"KEY")
        ;;ORB FORWARD SURROGATES^OP RX RENEWAL REQUEST
        ;;7344,"VAL")
        ;;0
        ;;7345,"KEY")
        ;;ORB PROCESSING FLAG^OP RX RENEWAL REQUEST
        ;;7345,"VAL")
        ;;Disabled
        ;;7346,"KEY")
        ;;ORB PROVIDER RECIPIENTS^OP RX RENEWAL REQUEST
        ;;7346,"VAL")
        ;;OAPT
        ;;7347,"KEY")
        ;;ORB URGENCY^OP RX RENEWAL REQUEST
        ;;7347,"VAL")
        ;;High
