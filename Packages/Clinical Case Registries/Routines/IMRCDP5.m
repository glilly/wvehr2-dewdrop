IMRCDP5 ;HCIOFO/NCA - Display CDC Form (Cont.) ;7/16/97  08:57
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !,"|   * Other (specify): "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,111.13,"E"),1:"")
 W X_$P(UNDR,"_",1,(30-$L(X))),"     ",$S(IMRPT:$$DAT^IMRCDCPX(111.14),1:"__  __"),"  |    * CD4 Percent .........    "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,111.08,"E"),1:"")
 S X=$S(X'="":$J(X,2),1:"__") W X," %                    ",$S(IMRPT:$$DAT^IMRCDCPX(111.09),1:"__  __"),"  |"
 W !,"=================================================================================================================================="
 W @IOF
 W !," =================================================  VIII. CLINICAL STATUS  ======================================================"
 W !,"| CLINICAL         YES  NO | ENTER DATE PATIENT  Asymptomatic                               Mo. Yr.      Symptomatic   Mo. Yr.   |"
 W !,"| RECORD REVIEWED  |",$S(IMRPT:$$VAL^IMRCDCPX(110.04,1),1:1),"| |",$S(IMRPT:$$VAL^IMRCDCPX(110.04,0),1:0)
 W "| | WAS DIAGNOSED AS:  (including acute retroviral syndrome and                                         |"
 W !,"|                          |                      persistant generalized lymphadenopathy):  ",$S(IMRPT:$$DAT^IMRCDCPX(112.07),1:"__  __"),"       (not AIDS):   ",$S(IMRPT:$$DAT^IMRCDCPX(112.08),1:"__  __"),"    |"
 W !,"|--------------------------------------------------------------------------------------------------------------------------------|"
 W !,"|                                         Initial       Initial |                                         Initial       Initial  |"
 W !,"|                                        Diagnosis       Date   |                                        Diagnosis       Date    |"
 W !,"|     AIDS INDICATOR DISEASES            Def.  Pres.    Mo. Yr. |     AIDS INDICATOR DISEASES            Def.  Pres.    Mo. Yr.  |"
 W !,"|---------------------------------------------------------------|----------------------------------------------------------------|"
 W !,"|Candidiasis, bronchi, trachea, or lungs  |",$S(IMRPT:$$VAL^IMRCDCPX(7,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.01),1:"__  __"),"  |"
 W "Lymphoma, Burkitt's (or equivalent term) |",$S(IMRPT:$$VAL^IMRCDCPX(8.2,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.14),1:"__  __"),"   |"
 W !,"|Candidiasis, esophageal                  |",$S(IMRPT:$$VAL^IMRCDCPX(7.1,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(7.1,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.02),1:"__  __"),"  |"
 W "Lymphoma, Immunoblastic (or equivalent                          |"
 W !,"|Carcinoma, invasive cervical             |",$S(IMRPT:$$VAL^IMRCDCPX(102.15,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.03),1:"__  __"),"  |"
 W "    term)                                |",$S(IMRPT:$$VAL^IMRCDCPX(8.3,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.15),1:"__  __"),"   |"
 W !,"|Coccidioidomycosis, disseminated or                            |Lymphoma, primary in brain               |",$S(IMRPT:$$VAL^IMRCDCPX(8.4,1),1:1),"|    NA     "
 W $S(IMRPT:$$DAT^IMRCDCPX(108.16),1:"__  __"),"   |"
 W !,"|   extrapulmonary                        |",$S(IMRPT:$$VAL^IMRCDCPX(7.2,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.04),1:"__  __"),"  |"
 W "Mycobacterium avium complex or                                  |"
 W !,"|Cryptococcosis, extrapulmonary           |",$S(IMRPT:$$VAL^IMRCDCPX(7.3,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.05),1:"__  __"),"  |"
 W "    M. kansasii, disseminated or                                |"
 W !,"|Cryptosporidiosis, chronic intestinal                          |    extrapulmonary                       |",$S(IMRPT:$$VAL^IMRCDCPX(8.5,1),1:1),"|    |"
 W $S(IMRPT:$$VAL^IMRCDCPX(8.5,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.17),1:"__  __"),"   |"
 W !,"|   (> 1 month duration)                  |",$S(IMRPT:$$VAL^IMRCDCPX(7.4,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.06),1:"__  __"),"  |"
 W "M. tuberculosis, pulmonary *             |",$S(IMRPT:$$VAL^IMRCDCPX(102.16,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(102.16,2),1:2),"|    "
 W $S(IMRPT:$$DAT^IMRCDCPX(108.18),1:"__  __"),"   |"
 D HDR^IMRCDCPR
 Q
