GMPLSAVE        ; SLC/MKB/KER -- Save Problem List data ; 11/13/2008
        ;;2.0;Problem List;**26,31,35,37,38**;Aug 25, 1994;Build 3
        ;
        ; External References
        ;   DBIA 10018  ^DIE
        ;   DBIA 10013  ^DIK
        ;   DBIA 10013  IX1^DIK
        ;   DBIA 10103  $$HTFM^XLFDT
        ;
EN      ; Save Changes made to Existing Problem
        N FLD,NOW,CHNGE,I,NIFN,TEXT,OLDTEXT,FAC,NODE,AUDITED,DR,DA,DIE,DIK
        I $P($G(GMPFLD(1.14)),U)="0" S GMPFLD(1.14)=""
        S:'GMPORIG(.01) GMPORIG(.01)=$$NOS^GMPLX
        S:'GMPFLD(.01) GMPFLD(.01)=$$NOS^GMPLX
        S:$D(GMPFLD(.01)) GMPFLD(.01)=+GMPFLD(.01)
        S:$P(+GMPFLD(.01),U)=-1 GMPFLD(.01)=$$NOS^GMPLX ;chk for error from ICD
        S:'GMPORIG(1.01) GMPORIG(1.01)="1^Unresolved"
        S:'GMPFLD(1.01) GMPFLD(1.01)="1^Unresolved"
        S:'GMPFLD(.05) I=$P(GMPFLD(.05),U,2),GMPFLD(.05)=$$PROVNARR^GMPLX(I,+GMPFLD(1.01))
        S NOW=$$HTFM^XLFDT($H),AUDITED=0
        S DR="1.02////"_$S('$D(GMPLUSER):"T",1:GMPFLD(1.02))
        I GMPORIG(1.02)="T",GMPFLD(1.02)="P" D
        . S CHNGE=GMPIFN_"^1.02^"_NOW_U_DUZ_"^T^P^Verified^"_DUZ
        . D AUDIT^GMPLX(CHNGE,"")
        I $P($G(GMPORIG(.12)),U)="I",$P(GMPFLD(.12),U)="A" D REACTV S AUDITED=1
        I +$G(GMPORIG(1.01))'=(+GMPFLD(1.01)) D REFORM S AUDITED=1
        S GMPFLD(.01)=+GMPFLD(.01) ;to remove text left by ?? lex (~)
        F FLD=.01,.05,.12,.13,1.01,1.05,1.06,1.07,1.08,1.09,1.1,1.11,1.12,1.13,1.14,1.15,1.16,1.17,1.18 D
        . Q:'$D(GMPFLD(FLD))  Q:$P($G(GMPORIG(FLD)),U)=$P($G(GMPFLD(FLD)),U)
        . S DR=DR_";"_FLD_"////"_$S($P(GMPFLD(FLD),U)'="":$P(GMPFLD(FLD),U),1:"@")
        . Q:AUDITED  S CHNGE=GMPIFN_U_FLD_U_NOW_U_DUZ_U_$P(GMPORIG(FLD),U)_U_$P(GMPFLD(FLD),U)_"^^"_+$G(GMPROV)
        . D AUDIT^GMPLX(CHNGE,"")
        S DA=GMPIFN,DIE="^AUPNPROB(" D ^DIE S GMPSAVED=1
NOTES   ; Save Changes to Notes
        F I=0:0 S I=$O(GMPORIG(10,I)) Q:I'>0  I GMPORIG(10,I)'=GMPFLD(10,I) D
        . S NIFN=+GMPFLD(10,I),FAC=$P(GMPFLD(10,I),U,2),TEXT=$P(GMPFLD(10,I),U,3),OLDTEXT=$P(GMPORIG(10,I),U,3)
        . S NODE=$G(^AUPNPROB(GMPIFN,11,FAC,11,NIFN,0))
        . I TEXT'="" S $P(^AUPNPROB(GMPIFN,11,FAC,11,NIFN,0),U,3)=TEXT D
        .. I TEXT=OLDTEXT Q
        .. S CHNGE=GMPIFN_"^1101^"_NOW_U_DUZ_"^C^^Note Modified^"_+$G(GMPROV)
        . I TEXT=OLDTEXT Q
        . I TEXT="" S CHNGE=GMPIFN_"^1101^"_NOW_U_DUZ_"^A^^Deleted Note^"_+$G(GMPROV)
        . D AUDIT^GMPLX(CHNGE,NODE)
        . I TEXT="" D
        .. S DIK="^AUPNPROB("_GMPIFN_",11,"_FAC_",11,"
        .. S DA(2)=GMPIFN,DA(1)=FAC,DA=NIFN D ^DIK
        I $D(GMPFLD(10,"NEW"))>9 D NEWNOTE
EXIT    ; Quit Saving Changes
        D:$G(GMPSAVED) DTMOD^GMPLX(GMPIFN)
        Q
        ;
REFORM  ; Audit Entry that has been Reformulated
        S CHNGE=GMPIFN_"^1.01^"_NOW_U_DUZ_U_+GMPORIG(1.01)_U_+GMPFLD(1.01)_"^Reformulated^"_+$G(GMPROV)
        S NODE=$G(^AUPNPROB(GMPIFN,0))_U_$G(^AUPNPROB(GMPIFN,1))
        D AUDIT^GMPLX(CHNGE,NODE)
        Q
        ;
REACTV  ; Audit Entry that has been Reactivated
        S CHNGE=GMPIFN_"^.12^"_NOW_U_DUZ_"^I^A^Reactivated^"_+$G(GMPROV)
        S NODE=$G(^AUPNPROB(GMPIFN,0))_U_$G(^AUPNPROB(GMPIFN,1))
        D AUDIT^GMPLX(CHNGE,NODE)
        Q
        ;
NEW     ; Save Collected Values in new Problem Entry
        ;   Output   DA (left defined)
        N DATA,APCDLOOK,APCDALVR,NUM,I,DIK,GMPIFN,TEMP,X
        I $P($G(GMPFLD(1.14)),U)="0" D
        .I '$D(GMPFLD(1.18)) S GMPFLD(1.18)=GMPFLD(1.14)
        .S GMPFLD(1.14)=""
        S:'GMPFLD(.01) GMPFLD(.01)=$$NOS^GMPLX
        S:$P(+GMPFLD(.01),U)=-1 GMPFLD(.01)=$$NOS^GMPLX ;chk for error from ICD
        S GMPFLD(.01)=+GMPFLD(.01) ;to remove text left by ?? lex (~)
        S:'GMPFLD(1.01) GMPFLD(1.01)="1^Unresolved"
        S:'GMPFLD(.05) X=$P(GMPFLD(.05),U,2),GMPFLD(.05)=$$PROVNARR^GMPLX(X,+GMPFLD(1.01))
        S DA=$$NEWPROB(+GMPFLD(.01),+GMPDFN) Q:DA'>0
        S NUM=$$NEXTNMBR(+GMPDFN,+GMPVAMC),GMPSAVED=1 S:'NUM NUM=""
        ;   Set Node 0
        S DATA=^AUPNPROB(DA,0)_U_DT_"^^"_$P(GMPFLD(.05),U)_U_+GMPVAMC_U_+NUM_U_DT_"^^^^"_$P(GMPFLD(.12),U)_U_$P(GMPFLD(.13),U)
        S ^AUPNPROB(DA,0)=DATA
        ;   Set Node 1
        S DATA=$P(GMPFLD(1.01),U) F I=1.02:.01:1.18 S DATA=DATA_U_$P($G(GMPFLD(+I)),U)
        S ^AUPNPROB(DA,1)=DATA
        ;   Set X-Refs
        S DIK="^AUPNPROB(",(APCDLOOK,APCDALVR)=1 D IX1^DIK
        I $D(GMPFLD(10,"NEW"))>9 S GMPIFN=DA D NEWNOTE
        Q
        ;
NEWPROB(ICD,DFN)        ; Creates New Problem Entry in file #9000011
        N I,HDR,LAST,TOTAL,DA
        L +^AUPNPROB(0):1 I '$T D  Q -1
        . W !!,"Someone else is currently editing this file."
        . W !,"Please try again later.",!
        S HDR=$G(^AUPNPROB(0)) Q:HDR="" -1
        S LAST=$P(HDR,U,3),TOTAL=$P(HDR,U,4)
        F I=(LAST+1):1 Q:'$D(^AUPNPROB(I,0))
        S DA=I,^AUPNPROB(DA,0)=ICD_U_DFN
        S ^AUPNPROB("B",ICD,DA)="",^AUPNPROB("AC",DFN,DA)=""
        S $P(^AUPNPROB(0),U,3,4)=DA_U_(TOTAL+1) L -^AUPNPROB(0)
        Q DA
        ;
NEWNOTE ; Creates New Note Entries for Problem
        ;   Requires GMPIFN   Pointer to Problem
        ;            GMPROV   Current Provider
        ;            GMPVAMC  Facility
        N HDR,LAST,TOTAL,I,FAC,NIFN
        L +^AUPNPROB(GMPIFN,11):1 I '$T Q
        S FAC=+$O(^AUPNPROB(GMPIFN,11,"B",GMPVAMC,0)) I 'FAC D
        . S:'$D(^AUPNPROB(GMPIFN,11,0)) ^(0)="^9000011.11PA^^"
        . S HDR=^AUPNPROB(GMPIFN,11,0),LAST=$P(HDR,U,3),TOTAL=$P(HDR,U,4)
        . F I=(LAST+1):1 Q:'$D(^AUPNPROB(GMPIFN,11,I,0))
        . S ^AUPNPROB(GMPIFN,11,I,0)=GMPVAMC,^AUPNPROB(GMPIFN,11,"B",GMPVAMC,I)=""
        . S FAC=I,$P(^AUPNPROB(GMPIFN,11,0),U,3,4)=FAC_U_(TOTAL+1)
        I FAC'>0 G NNQ
NN1     ; Get New Note
        S:'$D(^AUPNPROB(GMPIFN,11,FAC,11,0)) ^(0)="^9000011.1111IA^^"
        S HDR=^AUPNPROB(GMPIFN,11,FAC,11,0),LAST=$P(HDR,U,3),TOTAL=$P(HDR,U,4)
        F I=(LAST+1):1 Q:'$D(^AUPNPROB(GMPIFN,11,FAC,11,I,0))
        S NIFN=I
        F I=0:0 S I=$O(GMPFLD(10,"NEW",I)) Q:I'>0  D
        . S ^AUPNPROB(GMPIFN,11,FAC,11,NIFN,0)=NIFN_"^^"_GMPFLD(10,"NEW",I)_"^A^"_DT_U_+$G(GMPROV)
        . S ^AUPNPROB(GMPIFN,11,FAC,11,"B",NIFN,NIFN)=""
        . S TOTAL=TOTAL+1,LAST=NIFN,NIFN=NIFN+1
        S $P(^AUPNPROB(GMPIFN,11,FAC,11,0),U,3,4)=LAST_U_TOTAL
NNQ     ; Quit Getting New Notes
        L -^AUPNPROB(GMPIFN,11)
        Q
        ;
NEXTNMBR(DFN,VAMC)      ; Returns Next Available Problem Number
        N I,J,NUM S NUM=1,I="" I '$D(^AUPNPROB("AA",DFN,VAMC)) Q NUM
        F  S I=$O(^AUPNPROB("AA",DFN,VAMC,I)) Q:I=""  S J=$E(I,2,999),NUM=+J
        S NUM=NUM+1
        Q NUM
