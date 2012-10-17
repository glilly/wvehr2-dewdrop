LR7OSAP3        ;DALOI/CKA - Silent AP Rpt from TIU;3/27/02
        ;;5.2;LAB SERVICE;**259,315**;Sep 27, 1994;Build 25
        ;
        ;Reference  to EXTRACT^TIULQ supported by IA #2693
        ;Reference to TGET^TIUSRVR1 supported by IA #2944
        ;
MAIN(LRPTR)     ;Main subrouting
        K ^TMP("LRTIU",$J),^TMP("LRTIUTXT",$J)
        D EXTRACT
        D DISSECT
        Q:LRQUIT
        ;Calculate LR and TIU checksums,if they don't match, set flag
        ;  to scramble signature on the report.
        D CHKSUM
        I LRCKSUM'=0,LRCKSUM'=TIUCKSUM S LRENCRYP=1
        ;
        D GLOSET
        K ^TMP("LRTIU",$J),^TMP("LRTIUTXT",$J)
        Q
EXTRACT ;Extract the report from TIU
        N LRQUIT,LRFLG,LRTXT,LROR,LRCNT,LRCNTT,LRHFLG
        Q:'+$G(LRPTR)
        D EXTRACT^TIULQ(LRPTR,"^TMP(""LRTIU"",$J)",,,,1,,1)
        Q:'+$P($G(^TMP("LRTIU",$J,LRPTR,"TEXT",0)),"^",3)
        M ^TMP("LRTIUTXT",$J)=^TMP("LRTIU",$J,LRPTR,"TEXT")
DISSECT ;Dissect the report into header,body, and footer
        S (LROR,LRCNT,LRCNTT,LRHFLG,LRQUIT)=0,LRFLG="H"
        F  S LROR=$O(^TMP("LRTIUTXT",$J,LROR)) Q:LROR'>0!(LRQUIT)  D
        .S LRTXT=$G(^TMP("LRTIUTXT",$J,LROR,0))
        .I 'LRHFLG,LRTXT'="$APHDR" D  Q
        ..S LRQUIT=1
        .I LRTXT="$APHDR" D  Q
        ..S LRHFLG=1
        ..K ^TMP("LRTIUTXT",$J,LROR)
        .I LRFLG="H" D  Q:LRFLG="T"
        ..I LRTXT="$TEXT" D  Q
        ...S ^TMP("LRTIUTXT",$J,"HDR")=LRCNT,LRCNT=0
        ...K ^TMP("LRTIUTXT",$J,LROR)
        ...S LRFLG="T",LRCNT=0
        ..Q:LRFLG="T"
        ..S LRCNT=LRCNT+1,LRCNTT=LRCNTT+1
        ..S ^TMP("LRTIUTXT",$J,"HDR",LRCNT)=LRTXT
        ..K ^TMP("LRTIUTXT",$J,LROR)
        .I LRFLG="T" D  Q:LRFLG="F"
        ..I LRTXT="$FTR" D  Q:LRFLG="F"
        ...S ^TMP("LRTIUTXT",$J,"TEXT")=LRCNT,LRCNT=0
        ...K ^TMP("LRTIUTXT",$J,LROR)
        ...S LRFLG="F"
        ..Q:LRFLG="F"
        ..S LRCNT=LRCNT+1,LRCNTT=LRCNTT+1
        ..S ^TMP("LRTIUTXT",$J,"TEXT",LRCNT)=LRTXT
        ..K ^TMP("LRTIUTXT",$J,LROR)
        .I LRFLG="F" D
        ..S LRCNT=LRCNT+1,LRCNTT=LRCNTT+1
        ..S ^TMP("LRTIUTXT",$J,"FTR",LRCNT)=LRTXT
        ..K ^TMP("LRTIUTXT",$J,LROR)
        S ^TMP("LRTIUTXT",$J,"FTR")=LRCNT
        S ^TMP("LRTIUTXT",$J,0)=LRCNTT
        Q
GLOSET  ;
        S LROR=0
        Q:'$D(^TMP("LRTIUTXT",$J,"HDR"))
        S LROR=0 F  S LROR=$O(^TMP("LRTIUTXT",$J,"HDR",LROR)) Q:LROR'>0  D
        .S LRTXT=$G(^TMP("LRTIUTXT",$J,"HDR",LROR))
        .D LN S ^TMP("LRC",$J,GCNT,0)=LRTXT
        Q:'$D(^TMP("LRTIUTXT",$J,"TEXT"))
        S LROR=0
        F  S LROR=$O(^TMP("LRTIUTXT",$J,"TEXT",LROR)) Q:LROR'>0!(LRQUIT)  D
        .S LRTXT=$G(^TMP("LRTIUTXT",$J,"TEXT",LROR))
        .;If signature line, and marked for encryption, scramble signature
        .I LRTXT["/es/",+$G(LRENCRYP) S LRTXT=$$ENCRYP^XUSRB1(LRTXT)
        .D LN S ^TMP("LRC",$J,GCNT,0)=LRTXT
        Q:'$D(^TMP("LRTIUTXT",$J,"FTR"))
        S LROR=0
        F  S LROR=$O(^TMP("LRTIUTXT",$J,"FTR",LROR)) Q:LROR'>0  D
        .S LRTXT=$G(^TMP("LRTIUTXT",$J,"FTR",LROR))
        .D LN S ^TMP("LRC",$J,GCNT,0)=LRTXT
        Q
LN      ;Increment the counter
        S GCNT=GCNT+1,CCNT=1
        Q
CHKSUM  ;Compare LR and TIU checksums
        ;Get original checksum value from file 63
        N LRTREC,LRROOT,LRFILE,LRIENS,LRFLD,LRREL
        S (LRENCRYP,LRTREC)=0
        I LRSS="AU" D
        .S LRTREC=$O(^LR(LRDFN,101,"C",LRPTR,LRTREC))
        .S LRIENS=LRDFN_","
        .S LRFILE=63.101
        I LRSS'="AU" D
        .S LRTREC=$O(^LR(LRDFN,LRSS,LRI,.05,"C",LRPTR,LRTREC))
        .S LRIENS=LRI_","_LRDFN_","
        .S LRFILE=$S(LRSS="SP":63.19,LRSS="CY":63.47,LRSS="EM":63.49,1:"")
        I LRFILE=""!(LRTREC=0) S LRCKSUM=0 Q
        ;Retrieve LR checksum
        S LRIENS=LRTREC_","_LRIENS
        S LRCKSUM=$$GET1^DIQ(LRFILE,LRIENS,2)
        I LRCKSUM="" S LRCKSUM=0
        ;Calculate TIU checksum
        S $P(^TMP("LRTIU",$J,LRPTR,"TEXT",0),U,5)=$P(^TMP("LRTIU",$J,LRPTR,1201,"I"),".")
        S LRVAL="^TMP(""LRTIU"","_$J_","_LRPTR_",""TEXT"")"
        S TIUCKSUM=$$CHKSUM^XUSESIG1(LRVAL)
        Q
