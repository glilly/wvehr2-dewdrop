VEPERI3 ;DAOU/WCJ - Incoming HL7 messages ;10/10/06  15:11
 ;;1.0;VOEB;;Jun 12, 2005
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ; Find patient
 ; Add if not found and addflag set
 Q
 ;
 ; Find the patient's DFN
 ; If patient can not be found, add it or save it off depending on the flag being
 ; passed in
 ;
FINDPAT(HLP,FE,DFN,NPADDFLG,HLMTIEN) ;
 N NAME,DOB,HRN,ID,SEX,MSHDTTM,%DT,X,RESULT,MBI,SSN
 ;
 S FE=0
 ;
 ; There are some required fields to lookup a patient
 S MSHDTTM=$$GETDATA("MSH",1000,6)
 I MSHDTTM="" D  Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","REQUIRED PATIENT IDENTIFIER - MSH DATE/TIME MISSING",HLMTIEN,.HLP) Q
 ;
 S NAME=$$GETDATA("PID",1000,5)
 I NAME="" D  Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","REQUIRED PATIENT IDENTIFIER - NAME MISSING",HLMTIEN,.HLP) Q
 ;
 S DOB=$$GETDATA("PID",1000,7)
 I DOB="" D  Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","REQUIRED PATIENT IDENTIFIER - DOB MISSING",HLMTIEN,.HLP) Q
 I DOB["/" D  Q:FE
 . S %DT="",X=DOB D ^%DT
 . I Y>0 S DOB=Y Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","REQUIRED PATIENT IDENTIFIER - DOB INVALID",HLMTIEN,.HLP) Q
 ;
 ; This won't be there since we are no longer doing a 2 way interface
 ; S HRN=$$GETDATA("PID",1000,2)   ;not required
 S HRN=""
 ;
 S ID=$$GETDATA("PID",1000,3)
 I ID="" D  Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","REQUIRED PATIENT IDENTIFIER - ID MISSING",HLMTIEN,.HLP) Q
 ;
 S SEX=$$GETDATA("PID",1000,8)
 I SEX="" D  Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","REQUIRED PATIENT IDENTIFIER - SEX MISSING",HLMTIEN,.HLP) Q
 ;
 S RESULT=$$LKUP^VEPERIC(HLMTIEN,MSHDTTM,"",DOB,ID,HRN,NAME,SEX)
 ;
 ; -1 is BAD.  Error is logged in VEPERIC
 I RESULT=-1 S FE=1 Q
 ;
 ; We have a match
 I +RESULT S DFN=RESULT Q
 ;
 ; Me thinks we have a new patient
 S MBI=$$GETDATA("PID",1000,24)   ; multiple birth indicator
 S SSN=$$GETDATA("PID",1000,19)   ; social security number
 I RESULT=0 D  Q:FE
 .I NPADDFLG D ADDPAT(NAME,DOB,SEX,.DFN,FE,HLMTIEN,.HLP) Q
 .I 'NPADDFLG D SAVEPAT(NAME,DOB,SEX,ID,HLMTIEN,MSHDTTM,.DUZ,FE,.HLP)
 Q
 ;
 ; The data will be in one of two places.
 ; On if it was mapped or manipulated after coming in or another if it was not.
 ; SETID is always 1000 on non repeating segments such as PID
GETDATA(SEG,SETID,SEQ) ;
 N DATA
 S DATA=$G(HLP(SEG,SETID,SEQ,0)) I DATA]"" Q DATA
 Q $G(HLP(SEG,SETID,SEQ))
 ;
 ; Save the information on this record for another day
 ; Dates need be in MMDDYYYY@HHMMSS or MM/DD/YYYY@HHMMSS
 ;
SAVEPAT(NAME,DOB,SEX,ID,HLMTIEN,MSGDTTM,DUZ,FE,HLP) ;
 N DIE,DIC,X,DR
 S X="`"_HLMTIEN
 S DIC=19904.21,DIC(0)="L"
 S DIC("DR")=".02///^S X=NAME;.03///^S X=DOB;.04///^S X=SEX;.06///^S X=ID;.07///NOW;.08///^S X=DUZ;.09///^S X=MSGDTTM"
 D ^DIC
 ;
 I '+Y D  Q
 . S FE=$$FATALERR^VEPERI6(1,"SYSTEM","CAN'T ADD TO NEW PATIENT HOLD FILE 19904.21",HLMTIEN,.HLP) Q
 ;
 Q
 ;
 ; Add a patient to file 2 & 9000001
 ; This just adds a stub to get the patient started.
ADDPAT(NAME,DOB,SEX,DFN,FE,HLMTIEN,HLP) ;
 N DIC,HRN,IENS,DATA,DLAYGO,RET,X,FDA
 ;
 ; These variables are most likely set by DIC,DIE and IHS lookup routines.
 N Y,VAERR,FDAIEN,DIW,DGUSER,DFN,DDER,DA,C,DICR,SSN
 N AUPNSEX,AUPNPAT,AUPNLK,AUPNDOD,AUPNDOB,AUPNDAYS,AGE,%I,%1,%L
 ;
 S FE=0
 I $G(NAME)=""!($G(DOB)="")!($G(SEX)="") D  Q
 . S FE=$$FATALERR^VEPERI6(1,"DATA","NAME, DOB OR SEX MISSING FROM PATIENT ADD",HLMTIEN,.HLP) Q
 ;
 ; Add stub patient
 ; Force the entry because we already determined it was a new patient
 S X=""""_NAME_""""
 S DIC=2,DIC(0)="L",DLAYGO=2
 S DIC("DR")=".301///N;391///VISTA OFFICE EHR;1901///N;.03///"_DOB_";.02///"_SEX
 D ^DIC
 I Y<0 D  Q
 . S FE=$$FATALERR^VEPERI6(1,"PATADD","PROBLEM ADDING PATIENT",HLMTIEN,.HLP) Q
 ;
 S DFN=+Y
 ;
 ; Create patient in IHS global
 S HRN=$$GENHRN^MPIFAG1()
 S IENS="?+1,"_+Y_","
 S DATA="FDA"
 S FDA(9000001.41,IENS,.01)=DUZ(2)
 S FDA(9000001.41,IENS,.02)=HRN
 D UPDATE^DIE("",DATA,"FDAIEN","RET")
 I $D(RET) D  Q
 . S FE=$$FATALERR^VEPERI6(1,"PATADD","PROBLEM ADDING PATIENT HRN",HLMTIEN,.HLP) Q
 Q
