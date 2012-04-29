XOBVPRE ;; mjk/alb - VistaLimk Pre-Init ; 07/27/2002  13:00
 ;;1.5;VistALink;;Sep 09, 2005
 ;;Foundations Toolbox Release v1.5 [Build: 1.5.0.026]
 ;
 QUIT
 ;
EN ; -- add pre-init code here
 ; -- delete VISTALINK MESSAGE TYPE file (18.05)
 DO DEL(18.05)
 ;
 QUIT
 ;
DEL(XOBFILE) ; -- delete file
 NEW DIU,XOBRES
 ;
 DO FILE^DID(XOBFILE,"","NAME","XOBRES")
 ;
 ; -- if file present then delete
 IF $GET(XOBRES("NAME"))'="" DO
 . ; -- delete security provider file
 . SET DIU=XOBFILE,DIU(0)="TD" DO EN^DIU2
 ;
 QUIT
 ;
