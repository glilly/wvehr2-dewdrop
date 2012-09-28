C0XRDF  ; GPL - Fileman Triples RDF out  ;11/07/11  17:05
        ;;1.0;FILEMAN TRIPLE STORE;;Sep 26, 2012;Build 10
        ;Copyright 2012 George Lilly.  Licensed under the terms of the GNU
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
REPLYSTART(ZARY);       
        D ADD(ZARY,"<?xml version=""1.0"" encoding=""UTF-8""?>")
        D ADD(ZARY,"<rdf:RDF xmlns:rdf=""http://www.w3.org/1999/02/22-rdf-syntax-ns#"">")
        Q
        ;
LISTSTART(ZARY,ZNAM)    
        Q
        ;
DICTSTART(ZARY,ZSUB)    
        I ZSUB["http" D  Q  ;
        . D ADD(ZARY,"<rdf:Description rdf:about="""_ZSUB_""">")
        I $E(ZSUB,1,1)="/" D  Q  ;
        . D ADD(ZARY,"<rdf:Description rdf:about="""_ZSUB_""">")
        D ADD(ZARY,"<rdf:Description rdf:nodeID="""_ZSUB_""">")
        Q
        ;
DASSERT(ZARY,ZPRED,ZOBJ)        
        I ZPRED[":" D  Q  ;
        . I ZPRED="rdf:type" D  Q  ;
        . . D ADD(ZARY,"<rdf:type rdf:resource="""_$$EXT^C0XUTIL(ZOBJ)_"""/>")
        . N ZA,ZB,ZC
        . S ZA=$P(ZPRED,":",1)
        . S ZB=$P(ZPRED,":",2)
        . I $E(ZB,1,1)="/" D  ;
        . . S ZB=$P(ZB,"/",2) ; handling gpltest:/note situations
        . S ZC=C0XVOC(ZA)
        . I ZOBJ["nodeID:" D  Q  ;
        . . D ADD(ZARY,"<"_ZB_" xmlns="""_ZC_""" rdf:nodeID="""_$$EXT^C0XUTIL(ZOBJ)_"""/>")
        . S ZOBJ=$$EXT^C0XUTIL(ZOBJ)
        . I ZOBJ["http" D  Q  ;
        . . D ADD(ZARY,"<"_ZB_" xmlns="""_ZC_""" rdf:resource="""_ZOBJ_"""/>")
        . I $E(ZOBJ,1,1)="/" D  Q  ;
        . . D ADD(ZARY,"<"_ZB_" xmlns="""_ZC_""" rdf:resource="""_ZOBJ_"""/>")
        . D ADD(ZARY,"<"_ZB_" xmlns="""_ZC_""">"_$$EXT^C0XUTIL(ZOBJ)_"</"_ZB_">")
        Q
        ;
DICTEND(ZARY)   
        D ADD(ZARY,"</rdf:Description>")
        Q
        ;
LISTEND(ZARY)   
        Q
        ;
REPLYEND(ZARY)  
        D ADD(ZARY,"</rdf:RDF>")
        Q
        ;
ADD(ZARY,ZELE)  
        N ZI
        I '$D(ZARY) S @ZARY@(1)=ZELE Q  ;
        S ZI=$O(@ZARY@(""),-1)
        S @ZARY@(ZI+1)=ZELE
        Q
        ;
rdfout(rdfout,zary)     ; 
        d REPLYSTART("rdfout")
        d LISTSTART("rdfout","results")
        n zi s zi=""
        f  s zi=$o(zary(zi)) q:zi=""  d  ; for each subject
        . n zii s zii=""
        . D DICTSTART("rdfout",$$EXT^C0XUTIL(zi))
        . f  s zii=$o(zary(zi,zii)) q:zii=""  d  ; for each pred^obj pair
        . . d DASSERT("rdfout",$p(zii,"^",1),$p(zii,"^",2))
        . D DICTEND("rdfout")
        d LISTEND("rdfout")
        d REPLYEND("rdfout")
        q
        ;
