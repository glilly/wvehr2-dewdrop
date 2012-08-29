ZVEMSGU ;DJB,VSHL**VShell Global - System QWIKs cont.. ; 9/6/02 8:58am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SYSTEM ;Load the System QWIKs
 NEW I,QWIK,TYPE,TXT,VEN
 F I=1:1 S TXT=$T(QWIK+I) Q:$P(TXT,";",3)="***"  S QWIK=$P(TXT,";",3),TYPE=$P(TXT,";",4) D
 . I TYPE="D" S ^%ZVEMS("QS",QWIK,"DSC")=$P(TXT,";",5,999)
 . I TYPE="C" S ^%ZVEMS("QS",QWIK)=$P(TXT,";",5,999) ;Code
 . I TYPE?1.N S ^%ZVEMS("QS",QWIK,TYPE)=$P(TXT,";",5,999) ;Vendor specific code
 Q
QWIK ;System QWIK Commands
 ;;LOCKTAB;D;Lock Table^^5
 ;;LOCKTAB;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;LOCKTAB;2;D ^LOCKTAB
 ;;LOCKTAB;8;D ^LOCKTAB
 ;;LOCKTAB;9;d ^%lockexam
 ;;LOCKTAB;16;D ^LOCKTAB
 ;;RCHANGE;D;Routine Change^^5
 ;;RCHANGE;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RCHANGE;2;D ^%RCE
 ;;RCHANGE;8;D ^%RCHANGE
 ;;RCHANGE;9;d ^%rchange
 ;;RCHANGE;16;D ^%RCE
 ;;RCHANGE;17;D ^%RCE
 ;;RCHANGE;18;D ^%RCHANGE
 ;;RCHANGE;19;D ^%RCE
 ;;RCMP;D;Routine Compare^^5
 ;;RCMP;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RCMP;2;D ^%RCMP
 ;;RCMP;8;D ^%RCMP
 ;;RCMP;9;d ^%rcompare
 ;;RCMP;16;D ^%RCMP
 ;;RCMP;18;D ^%RCMP
 ;;RCOPY;D;Routine Copy to Another UCI^^5
 ;;RCOPY;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RCOPY;8;D ^%RCOPY
 ;;RCOPY;9;D ^%rcopy
 ;;RCOPY;16;D ^%RCOPY
 ;;RCOPY;18;D ^%RCOPY
 ;;RD;D;Routine Directory^^5
 ;;RD;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RD;2;D ^%RD
 ;;RD;8;D ^%RD
 ;;RD;9;d ^%rd
 ;;RD;16;D ^%RD
 ;;RD;17;D ^%RD
 ;;RD;18;D ^%RD
 ;;RD;19;D ^%RD
 ;;RDEL;D;Routine Delete^^5
 ;;RDEL;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RDEL;2;D ^%ZRDELET
 ;;RDEL;8;D ^%RDEL
 ;;RDEL;9;d ^%rdelete
 ;;RDEL;16;D ^%RPURGE
 ;;RDEL;17;D ^%ZTRDEL
 ;;RDEL;18;D ^%RDELETE
 ;;RDEL;19;D ^%ZTRDEL
 ;;RL;D;Routine Lister^^5
 ;;RL;C;D ^%ZVEMSRL
 ;;RR;D;Routine Restore^^5
 ;;RR;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RR;2;D ^%RR
 ;;RR;8;D ^%RR
 ;;RR;9;d ^%rload
 ;;RR;16;D ^%RR
 ;;RR;17;D ^%RI
 ;;RR;18;D ^%RI
 ;;RR;19;D ^%RI
 ;;RS;D;Routine Save^^5
 ;;RS;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RS;2;D ^%RS
 ;;RS;8;D ^%RS
 ;;RS;9;d ^%rsave
 ;;RS;16;D ^%RS
 ;;RS;17;D ^%RO
 ;;RS;18;D ^%RO
 ;;RS;19;D ^%RO
 ;;RSEARCH;D;Routine Search^^5
 ;;RSEARCH;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RSEARCH;8;D ^%RSE
 ;;RSEARCH;9;d ^%rsearch
 ;;RSEARCH;16;D ^%RSE
 ;;RSEARCH;17;D ^%RSE
 ;;RSEARCH;18;D ^%RFIND
 ;;RSEARCH;19;D ^%RSE
 ;;RSEL;D;Routine Select^^5
 ;;RSEL;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RSEL;2;D ^%RSEL
 ;;RSEL;8;D ^%RSEL
 ;;RSEL;9;w $$^%rselect," routines selected"
 ;;RSEL;16;D ^%RSEL
 ;;RSEL;17;D ^%RSEL
 ;;RSEL;18;D ^%RSET
 ;;RSEL;19;D ^%RSEL
 ;;RSIZE;D;Routine Size^^5
 ;;RSIZE;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;RSIZE;2;D ^%RSIZE
 ;;RSIZE;8;D ^%RSIZE
 ;;RSIZE;16;D ^%RSIZE
 ;;RTN;D;Make NEW Routine^^5
 ;;RTN;C;D ^%ZVEMSNR
 ;;UCI;D;Switch UCI^^5
 ;;UCI;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;UCI;2;D ^%ZUCI
 ;;UCI;8;D ^%LOGON
 ;;UCI;9;d ^%nspace
 ;;UCI;16;D ^%ZUCI
 ;;UTIL;D;Utilities Menu^^5
 ;;UTIL;C;W $C(7),!?2,"Not available for this M Vendor.",!
 ;;UTIL;2;D ^%LIB
 ;;UTIL;8;D ^%UTL
 ;;UTIL;9;ZZUTIL
 ;;UTIL;16;D ^%LIB
 ;;***
