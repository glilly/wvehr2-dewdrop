ORWGTEST        ; SLC/STAFF - Graph Test Cache ;5/2/07  09:22
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
TEST    ;
        N DFN,TASKED
        ;D CLEAN^ORWGTASK
        ;D INIT^ORWGTASK(1)
        S ^XTMP("ORGDATA","TU",DUZ)=$$NOW^ORWGAPIX
        S DFN=40
        D UPDATE^ORWGTASK(.TASKED,DFN,DUZ,0)
        Q
        ;
TESTING(DATA)   ; from ORWGAPI
        N CNT,DFN,LINE,SUB,TMP,USER
        K ^TMP("ORWGRPC",$J)
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S CNT=0
        S SUB=""
        F  S SUB=$O(^XTMP("ORGDATA","Q",SUB)) Q:SUB=""  D
        . S LINE=^XTMP("ORGDATA","Q",SUB)
        . D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        S USER=""
        F  S USER=$O(^XTMP("ORGDATA","U",USER)) Q:USER=""  D
        . S LINE="u^"_USER
        . S LINE=LINE_U_+$G(^XTMP("ORGDATA","U",USER,"C"))
        . S LINE=LINE_U_+$G(^XTMP("ORGDATA","U",USER,"CG"))
        . D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        . S DFN=""
        . F  S DFN=$O(^XTMP("ORGDATA","U",USER,"C-P",DFN)) Q:DFN=""  D
        .. S LINE="u^"_USER_"^p^"_DFN
        .. S LINE=LINE_U_+$G(^XTMP("ORGDATA","U",USER,"C-P",DFN))
        .. S LINE=LINE_U_+$G(^XTMP("ORGDATA","U",USER,"CG-P",DFN))
        .. D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        S DFN=""
        F  S DFN=$O(^XTMP("ORGDATA","P",DFN)) Q:DFN=""  D
        . S LINE="p^"_DFN
        . S LINE=LINE_U_+$G(^XTMP("ORGDATA","P",DFN,"C"))
        . S LINE=LINE_U_+$G(^XTMP("ORGDATA","P",DFN,"CG"))
        . D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        . S USER=""
        . F  S USER=$O(^XTMP("ORGDATA","P",DFN,"C-P",USER)) Q:USER=""  D
        .. S LINE="p^"_DFN_"^u^"_USER
        .. S LINE=LINE_U_+$G(^XTMP("ORGDATA","P",DFN,"C-P",USER))
        .. S LINE=LINE_U_+$G(^XTMP("ORGDATA","P",DFN,"CG-P",USER))
        .. D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        S DFN=""
        F  S DFN=$O(^XTMP("ORGRAPH","LAST BUILD",DFN)) Q:DFN=""  D
        . S LINE="b^"_DFN_U_+$G(^XTMP("ORGRAPH","LAST BUILD",DFN))
        . D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        S DFN=""
        F  S DFN=$O(^XTMP("ORGRAPH","OLD DATA",DFN)) Q:DFN=""  D
        . S SUB=""
        . F  S SUB=$O(^XTMP("ORGRAPH","OLD DATA",DFN,SUB)) Q:SUB=""  D
        .. S LINE="d^"_DFN_U_SUB
        .. ;S LINE=LINE_U_$G(^XTMP("ORGRAPH","OLD DATA",DFN,SUB))
        .. S LINE=LINE_U_($L(LINE)+$L($G(^XTMP("ORGRAPH","OLD DATA",DFN,SUB))))
        .. D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        S DFN=""
        F  S DFN=$O(^XTMP("ORGRAPH","OLD LABS",DFN)) Q:DFN=""  D
        . S SUB=""
        . F  S SUB=$O(^XTMP("ORGRAPH","OLD LABS",DFN,SUB)) Q:SUB=""  D
        .. S LINE="l^"_DFN_U_SUB
        .. ;S LINE=LINE_U_$G(^XTMP("ORGRAPH","OLD LABS",DFN,SUB))
        .. S LINE=LINE_U_($L(LINE)+$L($G(^XTMP("ORGRAPH","OLD LABS",DFN,SUB))))
        .. D SETUP^ORWGAPIW(.DATA,LINE,TMP,.CNT)
        Q
