AUPNLKZ ; IHS/CMI/LAB - SET AND RESET DUZ(2) ;1/29/07  09:06
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
 ;  This routine is called to save DUZ(2) and set it to
 ;  zero, then restore DUZ(2) to its original value.  The
 ;  calls must be made to the two entry points and it makes
 ;  no sense to call RESET unless SET was previously called.
 ;
 ;  If SET is called and DUZ(2) does not exists this
 ;  routine will abort.
 ;
 Q  ; Invalid entry point
 ;
SET ;EP - SAVE DUZ(2) AND SET TO ZERO
 S:'($D(AUPNDUZ)#2) AUPNDUZ=0
 S AUPNDUZ=AUPNDUZ+1
 S AUPNDUZ(AUPNDUZ)=DUZ(2)
 S DUZ(2)=0
 Q
 ;
RESET ;EP - RESTORE DUZ(2)
 Q:'($D(AUPNDUZ)#2)
 S DUZ(2)=AUPNDUZ(AUPNDUZ)
 K AUPNDUZ(AUPNDUZ)
 S AUPNDUZ=AUPNDUZ-1
 K:'AUPNDUZ AUPNDUZ
 Q
