IMRCDP2 ;HCIOFO/NCA - Display CDC Form (Cont.) ;7/16/97  08:54
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:IMRUT
 W !,"AT REPORT (check one):                      |   Mo. Day Yr.   |"
 W "  Alive Dead Unk. |   Mo. Day Yr.   |",!,"|",$S(IMRPN:$$VAL^IMRCDCPX(110.01,1),1:1),"| HIV Infection (not AIDS)    "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,110.02,"E"),1:0) S:X'>0 X="__" W X," Years    |                 |                  |                 |"
 W !,"|",$S(IMRPT:$$VAL^IMRCDCPX(110.01,2),1:2),"| AIDS                        " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,15.8,"I"),1:0) S:X'>0 X="__" W X," Years    |   ",IMRDOB
 W "   |   |",$S(IMRPT:$$VAL^IMRCDCPX(15.7,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(15.7,2),1:2),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(15.7,9),1:9),"|  |   ",IMRDOD,"   |  ",$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,112.05,"E"),1:"")
 W !,"----------------------------------------------------------------------------------------------------------------------------------"
 W !,"SEX:       |RACE/ETHNICITY:                                                  |COUNTRY OF BIRTH:                                 "
 W !,"|",$S(IMRPT:$$VAL^IMRCDCPX(1.2,1),1:1),"| Male   ||",$S(IMRPT:$$VAL^IMRCDCPX(1,1),1:1),"| White (not Hispanic) |",$S(IMRPT:$$VAL^IMRCDCPX(1,2),1:2),"| Black (not Hispanic)  |",$S(IMRPT:$$VAL^IMRCDCPX(1,3),1:3)
 W "| Hispanic  "
 W "||",$S(IMRPT:$$VAL^IMRCDCPX(102.08,1),1:1),"| U.S.  |",$S(IMRPT:$$VAL^IMRCDCPX(102.08,7),1:7),"| U.S. Dependencies and Possessions (in-"
 W !,"|",$S(IMRPT:$$VAL^IMRCDCPX(1.2,2),1:2),"| Female ||",$S(IMRPT:$$VAL^IMRCDCPX(1,4),1:4),"| Asian/Pacific        |",$S(IMRPT:$$VAL^IMRCDCPX(1,5),1:5),"| American Indian/      |",$S(IMRPT:$$VAL^IMRCDCPX(1,9),1:9)
 W "| Not       |   cluding Puerto Rico (specify): "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,102.23,"E"),1:""),UNDR="______________________________"
 W X_$P(UNDR,"_",1,(15-$L(X)))
 W !,"           |    Islander                 Alaskan Native            Specified ||",$S(IMRPT:$$VAL^IMRCDCPX(102.08,8),1:8),"| Other (specify): "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.1,"E"),1:"") W X_$P(UNDR,"_",1,(15-$L(X))),"   |",$S(IMRPT:$$VAL^IMRCDCPX(102.08,9),1:9),"| Unknown"
 W !,"----------------------------------------------------------------------------------------------------------------------------------"
 W !,"RESIDENCE AT DIAGNOSIS:",?48,"State/"
 W !,"City: ",$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPN,16.2,"E"),1:""),?25,"County: ",$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.3,"E"),1:""),?48,"Country: "
 S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.4,"E"),1:"") I X="" S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.5,"E"),1:"") W X
 W ?92,"Zip Code: " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPN,16.6,"E"),1:"") W X
 W !,"----------------------------------------------------------------------------------------------------------------------------------"
 W !,"- IV. FACILITY OF DIAGNOSIS ----  ---------------------------------------  V. PATIENT HISTORY  -----------------------------------"
 W !,"|" S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPN,16.7,"E"),1:"")
 W X_$P(UNDR,"_",1,(28-$L(X))),"   |  | AFTER 1977 AND PRECEDING THE FIRST POSITIVE HIV ANTIBODY TEST                                |"
 W !,"| FACILITY NAME:               |  | OR AIDS DIAGNOSIS, THIS PATIENT HAD (Respond to ALL Categories):              Yes  No   Unk. |"
 W !,"| " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPN,16.8,"E"),1:"") W X_$P(UNDR,"_",1,(28-$L(X))),"  |  | * Sex with male " W "............................................................  "
 W "|",$S(IMRPT:$$VAL^IMRCDCPX(17.8,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(17.8,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(17.8,9),1:9),"|  |"
 W !,"| City                         |  | * Sex with female ..........................................................  "
 W "|",$S(IMRPT:$$VAL^IMRCDCPX(17.9,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(17.9,0),1:0),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(17.9,9),1:9),"|  |"
 W !,"| " S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.9,"E"),1:"") I X="" S X=$S(IMRPT:$$FIELD^IMRCDCPX(158,IMRPT,16.11,"E"),1:"")
 W X_$P(UNDR,"_",1,(28-$L(X))),"  |  | * Injected nonprescription drugs ...........................................  |",$S(IMRPT:$$VAL^IMRCDCPX(16.19,1),1:1),"|  |",$S(IMRPT:$$VAL^IMRCDCPX(16.19,0),1:0),"|  |"
 W $S(IMRPT:$$VAL^IMRCDCPX(16.19,9),1:9),"|  |"
 D HDR^IMRCDCPR
 Q
