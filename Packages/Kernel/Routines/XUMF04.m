XUMF04  ;BP/RAM - INSTITUTION SEGMENTS ;06/28/00
        ;;8.0;KERNEL;**549**;Jul 10, 1995;Build 9
        ;
        Q
        ;
MSA(ERROR,HLFS,HL)      ; - ACK 
        ;
        S:$G(HLFS)="" HLFS="^"
        ;
        Q "MSA"_HLFS_$S(ERROR:"AE",1:"AA")_HLFS_$G(HL("MID"))
        ;
QRD(HLFS,WHO)   ; -- query definition segment
        ;
        S:$G(HLFS)="" HLFS="^"
        S:$G(WHO)="" WHO="VASTANUM"
        ;
        N QDT,QFC,QP,QID,ZDRT,ZDRDT,QLR,WHAT,WDDC,WDCVQ,QRL,QRD
        ;
        S QDT=$$HLDATE^HLFNC($$NOW^XLFDT)
        S QFC="R"
        S QP="I"
        S QID="Z04"
        S ZDRT=""
        S ZDRDT=""
        S QLR="RD"_HLCS_999
        S WHAT="INSTITUTION"
        S WDDC="VA"
        S WDCVQ=""
        S QRL=""
        S QRD="QRD"_HLFS_QDT_HLFS_QFC_HLFS_QP_HLFS_QID_HLFS_ZDRT_HLFS_ZDRDT
        S QRD=QRD_HLFS_QLR_HLFS_WHO_HLFS_WHAT_HLFS_WDDC_HLFS_WDCVQ_HLFS_QRL
        ;
        Q QRD
        ;
MFI()   ; master file identifier segment
        ;
        N ID,APP,EVENT,ENDT,EFFDT,RESP,MFI
        ;
        S ID="Z04"
        S APP="MFS"
        S EVENT="UPD"
        S ENDT=$$NOW^XLFDT
        S EFFDT=$$NOW^XLFDT
        S RESP="NE"
        S MFI=$$MFI^XUMFMFI(ID,APP,EVENT,ENDT,EFFDT,RESP)
        ;
        Q MFI
        ;
MFE(IEN)        ; master file entry segment
        ;
        N EVENT,MFN,EDT,CODE,MFE
        ;
        S EVENT="MUP"
        S MFN=""
        S EDT=$$HLDATE^HLFNC($$NOW^XLFDT)
        S CODE=$$CODESYS(IEN)
        S MFE=$$MFE^XUMFMFE(EVENT,MFN,EDT,CODE)
        ;
        Q MFE
        ;
ZIN(IEN,NODE,HLFS,HLCS) ; ZIN segment
        ;
        N IENS,NAME,STATE,STREET1,STREET2,CITY,ZIP,ST1,ST2,CITY1,STATE1,ZIP1
        N X,ARRAY,BILLNAME,NPIDT,TAX,TAXSTAT,TAXPC,CLIA,DMIS,MAMMO
        N STATUS,FACTYP,AGENCY,STANUM,OFFNAME,INACTIVE,VISN,PARENT,NPI,NPISTAT
        ;
        S IENS=IEN_","
        ;
        S:$G(HLFS)="" HLFS="^"
        S:$G(HLCS)="" HLCS="~"
        ;
        D GETS^DIQ(4,IENS,"*","","ARRAY")
        ;
        S NAME=ARRAY(4,IENS,.01)
        S STATE=ARRAY(4,IENS,.02)
        S STREET1=ARRAY(4,IENS,1.01)
        S STREET2=ARRAY(4,IENS,1.02)
        S CITY=ARRAY(4,IENS,1.03)
        S ZIP=ARRAY(4,IENS,1.04)
        S ST1=ARRAY(4,IENS,4.01)
        S ST2=ARRAY(4,IENS,4.02)
        S CITY1=ARRAY(4,IENS,4.03)
        S STATE1=ARRAY(4,IENS,4.04)
        S ZIP1=ARRAY(4,IENS,4.05)
        S STATUS=ARRAY(4,IENS,11)
        S FACTYP=ARRAY(4,IENS,13)
        S AGENCY=ARRAY(4,IENS,95)
        S STANUM=ARRAY(4,IENS,99)
        S OFFNAME=ARRAY(4,IENS,100)
        S INACTIVE=ARRAY(4,IENS,101)
        S BILLNAME=ARRAY(4,IENS,200)
        S VISN=$P($G(^DIC(4,+$P($G(^DIC(4,+IEN,7,1,0)),U,2),0)),U)
        S PARENT=$P($G(^DIC(4,+$P($G(^DIC(4,+IEN,7,2,0)),U,2),99)),U)
        S NPI=$$NPI^XUSNPI("Organization_ID",IEN)
        S:$P(NPI,U)="-1" NPI=""
        S NPIDT=$$HLDATE^HLFNC($P(NPI,U,2))
        S NPISTAT=$$UP^XLFSTR($P(NPI,U,3))
        S NPI=$P(NPI,U)
        S TAX=$$TAXORG^XUSTAX(IEN)
        S X=$P(TAX,U,2),TAX=$P(TAX,U)
        S:X X=$O(^DIC(4,IEN,"TAXONOMY","B",X,0))
        S X=$G(^DIC(4,+IEN,"TAXONOMY",+$G(X),0))
        S TAXPC=$S('X:"",$P(X,U,2)=1:"YES",1:"NO")
        S TAXSTAT=$S('X:"",$P(X,U,3)="A":"ACTIVE",1:"INACTIVE")
        S CLIA=$$ID^XUAF4("CLIA",IEN)
        S MAMMO=$$ID^XUAF4("MAMMO-ACR",IEN)
        S DMIS=$$ID^XUAF4("DMIS",IEN)
        ;
        S NODE="ZIN"_HLFS_NAME_HLFS_STANUM_HLFS_STATUS_HLFS_FACTYP_HLFS
        S NODE(1)=OFFNAME_HLFS_INACTIVE_HLFS_STATE_HLFS_VISN_HLFS_PARENT
        S NODE(1)=NODE(1)_HLFS_HLFS_HLFS_HLFS_HLFS
        S NODE(2)=STREET1_HLCS_STREET2_HLCS_CITY_HLCS_STATE_HLCS_ZIP_HLFS
        S NODE(3)=ST1_HLCS_ST2_HLCS_CITY1_HLCS_STATE1_HLCS_ZIP1_HLFS
        S NODE(4)=AGENCY_HLFS_NPI_HLFS_NPISTAT_HLFS_NPIDT_HLFS_TAX_HLFS
        S NODE(4)=NODE(4)_TAXSTAT_HLFS_TAXPC_HLFS
        S NODE(4)=NODE(4)_CLIA_HLFS_MAMMO_HLFS_DMIS_HLFS_BILLNAME
        ;
        Q
        ;
CODESYS(IEN)    ; coding system / id
        ;
        N X
        ;
        S X=$$STA^XUAF4(IEN) Q:X X_"~"_$P(^DIC(4,IEN,0),U)_"~VASTANUM"
        ;
        S X=$$ID^XUAF4("NPI",IEN) Q:X'="" X_"~"_$P(^DIC(4,IEN,0),U)_"~NPI"
        ;
        S X=$$ID^XUAF4("DMIS",IEN) Q:X'="" X_"~"_$P(^DIC(4,IEN,0),U)_"~DMIS"
        ;
        Q 0
        ;
