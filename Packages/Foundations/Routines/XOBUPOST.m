XOBUPOST ;; ld,mjk/alb - Foundations Post-Init ; 07/27/2002  13:00
 ;;1.5;Foundations;;Sep 09, 2005
 ;;Foundations Toolbox Release v1.5 [Build: 1.5.0.026]
 ;
 QUIT
 ;
EN ; -- add post-init code here
 DO PARMS
 QUIT
 ;
 ;
PARMS ; -- add parameter entry
 NEW DIC,X,Y,DIE,DA,DR,XOBBOX,XOBDA,XOBMULI,XOBNEW
 ;
 ; -- box-pair name, no ien
 SET XOBBOX=$PIECE($$GETENV(),U,4)
 ;
 ; -- Top-Level Parameters --
 SET DIC="^XOB(18.01,",DIC(0)="LX",X=$$DOMAIN() DO ^DIC
 ;
 QUIT
 ;
 ;
DOMAIN() ; -- get account's domain entry
 ;
 QUIT $$KSP^XUPARAM("WHERE")
 ;
 ;
GETENV() ; -- get environment variable
 ;-- Get environment of current system i.e. Y=UCI^VOL/DIR^NODE^BOX LOOKUP
 NEW Y
 DO GETENV^%ZOSV
 QUIT Y
 ;
