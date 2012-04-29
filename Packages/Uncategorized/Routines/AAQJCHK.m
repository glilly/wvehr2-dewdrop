AAQJCHK ;FGO/JHS-Check/Warning for Test Account ; 12/6/05 3:01am
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 D UCI^%ZOSV S AAQUCI=$P(Y,",",1)
 ;;I AAQUCI="VAH" K AAQUCI Q  ;Quit if in Production
 I AAQUCI="EHR" K AAQUCI Q  ;Quit if in Production
 W !!,$C(7),"You are not in the Production Account.  You are in "_AAQUCI_".",!,"Actual Patch Record Editing should be done only in the Production account."
 W !,"If you are only testing with Patch Record editing, you may continue."
ASKCONT S %=2 W !!,"Are you using test data in the Patch Record" D YN^DICN D:%=2 WARN I %=0 D WARN G ASKCONT
 I %=-1 D WARN G EXIT
 G EXIT
WARN W !!,"If you are entering actual data, please Halt and use the Production Account.",!,"Answer YES, if you are only testing."
 R !!,"Press RETURN to Continue.",X:DTIME
 Q
EXIT K %,AAQUCI,X,Y Q
