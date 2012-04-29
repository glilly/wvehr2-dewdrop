C0CLA7DD ;WV/JMC - CCD/CCR Post Install DD X-Ref Setup Routine ; Aug 31, 2009
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;
 ; Tasked by C0C post-install routine C0CENV to create C0C cross-references on V LAB file.
 ;
 Q
 ;
 ;
EN ; Add new style cross-references to V LAB file if it exists.
 ; OLD entry point - see new KIDS check points in C0CENV.
 ;
 ;
 ; Quit if AUPNVLAB global does not exist.
 I $$VFILE^DILFD(9000010.09)'=1 Q
 ;
 N MSG
 ;
 S MSG="Starting installation of ALR1 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR1
 S MSG="Installation of ALR1 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 ;
 S MSG="Starting installation of ALR2 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR2
 S MSG="Installation of ALR2 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 ;
 S MSG="Starting installation of ALR3 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR3
 S MSG="Installation of ALR3 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 ;
 S MSG="Starting installation of ALR4 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR4
 S MSG="Installation of ALR4 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 ;
 S MSG="Starting installation of ALR5 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR5
 S MSG="Installation of ALR5 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 ;
 Q
 ;
 ;
ALR1 ; Installation of ALR1 cross-reference
 ;
 N C0CFLAG,C0CXR,C0CRES,C0COUT
 ;
 S C0CFLAG=""
 ;
 S C0CXR("FILE")=9000010.09
 S C0CXR("NAME")="ALR1"
 S C0CXR("TYPE")="R"
 S C0CXR("USE")="S"
 S C0CXR("EXECUTION")="R"
 S C0CXR("ACTIVITY")="IR"
 S C0CXR("SHORT DESCR")="X-ref to link entry with parent in LAB DATA file (#63)"
 S C0CXR("VAL",1)=.02
 S C0CXR("VAL",1,"SUBSCRIPT")=1
 S C0CXR("VAL",1,"COLLATION")="F"
 S C0CXR("VAL",2)=.06
 S C0CXR("VAL",2,"SUBSCRIPT")=2
 S C0CXR("VAL",2,"LENGTH")=30
 S C0CXR("VAL",2,"COLLATION")="F"
 S C0CXR("VAL",3)=.01
 S C0CXR("VAL",3,"SUBSCRIPT")=3
 S C0CXR("VAL",3,"COLLATION")="F"
 S C0CXR("VAL",4)=1201
 S C0CXR("VAL",4,"SUBSCRIPT")=4
 S C0CXR("VAL",4,"COLLATION")="F"
 D CREIXN^DDMOD(.C0CXR,C0CFLAG,.C0CRES,"C0COUT")
 ;
 Q
 ;
 ;
ALR2 ; Installation of ALR2 cross-reference
 ;
 N C0CFLAG,C0CXR,C0CRES,C0COUT
 ;
 S C0CFLAG=""
 ;
 S C0CXR("FILE")=9000010.09
 S C0CXR("NAME")="ALR2"
 S C0CXR("TYPE")="MU"
 S C0CXR("USE")="S"
 S C0CXR("EXECUTION")="R"
 S C0CXR("ACTIVITY")="IR"
 S C0CXR("SHORT DESCR")="X-ref for LOINC code related to test result."
 S C0CXR("DESCR",1)="This cross-reference is used to identify the LOINC codes"
 S C0CXR("DESCR",2)="that has been assigned to a lab result. Allows queries to"
 S C0CXR("DESCR",3)="retrieve the LOINC code associated with a specific test"
 S C0CXR("DESCR",4)="result."
 S C0CXR("SET")="S ^AUPNVLAB(""ALR2"",X(1),X(2),X(3),X(4),X(5),DA)="""""
 S C0CXR("KILL")="K ^AUPNVLAB(""ALR2"",X(1),X(2),X(3),X(4),X(5),DA)"
 S C0CXR("WHOLE KILL")="K ^AUPNVLAB(""ALR2"")"
 S C0CXR("VAL",1)=.02
 S C0CXR("VAL",1,"SUBSCRIPT")=1
 S C0CXR("VAL",1,"COLLATION")="F"
 S C0CXR("VAL",2)=1201
 S C0CXR("VAL",2,"SUBSCRIPT")=2
 S C0CXR("VAL",2,"COLLATION")="F"
 S C0CXR("VAL",3)=.06
 S C0CXR("VAL",3,"SUBSCRIPT")=3
 S C0CXR("VAL",3,"COLLATION")="F"
 S C0CXR("VAL",4)=.01
 S C0CXR("VAL",4,"SUBSCRIPT")=4
 S C0CXR("VAL",4,"COLLATION")="F"
 S C0CXR("VAL",5)=1113
 S C0CXR("VAL",5,"SUBSCRIPT")=5
 S C0CXR("VAL",5,"COLLATION")="F"
 D CREIXN^DDMOD(.C0CXR,C0CFLAG,.C0CRES,"C0COUT")
 ;
 Q
 ;
 ;
ALR3 ; Installation of ALR3 cross-reference
 ;
 N C0CFLAG,C0CXR,C0CRES,C0COUT
 ;
 S C0CFLAG=""
 ;
 S C0CXR("FILE")=9000010.09
 S C0CXR("NAME")="ALR3"
 S C0CXR("TYPE")="R"
 S C0CXR("USE")="S"
 S C0CXR("EXECUTION")="F"
 S C0CXR("ACTIVITY")="IR"
 S C0CXR("SHORT DESCR")="X-ref for LOINC code related to test result - any patient"
 S C0CXR("DESCR",1)="This cross-reference is used to identify the LOINC codes that has been assigned to a lab result. Allows queries"
 S C0CXR("DESCR",2)="to retrieve the LOINC code associated with a specific test result. It allows any patient"
 S C0CXR("DESCR",3)="lab results to be identified by LOINC"
 S C0CXR("VAL",1)=1113
 S C0CXR("VAL",1,"SUBSCRIPT")=1
 S C0CXR("VAL",1,"COLLATION")="F"
 ;
 D CREIXN^DDMOD(.C0CXR,C0CFLAG,.C0CRES,"C0COUT")
 ;
 Q
 ;
 ;
ALR4 ; Installation of ALR4 cross-reference
 ;
 N C0CFLAG,C0CXR,C0CRES,C0COUT
 ;
 S C0CFLAG=""
 ;
 S C0CXR("FILE")=9000010.09
 S C0CXR("NAME")="ALR4"
 S C0CXR("TYPE")="R"
 S C0CXR("USE")="S"
 S C0CXR("EXECUTION")="R"
 S C0CXR("ACTIVITY")="IR"
 S C0CXR("SHORT DESCR")="X-ref by patient and collection date/time"
 S C0CXR("DESCR",1)="This cross-reference is used to identify all lab results for a"
 S C0CXR("DESCR",2)="patient by collection date/time. This includes results that are only in"
 S C0CXR("DESCR",3)="this file and therefore do not have a corresponding entry in LAB DATA"
 S C0CXR("DESCR",4)="file (#63)."
 S C0CXR("VAL",1)=.02
 S C0CXR("VAL",1,"SUBSCRIPT")=1
 S C0CXR("VAL",1,"COLLATION")="F"
 S C0CXR("VAL",2)=1201
 S C0CXR("VAL",2,"SUBSCRIPT")=2
 S C0CXR("VAL",2,"COLLATION")="F"
 ;
 D CREIXN^DDMOD(.C0CXR,C0CFLAG,.C0CRES,"C0COUT")
 ;
 Q
 ;
 ;
ALR5 ; Installation of ALR5 cross-reference
 ;
 N C0CFLAG,C0CXR,C0CRES,C0COUT
 ;
 S C0CFLAG=""
 ;
 S C0CXR("FILE")=9000010.09
 S C0CXR("NAME")="ALR5"
 S C0CXR("TYPE")="R"
 S C0CXR("USE")="S"
 S C0CXR("EXECUTION")="R"
 S C0CXR("ACTIVITY")="IR"
 S C0CXR("SHORT DESCR")="X-ref by patient and results availble date/time"
 S C0CXR("DESCR",1)="This cross-reference is used to identify all lab results for a"
 S C0CXR("DESCR",2)="patient by results available date/time. This includes results that are only in"
 S C0CXR("DESCR",3)="this file and therefore do not have a corresponding entry in LAB DATA"
 S C0CXR("DESCR",4)="file (#63)."
 S C0CXR("VAL",1)=.02
 S C0CXR("VAL",1,"SUBSCRIPT")=1
 S C0CXR("VAL",1,"COLLATION")="F"
 S C0CXR("VAL",2)=1212
 S C0CXR("VAL",2,"SUBSCRIPT")=2
 S C0CXR("VAL",2,"COLLATION")="F"
 ;
 D CREIXN^DDMOD(.C0CXR,C0CFLAG,.C0CRES,"C0COUT")
 ;
 Q
 ;
 ;
REINDEX ; Set data into indexes for current entries.
 ;
 ;
 N C0CHLOG,DA,DIK,MSG
 ;
 S C0CHLOG("START")=$H
 S MSG="Starting indexing of ALR1, ALR2, ALR4, ALR5 indexes - "_$$HTE^XLFDT(C0CHLOG("START"),"1Z")
 D BMES(MSG),SENDXQA(MSG)
 ;
 S DIK="^AUPNVLAB("
 S DIK(1)=".02^ALR1^ALR2^ALR4^ALR5"
 D ENALL^DIK
 ;
 S C0CHLOG("END")=$H
 S MSG="Finished indexing of ALR1, ALR2, ALR4, ALR5 indexes - "_$$HTE^XLFDT(C0CHLOG("END"),"1Z")
 D BMES(MSG),SENDXQA(MSG)
 ;
 S MSG="Elapsed Time: "_$$HDIFF^XLFDT(C0CHLOG("END"),C0CHLOG("START"),3)
 D BMES(MSG)
 ;
 S C0CHLOG("START")=$H
 S MSG="Starting indexing of ALR3 index - "_$$HTE^XLFDT(C0CHLOG("START"),"1Z")
 D BMES(MSG),SENDXQA(MSG)
 ;
 K DA,DIK
 S DIK="^AUPNVLAB("
 S DIK(1)="1113^ALR3"
 D ENALL^DIK
 ;
 S C0CHLOG("END")=$H
 S MSG="Finished indexing of ALR3 index - "_$$HTE^XLFDT(C0CHLOG("END"),"1Z")
 D BMES(MSG),SENDXQA(MSG)
 ;
 S MSG="Elapsed Time: "_$$HDIFF^XLFDT(C0CHLOG("END"),C0CHLOG("START"),3)
 D BMES(MSG)
 ;
 Q
 ;
 ;
BMES(STR) ; Write BMES^XPDUTL statements
 ;
 D BMES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 ;
 Q
 ;
 ;
SENDXQA(MSG) ; Send alert for reindex status
 ;
 N XQA,XQAMSG
 ;
 S XQA(DUZ)=""
 S XQAMSG=MSG
 D SETUP^XQALERT
 ;
 Q
