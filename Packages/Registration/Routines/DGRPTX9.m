DGRPTX9 ; ;08/31/12
 S X=DE(7),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(7),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(7),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".132;" D AVAFC^VAFCDD01(DA)
 S X=DE(7),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(7),DIIX=2_U_DIFLD D AUDIT^DIET
