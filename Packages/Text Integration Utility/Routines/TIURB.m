TIURB   ; SLC/JER - More Review Screen Actions ;12/11/07
        ;;1.0;TEXT INTEGRATION UTILITIES;**4,32,52,78,58,100,109,155,184,234**;Jun 20, 1997;Build 6
        ; DBIA 3473 TIU use of GMRCTIU
AMEND   ; Amendment action
        N TIUDA,DFN,DIE,DR,TIU,TIUDATA,TIUI,TIUSIG,TIUY,X,X1,Y
        N DIROUT,TIUCHNG,TIUDAARY,TIULST
        I '$D(VALMY) D EN^VALM2(XQORNOD(0))
        S TIUI=0
        F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
        . N RSTRCTD
        . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
        . S TIUDA=+$P(TIUDATA,U,2) S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
        . I RSTRCTD D  Q
        . . W !!,$C(7),"Ok, no harm done...",! ; Echo denial message
        . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
        . W !!,"Amending #",+TIUDATA
        . S TIUCHNG=0
        . D AMEND1
        . I $G(TIUDAARY(TIUI)) D
        . . S TIULST=$G(TIULST)_$S($G(TIULST)]"":",",1:"")_TIUI
        ; -- Update or Rebuild list, restore video:
        D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY
        S VALMBCK="R"
        D VMSG^TIURS1($G(TIULST),.TIUDAARY,"amended")
        Q
AMEND1  ; Single record amend
        N TIUCMT,TIUT0,TIUTYP,TIUAMND,TIUSNM,TIUSBLK,TIUCSNM,TIUCSBLK,DIE,DR
        N DA,DFN,DIWESUB,TIU,TIUODA,TIUTITL,TIUCLSS,TIUCON,TIUCNSLT,TIUPRF,TIUFLAG
        K ^TMP("TIURTRCT",$J)
        ; TIU*155 Gets consult data if exists
        S TIUTITL=$P($G(^TIU(8925,TIUDA,0)),U)
        S TIUCLSS=$$CLASS^TIUCNSLT()
        S TIUCON=+$$ISA^TIULX(TIUTITL,TIUCLSS)
        S TIUCNSLT=+$P($G(^TIU(8925,TIUDA,14)),U,5)
        S TIUPRF=0,TIUFLAG=0
        D ISPRFTTL^TIUPRF2(.TIUPRF,TIUTITL)
        I TIUPRF S TIUFLAG=$$FNDACTIF^TIUPRFL(TIUDA)
        L +^TIU(8925,+TIUDA):1
        E  D  Q
        . W !?5,$C(7),"Another user is editing this entry." H 3
        . S TIUCHNG("REFRESH")=1
        I +$P($G(^TIU(8925,+TIUDA,0)),U,5)'>6 D  Q
        . W !?5,$C(7),"Only SIGNED Documents may be amended."
        . I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
        . S TIUCHNG("REFRESH")=1
        I '$$ISA^USRLM(+$G(DUZ),"PRIVACY ACT OFFICER"),'$$ISA^USRLM(+$G(DUZ),"CHIEF, MIS"),'$$ISA^USRLM(+$G(DUZ),"CHIEF, HIM") D  Q
        . W !?5,$C(7),"Only Privacy Act Officers or MIS/HIM Chiefs may amend documents."
        . I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
        . S TIUCHNG("REFRESH")=1
        I +$$HASIMG^TIURB2(TIUDA) D IMGNOTE^TIURB2 Q
        ;S TIUAMND=$$CANDO^TIULP(TIUDA,"AMENDMENT")
        ;I +TIUAMND'>0 D  Q
        ;. W !!,$C(7),$C(7),$C(7),$P(TIUAMND,U,2),!
        ;. S TIUCHNG("REFRESH")=1
        ;. I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
        W !!,"Before proceeding, please enter your Electronic Signature Code..."
        S TIUAMND=$$GETSIG^TIURD2
        I +TIUAMND'>0 D  Q
        . W !!,"  Ok, no harm done...",!
        . S TIUCHNG("REFRESH")=1
        . I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
        W !!,"The ORIGINAL document will be RETRACTED, and a copy will be amended...",!
        S TIUODA=TIUDA
        S TIUDA=+$$RETRACT^TIURD2(TIUDA,"",7)
        I '+TIUDA D  Q
        . W !!,$C(7),$C(7),$C(7),"Retraction of Original Document Failed.",!
        . I $$READ^TIUU("EA","Press RETURN to continue...") ; pause
        . S TIUDA=TIUODA,TIUCHNG("REFRESH")=1
        L +^TIU(8925,TIUDA):1
        E  D  Q
        . W !?5,$C(7),"Another user is editing this entry."
        . D RECOVER^TIURD4(TIUODA,TIUDA) H 3
        . S TIUPRF=$$LINK^TIUPRF1(TIUODA,+TIUFLAG,$P(TIUFLAG,U,2),$P($G(^TIU(8925,TIUODA,0)),U,2))
        . S TIUDA=TIUODA,TIUCHNG("REFRESH")=1
        S TIUSNM=$$DECRYPT^TIULC1($P(^TIU(8925,TIUDA,15),U,3),1,$$CHKSUM^TIULC("^TIU(8925,"_TIUDA_",""TEXT"")"))
        S TIUSBLK=$$DECRYPT^TIULC1($P($G(^TIU(8925,TIUDA,15)),U,4),1,$$CHKSUM^TIULC("^TIU(8925,"_TIUDA_",""TEXT"")"))
        S TIUCSNM=$$DECRYPT^TIULC1($P(^TIU(8925,TIUDA,15),U,9),1,$$CHKSUM^TIULC("^TIU(8925,"_TIUDA_",""TEXT"")"))
        S TIUCSBLK=$$DECRYPT^TIULC1($P($G(^TIU(8925,TIUDA,15)),U,10),1,$$CHKSUM^TIULC("^TIU(8925,"_TIUDA_",""TEXT"")"))
        S TIUTYP=+$G(^TIU(8925,+TIUDA,0)),TIUT0=$G(^TIU(8925.1,+TIUTYP,0))
        S TIUTYP(1)="1^"_+TIUTYP_U_$P(TIUT0,U,3)_U
        S DFN=$P($G(^TIU(8925,+TIUDA,0)),U,2)
        D GETTIU^TIULD(.TIU,TIUDA)
        S DIWESUB="Patient: "_$G(TIU("PNM"))
        S TIUCHNG=0 D FULL^VALM1,TEXTEDIT^TIUEDI4(TIUDA,.TIUCMT,.TIUCHNG)
        I '+$G(TIUCHNG) D  Q
        . L -^TIU(8925,TIUDA)
        . D RECOVER^TIURD4(TIUODA,TIUDA)
        . S TIUPRF=$$LINK^TIUPRF1(TIUODA,+TIUFLAG,$P(TIUFLAG,U,2),$P($G(^TIU(8925,TIUODA,0)),U,2))
        . L -^TIU(8925,TIUODA) H 3
        . S TIUDA=TIUODA,TIUCHNG("REFRESH")=1
        I +$G(TIUCHNG) D
        . S DR=".05///AMENDED;1601////"_$$NOW^XLFDT_";1602////"_DUZ,DA=TIUDA,TIUSIG=0
        . S DR=DR_";1603////"_$$NOW^XLFDT_";1604///^S X=$$SIGNAME^TIULS(DUZ);1605///^S X=$$SIGTITL^TIULS(DUZ)",TIUSIG=1
        . S DIE=8925 D ^DIE
        . ; Refile /es/-block fields
        . S DR="1503///^S X=TIUSNM;1504///^S X=TIUSBLK;1509///^S X=TIUCSNM;1510///^S X=TIUCSBLK"
        . D ^DIE
        ; Drop Locks on both documents
        L -^TIU(8925,+TIUDA)
        L -^TIU(8925,+TIUODA)
        S TIUDAARY(TIUI)=TIUDA
        S TIUCHNG("RBLD")=1
        ; if note is associated with a patient record flag - clean up
        I +TIUFLAG S TIUPRF=$$LINK^TIUPRF1(TIUDA,+TIUFLAG,$P(TIUFLAG,U,2),$P($G(^TIU(8925,TIUDA,0)),U,2))
        ; TIU*155 If note is associated with a consult update ^GMR global
        ; to include the amended note
        ; Rollback retracted note from ^GMR(123 node 50
        I $G(TIUCON)=1 D
        . N STATUS,GMRCSTAT,TIUAUTH
        . S STATUS=$P($G(^TIU(8925,TIUDA,0)),U,5)
        . S GMRCSTAT=$S(STATUS>6:"COMPLETED",1:"INCOMPLETE")
        . S TIUAUTH=$P($G(^TIU(8925,TIUDA,12)),U,2)
        . D ROLLBACK^TIUCNSLT(TIUODA)
        . D GET^GMRCTIU(TIUCNSLT,TIUDA,GMRCSTAT,TIUAUTH)
        Q
SENDBACK        ; Send back a Document to transcription
        N TIUDA,DFN,TIU,TIUDATA,TIUCHNG,TIUI,TIUY,Y,DIROUT,TIULST
        N TIUDAARY
        I '$D(VALMY) D EN^VALM2(XQORNOD(0))
        S TIUI=0
        I +$O(VALMY(0)) D CLEAR^VALM1
        F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
        . N TIU,RSTRCTD
        . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
        . S TIUDA=+$P(TIUDATA,U,2) S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
        . I RSTRCTD D  Q
        . . W !!,$C(7),"Ok, no harm done...",! ; Echo denial message
        . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
        . S TIUDAARY(TIUI)=TIUDA
        . S TIUCHNG=0
        . D EN^VALM("TIU SEND BACK")
        . I +$G(TIUCHNG) D
        . . S TIULST=$G(TIULST)_$S($G(TIULST)]"":",",1:"")_TIUI
SENDX   ; Revise list and cycle back as appropriate
        I $G(TIUCHNG("ADDM"))!$G(TIUCHNG("DELETE")) S TIUCHNG("RBLD")=1
        E  S TIUCHNG("UPDATE")=1
        D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY
        S VALMBCK="R"
        D VMSG^TIURS1($G(TIULST),.TIUDAARY,"sent back")
        Q
LINK    ; Link to problem(s)
        N TIUCHNG,TIUDA,DFN,TIU,TIUDATA,TIUEDIT,TIUI,TIUY,TIULST,Y,DIROUT
        N TIUDAARY
        I '$D(VALMY) D EN^VALM2(XQORNOD(0))
        S TIUI=0
        I +$O(VALMY(0)) D CLEAR^VALM1
        F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
        . N TIU,VALMY,XQORM,VA,VADM,GMPDFN,GMPLUSER,RSTRCTD
        . S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
        . S TIUDA=+$P(TIUDATA,U,2),GMPLUSER=1
        . I '$D(^TIU(8925,+TIUDA,0)) D  Q
        . . W !,$C(7),"Document no longer exists.",!
        . . I $$READ^TIUU("EA","Press RETURN to continue...") W ""
        . S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
        . I RSTRCTD D  Q
        . . W !!,$C(7),"Ok, no harm done...",! ; Echo denial message
        . . I $$READ^TIUU("EA","RETURN to continue...") ; pause
        . S TIUDAARY(TIUI)=TIUDA
        . S DFN=+$P($G(^TIU(8925,+TIUDA,0)),U,2)
        . I +DFN D DEM^VADPT S GMPDFN=DFN_U_VADM(1)_U_$E(VADM(1))_VA("BID")
        . S TIUCHNG=0
        . D EN^VALM("TIU LINK TO PROBLEM")
        . I +$G(TIUCHNG) S TIULST=$G(TIULST)_$S($G(TIULST)]"":",",1:"")_TIUI
LINKX   ; Revise list and cycle back as appropriate
        S TIUCHNG("REFRESH")=1
        D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY
        S VALMBCK="R"
        D VMSG^TIURS1($G(TIULST),.TIUDAARY,"linked to problems")
        Q
DEL(DA) ; -- Call to DEL for backward compatibility
        G GODEL^TIURB2
        Q
