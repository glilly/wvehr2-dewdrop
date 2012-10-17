ORAM3   ;POR/RSF - ANTICOAGULATION MANAGEMENT RPCS (4 of 4)  ;12/09/09  14:44
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**307**;Dec 17, 1997;Build 60
        ;;Per VHA Directive 2004-038, this routine should not be modified
        Q
        ;
PTADR(RESULT,ORAMDFN)   ;GET PT ADDRESS
        ;;CALLED BY ORAM3 ADDRESS
        N ORAMADD,ORAMADD2,ORAMADD3,ORAMCITY,ORAMCODE,ORAMST,ORAMZIP,ORAMBAD,ORAMT
        S ORAMT=.11,ORAMST="",ORAMBAD=0
        I '$G(ORAMDFN) S RESULT="NONE" Q
        I $$TMPCHK(ORAMDFN)=1 S ORAMT=.121
        S ORAMADD=$P($G(^DPT(ORAMDFN,ORAMT)),"^"),ORAMADD2=$P($G(^DPT(ORAMDFN,ORAMT)),"^",2),ORAMADD3=$P($G(^DPT(ORAMDFN,ORAMT)),"^",3)
        S ORAMCITY=$P($G(^DPT(ORAMDFN,ORAMT)),"^",4),ORAMCODE=$P($G(^DPT(ORAMDFN,ORAMT)),"^",5),ORAMZIP=$P($G(^DPT(ORAMDFN,ORAMT)),"^",6),ORAMBAD=$P($G(^DPT(ORAMDFN,.11)),"^",16)
        I ORAMCODE S ORAMST=$P($G(^DIC(5,$G(ORAMCODE),0)),"^",2)
        S:$G(ORAMBAD)="" ORAMBAD=0
        S RESULT=ORAMADD_"^"_ORAMADD2_"^"_ORAMADD3_"^"_ORAMCITY_"^"_ORAMST_"^"_ORAMZIP_"^"_$G(ORAMBAD)_"^"_$G(ORAMT)
        Q
        ;
PTFONE(RESULT,ORAMDFN)  ;GET PT PHONE NUMBERS
        ;;RPC=ORAM3 PHONE
        ;;RESULT=HOMEPHONE^WORKPHONE^CELLNUMBER^PAGER^EMAIL
        N ORAMF1,ORAMF2,ORAMFC,ORAMP,ORAMEM,ORAMT S ORAMT=0
        I '$G(ORAMDFN) S RESULT="NONE" Q
        I $$TMPCHK(ORAMDFN)=1 S ORAMT=1
        I ORAMT=0 D
        . S ORAMF1=$P($G(^DPT(ORAMDFN,.13)),"^"),ORAMF2=$P($G(^DPT(ORAMDFN,.13)),"^",2)
        . S ORAMFC=$P($G(^DPT(ORAMDFN,.13)),"^",4),ORAMP=$P($G(^DPT(ORAMDFN,.13)),"^",5),ORAMEM=$P($G(^DPT(ORAMDFN,.13)),"^",3)
        I ORAMT=1 D
        . S ORAMF1=$P($G(^DPT(ORAMDFN,.121)),"^",10),ORAMF2=$P($G(^DPT(ORAMDFN,.13)),"^",2)
        . S ORAMFC=$P($G(^DPT(ORAMDFN,.13)),"^",4),ORAMP=$P($G(^DPT(ORAMDFN,.13)),"^",5),ORAMEM=$P($G(^DPT(ORAMDFN,.13)),"^",3)
        S RESULT=$G(ORAMF1)_"^"_$G(ORAMF2)_"^"_$G(ORAMFC)_"^"_$G(ORAMP)_"^"_$G(ORAMEM)_"^"_$G(ORAMT)
        Q
        ;
TMPCHK(ORAMDFN) ;
        ;;
        N ORAMTMP S ORAMTMP=0
        I $D(^DPT(ORAMDFN,.121)),$P(^DPT(ORAMDFN,.121),"^",9)="Y" D
        . Q:$P(^DPT(ORAMDFN,.121),"^",7)>DT  ;START DATE
        . I $P(^DPT(ORAMDFN,.121),"^",8)'="" Q:DT>$P(^DPT(ORAMDFN,.121),"^",8)  ;END DATE
        . S ORAMTMP=1
        Q ORAMTMP
        ;RSF 10/08/08  CHANGE TO CODE DUE TO NEWLY DISCOVERED PROBLEM WITH 'COMPLICATIONS'
COMPENT(RESULT,ORAMDFN,ORAMDUZ,ORAMC,ORAMCT,ORAMD2)     ;
        ;RPC=ORAM3 COMPLICATION
        Q:'+$G(ORAMDFN)
        Q:'$G(ORAMDUZ)
        Q:'+$G(ORAMC)
        Q:$G(ORAMD2)=""
        N ORAMD3,ORAMX D DT^DILF(,ORAMD2,.ORAMX) S ORAMD3=ORAMX
        N ORAMNOW,ORAMDAY,X,% D NOW^%DTC S ORAMNOW=%,ORAMDAY=X
        N ORAMNX S ORAMNX=$O(^ORAM(103,ORAMDFN,3," "),-1)+1
        N ORAMC2,ORAMLLOC,ORAMPS,ORAMDD,ORAMTWD,ORAML,OERR
        I '$G(ORAMNX) S ORAMNX=1
        I ORAMNX>1 D
        . S ORAML=ORAMNX-1,ORAMLLOC=$P(^ORAM(103,ORAMDFN,3,ORAML,0),"^",4),ORAMPS=$P(^(0),"^",5),ORAMTWD=$P(^(0),"^",6),ORAMDD=$P(^(0),"^",7)
        I ORAMC>99 S ORAMC2=2  ;CLOT in the 100 range...I P1>100,P1#100>0 S P1=3 Q
        I ORAMC#10>0 S ORAMC2=1  ;MAJOR BLEED I P1>99 S P1=2 Q
        I ORAMC=10 S ORAMC2=3  ;MINOR BLEED
        N DA,IENS,ORAMRSF,ORAMF
        S IENS="+1,"_ORAMDFN_","
        S DA=ORAMNX,DA(1)=ORAMDFN
        S ORAMRSF(103.011,IENS,.01)=ORAMD3  ;COMPLICATION DATE
        S ORAMRSF(103.011,IENS,30)=ORAMLLOC  ;LAB DRAW LOC
        S ORAMRSF(103.011,IENS,40)=ORAMPS  ;PILL STRENGTH
        S ORAMRSF(103.011,IENS,50)=ORAMTWD  ;TOTAL WEEK DOSE
        S ORAMRSF(103.011,IENS,60)=ORAMDD  ;DAILY DOSING
        S ORAMRSF(103.011,IENS,80)=ORAMNOW
        S ORAMRSF(103.011,IENS,90)=ORAMDUZ  ;PROVIDER
        S ORAMRSF(103.011,IENS,104)=ORAMC2  ;COMPLICATION CODE
        K ORAMF
        S ORAMF(ORAMNX)=DA
        K OERR
        D UPDATE^DIE("","ORAMRSF","ORAMF","OERR")
        S ^ORAM(103,ORAMDFN,3,ORAMNX,2,1,0)=ORAMD2
        I $L(ORAMCT,"^")>0 N ORAMCC F ORAMCC=1:1:$L(ORAMCT,"^") D  S ^ORAM(103,ORAMDFN,3,ORAMNX,2,0)="^^"_ORAMCC_"^"_ORAMCC_"^"_ORAMDAY_"^"
        . S ^ORAM(103,ORAMDFN,3,ORAMNX,2,ORAMCC+1,0)=$P(ORAMCT,"^",ORAMCC)
        S RESULT=1
        Q
        ;
TLISTS  ; Erases and sets Team Lists for Anticoagulation Clinics
        ; Option: ORAM SET TEAMS
        N ORAMLIST  ;ARRAYS OF TEAMS
        D FTL(.ORAMLIST)
        I '$D(ORAMLIST) Q  ;No lists defined
        D ETEAM(.ORAMLIST)  ;ERASE ALL TEAM LISTS
        D MTEAM(.ORAMLIST)  ;FORM TODAY'S TEAM LISTS
        Q
        ;
FTL(ORAMLIST)   ;FIND TEAM LISTS  CALLED FROM TLISTS
        ;
        N ORAMI,ORAMCLST S ORAMI=0
        D GETCLINS^ORAMSET(.ORAMCLST)
        I +$G(ORAMCLST(0))'>0 Q  ;Site not SET UP
        ; Loop through Clinics, get team lists for each
        F  S ORAMI=$O(ORAMCLST(ORAMI)) Q:+ORAMI'>0  D
        . N ORAMCL,ORAMALL,ORAMCPLX
        . S ORAMCL=$P($G(ORAMCLST(ORAMI)),U,2) Q:+ORAMCL'>0
        . S ORAMALL=$$GET^XPAR(ORAMCL,"ORAM TEAM LIST (ALL)",1,"I")
        . S:ORAMALL]"" ORAMLIST(ORAMCL,"ALL")=ORAMALL
        . S ORAMCPLX=$$GET^XPAR(ORAMCL,"ORAM TEAM LIST (COMPLEX)",1,"I")
        . S:ORAMCPLX]"" ORAMLIST(ORAMCL,"COMPLEX")=ORAMCPLX
        Q
        ;
ETEAM(ORAMLIST) ; Remove all Anticoagulation Patients from their respective lists
        ; called from TLISTS
        N ORAMI S ORAMI=""
        F  S ORAMI=$O(ORAMLIST(ORAMI)) Q:ORAMI']""  D
        . N ORAML S ORAML=""
        . F  S ORAML=$O(ORAMLIST(ORAMI,ORAML)) Q:ORAML']""  D
        . . N DO,DA,DIK
        . . S DA(1)=ORAMLIST(ORAMI,ORAML),DIK="^OR(100.21"_","_DA(1)_",10,"
        . . S DA=0 F  S DA=$O(^OR(100.21,DA(1),10,DA)) Q:+DA'>0  D
        . . . D ^DIK
        Q
        ;
MTEAM(ORAMLIST) ; Build Today's Team Lists
        ; CALLED FROM TLISTS
        N ORAMCL S ORAMCL=""
        ; Loop through ORAMLIST by clinic location
        F  S ORAMCL=$O(ORAMLIST(ORAMCL)) Q:ORAMCL']""  D
        . N ORAMCN,ORAMCA,ORAMCC,ORAMDFN
        . S ORAMCN=+ORAMCL                        ; Pointer to file 44
        . S ORAMCA=$G(ORAMLIST(ORAMCL,"ALL"))     ; Pointer to "All" List
        . S ORAMCC=$G(ORAMLIST(ORAMCL,"COMPLEX")) ; Pointer to "Complex" List
        . ; Loop through Anticoagulation Patients by location
        . S ORAMDFN=0
        . F  S ORAMDFN=$O(^ORAM(103,"CL",ORAMCN,ORAMDFN)) Q:+ORAMDFN'>0  D
        . . N ORAMD0,ORAMRDT,ORAMCPLX,ORAMNDCB,ORAMAXDT
        . . S ORAMD0=$G(^ORAM(103,ORAMDFN,0))
        . . S ORAMRDT=$P(ORAMD0,U,4)   ; Pt's Return Date
        . . S ORAMAXDT=DT_".2359"      ; Upper bound for return date range
        . . S ORAMCPLX=$P(ORAMD0,U,10) ; Pt's Complexity
        . . S ORAMNDCB=$P(ORAMD0,U,20) ; Next Day Callback
        . . ; if next day callback, increment return date, disregard time
        . . I +ORAMNDCB S ORAMRDT=$$FMADD^XLFDT($P(ORAMRDT,"."),1)
        . . ; if future return date or pt inactive, quit to next pt
        . . I (ORAMRDT>ORAMAXDT)!(ORAMCPLX=2) Q
        . . ; otherwise, add pt to appropriate list(s) for location
        . . D ADDLIST(ORAMDFN,ORAMCA) ; All active pts on "ALL" List
        . . I ORAMCPLX=1 D ADDLIST(ORAMDFN,ORAMCC) ; Complex pts also on "COMPLEX" List
        Q
ADDLIST(ORAMDFN,ORAMLDA)        ; Add pt to Team List / Assure record is UNLOCKED
        N DIC,DA,DO,X,ORAMLR
        S X=ORAMDFN_";DPT("
        S DA(1)=ORAMLDA,DIC="^OR(100.21"_","_DA(1)_",10,",DIC(0)="L" D FILE^DICN
        D UNLOCK^ORAM1(.ORAMLR,ORAMDFN)
        Q
