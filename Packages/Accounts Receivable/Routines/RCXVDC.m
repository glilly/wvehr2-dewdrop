RCXVDC  ;DAOU/ALA-AR Data Extraction Data Creation ;02-JUL-03
        ;;4.5;Accounts Receivable;**201,228,256**;Mar 20, 1995;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
EN      ; Entry Point
        NEW RCXVD0,RCXVEVDT,RCXVBCN
        NEW RCXVI,RCXVCP,RCXVPC,RCXVPFDT,RCXVPTDT
        NEW RCXVBLNA,RCXVBLNB,RCXVICN
        I DFN="" S DFN=$P($G(^PRCA(430,RCXVBLN,0)),U,7) ;
        K ^TMP($J)
        D D430^RCXVDC1
        I DFN'="" D D2^RCXVDC2
        D D399^RCXVDC3
        D D399PC^RCXVDC4
        D D350^RCXVDC5
        D D3625^RCXVDC7
        I RCXVRT="D"!(RCXVRT="C")!(RCXVRT="E") D D433^RCXVDC6
        I RCXVRT="H" D D433B^RCXVDC6
        ;
FILE    ;
        W "REC:"_RCXVBLNA,!
        W "430:"_$G(^TMP($J,RCXVBLN,"1-430A"))_RCXVU
        W $G(^TMP($J,RCXVBLN,"1-430B"))_RCXVU
        W $G(^TMP($J,RCXVBLN,"1-430C"))
        W !
        I DFN'="" W "2:"_$G(^TMP($J,RCXVBLN,"2-2A"))_RCXVU_$G(^TMP($J,RCXVBLN,"2-2B")),!
        I $G(^TMP($J,RCXVBLN,"3-399A"))'="" W "399:"_^TMP($J,RCXVBLN,"3-399A")_RCXVU_^TMP($J,RCXVBLN,"3-399B")_RCXVU_^TMP($J,RCXVBLN,"3-399C")_RCXVU_^TMP($J,RCXVBLN,"3-399D"),!
        S RCXVPC=0
        F  S RCXVPC=$O(^TMP($J,RCXVBLN,"4-399A",RCXVPC))  Q:'RCXVPC  D
        . I $G(^TMP($J,RCXVBLN,"4-399A",RCXVPC))'="" D
        .. W "399.0304:"
        .. W $G(^TMP($J,RCXVBLN,"4-399A",RCXVPC))
        .. W RCXVU
        .. F RCXVCP=1:1 Q:('$D(^TMP($J,RCXVBLN,"4-399A",RCXVPC,RCXVCP)))  D
        ... I RCXVCP>1 W "~"
        ... W $G(^TMP($J,RCXVBLN,"4-399A",RCXVPC,RCXVCP))
        ... Q
        .. W !
        . I $G(^TMP($J,RCXVBLN,"4-399B",RCXVPC))'="" W "399.042:"_$G(^TMP($J,RCXVBLN,"4-399B",RCXVPC)),!
        . Q
        S RCXVI=""
        F  S RCXVI=$O(^TMP($J,RCXVBLN,"5-350A",RCXVI)) Q:RCXVI=""  D
        . W "350:"_^TMP($J,RCXVBLN,"5-350A",RCXVI),!
        S RCXVI=""
        F  S RCXVI=$O(^TMP($J,RCXVBLN,"7-362.5A",RCXVI)) Q:RCXVI=""  D
        . W "362.5:"_^TMP($J,RCXVBLN,"7-362.5A",RCXVI),!
        ; LOOP THRU ^TMP($J,RCXVBLN,"6-433A",RCXVI)
        S RCXVI=""
        F  S RCXVI=$O(^TMP($J,RCXVBLN,"6-433A",RCXVI)) Q:RCXVI=""  D
        . W "433:"_$G(^TMP($J,RCXVBLN,"6-433A",RCXVI)),!
        . Q
        Q
