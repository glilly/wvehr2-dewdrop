VBECRPCD        ;DALOI/RLM - Lookup HOSPITAL LOCATION based on DIVISION ;12 January 2004
        ;;1.0;VBECS;;Apr 14, 2005;Build 35
        ;
        ; Note: This routine supports data exchange with an FDA registered
        ; medical device. As such, it may not be changed in any way without
        ; prior written approval from the medical device manufacturer.
        ; 
        ; Integration Agreements:
        ; Reference to ^SC( supported by IA #10040
        ; Reference to $$SITE^VASITE supported by IA #10112
        ; Reference to $$CHARCHK^XOBVLIB supported by IA #4090
        ;
        ; This routine should not be called from the top.
        QUIT
        ;
LOC(RESULTS,DIV)        ; Main RPC Entry
        S VBECCNT=0
        S RESULTS=$NA(^TMP("VBECHLOC",$J))
        K @RESULTS
        D BEGROOT^VBECRPC("HospitalLocations")
        I DIV="" D  Q
        . D ADD^VBECRPC("<Error>No Division Provided</Error>")
        . D ENDROOT^VBECRPC("HospitalLocations")
        . Q
        I DIV]"" D LOOK
        D ENDROOT^VBECRPC("HospitalLocations")
        Q
LOOK    ;
        S VBECA=0 F  S VBECA=$O(^SC(VBECA)) Q:'VBECA  D
         . Q:'$P(^SC(VBECA,0),U,15)  ;No Division
         . Q:$D(^SC(VBECA,"I"))  ;Inactive Location???
         . Q:"CW"'[$P(^SC(VBECA,0),U,3)  ;Clinic or Ward only???
         . I DIV=$P($$SITE^VASITE(DT,+$P(^SC(VBECA,0),U,15)),U,3) D
         . . D BEGROOT^VBECRPC("Location")
         . . D ADD^VBECRPC("<LocationName>"_$$CHARCHK^XOBVLIB($$WSTRIP($P(^SC(VBECA,0),U)))_"</LocationName>")
         . . D ADD^VBECRPC("<LocationIEN>"_$$CHARCHK^XOBVLIB(VBECA)_"</LocationIEN>")
         . . D ADD^VBECRPC("<LocationType>"_$$CHARCHK^XOBVLIB($P(^SC(VBECA,0),U,3))_"</LocationType>")
         . . D ENDROOT^VBECRPC("Location")
        Q
KILL    ;
        K DIV,VBDATA,VBECA,VBECCNT
        Q
WSTRIP(VBDATA)  ;Strip White Space
        F  Q:$E(VBDATA,$L(VBDATA))'=" "  S VBDATA=$E(VBDATA,1,$L(VBDATA)-1)
        F  Q:$E(VBDATA,1)'=" "  S VBDATA=$E(VBDATA,2,$L(VBDATA))
        Q VBDATA
        ;
TESTLOC ; Entry point to write the results of the Get Hospital Locations RPC
        ; Function in XML format
        ;
        S VBECTST=1
        D LOC(.RESULTS,"589")
        S X=0
        F  S X=$O(@RESULTS@(X)) Q:X=""  D
        . W @RESULTS@(X)
        Q
