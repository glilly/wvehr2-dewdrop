IBCNEUT2 ;DAOU/DAC - IIV MISC. UTILITIES ;06-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; Can't be called from the top
 Q
 ;
SAVETQ(IEN,TDT) ;  Update service date in TQ record
 ;
 N DIE,DA,DR,D,D0,DI,DIC,DQ,X
 S DIE="^IBCN(365.1,",DA=IEN,DR=".12////"_TDT
 D ^DIE
 Q
 ;
 ;
SST(IEN,STAT) ;  Set the Transmission Queue Status
 ;  Input parameters
 ;    IEN = Internal entry number for the record
 ;    STAT= Status IEN
 ;
 NEW DIE,DA,DR,D,D0,DI,DIC,DQ,X
 ;
 I IEN="" Q
 ;
 S DIE="^IBCN(365.1,",DA=IEN,DR=".04////^S X=STAT;.15////^S X=$$NOW^XLFDT()"
 D ^DIE
 Q
 ;
RSP(IEN,STAT) ;  Set the Response File Status
 ;  Input parameters
 ;    IEN = Internal entry number for the record
 ;    STAT= Status IEN
 ;
 NEW DIE,DA,DR,D,D0,DI,DIC,DQ,X
 S DIE="^IBCN(365,",DA=IEN,DR=".06////^S X=STAT"
 D ^DIE
 Q
 ;
BUFF(BUFF,BNG) ;  Set error symbol into Buffer File
 ;  Input Parameter
 ;    BUFF = Buffer internal entry number
 ;    BNG = Buffer Symbol IEN
 I 'BUFF!'BNG Q
 NEW DIE,DA,DR,D,D0,DI,DIC,DQ,X,DISYS
 S DIE="^IBA(355.33,",DA=BUFF,DR=".12////^S X=BNG"
 D ^DIE
 Q
 ;
PAYR ;  Set up the '~NO PAYER' payer.  This procedure is called by both
 ;  the post-install routine and by the nightly batch extract routine.
 S DLAYGO=365.12,DIC(0)="L",DIC("P")=DLAYGO,DIC="^IBE(365.12,"
 S X="~NO PAYER" D ^DIC
 S DA=+Y
 S DR=".02////^S X=""00000""",DIE=DIC D ^DIE
 ;
 ;  Set up Payer Application with active flags (if needed)
 ;S IDUZ=$$FIND1^DIC(200,"","X","INTERFACE,IB IIV")
 ;I '$D(^IBE(365.12,DA,1,0)) S ^IBE(365.12,DA,1,0)="^365.121P^^"
 ;S DLAYGO=365.121,DIC(0)="L",DIC("P")=DLAYGO,DA(1)=DA
 ;S DIC="^IBE(365.12,"_DA(1)_",1,"
 ;S X="IIV" D ^DIC
 ;S DA=+Y
 ;S DIE=DIC,DR=".02////1;.03////1;.05////^S X=$$NOW^XLFDT();.06////^S X=$$NOW^XLFDT()"
 ;S DR=DR_";.04////^S X=IDUZ" D ^DIE
 ;
 K DA,DIC,DLAYGO,X,Y,D1,DILN,DISYS,IDUZ,DIE,DR,D0,D,DI,DIERR,DQ
 Q
 ;
