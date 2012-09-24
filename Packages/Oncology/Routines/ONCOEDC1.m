ONCOEDC1        ;Hines OIFO/GWB - "Required" data item check ;06/23/10
        ;;2.11;ONCOLOGY;**27,28,29,34,36,39,41,42,47,51**;Mar 07,1995;Build 65
        ;
F1655   ;If data item blank, S CMPLT=0 and add field to list
        I $$GET1^DIQ(165.5,PRM,361,"I")="" S FDNUM=361 D CMPLT
        I $$GET1^DIQ(165.5,PRM,155,"I")="" S FDNUM=155 D CMPLT
        I $$GET1^DIQ(165.5,PRM,56,"I")="" S FDNUM=56 D CMPLT
        I $$GET1^DIQ(165.5,PRM,125,"I")="" S FDNUM=125 D CMPLT
        I $$GET1^DIQ(165.5,PRM,126,"I")="" S FDNUM=126 D CMPLT
        I $$GET1^DIQ(165.5,PRM,363,"I")="" S FDNUM=363 D CMPLT
        I $$GET1^DIQ(165.5,PRM,.03,"I")="" S FDNUM=.03 D CMPLT
        I $$GET1^DIQ(165.5,PRM,.05,"I")="" S FDNUM=.05 D CMPLT
        I $$GET1^DIQ(165.5,PRM,.06,"I")="" S FDNUM=.06 D CMPLT
        I $$GET1^DIQ(165.5,PRM,.07,"I")="" S FDNUM=.07 D CMPLT
        I $$GET1^DIQ(165.5,PRM,8,"I")="" S FDNUM=8 D CMPLT
        I $$GET1^DIQ(165.5,PRM,8.1,"I")="" S FDNUM=8.1 D CMPLT
        I $$GET1^DIQ(165.5,PRM,16,"I")="" S FDNUM=16 D CMPLT
        I $$GET1^DIQ(165.5,PRM,11,"I")="" S FDNUM=11 D CMPLT
        I $$GET1^DIQ(165.5,PRM,9,"I")="" S FDNUM=9 D CMPLT
        I $$GET1^DIQ(165.5,PRM,10,"I")="" S FDNUM=10 D CMPLT
        I $$GET1^DIQ(165.5,PRM,4,"E")="" S FDNUM=4 D CMPLT
        I $$GET1^DIQ(165.5,PRM,1.2,"I")="" S FDNUM=1.2 D CMPLT
        I $$GET1^DIQ(165.5,PRM,2.1,"I")="" S FDNUM=2.1 D CMPLT
        I $$GET1^DIQ(165.5,PRM,18,"I")="" S FDNUM=18 D CMPLT
        I $$GET1^DIQ(165.5,PRM,.04,"I")="" S FDNUM=.04 D CMPLT
        I $$GET1^DIQ(165.5,PRM,12,"I")="" S FDNUM=12 D CMPLT
        I $$GET1^DIQ(165.5,PRM,3,"I")="" S FDNUM=3 D CMPLT
        I $$GET1^DIQ(165.5,PRM,147,"I")="" S FDNUM=147 D CMPLT
        I $$GET1^DIQ(165.5,PRM,20,"I")="" S FDNUM=20 D CMPLT
        I $$GET1^DIQ(165.5,PRM,28,"I")="" S FDNUM=28 D CMPLT
        I $$GET1^DIQ(165.5,PRM,22.3,"I")="" S FDNUM=22.3 D CMPLT
        I $$GET1^DIQ(165.5,PRM,24,"I")="" S FDNUM=24 D CMPLT
        I $$GET1^DIQ(165.5,PRM,26,"I")="" S FDNUM=26 D CMPLT
        I $$GET1^DIQ(165.5,PRM,29,"I")="" S FDNUM=29 D CMPLT
        I $$GET1^DIQ(165.5,PRM,30,"I")="" S FDNUM=30 D CMPLT
        I $$GET1^DIQ(165.5,PRM,31,"I")="" S FDNUM=31 D CMPLT
        I $$GET1^DIQ(165.5,PRM,33,"I")="" S FDNUM=33 D CMPLT
        I DTDX<3040000 D
        .I $$GET1^DIQ(165.5,PRM,34,"I")="" S FDNUM=34 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,34.1,"I")="" S FDNUM=34.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,34.2,"I")="" S FDNUM=34.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,35,"I")="" S FDNUM=35 D CMPLT
        I $$GET1^DIQ(165.5,PRM,32,"I")="" S FDNUM=32 D CMPLT
        I $$GET1^DIQ(165.5,PRM,37.1,"I")="" S FDNUM=37.1  D CMPLT
        I $$GET1^DIQ(165.5,PRM,85,"I")="" S FDNUM=85 D CMPLT
        I '$$GTT^ONCOU55(PRM),$$GET1^DIQ(165.5,PRM,37.2,"I")="" S FDNUM=37.2 D CMPLT
        I '$$GTT^ONCOU55(PRM),$$GET1^DIQ(165.5,PRM,86,"I")="" S FDNUM=86 D CMPLT
        I $$GET1^DIQ(165.5,PRM,37.3,"I")="" S FDNUM=37.3 D CMPLT
        I DTDX<3100000 D
        .I $$GET1^DIQ(165.5,PRM,87,"I")="" S FDNUM=87 D CMPLT
        I DTDX<3030000 D
        .I $$GET1^DIQ(165.5,PRM,25.1,"I")="" S FDNUM=25.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,25.2,"I")="" S FDNUM=25.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,25.3,"I")="" S FDNUM=25.3 D CMPLT
        I $$GET1^DIQ(165.5,PRM,38,"I")="" S FDNUM=38 D CMPLT
        I $$GET1^DIQ(165.5,PRM,88,"I")="" S FDNUM=88 D CMPLT
        I $$GET1^DIQ(165.5,PRM,19,"I")="" S FDNUM=19 D CMPLT
        I $$GET1^DIQ(165.5,PRM,89,"I")="" S FDNUM=89 D CMPLT
        I $$GET1^DIQ(165.5,PRM,58.3,"I")="" S FDNUM=58.3 D CMPLT
        I $$GET1^DIQ(165.5,PRM,58.1,"I")="" S FDNUM=58.1 D CMPLT
        I $$GET1^DIQ(165.5,PRM,560,"I")="" S FDNUM=560 D CMPLT
        I $$GET1^DIQ(165.5,PRM,49,"E")="" S FDNUM=49 D CMPLT
        I $$GET1^DIQ(165.5,PRM,50,"I")="" S FDNUM=50 D CMPLT
        I $$GET1^DIQ(165.5,PRM,58,"I")="" S FDNUM=58 D CMPLT
        I $$GET1^DIQ(165.5,PRM,58.6,"I")="" S FDNUM=58.6 D CMPLT
        I $$GET1^DIQ(165.5,PRM,75,"I")="" S FDNUM=75 D CMPLT
        I $$GET1^DIQ(165.5,PRM,59,"I")="" S FDNUM=59 D CMPLT
        I DTDX<3030000 D
        .I $$GET1^DIQ(165.5,PRM,23,"I")="" S FDNUM=23 D CMPLT
        I $$GET1^DIQ(165.5,PRM,51,"I")="" S FDNUM=51 D CMPLT
        I $$GET1^DIQ(165.5,PRM,51.2,"I")="" S FDNUM=51.2 D CMPLT
        I $$GET1^DIQ(165.5,PRM,51.3,"I")="" S FDNUM=51.3 D CMPLT
        I $$GET1^DIQ(165.5,PRM,53,"I")="" S FDNUM=53 D CMPLT
        I $$GET1^DIQ(165.5,PRM,53.2,"I")="" S FDNUM=53.2 D CMPLT
        I $$GET1^DIQ(165.5,PRM,54,"I")="" S FDNUM=54 D CMPLT
        I $$GET1^DIQ(165.5,PRM,54.2,"I")="" S FDNUM=54.2 D CMPLT
        I $$GET1^DIQ(165.5,PRM,55,"I")="" S FDNUM=55 D CMPLT
        I $$GET1^DIQ(165.5,PRM,55.2,"I")="" S FDNUM=55.2 D CMPLT
        I $$GET1^DIQ(165.5,PRM,57,"I")="" S FDNUM=57 D CMPLT
        I $$GET1^DIQ(165.5,PRM,57.2,"I")="" S FDNUM=57.2 D CMPLT
        I DTDX<3030000 D
        .I $$GET1^DIQ(165.5,PRM,74,"I")="" S FDNUM=74 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,58.2,"I")="" S FDNUM=58.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,50.2,"I")="" S FDNUM=50.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,138,"I")="" S FDNUM=138 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,138.1,"I")="" S FDNUM=138.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,139,"I")="" S FDNUM=139 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,139.1,"I")="" S FDNUM=139.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,140,"I")="" S FDNUM=140 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,140.1,"I")="" S FDNUM=140.1 D CMPLT
        I DTDX'=9999999,DTDX>3061231 D
        .I $$GET1^DIQ(165.5,PRM,159,"I")="" S FDNUM=159 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,193,"I")="" S FDNUM=193 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,194,"I")="" S FDNUM=194 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,195,"I")="" S FDNUM=195 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,196,"I")="" S FDNUM=196 D CMPLT
        I DTDX'=9999999,DTDX>2971231 D
        .I $$GET1^DIQ(165.5,PRM,138.4,"I")="" S FDNUM=138.4 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,139.4,"I")="" S FDNUM=139.4 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,138.5,"I")="" S FDNUM=138.5 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,139.5,"I")="" S FDNUM=139.5 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,435,"I")="" S FDNUM=435 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,14,"I")="" S FDNUM=14 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,58.7,"I")="" S FDNUM=58.7 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,51.4,"I")="" S FDNUM=51.4 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,53.3,"I")="" S FDNUM=53.3 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,54.3,"I")="" S FDNUM=54.3 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,55.3,"I")="" S FDNUM=55.3 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,57.3,"I")="" S FDNUM=57.3 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,58.4,"I")="" S FDNUM=58.4 D CMPLT
        I DTDX'=9999999,DTDX>2961231 I $$GET1^DIQ(165.5,PRM,442,"I")="" S FDNUM=442 D CMPLT
        I DTDX'=9999999,DTDX>3031231 D
        .I $$GET1^DIQ(165.5,PRM,29.2,"I")="" S FDNUM=29.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,30.2,"I")="" S FDNUM=30.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,29.1,"I")="" S FDNUM=29.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,31.1,"I")="" S FDNUM=31.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,32.1,"I")="" S FDNUM=32.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,34.3,"I")="" S FDNUM=34.3 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,34.4,"I")="" S FDNUM=34.4 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,44.1,"I")="" S FDNUM=44.1 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,44.2,"I")="" S FDNUM=44.2 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,44.3,"I")="" S FDNUM=44.3 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,44.4,"I")="" S FDNUM=44.4 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,44.5,"I")="" S FDNUM=44.5 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,44.6,"I")="" S FDNUM=44.6 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,160,"I")="" S FDNUM=160 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,161,"I")="" S FDNUM=161 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,162,"I")="" S FDNUM=162 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,163,"I")="" S FDNUM=163 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,164,"I")="" S FDNUM=164 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,165,"I")="" S FDNUM=165 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,166,"I")="" S FDNUM=166 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,167,"I")="" S FDNUM=167 D CMPLT
        .I $$GET1^DIQ(165.5,PRM,168,"I")="" S FDNUM=168 D CMPLT
        Q
        ;
CMPLT   ;Set CMPLT = 0 and add FLD to LIST of fields needed to be filled in.
        S FLDNAME=$P($G(^DD(ONCFILE,FDNUM,0)),U,1) S FDNUM=""
        S CMPLT=0,LIST(FLDNAME)=""
        Q
        ;
CLEANUP ;Cleanup
        K CMPLT,DTDX,FDNUM,FLDNAME,LIST,ONCFILE,PRM
        Q
