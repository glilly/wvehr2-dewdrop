DVBAXA2 ; ;09/24/12
 S X=DG(DQ),DIC=DIE
 S DFN=DA D EN^DGMTCOR K DGMTCOR
 S X=DG(DQ),DIC=DIE
 S DFN=DA D EN^DGRP7CC
 S X=DG(DQ),DIC=DIE
 X ^DD(2,1901,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.3)):^(.3),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X="N" X ^DD(2,1901,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="1901;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(12))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
