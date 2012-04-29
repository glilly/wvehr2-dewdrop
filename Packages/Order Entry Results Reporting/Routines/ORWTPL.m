ORWTPL  ; SLC/STAFF Personal Preference - Lists ; 3/11/08 6:36am
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**85,109,173,243**;Oct 24, 2000;Build 242
        ;
NEWLIST(VAL,LISTNAME,USER,ORVIZ)        ; from ORWTPP
        ; set user's new personal list
        S LISTNAME=$G(LISTNAME)
        I '$L(LISTNAME) S VAL="^invalid list name" Q
        I $O(^OR(100.21,"B",LISTNAME,0)) S VAL="^invalid list name - duplicate of another name" Q
        ;*** check input transform, duplicate name for same user
        N DA,DIK,NUM
        L +^OR(100.21,0):20 I '$T S VAL="^unable to set up" Q
        S NUM=1+$P(^OR(100.21,0),U,3)
        F  Q:'$D(^OR(100.21,NUM,0))  S NUM=NUM+1
        S $P(^OR(100.21,0),U,3)=NUM,$P(^(0),U,4)=$P(^(0),U,4)+1
        S ^OR(100.21,NUM,0)=LISTNAME_"^P"
        L -^OR(100.21,0)
        K ^OR(100.21,NUM,1),^(2),^(10)
        S ^OR(100.21,NUM,1,0)="^100.212PA^"_USER_"^1"
        S ^OR(100.21,NUM,1,USER,0)=USER
        S ^OR(100.21,NUM,11)=$G(ORVIZ)_U
        S DIK="^OR(100.21,",DA=NUM
        D IX1^DIK
        S VAL=NUM_U_LISTNAME_"^^^^^^^"_$G(ORVIZ)
        Q
        ;
DELLIST(OK,LISTNUM,USER)        ; from ORWTPP
        ; delete user's personal list
        N DA,DIK
        S LISTNUM=+$G(LISTNUM),OK=1
        I '$O(^OR(100.21,"C",USER,LISTNUM,0)) S OK=0 Q
        I $P($G(^OR(100.21,LISTNUM,0)),U,2)'="P" S OK=0 Q
        S DA=LISTNUM,DIK="^OR(100.21,"
        D ^DIK
        Q
        ;
SAVELIST(OK,PLIST,LISTNUM,USER,ORVIZ)   ; from ORWTPP
        ; save user's personal list changes
        N CNT,DA,DFN,DIK,NUM K DA
        S LISTNUM=+$G(LISTNUM),OK=1
        I $P($G(^OR(100.21,LISTNUM,0)),U,2)'="P" S OK=0 Q
        I '$D(^OR(100.21,"C",USER,LISTNUM)) S OK=0 Q
        I '$D(^OR(100.21,LISTNUM,10,0))#2 S ^(0)="^100.2101AV^"
        S DA(1)=LISTNUM,DIK="^OR(100.21,"_LISTNUM_",10,"
        S DA=0 F  S DA=$O(^OR(100.21,LISTNUM,10,DA)) Q:DA<1  D ^DIK
        K DA
        S CNT=0
        S NUM=0 F  S NUM=$O(PLIST(NUM)) Q:NUM<1  D
        .S DFN=+PLIST(NUM) I 'DFN Q
        .S CNT=CNT+1
        .S ^OR(100.21,LISTNUM,10,CNT,0)=DFN_";DPT("
        S ^OR(100.21,LISTNUM,10,0)="^100.2101AV^"_CNT_U_CNT
        S ^OR(100.21,LISTNUM,11)=$G(ORVIZ)_U
        S DA=LISTNUM,DIK="^OR(100.21,"
        D IX1^DIK
        Q
        ;
LSDEF(INFO,USER)        ; from ORWTPP
        ; get user's list sources
        N TYPE
        S INFO=""
        F TYPE="P","S","T","W","C" D
        .S INFO=INFO_$P($$LISTSRC^ORQPTQ11(USER,TYPE),U)_U
        Q
        ;
SORTDEF(SORT,USER)      ; from ORWTPP
        ; get user's sort order - Modified by PKS - 8/30/2001
        N ORSECT
        S ORSECT=$G(^VA(200,USER,5))
        I +ORSECT>0 S ORSECT=$P(ORSECT,U)
        S SORT=$$GET^XPAR("USR.`"_USER_"^SRV.`"_$G(ORSECT)_"^DIV^SYS^PKG","ORLP DEFAULT LIST ORDER",1,"I") I SORT']"" S SORT="A"
        Q
        ;
CLDAYS(DAYS,USER)       ; from ORWTPP
        ; get user's clinic defaults
        N DAY
        S DAYS=""
        F DAY="MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY" D
        .S DAYS=DAYS_$$GET^XPAR("USR.`"_USER,"ORLP DEFAULT CLINIC "_DAY,1,"I")_U
        Q
        ;
CLRANGE(RANGE,USER)     ; from ORWTPP
        ; get user's default clinic start, stop dates
        N RNG
        S RANGE=""
        F RNG="START","STOP" D
        .S RANGE=RANGE_$$GET^XPAR("USR.`"_USER,"ORLP DEFAULT CLINIC "_RNG_" DATE",1,"I")_U
        Q
        ;
SAVECD(OK,INFO,USER)    ; from ORWTPP
        ; save user's clinic defaults
        N FRI,MON,SAT,START,STOP,SUN,THURS,TUES,WED
        S OK=1
        S START=+$P(INFO,U,1) S START=$S(START=0:"T",START<0:"T"_START,1:"T+"_START)
        S STOP=+$P(INFO,U,2) S STOP=$S(STOP=0:"T",STOP<0:"T"_STOP,1:"T+"_STOP)
        S MON=+$P(INFO,U,3),MON=$S('MON:"@",1:"`"_MON)
        S TUES=+$P(INFO,U,4),TUES=$S('TUES:"@",1:"`"_TUES)
        S WED=+$P(INFO,U,5),WED=$S('WED:"@",1:"`"_WED)
        S THURS=+$P(INFO,U,6),THURS=$S('THURS:"@",1:"`"_THURS)
        S FRI=+$P(INFO,U,7),FRI=$S('FRI:"@",1:"`"_FRI)
        S SAT=+$P(INFO,U,8),SAT=$S('SAT:"@",1:"`"_SAT)
        S SUN=+$P(INFO,U,9),SUN=$S('SUN:"@",1:"`"_SUN)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC START DATE",1,START)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC STOP DATE",1,STOP)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC MONDAY",1,MON)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC TUESDAY",1,TUES)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC WEDNESDAY",1,WED)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC THURSDAY",1,THURS)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC FRIDAY",1,FRI)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC SATURDAY",1,SAT)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT CLINIC SUNDAY",1,SUN)
        Q
        ;
SAVEPLD(OK,INFO,USER)   ; from ORWTPP
        ; save user's clinic defaults
        N PROV,SORT,SOURCE,SPEC,TEAM,WARD
        S OK=1
        S SOURCE=$P(INFO,U,1)
        S SORT=$P(INFO,U,2)
        S PROV=+$P(INFO,U,3),PROV=$S('PROV:"@",1:"`"_PROV)
        S SPEC=+$P(INFO,U,4),SPEC=$S('SPEC:"@",1:"`"_SPEC)
        S TEAM=+$P(INFO,U,5),TEAM=$S('TEAM:"@",1:"`"_TEAM)
        S WARD=+$P(INFO,U,6),WARD=$S('WARD:"@",1:"`"_WARD)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT LIST SOURCE",1,SOURCE)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT LIST ORDER",1,SORT)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT PROVIDER",1,PROV)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT SPECIALTY",1,SPEC)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT TEAM",1,TEAM)
        D EN^XPAR(USER_";VA(200,","ORLP DEFAULT WARD",1,WARD)
        Q
