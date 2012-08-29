FSCEUD ;SLC/STAFF-NOIS Edit User Defaults ;1/10/96  11:46
 ;;1.1;NOIS;;Sep 06, 1998
 ;
MOD(USER) ; $$(user) -> preferred module default
 N ACTION,DEF,VALUE S DEF=""
 D DEFAULT(USER,"MOD",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 D
 .I '$D(VALUE) S VALUE=DEF Q
 .I '$L(VALUE) S VALUE=DEF Q
 .I '$O(^FSC("MOD","B",VALUE,0)) S ACTION="P" Q
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
SPEC(USER) ; $$(user) -> preferred specialist default
 N ACTION,DEF,VALUE S DEF=USER
 D DEFAULT(USER,"SPEC",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"S") I '$L(ACTION) S ACTION="P"
 S VALUE=DEF
 Q ACTION_U_VALUE
 ;
SUBJECT(USER) ; $$(user) -> preferred subject default
 N ACTION,DEF,VALUE S DEF=""
 D DEFAULT(USER,"SUBJECT",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 D
 .I '$D(VALUE) S VALUE=DEF Q
 .I '$L(VALUE) S VALUE=DEF Q
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
CONTACT(SITE0,USER) ; $$(site zero node,user) -> preferred site contact default
 N ACTION,DEF,VALUE S DEF=$$VALUE^FSCGET($P(SITE0,U,6),7100,2.1)
 D DEFAULT(USER,"IRM",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 S VALUE=DEF
 Q ACTION_U_VALUE
 ;
PHONE(SITE0,USER) ; $$(site zero node,user) -> preferred site phone default
 N ACTION,DEF,VALUE S DEF=$S($P(SITE0,U,7):$P(SITE0,U,7),1:$P(SITE0,U,8))
 D DEFAULT(USER,"PHONE",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 S VALUE=DEF
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
PRIORITY(USER) ; $$(user) -> preferred edit
 N ACTION,DEF,VALUE S DEF="ROUTINE"
 D DEFAULT(USER,"PRI",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 D
 .I '$D(VALUE) S VALUE=DEF Q
 .I '$L(VALUE) S VALUE=DEF Q
 .I '$O(^FSC("PRI","B",VALUE,0)) S ACTION="P" Q
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
PATCH(USER) ; $$(user) -> preferred patch default (prompt or not)
 N ACTION,DEF,VALUE S DEF=""
 D DEFAULT(USER,"PATCH",.ACTION,.VALUE)
 Q $S($L($G(ACTION)):"P",1:"")
 ;
SUB(USER) ; $$(user) -> preferred subcomponent default (prompt or not)
 N ACTION,DEF,VALUE S DEF=""
 D DEFAULT(USER,"DEVSUB",.ACTION,.VALUE)
 Q $S($L($G(ACTION)):"P",1:"")
 ;
KEYWORDS(USER) ; $$(user) -> preferred keywords default (prompt or not)
 N ACTION,DEF,VALUE S DEF=""
 D DEFAULT(USER,"KEYWORDS",.ACTION,.VALUE)
 Q $S($L($G(ACTION)):"P",1:"")
 ;
WKLD(USER) ; $$(user) -> 1 to prompt hrs on editing else 0
 I $L($P($G(^FSC("SPEC",USER,0)),U,21)) Q $P(^(0),U,21)
 Q +$P($G(^FSC("PARAM",1,0)),U,9)
 ;
CDATE(USER) ; $$(user) -> preferred close date default
 N ACTION,DEF,VALUE S DEF="TODAY"
 D DEFAULT(USER,"DATEC",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 D
 .I '$D(VALUE) S VALUE=DEF Q
 .I '$L(VALUE) S VALUE=DEF Q
 .N X,Y S X=VALUE D ^%DT I Y=-1 S ACTION="P" Q
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
FUNC(USER) ; $$(user) -> preferred functional area default
 N ACTION,DEF,VALUE S DEF=$S($P($G(^FSC("SPEC",USER,0)),U,4):$$VALUE^FSCGET($P(^(0),U,4),7105.2,4),1:"SUPPORT")
 D DEFAULT(USER,"FUNC",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 D
 .I '$D(VALUE) S VALUE=DEF Q
 .I '$L(VALUE) S VALUE=DEF Q
 .I '$O(^FSC("FUNC","B",VALUE,0)) S ACTION="P" Q
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
TASK(USER) ; $$(user) -> preferred task default
 N ACTION,DEF,VALUE S DEF="PROBLEM RESOLUTION"
 D DEFAULT(USER,"TASK",.ACTION,.VALUE)
 S ACTION=$G(ACTION,"P") I '$L(ACTION) S ACTION="P"
 D
 .I '$D(VALUE) S VALUE=DEF Q
 .I '$L(VALUE) S VALUE=DEF Q 
 .I '$O(^FSC("TASK","B",VALUE,0)) S ACTION="P" Q
 I ACTION="S",VALUE="" S ACTION="P"
 Q ACTION_U_VALUE
 ;
DEFAULT(USER,FIELD,ACTION,VALUE) ;
 N FLD,NUM
 S FLD=+$O(^FSC("FLD","AC",FIELD,0)) I 'FLD Q
 S NUM=+$O(^FSC("SPEC",USER,50,"B",FLD,0)) I 'NUM Q
 S ACTION=$P($G(^FSC("SPEC",USER,50,NUM,0)),U,2),VALUE=$P($G(^(0)),U,3)
 I ACTION="I",FIELD'="SPEC" S ACTION="P" ; *** kludge to allow 'ignore' only on specialist
 Q
