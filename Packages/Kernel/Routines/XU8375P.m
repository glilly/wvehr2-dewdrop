XU8375P ;;BPOIFO/DW - Post-init for XU*8*375 ; 14 April 2004
 ;;8.0;KERNEL;**375**; Jul 10, 1995;
 ;
 ;Update the DD
 D UPDATE
 ;
 ;Recompile input templates
 D RECOMP
 ;
 ;Update triggered fields
 D TRIG
 Q
 ;
UPDATE ;Update DD of the SIGNATURE BLOCK PRINTED NAME field
 S $P(^DD(200,20.2,0),U,5,999)="K:X[""""""""!($A(X)=45)!($L(X)>40)!($L(X)<2) X I $D(X) K:$$FORMAT^XLFNAME7(X,2,40,,0,,1)'[$P(^VA(200,DA,0),"","") X"
 Q
 ;
RECOMP ;Recompile input templates
 D BMES^XPDUTL("Recompiling templates...")
 ;
 N XUFLD
 S XUFLD(200,20.2)=""
 D DIEZ^DIKCUTL3(200,.XUFLD)
 ;
 Q
 ;
TRIG ;Update triggered fields
 D BMES^XPDUTL("Updating trigger field definitions...")
 ;
 N XUFLD,XUOUT
 S XUFLD(200,20.2)=""
 D TRIG^DICR(.XUFLD,.XUOUT)
 ;
 N XUFL,XUFD
 S XUFL=0 F  S XUFL=$O(XUOUT(XUFL)) Q:'XUFL  D
 . S XUFD=0 F  S XUFD=$O(XUOUT(XUFL,XUFD)) Q:'XUFD  D
 .. D MES^XPDUTL("         Field #"_XUFD_" of file #"_XUFL_" updated.")
 ;
 Q
 ;
