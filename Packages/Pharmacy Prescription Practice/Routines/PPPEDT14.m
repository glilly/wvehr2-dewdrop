PPPEDT14 ;ALB/JFP - EDIT FF XREF ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; These routines control the adding of foreign facility 
 ; data to the FFX file (Add Entry).
 ;
ADD ; -- Adds new entry to FFX file
 ;
 N SNIFN,STATION,STANO,ERR,NEWENTRY,PATNAME,LOCKERR,STANAME
 ;
 S LOCKERR=-9004
 S NEWENTRY=1001
 ;
 I $P(XQORNOD(0),"^",4)["=" D
 . W !,"  - Add Entry action doesn't allow for numeric selection..."
ADD1 S SNIFN=$$GETINST^PPPGET3()
 I SNIFN<0 S VALMBCK="R" Q
 S STATION=$$GETSNIFN^PPPGET3(SNIFN,1)
 S SNIFN=$P(STATION,"^")
 I SNIFN=-1001 Q  ; -- user abort
 I SNIFN<0 D  G ADD1
 .W ?35,"...No entry found"
 S STANAME=$P(STATION,"^",2)
 S STANO=$$GETSTANO^PPPGET1(SNIFN)
 ;
 D PATDATA(PATDFN) S PATNAME=$G(PPPTMP(2,PATDFN,.01)) K PPPTMP
 S ERR=$$NEWFFX(PATDFN,SNIFN,1)
 I ERR=-1001 D  Q
 .N DIK,DA
 .S DIK="^PPP(1020.2,"
 .S DA=FFIFN
 .D ^DIK
 ;
 I ERR<0 D  Q
 .W !,*7,"An unexpected error occurred"
 .S TMP=$$STATUPDT^PPPMSC1(5,1)
 .S TMP=$$LOGEVNT^PPPMSC1(ERR,"ADD_PPPEDT14",PATNAME)
 .R !,"Press <RETURN> to continue...",TMP:DTIME
 ;
 I ERR=LOCKERR D
 .W !,"File in use.  Please try again later."
 .R !,"Press <RETURN> to continue...",TMP:DTIME
 E  D
 .S TMP=$$LOGEVNT^PPPMSC1(NEWENTRY,"ADD_PPPEDT14",PATNAME_", "_STANO)
 .;W !,"New entry added."
 .;R !,"Press <RETURN> to continue...",TMP:DTIME
 D INIT^PPPEDT12
 S VALMBCK="R"
 K FFIFN
 Q
 ;
NEWFFX(PATDFN,SNIFN,SRC) ; Create a new FFX entry
 ;
 N PARMERR,FINDERR,LOCLERR,DIC,X,Y,TMP,ERR,DTOUT,DUOUT
 ;
 S PARMERR=-9001
 S FINDERR=-9003
 S LOCKERR=-9004
 S ERR=0
 ;
 ; Check Input Parameters
 ;
 I '$D(PATDFN) Q PARMERR
 I '$D(SNIFN) Q PARMERR
 I '$D(SRC) Q PARMERR
 I SRC<0!(SRC>1) Q PARMERR
 ;
 ; Set up FileMan For New Entry
 ;
 S DIC="^PPP(1020.2,"
 S DIC(0)=""
 S X=PATDFN
 S DIC("DR")="1////"_SNIFN_";7////"_SRC
 L +(^PPP(1020.2)):5
 I '$T D
 .S ERR=LOCKERR
 E  D
 .K DD,DO D FILE^DICN
 .L -(^PPP(1020.2)):5
 ;
 ; If the entry was added successfully, add the remaining fields
 ;
 I 'ERR D
 .I $P(Y,"^",3)=1 D
 ..S FFIFN=$P(Y,"^",1)
 ..S TMP=$$EDTFFX^PPPEDT1(FFIFN)
 ..I TMP<0 S ERR=TMP
 .E  S ERR=FINDERR
 Q ERR
 ;
PATDATA(PATDFN) ; Pulls data from patient file
 ;
 ; Note: Calling routine must kill PPPTMP
 ;
 N DIC,DA,DR,DIQ,DUOUT,DTOUT
 ;
 S DIC="^DPT(",DA=PATDFN,DR=".01",DIQ="PPPTMP" D EN^DIQ1
 Q
 ;
