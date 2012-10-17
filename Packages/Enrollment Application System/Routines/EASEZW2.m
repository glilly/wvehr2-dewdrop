EASEZW2 ;ALB/AMA - Auto-process 1010EZ from Web-based Application, part 2 ; 7/31/08 2:17pm
        ;;1.0;ENROLLMENT APPLICATION SYSTEM;**70,81**;Mar 15, 2001;Build 11
        ;
        ;This is just a continuation of EASEZW, which got too large
        ;
SEC3    ;special parsing for Section III
        N OUT,DA,DIE,DR,X,C,LINE,EMAIL,EVERS,EXPECT,EDETL,ESERV,EAPREQ,ECOMM,ERR
        ;find the Submission ID
        S EASWEBID="",EMAIL="",EVERS="",EXPECT="",EDETL="",ESERV="",EAPREQ="" S OUT=0
        F  X XMREC Q:XMER=-1  D  Q:OUT
        . S LINE=XMRG
        . I LINE["EOF",LINE["III" S OUT=1 Q
        . I LINE["Comment" S NOCOMM=0,JJ=1 F  D  Q:NOCOMM  Q:OUT
        . . I JJ=1 S C=$P(LINE,U,2) S ECOMM(JJ)=C
        . . I JJ>1,$L(LINE)>1 S ECOMM(JJ)=LINE
        . . S JJ=JJ+1
        . . X XMREC
        . . I XMER=-1 S NOCOMM=1,OUT=1
        . . S LINE=XMRG
        . . I $E(LINE,1,30)["Services Request" S NOCOMM=1
        . I LINE["Submit ID" S EASWEBID=$P(LINE,U,2)
        . I LINE["Email Address" S EMAIL=$P(LINE,U,2)
        . I LINE["Version #" S EVERS=$P(LINE,U,2)
        . I LINE["Veteran To Mail" S X=$P(LINE,U,2),EXPECT=$S(X["Vet":1,1:"")
        . I LINE["Provide",LINE["Details" S EDETL=$P(LINE,U,2)
        . ;I LINE["Appointment Request" S X=$P(LINE,U,2),EAPREQ=$S(X="YES":1,1:0)
        . I LINE["Appointment Request" S X=$P(LINE,U,2),EAPREQ=$S(X["Y":1,1:0)
        . I LINE["Services Request" S ESERV=$P(LINE,U,2)
        ;file the Submission ID into #712 record
        S DA=EASAPP
        S DIE="^EAS(712,"
        S DR=".1///^S X=EASWEBID;3.6///^S X=EVERS;3.7///^S X=EXPECT;3.8///^S X=EDETL;4.3///^S X=EMAIL;"
        S DR=DR_"4.4///^S X=EAPREQ;12///^S X=ESERV"
        D ^DIE
        K DA,DIE,DR,X,Y
        I $D(ECOMM) D WP^DIE(712,EASAPP_",",13,,"ECOMM","ERR")
        Q
        ;
NMSSNDOB        ;find applicant's name,ssn,dob in data subrecords & file in main record
        ;get applicant name
        N KEY,MDL,SUFF,N,X,Y,ZX,DA,DR,DIE
        S KEY=$$KEY711^EASEZU1("APPLICANT LAST NAME"),EASNAME=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("APPLICANT FIRST NAME"),EASNAME=EASNAME_","_$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("APPLICANT MIDDLE NAME"),MDL=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("APPLICANT SUFFIX NAME"),SUFF=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        I $L(EASNAME)+$L(MDL)>45 S MDL=$E(MDL,1)
        I MDL'="" S EASNAME=EASNAME_" "_MDL
        I SUFF'="" S EASNAME=EASNAME_" "_SUFF
        S EASNAME=$$UC^EASEZT1($E(EASNAME,1,45))
        ;get applicant ssn & dob
        S KEY=$$KEY711^EASEZU1("APPLICANT SOCIAL SECURITY NUMBER")
        S EASSSN=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1),EASSSN=$$SSNOUT^EASEZT1(EASSSN)
        S KEY=$$KEY711^EASEZU1("APPLICANT DATE OF BIRTH")
        S EASDOB=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S VETTYPE=$$VETTYPE(EASAPP)
        S N(1)=$O(^EAS(711,"AB","APPLICANT FIRST NAME",0)),KEY(1)=$P($G(^EAS(711,N(1),0)),U,2)
        K DA,DR S DA=EASAPP,DIE="^EAS(712,"
        S ZX=EASSSN_"&"_EASDOB
        S DR="1///^S X=EASNAME;2///^S X=ZX;3.3///^S X=VETTYPE"
        D ^DIE
        Q
        ;
VETTYPE(EASAPP) ;derive a veteran type categorization for this Applicant
        ;input  EASAPP = ien in file #712 for Application
        ;output TYPE   = veteran type
        ;
        N KEY,PH,POW,SC,SCPC,MRET,VETTYPE
        ;get application data needed to determine veteran type
        S KEY=$$KEY711^EASEZU1("PURPLE HEART"),PH=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("PRISONER OF WAR"),POW=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("SERVICE-CONNECTED"),SC=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("RATED PERCENTAGE"),SCPC=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        S KEY=$$KEY711^EASEZU1("RETIRED FROM MILITARY"),MRET=$P($$DATA712^EASEZU1(EASAPP,KEY),U,1)
        ;set veteran type
        I PH="Y" Q 5
        I POW="Y" Q 4
        I SC="Y" S TYPE=$S(+SCPC>49:1,+SCPC=0:3,1:2) Q TYPE
        I MRET="Y" Q 6
        Q 7
        ;
DESIGNEE        ;set either NOK or E-CONTACT data into DESIGNEE
        N DIC,DIE,DA,DR,X,Y,EASDATA,TYPE,MULTIPLE,XPART,KEY,EASIEN
        S KEY=$$KEY711^EASEZU1("DESIGNEE")
        S EZDATA=$P($$DATA712^EASEZU1(EASAPP,KEY,1),U,1)
        I (EZDATA["EMERGENCY")!(EZDATA["CONTACT") S TYPE="E-CONTACT"
        E  S TYPE="NEXT-OF-KIN"
        ;place all NOK or E-CONTACT data in DESIGNEE data elements
        F I=1:1 S X=$P($T(DSGDAT+I),";;",2) Q:X="QUIT"  D
        . S XPART=$P(X,";",1)
        . S KEY=$$KEY711^EASEZU1(TYPE_" "_XPART)
        . Q:KEY=.1
        . S KEYIEN=+$P(KEY,U,1),DATAKEY=$P(KEY,U,3)
        . ;in file #2, multiple is always 1
        . S MULTIPLE=1
        . ;get the data element for the NOK or E-CONT
        . S X=$$DATA712^EASEZU1(EASAPP,KEY,MULTIPLE),EASDATA=$P(X,U,1)
        . Q:EASDATA=""
        . ;and file it as DESIGNEE
        . ;create subrecord
        . S X=$$KEY711^EASEZU1("DESIGNEE"_" "_XPART),KEYIEN=+X
        . S EASIEN=$O(^EAS(712,EASAPP,10,999),-1)+1
        . S DIC="^EAS(712,EASAPP,10,",DIC(0)="L",DLAYGO="",X=KEYIEN,DINUM=EASIEN
        . S DA(1)=EASAPP,DIC("P")=$P(^DD(712,10,0),U,2)
        . K DD,DO D FILE^DICN
        . ;file data element
        . S DIE="^EAS(712,EASAPP,10,",DA=EASIEN,DA(1)=EASAPP,DR(1)="10;"
        . S DR=".1///^S X=1;1///^S X=EASDATA;"
        . D ^DIE
        Q
        ;
DSGDAT  ;
        ;;LAST NAME;
        ;;FIRST NAME;
        ;;STREET ADDRESS;
        ;;CITY;
        ;;STATE;
        ;;ZIP;;
        ;;HOME PHONE AREA CODE;
        ;;HOME PHONE NUMBER;
        ;;WORK PHONE AREA CODE;
        ;;WORK PHONE NUMBER;
        ;;WORK PHONE EXTENSION;
        ;;RELATIONSHIP;
        ;;QUIT
        ;
CONFIRM(EASWEBID,EASAPP,EASXMZ) ;confirm receipt of web submission message to Forum
        ;input EASAPP   = ien in file #712
        ;      EASWEBID = web submission id
        ;      EASXMZ   = ien in file #3.9 for msg being processed
        N ARRAY,DIC,DIQ,DA,DR,STN,XMSUB,XMDUZ,XMTEXT,XMY,XMZ
        Q:$G(EASAPP)=""  Q:$G(EASWEBID)=""
        S DA=EASAPP,DIC="^EAS(712,",DIQ="ARRAY",DIQ(0)="I",DR=".2;4.5"
        D EN^DIQ1
        S STN=$G(ARRAY(712,EASAPP,4.5,"I")),STN=$TR(STN," ",""),STN=STN_U_"G.VA1010EZ@"_^XMB("NETNAME")
        S ^TMP("1010EZRC",$J,1)="Receipt Confirmation for: "_EASWEBID
        S ^TMP("1010EZRC",$J,2)="Sent from: "_STN
        ;send msg # from holding file record just in case current msg is a duplicate
        S ^TMP("1010EZRC",$J,3)="Site msg #: "_$G(ARRAY(712,EASAPP,.2,"I"))
        S XMSUB="1010EZ CONFIRMATION for SID "_EASWEBID,XMDUZ=.5
        S XMY("1010EZ.1010EZ@FORUM.VA.GOV")=""
        S XMTEXT="^TMP(""1010EZRC"",$J,"
        D ^XMD
        K ^TMP("1010EZRC",$J)
        Q
