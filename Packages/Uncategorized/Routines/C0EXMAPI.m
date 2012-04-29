C0EXMAPI ;KBAZ/ZAG - Mailman/Mailbox APIs ; 6/15/11 10:35pm
 ;;1.0;;;Jun 10, 2011;
 ;
 ;2011 Zach Gonzales<zach@linux.com> - Licensed under the terms of the GNU
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
MBLIST(sessid) ;list all mail folders
 ;
 N U S U="^"
 N MBDUZ S MBDUZ=$$getSessionValue^%zewdAPI("DUZ",sessid) ;user DUZ
 N MBNAME,BSKTLST,I S MBNAME=""
 F I=1:1 D  Q:MBNAME=""
 . S MBNAME=$O(^XMB(3.7,MBDUZ,2,"B",MBNAME)) ;basket name
 . Q:MBNAME=""
 . N MBNUM S MBNUM=""
 . F  D  Q:'MBNUM
 . . S MBNUM=$O(^XMB(3.7,MBDUZ,2,"B",MBNAME,MBNUM)) ;basket number
 . . Q:'MBNUM
 . . S BSKTLST(I,"text")=MBNAME
 ;
 D saveListToSessionValue^%zewdSTAPI(.BSKTLST,"bsktList",sessid)
 ;
 QUIT "" ;end of MBLIST
 ;
 ;
ARCHIVE(sessid) ;archive mail messages
 ; Example: D MOVEMSG^XMXAPI(DUZ,"IN","1","ARCHIVE",.MOVEMSG)
 ;
 N U S U="^"
 N MBDUZ S MBDUZ=$$getSessionValue^%zewdAPI("DUZ",sessid)
 N MBLST S MBLST=$$getRequestValue^%zewdAPI("listItemNo",sessid)
 N BSKLIST D mergeArrayFromSession^%zewdAPI(.BSKLIST,"bsktList",sessid)
 N MSGNUM S MSGNUM=$$getSessionValue^%zewdAPI("msgNum",sessid)
 N BSKT S BSKT=$P(BSKLST,U)
 N MSGSEQ S MSGSEQ=$P(^XMB(3.7,MBDUZ,2,1,1,MSGNUM,0),U,2)
 ;
 ;Mailman API to save 1 mail messgae from INBOX to another basket.
 D MOVEMSG^XMXAPI(MBDUZ,"IN","""MSGSEQ""","""BSKT""",.MOVEMSG)
 D setSessionValue^%zewdAPI("moveMsg",MOVEMSG,sessid)
 ;
 QUIT "" ;end of ARCHIVE
 ;
 ;
END ;end of C0EXMAPI
