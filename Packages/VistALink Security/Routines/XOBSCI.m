XOBSCI ;; ld,mjk/alb - VistaLink Interface Implementation ; 07/27/2002  13:00
 ;;1.5;VistALink Security;;Sep 09, 2005
 ;;Foundations Toolbox Release v1.5 [Build: 1.5.0.026]
 ;
 ;Implements the VistaLink message framework for messages in the (XOBS) security module.
 ;
CALLBACK(CB) ; -- init callbacks implementation
 SET CB("STARTELEMENT")="ELEST^XOBSCAV2"
 SET CB("ENDELEMENT")="ELEND^XOBSCAV2"
 SET CB("CHARACTERS")="CHR^XOBSCAV2"
 QUIT
 ;
READER(XOBUF,XOBDATA) ; -- propriatary format reader implementation
 QUIT
 ;
REQHDLR(XOBDATA) ; -- request handler implementation
 DO EN^XOBSCAV(.XOBDATA)
 QUIT
 ;
