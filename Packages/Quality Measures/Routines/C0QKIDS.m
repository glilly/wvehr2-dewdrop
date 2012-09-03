C0QKIDS ; VEN/SMH - Kids Utilities for transporting C0Q data ; 7/31/12 3:36pm
        ;;1.0;C0Q;;May 21, 2012;Build 68
        ; Licensed under package license. See Documentation.
        ;
        ; PEPs: TRAN, POST, PRE
        ;
TRAN    ; Unified Transport; PEP
        ; D TRAN301  ; looks like I won't send that file over
        D TRAN201 ; C0Q MEASUREMENT
        D TRAN101 ; C0Q QUALITY MEASURE
        QUIT
POST    ; Unified Post; PEP
        ; D POST301  ; looks like I won't send that file over
        ; D POST101 ; C0Q QUALITY MEASURE ; As of T11, I won't do that anymore. -->
        ; I discovered that it will do it on destination systems that are set-up.
        ; So bad bad bad idea for me to do it in a post-init.
        ; ... I wrote TRAN101 to do the function of POST101.
        D POST201 ; C0Q MEASUREMENT
        QUIT
        ;
PRE     ; Unified Pre; PEP
        D PRE101
        QUIT
        ;
        ; << >>
        ;
TRAN101 ; Remove Untransportable pointers in C0Q QUALITY MEASURE; Private EP
        ; NB: I am reaching into KIDS's data here. This may not work for future versions
        ; of KIDS. However, I am exporting this only; once exported, it should work in
        ; any version of KIDS.
        N XPDIEN S XPDIEN=$QS(XPDGREF,2) ; Get IEN of KIDS Transport Global
        N X S X=$NA(^XTMP("XPDT",XPDIEN,"DATA",1130580001.101)) ; KIDS transports our data here
        N IEN S IEN=0 ; Looper
        F  S IEN=$O(@X@(IEN)) Q:'IEN  D  ; For each IEN, remove the following:
        . S $P(@X@(IEN,0),U,2)="" ; Numerator Patient List
        . S $P(@X@(IEN,0),U,3)="" ; Denominator Patient List
        . S $P(@X@(IEN,7),U,4)="" ; Negative Numerator List
        . S $P(@X@(IEN,7),U,2)="" ; Alternate Numerator List
        . S $P(@X@(IEN,7),U,3)="" ; Alternate Denominator List
        . S $P(@X@(IEN,7),U,5)="" ; Alternate Negative Numerator List
        QUIT
        ;
TRAN301 ; Grab FDA for entire file C0Q PATIENT LIST and store in Transport Global; Private EP
        ; Not used. Dead code.
        N C0QIEN S C0QIEN=0 ; IEN walker
        N C0QREF1 S C0QREF1=$NAME(^TMP("C0QOLD",$J)) ; Temporary Global Reference
        N C0QREF2 S C0QREF2=$NAME(^TMP("C0QNEW",$J)) ; Temporary Global Reference
        K @C0QREF1,@C0QREF2   ; Kill that
        F  S C0QIEN=$O(^C0Q(301,C0QIEN)) Q:'+C0QIEN  D
        . D GETS^DIQ(1130580001.301,C0QIEN_",","*","",C0QREF1) ; Load FDA's in there
        . M @C0QREF2@(1130580001.301,"?+"_C0QIEN_",")=@C0QREF1@(1130580001.301,C0QIEN_",") ; Change IENs to ?+ IENs
        M @XPDGREF@("C0Q","1130580001.301")=@C0QREF2  ; Put in Transport Global
        K @C0QREF1,@C0QREF2  ; Remove
        QUIT
        ;
TRAN201 ; Grab FDA for 201 C0Q MEASUREMENTS selected fields; Private EP
        N C0QIEN S C0QIEN=0 ; IEN walker
        N C0QREF1 S C0QREF1=$NAME(^TMP("C0QOLD",$J)) ; Temporary Global Reference
        N C0QREF2 S C0QREF2=$NAME(^TMP("C0QNEW",$J)) ; Temporary Global Reference
        K @C0QREF1,@C0QREF2   ; Kill that
        ;
        ; We need C0QCOUNT so that it wouldn't reuse the numbers, b/c updater wants numbers for every different item
        N C0QCOUNT S C0QCOUNT=$O(^C0Q(201," "),-1) ; Counter for SubIENs for destination array; init at highest IEN to prevent dups
        F  S C0QIEN=$O(^C0Q(201,C0QIEN)) Q:'+C0QIEN  D  ; Walk IENs
        . W "Exporting "_C0QIEN,!
        . ; Fields SET NAME, BEGIN DATE, END DATE, LOCKED, USE ALL MEASURES, MU YEAR KEY
        . D GETS^DIQ(1130580001.201,C0QIEN_",",".01;.02;.03;.05;.2;.3","",C0QREF1)
        . M @C0QREF2@(1130580001.201,"?+"_C0QIEN_",")=@C0QREF1@(1130580001.201,C0QIEN_",") ; Change IENs to ?+ IENs
        . N C0QIEN2 S C0QIEN2=0 ; Subfile walker
        . F  S C0QIEN2=$O(^C0Q(201,C0QIEN,5,C0QIEN2)) Q:'+C0QIEN2  D  ; MEASURE subfile
        . . W "Exporting IENS "_C0QIEN2_","_C0QIEN_",",!
        . . D GETS^DIQ(1130580001.2011,C0QIEN2_","_C0QIEN_",",".01","",C0QREF1) ; MEASURE (#.01)
        . . S C0QCOUNT=C0QCOUNT+1 ; Increment the counter for SubIEN (can't reuse)
        . . M @C0QREF2@(1130580001.2011,"?+"_C0QCOUNT_","_"?+"_C0QIEN_",")=@C0QREF1@(1130580001.2011,C0QIEN2_","_C0QIEN_",") ; as above
        ;
        M @XPDGREF@("C0Q","1130580001.201")=@C0QREF2 ; Put in transport global
        K @C0QREF1,@C0QREF2  ; Remove temp
        QUIT
        ;
POST201 ; File FDA for 201; Private EP
        ; 
        ; Clean-up data if it already exists!
        ; ZWRITE ^C0Q(201,:,5,:,0)        
        ; ^C0Q(201,1,5,599,0)=50
        ; ^C0Q(201,1,5,600,0)=4
        ; ^C0Q(201,1,5,601,0)=39
        ; ^C0Q(201,1,5,602,0)=6
        ; ^C0Q(201,1,5,603,0)=7
        ; ^C0Q(201,1,5,604,0)=48
        ; ^C0Q(201,1,5,605,0)=46
        ;
        IF $O(^C0Q(201,0)) DO  QUIT  ; Quit if data is already there.
        . D MES^XPDUTL("Data exists in file C0Q MEASUREMENTS... Not adding new data")
        . D MES^XPDUTL("Cleaning up broken pointers in C0Q MEASUREMENTS from deleted data in C0Q QUALITY MEASURE")
        . ; This is very hairy code. Run through the 5 multiple in C0Q MEASUREMENT
        . ; Grab the IEN in the .01, check if it exists; if not, kill.
        . N DA,DIK ; DIK Variables; as well as our looper variables
        . S (DA,DA(1))=0 ; Initial looper values
        . F  S DA(1)=$O(^C0Q(201,DA(1))) Q:'DA(1)  D  ; Loop through entries
        . . D MES^XPDUTL("...Processing entry "_$P(^C0Q(201,DA(1),0),U))  ; msg
        . . S DIK="^C0Q(201,"_DA(1)_",5,"  ; deletion root for the next loop
        . . F  S DA=$O(^C0Q(201,DA(1),5,DA)) Q:'DA  D  ; For each Measure
        . . . N IEN S IEN=+^C0Q(201,DA(1),5,DA,0)  ; Get IEN
        . . . I IEN,'$D(^C0Q(101,IEN)) D  ; If IEN is numeric, IEN exists in dest file
        . . . . D MES^XPDUTL("......Deleting broken pointer "_IEN) ; msg
        . . . . D ^DIK ; delete
        ;
        ; If new install, add data
        ;
        D MES^XPDUTL("Adding data to C0Q MEASUREMENTS")
        N C0QFDA S C0QFDA=$NAME(@XPDGREF@("C0Q","1130580001.201")) ; Grab FDA from Transport Global
        N C0QERR ; Error array for filer
        D UPDATE^DIE("E",C0QFDA,"","C0QERR") ; File all
        I $D(C0QERR) D  ; if there's an error, print it out
        . D MES^XPDUTL("Couldn't add data into C0Q MEASUREMENTS")
        . S C0QERR=$Q(C0QERR)
        . F  S C0QERR=$Q(@C0QERR) Q:C0QERR=""  D MES^XPDUTL(C0QERR_": "_@C0QERR)
        QUIT
        ;
POST301 ; Get FDA from Transport Global and install in destination system for C0Q PATIENT LIST; Private EP
        ; Not used. Dead code.
        N C0QFDA S C0QFDA=$NAME(@XPDGREF@("C0Q","1130580001.301")) ; FDA array name is the global reference
        N C0QERR ; Error 
        D UPDATE^DIE("E",C0QFDA,"","C0QERR") ; File all
        I $D(C0QERR) D  ; if there's an error, print it out
        . D MES^XPDUTL("Couldn't add data into C0Q PATIENT LIST file")
        . S C0QERR=$Q(C0QERR)
        . F  S C0QERR=$Q(@C0QERR) Q:C0QERR=""  D MES^XPDUTL(C0QERR_": "_@C0QERR)
        QUIT
        ;
PRE101  ; Clean existing data (from an earlier installation) from measures that are now merged to other measures
        ; in C0Q QUALITY MEASURE in destination systems; Private EP
        ;
        ; Quit if C0Q Quality Measures isn't on the system.
        Q:'$D(^C0Q(101))
        ; 
        D MES^XPDUTL("Removing subsumed entries in C0Q QUALITY MEASURE")
        ;
        ; .01 field values to for records to remove
        N C0QLIST
        S C0QLIST("TEST M0028A")=""
        S C0QLIST("MU EP 0028B")=""
        S C0QLIST("M0013")=""
        S C0QLIST("M0024")=""
        S C0QLIST("M1")=""
        S C0QLIST("M3")=""
        S C0QLIST("M2")=""
        S C0QLIST("M0028")=""
        S C0QLIST("M111")=""
        S C0QLIST("M112")=""
        S C0QLIST("M113")=""
        S C0QLIST("M128")=""
        S C0QLIST("M5")=""
        S C0QLIST("M7")=""
        S C0QLIST("M0022")=""
        S C0QLIST("12")=""
        S C0QLIST("M0038")=""
        S C0QLIST("M110")=""
        ;
        ; Root for ^DIK
        N DIK S DIK="^C0Q(101,"
        ;
        ; Loop through list, find IEN for each one, kill off
        N C0QITEM S C0QITEM=""                             ; Item
        F  S C0QITEM=$O(C0QLIST(C0QITEM)) Q:C0QITEM=""  D  ; Loop
        . Q:'$DATA(^C0Q(101,"B",C0QITEM))                  ; Quit if not present.
        . N DA S DA=$O(^C0Q(101,"B",C0QITEM,""))           ; IEN
        . D MES^XPDUTL("...Removing "_C0QITEM)                ; Message to user
        . D ^DIK                                           ; Delete
        ;
REN     ; Rename a bunch of entries
        ; ("OLD NAME")="NEW NAME"
        D MES^XPDUTL("Renaming Old entries in C0Q QUALITY MEASURE")
        ;
        N C0QLIST
        S C0QLIST("NQF0038 NUM1 DPT")="MU EP NQF 0038 NUM1 DPT"
        S C0QLIST("NQF0038 NUM10")="MU EP NQF 0038 NUM10 FLU"
        S C0QLIST("NQF0038 NUM11 COMBO5")="MU EP NQF 0038 NUM11 COMBO5"
        S C0QLIST("NQF0038 NUM12 COMBO6")="MU EP NQF 0038 NUM12 COMBO6"
        S C0QLIST("NQF0038 NUM2 IPV")="MU EP NQF 0038 NUM2 IPV"
        S C0QLIST("NQF0038 NUM3 MMR")="MU EP NQF 0038 NUM3 MMR"
        S C0QLIST("NQF0038 NUM4 HiB")="MU EP NQF 0038 NUM4 HiB"
        S C0QLIST("NQF0038 NUM5 HEP B")="MU EP NQF 0038 NUM5 HEP B"
        S C0QLIST("NQF0038 NUM6 VZV")="MU EP NQF 0038 NUM6 VZV"
        S C0QLIST("NQF0038 NUM7 PCV")="MU EP NQF 0038 NUM7 PCV"
        S C0QLIST("NQF0038 NUM8 HEP A")="MU EP NQF 0038 NUM8 HEP A"
        S C0QLIST("NQF0038 NUM9")="MU EP NQF 0038 NUM9 RV"
        S C0QLIST("M124")="PQRI MEASURE 124"
        S C0QLIST("M173")="PQRI MEASURE 173"
        S C0QLIST("M39")="PQRI MEASURE 39"
        S C0QLIST("M47")="PQRI MEASURE 47"
        S C0QLIST("M48")="PQRI MEASURE 48"
        ;
        N C0QITEM S C0QITEM=""                              ; Item
        N C0QFDA                                            ; FDA
        F  S C0QITEM=$O(C0QLIST(C0QITEM))  Q:C0QITEM=""  D  ; Loop through
        . N IEN S IEN=$O(^C0Q(101,"B",C0QITEM,""))          ; Get IEN from File using old name
        . I IEN S C0QFDA(1130580001.101,IEN_",",.01)=C0QLIST(C0QITEM)  ; If found, put new name in FDA for this IEN
        . I IEN D MES^XPDUTL("...Renaming "_C0QITEM_" to "_C0QLIST(C0QITEM)) ; Print message to user
        ;
        N C0QERR                                            ; Error for FILE^DIE
        I $D(C0QFDA) D FILE^DIE("E",$NA(C0QFDA),$NA(C0QERR))  ; File if FDA has contents
        E  D MES^XPDUTL("No entries to rename")             ; If nothing, tell user so
        ; 
        D:$D(C0QERR)                                        ; If Error, print it
        . D MES^XPDUTL("Error Filing Data. FILE^DIE reported:")
        . N REF S REF=$NA(C0QERR)                           ; $Q Reference
        . F  S REF=$Q(@REF) Q:REF=""  D MES^XPDUTL(REF_"="_@REF) ; Loop and Print
        ;
        QUIT
