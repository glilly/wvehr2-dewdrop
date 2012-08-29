%ZVEMRLZ ;DJB,VRR**RTN VER - ..LBRY Options ; 9/6/02 8:17am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
DELETE ;Delete versions
 NEW CNT,DA,DESC,DIC,DIK,IEN,ND,RENUM,RTN,TMP,VER
 ;
 Q:'$D(^VEE(19200.112))  ;...Version file doesn't exist
 S X="ERROR^%ZVEMRLZ",@($$TRAP^%ZVEMKU1) KILL X
 ;
 W !,"*** DELETE VERSION(S) ***",!
 S RTN=$$GETRTN^%ZVEMRLY() Q:RTN']""
 ;
 ;Quit if routine is currently being edited.
 L +VRRLOCK(RTN):0 E  D  Q
 . W $C(7),!!,"This program is currently being edited. Try later.",!
 . D PAUSE^%ZVEMKU(2,"P")
 ;
 KILL ^TMP("VPE",$J)
 S CNT=1,VER=0
 F  S VER=$O(^VEE(19200.112,"AKEY",RTN,VER)) Q:'VER  D  ;
 . S IEN=$O(^(VER,"")) Q:'IEN  ;
 . S ND=$G(^VEE(19200.112,IEN,0))
 . S DESC=$P(ND,"^",3) S:DESC="" DESC="No description"
 . S TMP="Version: "_VER
 . S TMP=TMP_$J("",15-$L(TMP))_"|"_DESC
 . S ^TMP("VPE",$J,CNT)=IEN_$C(9)_TMP
 . S CNT=CNT+1
 ;
 G:'$D(^TMP("VPE",$J)) DELEX ;.............No versions on file
 S ^TMP("VPE",$J,"HD")="^"_RTN_" routine "
 D SELECT^%ZVEMKT("^TMP(""VPE"","_$J_")") ;Call SELECTOR
 G:'$D(^TMP("VPE","SELECT",$J)) DELEX  ;...Nothing selected
 ;
 S RENUM=$$ASK^%ZVEMKU("Renumber any remaining versions, starting with 1",1)
 W !
 G:$$ASK^%ZVEMKU("Ok to delete now",1)'="Y" DELEX
 ;
 S CNT=0
 F  S CNT=$O(^TMP("VPE","SELECT",$J,CNT)) Q:'CNT  D  ;
 . S ND=$G(^TMP("VPE","SELECT",$J,CNT))
 . S DA=$P(ND,$C(9),1) Q:'DA
 . S DIK="^VEE(19200.112,"
 . D ^DIK
 ;
 I RENUM="Y" D DELRENUM(RTN) ;Renumber remaining version
 ;
 W !!,"Deletion complete."
 D PAUSE^%ZVEMKU(2)
DELEX ;
 L -VRRLOCK(RTN) ;Unlock routine editing
 KILL ^TMP("VPE",$J)
 KILL ^TMP("VPE","SELECT",$J)
 Q
 ;
DELRENUM(RTN) ;Renumber remaining versions.
 ;RTN=Routine name
 Q:$G(RTN)']""
 Q:'$D(^VEE(19200.112,"AKEY",RTN))
 ;
 NEW CNT,FDA,IEN,MSG,VER
 ;
 S VER=0,CNT=1
 F  S VER=$O(^VEE(19200.112,"AKEY",RTN,VER)) Q:'VER  D  ;
 . I VER=CNT S CNT=CNT+1 Q
 . S IEN=$O(^VEE(19200.112,"AKEY",RTN,VER,0)) Q:'IEN
 . S FDA(19200.112,IEN_",",2)=CNT,CNT=CNT+1
 . D FILE^DIE("","FDA","MSG")
 Q
 ;==================================================================
BULKDEL ;Bulk delete
 NEW PRESERVE,RENUM,SHOW,X
 ;
 Q:'$D(^VEE(19200.112))  ;...Version file doesn't exist
 S X="ERROR^%ZVEMRLZ",@($$TRAP^%ZVEMKU1) KILL X
 KILL ^TMP("VPE",$J)
 ;
 S SHOW=$$BULKS() G:SHOW="" BULKEX
 I SHOW="L" D BULKL I 1 ;Show only Library routines in Selector
 E  D BULKA ;Show ALL routines in Selector
 ;
 G:'$D(^TMP("VPE",$J)) BULKEX ;............No versions on file
 S ^TMP("VPE",$J,"HD")="Routines on file "
 D SELECT^%ZVEMKT("^TMP(""VPE"","_$J_")") ;Call SELECTOR
 G:'$D(^TMP("VPE","SELECT",$J)) BULKEX  ;..Nothing selected
 ;
 S PRESERVE=$$BULKV() ;Preserve any versions?
 I PRESERVE W ! D  ;
 . S RENUM=$$ASK^%ZVEMKU("Renumber any remaining versions, starting with 1",1)
 W ! G:$$ASK^%ZVEMKU("Ok to delete now",1)'="Y" DELEX
 ;
 D BULKD ;Do deletions
 W !!,"Deletion complete."
 D PAUSE^%ZVEMKU(2)
 ;
BULKEX ;Exit
 KILL ^TMP("VPE",$J)
 KILL ^TMP("VPE","SELECT",$J)
 Q
 ;
BULKS() ;Which routines to show in Selector?
 ;Return: L, A, or ""
 NEW SHOW
 W !,"Include which routines in Selector?"
 W !!,"   L  Library Routines"
 W !,"   A  All Routines"
 W !
BULKS1 W !,"Select LETTER: "
 R SHOW:300 S:'$T SHOW="^" I "^"[SHOW Q ""
 I ",L,A,l,a,"'[(","_SHOW_",") D  G BULKS1
 . W "   Enter L or A, or <RET> to abort"
 S:SHOW="l" SHOW="L"
 S:SHOW="a" SHOW="A"
 Q SHOW
 ;
BULKA ;Present all routines in Selector
 NEW CNT,NUM,RTN,TMP,VER
 S CNT=1
 S RTN=""
 F  S RTN=$O(^VEE(19200.112,"UNIQ",RTN)) Q:RTN']""  D  ;
 . S TMP=RTN_$J("",15-$L(RTN))
 . S (NUM,VER)=0
 . F  S VER=$O(^VEE(19200.112,"AKEY",RTN,VER)) Q:'VER  S NUM=NUM+1
 . S TMP=TMP_"|"_NUM_" version"_$S(NUM>1:"s",1:"")
 . S ^TMP("VPE",$J,CNT)=RTN_"^"_NUM_$C(9)_TMP
 . S CNT=CNT+1
 Q
 ;
BULKL ;Present only those routines signed out in the Library
 NEW CNT,DATA,ID,IEN,NUM,RTN,TMP,VER
 ;
 S ID=$$RSID^%ZVEMRLO() Q:ID="^"  ;Use IDENTIFIER field
 ;
 S CNT=1
 S RTN=""
 F  S RTN=$O(^VEE(19200.11,"B",RTN)) Q:RTN']""  D  ;
 . Q:'$D(^VEE(19200.112,"AKEY",RTN))  ;No versions for this rtn
 . S IEN=$O(^VEE(19200.11,"B",RTN,"")) Q:'IEN
 . S DATA=$G(^VEE(19200.11,IEN,0))
 . I ID]"",ID'=$P(DATA,"^",4) Q
 . S TMP=RTN_$J("",15-$L(RTN))
 . S (NUM,VER)=0
 . F  S VER=$O(^VEE(19200.112,"AKEY",RTN,VER)) Q:'VER  S NUM=NUM+1
 . S TMP=TMP_"|"_NUM_" version"_$S(NUM>1:"s",1:"")
 . S ^TMP("VPE",$J,CNT)=RTN_"^"_NUM_$C(9)_TMP
 . S CNT=CNT+1
 Q
 ;
BULKD ;Do deletions
 NEW CNT,DA,DIC,DIK,I,ND,NUM,TMP,RTN,VER
 S CNT=0
 F  S CNT=$O(^TMP("VPE","SELECT",$J,CNT)) Q:'CNT  D  ;
 . S ND=$G(^TMP("VPE","SELECT",$J,CNT))
 . S TMP=$P(ND,$C(9),1)
 . S RTN=$P(TMP,"^",1) Q:RTN']""  ;Routine name
 . S NUM=$P(TMP,"^",2) ;Number of versions on file
 . I PRESERVE S NUM=(NUM-PRESERVE) ;How many to preserve?
 . S VER=0
 . F I=1:1:NUM S VER=$O(^VEE(19200.112,"AKEY",RTN,VER)) Q:'VER  D  ;
 .. S DA=$O(^VEE(19200.112,"AKEY",RTN,VER,0)) Q:'DA
 .. S DIK="^VEE(19200.112,"
 .. D ^DIK
 . I $G(RENUM)="Y" D DELRENUM(RTN) ;Renumber remaining versions
 Q
 ;
BULKV() ;Preserve how many versions?
 NEW PRES
 S PRES=$$ASK^%ZVEMKU("Do you want to preserve any versions",1)
 I PRES'="Y" Q 0
BULKV1 W !!,"Enter number of most recent versions to be preserved: "
 R PRES:300 S:'$T PRES="^" I "^"[PRES Q 0
 I PRES'=+PRES!(PRES?1.N1".".E) D  G BULKV1
 . W !,"If you enter a number I will preserve that many versions of each"
 . W !,"routine on file. The most recent versions will be the ones preserved."
 Q PRES
 ;
ERROR ;Error trap
 NEW ZE
 S @("ZE="_VEE("$ZE"))
 L -VRRLOCK(RTN) ;Unlock routine editing
 W !!,"An error has occurred"
 W !,"ERROR: ",ZE
 D PAUSE^%ZVEMKU(2,"P")
 Q
