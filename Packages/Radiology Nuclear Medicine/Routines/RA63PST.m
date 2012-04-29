RA63PST ;HIOFO/SWM-Post install ;4/11/2006  05:21
 ;;5.0;Radiology/Nuclear Medicine;**63,VOE**;Mar 16, 1998
 ;
 ; 2006 04 11 (WV/TOAD): fix null subscript error at
 ; RA63PST+15 during post-install of RA*5.0*63 when run
 ; in an account with no Radiology data.
 ;
 ; This is the post-install routine for patch RA*5.0*63
 ; It will loop thru the first record in file 79
 ; and insert "Y" for the new field, "IS THIS FOR HQ?" only if
 ; the SMTP address is "VHARADIOLOGYREPORTS@HQ.MED.VA.GOV"
 ;
 ; This routine may be deleted after RA*5.0*63 is installed.
 ;
 N RA1,RA2,RASTR,RAVAL,RAFDA,RAIEN
 S RATXT(1)=""
 S RATXT(2)="** File 79, RAD/NUC MED DIVISION,"
 S RATXT(3)="   new field ""OQP PERFORMANCE MGMT?"" "
 S RATXT(4)="   has been updated with data. **"
 S RA1=$O(^RA(79,0)),RA2=0,RAC=0
 I RA1 F  S RA2=$O(^RA(79,RA1,1,RA2)) Q:'RA2  D  ; added IF for VOE
 . S RAC=RAC+1 ;counter
 . S RASTR=$G(^RA(79,RA1,1,RA2,0)) Q:RASTR=""
 . S RAIEN=RA2_","_RA1_","
 . S RAVAL=$P(RASTR,"^"),RAVAL=$$UP^XLFSTR(RAVAL) ;smtp address all caps
 . I RAVAL="VHARADIOLOGYREPORTS@HQ.MED.VA.GOV" S RAFDA(79.0175,RAIEN,1)="Y"
 . E  S RAFDA(79.0175,RAIEN,1)="N"
 . D FILE^DIE("","RAFDA") K RAFDA,RAIEN
 . Q
 I RAC=0 S RATXT(4)="   has NO data because there are NO Outlook mail groups in this file."
 D MES^XPDUTL(.RATXT)
 Q
