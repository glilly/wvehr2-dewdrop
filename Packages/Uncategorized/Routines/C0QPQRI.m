C0QPQRI   ; GPL - GENERATES A PQRI XML FILE ;6/14/11  17:05
        ;;0.1;C0C;nopatch;noreleasedate;Build 12
        ;Copyright 2011 George Lilly.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        Q
        ;
C0QQFN()        Q 1130580001.101 ; FILE NUMBER FOR C0Q QUALITY MEASURE FILE
C0QMFN()        Q 1130580001.201 ; FILE NUMBER FOR C0Q MEASUREMENT FILE
C0QMMFN()       Q 1130580001.2011 ; FN FOR MEASURE SUBFILE
C0QMMNFN()      Q 1130580001.20111 ; FN FOR NUMERATOR SUBFILE
C0QMMDFN()      Q 1130580001.20112 ; FN FOR DENOMINATOR SUBFILE
RLSTFN()        Q 810.5 ; FN FOR REMINDER PATIENT LIST FILE
RLSTPFN()       Q 810.53 ; FN FOR REMINDER PATIENT LIST PATIENT SUBFILE
        ;
EN      ;
        ; lets try some hard coded values for now
        N C0QVAR
        ;
        ; first, the values that occur only once for the file
        ;
        S C0QVAR("create-by")="RegistryA"
        S C0QVAR("create-date")="12-10-2010"
        S C0QVAR("create-time")="14:27"
        S C0QVAR("file-number")=1
        S C0QVAR("number-of-files")=9
        S C0QVAR("version")="1.0"
        ;
        ; registry values
        ;
        S C0QVAR("registry-id")=125789123
        S C0QVAR("registry-name")="Model Registry"
        S C0QVAR("submission-method")="C"
        ;
        ; values for each provider
        ;
        S C0QVAR("npi")=12011989
        S C0QVAR("tin")=387682321
        S C0QVAR("waiver-signed")="Y"
        S C0QVAR("encounter-from-date")="06-13-2010"
        S C0QVAR("encounter-to-date")="12-10-2010"
        ;
        ; values for each measure group
        ;
        S C0QVAR("ffs-patient-count")=2
        S C0QVAR("group-eligible-instances")=30
        S C0QVAR("group-reporting-rate")=66.67
        S C0QVAR("group-reporting-rate-numerator")=20
        ;
        ; for each measure
        ;
        S C0QVAR("pqri-measure-number")=128
        S C0QVAR("eligible-instances")=100
        S C0QVAR("meets-performance-instances")=18
        S C0QVAR("performance-exclusion-instances")=0
        S C0QVAR("performance-not-met-instances")=10
        S C0QVAR("performance-rate")="90.00"
        S C0QVAR("reporting-rate")="28.00"
        ;
        ;
        N ZG,ZV
        D GETTEMP^C0CMXP("ZG","PQRIXML") ; GET THE TEMPLATE
        D BIND^C0CSOAP("ZV","C0QVAR","PQRIXML") ; GET BINDING VALUES
        D MAP^C0CXPATH("ZG","ZV","ZO") ; MAP THE XML
        D MEA("GG","GGG") ; GET THE MEASURES
        N GB ; BUILD LIST
        D QUEUE^C0CXPATH("GB","ZO",1,30) ; first part of pqri.xml
        D QUEUE^C0CXPATH("GB","GG",2,$O(GG(""),-1)-1) ; the measures
        D QUEUE^C0CXPATH("GB","ZO",$O(ZO(""),-1)-2,$O(ZO(""),-1)) ; LAST LINES
        D BUILD^C0CXPATH("GB","GZO") ; BUILD THE XML
        N ZI S ZI=0
        F  S ZI=$O(ZO(ZI)) Q:ZI=""  D  ; FOR EACH LINE OF XML
        . W !,GZO(ZI) ; WRITE OUT THE XML
        N GN,GN1,GD S GN=$NA(^TMP("C0QXML",$J))
        K @GN
        K ZO(0) ; GET RID OF LINE COUNT
        M @GN=GZO
        S GN1=$NA(@GN@(1))
        S GD=$G(^TMP("C0CCCR","ODIR")) ; CONVENIENT OUTPUT DIRECTORY
        W $$OUTPUT^C0CXPATH(GN1,"pqri.xml",GD)
        K @GN ; DONT NEED IT ANYMORE
        Q
        ;
INSERT(ZARY,ZONE)       ; INSERT ONE MEASURE INTO THE ARRAY
        ;
        ;N GGG
        S GGG="//submission/measure-group ID='C'/provider/pqri-measure" ;XPATH
        D INSINNER^COCXPATH(ZARY,GGG,ZONE) ; INSERT XML
        Q
        ;
PQRI(ZOUT,KEEP) ; RETURN THE NHIN ARRAY FOR THE PQRI XML TEMPLATE
        ;
        N ZG
        S ZG=$NA(^TMP("PQRIXML",$J))
        K @ZG
        D GETXML^C0CMXP(ZG,"PQRIXML") ; GET THE XML FROM C0C MISC XML
        N C0CDOCID
        S C0CDOCID=$$PARSE^C0CDOM(ZG,"PQRIXML") ; PARSE THE XML
        D DOMO^C0CDOM(C0CDOCID,"/","ZOUT","GIDX","GARY",,"//submission") ; BLD ARRAYS
        I '$G(KEEP) K GIDX,GARY ; GET RID OF THE ARRAYS UNLESS KEEP=1
        Q
        ;
PROCESS(ZRSLT,ZXML,ZREDUCE,KEEP)        ; PARSE AND RUN DOMO ON XML
        ; ZRTN IS PASSED BY REFERENCE
        ; ZXML IS PASSED BY NAME
        ; IF KEEP IS 1, GARY AND GIDX ARE NOT KILLED
        ;
        N ZG
        S ZG=$NA(^TMP("C0CXML",$J))
        K @ZG
        M @ZG=@ZXML
        S C0CDOCID=$$PARSE^C0CDOM(ZG,"NHINARRAY") ; PARSE WITH MXML
        D DOMO^C0CDOM(C0CDOCID,"/","ZRSLT","GIDX","GARY",,$G(ZREDUCE)) ; BLD ARRAYS
        I '$G(KEEP) K GIDX,GARY,@ZG ; GET RID OF THE ARRAYS UNLESS KEEP=1
        Q
        ;
GETFM(RTN,ZREC) ; GET THE QUALITY MEASURES ARRAY
        ;
        I '$D(ZREC) S ZREC=7 ; OUTPATIENT CERTIFICATION SET
        ;N GPL
        D LIST^DIC($$C0QMMFN(),","_ZREC_",",".01;1.1;2.1;3;",,,,,,,,"GPL")
        N ZI S ZI=""
        F  S ZI=$O(GPL("DILIST","ID",ZI)) Q:ZI=""  D  ;
        . S @RTN@(ZI,"measure")=GPL("DILIST","ID",ZI,.01)
        . N ZMIEN,ZMEAIEN,ZRNAME
        . S ZMIEN=GPL("DILIST",2,ZI) ; IEN OF MEASURE IN MEASURE FILE
        . ;S ZMEAIEN=$$GET1^DIQ($$C0QMMFN(),ZMIEN_","_ZREC_",",.01,"I") ; MEASURE
        . S ZRNAME=$$GET1^DIQ($$C0QMMFN(),ZMIEN_","_ZREC_",",".01:.8") ; MEASURE
        . ;S @RTN@(ZI,"reportingName")=$$GET1^DIQ($$C0QQFN(),ZMEAIEN_",",.8) ; RNAME
        . S @RTN@(ZI,"reportingName")=ZRNAME ; A SHORTCUT TO THE REPORTING NAME
        . S @RTN@(ZI,"reportingNumber")=$P(ZRNAME,"NQF",2) ; NQF0001 -> 0001
        . S @RTN@(ZI,"denominator")=+GPL("DILIST","ID",ZI,2.1)
        . S @RTN@(ZI,"numerator")=+GPL("DILIST","ID",ZI,1.1)
        . N ZNUM,ZDEM,ZPCT
        . S (ZNUM,ZDEM,ZPCT)=0
        . S ZDEM=+GPL("DILIST","ID",ZI,2.1)
        . S ZNUM=+GPL("DILIST","ID",ZI,1.1)
        . I ZDEM>0 S ZPCT=((ZNUM*100)/ZDEM)
        . S @RTN@(ZI,"percent")=$P(ZPCT,".",1)
        . S @RTN@(ZI,"ien")=ZI
        ;ZWR GPL
        Q
        ;
MEA(ZOUT,ZIN)   ; CREATE XML FROM THE MEASURES ARRAY
        ;
        D GETFM(ZIN) ;  GET THE MEASURES
        ;N G
        ;N ZI,ZJ
        S ZI=""
        F  S ZI=$O(@ZIN@(ZI)) Q:ZI=""  D  ;
        . N ZDEN,ZNUM,ZPCT
        . S ZDEN=$G(@ZIN@(ZI,"denominator"))
        . S ZNUM=$G(@ZIN@(ZI,"numerator"))
        . S ZPCT=$G(@ZIN@(ZI,"percent"))
        . S G("pqri-measure",ZI,"eligible-instances")=ZDEN
        . S G("pqri-measure",ZI,"meets-performance-instances")=ZNUM
        . S G("pqri-measure",ZI,"performance-exclusion-instances")=0
        . S G("pqri-measure",ZI,"performance-not-met-instances")=ZDEN-ZNUM
        . S G("pqri-measure",ZI,"performance-rate")=ZPCT
        . S G("pqri-measure",ZI,"pqri-measure-number")="NQF "_@ZIN@(ZI,"reportingNumber")
        . S G("pqri-measure",ZI,"reporting-rate")=ZPCT
        K ^TMP("MXMLDOM",$J)
        S C0CDOCID=$$DOMI^C0CDOM("G",1,"root")
        D OUTXML^C0CDOM(ZOUT,C0CDOCID,1)
        Q
        ;
