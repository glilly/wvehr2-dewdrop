ORWGAPIX        ; SLC/STAFF - Graph External Calls ;11:11 AM  31 Jul 2010
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,260,243,NO HOME**;Dec 17, 1997;Build 13;WorldVistA 30-June-08
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
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
DATE(X) ; $$(date/time) -> date/time
        N Y D ^%DT
        Q Y
ENDIQ1(RESULTS,DIC,DR,DA,DIQ)   ; use file # for DIC
        N NUMDIC K RESULTS,^UTILITY("DIQ1",$J)
        Q:'$G(DIC)  Q:'$L(DR)  Q:'$G(DA)
        S NUMDIC=DIC
        D EN^DIQ1
        M RESULTS=^UTILITY("DIQ1",$J,NUMDIC,DA)
        K ^UTILITY("DIQ1",$J)
        Q
EXT(Y,FILE,FIELD)       ; $$(value,file,field) -> external value
        N C S C=$P($G(^DD(FILE,FIELD,0)),U,2) D Y^DIQ
        Q Y
EXTERNAL(FILE,FIELD,FLAG,VAL)   ; $$(file,field,flag,internal value) -> external value
        Q $$EXTERNAL^DILFD(FILE,FIELD,FLAG,VAL)
EXTNAME(IEN,FN) ; $$(ien,file#) -> external form of pointer
        N REF
        S REF=$G(^DIC(FN,0,"GL"))
        I $L(REF),+IEN Q $P($G(@(REF_IEN_",0)")),U)
        Q ""
FILENM(FILENUM) ; $$(file#) -> file name
        N DIC,DO,NAME K DIC,DO
        S FILENUM=$$GBLREF(+$G(FILENUM))
        I '$L($G(FILENUM)) Q ""
        S DIC=FILENUM
        D DO^DIC1
        S NAME=$P(DO,U)
        Q NAME
GETDATA(RESULTS,DIC,DR,DA,DIQ)  ; use file # for DIC
        N NUMDIC K RESULTS,^UTILITY("DIQ1",$J)
        Q:'$G(DIC)  Q:'$L(DR)  Q:'$G(DA)
        S NUMDIC=DIC
        D EN^DIQ1
        M RESULTS=^UTILITY("DIQ1",$J,NUMDIC,DA)
        K ^UTILITY("DIQ1",$J)
        Q
GBLREF(FILENUM) ; $$(file#) -> global reference
        I '$G(FILENUM) Q ""
        Q $$ROOT^DILFD(+FILENUM)
INDEX(DIK,DA)   ; index entry in file   -  from ORWGAPIP
        D IX1^DIK
        Q
XDEL(ENTITY,PARAM,NAME,ORERR)   ; from ORWGAPIP
        D DEL^XPAR(ENTITY,PARAM,NAME,.ORERR)
        Q
XEN(ENTITY,PARAM,NAME,ORVAL,ORERR)      ; from ORWGAPIP
        D EN^XPAR(ENTITY,PARAM,NAME,.ORVAL,.ORERR)
        Q
XENVAL(ORVALUES,PARAM)  ;
        D ENVAL^XPAR(.ORVALUES,PARAM)
        Q
XGET(ENTITY,PARAM,INST,FORMAT)  ; $$(...) -> parameter values
        Q $$GET^XPAR(ENTITY,PARAM,INST,FORMAT)
XGETLST(ORLIST,ENTITY,PARAM)    ; from ORWGAPIP
        D GETLST^XPAR(.ORLIST,ENTITY,PARAM)
        Q
XGETLST1(ORLIST,ENTITY,PARAM,FORMAT,ORERR)      ; from ORWGAPIP
        D GETLST^XPAR(.ORLIST,ENTITY,PARAM,FORMAT,.ORERR)
        Q
XGETWP(ORWP,ENTITY,PARAM,ALL)   ; from ORWGAPIP
        D GETWP^XPAR(.ORWP,ENTITY,PARAM,ALL)
        Q
        ; kernel functions
FMADD(X,D,H,M,S)        ;
        Q $$FMADD^XLFDT(X,$G(D),$G(H),$G(M),$G(S))
NOW()   ;
        Q $$NOW^XLFDT
LOW(X)  ;
        Q $$LOW^XLFSTR(X)
REPLACE(STRING,ORARRAY) ;
        Q $$REPLACE^XLFSTR(STRING,.ORARRAY)
TRIM(X,F,V)     ;
        Q $$TRIM^XLFSTR(X,$G(F,"LR"),$G(V," "))
UP(X)   ;
        Q $$UP^XLFSTR(X)
BMIITEMS(ITEMS,CNT,TMP) ; from ORWGAPIR
        N BMI,NUM,REPLACE K REPLACE
        S REPLACE("WEIGHT")="BODY MASS INDEX"
        S BMI=""
        S NUM=0
        I 'TMP D
        . F  S NUM=$O(ITEMS(NUM)) Q:NUM<1  D
        .. I $P(ITEMS(NUM),U,2)=8 S $P(BMI,U)=1
        .. I $P(ITEMS(NUM),U,2)=9 S $P(BMI,U,2)=ITEMS(NUM)
        I TMP D
        . F  S NUM=$O(^TMP(ITEMS,$J,NUM)) Q:NUM<1  D
        .. I $P(^TMP(ITEMS,$J,NUM),U,2)=8 S $P(BMI,U)=1
        .. I $P(^TMP(ITEMS,$J,NUM),U,2)=9 S $P(BMI,U,2)=^TMP(ITEMS,$J,NUM)
        I BMI,$L(BMI)>3 D
        . S CNT=CNT+1
        . S RESULT=$P(BMI,U,2,99)
        . S RESULT=$$REPLACE^ORWGAPIX(RESULT,.REPLACE)
        . S $P(RESULT,U,2)=99999
        . D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        Q
        ;
BMIDATA(DATA,ITEM,START,DFN,CNT,TMP)    ; from ORWGAPI4
        N DATE,DATE2,NODE,RESULT,VALUE,W K VALUE
        S DATE="",DATE2="",CNT=$G(CNT)
        F  S DATE=$O(^PXRMINDX(120.5,"PI",DFN,9,DATE)) Q:DATE=""  D
        . I DATE>START Q
        . S NODE=""
        . F  S NODE=$O(^PXRMINDX(120.5,"PI",DFN,9,DATE,NODE)) Q:NODE=""  D
        .. D VITAL^ORWGAPIA(.VALUE,NODE) S WT=$P($G(VALUE(7)),U) I 'WT Q
        .. S BMI=$$BMI(DFN,WT,DATE) I 'BMI Q
        .. S RESULT=120.5_U_ITEM_U_DATE_U_DATE2_U_BMI
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
BMI(DFN,WT,DATE)        ; $$(dfn,wt,date) -> bmi, else ""
        N HDATE,HT,NEXT,NODE,PREV
        I '$O(^PXRMINDX(120.5,"PI",DFN,8,0)) Q ""
        S NODE=$O(^PXRMINDX(120.5,"PI",DFN,8,DATE,""))
        I '$L(NODE) D
        . S NEXT=+$O(^PXRMINDX(120.5,"PI",DFN,8,DATE))
        . S PREV=+$O(^PXRMINDX(120.5,"PI",DFN,8,DATE),-1)
        . S NODE=$O(^PXRMINDX(120.5,"PI",DFN,8,$$CLOSEST(DATE,NEXT,PREV),""))
        I '$L(NODE) Q ""
        D VITAL^ORWGAPIA(.VALUE,NODE) S HT=$P($G(VALUE(7)),U) I 'HT Q ""
        Q $$CALCBMI(HT,WT)
        ;
CALCBMI(HT,WT)  ; $$(ht,wt) -> bmi  uses (inches,lbs)
        S WT=WT/2.2 ;+$$WEIGHT^XLFMSMT(WT,"LB","KG")
        S HT=HT*2.54/100 ;+$$LENGTH^XLFMSMT(HT,"IN","M")
        Q $J(WT/(HT*HT),0,2)
        ;
CLOSEST(DATE,NEXT,PREV) ;
        I $$FMDIFF^XLFDT(DATE,NEXT,2)>$$FMDIFF^XLFDT(DATE,PREV,2) Q PREV
        Q NEXT
        ;
BMILAST(DFN,ARRAY,CNT)  ;
        N BMI,DATE,NUM,WT
        S (DATE,NUM,WT)=0
        F  S NUM=$O(ARRAY(NUM)) Q:NUM<1  D  Q:WT
        . I $P(ARRAY(NUM),U,2)'="WT" Q
        . S WT=+$P(ARRAY(NUM),U,3)
        . S DATE=$P(ARRAY(NUM),U,4)
        I 'WT Q
        I 'DATE Q
        S BMI=$$BMI(DFN,WT,DATE)
        I 'BMI Q
        S CNT=CNT+1
        S ARRAY(CNT)="-1^BMI^"_BMI_U_DATE_U_BMI_"^^"
        Q
        ;
ZZ()    ; test use only - this code will be removed before v27 release
        ;Begin World VistA Change;NO HOME ;07/31/2010
        Q 1
        ;N X,ZIP,ZZ
        ;S ZZ=$C(36)_$C(90)_$C(72)
        ;S ZIP="S X="_ZZ X ZIP
        ;Q X
        ;End World VistA change
