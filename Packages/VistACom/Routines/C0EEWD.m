C0EEWD ;FWSLC/DLW-EWD/Sencha Touch utilities; 6/4/12 10:57pm
 ;;0.1;EWD UTILS;****LOCL RTN**;
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
 ; $Source: repository:/home/src/VistACom/p/C0EEWD.m $
 ; $Revision: [] [43:4a41e90eb6f4] 2011-10-28 14:11 -0600 $
 ;
 ; Utilities to allow EWD to be a front end for VistA
 ; Login via CPRS or from a Web browser
 ;
 ;
INIT(sessid) ;Initialize an EWD/CPRS session
 ;Modified from C0CEVC, written by GPL
 ;
 D setSessionValue^%zewdAPI("CPRS",0,sessid)
 ;
 N TOKEN,DFN,DUZ,USRNAME,PNAME
 S TOKEN=$$URLTOKEN(sessid)
 I TOKEN="" D setSessionValue^%zewdAPI("nextPage","login",sessid) Q ""  ;No CPRS
 ;
 D setSessionValue^%zewdAPI("CPRS",1,sessid) ;Coming in via CPRS
 ;
 S DFN=$$PARSETOK(TOKEN) ;Parse the token and look up the DFN
 I DFN=0 S DFN=2 ;Default test patient, shouldn't be needed
 ;
 S DUZ=$$GETDUZ(TOKEN) ;Hack to get the DUZ via the token's $J, C0EWPS for info
 S:DUZ="" DUZ=2
 ;
 S USRNAME=$P(^VA(200,DUZ,0),"^")
 S PNAME=$P(USRNAME,",",2)_" "_$P(USRNAME,",")
 ;
 D setSessionValue^%zewdAPI("DUZ",DUZ,sessid)
 D setSessionValue^%zewdAPI("userName",USRNAME,sessid)
 D setSessionValue^%zewdAPI("displayName",PNAME,sessid)
 D setSessionValue^%zewdAPI("DFN",DFN,sessid)
 D setSessionValue^%zewdAPI("nextPage","portal",sessid)
 Q ""
 ;
LOGIN(sessid) ;Durable EWD/Sencha VistA access script
 ;Added a bit more smarts to it, it now deals with inactive or disabled users
 ;Still more work to be done, however
 N U S U="^"
 N X D NOW^%DTC S DT=X
 N IO,IOF,IOM,ION,IOS,IOSL,IOST,IOT,POP
 S (IO,IO(0),IOF,IOM,ION,IOS,IOSL,IOST,IOT)="",POP=0
 ;
 N ERR
 S ERR="javascript:Ext.getCmp('fLoginBtn').setDisabled(false); EWD.ajax.alert('"
 ;
 N V4WACC S V4WACC=$$getRequestValue^%zewdAPI("accessCode",sessid)
 Q:V4WACC="" ERR_"Please enter your Access Code');"
 ;
 N V4WVER S V4WVER=$$getRequestValue^%zewdAPI("verifyCode",sessid)
 Q:V4WVER="" ERR_"Please enter your Verify Code');"
 N V4WAVC S V4WAVC=V4WACC_";"_V4WVER,V4WAVC=$$ENCRYP^XUSRB1(V4WAVC)
 ;
 D SETUP^XUSRB()
 N DUZ,V4WUSER D VALIDAV^XUSRB(.V4WUSER,V4WAVC)
 S V4WDUZ=V4WUSER(0)
 ;
 N V4WTR S V4WTR=""
 I 'V4WDUZ,$G(DUZ) S V4WTR=": "_$$GET1^DIQ(200,DUZ_",",9.4) ;Termination reason
 Q:'V4WDUZ ERR_V4WUSER(3)_V4WTR_"');"
 ;
 N USRNAME,PNAME
 S USRNAME=$P(^VA(200,V4WDUZ,0),"^")
 S PNAME=$P(USRNAME,",",2)_" "_$P(USRNAME,",")
 ;
 D setSessionValue^%zewdAPI("DUZ",V4WDUZ,sessid)
 D setSessionValue^%zewdAPI("userName",USRNAME,sessid)
 D setSessionValue^%zewdAPI("displayName",PNAME,sessid)
 Q ""
 ;
URLTOKEN(sessid) ;Retrieve the token passed in the URL in CPRS
 ;Modified from C0CEWD by GPL
 N TOKEN S TOKEN=$$getRequestValue^%zewdAPI("token",sessid)
 S TOKEN=$TR(TOKEN,"""") ;Strip out the quotes
 Q TOKEN
 ;
PARSETOK(TOKEN) ;Parses the token sent by CPRS and returns the DFN 
 ;Modified from C0CEVC by GPL
 ; Eg. ^TMP('ORWCHART',6547,'192.168.1.41',002E0FE6)
 N NUM1,IP,NUM2,DFN,GLOBAL
 S DFN=0 ;Default return
 S NUM1=$P(TOKEN,",",2) ;First number
 S IP=$P(TOKEN,",",3) ;Ip number
 S IP=$P(IP,"'",2) ;Get rid of '
 S NUM2=$P(TOKEN,",",4) ;Second number
 S NUM2=$P(NUM2,")") ;Get rid of )
 S GLOBAL=$NA(^TMP("ORWCHART",NUM1,IP,NUM2)) ;Build the global name
 I $G(@GLOBAL)'="" S DFN=@GLOBAL ;Access the global
 Q DFN
 ;
GETDUZ(TOKEN) ;Hack to get the DUZ for VistACom
 N NUM1,DUZ
 S NUM1=$P(TOKEN,",",2) ;First number
 S DUZ=$G(^TMP("ZEWD",NUM1,"DUZ")) ;DUZ stored in here, via C0EWPS
 Q DUZ
 ;
ERROR ;Call the VistA error trap and then display the error on the screen
 S $ZT="H" ;If we have an error in here, abandon all hope and kill the process
 D ^%ZTER ;VistA error trap
 ZG $ZL:prePageError^%zewdPHP ;EWD prePage error trap
 Q  ;We'll never get here
 ;
 ; $RCSfile: C0EEWD.m $
