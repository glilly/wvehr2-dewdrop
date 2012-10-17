HBHCXMA1        ; LR VAMC(IRMS)/MJT-HBHC, called by ^HBHCXMA, entry points: START, ERROR, EXIT, calls HOSP^HBHCUTL1 ; Jul 2000
        ;;1.0;HOSPITAL BASED HOME CARE;**2,6,14,19,24**;NOV 01, 1993;Build 201
START   ; Initialization
        W !,"Processing Admission/Form 3 Data"
        S HBHCFORM=3,$P(HBHCSP1," ",2)="",$P(HBHCSP2," ",3)="",$P(HBHCSP4," ",5)="",$P(HBHCSP5," ",6)="",$P(HBHCSP6," ",7)="",$P(HBHCSP8," ",9)="",$P(HBHCSP16," ",17)="",HBHCLNTH=30
        D HOSP^HBHCUTL1
        S HBHCFLD1="HBHCMARE^HBHCLIVE^HBHCCARE^HBHCTYPE"
        S HBHCFLD2="HBHCVISA^HBHCHERA^HBHCEXCA^HBHCRECA^HBHCBTHA^HBHCDRSA^HBHCTLTA^HBHCTRNA^HBHCEATA^HBHCWLKA^HBHCBWLA^HBHCBLDA^HBHCMOBA^HBHCADTA^HBHCBHVA^HBHCDSOA^HBHCMODA^HBHCLMTA"
        K %DT S X="T" D ^%DT S HBHCTDY=Y
        ; Initialize variables passed for $$PRT2CODE^DGUTL4(VALUE,TYPE,CODE) calls
        ; Following comments stolen from DGUTL4 routine:
        ; Convert pointer to specified code
        ; Input: VALUE - Pointer to RACE file (#10), ETHNICITY file (#10.2),
        ;                or RACE AND ETHNICITY COLLECTION METHOD file (#10.3)
        ;        TYPE - Flag indicating which file VALUE is for
        ;               1 = Race (default)
        ;               2 = Ethnicity
        ;               3 = Collection Method
        ;        CODE - Flag indicating which code to return
        ;               1 = Abbreviation (default)
        ;               2 = HL7
        ;               3 = CDC (not applicable for Collection Method)
        ;               4 = PTF
        ; End of DGUTL4 comment theft  mjt
        ; Race = 10, Ethnicity = 102, Collection Method = 103
        ; Type
        S HBHCT103=3
        ; Code, PTF Value used for all files
        S HBHCPTF=4
        ; Race field set to "X" & became Historical only, beginning w/Jan 2003 new Race & Ethnicity Information fields mandate  mjt
        S HBHCRC="X"
        Q
ERROR   ; Set node in ^HBHC(634.1) if data is incomplete or proper fields invalid for 'Admit/Reject Action'
        L +^HBHC(634.1,0):$S($D(DILOCKTM):DILOCKTM,1:3) Q:'$T  S HBHCNDX2=$P(^HBHC(634.1,0),U,3)+1,$P(^HBHC(634.1,0),U,3)=HBHCNDX2,$P(^HBHC(634.1,0),U,4)=$P(^HBHC(634.1,0),U,4)+1 L -^HBHC(634.1,0)
        S ^HBHC(634.1,HBHCNDX2,0)=$P(HBHCINFO,U)_U_HBHCDFN,^HBHC(634.1,HBHCNDX2,1)=HBHCDR,^HBHC(634.1,"B",$P(HBHCINFO,U),HBHCNDX2)=""
        Q
EXIT    ; Exit module => cleanup for HBHCXMA
        K DILOCKTM,HBHC,HBHCACTN,HBHCADDT,HBHCADTA,HBHCAFLG,HBHCBHVA,HBHCBLDA,HBHCBTHA,HBHCBWLA,HBHCBYR,HBHCCM,HBHCCARE,HBHCCDTS,HBHCCNTY,HBHCCURJ,HBHCCURK,HBHCDATE,HBHCDFN,HBHCDPT0,HBHCDR,HBHCDRSA,HBHCDSOA,HBHCEATA,HBHCELGE,HBHCEND,HBHCETH
        K HBHCEXCA,HBHCFIL,HBHCFLD,HBHCFLD1,HBHCFLD2,HBHCFLG,HBHCFORM,HBHCHERA,HBHCHOSP,HBHCI,HBHCICDA,HBHCIEN,HBHCIEN2,HBHCIENP,HBHCINFO,HBHCJ,HBHCK,HBHCL,HBHCLIVE,HBHCLMTA,HBHCLNTH,HBHCMARE,HBHCMFHP,HBHCMFHS,HBHCMOBA,HBHCMODA,HBHCMPT
        K HBHCNAME,HBHCNDX1,HBHCNDX2,HBHCNOD3,HBHCNODE,HBHCPSRV,HBHCPTF,HBHCPTFV,HBHCRACE,HBHCRC,HBHCREC,HBHCRECA,HBHCREJ,HBHCREJD,HBHCRFIN,HBHCRFLG,HBHCRTDT,HBHCRTPD,HBHCSEX,HBHCSP1,HBHCSP16,HBHCSP2,HBHCSP4,HBHCSP5,HBHCSP6,HBHCSP8
        K HBHCSSN,HBHCST,HBHCSX,HBHCT103,HBHCTDY,HBHCTLTA,HBHCTRNA,HBHCTYPE,HBHCVAR,HBHCVISA,HBHCWLKA,HBHCX,HBHCXMT3,HBHCZIP,X,Y,%DT
        Q
