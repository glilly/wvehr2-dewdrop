LEXTOLKN ;ISL Parse term into words ;11/30/2008
 ;;2.0;LEXICON UTILITY;**4,55**;Sep 23, 1996;Build 11
 ;
 ; Returns ^TMP("LEXTKN",$J,#,WORD) containing words
 ;
 ; If LEXIDX is set, then the Excluded Words file is used to 
 ; selectively exclude words from the indexing process.  If
 ; LEXLOOK is set, then the Excluded Words file is used to 
 ; selectively exclude words from the look-up process.  If 
 ; LEXIDX and LEXLOOK do not exist then all words are parsed
 ; parsed.
 ;
PT ; Entry point where DA is defined and X is unknown
 Q:'$D(DA)  S X=^LEX(757.01,DA,0)
PTX ; Entry point to parse string (X must exist)
 N LEXOK,LEXTOKS,LEXTOKS2,LEXTOKI,LEXTOKW,LEXTOLKN,LEXOKC,LEXOKN,LEXOKP,LEXTOKAA,LEXTOKAB,LEXTOKAC K ^TMP("LEXTKN",$J)
 Q:'$L($G(X))  S LEXTOKS=$TR(X,"-"," "),LEXTOKS=$TR(LEXTOKS,$C(9)," ")
 ; Remove leading blanks from string
 F LEXOKP=1:1:$L(LEXTOKS) Q:$E(LEXTOKS,LEXOKP)'[" "
 S LEXTOKS=$E(LEXTOKS,LEXOKP,$L(LEXTOKS))
 ; Remove trailing blanks from string
 F LEXOKP=$L(LEXTOKS):-1:1 Q:$E(LEXTOKS,LEXOKP)'[" "
 S LEXTOKS=$E(LEXTOKS,1,LEXOKP)
 ; Remove Punctuation (less slashes)
 S LEXTOKS=$TR(LEXTOKS,"?`~!@#$%^&*()_-+={}[]\:;,<>","                            ")
 ; Conditionally remove slashes
 S:$D(LEXIDX) LEXTOKS=$TR(LEXTOKS,"/"," ")
 S LEXTOKS=$TR(LEXTOKS,".","")
 S LEXTOKS=$TR(LEXTOKS,"""","")
 ; Swtich to UPPERCASE (lower case is not specified by LEXLOW)
 S:'$D(LEXLOW) LEXTOKS=$$UP^XLFSTR(LEXTOKS)
 ; Store in temporary array (based on space character)
 S LEXOKC=0 F LEXTOKI=1:1:$L(LEXTOKS," ") D
 . N LEXTOKW S LEXTOKW=$P(LEXTOKS," ",LEXTOKI) Q:LEXTOKW=""
 . I LEXTOKW'["/" D
 . . S LEXOKC=LEXOKC+1,LEXTOLKN(LEXOKC)=LEXTOKW
 . . S LEXTOLKN(0)=LEXOKC
 . I LEXTOKW["/"&('$D(^LEX(757.05,"B",LEXTOKW))) D  Q  ; PCH 4
 . . N LEXP S LEXP=0 F  S LEXP=LEXP+1 Q:$P(LEXTOKW,"/",LEXP)=""  D
 . . . S LEXOKC=LEXOKC+1,LEXTOLKN(LEXOKC)=$P(LEXTOKW,"/",LEXP)
 . . . S LEXTOLKN(0)=LEXOKC
 . I LEXTOKW["/"&($D(^LEX(757.05,"B",LEXTOKW))) D
 . . N LEXOKR S LEXOKR=$O(^LEX(757.05,"B",LEXTOKW,0))
 . . I $P($G(^LEX(757.05,LEXOKR,0)),U,3)="R" D
 . . . S LEXOKC=LEXOKC+1,LEXTOLKN(LEXOKC)=LEXTOKW
 . . . S LEXTOLKN(0)=LEXOKC
 K LEXOKC,LEXOKR
 I +($G(LEXTOLKN(0)))=0 K LEXTOLKN S ^TMP("LEXTKN",$J,0)=0 G EXIT
 S LEXTOKW="",LEXOKN=0 F LEXTOKI=1:1:LEXTOLKN(0) D
 . S LEXTOKW=$G(LEXTOLKN(LEXTOKI))
 . ; Remove leading blanks
 . F LEXOKP=1:1:$L(LEXTOKW) Q:$E(LEXTOKW,LEXOKP)'[" "
 . S LEXTOKW=$E(LEXTOKW,LEXOKP,$L(LEXTOKW))
 . ; Remove trailing blanks
 . F LEXOKP=$L(LEXTOKW):-1:1 Q:$E(LEXTOKW,LEXOKP)'[" "
 . S LEXTOKW=$E(LEXTOKW,1,LEXOKP)
 . ; Apostrophy "S"
 . S (LEXTOKAA,LEXTOKAB,LEXTOKAC)="" I $E(LEXTOKW,($L(LEXTOKW)-1),$L(LEXTOKW))["'S" D
 . . S LEXTOKAA=$TR(LEXTOKW,"'",""),LEXTOKAB=$P(LEXTOKW,"'",1),LEXTOKAC=$P(LEXTOKW,"'",1)_$P(LEXTOKW,"'",2)
 . ; Pluralized Apostrophy "S"
 . I '$L((LEXTOKAA_LEXTOKAB_LEXTOKAC)) I $E(LEXTOKW,$L(LEXTOKW))["S",$E(LEXTOKW,($L(LEXTOKW)-1))'["'" D
 . . N LEXTMP S LEXTMP=$E(LEXTOKW,1,($L(LEXTOKW)-1)) Q:'$L(LEXTMP)  S:$D(^LEX(757.01,"AWRD",LEXTMP)) LEXTOKAA=LEXTMP
 . ; Apostrophies and spaces
 . S LEXTOKW=$TR(LEXTOKW,"'",""),LEXTOKW=$TR(LEXTOKW," ","")
 . ; Numeric only
 . I $D(LEXIDX) D
 . . I LEXTOKW'="" S:$D(^LEX(757.04,"ACTION",LEXTOKW,"I")) LEXTOKW=""
 . . I LEXTOKW'="" S:$D(^LEX(757.04,"ACTION",LEXTOKW,"B")) LEXTOKW=""
 . I $D(LEXLOOK) D
 . . I LEXTOKW'="" S:$D(^LEX(757.04,"ACTION",LEXTOKW,"L")) LEXTOKW=""
 . . I LEXTOKW'="" S:$D(^LEX(757.04,"ACTION",LEXTOKW,"B")) LEXTOKW=""
 . I $D(LEXIDX),($L($G(LEXTOKAA))!($L($G(LEXTOKAB)))!($L($G(LEXTOKAC)))) D
 . . I $L(LEXTOKAA) S LEXOKN=+($G(LEXOKN))+1,^TMP("LEXTKN",$J,LEXOKN,LEXTOKAA)=""
 . . I $L(LEXTOKAB) S LEXOKN=+($G(LEXOKN))+1,^TMP("LEXTKN",$J,LEXOKN,LEXTOKAB)=""
 . . I $L(LEXTOKAC) S LEXOKN=+($G(LEXOKN))+1,^TMP("LEXTKN",$J,LEXOKN,LEXTOKAC)=""
 . I $D(LEXOKN),$D(LEXTOKW),LEXTOKW'="" D
 . . S LEXOKN=+(LEXOKN)+1,^TMP("LEXTKN",$J,LEXOKN,LEXTOKW)=""
 . S LEXTOKW=""
 S ^TMP("LEXTKN",$J,0)=LEXOKN
EXIT ; Clean up and quit
 K LEXOK,LEXTOKI,LEXOKN,LEXOKP,LEXOKR,LEXTOKS,LEXTOKS2,LEXTOKW,LEXTOLKN,LEXTOKAA,LEXTOKAB,LEXTOKAC
 Q
