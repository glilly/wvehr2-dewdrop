IMRCDP7 ;HCIOFO/NCA - Display CDC Form (Cont.) ;7/16/97  08:58
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !," ================================================  IX. TREATMENT/SERVICES REFERRALS  ============================================"
 W !,"| Has this patient been informed of his/her HIV infection?  |",$S(IMRPT:$$VAL^IMRCDCPX(110.06,1),1:1),"| Yes  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.06,0),1:0),"| No  |",$S(IMRPT:$$VAL^IMRCDCPX(110.06,9),1:9)
 W "| Unk. | This patient is receiving or             |"
 W !,"|                                                                                     | has been referred for:   Yes  No  Unk.   |"
 W !,"| This patient's partners will be notified about their HIV exposure and counseled by: | * HIV related medical services           |"
 W !,"|   |",$S(IMRPT:$$VAL^IMRCDCPX(110.07,1),1:1),"| Health department    |",$S(IMRPT:$$VAL^IMRCDCPX(110.07,2),1:2),"| Physician/provider    |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.07,3),1:3)
 W "| Patient    |",$S(IMRPT:$$VAL^IMRCDCPX(110.07,9),1:9),"| Unknown     | * Substance abuse treatment services     |"
 W !?1,LN
 W !,"| This patient received or is receiving:  | This patient has been enrolled at:        | This patient's medical treatment is      |"
 W !,"|  * Anti-retroviral    Yes  No   Unk.    |  Clinical Trial       Clinic              |  PRIMARILY reimbursed by:                |"
 W !,"|    therapy",?24,"|",$S(IMRPT:$$VAL^IMRCDCPX(110.08,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(110.08,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.08,9),1:9),"|     |  |",$S(IMRPT:$$VAL^IMRCDCPX(110.1,1),1:1)
 W "| NIH-sponsored    |",$S(IMRPT:$$VAL^IMRCDCPX(110.11,1),1:1),"| HRSA-sponsored  |  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.12,1),1:1),"| Medicaid     |",$S(IMRPT:$$VAL^IMRCDCPX(110.12,2),1:2),"| Private ins/HMO    |"
 W !,"|                                         |  |",$S(IMRPT:$$VAL^IMRCDCPX(110.1,2),1:2),"| Other            |",$S(IMRPT:$$VAL^IMRCDCPX(110.11,2),1:2)
 W "| Other           |  |",$S(IMRPT:$$VAL^IMRCDCPX(110.12,3),1:3),"| No coverage  |",$S(IMRPT:$$VAL^IMRCDCPX(110.12,4),1:4),"| Other public funds |"
 W !,"|                       Yes  No   Unk.    |  |",$S(IMRPT:$$VAL^IMRCDCPX(110.1,3),1:3),"| None             |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.11,3),1:3),"| None            |  |",$S(IMRPT:$$VAL^IMRCDCPX(110.12,7),1:7)
 W "| Clinical     |",$S(IMRPT:$$VAL^IMRCDCPX(110.12,9),1:9),"| Unknown            |"
 W !,"|  * PCP prophylaxis    |",$S(IMRPT:$$VAL^IMRCDCPX(110.09,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(110.09,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.09,9),1:9),"|     |  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.1,9),1:9),"| Unknown          |",$S(IMRPT:$$VAL^IMRCDCPX(110.11,9),1:9),"| Unknown         |      trial/government program            |"
 W !?1,LN
 W !,"| FOR WOMEN: *This patient is receiving or has been referred for gynecological or obstetrical services: . |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.13,1),1:1),"|Yes  |",$S(IMRPT:$$VAL^IMRCDCPX(110.13,0),1:0),"|No  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.13,9),1:9),"|Unk  |"
 W !,"|            *Is this patient currently pregnant? ....................................................... |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.14,1),1:1),"|Yes  |",$S(IMRPT:$$VAL^IMRCDCPX(110.14,0),1:0),"|No  |",$S(IMRPT:$$VAL^IMRCDCPX(110.14,9),1:9),"|Unk  |"
 W !,"|            *Has this patient delivered live born infants? ...  |",$S(IMRPT:$$VAL^IMRCDCPX(110.15,1),1:1),"|Yes (If delivered after 1977, provide birth   |"
 W $S(IMRPT:$$VAL^IMRCDCPX(110.15,0),1:0),"|No  |",$S(IMRPT:$$VAL^IMRCDCPX(110.15,9),1:9),"|Unk  |"
 W !,"|",?73,"information below for the most recent birth)            |"
 W !?1,LN
 W !,"| CHILD'S DATE OF BIRTH:  | Hospital of Birth: "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,112.02,"E"),1:"") W X_$P(UNDR,"_",1,(23-$L(X))),"   |  Child's Soundex:        | Child's State Patient No.   |"
 W !,"|     Mo.  Day  Yr.       |                                             |   | | | | |  __________  |  | | | | | | | | | | |      |"
 W !,"|     " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,112.01,"I"),1:"")
 I X'="" S X=$E(X,4,5)_"   "_$E(X,6,7)_"   "_$E(X,2,3)
 W $S(X="":"            ",1:X),"        | City: " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,112.03,"E"),1:"") W X_$P(UNDR,"_",1,(23-$L(X)))," State: "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,112.04,"E"),1:"") W X_$P(UNDR,"_",1,(3-$L(X))),"      |",?99,"|",?129,"|"
 D HDR^IMRCDCPR
 Q
