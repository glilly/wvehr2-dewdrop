C0EVCOM ;FWSLC/DLW-VistACom EWD pageScripts; 6/6/12 12:24pm
 ;;0.1;EWD VistACom App;****LOCL RTN**;
 ;
 ; Written by David Wicksell <dlw@linux.com>
 ; Copyright © 2010 Fourth Watch Software, LC
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
 ; $Source: repository:/home/src/VistACom/p/C0EVCOM.m $
 ; $Revision: [] [43:4a41e90eb6f4] 2011-10-28 14:11 -0600 $
 ;
 ; Patient lookup utilities for EWD/Sencha Touch
 ; Set up the tabPanel in the portal page
 ;
 ;
COMBOLST(prefix,options) ;Generates the list of patients for the combo box
 N U S U="^"
 ;
 S prefix=$$zcvt^%zewdAPI(prefix,"U")
 ;
 ;Generate the list of patients in the combo box to match what the user typed
 ;Using the patient XREF
 ;
 N PAT S PAT=prefix
 I prefix'="" S PAT=$O(^DPT("B",prefix),-1)
 N N,FL S N=1,FL=0
 F  S PAT=$O(^DPT("B",PAT)) D  Q:PAT=""!(FL)!(N>500)
 . I $E(PAT,1,$L(prefix))'=prefix S FL=1 Q
 . S options(N)=PAT,N=N+1
 Q
 ;
PORTAL(sessid) ;Need to add specific code to create the contents of the TAB
 N U S U="^"
 N PTNAME,DFN
 N ERR
 S ERR="javascript:Ext.getCmp('fPatsBtn').setDisabled(false); EWD.ajax.alert('"
 ;
 I $$getSessionValue^%zewdAPI("CPRS",sessid)=1 D
 . S DFN=$$getSessionValue^%zewdAPI("DFN",sessid)
 . S PTNAME=$P(^DPT(DFN,0),"^")
 . D setSessionValue^%zewdAPI("page","cprs",sessid)
 . D setSessionValue^%zewdAPI("panel","cardPanel",sessid)
 . D setSessionValue^%zewdAPI("parentPanel","mainPanel",sessid)
 E  D  Q:PTNAME="" ERR_"Please choose a patient');"
 . S PTNAME=$$getRequestValue^%zewdAPI("patient",sessid)
 . S:PTNAME="" PTNAME=$$getSessionValue^%zewdAPI("patientName",sessid)
 . Q:PTNAME=""
 . S DFN=$O(^DPT("B",PTNAME,0))
 . D setSessionValue^%zewdAPI("page","login",sessid)
 . D setSessionValue^%zewdAPI("panel","patPanel",sessid)
 . D setSessionValue^%zewdAPI("parentPanel","cardPanel",sessid)
 ;
 Q:DFN="" ERR_"Not a valid patient');"
 ;
 D setSessionValue^%zewdAPI("DFN",DFN,sessid)
 S PTNAME=$$zcvt^%zewdAPI(PTNAME,"U")
 D setSessionValue^%zewdAPI("patientName",PTNAME,sessid)
 ;
 ;Call individual APIs to generate all the tab content and return err if any
 N MAIL S MAIL=$$IN^C0EMAIL(sessid)
 Q:MAIL'="" MAIL 
 N FILE S FILE=$$FILELIST^C0EPTFL(sessid)
 Q:FILE'="" FILE 
 N QINIT S QINIT=$$qinit^C0EMUAT(sessid)
 Q:QINIT'="" QINIT
 N MUINIT S MUINIT=$$muinit^C0EMUAT(sessid)
 Q:MUINIT'="" MUINIT
 N MODAL S MODAL=$$MODAL(sessid)
 Q:MODAL'="" MODAL
 Q ""
 ;
MODAL(sessid) ;Prepopulate the modal panels
 N USRNAME S USRNAME=$$getSessionValue^%zewdAPI("userName",sessid)
 S USRNAME=$TR(USRNAME,",",".")
 ;
 D setSessionValue^%zewdAPI("docFrom",USRNAME,sessid)
 D setSessionValue^%zewdAPI("patFrom",USRNAME,sessid)
 ;
 N SUBJECT S SUBJECT="Urgent: CCR Attached"
 N MESSAGE S MESSAGE="This is a Continuity of Care Record.\n"
 S MESSAGE=MESSAGE_"This email is private. Thank you"
 ;
 D setSessionValue^%zewdAPI("docSubject",SUBJECT,sessid)
 D setSessionValue^%zewdAPI("patSubject",SUBJECT,sessid)
 D setSessionValue^%zewdAPI("docMessage",MESSAGE,sessid)
 D setSessionValue^%zewdAPI("patMessage",MESSAGE,sessid)
 Q ""
 ;
STREAM(DOC,sessid) ;Stream an XML document into an EWD application DOM
 N TYPE
 I DOC=("displayCCR"_$J) D
 . S TYPE=$$getSessionValue^%zewdAPI("type",sessid)
 . S DOC=$$getSessionValue^%zewdAPI("displayCCR",sessid)
 E  I DOC=("xmlDocument"_$J) D
 . S TYPE=$$getSessionValue^%zewdAPI("file",sessid)
 E  D
 . S TYPE="CCR"
 ;
 N IO S IO=$IO
 U IO:WIDTH=1048576 ;Set device's logical record size to the max
 ;
 N OK
 S OK=$$outputDOM^%zewdDOM(DOC,"11:xml",0)
 I $G(OK)]"" W "Ext.Msg.alert('Error', '"_OK_"');"_$C(13,10)
 ;
 I TYPE="CCR" S OK=$$outputDOM^%zewdDOM("ccrxsl","11:xslt",0)
 E  I TYPE="CCD" S OK=$$outputDOM^%zewdDOM("cdaxsl","11:xslt",0)
 I $G(OK)]"" W "Ext.Msg.alert('Error', '"_OK_"');"_$C(13,10)
 ;
 N ERR
 S ERR=$$removeDocument^%zewdDOM(DOC)
 I $G(ERR)'=DOC W "Ext.Msg.alert('Error', '"_ERR_"');"_$C(13,10)
 Q
 ;
 ; $RCSfile: C0EVCOM.m $
