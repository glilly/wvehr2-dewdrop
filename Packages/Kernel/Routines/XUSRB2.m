XUSRB2 ;SFISC/RWF - RPC Broker Kernel Utilities. ;05/04/2004  16:12
 ;;8.0;KERNEL;**115,150,277,337**;Jul 10, 1995
 Q
 ;
DIVGET(RET,IEN) ;Get Division data
 ;IEN is userid (DUZ or username) for future use.
 N %,XUDIV
 S XUDIV=0,%=$$CHKDIV^XUS1(.XUDIV) ;Get users div.
 S:(%>0)&($P(%,U,2)'>0) DUZ(2)=+% ;Set users default div.
 S RET(0)=XUDIV ;RET(0) is number of divisions.
 I XUDIV S %=0 D  S RET(0)=XUDIV
 . ;RET(%) is divison array eg. ien;station name;station#
 . F  S %=$O(XUDIV(%)) Q:(%'>0)  S RET(%)=XUDIV(%)
 Q
DIVSET(RET,DIV) ;Set users Division
 S RET=0,DIV=$$FIND1^DIC(200.02,","_DUZ_",","MX",$G(DIV))
 Q:DIV'>0
 I '$D(^VA(200,DUZ,2,DIV,0)) Q
 S DUZ(2)=DIV,RET=1 ;1=set, 0=not set
 Q
 ;
USERINFO(RET) ;generic user information for seeding VistaUser object.
 ;Entry point for 'XUS GET USER INFO' RPC
 N %,XU1,XU5
 S RET(0)=DUZ
 F %=1:1:6 S RET(%)="unk"
 I DUZ'>0 S XWBSEC="User not fully sign-on" Q
 S XU1=^VA(200,DUZ,0),XU5=$G(^(5))
 S RET(1)=$P(XU1,"^") ;.01 User name.
 S RET(2)=$$NAME^XUSER(DUZ) ;Return standard name.
 S RET(3)=DUZ(2)_"^"_$$NS^XUAF4(DUZ(2))
 S %=+$P(XU1,U,9),RET(4)=$P($G(^DIC(3.1,%,0)),U) ;Title
 S %=+XU5,RET(5)=$P($G(^DIC(49,%,0)),U) ;Service/Section
 S RET(6)=$G(DUZ("LANG")) ;User language
 S RET(7)=DTIME ;Users DTIME
 S RET(8)=$$VPID^XUPS(DUZ) ;Return VPID
 Q
