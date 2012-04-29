C0EMAIL ;FWSLC/DLW-EWD/Mail generator; 1/19/12 6:48pm
 ;;0.1;EWD UTILS;****LOCL RTN**;
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
 ; $Source: repository:/home/src/VistACom/p/C0EMAIL.m $
 ; $Revision: [1.1.1] [46:c470103d14e0] 2011-10-28 18:22 -0600 $
 ;
 ; Script to create the mail list, display the body of a message,
 ; display any CCR/CCD attachments, and save an attachment to the mail box
 ;
 ;
IN(sessid) ;Create the list of incoming mail messages
 N DUZ,RMAIL
 S DUZ=$$getSessionValue^%zewdAPI("DUZ",sessid)
 ;
 ;API to get general info about the message inbox for a DUZ
 D GETMSG^C0CMAIL2(.RMAIL,DUZ)
 ;
 ;Create the mail inbox with pertinent information formatted correctly
 N MAIL,TDATE,M,MONTH,DAY,YEAR,DATE,FROM,SUBJECT
 N I,MSG,TOTAL,NUM,TEST,ATTACH S MSG=1,NUM=0
 F I=1:1 S MSG=$O(RMAIL("IN","MSG",MSG)) Q:MSG=""  D
 . S TDATE=RMAIL("IN","MSG",MSG,"CREATED")
 . S M=$E(TDATE,4,5)
 . S M=$S(M="01":"Jan",M="02":"Feb",M="03":"Mar",M="04":"Apr",1:M)
 . S M=$S(M="05":"May",M="06":"Jun",M="07":"Jul",M="08":"Aug",1:M)
 . S MONTH=$S(M="09":"Sep",M="10":"Oct",M="11":"Nov",M="12":"Dec",1:M)
 . S DAY=$E(TDATE,6,7)
 . S YEAR=$E(TDATE,1,3)+1700
 . S DATE=MONTH_" "_DAY_", "_YEAR_"&nbsp;&nbsp;"
 . S FROM="FROM: "_$TR(RMAIL("IN","MSG",MSG,"FROM"),"<>","")
 . S:FROM="FROM: " FROM="FROM: Unknown"
 . S TOTAL=25-$L(FROM)
 . I TOTAL'>0 S FROM=$E(FROM,1,20)_"...&nbsp;&nbsp;",SP="" ;Proper spacing
 . E  N J,SP F J=1:1:TOTAL S SP=$G(SP)_"&nbsp;" ;Proper spacing
 . S SUBJECT="SUBJECT: "_RMAIL("IN","MSG",MSG,"TITLE")
 . S MAIL(I,"text")=DATE_FROM_SP_SUBJECT
 . S MAIL(I,"text")=$TR(MAIL(I,"text"),"""","") ;Get rid of quotes
 . S MAIL(I,"msgNum")=MSG
 . S TEST=$G(RMAIL("IN","MSG",MSG,"SEG",0,"CONT",0,"Disposition"))["attachment"
 .;S ATTACH=$S(TEST:"*",1:"&nbsp;")_"&nbsp;&nbsp;"
 . S ATTACH=$S(TEST:"+",1:"&nbsp;")_"&nbsp;&nbsp;"
 . S MAIL(I,"text")=ATTACH_MAIL(I,"text")
 . S NUM=NUM+1
 N SMAIL,SUB,I S SUB=""
 F I=1:1 S SUB=$O(MAIL(SUB),-1) Q:SUB=""  D
 . S SMAIL(I,"text")=MAIL(SUB,"text")
 . S SMAIL(I,"msgNum")=MAIL(SUB,"msgNum")
 ;
 N MSGS S MSGS="Message"_$S(NUM=1:"",1:"s")
 ;
 D setSessionValue^%zewdAPI("msgDisp",MSGS,sessid)
 D setSessionValue^%zewdAPI("mailNum",NUM,sessid)
 D saveListToSession^%zewdSTAPI(.SMAIL,"mailMsgList",sessid)
 Q ""
 ;
MAIL(sessid) ;Display the mail message body
 N NUM,LIST,MSGNUM,MSGTITLE
 S NUM=$$getRequestValue^%zewdAPI("listItemNo",sessid)
 D mergeArrayFromSession^%zewdAPI(.LIST,"mailMsgList",sessid)
 S MSGNUM=$G(LIST(NUM,"msgNum")) ;Mail message number selected
 S MSGTITLE=$G(LIST(NUM,"text"))
 ;
 D setSessionValue^%zewdAPI("msgNum",MSGNUM,sessid)
 ;
 ;I $E(MSGTITLE)="*" D
 I $E(MSGTITLE)="+" D
 . D setSessionValue^%zewdAPI("attachment","true",sessid)
 . S MSGTITLE=$E(MSGTITLE,14,$L(MSGTITLE))
 E  D
 . D setSessionValue^%zewdAPI("attachment","false",sessid)
 . S MSGTITLE=$E(MSGTITLE,19,$L(MSGTITLE))
 ;
 D setSessionValue^%zewdAPI("mailHeader",MSGTITLE,sessid)
 ;
 N NUM S NUM=$$parseContents^vistAComEWD(MSGNUM,.META)
 ;
 S BODY(1)="<pre>"
 N N,I,M S (N,M)=0,I=2
 F  S N=$O(META("attachment",N)) Q:N=""!(M="")  D
 . I META("attachment",N,"mimeType")="text/plain" D
 . . F I=I:1 S M=$O(META("attachment",N,"content",M)) Q:M=""  D
 . . . S BODY(I)=META("attachment",N,"content",M)_$C(13,10)
 S BODY(I)="</pre>"
 ;
 D deleteFromSession^%zewdAPI("mailMessage",sessid)
 D mergeArrayToSession^%zewdAPI(.BODY,"mailMessage",sessid)
 Q ""
 ;
DISPLAY(sessid) ;Display the CCR/CCD attachment
 N MSGNUM S MSGNUM=$$getSessionValue^%zewdAPI("msgNum",sessid)
 ;
 N ERR
 S ERR="javascript:Ext.getCmp('attachBtn').setDisabled(false); EWD.ajax.alert('"
 ;
 ;Changed mail parser to also store as a flat XML, for storing in ^C0CIN
 N NUM S NUM=$$parseContents^vistAComEWD(MSGNUM,.META,"NXML")
 I NUM<2 Q ERR_"Missing XML document"_"');"
 Q:$E($G(NXML),1,3)="ERR" ERR_$P(NXML,":",2)_"');" ;Error parsing
 ;
 N SUB S SUB="",QUIT=0,SAVSUB=2 ;2 is sort of a safe default for SAVSUB
 F  S SUB=$O(META("attachment",SUB)) Q:QUIT!(SUB="")  D
 . I META("attachment",SUB,"mimeType")="text/xml" S QUIT=1,SAVSUB=SUB
 ;
 N TYPE S TYPE=META("attachment",SAVSUB,"docType")
 S TYPE=$$zcvt^%zewdAPI(TYPE,"U")
 D setSessionValue^%zewdAPI("type",TYPE,sessid)
 ;
 N DISPXML S DISPXML=META("attachment",SAVSUB,"docName")
 D setSessionValue^%zewdAPI("displayCCR",DISPXML,sessid)
 ;
 ;outputDOM sometimes breaks < and / - uses a temp file with "array"
 N NXML,OK S OK=$$outputDOM^%zewdDOM(DISPXML,,1,"array",,"NXML")
 ZSY "rm zewdTempDOM.txt" ;remove temporary file
 ;N NXML,OK S OK=$$outputDOM^%zewdDOM(DISPXML,,1,,,"NXML")
 I $G(OK)]"" Q ERR_OK_"');"
 ;
 ;Temporary fix to pass testing
 ;N N S N="" F  S N=$O(NXML(N)) Q:N=""  D
 ;. I NXML(N)="<" S NXML(N)="<"_NXML(N+1),NXML(N+1)=""
 ;
 D deleteFromSession^%zewdAPI("displayXML",sessid)
 D mergeArrayToSession^%zewdAPI(.NXML,"displayXML",sessid)
 ;
 K ^CacheTempEWD($J)
 ;
 N XSLT,FILE I TYPE="CCR" S XSLT="ccrxsl",FILE="www/css/ccr.xsl"
 E  S XSLT="cdaxsl",FILE="www/css/cda.xsl"
 ;
 D listDOMs^%zewdDOM(.LIST)
 S OK=""
 I '$D(LIST(XSLT)) D
 .; S OK=$$parseXMLFile^%zewdAPI(FILE,XSLT)
 . S OK=$$parseFile^%zewdHTMLParser(FILE,XSLT,,,0) ;Use this one!
 I OK]"" Q ERR_OK_"');"
 ;
 D setSessionValue^%zewdAPI("displayXMLType",TYPE,sessid)
 ;
 Q ""
 ;
SAVE(sessid) ;Save the CCR/CCD mail attachment to a patient's inbox
 N SAVENAME,DFN
 S SAVENAME=$$getRequestValue^%zewdAPI("savePatient",sessid)
 S SAVENAME=$$zcvt^%zewdAPI(SAVENAME,"U")
 Q:SAVENAME="" "Please choose a patient"
 ;
 S DFN=$O(^DPT("B",SAVENAME,0))
 Q:DFN="" "Not a valid patient"
 ;
 N DUZ,FROM,ARRAY
 S DUZ=$$getSessionValue^%zewdAPI("DUZ",sessid)
 S FROM=$$getSessionValue^%zewdAPI("mailFrom",sessid)
 S TYPE=$$getSessionValue^%zewdAPI("type",sessid)
 ;
 D mergeArrayFromSession^%zewdAPI(.ARRAY,"displayXML",sessid)
 ;
 ;API that saves the XML file to the patient's file
 D SAVE^C0EIN(DFN,DUZ,FROM,,,TYPE,.ARRAY)
 ;If call fails, Q "" with the fail message, ask Zach to implement
 ;
 D setSessionValue^%zewdAPI("savePatient",SAVENAME,sessid)
 Q ""
 ;
 ; $RCSfile: C0EMAIL.m $
