IMRCDP3 ;HCIOFO/NCA - Display CDC Form (Cont.) ;7/16/97  08:55
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !,"| State/Country                |  | * Received clotting factor for hemophilia/coagulation disorder .............  |",$S(IMRPT:$$VAL^IMRCDCPX(15.9,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(15.9,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(15.9,9),1:9),"|  |"
 W !,"|                              |  |       Specify disorder:  |",$S(IMRPT:$$VAL^IMRCDCPX(16.12,1),1:1),"| Factor VIII  |",$S(IMRPT:$$VAL^IMRCDCPX(16.12,2),1:2),"| Factor IX     |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.12,8),1:8),"| Other                        |"
 W !,"| FACILITY SETTING (check one) |  | *                            (Hemophilia A)   (Hemophilia B)    (specify): "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.13,"E"),1:"") W X_$P(UNDR,"_",1,(15-$L(X))),"    |"
 W !,"| |",$S(IMRPT:$$VAL^IMRCDCPX(110.16,1),1:1),"| Public  |",$S(IMRPT:$$VAL^IMRCDCPX(110.16,2),1:2),"| Private      |  | * HETEROSEXUAL relations with any of the following:                                          |"
 W !,"| |",$S(IMRPT:$$VAL^IMRCDCPX(110.16,3),1:3),"| Federal |",$S(IMRPT:$$VAL^IMRCDCPX(110.16,9),1:9),"| Unknown      |  |   * Intravenous/injection drug user ........................................  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.22,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.22,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.22,9),1:9),"|  |"
 W !,"|                              |  |   * Bisexual male ..........................................................  |",$S(IMRPT:$$VAL^IMRCDCPX(16.23,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.23,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.23,9),1:9),"|  |"
 W !,"|                              |  |   * Person with hemophilia/coagulation disorder ............................  |",$S(IMRPT:$$VAL^IMRCDCPX(16.24,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.24,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.24,9),1:9),"|  |"
 W !,"| FACILITY TYPE (check one)    |  |   * Transfusion recipient with documented HIV infection ....................  |",$S(IMRPT:$$VAL^IMRCDCPX(16.25,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.25,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.25,9),1:9),"|  |"
 W !,"| |",$S(IMRPT:$$VAL^IMRCDCPX(112.06,"01"),1:"01"),"| Physician,HMO           |  |   * Transplant recipient with documented HIV infection .....................  |",$S(IMRPT:$$VAL^IMRCDCPX(110.03,1),1:1),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.03,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(110.03,9),1:9),"|  |"
 W !,"| |",$S(IMRPT:$$VAL^IMRCDCPX(112.06,31),1:31),"| Hospital,Inpatient      |  |   * Person with AIDS or documented HIV infection, risk not specified .......  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.26,1),1:1),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.26,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.26,9),1:9),"|  |"
 W !,"| |",$S(IMRPT:$$VAL^IMRCDCPX(112.06,88),1:88),"| Other (specify):        |  | * Received transfusion of blood/blood components (other than clotting factor) |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.14,1),1:1)
 W "|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.14,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.14,9),1:9),"|  |"
 W !,"|      " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,102.1,"E"),1:"")
 W X_$P(UNDR,"_",1,(22-$L(X))),"   |  |                                   Mo.   Yr.                  Mo.  Yr.",?129,"|"
 W !,"                                  |                           FIRST   ",IMRFT,"            LAST   ",IMRLT,?129,"|"
 W !,"                                  | * Received transplant of tissue/organs or artificial insemination ..........  |",$S(IMRPT:$$VAL^IMRCDCPX(102.14,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(102.14,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(102.14,9),1:9),"|  |"
 W !,"                                  | * Worked in a health-care or clinical laboratory setting ...................  |",$S(IMRPT:$$VAL^IMRCDCPX(16.17,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.17,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.17,9),1:9),"|  |"
 W !,"                                  |     (specify occupation): "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.18,"E"),1:"")
 W X_$P(UNDR,"_",1,(15-$L(X))),?129,"|"
 W !,"                                   ================================"
 W "=============================================================="
 D HDR^IMRCDCPR
 Q
