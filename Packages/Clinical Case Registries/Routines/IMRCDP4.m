IMRCDP4 ;HCIOFO/NCA - Display CDC Form (Cont.) ;7/16/97  08:56
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !,"======================================================== VI. LABORATORY DATA ===================================================="
 W !,"| 1. HIV ANTIBODY TESTS AT DIAGNOSIS:              Not Test Date |                                                       Mo. Yr. |"
 W !,"|    (Indicate FIRST test)          Pos  Neg  Ind  Done  Mo. Yr. | * Date of last documented NEGATIVE HIV test           ",$S(IMRPT:$$DAT^IMRCDCPX(111.01),1:"__  __"),"  |"
 W !,"|   * HIV-1 EIA ................... |",$S(IMRPT:$$VAL^IMRCDCPX(9.4,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(9.4,0),1:0),"|   -   |"
 W $S(IMRPT:$$VAL^IMRCDCPX(9.4,9),1:9),"|   ",$S(IMRPT:$$DAT^IMRCDCPX(108.27),1:"__  __"),"  |   (specify type): "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,111.02,"E"),1:"") W X_$P(UNDR,"_",1,(30-$L(X))),"               |"
 W !,"|   * HIV-1/HIV-2 combination EIA . |",$S(IMRPT:$$VAL^IMRCDCPX(110.17,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(110.17,0),1:0)
 W "|   -   |",$S(IMRPT:$$VAL^IMRCDCPX(110.17,9),1:9),"|   ",$S(IMRPT:$$DAT^IMRCDCPX(110.18),1:"__  __"),"  | * If HIV laboratory tests were not documented,  Yes  No   Unk.|"
 W !,"|   * HIV-1 Western blot/IFA ...... |",$S(IMRPT:$$VAL^IMRCDCPX(9.5,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(9.5,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(9.5,8),1:8),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(9.5,9),1:9),"|   ",$S(IMRPT:$$DAT^IMRCDCPX(108.28),1:"__  __")
 W "  |   is HIV diagnosis documented by a physician?   |",$S(IMRPT:$$VAL^IMRCDCPX(111.03,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(111.03,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(111.03,9),1:9),"| |"
 W !,"|   * Other HIV antibody test ..... |",$S(IMRPT:$$VAL^IMRCDCPX(9.6,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(9.6,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(9.6,8),1:8)
 W "|  |",$S(IMRPT:$$VAL^IMRCDCPX(9.6,9),1:9),"|   ",$S(IMRPT:$$DAT^IMRCDCPX(108.29),1:"__  __"),"  | * If yes, provide date of documentation by physician  ",$S(IMRPT:$$DAT^IMRCDCPX(111.04),1:"__  __"),"  |"
 W !,"|         (specify): " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,9.7,"E"),1:"")
 W X_$P(UNDR,"_",1,(25-$L(X))),"                    |===============================================================|"
 W !,"|   * HIV-2 EIA ................... |",$S(IMRPT:$$VAL^IMRCDCPX(102.2,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(102.2,0),1:0),"|   -   |"
 W $S(IMRPT:$$VAL^IMRCDCPX(102.2,9),1:8),"|   ",$S(IMRPT:$$DAT^IMRCDCPX(108.3),1:"__  __"),"  | 3. IMMUNOLOGIC LAB TESTS:                                     |"
 W !,"|   * HIV-2 Western blot .......... |",$S(IMRPT:$$VAL^IMRCDCPX(110.19,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(110.19,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.19,8),1:8),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(110.19,9),1:9),"|   ",$S(IMRPT:$$DAT^IMRCDCPX(110.2),1:"__  __")
 W "  |    At or closest to current diagnostic status         Mo. Yr. |"
 W !,"| 2. POSITIVE HIV DETECTION TEST: (Record earliest test)         |    * CD4 Count ........... "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,102.21,"E"),1:0)
 S X=$S(X>0:$J(X,5),1:"_,___") W X," cells/uL             ",$S(IMRPT:$$DAT^IMRCDCPX(108.31),1:"__  __"),"  |"
 W !,"|   * HIV culture .....................................  ",$S(IMRPT:$$DAT^IMRCDCPX(111.1),1:"__  __"),"  |    * CD4 Percent .........    "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,102.22,"E"),1:0)
 S X=$S(X>0:$J(X,2),1:"__") W X," %                    ",$S(IMRPT:$$DAT^IMRCDCPX(111.05),1:"__  __"),"  |"
 W !,"|   * HIV antigen test ................................  ",$S(IMRPT:$$DAT^IMRCDCPX(111.11),1:"__  __"),"  |    First <200 uL or <14%                                      |"
 W !,"|   * HIV PCR, DNA or RNA probe .......................  ",$S(IMRPT:$$DAT^IMRCDCPX(111.12),1:"__  __"),"  |    * CD4 Count ........... "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,111.06,"E"),1:"")
 S X=$S(X'="":$J(X,5),1:"_,___") W X," cells/uL             ",$S(IMRPT:$$DAT^IMRCDCPX(111.07),1:"__  __"),"  |"
 D HDR^IMRCDCPR
 Q
