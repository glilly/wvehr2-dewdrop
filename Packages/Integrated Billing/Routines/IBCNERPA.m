IBCNERPA ;DAOU/BHS - IBCNE IIV RESPONSE REPORT (cont'd) ;03-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184,271,345**;21-MAR-94;Build 28
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ; IIV - Insurance Identification and Verification Interface
 ;
 ; Input from IBCNERP1/2:
 ;  IBCNERTN="IBCNERP1" - Driver rtn
 ;  IBCNESPC("BEGDT")=Start Dt,  IBCNESPC("ENDDT")=End Dt
 ;  IBCNESPC("PYR")=Pyr IEN OR "" for all
 ;  IBCNESPC("PAT")=Pat IEN OR "" for all
 ;  IBCNESPC("TYPE")=A (All Responses) OR M (Most Recent Responses) for
 ;   unique Pyr/Pt pair
 ;  IBCNESPC("SORT")=1 (PyrNm) OR 2 (PatNm)
 ;  IBCNESPC("TRCN")=Trace #^IEN, if non-null, all params null
 ;  IBCNESPC("RFLAG")=Report Flag used to indicate which report is being
 ;   run.  Response Report (O), Inactive Report (1), or Ambiguous
 ;   Report (2).
 ;  IBCNESPC("DTEXP")=Expiration date used in the inactive policy report
 ;
 ;  Based on structure of IIV Response File (#365)
 ;  ^TMP($J,IBCNERTN,S1,S2,CT,0) based on ^IBCN(365,DA,0)
 ;    IBCNERTN="IBCNERP1", S1=PyrName(SORT=1) or PatNm(SORT=2),
 ;    S2=PatName(SORT=1) or PyrName(SORT=2), CT=Seq ct
 ;  ^TMP($J,IBCNERTN,S1,S2,CT,1) based on ^IBCN(365,DA,1)
 ;  ^TMP($J,IBCNERTN,S1,S2,2,EBCT) based on ^IBCN(365,DA,2)
 ;    EBCT=E/B IEN (365.02)
 ;  ^TMP($J,IBCNERTN,S1,S2,2,EBCT,NTCT)=based on ^IBCN(365,DA,2,EB,NT)
 ;   NTCT=Notes Ct, may not be Notes IEN, if line wrapped (365.021)
 ;  ^TMP($J,IBCNERTN,S1,S2,2,CNCT) based on ^IBCN(365,DA,3)
 ;   CNCT=Cont Pers IEN (365.03)
 ;  ^TMP($J,IBCNERTN,S1,S2,4,CT)= err txt based on ^IBCN(365,DA,4)
 ;   CT=1/2 if >60 ch long
 ; Must call at one of the entry points, EN3 or EN6
 Q
 ;
EN3(IBCNERTN,IBCNESPC) ; Entry pt.  Calls IBCNERP3
 N IBBDT,IBEDT,IBPY,IBPT,IBTYP,IBSRT,CRT,MAXCNT,IBPXT
 N IBPGC,X,Y,DIR,DTOUT,DUOUT,LIN,IBTRC,IPRF
 S IBBDT=$G(IBCNESPC("BEGDT")),IBEDT=$G(IBCNESPC("ENDDT"))
 S IBPY=$G(IBCNESPC("PYR")),IBPT=$G(IBCNESPC("PAT"))
 S IBTYP=$G(IBCNESPC("TYPE")),IBSRT=$G(IBCNESPC("SORT"))
 S IBTRC=$P($G(IBCNESPC("TRCN")),U,1),(IBPXT,IBPGC)=0
 S IBEXP=$G(IBCNESPC("DTEXP"))
 S IPRF=$G(IBCNESPC("RFLAG"))
 ; Determine IO params
 I IOST["C-" S MAXCNT=IOSL-3,CRT=1
 E  S MAXCNT=IOSL-6,CRT=0
 D PRINT^IBCNERP3(IBCNERTN,IBBDT,IBEDT,IBPY,IBPT,IBTYP,IBSRT,.IBPGC,.IBPXT,MAXCNT,CRT,IBTRC,IBEXP,IPRF)
 I $G(ZTSTOP)!IBPXT G EXIT3
 I CRT,IBPGC>0,'$D(ZTQUEUED) D
 . I MAXCNT<51 F LIN=1:1:(MAXCNT-$Y) W !
 . S DIR(0)="E" D ^DIR K DIR
EXIT3 ; Exit pt
 Q
 ;
 ;
EN6(IBCNERTN,IBCNESPC) ; Entry pt.  Calls IBCNERP6
 ;
 ; Init vars
 N CRT,MAXCNT,IBPXT,IBPGC,IBBDT,IBEDT,IBPY,IBSRT,IBDTL
 N X,Y,DIR,DTOUT,DUOUT,LIN,TOTALS
 ;
 S IBBDT=$G(IBCNESPC("BEGDT"))
 S IBEDT=$G(IBCNESPC("ENDDT"))
 S IBPY=$G(IBCNESPC("PYR"))
 S IBDTL=$G(IBCNESPC("DTL"))
 S IBSRT=$G(IBCNESPC("SORT"))
 S (IBPXT,IBPGC)=0
 ;
 ; Determine IO parameters
 I IOST["C-" S MAXCNT=IOSL-3,CRT=1
 E  S MAXCNT=IOSL-6,CRT=0
 ;
 D PRINT^IBCNERP6(IBCNERTN,IBBDT,IBEDT,IBPY,IBDTL,IBSRT,.IBPGC,.IBPXT,MAXCNT,CRT)
 I $G(ZTSTOP)!IBPXT G EXIT6
 I CRT,IBPGC>0,'$D(ZTQUEUED) D
 . I MAXCNT<51 F LIN=1:1:(MAXCNT-$Y) W !
 . S DIR(0)="E" D ^DIR K DIR
 ;
EXIT6 ; Exit pt
 Q
 ;
EBDISP(RPTDATA,DISPDATA,LCT) ; Build sorted Elig/Ben notes for display
 ; Called by IBCNERP3 - all inputs should be passed by reference
 ; Init local variables
 N EBCT,EBSEGS,CT,SRT1,SRT2,SRT3,SRT4,SRT5,SRT6,SEGCT,CT2,ITEM,NTCT
 N STATFLG
 ;
 ; Only build more display lines if notes exist
 S EBCT=+$O(RPTDATA(2,""),-1) I 'EBCT,'$D(RPTDATA(2,0)) G EBEXIT
 S DISPDATA(LCT)="",LCT=LCT+1,DISPDATA(LCT)="Eligibility/Benefit Information:",LCT=LCT+1
 S STATFLG=""
 ; Build EB w/Notes
 I $D(RPTDATA(2,0)) S STATFLG=RPTDATA(2,0)
 F CT=1:1:EBCT D
 . S (SRT1,SRT2,SRT3,SRT4,SRT5)="*"
 . S SEGCT=$L($G(RPTDATA(2,CT)),U)
 . F CT2=2:1:SEGCT S ITEM=$P(RPTDATA(2,CT),U,CT2) I $L(ITEM)>0 D
 . . I CT2=3 S SRT4=ITEM Q
 . . I CT2=4 S SRT2=ITEM Q
 . . I CT2=5 S SRT3=ITEM Q
 . . I CT2=13 S SRT1=ITEM Q
 . S EBSEGS(SRT1,SRT2,SRT3,SRT4,SRT5,CT)=""
 ; Display Active/Inactive/Undetermined message
 S DISPDATA(LCT)="",LCT=LCT+1
 I STATFLG]"" D
 . I STATFLG="U" S DISPDATA(LCT)="IIV was unable to determine the status of this patient's policy.",LCT=LCT+1 Q
 . S DISPDATA(LCT)="IIV has determined that this patient's policy is "_STATFLG_".",LCT=LCT+1
 ; Loop thru sorted EB Notes
 S SRT1="" F  S SRT1=$O(EBSEGS(SRT1)) Q:SRT1=""  D
 . S DISPDATA(LCT)="",LCT=LCT+1
 . I SRT1'="*" S DISPDATA(LCT)=" "_$$LBL^IBCNERP2(365.02,.13)_SRT1,LCT=LCT+1
 . S SRT2="" F  S SRT2=$O(EBSEGS(SRT1,SRT2)) Q:SRT2=""  D
 . . I SRT2'="*" S DISPDATA(LCT)="  "_$$LBL^IBCNERP2(365.02,.04)_SRT2,LCT=LCT+1
 . . S SRT3="" F  S SRT3=$O(EBSEGS(SRT1,SRT2,SRT3)) Q:SRT3=""  D
 . . . I SRT3'="*" S DISPDATA(LCT)="   "_$$LBL^IBCNERP2(365.02,.05)_SRT3,LCT=LCT+1
 . . . S SRT4="" F  S SRT4=$O(EBSEGS(SRT1,SRT2,SRT3,SRT4)) Q:SRT4=""  D
 . . . . I SRT4'="*" S DISPDATA(LCT)="    "_$$LBL^IBCNERP2(365.02,.03)_SRT4,LCT=LCT+1
 . . . . S SRT5="" F  S SRT5=$O(EBSEGS(SRT1,SRT2,SRT3,SRT4,SRT5)) Q:SRT5=""  D
 . . . . . I SRT5'="*" S DISPDATA(LCT)="     "_$$LBL^IBCNERP2(365.02,.02)_SRT5,LCT=LCT+1
 . . . . . S SRT6="" F  S SRT6=$O(EBSEGS(SRT1,SRT2,SRT3,SRT4,SRT5,SRT6)) Q:SRT6=""  D
 . . . . . . S DISPDATA(LCT)="       "
 . . . . . . S SEGCT=$L($G(RPTDATA(2,CT)),U)
 . . . . . . F CT2=2,6:1:$S(SEGCT>12:12,1:SEGCT) S ITEM=$P(RPTDATA(2,SRT6),U,CT2) I $L(ITEM)>0 D
 . . . . . . . ; Display label for all but .09 field - Percentage
 . . . . . . . S ITEM=$S(CT2'=9:$$LBL^IBCNERP2(365.02,(.01*CT2)),1:"")_ITEM
 . . . . . . . I $L(ITEM)+$L(DISPDATA(LCT))>69 S LCT=LCT+1,DISPDATA(LCT)="       "_ITEM Q
 . . . . . . . I DISPDATA(LCT)'="       " S DISPDATA(LCT)=DISPDATA(LCT)_",  "_ITEM Q
 . . . . . . . S DISPDATA(LCT)="       "_ITEM
 . . . . . . ; Notes
 . . . . . . S NTCT=$O(RPTDATA(2,SRT6,""),-1),ITEM="" I NTCT>0 D
 . . . . . . . F CT2=1:1:NTCT S LCT=LCT+1,DISPDATA(LCT)="        "_RPTDATA(2,SRT6,CT2)
 . . . . . . . S LCT=LCT+1,DISPDATA(LCT)="       "
 . . . . . . I $TR(DISPDATA(LCT)," ","")'="" S LCT=LCT+1
EBEXIT ; EBDISP exit point
 Q
 ;
