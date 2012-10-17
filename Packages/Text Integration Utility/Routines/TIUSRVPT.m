TIUSRVPT        ; SLC/JER - Set Methods for Documents ;03/02/10  09:59
        ;;1.0;TEXT INTEGRATION UTILITIES;**122,175,186,210,223,250**;Jun 20, 1997;Build 14
        ;
        ; ICR #10018    - DIE Routine & DIE, DR, & DA Local Vars
        ;     #10103    - $$FMADD^XLFDT,$$NOW^XLFDT
        ;
SETTEXT(TIUY,TIUDA,TIUX,SUPPRESS)       ; Save Text - use Buffered I/O
        N PAGES,PAGE S TIUY=0,SUPPRESS=$G(SUPPRESS,0)
        I $S(+$G(TIUDA)'>0:1,'$D(^TIU(8925,+TIUDA,0)):1,1:0) D  Q
        . S TIUY="0^0^0^Attempt to file data in a Nonexistent Entry."
        . D ERROR(TIUY)
        S PAGE=$P($G(TIUX("HDR")),U),PAGES=$P($G(TIUX("HDR")),U,2)
        I $S('PAGE:1,'PAGES:1,1:0) D  Q
        . S TIUY="0^0^0^Invalid text block header"
        . D ERROR(TIUY)
        ; I PAGE=1 D MERGTEMP^TIUEDI1(TIUDA) K ^TIU(8925,+TIUDA,"TEMP"),^("TEXT")
        I PAGE=1 K ^TIU(8925,+TIUDA,"TEMP")
        M ^TIU(8925,+TIUDA,"TEMP")=TIUX("TEXT")
        ;if done, commit changes
        I 'SUPPRESS,(PAGE=PAGES),$D(^TIU(8925,TIUDA,"TEMP")) D
        . N TIUC,TIUI,TIU,TIUD12,TIUAU,TIUEC S (TIUC,TIUI)=0
        . F  S TIUI=$O(^TIU(8925,TIUDA,"TEMP",TIUI)) Q:+TIUI'>0  D
        . . S TIUC=TIUC+1
        . I TIUC>0 S ^TIU(8925,TIUDA,"TEMP",0)="^^"_TIUC_U_TIUC_U_DT_"^^"
        . D GETTIU^TIULD(.TIU,TIUDA)
        . K ^TIU(8925,TIUDA,"TEXT")
        . S TIUC=0 F  S TIUC=$O(^TIU(8925,"DAD",TIUDA,TIUC)) Q:+TIUC'>0  D
        . . I +$$ISADDNDM^TIULC1(+TIUC) Q
        . . K ^TIU(8925,+TIUC,"TEXT")
        . D MERGTEXT^TIUEDI1(+TIUDA,.TIU)
        . K ^TIU(8925,TIUDA,"TEMP")
        . ; If user is neither author or expected cosigner, file VBC Line count
        . S TIUD12=$G(^TIU(8925,TIUDA,12)),TIUAU=$P(TIUD12,U,2),TIUEC=$P(TIUD12,U,8)
        . I (TIUAU]""),(DUZ'=TIUAU) D
        . . I (TIUEC]""),(DUZ=TIUEC) Q
        . . D LINES(TIUDA)
        ; Acknowledge success / ask for next page
        S TIUY=TIUDA_U_PAGE_U_PAGES
        Q
LINES(DA)       ; Compute/file VBC Line count
        N DIE,DR S DIE="^TIU(8925,",DR=".1///"_$$LINECNT^TIULC(DA)_";1801///"_$$VBCLINES^TIULC(+DA)
        D ^DIE
        Q
ADMNCLOS(TIUY,TIUDA,MODE,PERSON)        ; Post Administrative Closure Information
        N TIUX,TIUI,TIUCLBY,TIUCLTTL,TIUCAPT
        I '$D(^TIU(8925,TIUDA)) S TIUY="0^Attempt to file data in a Nonexistent Entry." Q
        S MODE=$G(MODE,"S")
        S TIUCAPT=$S("ES"[MODE:"  Electronically Filed: ",1:"Administrative Closure: ")
        S PERSON=$G(PERSON,DUZ)
        S TIUCLBY=$$SIGNAME^TIULS(PERSON)
        S TIUCLTTL=$$SIGTITL^TIULS(PERSON)
        S TIUX(.05)=7
        S TIUX(1606)=$G(DT)
        S TIUX(1607)=TIUCLBY
        S TIUX(1608)=TIUCLTTL
        S TIUX(1613)=MODE
        D FILE^TIUSRVP(.TIUY,TIUDA,.TIUX)
        S TIUI=$P($G(^TIU(8925,TIUDA,"TEXT",0)),U,3)+1
        ;If scanned document set document body to informational text
        I MODE="S" D
        . S ^TIU(8925,+TIUDA,"TEXT",TIUI,0)=" ",TIUI=TIUI+1
        . S ^TIU(8925,+TIUDA,"TEXT",TIUI,0)="                           *** SCANNED DOCUMENT ***",TIUI=TIUI+1
        . S ^TIU(8925,+TIUDA,"TEXT",TIUI,0)="                            SIGNATURE NOT REQUIRED",TIUI=TIUI+1
        . S ^TIU(8925,+TIUDA,"TEXT",TIUI,0)=" ",TIUI=TIUI+1
        S ^TIU(8925,TIUDA,"TEXT",TIUI,0)=" ",TIUI=TIUI+1
        S ^TIU(8925,TIUDA,"TEXT",TIUI,0)=TIUCAPT_$$DATE^TIULS(DT,"MM/DD/CCYY"),TIUI=TIUI+1
        S ^TIU(8925,TIUDA,"TEXT",TIUI,0)="                    by: "_TIUCLBY,TIUI=TIUI+1
        S ^TIU(8925,TIUDA,"TEXT",TIUI,0)="                        "_TIUCLTTL
        S ^TIU(8925,+TIUDA,"TEXT",0)="^^"_TIUI_U_TIUI_U_DT_"^^"
        D ALERTDEL^TIUALRT(TIUDA)
        ; post-signature action for administratively closed docs
        N TIUCONS,TIUSTIS,TIUTTL,TIUPSIG,DA S TIUCONS=-1
        D ISCNSLT^TIUCNSLT(.TIUCONS,+$G(^TIU(8925,TIUDA,0)))
        S TIUSTIS=$P($G(^TIU(8925,TIUDA,0)),U,5)
        S TIUTTL=+$G(^TIU(8925,+TIUDA,0)),TIUPSIG=$$POSTSIGN^TIULC1(TIUTTL)
        I +$L(TIUPSIG) S DA=TIUDA X TIUPSIG
        I TIUCONS,TIUSTIS=7,$$HASKIDS^TIUSRVLI(TIUDA) D
        . N SEQUENCE,TIUKIDS,TIUINT,TIUK
        . S SEQUENCE="D",TIUKIDS="TIUKIDS",TIUINT=0,TIUK=0
        . D SETKIDS^TIUSRVLI(TIUKIDS,TIUDA,TIUINT)
        . F  S TIUK=$O(TIUKIDS(TIUK)) Q:'TIUK  D
        . . I $P(TIUKIDS(TIUK),U,7)="completed" X TIUPSIG
        Q
ERROR(ECODE)    ; Register AUTOSAVE Error
        N ERRDT S ERRDT=+$$NOW^XLFDT
        Q:+$G(^XTMP("TIUERR","COUNT"))'<100
        I '$D(^XTMP("TIUERR",0)) D
        . S ^XTMP("TIUERR",0)=$$FMADD^XLFDT(DT,90)_U_DT
        S ^XTMP("TIUERR",ERRDT,"ECODE")=ECODE
        S ^XTMP("TIUERR",ERRDT,"USER")=DUZ
        S ^XTMP("TIUERR",ERRDT,"TIUDA")=$G(TIUDA,"UNDEFINED")
        S ^XTMP("TIUERR",ERRDT,"TIUHDR")=$G(TIUX("HDR"))
        S ^XTMP("TIUERR",ERRDT,"XWBHDR")=$G(XWBS1("HDR"))
        S ^XTMP("TIUERR","COUNT")=$G(^XTMP("TIUERR","COUNT"))+1
        Q
