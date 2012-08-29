%ZVEMKST ;DJB,KRN**Save Symbol Table [07/22/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SYMTAB(ACTION,MODULE,SESSION) ; Symbol Table
 ;ACTION ....: C=Clear  R=Restore  S=Save
 ;MODULE ....: VEDD  VGL  VRR
 ;SESSION ...: Number (VGL=Session number  VRR=Rtn Number)
 Q:",C,R,S,"'[(","_$G(ACTION)_",")
 Q:",VEDD,VEDDL,VGL,VRR,"'[(","_$G(MODULE)_",")
 S:$G(SESSION)'>0 SESSION=1
 I ACTION="C" D SAVE,CLEAR Q  ;Clear symbol table
 I ACTION="R" D RESTORE Q  ;Restore symbol table
 I ACTION="S" D SAVE Q  ;Save symbol table
 Q
SAVE ;Save symbol table.
 KILL ^TMP("VEE","SYMTAB",$J,MODULE,SESSION)
 Q:'$$EXIST^%ZVEMKU("%ZOSV")
 NEW %,%X,%Y,%ZISOS,X,Y
 S X="^TMP(""VEE"",""SYMTAB"","_$J_","""_MODULE_""","_SESSION_","
 D DOLRO^%ZOSV
 Q
CLEAR ;Clear symbol table (Save certain variables)
 Q:'$D(^TMP("VEE","SYMTAB",$J,MODULE,SESSION))
 NEW %HLD,%PC,%REF,%VAR
 S %REF="^TMP(""VEE"",""SYMTAB"","_$J_","""_MODULE_""","_SESSION_")"
 S %HLD="""VEE"",""SYMTAB"","_$J_","""_MODULE_""","_SESSION_","
 F  S %REF=$Q(@%REF) Q:%REF=""!(%REF'[%HLD)  D
 . F %PC=1:1:10 Q:$P(%REF,",",%PC)["SYMTAB"  ;%PC varies with translation
 . S %VAR=$P(%REF,",",(%PC+4)),%VAR=$P(%VAR,"""",2) ;Strip quotes
 . I $P(%REF,",",(%PC+5))]""  S %VAR=%VAR_"("_$P(%REF,",",(%PC+5),99)
 . I $E(%VAR,1,3)="DUZ"!($E(%VAR,1,2)="IO") Q
 . I $E(%VAR,1,3)="VEE" Q
 . I ",FLAGVPE,GLS,U,VEDDS,VRRS,"[(","_%VAR_",") Q  ;Module counters
 . I ",%HLD,%PC,%REF,%VAR,"[(","_%VAR_",") Q  ;Used by RESTORE
 . KILL @%VAR
 . Q
 Q
RESTORE ;Restore symbol table.
 Q:'$D(^TMP("VEE","SYMTAB",$J,MODULE,SESSION))
 NEW %HLD,%PC,%REF,%VAR
 S %REF="^TMP(""VEE"",""SYMTAB"","_$J_","""_MODULE_""","_SESSION_")"
 S %HLD="""VEE"",""SYMTAB"","_$J_","""_MODULE_""","_SESSION_","
 F  S %REF=$Q(@%REF) Q:%REF=""!(%REF'[%HLD)  D
 . F %PC=1:1:10 Q:$P(%REF,",",%PC)["SYMTAB"  ;PC varies with translation
 . S %VAR=$P(%REF,",",(%PC+4)),%VAR=$P(%VAR,"""",2) ;Strip quotes
 . I $P(%REF,",",(%PC+5))]""  S %VAR=%VAR_"("_$P(%REF,",",(%PC+5),99)
 . I ",%HLD,%PC,%REF,%VAR,,X,Y,"[(","_%VAR_",") Q  ;Used by RESTORE
 . S @%VAR=@%REF
 . Q
 KILL ^TMP("VEE","SYMTAB",$J,MODULE,SESSION)
 Q
