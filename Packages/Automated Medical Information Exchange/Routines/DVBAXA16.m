DVBAXA16 ; ;08/31/12
 S X=DE(5),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(5),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(5),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".131;" D AVAFC^VAFCDD01(DA)
 S X=DE(5),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(5),DIC=DIE
 X "N % S %=$E($TR(X,""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+[]{}<>,./?:;'\|""),1,30) K:%'="""" ^DPT(""AZVWVOE"",%,DA)"
 S X=DE(5),DIIX=2_U_DIFLD D AUDIT^DIET
