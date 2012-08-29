%ZVEMRLX ;DJB,VRR**RTN VER - Xref ; 11/20/00 9:52pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 ;=======================[ INPUT TRANSFORM 1]=========================
KEY1 ;ROUTINE Field
 NEW KEY1,KEY2
 I X'?.1"%"1A.7AN KILL X Q  ;Check format of input
 Q:'$G(DA)
 S KEY1=X
 S KEY2=$P($G(^VEE(19200.112,DA,0)),U,2)
 D CHECK
 Q
 ;
KEY2 ;VERSION Field
 NEW KEY1,KEY2
 I X<1!(X>99999)!(X?1.N1"."1.E) KILL X Q  ;Check format of input
 Q:'$G(DA)
 S KEY1=$P($G(^VEE(19200.112,DA,0)),U,1)
 S KEY2=X
 D CHECK
 Q
 ;
CHECK ;Check for duplicate entry
 Q:KEY1']""!(KEY2']"")
 Q:'$D(^VEE(19200.112,"AKEY",KEY1,KEY2))
 ;
 NEW ENTRY
 S ENTRY=$O(^VEE(19200.112,"AKEY",KEY1,KEY2,""))
 Q:ENTRY']""
 Q:ENTRY=DA
 Q:'$D(^VEE(19200.112,ENTRY,0))
 KILL X
 Q
 ;========================[ SET "AKEY" XREF ]========================
SET1 ;ROUTINE Field
 NEW KEY1,KEY2
 Q:'$D(^VEE(19200.112,DA,0))
 S KEY1=X,KEY2=$P($G(^(0)),U,2)
 D XREFSET
 Q
 ;
SET2 ;VERSION Field
 NEW KEY1,KEY2
 Q:'$D(^VEE(19200.112,DA,0))
 S KEY1=$P($G(^(0)),U,1),KEY2=X
 D XREFSET
 Q
 ;
XREFSET ;Set xref on "Key" fields
 Q:KEY1']""!(KEY2']"")
 S ^VEE(19200.112,"AKEY",KEY1,KEY2,DA)=""
 Q
 ;========================[KILL "AKEY" XREF]=========================
KILL1 ;ROUTINE Field
 NEW KEY1,KEY2
 Q:'$D(^VEE(19200.112,DA,0))
 S KEY1=X,KEY2=$P($G(^(0)),U,2)
 D XREFKILL
 Q
 ;
KILL2 ;VERSION Field
 NEW KEY1,KEY2
 Q:'$D(^VEE(19200.112,DA,0))
 S KEY1=$P($G(^(0)),U,1),KEY2=X
 D XREFKILL
 Q
 ;
XREFKILL ;Kill "AKEY" xref
 Q:KEY1']""!(KEY2']"")
 KILL ^VEE(19200.112,"AKEY",KEY1,KEY2,DA)
 Q
 ;========================[KILL "UNIQ" XREF]=========================
KILLUNIQ ;Maintain xref of uniques. If an entry is deleted, reset xref to
 ;another entry.
 ;
 NEW IEN
 Q:'$D(^VEE(19200.112,"UNIQ",X,DA))
 KILL ^VEE(19200.112,"UNIQ",X)
 Q:'$D(^VEE(19200.112,"B",X))
 S IEN=$O(^VEE(19200.112,"B",X,""))
 Q:'IEN
 S ^VEE(19200.112,"UNIQ",X,IEN)=""
 Q
