YS85PRE ;ALB/ASF-YS 501 PATCH 85 PRE ; 6/14/07 9:57am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        ; initialize national areas
        ;
        K DIF,DIK,D,DDF,DDT,DTO,D0,DLAYGO,DIC,DIDUZ,DIR,DA,DFR,DTN,DIX,DZ D DT^DICRW S %=1,U="^",DSEC=1
        N YSEX
        D DT^DICRW K ^UTILITY(U,$J),^UTILITY("DIK",$J)
ENT     ;
        F YSEX=71,72,73,74,75,751,76,77,781,79,81,82,83,86,87,88,89,91,93 D
        . S DIK="^YTT(601."_YSEX_","
        . S DA=0 F  S DA=$O(^YTT("601."_YSEX,DA)) Q:DA'>0!(DA>99999)  D ^DIK
