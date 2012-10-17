ONCPCDX ;Hines OIFO/GWB - Postal Code INPUT/OUTPUT TRANSFORMS ;06/23/10
        ;;2.11;ONCOLOGY;**51**;Mar 07, 1995;Build 65
        ;
PCDX    ;POSTAL CODE AT DX (165.5,9) INPUT TRANSFORM
        N DIC,ONCXIP,Y
        I (X=88888)!(X=99999)!(X=999999) Q
        I X?1A1N1A1N1A1N Q
        S DIC="^XIP(5.12,",DIC(0)="EMZ"
        S DIC("B")=$P(^ONCO(165.5,DA,1),U,2)
        D ^DIC
        I Y=-1 D EN^DDIOL("  Invalid postal code") K X Q
        S X=$P(Y(0),U,1)
        D POSTAL^XIPUTIL(X,.ONCXIP)
        S ONCCITY=$P(Y(0),U,2)
        S ONCSTATE=$P(Y(0),U,4)
        S ONCCOUNTY=ONCXIP("FIPS CODE")
        Q
        ;Code for POSTALB^XIPUTIL API if needed
        ;S SUB=$O(ZIP(""),-1)
        ;I SUB=1 W " "_ZIP(1,"CITY")_" "_$P($G(^DIC(5,ZIP(1,"STATE POINTER"),0)),U,2)_" "_ZIP(1,"COUNTY") S Y=1 G SET
        ;W !
        ;S DIR(0)="SAO^"
        ;S SUB=0 F  S SUB=$O(ZIP(SUB)) Q:SUB'>0  D
        ;.S CHOICE=ZIP(SUB,"POSTAL CODE")_" "_ZIP(SUB,"CITY")_" "_$P($G(^DIC(5,ZIP(SUB,"STATE POINTER"),0)),U,2)_" "_ZIP(SUB,"COUNTY")
        ;.S DIR(0)=DIR(0)_SUB_":"_CHOICE_";"
        ;.W !,?5,SUB," ",CHOICE
        ;W ! S DIR("A")=" Select Postal Code: "
        ;D ^DIR
        ;I $D(DIRUT) K DIRUT K ZIP Q
        ;I Y<1 K ZIP Q
        ;
PC1601  ;POSTAL CODE (160.1,.03) INPUT TRANSFORM
        N DIC,Y
        S DIC="^XIP(5.12,",DIC(0)="EMZ"
        S DIC("B")=$P(^ONCO(160.1,DA,0),U,3)
        D ^DIC
        I Y=-1 D EN^DDIOL("  Invalid postal code") K X Q
        S X=$P(Y(0),U,1)
        S ONCCITY=$P(Y(0),U,2)
        S ONCSTATE=$P(Y(0),U,4)
        Q
        ;
PC165I  ;ZIP CODE (165,.119) INPUT TRANSFORM
        N DIC,Y
        S DIC="^XIP(5.12,",DIC(0)="EMZ"
        S DIC("B")=$P($G(^ONCO(165,DA,.11)),U,9)
        D ^DIC
        I Y=-1 D EN^DDIOL("  Invalid postal code") K X Q
        S X=$P(Y(0),U,1)
        S ONCCITY=$P(Y(0),U,2)
        S ONCSTATE=$P(Y(0),U,4)
        Q
        ;
PC165O  ;ZIP CODE (165,.119) OUTPUT TRANSFORM
        N CITY,STATE,STATEPNT,ZIP
        S CITY=$P($G(^ONCO(165,D0,.11)),U,4)
        S STATEPNT=$P($G(^ONCO(165,D0,.11)),U,5)
        S STATE="" S:STATEPNT'="" STATE=$$GET1^DIQ(5,STATEPNT,1)
        S ZIP=$P($G(^ONCO(165,D0,.11)),U,9)
        S:ZIP'="" Y=CITY_", "_STATE_" "_ZIP
        Q
        ;
CLEANUP ;Cleanup
        K D0,DA
