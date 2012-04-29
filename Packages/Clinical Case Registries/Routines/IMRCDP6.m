IMRCDP6 ;HCIOFO/NCA - Display CDC Form (Cont.) ;7/16/97  08:58
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !,"|Cytomegalovirus disease (other than in                         |M. tuberculosis, disseminated                                   |"
 W !,"|   liver, spleen or nodes)               |",$S(IMRPT:$$VAL^IMRCDCPX(7.5,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.07),1:"__  __"),"  |"
 W "    or extrapulmonary *                  |",$S(IMRPT:$$VAL^IMRCDCPX(8.6,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(8.6,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.19),1:"__  __"),"   |"
 W !,"|Cytomegalovirus retinitis (with loss of                        |Mycobacterium, of other species or                              |"
 W !,"|   vision)                               |",$S(IMRPT:$$VAL^IMRCDCPX(7.6,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(7.6,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.08),1:"__  __"),"  |"
 W "    unidentified species, disseminated                          |"
 W !,"|HIV encephalopathy                       |",$S(IMRPT:$$VAL^IMRCDCPX(7.7,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.09),1:"__  __")
 W "  |    or extrapulmonary                    |",$S(IMRPT:$$VAL^IMRCDCPX(8.7,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(8.7,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.2),1:"__  __"),"   |"
 W !,"|Herpes simplex: chronic ulcer(s) (>1 mo.                       |Pneumocystis carinii pneumonia           |"
 W $S(IMRPT:$$VAL^IMRCDCPX(8.8,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(8.8,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.21),1:"__  __"),"   |"
 W !,"|   duration); or bronchitis, pneumonitis,                      |Penumonia, recurrent in 12 mo. period    |",$S(IMRPT:$$VAL^IMRCDCPX(102.17,1),1:1),"|    |"
 W $S(IMRPT:$$VAL^IMRCDCPX(102.17,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.22),1:"__  __"),"   |"
 W !,"|   or esophagitis                        |",$S(IMRPT:$$VAL^IMRCDCPX(7.8,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.1),1:"__  __"),"  |"
 W "Progressive multifocal                                          |"
 W !,"|Histoplasmosis, disseminated or                                |    leukoencephalopathy                  |",$S(IMRPT:$$VAL^IMRCDCPX(8.9,1),1:1)
 W "|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.23),1:"__  __"),"   |"
 W !,"|   extrapulmonary                        |",$S(IMRPT:$$VAL^IMRCDCPX(7.9,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.11),1:"__  __"),"  |"
 W "Salmonella septicemia, recurrent         |",$S(IMRPT:$$VAL^IMRCDCPX(9,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.24),1:"__  __"),"   |"
 W !,"|Isosporiasis, chronic intestinal (>1 mo.                       |Toxoplasmosis of brain                   |"
 W $S(IMRPT:$$VAL^IMRCDCPX(9.1,1),1:1),"|    |",$S(IMRPT:$$VAL^IMRCDCPX(9.1,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.25),1:"__  __"),"   |"
 W !,"|   duration)                             |",$S(IMRPT:$$VAL^IMRCDCPX(8,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.12),1:"__  __"),"  |",?129,"|"
 W !,"|Kaposi's sarcoma                         |",$S(IMRPT:$$VAL^IMRCDCPX(8.1,1),1:1),"|    |"
 W $S(IMRPT:$$VAL^IMRCDCPX(8.1,2),1:2),"|    ",$S(IMRPT:$$DAT^IMRCDCPX(108.13),1:"__  __"),"  |Wasting Syndrome due to HIV              |"
 W $S(IMRPT:$$VAL^IMRCDCPX(9.2,1),1:1),"|    NA     ",$S(IMRPT:$$DAT^IMRCDCPX(108.26),1:"__  __"),"   |"
 W !,"|---------------------------------------------------------------|----------------------------------------------------------------|"
 W !,"|     Def.=definitive diagnosis  Pres.=presumptive diagnosis    |    * RVCT CASE NO.: _______________                            |"
 S LN="",$P(LN,"-",129)="" W !?1,LN
 W !,"| * If HIV tests were not positive or were not done, does this patient have                                                      |"
 W !,"|   an immunodeficiency that would disqualify him/her from the AIDS case definition          |",$S(IMRPT:$$VAL^IMRCDCPX(110.05,1),1:1),"| Yes  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.05,0),1:0),"| No |",$S(IMRPT:$$VAL^IMRCDCPX(110.05,9),1:9),"| Unknown         |"
 W !?1,LN
 D HDR^IMRCDCPR
 Q
