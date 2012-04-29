C0ECCR ;WV/GPL,FWSLC/DLW-EWD/CCR generator; 9/29/11 10:14pm
 ;;0.1;EWD UTILS;****LOCL RTN**;
 ;
 ; Copyright 2008,2009 George Lilly, University of Minnesota
 ;
 ; David Wicksell <dlw@linux.com>
 ; Copyright © 2011 Fourth Watch Software, LC
 ;
 ; This program is free software: you can redistribute it and/or modify
 ; it under the terms of the GNU Affero General Public License (AGPL)
 ; as published by the Free Software Foundation, either version 3 of
 ; the License, or (at your option) any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 ; GNU Affero General Public License for more details.
 ;
 ; You should have received a copy of the GNU Affero General Public License
 ; along with this program. If not, see http://www.gnu.org/licenses/.
 ;
 ; $Source: repository:/home/src/VistACom/p/C0ECCR.m $
 ; $Revision: [] [34:918e681a6618] 2011-09-29 22:51 -0600 $
 ;
 ; Script to display the local CCR, transform an XML doc with an xml-stylesheet,
 ; and send an email with the local CCR attached to a doctor or the patient
 ;
 ;
INIT(sessid) ;Create the local CCR
 N U,DT,IO,DEV
 S U="^",DT=300
 S IO=$IO
 S DEV="/dev/null" ;Throw away output, so as to not mess up the DOM
 O DEV U DEV
 ;
 N G,DFN,DUZ,XML,HTML
 S DUZ=$$getSessionValue^%zewdAPI("DUZ",sessid)
 S DUZ("AG")="E"
 S DFN=$$getSessionValue^%zewdAPI("DFN",sessid)
 I DFN="" S DFN=2
 ;API to do a Remote Procedure Call to get the local CCR
 D CCRRPC^C0CCCR(.XML,DFN)
 C DEV U IO
 K XML(0) ;Contains count of lines in global, don't want it
 ;
 D deleteFromSession^%zewdAPI("XML",sessid)
 D mergeArrayToSession^%zewdAPI(.XML,"XML",sessid)
 ;
 K ^CacheTempEWD($J)
 M ^CacheTempEWD($J)=XML
 ;
 N OK
 S OK=$$parseDocument^%zewdHTMLParser("xml",0)
 I $G(OK)]"" Q OK
 ;
 K ^CacheTempEWD($J)
 ;
 D listDOMs^%zewdDOM(.LIST)
 S OK=""
 I '$D(LIST("ccrxsl")) S OK=$$parseXMLFile^%zewdAPI("www/css/ccr.xsl","ccrxsl")
 . S OK=$$parseFile^%zewdHTMLParser(FILE,XSLT,,,0) ;Use this one!
 I OK]"" Q OK
 ;
 ;D setSessionValue^%zewdAPI("xmlType",TYPE,sessid)
 ;
 Q ""
 ;
TRANS(XML,HTML) ;Transform a CCR/CCD XML doc into a CCR/CCD HTML doc
 ;DLW - Rough draft of server-side transformation using xsltproc - needs work
 ;Deprecated, now doing the xslt processing in the browser
 N IO,IXML,IHTML,NDEV,PDEV
 S IO=$IO
 ;
 N SUB,IXML S SUB=""
 F  S SUB=$O(XML(SUB)) Q:SUB=""  S IXML(SUB)=XML(SUB)_$C(13,10)
 ;
 S NDEV="vcom.xml."_$J,PDEV="vcom-proc.xml."_$J
 O NDEV U NDEV
 ;
 N NSUB S NSUB=""
 F  S NSUB=$O(IXML(NSUB)) Q:NSUB=""  W IXML(NSUB),!
 C NDEV U IO
 ;
 ZSY "xsltproc "_NDEV_" -o "_PDEV_" 2>/dev/null"
 ;ZSY "xsltproc "_NDEV_" -o "_PDEV_" 2>>xsltError"
 ;
 N TST S TST=$$RETURN^%ZOSV("if [ -e "_PDEV_" ]; then echo 1; else echo 0; fi")
 I TST D
 . O PDEV:READONLY U PDEV
 . ;
 . N I F I=1:1 Q:$ZEOF  R IHTML(I)
 . ;
 . C PDEV U IO
 . ZSY "rm "_NDEV_" "_PDEV
 . ;
 .;DLW - Most of this code is ugly, but this loop is particulary ugly
 . N TSUB,J S TSUB="",J=1
 . F  S TSUB=$O(IHTML(TSUB)) Q:TSUB=""  D
 . . I IHTML(TSUB)["<body>" S IHTML(TSUB)=$P(IHTML(TSUB),"<body>")_$P(IHTML(TSUB),"<body>",2)
 . . I IHTML(TSUB)["</body>" S IHTML(TSUB)=$P(IHTML(TSUB),"</body>")_$P(IHTML(TSUB),"</body>",2)
 . . I IHTML(TSUB)'["<html",IHTML(TSUB)'["</html",IHTML(TSUB)'["<head",IHTML(TSUB)'["</head",IHTML(TSUB)'["<meta" D
 . . . S HTML(J)=IHTML(TSUB),J=J+1
 E  ZSY "rm "_NDEV S HTML(1)="ERROR"
 Q
 ;
DOCEMAIL(sessid) ;Send an email with the local CCR attached to a doctor
 N KBAWTO S KBAWTO=$$getRequestValue^%zewdAPI("docTo",sessid)
 Q:KBAWTO="" "Please fill in the To: field"
 ;Q:KBAWTO'["@" "Invalid email address"
 ;
 N KBAWFROM S KBAWFROM=$$getRequestValue^%zewdAPI("docFrom",sessid)
 Q:KBAWFROM["," "You need to use a dot (.) between the names in the From: field"
 Q:KBAWFROM="" "Please fill in the From: field"
 ;
 N KBAWSUBJ S KBAWSUBJ=$$getRequestValue^%zewdAPI("docSubject",sessid)
 Q:KBAWSUBJ="" "Please fill in the Subject: field"
 ;
 N KBAWBODY S KBAWBODY=$$getRequestValue^%zewdAPI("docMessage",sessid)
 Q:KBAWBODY="" "Please fill in the Message: field"
 ;
 ;Break the string into an array
 N I,KBAWMSG F I=1:1:$L(KBAWBODY,$C(10)) S KBAWTMSG(I)=$P(KBAWBODY,$C(10),I)
 S KBAWMSG=$NA(KBAWTMSG)
 ;
 ;MAILSEND^C0CMIME expects a VistA environment
 N U,DT,IO,DEV
 S U="^",DT=300
 N DUZ
 S DUZ=$$getSessionValue^%zewdAPI("DUZ",sessid)
 S DUZ("AG")="E"
 ;
 D mergeArrayFromSession^%zewdAPI(.KBAWXML,"XML",sessid)
 ;
 K KBAWXML(0)
 S KBAWTO(KBAWTO)="",KBAWATT=$NA(KBAWXML)
 ;API to send an email with an attachment via MailMan
 D MAILSEND^C0CMIME(.KBAWTEST,KBAWFROM,"KBAWTO",,KBAWSUBJ,KBAWMSG,KBAWATT)
 Q:KBAWTEST(1)'="OK" "Mail message failed to send"
 Q ""
 ;
PATEMAIL(sessid) ;Send an email with a local CCR attached to the patient
 N KBAWTO S KBAWTO=$$getRequestValue^%zewdAPI("patTo",sessid)
 Q:KBAWTO="" "Please fill in the To: field"
 ;Q:KBAWTO'["@" "Invalid email address"
 ;
 N KBAWFROM S KBAWFROM=$$getRequestValue^%zewdAPI("patFrom",sessid)
 ;Q:KBAWFROM["," "You need to use a dot (.) between the names in the From: field"
 Q:KBAWFROM="" "Please fill in the From: field"
 ;
 N KBAWSUBJ S KBAWSUBJ=$$getRequestValue^%zewdAPI("patSubject",sessid)
 Q:KBAWSUBJ="" "Please fill in the Subject: field"
 ;
 N KBAWBODY S KBAWBODY=$$getRequestValue^%zewdAPI("patMessage",sessid)
 Q:KBAWBODY="" "Please fill in the Message: field"
 ;
 ;Break the string into an array
 N I,KBAWMSG F I=1:1:$L(KBAWBODY,$C(10)) S KBAWTMSG(I)=$P(KBAWBODY,$C(10),I)
 S KBAWMSG=$NA(KBAWTMSG)
 ;
 ;MAILSEND^C0CMIME expects a VistA environment
 N U,DT,IO,DEV
 S U="^",DT=300
 N DUZ
 S DUZ=$$getSessionValue^%zewdAPI("DUZ",sessid)
 S DUZ("AG")="E"
 ;
 D mergeArrayFromSession^%zewdAPI(.KBAWXML,"XML",sessid)
 K KBAWXML(0)
 ;API to send an email with an attachment via MailMan
 S KBAWTO(KBAWTO)="",KBAWATT=$NA(KBAWXML)
 D MAILSEND^C0CMIME(.KBAWTEST,KBAWFROM,"KBAWTO",,KBAWSUBJ,KBAWMSG,KBAWATT)
 Q:KBAWTEST(1)'="OK" "Mail message failed to send"
 Q ""
 ;
 ; $RCSfile: C0ECCR.m $
