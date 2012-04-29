VEPERI2 ;;DAOU/WCJ - Incoming HL7 messages ;2-MAY-2005
 ;;1.0;VOEB;;Jun 12, 2005;Build 1
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ;  Find matching insurance or file ne entries in 36, 355.3, and 366.03.
 ;
 Q
 ;
FILEINS(HLP,HLF,DFN,IEN,FE,HLMTIEN) ;
 ;
 Q:'$D(HLP("IN1"))
 ;
 N SETID,INSCONM,PLAN,PLANID
 S FE=0
 ;
 ; Make sure IN1 are sequential and start with 1.
 ; The first character of the 4 digit SETID is the SETID for IN1
 F SETID=1000:1000 Q:'$D(HLP("IN1",SETID))
 I $O(HLP("IN1",SETID)) S FE=$$FATALERR^VEPERI6(1,"HL7","INVALID SETID FOR IN1",HLMTIEN,.HLP) Q
 ;
 ; Get existing plans for this patient
 D GETINS(DFN,.PLAN) ;
 ;
 S SETID=0 F  S SETID=$O(HLP("IN1",SETID)) Q:'+SETID!(FE)  D
 . S INSCONM=$G(HLP("IN1",SETID,4))
 . I INSCONM="" S FE=$$FATALERR^VEPERI6(1,"DATA","IN1 MISSING INS CO NAME",HLMTIEN,.HLP) Q
 . S PLANID=$G(HLP("IN1",SETID,2))
 . I PLANID="" S FE=$$FATALERR^VEPERI6(1,"DATA","IN1 MISSING PLAN ID",HLMTIEN,.HLP)
 . ;
 . ; Check patient's exisitng info
 . I $D(PLAN(INSCONM,PLANID)) D  Q
 .. S IEN(SETID,36)=$P(PLAN(INSCONM,PLANID),U)
 .. S IEN(SETID,355.3)=$P(PLAN(INSCONM,PLANID),U,2)
 .. S IEN(SETID,366.03)=$P(PLAN(INSCONM,PLANID),U,3)
 .. D FILE
 . ;
 . ; Get all other INS CO/PLAN ID combos on file
 . D INSCO(INSCONM,.PLAN)
 . ;
 . ; See if any matched
 . I $D(PLAN(INSCONM,PLANID)) D  Q
 .. S IEN(SETID,36)=$P(PLAN(INSCONM,PLANID),U)
 .. S IEN(SETID,355.3)=$P(PLAN(INSCONM,PLANID),U,2)
 .. S IEN(SETID,366.03)=$P(PLAN(INSCONM,PLANID),U,3)
 .. D FILE
 . ;
 . S IEN(SETID,36)=$$ADD36(INSCONM)
 . I IEN(SETID,36)'=+IEN(SETID,36) S FE=IEN(SETID,36) Q
 . S IEN(SETID,366.03)=$$ADD36603(PLANID)
 . I IEN(SETID,366.03)'=+IEN(SETID,366.03) S FE=IEN(SETID,366.03) Q
 . S IEN(SETID,355.3)=$$ADD3553(IEN(SETID,36),IEN(SETID,366.03))
 . I IEN(SETID,355.3)'=+IEN(SETID,355.3) S FE=IEN(SETID,355.3) Q
 . D FILE
 Q
 ;
FILE ;
 N FDA,FILE,FIELD,ERR
 F FILE=36,366.03,355.3 D  Q:FE
 . K FDA
 . S FIELD=0 F  S FIELD=$O(HLF("DATA",FILE,FIELD)) Q:FIELD=""  D
 .. Q:'$D(HLF("DATA",FILE,FIELD,SETID))
 .. S IEN=IEN(SETID,FILE)_","
 .. S FDA(FILE,IEN,FIELD)=HLF("DATA",FILE,FIELD,SETID)
 . Q:'$D(FDA)   ; nothing to file
 . D FILE^DIE("EKT","FDA","ERR")
 . I $D(ERR) Q
 Q
 ;
 ; This will get all the insurance for an existing patient.  It's
 ; purpose is to set up the following array.
 ;
 ; PLAN(INSURANCE CO NAME,PLAN ID)=
 ; [1] = IEN to file 36
 ; [2] = IEN to file 355.3
 ; [3] = IEN to file 366.03
 ;
 ; This subroutine assume that Plan ID are unique within and insurance company
 ;
GETINS(DFN,PLAN) ;
 ;
 Q:'+DFN
 ;
 N RESULT,INSIEN,SCREEN,NUM,DONE
 N INS,INSCONM,D0,DIC,DLAYGO
 S U="^"
 ;
 ; If this is an existing patient, see if this is about an exisiting
 ; entry on file being edited.
 D ALL^IBCNS1(DFN,"INS",,,1)   ; get all of the patients insurance
 S D0=0 F  S D0=$O(INS(D0)) Q:'D0  D
 . S INSIEN=$P(INS(D0,0),U)
 . ;
 . ; Only Check Ins Co once
 . Q:$D(DONE(INSIEN))
 . S DONE(INSIEN)=""
 . ;
 . ; Get INS CO name
 . K RESULT
 . D FIND^DIC(36,,"@;.01","AX",INSIEN,,,,,"RESULT")
 . Q:'$P(RESULT("DILIST",0),U)
 . S INSCONM=$G(RESULT("DILIST","ID",1,.01)) S:INSCONM="" INSCONM=" "
 . ;
 . ; Get all PLAN ID's for that insurance
 . K RESULT
 . D FIND^DIC(355.3,,"@;.03;6.01I;6.01","Q",INSIEN,,,,,"RESULT")
 . Q:'$P(RESULT("DILIST",0),U)
 . S NUM="" F  S NUM=$O(RESULT("DILIST","ID",NUM)) Q:'NUM  D
 .. N EXT
 .. S EXT=$G(RESULT("DILIST","ID",NUM,6.01,"E")) S:EXT="" EXT="NO PLAN ON FILE"
 .. S PLAN(INSCONM,EXT)=INSIEN_U_$G(RESULT("DILIST",2,NUM))_U_$G(RESULT("DILIST","ID",NUM,6.01,"I"))
 Q
 ;
INSCO(INSCO,PLAN) ;
 ;
 ; This will get all the PLAN ID's for an insurance co name.  It's
 ; purpose is to set up the following array.
 ;
 ; PLAN(INSURANCE CO NAME,PLAN ID)=
 ; [1] = IEN to file 36
 ; [2] = IEN to file 355.3
 ; [3] = IEN to file 366.03
 ;
 ; This subroutine assume that Plan ID are unique within and insurance company
 ;
 ; Find all active insurance companies with this exact name
 N RESULT,NUM,RESULT2,LOOP,INSIEN
 D FIND^DIC(36,,"@;.01","X",INSCO,,,,,"RESULT")
 ;
 ; Quit if no matches
 Q:'+RESULT("DILIST",0)
 ;
 ; One or more matches
 F LOOP=1:1 Q:'$D(RESULT("DILIST",2,LOOP))  D
 . S INSIEN=RESULT("DILIST",2,LOOP)
 . ;
 . ; Get all PLAN ID's for that insurance
 . K RESULT2
 . D FIND^DIC(355.3,,"@;.03;6.01I;6.01","Q",INSIEN,,,,,"RESULT2")
 . Q:'$P(RESULT2("DILIST",0),U)
 . S NUM="" F  S NUM=$O(RESULT2("DILIST","ID",NUM)) Q:'NUM  D
 .. N EXT
 .. S EXT=$G(RESULT2("DILIST","ID",NUM,6.01,"E")) S:EXT="" EXT="NO PLAN ON FILE"
 .. S PLAN(INSCONM,EXT)=INSIEN_U_$G(RESULT2("DILIST",2,NUM))_U_$G(RESULT2("DILIST","ID",NUM,6.01,"I"))
 Q
 ;
 ; Add an entry to file 36 INSURANCE COMPANY
ADD36(X) ;
 N Y
 S X=""""_X_""""
 S DIC=36,DIC(0)="L",DLAYGO=1
 D ^DIC
 I Y<1 S FE=$$FATALERR^VEPERI6(1,"DATA","COULD NOT ADD PLAN TO DICTIONARY",HLMTIEN,.HLP) Q FE
 Q +Y
 ;
 ; Add an entry to file 366.03 PLAN
ADD36603(X) ;
 N Y
 S X=""""_X_""""
 S DIC=366.03,DIC(0)="L",DLAYGO=1
 D ^DIC
 I Y<1 S FE=$$FATALERR^VEPERI6(1,"DATA","COULD NOT ADD PLAN TO DICTIONARY",HLMTIEN,.HLP) Q FE
 Q +Y
 ;
 ; Add an entry to file 355.3 GROUP INSURANCE PLAN
 ; This is passed in a pointer to 36 (ins co) and a pointer to 366.03 (plans)
ADD3553(P36,P36603) ;
 N Y
 S X=P36
 S DIC=355.3,DIC(0)="UL",DIC("S")="I 0"
 S DIC("DR")="6.01////"_P36603
 D ^DIC
 I Y<1 S FE=$$FATALERR^VEPERI6(1,"DATA","COULD NOT ADD PLAN TO DICTIONARY",HLMTIEN,.HLP) Q FE
 Q +Y
