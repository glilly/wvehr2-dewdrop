IVMCM9  ;ALB/SEK,CKN,TDM - ADD DCD DEPENDENT CHANGES TO 408.13 & 408.41 ; 5/10/06 11:19am
        ;;2.0;INCOME VERIFICATION MATCH;**17,105,115**;21-OCT-94;Build 28
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
AUDIT   ; change dependent demo data in 408.13 and add changes to 408.41.
        ; if IVM transmitted IEN of 408.12 and IEN found at VAMC, any of the
        ; 4 demo fields could be different.  if ien of 408.12 is not
        ; transmitted and dependent is found in 408.13, name & ssn could be
        ; different because sex, dob, & relationship (408.12) must be the same.
        I IVMDOB'=IVMDOB13 D
        .S DGMTACT="DOB",DGMTSOLD=IVMDOB13,DGMTSNEW=IVMDOB D SET^DGMTAUD
        .S IVMDR=".03////^S X=IVMDOB"
        .Q
        I IVMSEX'=IVMSEX13 D
        .S DGMTACT="SEX",DGMTSOLD=IVMSEX13,DGMTSNEW=IVMSEX D SET^DGMTAUD
        .S IVMDR=$S($D(IVMDR):IVMDR_";",1:"") S IVMDR=IVMDR_".02////^S X=IVMSEX"
        .Q
AUDIT1  I IVMNM'=IVMNM13 D
        .S DGMTACT="NAM",DGMTSOLD=IVMNM13,DGMTSNEW=IVMNM D SET^DGMTAUD
        .S IVMDR=$S($D(IVMDR):IVMDR_";",1:"") S IVMDR=IVMDR_".01////^S X=IVMNM"
        .Q
        I IVMSSN'=IVMSSN13 D
        .;If spouse and not a pseudo quit if not verified
        .Q:(IVMSPCHV="S")&(IVMSSNVS'=4)&(IVMSSN'["P")
        .S DGMTACT="SSN",DGMTSOLD=IVMSSN13,DGMTSNEW=IVMSSN D SET^DGMTAUD
        .S IVMSSN=$S(IVMSSN="":"@",1:IVMSSN)
        .S IVMDR=$S($D(IVMDR):IVMDR_";",1:"") S IVMDR=IVMDR_".09////^S X=IVMSSN"
        .Q
        I IVMPSSNR'=IVMPSR13 D
        .S IVMPSSNR=$S(IVMPSSNR="":"@",1:IVMPSSNR)
        .S IVMDR=$S($D(IVMDR):IVMDR_";",1:"") S IVMDR=IVMDR_".1////^S X=IVMPSSNR"
        .Q
        I IVMSSNVS'=IVMSVS13 D
        .I IVMSPCHV="S",IVMSSNVS="" Q  ;If spouse quit if no verify status
        .I IVMSPCHV="S",IVMSSNVS=2,IVMSSN'=IVMSSN13 Q  ;Quit if Spouse, verify status=Invalid and NO SSN match
        .S IVMSSNVS=$S(IVMSSNVS="":"@",1:IVMSSNVS)
        .S IVMDR=$S($D(IVMDR):IVMDR_";",1:"") S IVMDR=IVMDR_".11////^S X=IVMSSNVS"
        .Q
        I IVMSPMNM'=IVMSMN13 D
        .S IVMSPMNM=$S(IVMSPMNM="":"@",1:IVMSPMNM)
        .S IVMDR=$S($D(IVMDR):IVMDR_";",1:"") S IVMDR=IVMDR_"1.1////^S X=IVMSPMNM"
        .Q
        ;
        ; change 408.13
        I $D(IVMDR) S DR=IVMDR,DA=DGIPI,DIE="^DGPR(408.13," D ^DIE K DA,DIE,DR,IVMDR Q
        K DGDEPI,DGMTA,DGMTACT,DGMTSNEW,DGMTSOLD
        Q
        ;
AUDITP  ; set common variables for audit
        S DGMTYPT=$S(IVMTYPE=3:"",1:IVMTYPE),DGDEPI=DGIPI
        I IVMMTIEN S DGMTA=$G(^DGMT(408.31,IVMMTIEN,0))
        S $P(DGMTA,"^",2)=DFN
        K IVMDR
        ;
        ; dgrel("s") contains 408.12 IEN of active spouse of VAMC test
        ; dgrel("c",xxx) contains 408.12 IEN of active children of VAMC test
        ; if VAMC dependent not a DCD dependent the dependent must be inactivated
        ; dependents remaining in dgrel after all DCD dependents are uploaded, will be inactivated
        ; if DCD & VAMC dependent, kill dgrel to prevent inactivation of dependent
        ; dgpri is DCD (or DCD & VAMC) dependent's 408.12 IEN
        I IVMSPCHV="S" D  Q
        .I +$G(DGREL("S"))=DGPRI K DGREL("S")
        S IVMFLG4=1,IVMCC=0 F  S IVMCC=$O(DGREL("C",IVMCC)) Q:'IVMCC  D  Q:'IVMFLG4
        .I +$G(DGREL("C",IVMCC))=DGPRI S IVMFLG4=0 K DGREL("C",IVMCC)
        K IVMCC
        Q
