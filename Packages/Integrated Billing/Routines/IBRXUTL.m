IBRXUTL ;ALB/MAF - PHARMACY API CALLS ;1/9/08  14:45
        ;;2.0;INTEGRATED BILLING;**309,347,383**;21-MAR-94;Build 11
        ;
ZERO(IBDRV)     ;
        N X
        K ^TMP($J,"IBDRUG")
        S X="IBDRUG" D ZERO^PSS50(IBDRV,,,,,X)
        Q
DATA(IBDRV)     ;
        N X
        K ^TMP($J,"IBDRUG")
        S X="IBDRUG" D DATA^PSS50(IBDRV,,,,,X)
        Q
FILE(DA,DR,INTEXT)      ;Returns single field from file 52
        N RETURN,PSOFILE
        I '$G(DA) S RETURN="" Q RETURN
        I '$G(DR) S RETURN="" Q RETURN
        S PSOFILE=52
        S DA=+DA
        I $G(INTEXT)="" S INTEXT="I"
        S RETURN=$$GET1^PSODI(PSOFILE,DA,DR,INTEXT)
        I $P($G(RETURN),"^",1)=0 S RETURN="" Q RETURN
        Q $P(RETURN,"^",2)
SUBFILE(DA,DASUB,DR,DRSUB,INTEXT)       ;Returns single field from subfile 52.1
        ;The DR variable isn't being used because Pharmacy API changed after IB*2.0*347 went
        ;to test site. Rather than changing all the routines that call this API this
        ;input variable is now not used.
        N RETSUB,PSOFILE,IENS
        I '$G(DA) S RETSUB="" Q RETSUB
        I '$G(DASUB) S RETSUB="" Q RETSUB
        I '$G(DRSUB) S RETSUB="" Q RETSUB
        S PSOFILE=52.1
        S IENS=+DASUB_","_+DA
        I $G(INTEXT)="" S INTEXT="I"
        S RETSUB=$$GET1^PSODI(PSOFILE,IENS,DRSUB,INTEXT)
        I $P($G(RETSUB),"^",1)=0 S RETSUB="" Q RETSUB
        Q $P(RETSUB,"^",2)
RXZERO(PDFN,RXIEN)      ;Returns zero node of file 52
        N ZEROOUT,LIST,IBTMPARR,NODE
        I '$G(PDFN) S ZEROOUT="" Q ZEROOUT
        I '$G(RXIEN) S ZEROOUT="" Q ZEROOUT
        S NODE=0
        S LIST="IBZEROARR"
        S IBTMPARR="IBTMPZERO"
        D RX^PSO52API(PDFN,LIST,RXIEN,,NODE,,)
        I $P(^TMP($J,LIST,PDFN,0),"^",1)>0  D
        .S $P(^TMP($J,IBTMPARR),"^",1)=$G(^TMP($J,LIST,PDFN,RXIEN,.01))
        .S $P(^TMP($J,IBTMPARR),"^",2)=$P($G(^TMP($J,LIST,PDFN,RXIEN,2)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",3)=$P($G(^TMP($J,LIST,PDFN,RXIEN,3)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",4)=$P($G(^TMP($J,LIST,PDFN,RXIEN,4)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",5)=$P($G(^TMP($J,LIST,PDFN,RXIEN,5)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",6)=$P($G(^TMP($J,LIST,PDFN,RXIEN,6)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",7)=$G(^TMP($J,LIST,PDFN,RXIEN,7))
        .S $P(^TMP($J,IBTMPARR),"^",8)=$G(^TMP($J,LIST,PDFN,RXIEN,8))
        .S $P(^TMP($J,IBTMPARR),"^",9)=$G(^TMP($J,LIST,PDFN,RXIEN,9))
        .S $P(^TMP($J,IBTMPARR),"^",10)=""
        .S $P(^TMP($J,IBTMPARR),"^",11)=$P($G(^TMP($J,LIST,PDFN,RXIEN,11)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",12)=""
        .S $P(^TMP($J,IBTMPARR),"^",13)=$P($G(^TMP($J,LIST,PDFN,RXIEN,1)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",14)=""
        .S $P(^TMP($J,IBTMPARR),"^",15)=""
        .S $P(^TMP($J,IBTMPARR),"^",16)=$P($G(^TMP($J,LIST,PDFN,RXIEN,16)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",17)=$G(^TMP($J,LIST,PDFN,RXIEN,17))
        .S $P(^TMP($J,IBTMPARR),"^",18)=$G(^TMP($J,LIST,PDFN,RXIEN,10.6))
        .S $P(^TMP($J,IBTMPARR),"^",19)=$P($G(^TMP($J,LIST,PDFN,RXIEN,10.3)),"^",1)
        .S ZEROOUT=^TMP($J,IBTMPARR)
        .K ^TMP($J,IBTMPARR)
        E  S ZEROOUT=""
        K ^TMP($J,LIST)
        Q ZEROOUT
RXSEC(PDFN,RXIEN)       ;Returns second node of file 52
        N SECOUT,LIST,IBTMPARR,NODE
        I '$G(PDFN) S SECOUT="" Q SECOUT
        I '$G(RXIEN) S SECOUT="" Q SECOUT
        S NODE=2
        S LIST="IBSECARR"
        S IBTMPARR="IBTMPSEC"
        D RX^PSO52API(PDFN,LIST,RXIEN,,NODE,,)
        I $P(^TMP($J,LIST,PDFN,0),"^",1)>0  D
        .S $P(^TMP($J,IBTMPARR),"^",1)=$P($G(^TMP($J,LIST,PDFN,RXIEN,21)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",2)=$P($G(^TMP($J,LIST,PDFN,RXIEN,22)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",3)=$P($G(^TMP($J,LIST,PDFN,RXIEN,23)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",4)=$G(^TMP($J,LIST,PDFN,RXIEN,24))
        .S $P(^TMP($J,IBTMPARR),"^",5)=$P($G(^TMP($J,LIST,PDFN,RXIEN,25)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",6)=$P($G(^TMP($J,LIST,PDFN,RXIEN,26)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",7)=$G(^TMP($J,LIST,PDFN,RXIEN,27))
        .S $P(^TMP($J,IBTMPARR),"^",8)=$G(^TMP($J,LIST,PDFN,RXIEN,28))
        .S $P(^TMP($J,IBTMPARR),"^",9)=$P($G(^TMP($J,LIST,PDFN,RXIEN,20)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",10)=$P($G(^TMP($J,LIST,PDFN,RXIEN,104)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",11)=$P($G(^TMP($J,LIST,PDFN,RXIEN,29)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",12)=$G(^TMP($J,LIST,PDFN,RXIEN,30))
        .S $P(^TMP($J,IBTMPARR),"^",13)=$P($G(^TMP($J,LIST,PDFN,RXIEN,31)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",14)=$P($G(^TMP($J,LIST,PDFN,RXIEN,32.2)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",15)=$P($G(^TMP($J,LIST,PDFN,RXIEN,32.1)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",16)=$G(^TMP($J,LIST,PDFN,RXIEN,32.3))
        .S SECOUT=^TMP($J,IBTMPARR)
        .K ^TMP($J,IBTMPARR)
        E  S SECOUT=""
        K ^TMP($J,LIST)
        Q SECOUT
RX3(PDFN,RXIEN) ;Returns third node of file 52
        N THRDOUT,LIST,IBTMPARR,NODE
        I '$G(PDFN) S THRDOUT="" Q THRDOUT
        I '$G(RXIEN) S THRDOUT="" Q THRDOUT
        S NODE=3
        S LIST="IBARRTHRD"
        S IBTMPARR="IBTMP3"
        D RX^PSO52API(PDFN,LIST,RXIEN,,NODE,,)
        I $P(^TMP($J,LIST,PDFN,0),"^",1)>0  D
        .S $P(^TMP($J,IBTMPARR),"^",1)=$P($G(^TMP($J,LIST,PDFN,RXIEN,101)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",2)=$P($G(^TMP($J,LIST,PDFN,RXIEN,102)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",3)=$P($G(^TMP($J,LIST,PDFN,RXIEN,109)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",4)=$P($G(^TMP($J,LIST,PDFN,RXIEN,102.1)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",5)=$P($G(^TMP($J,LIST,PDFN,RXIEN,26.1)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",6)=$P($G(^TMP($J,LIST,PDFN,RXIEN,34.1)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",7)=$G(^TMP($J,LIST,PDFN,RXIEN,12))
        .S $P(^TMP($J,IBTMPARR),"^",8)=$G(^TMP($J,LIST,PDFN,RXIEN,102.2))
        .S $P(^TMP($J,IBTMPARR),"^",9)=$G(^TMP($J,LIST,PDFN,RXIEN,112))
        .S THRDOUT=^TMP($J,IBTMPARR)
        .K ^TMP($J,IBTMPARR)
        E  S THRDOUT=""
        K ^TMP($J,LIST)
        Q THRDOUT
ZEROSUB(PDFN,RXIEN,RXSUB)       ;Returns zero node of subfile 52.1
        N ZSUBOUT,LIST,IBTMPARR,NODE
        I '$G(PDFN) S ZSUBOUT="" Q ZSUBOUT
        I '$G(RXIEN) S ZSUBOUT="" Q ZSUBOUT
        I '$G(RXSUB) S ZSUBOUT="" Q ZSUBOUT
        S NODE="R^^"_RXSUB
        S LIST="IBSUBARR"
        S IBTMPARR="IBTMPSUB"
        D RX^PSO52API(PDFN,LIST,RXIEN,,NODE,,)
        I $P(^TMP($J,LIST,PDFN,RXIEN,"RF",0),"^",1)>0  D
        .S $P(^TMP($J,IBTMPARR),"^",1)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,.01)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",2)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,2)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",3)=$G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,3))
        .S $P(^TMP($J,IBTMPARR),"^",4)=$G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,1))
        .S $P(^TMP($J,IBTMPARR),"^",5)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,4)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",6)=$G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,5))
        .S $P(^TMP($J,IBTMPARR),"^",7)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,6)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",8)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,7)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",9)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,8)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",10)=$G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,1.1))
        .S $P(^TMP($J,IBTMPARR),"^",11)=$G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,1.2))
        .S $P(^TMP($J,IBTMPARR),"^",12)=""
        .S $P(^TMP($J,IBTMPARR),"^",13)=""
        .S $P(^TMP($J,IBTMPARR),"^",14)=$G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,12))
        .S $P(^TMP($J,IBTMPARR),"^",15)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,13)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",16)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,14)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",17)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,15)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",18)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,17)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",19)=$P($G(^TMP($J,LIST,PDFN,RXIEN,"RF",RXSUB,10.1)),"^",1)
        .S ZSUBOUT=^TMP($J,IBTMPARR)
        .K ^TMP($J,IBTMPARR)
        E  S ZSUBOUT=""
        K ^TMP($J,LIST)
        Q ZSUBOUT
RFNUM(RXIEN)    ;
        N PDFN,RXSUB,LIST,IBTMPARR,NODE
        I '$G(RXIEN) S RXSUB="" Q RXSUB
        S PDFN=$$FILE^IBRXUTL(RXIEN,2)
        S LIST="IBRFNARR"
        S IBTMPARR="IBTMPRFN"
        S NODE="R"
        D RX^PSO52API(PDFN,LIST,RXIEN,,NODE,,)
        I $P(^TMP($J,LIST,PDFN,RXIEN,"RF",0),"^",1)>0  D
        .S RXSUB=^TMP($J,LIST,PDFN,RXIEN,"RF",0)
        E  S RXSUB=""
        K ^TMP($J,LIST)
        Q RXSUB
IBND(DFN,RXIEN) ;Returns IB node
        N IBNDOUT,LIST,NODE,IBTMPARR
        I '$G(DFN) S IBNDOUT="" Q IBNDOUT
        I '$G(RXIEN) S IBNDOUT="" Q IBNDOUT
        S LIST="IBIBNDARR"
        S NODE="I^O"
        S IBTMPARR="IBTMPIBND"
        D RX^PSO52API(DFN,LIST,RXIEN,,NODE,,)
        I $P(^TMP($J,LIST,DFN,0),"^",1)>0  D
        .S $P(^TMP($J,IBTMPARR),"^",1)=$P($G(^TMP($J,LIST,DFN,RXIEN,105)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",2)=$P($G(^TMP($J,LIST,DFN,RXIEN,106)),"^",1)
        .S $P(^TMP($J,IBTMPARR),"^",3)=$G(^TMP($J,LIST,DFN,RXIEN,106.5))
        .S $P(^TMP($J,IBTMPARR),"^",4)=$G(^TMP($J,LIST,DFN,RXIEN,106.6))
        .S IBNDOUT=^TMP($J,IBTMPARR)
        .S:IBNDOUT="^^^" IBNDOUT=""
        .K ^TMP($J,IBTMPARR)
        E  S IBNDOUT=""
        K ^TMP($J,LIST)
        Q IBNDOUT
IBNDFL(DFN,RXIEN,RXRFL) ;
        N IBNDFL,LIST,NODE,IBTMPARR
        I '$G(DFN) S IBNDFL="" Q IBNDFL
        I '$G(RXIEN) S IBNDFL="" Q IBNDFL
        I '$G(RXRFL) S IBNDFL="" Q IBNDFL
        S LIST="IBIBNDFLARR"
        S NODE="I^R^"_RXRFL
        S IBTMPARR="IBTMPIBNDFL"
        D RX^PSO52API(DFN,LIST,RXIEN,,NODE,,)
        I ^TMP($J,LIST,DFN,RXIEN,"IB",0)>0  D
        .S $P(^TMP($J,IBTMPARR),"^",1)=$G(^TMP($J,LIST,DFN,RXIEN,"IB",RXRFL,9))
        .S $P(^TMP($J,IBTMPARR),"^",2)=$G(^TMP($J,LIST,DFN,RXIEN,"IB",RXRFL,9.1))
        .S IBNDFL=^TMP($J,IBTMPARR)
        .K ^TMP($J,IBTMPARR)
        E  S IBNDFL=""
        K ^TMP($J,LIST)
        Q IBNDFL
        ;
RFLNUM(IBRXN,FLDT,IBFLG)        ; find the refill number in file 52 for the given date
        N NUMOUT,NUM,DFN,LIST,NODE
        I '$G(IBRXN) S NUMOUT="" Q NUMOUT
        I '$G(FLDT) S NUMOUT="" Q NUMOUT
        S LIST="IBRTMP"
        K ^TMP($J,LIST)
        S NUM=0
        S DFN=$$FILE(IBRXN,2)
        S NODE="R^^"
        D RX^PSO52API(DFN,LIST,IBRXN,,NODE,,)
        F  S NUM=$O(^TMP($J,LIST,DFN,IBRXN,"RF",NUM)) Q:'NUM  D
        .I $P(^TMP($J,LIST,DFN,IBRXN,"RF",NUM,.01),"^",1)=FLDT S NUMOUT=NUM
        K ^TMP($J,LIST)
        S:'$G(NUMOUT) NUMOUT=""
        Q NUMOUT
