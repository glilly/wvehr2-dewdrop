GMRARAD1        ;HIRMFO/WAA-RADIOLOGY ALLERGY INTERFACE ; 12/4/07 11:47am
        ;;4.0;Adverse Reaction Tracking;**13,27,41**;Mar 29, 1996;Build 8
PSCHK(GMRAVAR)  ; This function will return a 1 (true) if the variable ptr
        ; passed in (GMRAVAR) has a RADIOLOGICAL CONTRAST/MEDIA VA Drug
        ; Class associated with it.
        N CHK,GMRAX,GMRAY
        ;--41
        S CHK=0,GMRAX=$P(GMRAVAR,";")
        D ZERO^PSS50(GMRAX,"","","","","ENCAP")
        I $P(GMRAVAR,";",2)="PSDRUG(" S:"^DX100^DX101^DX102^DX103^DX104^DX105^DX106^DX107^DX108^DX109^"[("^"_$G(^TMP($J,"ENCAP",GMRAX,2))_"^") CHK=1
        K ^TMP($J,"ENCAP")
        ;--41
        I $P(GMRAVAR,";",2)=$P($$NDFREF^GMRAOR,U,2) D:$D(@($$NDFREF^GMRAOR_GMRAX_",0)"))
        .N CLASS,GMRACL
        .S CLASS=$$CLIST^PSNAPIS(GMRAX,.GMRACL) I $O(GMRACL(0)) D  Q:CHK
        ..S CLASS=0 F  S CLASS=$O(GMRACL(CLASS)) Q:'CLASS  D
        ...I "^DX100^DX101^DX102^DX103^DX104^DX105^DX106^DX107^DX108^DX109^"[("^"_$P(GMRACL(CLASS),U,2)_"^") S CHK=1
        ..Q
        .Q
        Q CHK
