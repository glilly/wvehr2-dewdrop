C0CEWD   ; CCDCCR/GPL - CCR EWD utilities; 1/6/11
 ;;0.1;CCDCCR;nopatch;noreleasedate;Build 2
 ;Copyright 2011 George Lilly.  Licensed under the terms of the GNU
 ;General Public License See attached copy of the License.
 ;
 ;This program is free software; you can redistribute it and/or modify
 ;it under the terms of the GNU General Public License as published by
 ;the Free Software Foundation; either version 2 of the License, or
 ;(at your option) any later version.
 ;
 ;This program is distributed in the hope that it will be useful,
 ;but WITHOUT ANY WARRANTY; without even the implied warranty of
 ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ;GNU General Public License for more details.
 ;
 ;You should have received a copy of the GNU General Public License along
 ;with this program; if not, write to the Free Software Foundation, Inc.,
 ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 Q
 ;
TOKEN() ; EXTRINSIC WHICH RETURNS A NEW RANDOM TOKEN
 Q $$UUID^C0CUTIL ; USE THE UUID FUNCTION IN THE CCR PACKAGE
 ;
STORE(ZARY) ; STORE AN ARRAY OF VALUES INDEXED BY A NEW TOKEN
 ; IN ^TMP("C0E","TOKEN") FOR LATER RETRIEVAL FROM INSIDE AN EWD SESSION
 ; RETURNS THE TOKEN. ZARY IS PASSED BY NAME
 N ZT
 S ZT=$$TOKEN ; GET A NEW TOKEN
 M ^TMP("C0E","TOKEN",ZT)=@ZARY ;
 Q ZT
 ;
GET(C0ERTN,C0ETOKEN,NOKILL) ; RETRIEVE A STORED ARRAY INDEXED BY ZTOKEN
 ; KILL THE ARRAY AFTER RETRIEVAL UNLESS NOKILL=1
 ; C0ERTN IS PASSED BY NAME
 I '$D(^TMP("C0E","TOKEN",C0ETOKEN)) D  Q  ; DOESN'T EXIST
 . S @C0ERTN="" ; PASS BACK NULL
 M @C0ERTN=^TMP("C0E","TOKEN",C0ETOKEN) ; RETRIEVE
 I $G(NOKILL)'=1 K ^TMP("C0E","TOKEN",C0ETOKEN) ; DELETE
 Q
 ;
URLTOKEN(sessid) ; EXTRINSIC WHICH RETRIEVES THE TOKEN PASSED ON THE URL
 ; IN EWD EXAMPLE: https://example.com/ewd/myApp/index.ewd?token="12345"
 N token
 S token=""
 s token=$$getRequestValue^%zewdAPI("token",sessid)
 s token=$tr(token,"""") ; strip out quotes
 Q token
 ;
cbTestMethod(prefix,seedValue,lastSeedValue,optionNo,options)
 ;
 n maxNo,noFound
 ;
 s maxNo=50
 s noFound=0
 f  s seedValue=$o(^DPT("B",seedValue)) q:seedValue=""  q:noFound=maxNo  d
 . s lastSeedValue=seedValue
 . i prefix'="",$e(seedValue,1,$l(prefix))'=prefix q
 . s optionNo=optionNo+1
 . s noFound=noFound+1
 . s options(optionNo)=seedValue
 QUIT
 ;
set1 ;
 s ^zewd("comboPlus","methodMap","test")="cbTestMethod^C0PEREW"
 q
 ;
test1(sessid) ;
 d setSessionValue^%zewdAPI("testing","ZZ",sessid)
 q 0
 ;
