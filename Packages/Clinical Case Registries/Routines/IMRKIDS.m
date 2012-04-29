IMRKIDS ;HCIOFO/SG - INSTALL UTILITIES (LOW-LEVEL) ; 7/23/02 8:31am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**18**;Feb 09, 1998
 ;
 Q
 ;
 ;***** DISPLAYS THE INSTALLATION MESSAGE
BMES(MSG,INFO) ;
 N I
 D BMES^XPDUTL("   "_MSG)
 S I=""
 F  S I=$O(INFO(I))  Q:I=""  D MES^XPDUTL("   "_INFO(I))
 Q
 ;
 ;***** DELETES ALL RECORDS FROM THE (SUB)FILE
 ;
 ; FILE          File/Subfile number
 ; [IENS]        IENS of the subfile
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
CLRFILE(FILE,IENS) ;
 N IEN,IMRFDA,IMRMSG,RC,ROOT
 S ROOT=$$ROOT^DILFD(FILE,$G(IENS),1)
 S:$G(IENS)="" IENS=","
 ;--- Delete the records
 S (IEN,RC)=0
 F  S IEN=$O(@ROOT@(IEN))  Q:'IEN  D  Q:RC<0
 . S IMRFDA(FILE,IEN_IENS,.01)="@"
 . D FILE^DIE(,"IMRFDA","IMRMSG")
 . I $G(DIERR)  D  Q
 . . S RC=$$DBSERR("IMRMSG",-9,"CLRFILE^IMRKIDS",FILE,IEN_IENS)
 Q $S(RC<0:RC,1:0)
 ;
 ;***** PROCESSES THE INSTALL CHECKPOINT
 ;
 ; CPNAME        Checkpoint name
 ;
 ; CALLBACK      Callback entry point ($$TAG^ROUTINE). This function
 ;               accepts no parameters and must return either 0 if
 ;               everything is Ok or a negative error code.
 ;
 ; [PARAM]       Value to set checkpoint parameter to.
 ;
 ; The function checks if the checkpoint is completed. If it is not,
 ; the callback entry point is XECUTEd. If everything is Ok, the
 ; function will complete the checkpoint.
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
CP(CPNAME,CALLBACK,PARAM) ;
 N RC
 ;--- Verify the checkpoint and quit if it is completed
 S RC=$$VERCP^XPDUTL(CPNAME)  Q:RC>0 0
 ;--- Create the new checkpoint
 I RC<0  D  Q:'RC $$ERROR(-3,"CP^IMRKIDS",,CPNAME)
 . S RC=$$NEWCP^XPDUTL(CPNAME,,.PARAM)
 ;--- Reset the KIDS progress bar
 S XPDIDTOT=0  D UPDATE^XPDID(0)
 ;--- Execute the callback entry point
 X "S RC="_CALLBACK  Q:RC<0 RC
 ;--- Complete the check point
 S RC=$$COMCP^XPDUTL(CPNAME)
 Q:'RC $$ERROR(-4,"CP^IMRKIDS",,CPNAME)
 Q 0
 ;
 ;***** CHECKS THE ERRORS AFTER A FILEMAN DBS CALL
 ;
 ; IMR8MSG       Closed reference of the error messages array
 ;               (from DBS calls)
 ; [ERRCODE]     Error code to assign
 ; PLACE         Location of the error (see the $$ERROR)
 ; [FILE]        File number used in the DBS call
 ; [IENS]        IENS used in the DBS call
 ;
 ; The $$DBSERR^IMRKIDS function checks the DIERR and @IMR8MSG
 ; variables for errors after a FileMan DBS call.
 ;
 ; Return Values:
 ;
 ; If there are no errors found, it returns an empty string.
 ; In case of errors, the result depends on value of the ERRCODE
 ; parameter:
 ;
 ; If ERRCODE is omitted or equals 0, the function returns a string
 ; containing the list of error codes separated by comma.
 ;
 ; If ERRCODE is not zero, the $$ERROR^IMRKIDS function is called and
 ; its return value is returned.
 ;
DBSERR(IMR8MSG,ERRCODE,PLACE,FILE,IENS) ;
 Q:'$G(DIERR) ""
 N ERRLST,ERRNODE,I,MSGTEXT
 S ERRNODE=$S($G(IMR8MSG)'="":$NA(@IMR8MSG@("DIERR")),1:$NA(^TMP("DIERR",$J)))
 Q:$D(@ERRNODE)<10 ""
 I '$G(ERRCODE)  D  Q $P(ERRLST,",",2,99)
 . S ERRLST="",I=0
 . F  S I=$O(@ERRNODE@(I))  Q:'I  S ERRLST=ERRLST_","_@ERRNODE@(I)
 . D CLEAN^DILF
 D MSG^DIALOG("AE",.MSGTEXT,,,$G(IMR8MSG)),CLEAN^DILF
 S I=$S($G(FILE):"; File #"_FILE,1:"")
 S:$G(IENS)'="" I=I_"; IENS: """_IENS_""""
 Q $$ERROR(ERRCODE,PLACE,.MSGTEXT,I)
 ;
 ;***** DELETES THE (SUB)FILE DD AND DATA (IF REQUESTED)
 ;
 ; FILE          File number
 ;
 ; [FLAGS]       String that contains flags for EN^DIU2:
 ;                 "D"  Delete the data as well as the DD
 ;                 "E"  Echo back information during deletion
 ;                 "S"  Subfile data dictionary is to be deleted
 ;                 "T"  Templates are to be deleted
 ;
 ; [SILENT]      If this parameters is defined and non-zero, the
 ;               function will work in "silent" mode.
 ;               Nothing (except error messages if debug mode >1 is
 ;               enabled) will be displayed on the console or stored
 ;               into the INSTALLATION file.
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
DELFILE(FILE,FLAGS,SILENT) ;
 Q:'$$VFILE^DILFD(+FILE) 0
 N DIU,FT,RC
 S DIU=+FILE,DIU(0)=$G(FLAGS)
 I '$G(SILENT)  D
 . S FT=$S(DIU(0)["S":"subfile",1:"file")
 . D BMES("Deleting the "_FT_" #"_(+FILE)_"...")
 D EN^DIU2
 D:'$G(SILENT) MES("The "_FT_" has been deleted.")
 Q 0
 ;
 ;***** DELETES FIELD DEFENITIONS FROM THE DD
 ;
 ; FILE          File number
 ;
 ; FLDLST        String that contains list of field numbers to
 ;               delete (separated with the ';').
 ;
 ; [SILENT]      If this parameters is defined and non-zero, the
 ;               function will work in "silent" mode.
 ;               Nothing (except error messages if debug mode >1 is
 ;               enabled) will be displayed on the console or stored
 ;               into the INSTALLATION file.
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
DELFLDS(FILE,FLDLST,SILENT) ;
 Q:'$$VFILE^DILFD(+FILE) 0
 N DA,DIK,I,RC,ROOT
 D:'$G(SILENT)
 . D BMES("Deleting the field definitions...")
 . D MES("File #"_(+FILE)_", Fields: '"_FLDLST_"'")
 S DA(1)=+FILE,DIK="^DD("_DA(1)_","
 F I=1:1  S DA=$P(FLDLST,";",I)  Q:'DA  D ^DIK
 D:'$G(SILENT) MES("The definitions have been deleted.")
 Q 0
 ;
 ;***** DISPLAYS A LINE OF THE ERROR MESSAGE
 ;
 ; MSG           Message to display
 ; [SKIP]        Skip a line before the output
 ;
ERRDL(MSG,SKIP) ;
 I $D(XPDENV)!($G(XPDNM)="")  W:$G(SKIP) !  W MSG,!  Q
 I $G(SKIP)  D BMES^XPDUTL(MSG)  Q
 D MES^XPDUTL(MSG)
 Q
 ;
 ;***** DISPLAYS THE ERROR
 ;
 ; ERRCODE       Error code.
 ;
 ; PLACE         Location of the error (TAG^ROUTINE).
 ;
 ; [[.]IMRINFO]  Optional additional information (either a string or
 ;               a reference to a local array that contains strings
 ;               prepared for storing in a word processing field)
 ;
 ; [ARG2-ARG5]   Optional parameters as for $$MSG^IMRKIDS1
 ;
 ; Return Values:
 ;       <0  Error code (value of the ERRCODE)
 ;        0  Ok (if ERRCOCE'<0)
 ;
ERROR(ERRCODE,PLACE,IMRINFO,ARG2,ARG3,ARG4,ARG5) ;
 Q:ERRCODE'<0 0
 N IR,MSG,TMP,TYPE
 I $D(IMRINFO)=1  S IR=IMRINFO  K IMRINFO  S IMRINFO(1)=IR,IR=1
 E  S IR=$O(IMRINFO(""),-1)
 S MSG=$$MSG^IMRKIDS1(+ERRCODE,.TYPE,,.ARG2,.ARG3,.ARG4,.ARG5)
 S IR=IR+1,IMRINFO(IR)="Location: "_PLACE
 ;--- Display the message
 U:$G(IO(0))'="" IO(0)
 D ERRDL($P($$FMTE^XLFDT($$NOW^XLFDT,"2FS"),"@",2)_" "_$E(MSG,1,70),1)
 S IR=""
 F  S IR=$O(IMRINFO(IR))  Q:IR=""  D  D ERRDL($J("",9)_TMP)
 . S TMP=$G(IMRINFO(IR))  S:TMP="" TMP=$G(IMRINFO(IR,0))
 U IO
 Q ERRCODE
 ;
 ;***** DISPLAYS THE INSTALLATION MESSAGE
MES(MSG,INFO) ;
 N I
 D MES^XPDUTL("   "_MSG)
 S I=""
 F  S I=$O(INFO(I))  Q:I=""  D MES^XPDUTL("   "_INFO(I))
 Q
