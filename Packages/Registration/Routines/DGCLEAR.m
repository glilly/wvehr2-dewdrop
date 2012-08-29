DGCLEAR ;ALB/BAJ - REGISTRATION CROSS REFERENCE CLEANUP ;01/09/2006
        ;;5.3;Registration;**653,688**;Aug 13, 1993;Build 29
        ;
        ; Called from ASK^DGLOCK or ADK^DGLOCK3, The purpose of this routine is to clear All temporary or confidential address fields
        ; Also called from Z07 process to clear Permanent address before update 
        ;               
        ; 
EN(DGENDA,TYPE) ; entry point
        ;
        ; Code to TRIGGER deletion of field data.
        N DATA,CALLTYP
        S CALLTYP=$S(TYPE="TEMP":"T",TYPE="PERM":"P",1:"C")
        D SETARR(CALLTYP,.DATA)
        Q $$UPD^DGENDBS(2,.DGENDA,.DATA)
        ;
SETARR(CALLTYP,DATA)    ;set up data array
        N CNT,CURFILE,CTRYFLD,FDFLG,ADDTYPE,T,FTYPE,CURFTYPE
        ; assemble array of fields to clear
        F CNT=1:1 S T=$P($T(DTABLE+CNT),";;",3) Q:T="QUIT"  D
        . Q:$P(T,";",1)'=CALLTYP  S DATA($P(T,";",3))=$P(T,";",4)
        Q
DTABLE  ;TABLE of Foreign and Domestic fields: structure -->>;;Description;;(T)EMPORARY/(C)ONFIDENTIAL/(P)ERMANENT;FILE;FIELD;DATA
        ;;TEMPORARY STREET [LINE 1];;T;2;.1211;@
        ;;TEMPORARY ZIP+4;;T;2;.12112;@
        ;;TEMPORARY STREET [LINE 2];;T;2;.1212;@
        ;;TEMPORARY STREET [LINE 3];;T;2;.1213;@
        ;;TEMPORARY CITY;;T;2;.1214;@
        ;;TEMPORARY STATE;;T;2;.1215;@
        ;;TEMPORARY COUNTY;;T;2;.12111;@
        ;;TEMPORARY ZIP CODE;;T;2;.1216;@
        ;;TEMPORARY ADDRESS START DATE;;T;2;.1217;@
        ;;TEMPORARY ADDRESS END DATE;;T;2;.1218;@
        ;;TEMPORARY PHONE NUMBER;;T;2;.1219;@
        ;;TEMPORARY ADDRESS PROVINCE;;T;2;.1221;@
        ;;TEMPORARY ADDRESS POSTAL CODE;;T;2;.1222;@
        ;;TEMPORARY ADDRESS COUNTRY;;T;2;.1223;@
        ;;TEMPORARY ADDRESS ACTIVE;;T;2;.12105;N
        ;;CONFIDENTIAL STREET [LINE 1];;C;2;.1411;@
        ;;CONFIDENTIAL STREET [LINE 2];;C;2;.1412;@
        ;;CONFIDENTIAL STREET [LINE 3];;C;2;.1413;@
        ;;CONFIDENTIAL CITY;;C;2;.1414;@
        ;;CONFIDENTIAL STATE;;C;2;.1415;@
        ;;CONFIDENTIAL COUNTY;;C;2;.14111;@
        ;;CONFIDENTIAL ZIP CODE;;C;2;.1416;@
        ;;CONFIDENTIAL ADDRESS START DATE;;C;2;.1417;@
        ;;CONFIDENTIAL ADDRESS END DATE;;C;2;.1418;@
        ;;CONFIDENTIAL ADDRESS PROVINCE;;C;2;.14114;@
        ;;CONFIDENTIAL ADDRESS POSTAL CODE;;C;2;.14115;@
        ;;CONFIDENTIAL ADDRESS COUNTRY;;C;2;.14116;@
        ;;CONFIDENTIAL ADDRESS ACTIVE;;C;2;.14105;N
        ;;PERMANENT STREET [LINE 1];;P;2;.111;@
        ;;PERMANENT STREET [LINE 2];;P;2;.112;@
        ;;PERMANENT CITY;;P;2;.114;@
        ;;PERMANENT STATE;;P;2;.115;@
        ;;PERMANENT COUNTY;;P;2;.117;@
        ;;PERMANENT ZIP CODE;;P;2;.1112;@
        ;;PERMANENT ADDRESS PROVINCE;;P;2;.1171;@
        ;;PERMANENT ADDRESS POSTAL CODE;;P;2;.1172;@
        ;;PERMANENT ADDRESS COUNTRY;;P;2;.1173;@
        ;;PERMANENT BAD ADDRESS INDICATOR;;P;2;.121;@
        ;;QUIT;;QUIT
