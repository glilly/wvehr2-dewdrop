SRTPUTLC        ;BIR/SJA - UTILITY ROUTINE ;09/10/08
        ;;3.0; Surgery ;**167**;24 Jun 93;Build 27
CHK     ; check for missing transplant assessment information
        K SRX,SRZZ,SRMM S SRMM=0
        D @SRTYPE
        Q
K       ; kidney data entry fields
        ; kidney recipient information
        S DR=$S(SRNOVA:"3;1;11;187;10;12;4;5;96;26;27;95;97;33;19;98;37;42;94",1:"3;11;187;10;12;96;26;27;95;97;33;19;98;37;42;94") D DATA
        ; kidney transplant information
        S DR="85;87;89;68;143;144;9;197;13;14;15;17;16;18" D DATA
        ; PREOPERATIVE RISK ASSESSMENT/RISK ASSESSMENT
        S DR=$S(SRNOVA:"147;59;60;61;75;108;113;80;83;131;115;109;110;92;145;132;146;90",1:"59;60;61;75;108;113;80;115;90;83;109;110;92;133") D DATA
        ; kidney outcome data
        I SRNOVA S DR="116;117;118;119;192;121;122;123;124;125;126;193;133" D DATA
        ; kidney donor information
        S DR="44" D DATA
        S DR="45;31;36;70;46;48;49;77;69;103;104;64;65;66;73;67;72" D DATA
        ; pancreas information
        S DR="134;135;136;137;138;139;140;141;142" D DATA
        Q
LI      ; liver data entry fields
        ; recipient information
        S DR=$S(SRNOVA:"3;1;11;4;5;10;12;52;53;54;55;19",1:"3;11;10;12;52;53;54;55;19") D DATA
        ; diagnosis information
        S DR="21;20;23;99;100;101;27;28;29;30;102;34;35;38;105;39;106;107;47;56;111;120;127;94" D DATA
        ; diagnosis information
        S DR="85;87;89;68;13;14;15;17;16;18" D DATA
        ; risk assessment information
        S DR=$S(SRNOVA:"86;84;147;59;60;113;108;114;90;91;78;79",1:"86;84;59;60;108;113;114;90;91;78;79;81;82;83;109;110") D DATA
        ; donor information for VA
        I 'SRNOVA D
        .S DR="44" D DATA
        .S DR="45;31;36;70;46;48;49;77;69;103;104;64;65;66;73;67;72" D DATA
        ; risk assessment information for Non-VA
        I SRNOVA S DR="81;82;88;83;109;110;145;132;146;131" D DATA
        ; outcome information for non-VA
        I SRNOVA S DR="116;117;118;119;192;121;122;123;124;125;126;193" D DATA
        I SRNOVA D
        .S DR="44" D DATA
        .S DR="45;31;36;70;46;48;49;77;69;103;104;64;65;66;73;67;72" D DATA
        Q
LU      ; lung data entry fields
        ; recipient information
        S DR=$S(SRNOVA:"3;1;11;4;5;10;12;40;41;24;25;32;129;19;43;22;128;94",1:"3;11;10;12;40;41;24;25;32;43;22;128;94;129;19") D DATA
        ; lung transplant information
        S DR="50;51;85;87;89;68;13;14;15;17;16;18" D DATA
        ; preoperative risk assessment
        S DR=$S(SRNOVA:"147;59;60;71;108;61;75;113;114;131;115;90;83;109;110;145;132;146;80",1:"59;60;71;108;61;75;113;114;80;115;90;83;109;110") D DATA
        ; outcome information
        I SRNOVA S DR="116;117;118;119;192;121;122;123;124;125;126;193" D DATA
        ; donor information
        S DR="44" D DATA
        S DR="45;31;36;70;46;48;49;77;69;103;104;64;65;66;73;67;72" D DATA
        Q
H       ; heart data entry fields
        ; recipient information
        S DR=$S(SRNOVA:"3;1;11;58;57;4;5;10;12;167;168;163;164;19;165;89;166;68",1:"3;11;58;57;163;164;165;89;166;68;10;12;19") D DATA
        ; diagnosis information
        S DR="155;156;157;158;159;43;160;161;162;94;112;13;14;15;16;17;18" D DATA
        ; risk assessment information
        S DR=$S(SRNOVA:"76;169;177;149;173;174;175;62;176;74;152;171;172;179;178;132;145;150;151;147;59;60",1:"62;149;150;151;59;60;152;108;153;74;115;81;82;109;110;90;83;75;154") D DATA
        ; risk assessment info
        I SRNOVA D  D DATA
        .S DR="75;154;108;115;81;82;90;83;153" S DR=DR_"193;170;192;191;190;119;189;148;118;121;122;130;109;110"
        ; donor information
        S DR="44" D DATA
        S DR="45;31;36;70;46;48;49;77;69;104;64;65;66;73;67;72" D DATA
         Q
DATA    K DIC,DIQ,SRY,SRYY S DIC="^SRT(",DA=SRTPP,DIQ="SRY",DIQ(0)="I" D EN^DIQ1
        I $P(DR,";")=44 D RACE
        S XX=0 F  S XX=$O(SRY(139.5,DA,XX)) Q:'XX   D LOC I SRI S SRYY(139.5,DA,SRI,"I")=SRY(139.5,SRTPP,XX,"I")_"^"_XX
        K DR S SRMM=SRMM+1 D ^SRTPUTL4
        Q
LOC     ;
        S SRI=0 F I=1:1:$L(DR,";") S:$P(DR,";",I)=XX SRI=I
        Q
RACE    ;
        K SRY1,SRY2 S DIC="^SRT(",DR=44,DA=SRTPP,DR(139.544)=".01"
        S (II,JJ)=0 F  S II=$O(^SRT(SRTPP,44,II)) Q:'II  S SRACE=$G(^SRT(SRTPP,44,II,0)) D  K SRY1
        .S DA(139.544)=II,DIQ="SRY1",DIQ(0)="E" D EN^DIQ1
        .S JJ=JJ+1,SRY2(139.544,JJ)=SRACE_"^"_$G(SRY1(139.544,II,.01,"E")),SRY2(139.544)=JJ
        I $G(SRY2(139.544))>0 Q
        S SRY(139.5,SRTPP,44,"I")=""
        Q
