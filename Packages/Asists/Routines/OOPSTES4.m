OOPSTES4        ;WIOFO/LLH FILE UPDATE TO 2263.6 ;04/24/08
        ;;2.0;ASISTS;**16**;Jun 03, 2002;Build 4
        ;
ADD     ;
        N CODE,COUNT,CODX,NAME,ECX,ECXX,STAT,VHO,ECDINUM,DINUM
        D MES^XPDUTL(" ")
        D BMES^XPDUTL("Adding new charge back code to ASISTS OWCP CHARGEBACK CODE FILE 2263.6(#725)...")
        D MES^XPDUTL(" ")
        S ECDINUM=$O(^OOPS(2263.6,9999),-1),COUNT=$P(^OOPS(2263.6,0),U,4)
        F ECX=1:1 S ECXX=$P($T(NEW+ECX),";;",2) Q:ECXX="QUIT"  D
        .S NAME=$P(ECXX,U,1),CODE=$P(ECXX,U,2),STAT=$P(ECXX,U,3),CODX=$P(ECXX,U,4),VHO=$P(ECXX,U,5)
        .S X=CODE D FILPROC
        D KILL1
        Q
NEW     ;
        ;;VAMC Orlando^4064^675^3^VHA
        ;;QUIT
FILPROC ;
        I $D(^OOPS(2263.6,"B",CODE)) D
        .D MES^XPDUTL(" ")
        .D BMES^XPDUTL("   Your site has "_CODE_" in ASISTS OWCP CHARGEBACK CODE FILE 2263.6")
        I '$D(^OOPS(2263.6,"B",CODE)) D
        .S ECDINUM=ECDINUM+1,DINUM=ECDINUM,DIC(0)="L",DLAYGO=2263.6,DIC="^OOPS(2263.6,"
        .S DIC("DR")=".01////^S X=CODE;1///^S X=NAME;2///^S X=STAT;3///^S X=CODX;4///^S X=VHO"
        .D FILE^DICN
        .I +Y>0 D
        ..D MES^XPDUTL(" ")
        ..D BMES^XPDUTL(CODE_"  ...successfully added.")
        .I Y=-1 D 
        ..D MES^XPDUTL(" ")
        ..D BMES^XPDUTL("ERROR when attempting to add "_CODE)
        .K Y
        Q
KILL1   ;
        K DIC("DR"),DLAYGO,DIC,DIC(0),X
