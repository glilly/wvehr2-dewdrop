YS97POST        ;ASF/ALB- YS*5.01*97 POST-INIT ; 8/28/08 9:27am
        ;;5.01;MENTAL HEALTH;**97**;Dec 30, 1994;Build 42
        Q
HL7     ;
        N DA,DIC,DIE,X,Y,DR
        ;app param
        S DIC=771,X="YS MHA",DIC(0)="M" D ^DIC Q:Y'>0
        S DA=+Y,DIE=771,DR="2///A" D ^DIE
        ;logical link
        S DIC=870,X="YS MHAT",DIC(0)="M" D ^DIC Q:Y'>0
        S DA=+Y,DIE=870,DR="200.02///5;400.01///10.37.1.53;400.02///5000" D ^DIE
        Q
