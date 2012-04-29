ZWR ;DUMP GLOBALS IN ZWR FORMAT
 ;dump Cache globals to a file in GTM's ZWR format
 ;mlp 18nov01 New routine
 ;mlp 07jan02 Update to encode some chars > 127; limit $C args to 256.
 ;            Use LF instead of ! to end lines.
 ;wb  20Sep02 save each global to a separate file in "/data/" %ZWRSEP
 ;WB  19OCT03 INTEGRATE $$EXIST FROM EXTERNAL ROUTINE
 ;wb  04Jan04 Add output directory query
 ;
 W !!,"DUMPS GLOBALS IN ZWR FORMAT",!!
 ; D OUT^%IS Q:$G(IO)=""  ;request output dev
 r !,"Output directory? ",ZOUTDIR
 D ^%GSET Q:$G(%G)<1    ;request globals to dump
 ;
ASK R !!,"Comment ? ",COM,! I COM?1"?".E D  G ASK
 . W "Enter a comment to save with the file. ",!
 S H=$H,LF=$C(10),QT="""",C255=$C(255),SKIP=$T(SKIP)
 S GN="" F  S GN=$O(^UTILITY(%JO,GN)) Q:GN=""  D
 . S GNN="^"_GN
 . s IOP=ZOUTDIR_GN_".zwr",IOPAR="WNS"
 . I SKIP[(";"_GNN_";")  w "Skipping ",IOP," - in exclusion set",! Q
 . i $$exist(IOP) w "Skipping ",IOP," - already exists",! Q
 . w "Opening ",IOP,!
 . d OUT^%IS i $G(IO)="" u $p w "error opening "_IOP,! r "Waiting for user...",junk q
 . U IO
 . W COM,LF
 . W "Cache "_$TR($ZD(H,2)," ","-")_" "_$ZT($P(H,",",2))_" ZWR",LF
 . s cnt=0
 . D WALK(GNN)
 . C IO U $P
 W !,"Done.",!
 Q
 ;
WALK(G) ;walk through global G, convert subscripts and values as necessary, dump out
 Q:'$D(@G)  Q:G["("    ; chk if @G defined, and must be a top-level name
 I $D(@G)#2 D          ; handle case where top-level node has data
 . S NAME=$NA(@G)
 . S VAL=$$CGV(@G)
 . W NAME_"="_VAL,LF
 F  S G=$Q(@G) Q:G=""  D   ;handle rest of global G
 . S NAME=$NA(@G)
 . S NAME=$$RCC(NAME) D
 . . N P                      ;Remove initial ""_ or final _""
 . . S P=$F(NAME,"(") I P,$E(NAME,P,P+2)="""""_" S $E(NAME,P,P+2)=""
 . . S P=$L(NAME) S:$E(NAME,P-3,P-1)="_""""" $E(NAME,P-3,P-1)=""
 . S VAL=$$CGV(@G)
 . W NAME_"="_VAL,LF
 . s cnt=cnt+1
 . i cnt#10000=0 u $p w "." u IO
 Q
 ;
RCC(NA) ;Replace control chars in NA with $C( ). Returns encoded string.
 Q:'$$CCC(NA) NA                         ;No embedded ctrl chars
 N OUT S OUT=""                          ;holds output name
 N CC S CC=0                             ;count ctrl chars in $C(
 N C                                     ;temp hold each char
 F I=1:1:$L(NA) S C=$E(NA,I) D           ;for each char C in NA
 . I C'?1C,C'=C255 D  S OUT=OUT_C Q      ;not a ctrl char
 . . I CC S OUT=OUT_")_""",CC=0          ;close up $C(... if one is open
 . I CC D
 . . I CC=256 S OUT=OUT_")_$C("_$A(C),CC=0  ;max args in one $C(
 . . E  S OUT=OUT_","_$A(C)              ;add next ctrl char to $C(
 . E  S OUT=OUT_"""_$C("_$A(C)
 . S CC=CC+1
 . Q
 Q OUT
 ;
CGV(V) ;Convert Global Value.
         ;If no encoding required, then return as quoted string.
         ;Otherwise, return as an expression with $C()'s and strings.
 I $F(V,QT) D     ;chk if V contains any Quotes
 . S P=0          ;position pointer into V
 . F  S P=$F(V,QT,P) Q:'P  D  ;find next "
 . . S $E(V,P-1)=QT_QT        ;double each "
 . . S P=P+1                  ;skip over new "
 I $$CCC(V) D  Q V
 . S V=$$RCC(QT_V_QT)
 . S:$E(V,1,3)="""""_" $E(V,1,3)=""
 . S L=$L(V) S:$E(V,L-2,L)="_""""" $E(V,L-2,L)=""
 Q QT_V_QT
 ;
CCC(S) ;test if S Contains a Control Character or $C(255).
 Q:S?.E1C.E 1
 Q:$F(S,$C(255)) 1
 Q 0
SKIP ;;^CacheTemp;^ROUTINE;^mtemp;^mtemp0;^mtemp1;^oddCOM;^oddDEF;^oddMAC;^oddMAP;^oddPROC;^rINC;^rOBJ;^%utility;^%UTILITY;^TMP;^XUTL;^UTILITY;
exist(fn)
 n %
 s %=$zu(140,4,fn)
 q (%=0)
 ;
