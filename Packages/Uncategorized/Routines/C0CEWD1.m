C0CEWD1   ; CCDCCR/GPL - CCR FILEMAN utilities; 12/6/08
 ;;0.1;CCDCCR;nopatch;noreleasedate;Build 2
 ;Copyright 2009 George Lilly.  Licensed under the terms of the GNU
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
TEST(filepath) ; filepath IS THE PATH/FILE TO BE READ IN
 i $g(^%ZISH)["" d  ; if the VistA Kernal routine %ZISH exists
 . n zfile,zpath,ztmp s (zfile,zpath,ztmp)=""
 . s zfile=$re($p($re(filepath),"/",1)) ;file name
 . s zpath=$p(filepath,zfile,1) ; file path
 . s ztmp=$na(^CacheTempEWD($j,0))
 . s ok=$$FTG^%ZISH(zpath,zfile,ztmp,2) ; import the file incrementing subscr 2
 q
 ;
TEST2 ;
 s zfilepath="/home/vademo2/CCR/PAT_780_CCR_V1_0_17.xml"
 ;s ok=$$gtmImportFile^%zewdHTMLParser(zfilepath)
 s ok=$$LOAD(zfilepath) ;load the XML file to the EWD global
 s ok=$$parseDocument^%zewdHTMLParser("DerekDOM",0)
 ;s ok=$$parseXMLFile^%zewdAPI(zfilepath,"fourthDOM")
 w ok,!
 q
 ;
LOAD(filepath) ; load an xml file into the EWD global for DOM processing
 ; need to call s error=$$parseDocument^%zewdHTMLParser(docName,isHTML)
 ; after to process it to the DOM - isHTML=0 for XML files
 n i
 i $g(^%ZISH)["" d  QUIT i ; if VistA Kernal routine %ZISH exists - gpl 2/23/09
 . n zfile,zpath,ztmp,zok s (zfile,zpath,ztmp)=""
 . s zfile=$re($p($re(filepath),"/",1)) ;file name
 . s zpath=$p(filepath,zfile,1) ; file path
 . s ztmp=$na(^CacheTempEWD($j,0))
 . s zok=$$FTG^%ZISH(zpath,zfile,ztmp,2) ; import the file increment subscr 2
 . s i=$o(^CacheTempEWD($j,""),-1) ; highest line number
 q i
 ;
Q(ZQ,ZD) ; SEND QUERY ZQ TO DOM ZD AND DIPLAY NODES RETURNED
 I '$D(ZD) S ZD="DerekDOM"
 s error=$$select^%zewdXPath(ZQ,ZD,.nodes) ;
 d displayNodes^%zewdXPath(.nodes)
 q
 ;
GET1URL0(URL) ;
 s ok=$$httpGET^%zewdGTM(URL,.gpl)
 D INDEX^C0CXPATH("gpl","gpl2")
 W !,"S URL=""",URL,"""",!
 S G=""
 F  S G=$O(gpl2(G)) Q:G=""  D  ;
 . W " S VDX(""",G,""")=""",gpl2(G),"""",!
 W !
 Q
