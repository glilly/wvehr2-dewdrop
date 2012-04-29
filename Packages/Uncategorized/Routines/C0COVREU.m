C0COVREU ; CCDCCR/ELN - CCR/CCD PROCESSING FOR LAB,RAD,TIU RESULTS ; 10/12/15
        ;;1.0;;;;Build 40
        ;
        ;
GHL7    ; GET HL7 MESSAGE FOR LABS FOR THIS PATIENT
        N C0CPTID,C0CSPC,C0CSDT,C0CEDT,C0CR,C0CLLMT,C0CLSTRT
        ; SET UP FOR LAB API CALL
        S C0CPTID=$$SSN^C0CDPT(DFN) ; GET THE SSN FOR THIS PATIENT
        I C0CPTID="" D  Q  ; NO SSN, COMPLAIN AND QUIT
        . W "LAB LOOKUP FAILED, NO SSN",!
        . S C0CNSSN=1 ; SET NO SSN FLAG
        S C0CSPC="*" ; LOOKING FOR ALL LABS
        ;I $D(^TMP("C0CCCR","RPMS")) D  ; RUNNING RPMS
        ;. D DT^DILF(,"T-365",.C0CSDT) ; START DATE ONE YEAR AGO TO LIMIT VOLUME
        ;E  D DT^DILF(,"T-5000",.C0CSDT) ; START DATE LONG AGO TO GET EVERYTHING
        ;D DT^DILF(,"T",.C0CEDT) ; END DATE TODAY
        S C0CLLMT=$$GET^C0CPARMS("LABLIMIT") ; GET THE LIMIT PARM
        S C0CLSTRT=$$GET^C0CPARMS("LABSTART") ; GET START PARM
        D DT^DILF(,C0CLLMT,.C0CSDT) ;
        W "LAB LIMIT: ",C0CLLMT,!
        D DT^DILF(,C0CLSTRT,.C0CEDT) ; END DATE TODAY - IMPLEMENT END DATE PARM
        S C0CR=$$LAB^C0CLA7Q(C0CPTID,C0CSDT,C0CEDT,C0CSPC,C0CSPC) ; CALL LAB LOOKUP
        Q
LTYP(OSEG,OTYP,OVARA,OC0CQT)    ;
        N OI,OI2,OTAB,OTI,OV,OVAR
        S OTAB=$NA(@C0CTAB@(OTYP)) ; TABLE FOR SEGMENT TYPE
        I '$D(OC0CQT) S C0CQT=0 ; NOT C0CQT IS DEFAULT
        E  S C0CQT=OC0CQT ; ACCEPT C0CQT FLAG
        I 1 D  ; FOR HL7 SEGMENT TYPE
        . S OI="" ; INDEX INTO FIELDS IN SEG
        . F  S OI=$O(@OTAB@(OI)) Q:OI=""  D  ; FOR EACH FIELD OF THE SEGMENT
        . . S OTI=$P(@OTAB@(OI),"^",1) ; TABLE INDEX
        . . S OVAR=$P(@OTAB@(OI),"^",4) ; CCR VARIABLE IF DEFINED
        . . S OV=$P(OSEG,"|",OTI+1) ; PULL OUT VALUE
        . . I $P(OI,";",2)'="" D  ; THIS IS DEFINING A SUB-VALUE
        . . . S OI2=$P(OTI,";",2) ; THE SUB-INDEX
        . . . S OV=$P(OV,"^",OI2) ; PULL OUT SUB-VALUE
        . . I OVAR'="" S OVARA(OVAR)=OV ; PASS BACK VARIABLE AND VALUE
        . . I 'C0CQT D  ; PRINT OUTPUT IF C0CQT IS FALSE
        . . . I OV'="" W OI_": "_$P(@OTAB@(OI),"^",3),": ",OVAR,": ",OV,!
        Q
LOBX    ;
        Q
        ;
OUT(DFN) ; WRITE OUT A CCR THAT HAS JUST BEEN PROCESSED (FOR TESTING)
        N GA,GF,GD
        S GA=$NA(^TMP("C0CCCR",$J,DFN,"CCR",1))
        S GF="RPMS_CCR_"_DFN_"_"_DT_".xml"
        S GD=^TMP("C0CCCR","ODIR")
        W $$OUTPUT^C0CXPATH(GA,GF,GD)
        Q
SETTBL  ;
        K X ; CLEAR X
        S X("PID","PID1")="1^00104^Set ID - Patient ID"
        S X("PID","PID2")="2^00105^Patient ID (External ID)"
        S X("PID","PID3")="3^00106^Patient ID (Internal ID)"
        S X("PID","PID4")="4^00107^Alternate Patient ID"
        S X("PID","PID5")="5^00108^Patient's Name"
        S X("PID","PID6")="6^00109^Mother's Maiden Name"
        S X("PID","PID7")="7^00110^Date of Birth"
        S X("PID","PID8")="8^00111^Sex"
        S X("PID","PID9")="9^00112^Patient Alias"
        S X("PID","PID10")="10^00113^Race"
        S X("PID","PID11")="11^00114^Patient Address"
        S X("PID","PID12")="12^00115^County Code"
        S X("PID","PID13")="13^00116^Phone Number - Home"
        S X("PID","PID14")="14^00117^Phone Number - Business"
        S X("PID","PID15")="15^00118^Language - Patient"
        S X("PID","PID16")="16^00119^Marital Status"
        S X("PID","PID17")="17^00120^Religion"
        S X("PID","PID18")="18^00121^Patient Account Number"
        S X("PID","PID19")="19^00122^SSN Number - Patient"
        S X("PID","PID20")="20^00123^Drivers License - Patient"
        S X("PID","PID21")="21^00124^Mother's Identifier"
        S X("PID","PID22")="22^00125^Ethnic Group"
        S X("PID","PID23")="23^00126^Birth Place"
        S X("PID","PID24")="24^00127^Multiple Birth Indicator"
        S X("PID","PID25")="25^00128^Birth Order"
        S X("PID","PID26")="26^00129^Citizenship"
        S X("PID","PID27")="27^00130^Veteran.s Military Status"
        S X("PID","PID28")="28^00739^Nationality"
        S X("PID","PID29")="29^00740^Patient Death Date/Time"
        S X("PID","PID30")="30^00741^Patient Death Indicator"
        S X("NTE","NTE1")="1^00573^Set ID - NTE"
        S X("NTE","NTE2")="2^00574^Source of Comment"
        S X("NTE","NTE3")="3^00575^Comment"
        S X("ORC","ORC1")="1^00215^Order Control"
        S X("ORC","ORC2")="2^00216^Placer Order Number"
        S X("ORC","ORC3")="3^00217^Filler Order Number"
        S X("ORC","ORC4")="4^00218^Placer Order Number"
        S X("ORC","ORC5")="5^00219^Order Status"
        S X("ORC","ORC6")="6^00220^Response Flag"
        S X("ORC","ORC7")="7^00221^Quantity/Timing"
        S X("ORC","ORC8")="8^00222^Parent"
        S X("ORC","ORC9")="9^00223^Date/Time of Transaction"
        S X("ORC","ORC10")="10^00224^Entered By"
        S X("ORC","ORC11")="11^00225^Verified By"
        S X("ORC","ORC12")="12^00226^Ordering Provider"
        S X("ORC","ORC13")="13^00227^Enterer's Location"
        S X("ORC","ORC14")="14^00228^Call Back Phone Number"
        S X("ORC","ORC15")="15^00229^Order Effective Date/Time"
        S X("ORC","ORC16")="16^00230^Order Control Code Reason"
        S X("ORC","ORC17")="17^00231^Entering Organization"
        S X("ORC","ORC18")="18^00232^Entering Device"
        S X("ORC","ORC19")="19^00233^Action By"
        S X("OBR","OBR1")="1^00237^Set ID - Observation Request"
        S X("OBR","OBR2")="2^00216^Placer Order Number"
        S X("OBR","OBR3")="3^00217^Filler Order Number"
        S X("OBR","OBR4")="4^00238^Universal Service ID"
        S X("OBR","OBR4;LOINC")="4;1^00238^Universal Service ID - LOINC^RESULTCODE"
        S X("OBR","OBR4;DESC")="4;2^00238^Universal Service ID - DESC^RESULTDESCRIPTIONTEXT"
        S X("OBR","OBR4;VACODE")="4;3^00238^Universal Service ID - VACODE^RESULTCODINGSYSTEM"
        S X("OBR","OBR5")="5^00239^Priority"
        S X("OBR","OBR6")="6^00240^Requested Date/Time"
        S X("OBR","OBR7")="7^00241^Observation Date/Time^RESULTASSESSMENTDATETIME"
        S X("OBR","OBR8")="8^00242^Observation End Date/Time"
        S X("OBR","OBR9")="9^00243^Collection Volume"
        S X("OBR","OBR10")="10^00244^Collector Identifier"
        S X("OBR","OBR11")="11^00245^Specimen Action Code"
        S X("OBR","OBR12")="12^00246^Danger Code"
        S X("OBR","OBR13")="13^00247^Relevant Clinical Info."
        S X("OBR","OBR14")="14^00248^Specimen Rcv'd. Date/Time"
        S X("OBR","OBR15")="15^00249^Specimen Source"
        S X("OBR","OBR16")="16^00226^Ordering Provider XCN^RESULTSOURCEACTORID"
        S X("OBR","OBR17")="17^00250^Order Callback Phone Number"
        S X("OBR","OBR18")="18^00251^Placers Field 1"
        S X("OBR","OBR19")="19^00252^Placers Field 2"
        S X("OBR","OBR20")="20^00253^Filler Field 1"
        S X("OBR","OBR21")="21^00254^Filler Field 2"
        S X("OBR","OBR22")="22^00255^Results Rpt./Status Change"
        S X("OBR","OBR23")="23^00256^Charge to Practice"
        S X("OBR","OBR24")="24^00257^Diagnostic Service Sect"
        S X("OBR","OBR25")="25^00258^Result Status^RESULTSTATUS"
        S X("OBR","OBR26")="26^00259^Parent Result"
        S X("OBR","OBR27")="27^00221^Quantity/Timing"
        S X("OBR","OBR28")="28^00260^Result Copies to"
        S X("OBR","OBR29")="29^00261^Parent Number"
        S X("OBR","OBR30")="30^00262^Transportation Mode"
        S X("OBR","OBR31")="31^00263^Reason for Study"
        S X("OBR","OBR32")="32^00264^Principal Result Interpreter"
        S X("OBR","OBR33")="33^00265^Assistant Result Interpreter"
        S X("OBR","OBR34")="34^00266^Technician"
        S X("OBR","OBR35")="35^00267^Transcriptionist"
        S X("OBR","OBR36")="36^00268^Scheduled Date/Time"
        S X("OBR","OBR37")="37^01028^Number of Sample Containers"
        S X("OBR","OBR38")="38^38^01029 Transport Logistics of Collected Sample"
        S X("OBR","OBR39")="39^01030^Collector.s Comment"
        S X("OBR","OBR40")="40^01031^Transport Arrangement Responsibility"
        S X("OBR","OBR41")="41^01032^Transport Arranged"
        S X("OBR","OBR42")="42^01033^Escort Required"
        S X("OBR","OBR43")="43^01034^Planned Patient Transport Comment"
        S X("OBX","OBX1")="1^00559^Set ID - OBX"
        S X("OBX","OBX2")="2^00676^Value Type"
        S X("OBX","OBX3")="3^00560^Observation Identifier"
        S X("OBX","OBX3;C1")="3;1^00560^Observation Identifier^C1"
        S X("OBX","OBX3;C2")="3;2^00560^Observation Identifier^C2"
        S X("OBX","OBX3;C3")="3;3^00560^Observation Identifier^C3"
        S X("OBX","OBX3;C4")="3;4^00560^Observation Identifier^C4"
        S X("OBX","OBX3;C5")="3;5^00560^Observation Identifier^C5"
        S X("OBX","OBX3;C6")="3;6^00560^Observation Identifier^C6"
        S X("OBX","OBX4")="4^00769^Observation Sub-Id"
        S X("OBX","OBX5")="5^00561^Observation Results^RESULTTESTVALUE"
        S X("OBX","OBX6")="6^00562^Units^RESULTTESTUNITS"
        S X("OBX","OBX7")="7^00563^Reference Range^RESULTTESTNORMALDESCTEXT"
        S X("OBX","OBX8")="8^00564^Abnormal Flags^RESULTTESTFLAG"
        S X("OBX","OBX9")="9^00639^Probability"
        S X("OBX","OBX10")="10^00565^Nature of Abnormal Test"
        S X("OBX","OBX11")="11^00566^Observ. Result Status^RESULTTESTSTATUSTEXT"
        S X("OBX","OBX12")="12^00567^Date Last Normal Value"
        S X("OBX","OBX13")="13^00581^User Defined Access Checks"
        S X("OBX","OBX14")="14^00582^Date/Time of Observation^RESULTTESTDATETIME"
        S X("OBX","OBX15")="15^00583^Producer.s ID^RESULTTESTSOURCEACTORID"
        S X("OBX","OBX16")="16^00584^Responsible Observer"
        S X("OBX","OBX17")="17^00936^Observation Method"
        K ^TMP("C0CCCR","LABTBL")
        M ^TMP("C0CCCR","LABTBL")=X ; SET VALUES IN LAB TBL
        S ^TMP("C0CCCR","LABTBL",0)="V3"
        Q
