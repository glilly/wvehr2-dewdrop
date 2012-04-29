ONCODIS ;Hines OIFO/GWB - ONCOTRAX Banner ;05/25/00
        ;;2.11;Oncology;**6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48**;Mar 07, 1995;Build 13
MAIN    ;Begin main menu VA display
        S RC=$$CHKVER^ONCSAPIV()
        S VR=$P($T(ONCODIS+1),";",3),NM="OncoTraX" D LOGO,FUNCT Q
FUNCT   ;INTRODUCTION
        W !!?10,"Choose among the following functions:"
        Q
LOGO    ;DISPLAY LOGO
        S:'$D(IOF) IOP="HOME" D:'$D(IOF) ^%ZIS
        W *7,@IOF W !!!!!!! F I=1:1:9 W !,?22,$P($T(DISP+I),";",3)
        W !!,?23,"Department of Veterans Affairs",!!?23,NM_" V"_VR_"P48" Q
DISP    ;
        ;;VVVV            VVAA
        ;; VVVV          VVAAAA
        ;;  VVVV        VVAAAAAA
        ;;   VVVV      VVAA  AAAA
        ;;    VVVV    VVAA    AAAA
        ;;     VVVV  VVAA      AAAA
        ;;      VVVVVVAA        AAAA
        ;;       VVVVAA   AAAAAAAAAAA
        ;;        VVAA     AAAAAAAAAAA
D       W !!?30,"INSTALLATION",!!,?20,NM," PACKAGE",!!,?31,"VERSION ",VR Q
