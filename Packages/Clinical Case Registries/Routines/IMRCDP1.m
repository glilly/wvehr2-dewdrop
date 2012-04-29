IMRCDP1 ;HCIOFO/NCA - Display CDC Form ;7/16/97  08:53
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 W:'($E(IOST,1,2)'="C-"&IMRCOPI'>1) @IOF
 W !,"I. STATE/LOCAL USE ONLY"
 W !!,"Patient's Name: ",IMRNAM,?94,"Phone No.: ",IMRPTEL,!," (Last, First, M.I.)",!?114,"Zip",!
 W "Address: ",IMRADDR,?41,"City: ",IMRADDR2,?68,"County: ",$S(IMRCNTY'="":IMRCNTY,1:"__________________"),?96,"State: ",$S(IMRSTATE'="":IMRSTATE,1:"________")
 W ?114,"Code: ",IMRZIP,!!!
 W !,"VII. STATE/LOCAL USE ONLY",!!?94,"Medical"
 W !,"Physician's Name: ",IMRPHYS,?65,"Phone No.: ",IMRPHYST,?94,"Record   No. ",IMRSSN,!,"  (Last, First, M.I.)",!?57,"Person"
 S X=""
 I IMRPT'="" S X=$$FIELD^IMRCDCPX(158,IMRPT,15.6,"E")
 W !,"Hospital/Facility: ",X,?57,"Completing Form: ",IMRUSR,?99,"Phone No.: ",IMRUSRT,!!!
 W !,"This report is authorized by law (Sections 304 and 306 of the Public Health Service Act, 42 USC 242b and 242k).  Response in this"
 W !,"base is voluntary for federal government purposes, but may be mandatory under state and local statutes.  Your cooperation is"
 W !,"necessary for the understanding and control of HIV/AIDS.  Information in the surveillance system that would permit identification"
 W !,"of any individual on whom a record is maintained, is collected with a guarantee that it will be held in confidence, will be used"
 W !,"only for the purposes stated in the assurance on file at the local health department, and will not otherwise be disclosed or"
 W !,"released without the consent of the individual in accordance with Section 308(d) of the Public Health Service Act (42 USC 242m).",!!
 W !,"Public burden for this collection of information is estimated to average 10 minutes per response.  Send comments regarding this"
 W !,"burden estimate or any other aspect of this collection of information, including suggestions for reducing this burden, to PHS"
 W !,"Reports Clearance Officer: ATTN: PRA; Hubert H. Humphrey Bldg. Rm 721-B; 200 Independence Ave., SW; Washington, DC 20201, and to"
 W !,"the Office of Management and Budget; Paperwork Reduction Project (0920-0009); Washington, DC 20503. -DO NOT MAIL CASE REPORT FORMS"
 W !,"TO THESE ADDRESSES --",!!!
 W !,"RETURN TO STATE/LOCAL HEALTH DEPARTMENT       - PATIENT IDENTIFIER INFORMATION IS NOT TRANSMITTED TO CDC! -"
 W @IOF
 W !,"U.S. DEPARTMENT OF HEALTH                     ADULT HIV/AIDS CONFIDENTIAL CASE REPORT                            CDC"
 W !,"& HUMAN SERVICES                         (Patients >=13 years of age at time of diagnosis)             CENTERS FOR DISEASE CONTROL"
 W !,"Public Health Service                                                                                        AND PREVENTION"
 W !?47,"II. HEALTH DEPARTMENT USE ONLY"
 W !,"DATE FORM COMPLETED" S LN="",$P(LN,"=",108)="" W !,?24,LN
 W !?4,"MO. DAY  YR.       |   SOUNDEX         REPORT STATUS          REPORTING HEALTH DEPARTMENT  STATE                               |"
 W !?4,IMRCDC,?23,"|     CODE                                 STATE: _______________       PATIENT NO.: __________             |"
 W !,"=====================  |",?43,"| | NEW REPORT         CITY/                        CITY/COUNTY                         |"
 W !,"| REPORT SOURCE: ___ | |     ____          | | UPDATE             COUNTY:_______________       PATIENT NO.: __________             |"
 W !,"=====================   ",LN
 W !,"-------------------------------------------------  III. DEMOGRAPHIC INFORMATION  -------------------------------------------------"
 W !,"DIAGNOSTIC STATUS         AGE AT DIAGNOSIS: |  DATE OF BIRTH  |  CURRENT STATUS  |  DATE OF DEATH  |  STATE/TERRITORY OF DEATH"
 D HDR^IMRCDCPR
 Q
