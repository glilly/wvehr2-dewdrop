vistAComEWD ; EWD Support module for VistACom to extract and parse XML documents in emails ; 11/3/11 12:03pm
 ;
 ;
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-11 M/Gateway Developments Ltd,                        |
 ; | Reigate, Surrey UK.                                                      |
 ; | All rights reserved.                                                     |
 ; |                                                                          |
 ; | http://www.mgateway.com                                                  |
 ; | Email: rtweed@mgateway.com                                               |
 ; |                                                                          |
 ; | This program is free software: you can redistribute it and/or modify     |
 ; | it under the terms of the GNU Affero General Public License as           |
 ; | published by the Free Software Foundation, either version 3 of the       |
 ; | License, or (at your option) any later version.                          |
 ; |                                                                          |
 ; | This program is distributed in the hope that it will be useful,          |
 ; | but WITHOUT ANY WARRANTY; without even the implied warranty of           |
 ; | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            |
 ; | GNU Affero General Public License for more details.                      |
 ; |                                                                          |
 ; | You should have received a copy of the GNU Affero General Public License |
 ; | along with this program.  If not, see <http://www.gnu.org/licenses/>.    |
 ; ----------------------------------------------------------------------------
 ;
 ;
 QUIT
 ;
parseContents(emailNo,metaData,array)
 ;
 ; Do not use ewdXML as your value for array, in the argument list
 ;
 n ewdXML ;DLW
 s array=$g(array) ;DLW
 i array'="" s ewdXML=1 ;DLW
 e  s ewdXML=0 ;DLW
 ;
 n attachmentNo,base64,ref,req,lineNo,mimeType,no,noOfAttachments,stop,top
 ;
 i $g(emailNo)="" QUIT "Email Number not defined"
 i '$d(^XMB(3.9,emailNo)) QUIT "No such email number in ^XMB(3.9)"
 ;
 s top=$g(^XMB(3.9,emailNo,0))
 s metaData("created")=$p(top,"^",3)
 s metaData("from")=$p(top,"^",2)
 s metaData("title")=$p(top,"^",1)
 s no=0
 f  s no=$o(^XMB(3.9,emailNo,6,no)) q:no=""  q:no'?1N.N  d
 . s metaData("to",no)=$g(^XMB(3.9,emailNo,6,no,0))
 . s metaData("to name",no)=$g(^XMB(3.9,emailNo,6,no,0))
 ;
 k ^CacheTempMail($j)
 s ref="^XMB(3.9,"_emailNo_","""")"
 s req="^XMB(3.9,"_emailNo
 s lineNo=0,stop=0
 f  d  q:stop
 . s ref=$q(@ref)
 . i ref="" s stop=1 q
 . i ref'[req s stop=1 q
 . s lineNo=lineNo+1
 . s ^CacheTempMail($j,"email",lineNo)=@ref
 ;
 s noOfAttachments=$$getAttachments()
 f attachmentNo=1:1:noOfAttachments d
 . s mimeType=$g(^CacheTempMail($j,"attachments",attachmentNo,"mimeType"))
 . s base64=$g(^CacheTempMail($j,"attachments",attachmentNo,"base64"))
 . s metaData("attachment",attachmentNo,"mimeType")=mimeType
 . i mimeType="text/plain" d  q
 . . m metaData("attachment",attachmentNo,"content")=^CacheTempMail($j,"attachments",attachmentNo,"content")
 . . k ^CacheTempMail($j,"attachments",attachmentNo,"content")
 . q:'ewdXML
 . i mimeType["text/xml",base64'="true" d  q
 . . n buf,line,lineNo,no,ok
 . . n type ;DLW
 . . k ^CacheTempEWD($j)
 . . ;m ^CacheTempEWD($j)=^CacheTempMail($j,"attachments",attachmentNo,"content")
 . . s lineNo="",buf="",no=0
 . . s type="ccr" ;DLW
 . . f  s lineNo=$o(^CacheTempMail($j,"attachments",attachmentNo,"content",lineNo)) q:lineNo=""  d
 . . . s line=^CacheTempMail($j,"attachments",attachmentNo,"content",lineNo)
 . . . s line=$$replaceAll^%zewdAPI(line,"=3D","=")
 . . .;s line=$$replaceAll^%zewdAPI(line,"=2E",".") ;DLW
 . . . i $e(line,$l(line)-2,$l(line))="=09" d
 . . . . s line=$$replaceAll^%zewdAPI(line,"=09",$c(9)) ;DLW
 . . . i $e(line,$l(line)-2,$l(line))="=20" d
 . . . . s line=$$replaceAll^%zewdAPI(line,"=20"," ") ;DLW
 . . . i line["<ClinicalDocument" s type="ccd" ;DLW
 . . . i $e(line,$l(line))="=" d
 . . . . s buf=buf_$e(line,1,$l(line)-1)
 . . . e  d
 . . . . s buf=buf_line
 . . . . s no=no+1
 . . . . s ^CacheTempEWD($j,no)=buf
 . . . . s buf=""
 . . ;s ok=$$parseDocument^%zewdHTMLParser("ccr"_attachmentNo,0)
 . . i ewdXML k @array m @array=^CacheTempEWD($j) ;DLW
 . . i ewdXML,'$d(^CacheTempEWD($j)) s @array="ERR:Malformed XML Document" q  ;DLW
 . . s ok=$$parseDocument^%zewdHTMLParser(type_attachmentNo,0) ;DLW
 . . i ok="" d
 . . . ;s metaData("attachment",attachmentNo,"docName")="ccr"_attachmentNo
 . . . s metaData("attachment",attachmentNo,"docName")=type_attachmentNo ;DLW
 . . . s metaData("attachment",attachmentNo,"docType")=type ;DLW
 . . . k ^CacheTempMail($j,"attachments",attachmentNo)
 . i mimeType["text/xml",base64="true" d  q
 . . n buff,line,no,ok
 . . d decode(attachmentNo)
 . . k ^CacheTempEWD($j)
 . . n type ;DLW
 . . s lineNo=""
 . . s buff=""
 . . s no=""
 . . s type="ccr" ;DLW
 . . f  s lineNo=$o(^CacheTempContent($j,lineNo)) q:lineNo=""  d
 . . . s line=^CacheTempContent($j,lineNo)
 . . . s line=$$replaceAll^%zewdAPI(line,$c(10),"")
 . . . s line=$$replaceAll^%zewdAPI(line,$c(13),"") ;DLW
 . . . i line["<ClinicalDocument" s type="ccd" ;DLW
 . . . i $l(buff)>1500 d  ;DLW 2000 to 1500
 . . . . i line[">" d
 . . . . . n p1,p2
 . . . . .;s p1=$p(line,">",1)_">"
 . . . . .;s p2=$p(line,">",2,1500)
 . . . . . s p1=$p(line,">",1,$l(line,">")-1)_">" ;DLW
 . . . . . s p2=$p(line,">",$l(line,">"),$l(line)) ;DLW
 . . . . . s buff=buff_p1
 . . . . . s no=no+1
 . . . . . s ^CacheTempEWD($j,no)=buff
 . . . . . s buff=p2
 . . . . e  d
 . . . . . s buff=buff_line
 . . . . . i $l(buff)>1000 d  ;DLW
 . . . . . . n p1,p2 ;DLW
 . . . . . . s p1=$p(buff," ",1,$l(buff," ")-1)_" " ;DLW
 . . . . . . s p2=$p(buff," ",$l(buff," "),$l(buff)) ;DLW
 . . . . . . s buff=p1 ;DLW
 . . . . . . s no=no+1 ;DLW
 . . . . . . s ^CacheTempEWD($j,no)=buff ;DLW
 . . . . . . s buff=p2 ;DLW
 . . . e  d
 . . . . s buff=buff_line
 . . i buff'="" d
 . . . s no=no+1
 . . . s ^CacheTempEWD($j,no)=buff
 . . ;s ok=$$parseDocument^%zewdHTMLParser("ccr"_attachmentNo,0)
 . . i ewdXML k @array m @array=^CacheTempEWD($j) ;DLW
 . . i ewdXML,'$d(^CacheTempEWD($j)) s @array="ERR:Malformed XML Document" q  ;DLW
 . . s ok=$$parseDocument^%zewdHTMLParser(type_attachmentNo,0) ;DLW
 . . i ok="" d
 . . . ;s metaData("attachment",attachmentNo,"docName")="ccr"_attachmentNo
 . . . s metaData("attachment",attachmentNo,"docName")=type_attachmentNo ;DLW
 . . . s metaData("attachment",attachmentNo,"docType")=type ;DLW
 . . . k ^CacheTempMail($j,"attachments",attachmentNo)
 . ;break  ; mimetype!
 ;
 QUIT noOfAttachments
 ;
getAttachments() ; get attachments from message
 ;
 n attachmentLineNo,boundary,boundaryText,endLine,found,i,lastPart,line,lineNo,noOfParts
 n part,partNo,started,startLine,stop,ucLine
 ;
 s lineNo=$o(^CacheTempMail($j,"email",""),-1)
 s stop=0,boundary=""
 k ^CacheTempMail($j,"Attachments")
 ;
 ; Get the boundary string
 ;
 f i=1:1:lineNo d  q:boundary'=""
 . s line=^CacheTempMail($J,"email",i)
 . s ucLine=$zconvert(line,"u")
 . i ucLine["CONTENT-TYPE: MULTIPART/MIXED" d
 . . s boundary=$$getDirectiveValue("Content-Type","boundary",i)
 ;
 s partNo=0
 i boundary="" d
 .  f i=1:1:lineNo d  q:boundary'=""
 . . s line=^CacheTempMail($J,"email",i)
 . . i $e(line,1,2)="--" s boundary=line
 ;
 i boundary="" QUIT partNo
 ;
 ;Now find the boundary places and the file types etc
 ;
 f i=1:1:lineNo d
 . s line=^CacheTempMail($j,"email",i)
 . s ucLine=$zconvert(line,"u")
 . i line[boundary,ucLine'["BOUNDARY=" d
 . . s partNo=partNo+1
 . . s part(partNo,"start")=i+1
 . . i partNo>1 s part(partNo-1,"end")=i-1
 . i ucLine["CONTENT-DISPOSITION" d  q
 . . n filename
 . . s filename=$$getDirectiveValue("Content-Disposition","filename",i)
 . . ;i partNo=0 break  ; 1
 . . s part(partNo,"filename")=filename
 . i ucLine["CONTENT-TYPE: MULTIPART/ALTERNATIVE" d  q
 . . n altBoundary
 . . s altBoundary=$$getDirectiveValue("Content-Type","boundary",i)
 . . i altBoundary'="" d
 . . . ;i partNo=0 break  ; 2
 . . . s part(partNo,"altBoundary")=altBoundary
 . i ucLine["CONTENT-TYPE: MULTIPART/SIGNED" d  q
 . . n altBoundary
 . . s altBoundary=$$getDirectiveValue("Content-Type","boundary",i)
 . . i altBoundary'="" d
 . . . ;i partNo=0 break  ; 3
 . . . s part(partNo,"altBoundary")=altBoundary
 . i ucLine["CONTENT-TYPE" d  q
 . . n mimeType
 . . s mimeType=$p(line,": ",2)
 . . s mimeType=$p(mimeType,"; ",1)
 . . i $e($re(mimeType),1)=";" s mimeType=$e(mimeType,1,$l(mimeType)-1)
 . . ;i partNo=0 break  ;4
 . . s part(partNo,"mimeType")=mimeType
 . i ucLine["CONTENT-TRANSFER-ENCODING",ucLine["BASE64" d
 . . s part(partNo,"base64")="true"
 ;
 i $g(part(partNo,"start"))'="",'$d(part(partNo,"end")) k part(partNo) s partNo=partNo-1
 ;
 ; now break out sub-sections
 ;
 s noOfParts=partNo
 s lastPart=0
 f partNo=1:1:noOfParts d
 . i '$d(part(partNo,"altBoundary")) q
 . s startLine=part(partNo,"start")
 . s endLine=part(partNo,"end")
 . s boundaryText=part(partNo,"altBoundary")
 . s found=0
 . f i=startLine:1:endLine d
 . . s line=^CacheTempMail($j,"email",i)
 . . s ucLine=$zconvert(line,"u")
 . . i line[boundaryText,ucLine'["BOUNDARY=" d  q
 . . . n previousPart,xPart,zPart
 . . . s previousPart=lastPart
 . . . s lastPart=lastPart+1
 . . . s xPart=partNo_"."_lastPart
 . . . s zPart=partNo_"."_previousPart
 . . . s part(xPart,"start")=i+1
 . . . s part(zPart,"end")=i-1
 . . . s found=1
 . . i 'found q
 . . i ucLine["CONTENT-DISPOSITION:" d  q
 . . . n fileName
 . . . s fileName=$$getDirectiveValue("Content-Disposition","filename",i)
 . . . s part(xPart,"filename")=fileName
 . . i ucLine["CONTENT-TYPE:" d
 . . . s mimeType=$p(line,": ",2),mimeType=$p(mimeType,"; ",1)
 . . . i $e($re(mimeType),1)=";" s mimeType=$e(mimeType,1,$l(mimeType)-1)
 . . . s part(xPart,"mimeType")=mimeType
 . . i ucLine["CONTENT-TRANSFER-ENCODING:",ucLine["BASE64" d
 . . . s part(xPart,"base64")="true"
 . i $g(part(xPart,"start"))'="",'$d(part(xPart,"end")) k part(xPart)
 . k part(partNo)
 ;
 ; get rid of part details
 ;
 s partNo=""
 f  s partNo=$o(part(partNo)) q:partNo=""  d
 . i $g(part(partNo,"end"))'="",'$d(part(partNo,"start")) k part(partNo) q
 . i '$d(part(partNo,"end")),'$d(part(partNo,"start")) k part(partNo) q
 ;
 ; now separate out the sections based on the pointers we've calculated
 ;
 s partNo=""
 f  s partNo=$o(part(partNo)) q:partNo=""  d
 . s startLine=part(partNo,"start")
 . s endLine=part(partNo,"end")
 . s ^CacheTempMail($j,"attachments",partNo,"mimeType")=$g(part(partNo,"mimeType"))
 . s ^CacheTempMail($j,"attachments",partNo,"fileName")=$g(part(partNo,"filename"))
 . s ^CacheTempMail($j,"attachments",partNo,"base64")=$g(part(partNo,"base64"))
 . s attachmentLineNo=0
 . s started=0
 . f lineNo=startLine:1:endLine d
 . . s line=^CacheTempMail($j,"email",lineNo)
 . . i line="",'started s started=1 q
 . . i 'started q
 . . s attachmentLineNo=attachmentLineNo+1
 . . s ^CacheTempMail($j,"attachments",partNo,"content",attachmentLineNo)=line
 . ;
 . f lineNo=startLine:1:endLine k ^CacheTempMail($j,"email",lineNo)
 . s ^CacheTempMail($j,"email",startLine)="Attachment #"_partNo_" separated out"
 ;
 s noOfParts=""
 s partNo=""
 f  s partNo=$o(^CacheTempMail($j,"attachments",partNo)) q:partNo=""  s noOfParts=noOfParts+1
 QUIT noOfParts
 ;
getDirectiveValue(directive,name,currentLine)
 ;
 ; Get value for a Content- directive name/value pair
 ;
 ; eg s value=$$getDirv("Content-Disposition","filename",%i)
 ;
 n i,line,p,stop,type,ucLine,ucName,value
 ;
 s type=$zconvert(directive,"u")
 s ucName=$zconvert(name,"u")
 s i=currentLine
 s stop=0
 s value=""
 ;
 f i=i:1 d  q:stop
 . s line=$g(^CacheTempMail($j,"email",i))
 . i line="" s stop=1 q  ; end of directive reached before name found
 . s ucLine=$zconvert(line,"u")
 . i ucLine["CONTENT-",ucLine'[type s stop=1 q  ; next directive found before name found
 . i i>currentLine,$a($e(line,1))'=9,ucLine[": " q  ; next directive found before name found
 . i ucLine'[ucName q
 . s p=name_"="
 . s value=$p(line,p,2)
 . s value=$p(value,"; ",1)
 . i $e(value,1)="""" s value=$e(value,2,$l(value)-1)
 . s stop=1
 ;
 QUIT value
 ;
decode(attachmentNo) ;
 ;decode BASE64 input string -- see RFC 2045 for specification
 ; input is in ^CacheTempMail($j,"attachments",attachmentNo,"content")
 ; output is in ^CacheTempContent($j)
 ;
 n buff,end,exit,lineNo,olineno,outs,quad,stop
 ;
 k ^CacheTempContent($j)
 ;
 s buff=$G(^CacheTempMail($j,"attachments",attachmentNo,"content",1))
 i buff="" QUIT
 s outs=""
 s end=0
 s lineNo=0
 s olineno=0
 ;
 s lineNo=lineNo+1
 S buff=^CacheTempMail($j,"attachments",attachmentNo,"content",lineNo)
 ;
 s stop=0
 f  d  q:stop
 . s quad=$e(buff,1,4)
 . i $l(quad)<4,'end d  q
 . . s buff=$$wmore(buff,.lineNo)
 . . i lineNo="" s end=1
 . i $l(quad)=0,end s stop=1 q
 . s buff=$e(buff,5,$l(buff))
 . s outs=$$dec3(quad,outs,.exit)
 . i exit s stop=1 q
 . i $l(outs)>75 d
 . . s olineno=olineno+1
 . . s ^CacheTempContent($j,olineno)=outs
 . . s outs=""
 ;
 s olineno=olineno+1
 S ^CacheTempContent($j,olineno)=outs
 QUIT
 ;
dec3(quad,outs,end) ;
 ;
 n bits,c,char64,f,j
 ;
 s bits=0
 s end=0
 s char64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
 f j=1:1:$l(quad) d  q:f<0
 . s c=$e(quad,j)
 . s f=$f(char64,c)-2
 . i f>-1 s bits=bits*64+f
 i f>-1 s outs=outs_$c(bits\65536,bits\256#256,bits#256)
 i f<0 s end=1
 ;
 i c="=" d
 . s j=j-1,f=0
 . i j=2 d
 . . s outs=outs_$c(bits\16)
 . e  d
 . . s outs=outs_$c(bits\1024,bits\4#256)
 QUIT outs
 ;
wmore(buff,lineNo)  ; add next line onto buffer
 n line,stop
 s stop=0
 f  d  q:stop
 . s lineNo=$o(^CacheTempMail($j,"attachments",attachmentNo,"content",lineNo))
 . i lineNo="" s stop=1 q
 . s line=^CacheTempMail($j,"attachments",attachmentNo,"content",lineNo)
 . i line'="" s buff=buff_line,stop=1
 QUIT buff
