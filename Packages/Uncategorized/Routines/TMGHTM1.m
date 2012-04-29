TMGTHTM1        ;TMG/kst-HTML utilities ;08/10/10, 8/23/10
                ;;1.0;TMG-LIB;**1**;08/10/10;Build 23
        ;
        ;"Utility functions related to documents with HTML formatting
        ;
        ;"Kevin Toppenberg MD
        ;"GNU General Public License (GPL) applies
        ;"8/10/10
        ;
        ;"---------------------------------------------------------------------------
        ;"PUBLIC FUNCTIONS
        ;"---------------------------------------------------------------------------
        ;"$$ISHTML(IEN8925) -- determine if the text held in the REPORT TEXT field is HTML markup
        ;"HTML2TXT(ARRAY) -- convert HTML --> text formatted array
        ;"$$SIGPICT(DUZ,DATE) -- Return HTML tag pointing to signiture image, or '' if none.
        ;"---------------------------------------------------------------------------
        ;"PRIVATE FUNCTIONS
        ;"---------------------------------------------------------------------------
        ;
        ;"---------------------------------------------------------------------------
        ;"DEPENDENCIES:
        ;
        ;"---------------------------------------------------------------------------
        ;
ISHTML(IEN8925)
               ;"Purpose: to determine if the text held in the REPORT TEXT field is HTML markup
               ;"Input: IEN8925 -- record number in file 8925
               ;"Results: 1 if HTML markup, 0 otherwise.
               ;"Note: This is not a perfect test.  Also, will fail if tag is not uppercase
               ;
               NEW RESULT SET RESULT=0
               NEW DONE SET DONE=0
               NEW LINE SET LINE=0
               FOR  SET LINE=$ORDER(^TIU(8925,IEN8925,"TEXT",LINE)) QUIT:(LINE="")!DONE  DO
               . NEW LINESTR SET LINESTR=$GET(^TIU(8925,IEN8925,"TEXT",LINE,0))
               . IF (LINESTR["<!DOCTYPE HTML")!(LINESTR["<HTML>") SET DONE=1,RESULT=1 QUIT
               QUIT RESULT
               ;
HTML2TXT(ARRAY)
               ;"Purpose: text a WP array that is HTML formatted, and strip <P>, and
               ;"         return in a format of 1 line per array node.
               ;"         Actually, strips out ALL other tags too
               ;"Input: ARRAY -- PASS BY REFERENCE.  This array will be altered.
               ;"Results: none
               ;"NOTE: This conversion causes some loss of HTML tags, so a round trip
               ;"      conversion back to HTML would fail.
               NEW OUTARRAY,OUTI
               SET OUTI=1
               ;
               NEW S2 SET S2=""
               NEW LINE SET LINE=0
               FOR  SET LINE=$ORDER(ARRAY(LINE)) QUIT:(LINE="")  DO
               . NEW LINESTR SET LINESTR=S2_$GET(ARRAY(LINE,0))
               . SET S2=""
               . FOR  DO  QUIT:(LINESTR'["<")
               . . IF (LINESTR["<P>")&($PIECE(LINESTR,"<P>",1)'["<BR>") DO  QUIT
               . . . SET OUTARRAY(OUTI,0)=$PIECE(LINESTR,"<P>",1)
               . . . SET OUTI=OUTI+1
               . . . SET OUTARRAY(OUTI,0)=""  ;"Add blank line to create paragraph break.
               . . . SET OUTI=OUTI+1
               . . . SET LINESTR=$PIECE(LINESTR,"<P>",2,999)
               . . IF (LINESTR["</P>")&($PIECE(LINESTR,"</P>",1)'["<BR>") DO  QUIT
               . . . SET OUTARRAY(OUTI,0)=$PIECE(LINESTR,"</P>",1)
               . . . SET OUTI=OUTI+1
               . . . SET OUTARRAY(OUTI,0)=""  ;"Add blank line to create paragraph break.
               . . . SET OUTI=OUTI+1
               . . . SET LINESTR=$PIECE(LINESTR,"</P>",2,999)
               . . IF (LINESTR["<LI>")&($PIECE(LINESTR,"</LI>",1)'["<BR>") DO  QUIT  ;"//kt Block added 8/23/10
               . . . SET OUTARRAY(OUTI,0)=$PIECE(LINESTR,"<LI>",1)
               . . . SET OUTI=OUTI+1
               . . . SET OUTARRAY(OUTI,0)=""  ;"Add blank line to create paragraph break.
               . . . SET OUTI=OUTI+1
               . . . SET LINESTR=$PIECE(LINESTR,"<LI>",2,999)
               . . IF (LINESTR["</LI>")&($PIECE(LINESTR,"</LI>",1)'["<BR>") DO  QUIT
               . . . SET OUTARRAY(OUTI,0)=$PIECE(LINESTR,"</LI>",1)   ;"   _"</LI>"
               . . . SET OUTI=OUTI+1
               . . . SET OUTARRAY(OUTI,0)=""  ;"Add blank line to create paragraph break.
               . . . SET OUTI=OUTI+1
               . . . SET LINESTR=$PIECE(LINESTR,"</LI>",2,999)
               . . IF LINESTR["<BR>" DO  QUIT
               . . . SET OUTARRAY(OUTI,0)=$PIECE(LINESTR,"<BR>",1)
               . . . SET OUTI=OUTI+1
               . . . SET LINESTR=$PIECE(LINESTR,"<BR>",2,999)
               . . SET S2=LINESTR,LINESTR=""
               . SET S2=S2_LINESTR
               IF S2'="" DO
               . SET OUTARRAY(OUTI,0)=S2
               . SET OUTI=OUTI+1
               ;
               ;"Strip out all tags other than <P>
               NEW LINE SET LINE=0
               FOR  SET LINE=$ORDER(OUTARRAY(LINE)) QUIT:(LINE="")  DO
               . NEW LINESTR SET LINESTR=$GET(OUTARRAY(LINE,0))
               . FOR  QUIT:(LINESTR'["<")!(LINESTR'[">")  DO  ;" aaa<bbb>ccc  or aaa>bbb<ccc
               . . NEW S1,S2,S3
               . . SET S1=$PIECE(LINESTR,"<",1)
               . . IF S1[">" DO  QUIT
               . . . SET LINESTR=$PIECE(LINESTR,">",1)_"}"_$PIECE($PIECE(LINESTR,">",2,999),"<",1)_"{"_$PIECE(LINESTR,"<",2,999)
               . . SET S2=$PIECE($PIECE(LINESTR,"<",2,999),">",1)
               . . SET S3=$PIECE(LINESTR,">",2,999)
               . . SET LINESTR=S1_S3
               . SET OUTARRAY(LINE,0)=LINESTR
               ;
               ;"Convert special characters
               NEW SPEC
               SET SPEC("&nbsp;")=" "
               SET SPEC("&lt;")="<"
               SET SPEC("&gt;")=">"
               SET SPEC("&amp;")="&"
               SET SPEC("&quot;")=""""
               NEW LINE SET LINE=0
               FOR  SET LINE=$ORDER(OUTARRAY(LINE)) QUIT:(LINE="")  DO
               . NEW LINESTR SET LINESTR=$GET(OUTARRAY(LINE,0))
               . SET OUTARRAY(LINE,0)=$$REPLACE^XLFSTR(LINESTR,.SPEC)
               ;
               KILL ARRAY
               MERGE ARRAY=OUTARRAY
               QUIT
               ;
SIGPICT(DUZ,DATE)       ;
               ;"Purpose: Return HTML tag pointing to signiture image, or '' if none.
               ;"Input: DUZ -- The user for whom to get sig image
               ;"       DATE -- (Optional) The date of the signed document.  A user may change
               ;"               their current signature image over time.
               ;"               If not provided, then the LAST entered sig image is returned
               ;"Results: An HTML tag with pointer to image, or '' if none.
               NEW RESULT
               SET RESULT=""
               ;"finish!!!
               QUIT RESULT
