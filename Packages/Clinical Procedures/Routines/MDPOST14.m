MDPOST14        ;HOIFO/NCA-CREATE ASD Cross Reference ;8:34 AM  9 Jun 2005
        ;;1.0;CLINICAL PROCEDURES;**14**;Apr 01, 2004;Build 20
        N MDERR,MDLP,MDVSTD,MDV,MDX
        Q:$D(^MDD(702,"ASD"))
        D MES^XPDUTL("MDPOST-Create Cross Reference for Scheduled Date/Time...")
        K DIK S DIK="^MDD(702,",DIK(1)=".14^ASD" D ENALL^DIK
        K DIK
        Q
