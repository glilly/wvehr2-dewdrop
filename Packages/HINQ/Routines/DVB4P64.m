DVB4P64 ;ALB/MJB - DISABILITY FILE UPDATE ; 6/28/10 1:34pm
        ;;4.0;HINQ;**64**;03/25/92;Build 25
        ;
        Q
EN      ; START UPDATE
        D BMES^XPDUTL("  >>> *** Updating the DISABILITY CONDITION (#31) file...")
        D MES^XPDUTL("      *** Please be patient, this should take less than 5 minutes.")
        D MES^XPDUTL("  ")
        D POST^DVB464 ; ADD NEW DISABILITY CONDITIONS
        D POST^DVB464P ;DELETE REQUESTED ICD'S FROM MAPPING
        D POST^DVB464PA ; ADD NEW DIAGNOSIC CODES TO MAPPING
        Q
