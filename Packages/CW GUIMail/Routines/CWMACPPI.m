CWMACPPI        ;RVAMC/PLS - Convert Personal Preferences to Parameters Utility;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;Call EN to convert Personal Preferences from File 890
        ;to the Kernel Toolkit Parameter File.
EN      ;entry point
        N CWLP,CWCNT,DTOUT,DUOUT,DIR,X,Y
        ;check for existing CWMAIL1 global containing preferences
        I '$D(^CWMAIL1) D BMES^XPDUTL("CWMAIL1 Global doesn't exist! Conversion of preferences not needed.") Q
        S (CWCNT,CWLP)=0 F  S CWLP=$O(^CWMAIL1(CWLP)) Q:CWLP<1  D
        . I $D(^CWMAIL1(CWLP,1,1,0)) S CWCNT=CWCNT+1
        D BMES^XPDUTL("There are "_CWCNT_" user(s) to convert")
        D UPDATE^XPDID(0)  ;init progress bar
        D MES^XPDUTL("Beginning conversion of preferences...")
        D LOOP
        Q
LOOP    ;loop thru users
        N CWUSR,CWLP,CWTXT,CWVAL,CWPREF,CWCNTC,XPDIDTOT
        S CWUSR=0
        S XPDIDTOT=CWCNT  ;set total number
        F  S CWUSR=$O(^CWMAIL1(CWUSR)) Q:CWUSR<1  D
        . S CWCNTC=+$G(CWCNTC)+1
        . I CWCNTC#10=0 D UPDATE^XPDID(CWCNTC)
        . S CWPREF=$O(^CWMAIL1(CWUSR,1,"B","PREFERENCES",0))  ;get node
        . Q:'CWPREF  ;no preferences stored
        . S CWLP=0 F  S CWLP=$O(^CWMAIL1(CWUSR,1,CWPREF,1,CWLP)) Q:CWLP<1  D
        . . S CWTXT=^CWMAIL1(CWUSR,1,CWPREF,1,CWLP,0)  ;get node text
        . . I CWTXT'?1"[".E1"]" D
        . . . S CWPRM=$$GETPRM^CWMAILE($P(CWTXT,"="))   ;get parameter
        . . . I $L(CWPRM) D
        . . . . S CWVAL=$$STRIP^XLFSTR($P(CWTXT,"=",2)," ")                 ;get value
        . . . . I CWPRM="1|CWMA GENERAL MD COL" D
        . . . . . S CWVAL=CWVAL_$S($E(CWVAL,$L(CWVAL))=";":"6,38",1:";6,38")  ;add data for new column
        . . . . S CWERR=$$SETPARM^CWMAILD(CWUSR,CWPRM,CWVAL)                 ;set value into parameter
        D BMES^XPDUTL("Preference conversion is finished.")
        Q
