DGRPTX16 ; ;08/31/12
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".219;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(16))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
