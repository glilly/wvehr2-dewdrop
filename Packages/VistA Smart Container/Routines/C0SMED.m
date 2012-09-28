C0SMED    ; GPL - Smart Meds Processing ;2/22/12  17:05
        ;;1.0;VISTA SMART CONTAINER;;Sep 26, 2012;Build 2
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
        ;
MED(GRTN,C0SARY)        ; GRTN, passed by reference,
        ; is the return name of the graph created. "" if none
        ; C0SARY is passed in by reference and is the NHIN array of meds
        ;
        I $O(C0SARY("med",""))="" D  Q  ;
        . I $D(DEBUG) W !,"No Meds"
        S GRTN="" ; default to no meds
        N C0SGRF
        S C0SGRF="vistaSmart:"_ZPATID_"/"_ZTYP
        I $D(DEBUG) W !,"Processing ",C0SGRF
        D DELGRAPH^C0XF2N(C0SGRF) ; delete the old graph
        N MEDTRP ; MEDS TRIPLES
        D INITFARY^C0XF2N("C0XFARY") ; which triple store to use
        N FARY S FARY="C0XFARY"
        D USEFARY^C0XF2N(FARY)
        D VOCINIT^C0XUTIL
        ;
        N DUPCHK S DUPCHK="" ; check for no duplicates
        N ZI S ZI=""
        F  S ZI=$O(C0SARY("med",ZI)) Q:ZI=""  D  ;
        . N SDATE,SDTMP
        . I $G(C0SARY("med",ZI,"vaStatus@value"))="EXPIRED" D  Q  ;
        . . I $D(DEBUG) W !,"Expired Mediation, Skipping"
        . I $G(COSARY("med",ZI,"vaType@value"))="I" D  Q  ;
        . . I $D(DEBUG) W !,"Inpatient Med, skipping"
        . I $G(COSARY("med",ZI,"vaType@value"))="V" D  Q  ;
        . . I $D(DEBUG) W !,"IV Inpatient Med, skipping"
        . ;
        . S SDTMP=$G(C0SARY("med",ZI,"ordered@value"))
        . I SDTMP="" D  ;
        . . S SDTMP=$G(C0SARY("med",ZI,"start@value"))
        . S SDATE=$$FMTE^XLFDT(SDTMP,"7D") ; ordered date
        . S SDATE=$TR(SDATE,"/","-") ; change slashes to hyphens
        . I SDATE="" S SDATE="UNKNOWN"
        . N DNAME,VUID,DCODE,RXNORM,SIG
        . S DNAME=$G(C0SARY("med",ZI,"name@value"))
        . I DNAME="" D  ;
        . . S DNAME=$G(C0SARY("med",ZI,"products.product@name"))
        . S VUID=$G(C0SARY("med",ZI,"products.product.vaProduct@vuid"))
        . S DCODE=$G(C0SARY("med",ZI,"products.product.vaProduct@code"))
        . I DCODE="" S DCODE=$G(C0SARY("med",ZI,"id@value"))
        . S RXNORM=$$RXCUI(VUID) ; look up RxNorm code
        . I $P(RXNORM,"^",2)="RXNORM" D  ;
        . . S RXVER=$P(RXNORM,"^",3)
        . . S RXNORM=$P(RXNORM,"^",1)
        . E  D  Q  ; 
        . . I $D(DEBUG) W !,"NO RXNORM NUMBER AVAILABLE"
        . . I $D(DEBUG) W !,RXNORM
        . I DNAME="" D  Q  ;
        . . I $D(DEBUG) W !,"Error No Drug Name"
        . S MEDGRF=C0SGRF_"/"_DCODE_"-"_$G(SDTMP)
        . I +$D(DUPCHK(MEDGRF)) D  Q  ; NO DUPS ALLOWED
        . . I $D(DEBUG) W !,"Found Duplicate Medication ",MEDGRF
        . S DUPCHK(MEDGRF)=""
        . I $D(DEBUG) D  ;
        . . W !,"Processing Medication ",MEDGRF
        . . W !,DNAME
        . . W !,RXNORM
        . S SIG=$G(C0SARY("med",ZI,"sig"))
        . I SIG["|" D  ;
        . . N SIGTMP
        . . S SIGTMP=SIG
        . . S SIG=$P(SIGTMP,"|",2) ; remove the drug name from the sig 
        . . I DNAME["FREE TXT" D  ; eRx free text drug, get drug name from sig
        . . . S DNAME=$P(SIGTMP,"|",1) ; eRx Drug name is stored as the first piece of the sig 
        . K C0XFARY
        . D ADD^C0XF2N(C0SGRF,MEDGRF,"rdf:type","sp:Medication",FARY)
        . D ADD^C0XF2N(C0SGRF,MEDGRF,"sp:belongsTo",C0SGRF,FARY)
        . N DSUBJ S DSUBJ=$$ANONS^C0XF2N ; anonomous subject
        . D ADD^C0XF2N(C0SGRF,MEDGRF,"sp:drugName",DSUBJ,FARY)
        . I SIG'="" D ADD^C0XF2N(C0SGRF,MEDGRF,"sp:instructions",SIG,FARY)
        . N NQTY,NQTY2,NFREQ,NFREQ2
        . S NQTY=$$ANONS^C0XF2N ; anonomous subject
        . D ADD^C0XF2N(C0SGRF,MEDGRF,"sp:quantity",NQTY,FARY)
        . S NQTY2=$$ANONS^C0XF2N ; anonomous subject
        . D ADD^C0XF2N(C0SGRF,NQTY,"sp:ValueAndUnit",NQTY2,FARY)
        . N DOSE S DOSE=$G(C0SARY("med",ZI,"doses.dose@dose"))
        . I DOSE="" S DOSE="UNKNOWN"
        . N UNIT S UNIT=$G(C0SARY("med",ZI,"doses.dose@units"))
        . I UNIT="" S UNIT="UNKNOWN"
        . D ADD^C0XF2N(C0SGRF,NQTY2,"sp:value",DOSE,FARY)
        . D ADD^C0XF2N(C0SGRF,NQTY2,"sp:unit",UNIT,FARY)
        . S NFREQ=$$ANONS^C0XF2N ; anonomous subject
        . S NFREQ2=$$ANONS^C0XF2N ; anonomous subject
        . D ADD^C0XF2N(C0SGRF,MEDGRF,"sp:frequency",NFREQ,FARY)
        . D ADD^C0XF2N(C0SGRF,NFREQ,"sp:ValueAndUnit",NFREQ2,FARY)
        . N SCHED S SCHED=$G(C0SARY("med",ZI,"doses.dose@schedule"))
        . I SCHED="" S SCHED="UNKNOWN"
        . N SCHUNIT S SCHUNIT=$G(C0SARY("med",ZI,"doses.dose@route"))
        . I SCHUNIT="" S SCHUNIT="UNKNOWN"
        . D ADD^C0XF2N(C0SGRF,NFREQ2,"sp:value",SCHED,FARY)
        . D ADD^C0XF2N(C0SGRF,NFREQ2,"sp:unit",SCHUNIT,FARY)
        . D ADD^C0XF2N(C0SGRF,DSUBJ,"rdf:type","sp:CodedValue",FARY)
        . D ADD^C0XF2N(C0SGRF,DSUBJ,"sp:code","rxnorm:"_RXNORM,FARY)
        . D ADD^C0XF2N(C0SGRF,"rxnorm:"_RXNORM,"rdf:type","sp:Code",FARY)
        . D ADD^C0XF2N(C0SGRF,"rxnorm:"_RXNORM,"dcterms:title",DNAME,FARY)
        . D ADD^C0XF2N(C0SGRF,"rxnorm:"_RXNORM,"sp:system","rxnorm:",FARY)
        . D ADD^C0XF2N(C0SGRF,"rxnorm:"_RXNORM,"dcterms:identifier",RXNORM,FARY)
        . D ADD^C0XF2N(C0SGRF,DSUBJ,"dcterms:title",DNAME,FARY)
        . D ADD^C0XF2N(C0SGRF,MEDGRF,"sp:startDate",SDATE,FARY)
        . D ADD^C0XF2N(C0SGRF,"rxnorm:"_RXNORM,"rdf:type","http://smartplatforms.org/terms/codes/RxNorm_Semantic",FARY)
        . D BULKLOAD^C0XF2N(.C0XFDA)
        . K C0XFDA
        S GRTN=C0SGRF
        q
        ;
RXNFN() Q 1130590011.001 ; RxNorm Concepts file number
        ;
RXCUI(ZVUID)    ; EXTRINSIC WHICH RETURNS THE RXNORM CODE IF KNOWN OF 
        ; THE VUID - RETURNS CODE^SYSTEM^VERSION TO USE IN THE CCR
        N ZRSLT S ZRSLT=ZVUID_"^"_"VUID"_"^" ; DEFAULT
        I $G(ZVUID)="" Q ""
        I '$D(^C0P("RXN")) Q ZRSLT ; ERX NOT INSTALLED
        N C0PIEN ; S C0PIEN=$$FIND1^DIC($$RXNFN,"","QX",ZVUID,"VUID")
        S C0PIEN=$O(^C0P("RXN","VUID",ZVUID,"")) ;GPL FIX FOR MULTIPLES
        N ZRXN S ZRXN=$$GET1^DIQ($$RXNFN,C0PIEN,.01)
        S ZRXN=$$NISTMAP(ZRXN) ; CHANGE THE CODE IF NEEDED
        I ZRXN'="" S ZRSLT=ZRXN_"^RXNORM^08AB_081201F"
        Q ZRSLT
        ;
NISTMAP(ZRXN)   ; EXTRINSIC WHICH MAPS SOME RXNORM NUMBERS TO 
        ; CONFORM TO NIST REQUIREMENTS
        ;INPATIENT CERTIFICATION
        I ZRXN=309362 S ZRXN=213169
        I ZRXN=855318 S ZRXN=855320
        I ZRXN=197361 S ZRXN=212549
        ;OUTPATIENT CERTIFICATION
        I ZRXN=310534 S ZRXN=205875
        I ZRXN=617312 S ZRXN=617314
        I ZRXN=310429 S ZRXN=200801
        I ZRXN=628953 S ZRXN=628958
        I ZRXN=745679 S ZRXN=630208
        I ZRXN=311564 S ZRXN=979334
        I ZRXN=836343 S ZRXN=836370
        Q ZRXN
        ;
