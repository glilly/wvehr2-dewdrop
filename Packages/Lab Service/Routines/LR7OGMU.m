LR7OGMU ;SLC/STAFF- Interim report rpc memo utility ;7/1/09  07:25
        ;;5.2;LAB SERVICE;**187,312,395**;Sep 27, 1994;Build 27
        ;
NEWOLD(Y,DFN)   ; from ORWLRR
        N LRDFN
        D DEMO^LR7OGU(DFN,.LRDFN)
        S Y=$$NEWEST(LRDFN)_U_$$OLDEST(LRDFN)
        Q
        ;
NEWEST(LRDFN)   ;
        N IDT,FIRSTCH,FIRSTMI,LRCAN,ZERO,UID,AREA,ACDT,NUM,TESTNUM,CHKTYP,ANODE,ACOMP,GOTNP
        S (FIRSTCH,FIRSTMI)=""
        S IDT=0
        F  S IDT=$O(^LR(LRDFN,"CH",IDT)) Q:IDT<1  S ZERO=^(IDT,0),UID=$P($G(^("ORU")),"^") D  Q:FIRSTCH
        . I $P(ZERO,U,3) S FIRSTCH=9999999-IDT Q
        . I UID'="" S UID=$$CHECKUID^LRWU4(UID) Q:'UID
        . I 'UID,'$P(ZERO,"^",3) Q
        . S GOTNP=0 D GETNP^LR7OGMC Q:GOTNP
        . S AREA=$P(UID,"^",2),ACDT=$P(UID,"^",3),NUM=$P(UID,"^",4)
        . I '$D(^LRO(68,+AREA,1,+ACDT,1,+NUM)) Q
        . S TESTNUM=0,CHKTYP=0,ACOMP=0
        . F  S TESTNUM=$O(^LRO(68,+AREA,1,+ACDT,1,+NUM,4,TESTNUM)) Q:'TESTNUM  S ANODE=^(TESTNUM,0) D
        .. Q:'$D(^LAB(60,TESTNUM,0))  I ("BO"[$P($G(^(0)),U,3)) S CHKTYP=1
        .. I '$P(ANODE,"^",5) S ACOMP=1
        . Q:'CHKTYP
        . Q:'ACOMP
        . S FIRSTCH=9999999-IDT
        . Q
        S IDT=$O(^LR(LRDFN,"MI",0)) I IDT>0  S FIRSTMI=9999999-IDT
        I FIRSTCH>FIRSTMI Q FIRSTCH
        I FIRSTCH'>FIRSTMI Q FIRSTMI
        Q ""
        ;
OLDEST(LRDFN)   ;
        N IDT,FIRSTCH,FIRSTMI,LRCAN,ZERO,UID,AREA,ACDT,NUM,TESTNUM,CHKTYP,ANODE,ACOMP,GOTNP
        S (FIRSTCH,FIRSTMI)=""
        S IDT=""
        F  S IDT=$O(^LR(LRDFN,"CH",IDT),-1) Q:IDT<1  S ZERO=^(IDT,0),UID=$P($G(^("ORU")),"^") D  Q:FIRSTCH
        . I $P(ZERO,U,3) S FIRSTCH=9999999-IDT Q
        . I UID'="" S UID=$$CHECKUID^LRWU4(UID)
        . I 'UID,'$P(ZERO,"^",3) Q
        . S GOTNP=0 D GETNP^LR7OGMC Q:GOTNP
        . S AREA=$P(UID,"^",2),ACDT=$P(UID,"^",3),NUM=$P(UID,"^",4)
        . I '$D(^LRO(68,+AREA,1,+ACDT,1,+NUM)) Q
        . S TESTNUM=0,CHKTYP=0,ACOMP=0
        . F  S TESTNUM=$O(^LRO(68,+AREA,1,+ACDT,1,+NUM,4,TESTNUM)) Q:'TESTNUM  S ANODE=^(TESTNUM,0) D
        .. Q:'$D(^LAB(60,TESTNUM,0))  I ("BO"[$P($G(^(0)),U,3)) S CHKTYP=1
        .. I '$P(ANODE,"^",5) S ACOMP=1
        . Q:'CHKTYP
        . Q:'ACOMP
        . S FIRSTCH=9999999-IDT
        . Q
        S IDT=$O(^LR(LRDFN,"MI",""),-1) I IDT>0  S FIRSTMI=9999999-IDT
        I FIRSTMI="" Q FIRSTCH
        I FIRSTCH="" Q FIRSTMI
        I FIRSTCH<FIRSTMI Q FIRSTCH
        I FIRSTCH'<FIRSTMI Q FIRSTMI
        Q ""
