C0STBL    ; GPL - Smart Container CREATE A TABLE OF NHINV VALUES;2/22/12  17:05
        ;;1.0;VISTA SMART CONTAINER;;Sep 26, 2012;Build 5
        ;Copyright 2012 George Lilly.  Licensed under the terms of the GNU
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
EN(BEGDFN,DFNCNT,ZPART) ; START IS A DFN
        I '$D(BEGDFN) S BDGDFN=""
        I '$D(DFNCNT) S DFNCNT=150
        I '$D(ZPART) S ZPART=""
        N ZTBL S ZTBL=$NA(^TMP("C0STBL"))
        N ZI,ZCNT,ZG
        S ZI=$O(^DPT(BEGDFN),-1)
        S ZCNT=1
        F  S ZI=$O(^DPT(ZI)) Q:((+ZI=0)!(ZCNT>DFNCNT))  D  ;
        . S ZCNT=ZCNT+1
        . W ZI," "
        . K ZG
        . D EN^C0SNHIN(.ZG,ZI,ZPART)
        . M @ZTBL@(ZI)=ZG
        . K G
        . N GDIR S GDIR="/home/vista/p/"
        . D EN^C0SMART(.G,ZI,"med")
        . I $D(G) W !,$$output^C0XGET1("G",ZI_"-med.rdf",GDIR)
        . k G
        . D EN^C0SMART(.G,ZI,"patient")
        . I $D(G) W !,$$output^C0XGET1("G",ZI_"-patient.rdf",GDIR)
        . K G
        . D EN^C0SMART(.G,ZI,"lab")
        . I $D(G) W !,$$output^C0XGET1("G",ZI_"-lab.rdf",GDIR)
        . K G
        . D EN^C0SMART(.G,ZI,"problem")
        . I $D(G) W !,$$output^C0XGET1("G",ZI_"-problem.rdf",GDIR)
        Q
        ;
LOADHACK        ;
        N ZI
        F ZI=2:1:374 D  ;
        . D IMPORT^C0XF2N("hack"_ZI_".xml","/home/vista/hack/")
        Q
        ;
LABCNT  ; COUNT LAB TESTS AND LOINC CODES
        K LABCNT,GLOINC,PATCNT
        S (LABCNT,GLOINC,PATCNT)=0
        N ZI S ZI=""
        N GN S GN=$NA(^TMP("C0STBL"))
        F  S ZI=$O(@GN@(ZI)) Q:ZI=""  D  ;
        . S PATCNT=PATCNT+1
        . I '$D(@GN@(ZI,"lab")) Q  ;
        . N ZJ S ZJ=""
        . F  S ZJ=$O(@GN@(ZI,"lab",ZJ)) Q:ZJ=""  D  ;
        . . S LABCNT=LABCNT+1
        . . S X=$G(@GN@(ZI,"lab",ZJ,"loinc@value"))
        . . I X'="" S GLOINC=GLOINC+1
        W !,"Total number of patients: ",PATCNT
        W !,"Total number of lab results: ",LABCNT
        W !,"Total number of lab results with loinc codes: ",GLOINC
        W !,"Percentage of lab tests with loinc codes: ",$P((GLOINC/LABCNT)*100,".")_"%"
        Q
        ;
PROBCNT ; COUNT PROBLEMS AND SNOMED CODES
        K PROBCNT,GSNO,PATCNT
        S (PROBCNT,GSNO,PATCNT)=0
        N ZI S ZI=""
        N GN S GN=$NA(^TMP("C0STBL"))
        F  S ZI=$O(@GN@(ZI)) Q:ZI=""  D  ;
        . S PATCNT=PATCNT+1
        . I '$D(@GN@(ZI,"problem")) Q  ;
        . N ZJ S ZJ=""
        . F  S ZJ=$O(@GN@(ZI,"problem",ZJ)) Q:ZJ=""  D  ;
        . . S PROBCNT=PROBCNT+1
        . . S X=$G(@GN@(ZI,"problem",ZJ,"icd@value"))
        . . S Y=$$SNOMED^C0SPROB2(X)
        . . I Y'="" S GSNO=GSNO+1
        W !,"Total number of patients: ",PATCNT
        W !,"Total number of problems: ",PROBCNT
        W !,"Total number of problems with snomed codes: ",GSNO
        W !,"Percentage of problems with SNOMED codes: ",$P((GSNO/PROBCNT)*100,".")_"%"
        Q
        ;
MEDCNT  ; COUNT INPATIENT VS OUTPATIENT MEDICATIONS
        K MEDCNT,OMED,PATCNT,DOSE,UNITS,FORM,SCHED,ROUTE
        S (MEDCNT,OMED,GSNO,PATCNT)=0
        N ZI S ZI=""
        N GN S GN=$NA(^TMP("C0STBL"))
        F  S ZI=$O(@GN@(ZI)) Q:ZI=""  D  ;
        . S PATCNT=PATCNT+1
        . I '$D(@GN@(ZI,"med")) Q  ;
        . N ZJ S ZJ=""
        . F  S ZJ=$O(@GN@(ZI,"med",ZJ)) Q:ZJ=""  D  ;
        . . S MEDCNT=MEDCNT+1
        . . I $G(@GN@(ZI,"med",ZJ,"vaStatus@value"))="EXPIRED" D  Q  ;
        . . . I $D(DEBUG) W !,"Expired Mediation, Skipping"
        . . I $G(@GN@(ZI,"med",ZJ,"vaType@value"))="I" D  Q  ;
        . . . I $D(DEBUG) W !,"Inpatient Med, skipping"
        . . I $G(@GN@(ZI,"med",ZI,"vaType@value"))="V" D  Q  ;
        . . . I $D(DEBUG) W !,"IV Inpatient Med, skipping"
        . . S OMED=OMED+1
        . . S X=$G(@GN@(ZI,"med",ZJ,"form@value"))
        . . S FORM(X)=$G(FORM(X))+1
        . . S X=$G(@GN@(ZI,"med",ZJ,"doses.dose@dose"))
        . . I X="" S X="UNKNOWN"
        . . S DOSE(X)=$G(DOSE(X))+1
        . . S X=$G(@GN@(ZI,"med",ZJ,"doses.dose@units"))
        . . I X="" S X="UNKNOWN"
        . . S UNITS(X)=$G(UNITS(X))+1
        . . S X=$G(@GN@(ZI,"med",ZJ,"doses.dose@schedule"))
        . . I X="" S X="UNKNOWN"
        . . S SCHED(X)=$G(SCHED(X))+1
        . . S X=$G(@GN@(ZI,"med",ZJ,"doses.dosc@route"))
        . . I X="" S X="UNKNOWN"
        . . S ROUTE(X)=$G(ROUTE(X))+1
        W !,"Total number of patients: ",PATCNT
        W !,"Total number of medications: ",MEDCNT
        W !,"Total number of outpatient medications: ",OMED
        W !,"Percentage of outpatient medications: ",$P((OMED/MEDCNT)*100,".")_"%",!
        ZWR FORM
        ZWR DOSE
        ZWR UNITS
        ZWR SCHED
        ZWR ROUTE
        Q
        ;
