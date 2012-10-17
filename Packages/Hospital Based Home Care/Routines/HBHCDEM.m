HBHCDEM ; LR VAMC(IRMS)/MJT-HBHC Medical Foster Home (MFH) demographic data entry ; 0208
        ;;1.0;HOSPITAL BASED HOME CARE;**24**;NOV 01, 1993;Build 201
START   ; Initialization
        S HBHCFORM=7
PROMPT  ; Prompt user for Medical Foster Home (MFH) name
        K DIC,HBHCPRCT S DIC="^HBHC(633.2,",DIC(0)="AELMQZ" D ^DIC
        G:Y=-1 EXIT
        S HBHCDFN=+Y,HBHCXMT7=$P($G(^HBHC(633.2,HBHCDFN,12)),U)
        I (HBHCXMT7]"")&(HBHCXMT7'="N") D FORMMSG^HBHCUTL1 G:$D(HBHCNHSP) EXIT G:HBHCPRCT'=1 PROMPT
        I $P(Y,U,3) S $P(^HBHC(633.2,HBHCDFN,12),U)="N",^HBHC(633.2,"AC","N",HBHCDFN)=""
        K DIE S DIE="^HBHC(633.2,",DA=HBHCDFN,DR="[HBHC MFH DEMOGRAPHIC INPUT]"
        L +^HBHC(633.2,HBHCDFN):0 I $T D ^DIE L -^HBHC(633.2,HBHCDFN) W !! G PROMPT
        W $C(7),!!,"Another user is editing this entry.",!! G PROMPT
EXIT    ; Exit module
        K DA,DIC,DIE,DR,HBHCDFN,HBHCFORM,HBHCNHSP,HBHCPRCT,HBHCXMT7,X,Y
        Q
