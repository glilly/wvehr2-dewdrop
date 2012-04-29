ORWGAPIT        ; SLC/STAFF - Graph Item Types ;11/20/06  08:58
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,260,243**;Dec 17, 1997;Build 242
        ;
COMPTYPE(FILE)  ; $$(file) -> hs component abbrv   - from ORWGAPID
        N COMP,COMPNAME,COMPS,NUM,OK K COMPS
        S COMPNAME=$$COMPNAME(FILE)_"]"
        D COMP^ORWRP2(.COMPS)
        S COMP=""
        S OK=0
        S NUM=0
        D
        . F  S NUM=$O(COMPS(NUM)) Q:NUM<1  D  I OK Q
        .. S COMP=COMPS(NUM)
        .. I COMP[COMPNAME,COMPNAME=$P($P(COMP,U,2),"[",2) S OK=1
        Q COMP
        ;
COMPNAME(FILE)  ; $$(file) -> hs component abbrv
        I FILE=63 Q "CH"
        I FILE=120.5 Q "VSD"
        I FILE=120.8 Q "ADR"
        I FILE=52 Q "RXOP"
        I FILE=55 Q "RXUD"
        I FILE=70 Q "II"
        I FILE=9000010.11 Q "IM"
        I FILE=9000010.12 Q "ST"
        I FILE=9000010.13 Q "EXAM"
        I FILE=9000010.18 Q "CPT"
        I FILE=9000011 Q "PLL"
        I FILE=9999911 Q "PLL"
        I FILE=9000010.23 Q "HF"
        I FILE=9000010.07 Q "OD"
        I FILE=9000010.16 Q "ED"
        I FILE=601.2 Q "MHPE"
        I FILE=100 Q "ORC"
        I FILE="45OP" Q "PRC"
        I FILE="45DX" Q "DD"
        I FILE="63AP" Q "SP"
        I FILE="63BB" Q "BT"
        I FILE="63MI" Q "MIC"
        I FILE=9000010 Q "CVP"
        I FILE=405 Q "ADC"
        I FILE="55NVA" Q "RXNV"
        I FILE=53.79 Q "BCMA"
        I FILE=130 Q "SR"
        I FILE=8925 Q "CNB"
        I FILE=690 Q "MEDF"
        Q ""
        ;
FILENAME(FILE)  ; $$(file) -> filename   - from ORWGAPIP
        I FILE=63 Q "LAB TESTS"
        I FILE=120.5 Q "VITALS"
        I FILE=120.8 Q "ALLERGIES"
        I FILE=52 Q "MEDICATION,OUTPATIENT"
        I FILE=55 Q "MEDICATION,INPATIENT"
        I FILE=70 Q "RADIOLOGY EXAMS"
        I FILE=9000010.11 Q "IMMUNIZATIONS"
        I FILE=9000010.12 Q "SKIN TESTS"
        I FILE=9000010.13 Q "EXAMS"
        I FILE=9000010.18 Q "PROCEDURES"
        I FILE=9000011 Q "PROBLEMS"
        I FILE=9999911 Q "PROBLEMS-DURATION" ;**************
        I FILE=9000010.23 Q "HEALTH FACTORS"
        I FILE=9000010.07 Q "PURPOSE OF VISIT"
        I FILE=9000010.16 Q "PATIENT EDUCATION"
        I FILE=601.2 Q "MENTAL HEALTH"
        I FILE=100 Q "ORDERS"
        I FILE="45OP" Q "REGISTRATION OP/PROC"
        I FILE="45DX" Q "REGISTRATION DX"
        I FILE="63AP" Q "ANATOMIC PATHOLOGY"
        I FILE="63BB" Q "BLOOD PRODUCTS"
        I FILE="63MI" Q "MICROBIOLOGY"
        I FILE=9000010 Q "VISITS"
        I FILE=405 Q "ADMISSIONS"
        I FILE="55NVA" Q "MEDICATION,NON-VA"
        I FILE=53.79 Q "MEDICATION,BCMA"
        I FILE=50.605 Q "DRUG CLASS"
        I FILE=68 Q "LAB ACC AREA"
        I FILE=8925.1 Q "NOTE TITLE"
        I FILE=100.98 Q "ORDER DISPLAY GROUP"
        I FILE=811.2 Q "REMINDER TAXONOMY"
        I FILE=130 Q "SURGERY"
        I FILE=8925 Q "NOTES"
        I FILE=690 Q "MEDICINE"
        Q ""
        ;
FILECHK(FILES)  ;
        ; get parameter string of excluded files
        N CHECK,NUM,ORSRV,VAL
        S ORSRV=$$GET1^DIQ(200,DUZ,29,"I")
        S CHECK=$$XGET^ORWGAPIX("USR^SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORWG GRAPH EXCLUDE DATA TYPE",1,"I")
        S CHECK=CHECK_";"
        S NUM=0
        F  S NUM=$O(FILES(NUM)) Q:NUM<1  D
        . S VAL=FILES(NUM)
        . S VAL=$P(VAL,U)_";"
        . I CHECK[VAL K FILES(NUM)
        Q
        ;
GETFILES(FILES) ;
        ; file #^file name^graph type^lookup file^lookup global^lookup index^prefix^abbrev^hint format
        ; commenting out a line setting FILES will inactivate that type
        S FILES(1)="63^LAB TESTS^1^60^LAB(60,^B^^CH^~  ~units~flag~|"
        S FILES(2)="120.5^VITALS^1^120.51^GMRD(120.51,^B^^VSD^~  ~"
        S FILES(3)="52^MEDICATION,OUTPATIENT^3^50^PSDRUG(^B^^RXOP^~  ~"
        S FILES(4)="55^MEDICATION,INPATIENT^3^50^PSDRUG(^B^^RXUD^~  ~"
        S FILES(5)="70^RADIOLOGY EXAMS^2^71^RAMIS(71,^B^rad^II^~  ~"
        S FILES(6)="9000010.11^IMMUNIZATIONS^2^9999999.14^AUTTIMM(^B^imm^IM^~  ~"
        S FILES(7)="9000010.12^SKIN TESTS^2^9999999.28^AUTTSK(^B^skin^ST^~  ~"
        S FILES(8)="9000010.13^EXAMS^2^9999999.15,^AUTTEXAM(^B^exam^EXAM^~  ~"
        S FILES(9)="9000010.18^PROCEDURES^2^81^ICPT(^C^proc^CPT^~  ~"
        S FILES(10)="9000011^PROBLEMS^2^80^ICD9(^B^prob^PLL^~  ~" ;***
        S FILES(11)="9000010.23^HEALTH FACTORS^2^9999999.64^AUTTHF(,^B^hf^HF^~  ~"
        S FILES(12)="9000010.07^PURPOSE OF VISIT^2^80^ICD9(^B^pov^OD^"
        S FILES(13)="9000010.16^PATIENT EDUCATION^2^9999999.09^AUTTEDT(^B^edu^ED^~  ~"
        S FILES(14)="601.2^MENTAL HEALTH^2^601^YTT(601,^B^mh^MHPE^~  ~"
        S FILES(15)="100^ORDERS^2^101.43^ORD(101.43,^B^order^ORC^~  ~"
        S FILES(16)="45OP^REGISTRATION OP/PROC^2^*^^^op^PRC^~  ~"
        S FILES(17)="45DX^REGISTRATION DX^2^*^^^dx^DD^~  ~"
        S FILES(18)="63AP^ANATOMIC PATHOLOGY^2^*^^^ap^SP^~  ~"
        S FILES(19)="63MI^MICROBIOLOGY^2^*^^^micro^MIC^~  ~"
        S FILES(20)="9000010^VISITS^3^44^SC(^B^^CVP^~  ~"
        S FILES(21)="405^ADMISSIONS^3^*^^^^ADC^~  ~"
        S FILES(23)="53.79^MEDICATION,BCMA^2^50.7^PS(50.7,^B^^BCMA^~  ~"
        S FILES(24)="130^SURGERY^2^81^ICPT(^C^surg^SR^~  ~"
        S FILES(25)="8925^NOTES^2^*^^^note^CNB^~  ~"
        S FILES(27)="120.8^ALLERGIES^2^*^^^allg^ADR^~  ~"
        S FILES(28)="63BB^BLOOD BANK^2^66^LAB(66,^B^bb^BT^~  ~"
        ;S FILES(29)="9999911^PROBLEMS-DURATION^3^80^ICD9(^B^prob^PLL^~  ~" ;***
        S FILES(30)="55NVA^MEDICATION,NON-VA^3^50.7^PS(50.7,^B^^RXNV^~  ~"
        S FILES(31)="690^MEDICINE^2^*^^^med^MEDF^~  ~"
        S FILES(2000)="811.2^Reminder Taxonomy"
        S FILES(3000)="50.605^Drug Class"
        Q
        ;
TYPES(TYPES,DFN,SUB,TMP)        ; from ORWGAPI
        N CNT,FILES,ITEM,MEDARRAY,NUM,OK,SEQ K FILES,MEDARRAY
        S TMP=$G(TMP)
        D GETFILES(.FILES)
        D FILECHK(.FILES)
        I SUB D
        . I $D(FILES(18)) D
        .. S FILES(1801)="63AP;O^AP: Organ"
        .. S FILES(1802)="63AP;T^AP: Test"
        .. S FILES(1803)="63AP;D^AP: Disease"
        .. S FILES(1804)="63AP;I^AP: ICD9"
        .. S FILES(1805)="63AP;E^AP: Etiology"
        .. S FILES(1806)="63AP;F^AP: Function"
        .. S FILES(1807)="63AP;P^AP: Procedure"
        .. S FILES(1808)="63AP;M^AP: Morphology"
        .. S FILES(1809)="63AP;S^AP: Specimen"
        . I $D(FILES(19)) D
        .. S FILES(1901)="63MI;A^Microbiology: Antibiotic"
        .. S FILES(1902)="63MI;T^Microbiology: Test"
        .. S FILES(1903)="63MI;S^Microbiology: Specimen"
        .. S FILES(1904)="63MI;O^Microbiology: Organism"
        .. ;S FILES(1905)="63MI;M^Microbiology: TB Drug"
        I 'SUB D
        . K FILES(2000)
        . K FILES(3000)
        I DFN D
        . I '$L($O(^PXRMINDX(63,"PI",DFN,""))) K FILES(1)
        . I '$L($O(^PXRMINDX(120.5,"PI",DFN,""))) K FILES(2)
        . I '$L($O(^PXRMINDX(52,"PI",DFN,""))) K FILES(3)
        . I '$L($O(^PXRMINDX(55,"PI",DFN,""))) K FILES(4)
        . I '$L($O(^PXRMINDX(70,"PI",DFN,""))) K FILES(5)
        . I '$L($O(^PXRMINDX(9000010.11,"PI",DFN,""))) K FILES(6)
        . I '$L($O(^PXRMINDX(9000010.12,"PI",DFN,""))) K FILES(7)
        . I '$L($O(^PXRMINDX(9000010.13,"PI",DFN,""))) K FILES(8)
        . I '$L($O(^PXRMINDX(9000010.18,"PPI",DFN,""))) K FILES(9)
        . I '$L($O(^PXRMINDX(9000011,"PSPI",DFN,""))) K FILES(10),FILES(29)
        . I '$L($O(^PXRMINDX(9000010.23,"PI",DFN,""))) K FILES(11)
        . I '$L($O(^PXRMINDX(9000010.07,"PPI",DFN,""))) K FILES(12)
        . I '$L($O(^PXRMINDX(9000010.16,"PI",DFN,""))) K FILES(13)
        . I '$L($O(^PXRMINDX(601.2,"PI",DFN,""))) K FILES(14)
        . I '$L($O(^PXRMINDX(100,"PI",DFN,""))) K FILES(15)
        . I '$L($O(^PXRMINDX(45,"ICD0","PNI",DFN,0))) K FILES(16)
        . I '$L($O(^PXRMINDX(45,"ICD9","PNI",DFN,0))) K FILES(17)
        . I $E($O(^PXRMINDX(63,"PI",DFN,"A")))'="A" K FILES(18) D
        .. F NUM=1:1:9 K FILES(180+NUM)
        . I $E($O(^PXRMINDX(63,"PI",DFN,"M")))'="M" K FILES(19) D
        .. F NUM=1:1:5 K FILES(190+NUM)
        . I '$$VISITX^ORWGAPIA(DFN) K FILES(20)
        . I '$$ADMITX^ORWGAPIA(DFN) K FILES(21)
        . I '$$NVAX^ORWGAPIC(DFN) K FILES(22),FILES(30)
        . I '$$BCMAX^ORWGAPIC(DFN) K FILES(23)
        . I '$$SURGX^ORWGAPIA(DFN) K FILES(24)
        . I '$$NOTEX^ORWGAPIA(DFN) K FILES(25)
        . I '$$ALLERGYX^ORWGAPIA(DFN) K FILES(27)
        . I '$$BBX^ORWGAPIB(DFN) K FILES(28)
        . S OK=0
        . D MEDICINE^ORWGAPIA(.MEDARRAY,DFN)
        . I $O(MEDARRAY(0)) S OK=1
        . I 'OK K FILES(31)
        S CNT=0,SEQ=0
        F  S SEQ=$O(FILES(SEQ)) Q:SEQ<1  D
        . S CNT=CNT+1
        . I TMP S ^TMP(TYPES,$J,CNT)=FILES(SEQ)
        . I 'TMP S TYPES(CNT)=FILES(SEQ)
        Q
        ;
