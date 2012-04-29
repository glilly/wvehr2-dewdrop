NHINVART        ;SLC/MKB -- Allergy/Reaction extract
        ;;1.0;NHIN;**1**;Oct 25, 2010;Build 11
        ;
        ; External References          DBIA#
        ; -------------------          -----
        ; %DT                          10003
        ; GMRADPT                      10099
        ; EN1^GMRAOR2                   2422
        ; PSN50P41                      4531
        ; PSN50P65                      4543
        ;
        ; ------------ Get reactions from VistA ------------
        ;
EN(DFN,BEG,END,MAX,IFN) ; -- find patient's allergies/reactions
        N GMRA,GMRAL,NHI,NHITM,NHICNT
        S DFN=+$G(DFN) Q:DFN<1
        S BEG=$G(BEG,1410101),END=$G(END,9999998),MAX=$G(MAX,999999),NHICNT=0
        D EN1^GMRADPT
        ;
        ; get one reaction
        I $G(IFN) D EN1(IFN,.NHITM),XML(.NHITM) Q
        ;
        ; get all reactions
        I 'GMRAL S NHITM("assessment")=$S(GMRAL=0:"nka",1:"not done") D XML(.NHITM) Q
        S NHI=0 F  S NHI=+$O(GMRAL(NHI)) Q:NHI<1  D  Q:NHICNT'<MAX
        . K NHITM D EN1(NHI,.NHITM) Q:'$D(NHITM)
        . D XML(.NHITM) S NHICNT=NHICNT+1
        Q
        ;
EN1(ID,REAC)    ; -- return a reaction in REAC("attribute")=value
        ;          from EN: expects GMRAL(ID)
        N NHY,GMRA,I,J,X,Y,SEV,TXT,NM,SEV K REAC
        S GMRA=$G(GMRAL(ID)) D EN1^GMRAOR2(ID,"NHY")
        S X=$P(NHY,U,10) I $L(X) S X=$$DATE(X) Q:X<BEG  Q:X>END  S REAC("entered")=X
        S REAC("facility")=$$FAC^NHINV ;local stn#^name
        S REAC("id")=ID,REAC("name")=$P(NHY,U) I $P(GMRA,U,9) D
        . S X=$P(GMRA,U,9),Y=+$P(X,"(",2) I 'Y,X["PSDRUG" S Y=50
        . S REAC("localCode")=X,REAC("vuid")=$$VUID^NHINV(+X,Y)
        S X=$P(NHY,U,6) S:$L(X) REAC("mechanism")=X
        S X=$P(NHY,U,5),REAC("source")=$E(X)
        S REAC("adverseEventType")=$S($L(GMRA):$P(GMRA,U,7),1:$$DFO($P(NHY,U,7)))
        I $P(NHY,U,4)="VERIFIED",$P(NHY,U,9) S REAC("verified")=$P(NHY,U,9)
        S I=0,SEV="" F  S I=$O(NHY("O",I)) Q:I<1  S X=$P(NHY("O",I),U,2) S:X]SEV SEV=X ;find highest severity
        S:$L(SEV) REAC("severity")=SEV
        ; reactions
        S I=0 F  S I=$O(NHY("S",I)) Q:I<1  D
        . S X=NHY("S",I),NM=$P(X," (") S:NM="" NM="OTHER REACTION"
        . S Y=+$$FIND1^DIC(120.83,,"QX",NM)
        . S REAC("reaction",I)=NM_U_$$VUID^NHINV(Y,120.83)
        ; comments
        S I=0 F  S I=$O(NHY("C",I)) Q:I<1  D
        . S X=$G(NHY("C",I)) K TXT
        . S Y=$$VA200($P(X,U,3))_U_$P(X,U)
        . S Y=Y_U_$S($L($P(X,U,2)):$E($P(X,U,2)),1:"E")
        . S J=0 F  S J=$O(NHY("C",I,J)) Q:J<1  S X=$G(NHY("C",I,J,0)),TXT(J)=X
        . K X S X=$$STRING^NHINV(.TXT)
        . S REAC("comment",I)=Y_U_X ;ien^name^date^type^text
        ; drug info
        I $D(NHY("I")) D
        . N ROOT S ROOT=$$B^PSN50P41
        . S I=0 F  S I=$O(NHY("I",I)) Q:I<1  S X=$G(NHY("I",I)) D
        .. N IEN S IEN=$O(@ROOT@(X,0))
        .. S REAC("drugIngredient",I)=X_U_$$VUID^NHINV(IEN,50.416)
        I $D(NHY("V")) D
        . S I=0 F  S I=$O(NHY("V",I)) Q:I<1  S X=$G(NHY("V",I)) D
        .. D C^PSN50P65("",$P(X,U,2),"PSN")
        .. N IEN S IEN=+$O(^TMP($J,"PSN","C",$P(X,U),0))
        .. S REAC("drugClass",I)=$P(X,U,2)_U_$$VUID^NHINV(IEN,50.605)
        I GMRA="" S REAC("removed")=1 ;entered in error
        Q
        ;
VA200(NAME)     ; -- Return ien^name from #200
        N Y S NAME=$G(NAME),Y="^"
        I $L(NAME) S Y=+$O(^VA(200,"B",NAME,0))_U_NAME
        Q Y
        ;
DATE(X) ; -- Return internal form of date X
        N %DT,Y
        S %DT="TX" D ^%DT
        Q Y
        ;
DFO(X)  ; -- Return 'DFO' string for mechanism name(s)
        N I,P,Y S Y=""
        F I=1:1:$L(X,",") S P=$P(X,",",I),Y=Y_$S($E(P)=" ":$E(P,2),1:$E(P))
        S:Y="" Y=$G(X)
        Q Y
        ;
        ; ------------ Return data to middle tier ------------
        ;
XML(REAC)       ; -- Return patient reaction as XML
        ;  as <element code='123' displayName='ABC' />
        N ATT,X,Y,I,P,NM,TAG
        D ADD("<allergy>") S NHINTOTL=$G(NHINTOTL)+1
        S ATT="" F  S ATT=$O(REAC(ATT)) Q:ATT=""  D  D:$L(Y) ADD(Y)
        . I ATT="comment" D  S Y="" Q
        .. S I=0,Y="<comments>" D ADD(Y)
        .. F  S I=$O(REAC(ATT,I)) Q:I<1  S X=$G(REAC(ATT,I)) D
        ... S Y="<comment id='"_I
        ... S:$L($P(X,U,3)) Y=Y_"' entered='"_$P(X,U,3)
        ... S:$L($P(X,U,2)) Y=Y_"' enteredBy='"_$$ESC^NHINV($P(X,U,2))
        ... S:$L($P(X,U,4)) Y=Y_"' commentType='"_$P(X,U,4)
        ... S:$L($P(X,U,5)) Y=Y_"' commentText='"_$$ESC^NHINV($P(X,U,5))
        ... S Y=Y_"' />" D ADD(Y)
        .. D ADD("</comments>")
        . I $O(REAC(ATT,0)) D  S Y="" Q
        .. S NM=ATT_$S($E(ATT,$L(ATT))="s":"es",1:"s") D ADD("<"_NM_">")
        .. S I=0 F  S I=$O(REAC(ATT,I)) Q:I<1  D
        ... S X=$G(REAC(ATT,I)),Y="<"_ATT_" "
        ... F P=1:1 S TAG=$P("name^vuid^severity^Z",U,P) Q:TAG="Z"  I $L($P(X,U,P)) S Y=Y_TAG_"='"_$$ESC^NHINV($P(X,U,P))_"' "
        ... S Y=Y_"/>" D ADD(Y)
        .. D ADD("</"_NM_">")
        . S X=$G(REAC(ATT)),Y="" Q:'$L(X)
        . I X'["^" S Y="<"_ATT_" value='"_$$ESC^NHINV(X)_"' />" Q
        . I $L(X)>1 D  S Y=""
        .. S Y="<"_ATT_" "
        .. F P=1:1 S TAG=$P("code^name^Z",U,P) Q:TAG="Z"  I $L($P(X,U,P)) S Y=Y_TAG_"='"_$$ESC^NHINV($P(X,U,P))_"' "
        .. S Y=Y_"/>" D ADD(Y)
        D ADD("</allergy>")
        Q
        ;
ADD(X)  ; Add a line @NHIN@(n)=X
        S NHINI=$G(NHINI)+1
        S @NHIN@(NHINI)=X
        Q
        ;
C32(REAC)       ; -- convert iens to C32 codes
        N X,Y,I
        S X=$G(REAC("product")) I X S $P(REAC("product"),U)=$$VUID^NHINV(+X,120.82)
        S X=$P($G(REAC("type")),U),Y=$P($G(REAC("mechanism")),U)
        I $L(X) D  S $P(REAC("type"),U)=I
        . I Y="A" S I=$S(X["D":416098002,X["F":414285001,1:419199007) Q
        . I Y="P" S I=$S(X["D":59037007,X["F":235719002,1:420134006) Q
        . S I=$S(X["D":419511003,X["F":418471000,1:418038007)
        S X=+$G(REAC("severity")) I X D
        . S X=$S(X=1:255604002,X=2:6736007,X=3:24484000,1:X)
        . S $P(REAC("severity"),U)=X
        S I=0 F  S I=$O(REAC("reaction",I)) Q:I<1  D
        . S X=$G(REAC("reaction",I)) Q:'X
        . S $P(REAC("reaction",I),U)=$$VUID^NHINV(+X,120.83)
        S I=0 F  S I=$O(REAC("drugClass",I)) Q:I<1  D
        . S X=$G(REAC("drugClass",I)) Q:'X
        . S $P(REAC("drugClass",I),U)=$$VUID^NHINV(+X,50.605)
        S I=0 F  S I=$O(REAC("drugIngredient",I)) Q:I<1  D
        . S X=$G(REAC("drugIngredient",I)) Q:'X
        . S $P(REAC("drugIngredient",I),U)=$$VUID^NHINV(+X,50.416)
        Q
