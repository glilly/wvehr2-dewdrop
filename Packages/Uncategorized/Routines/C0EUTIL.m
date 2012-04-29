C0EUTIL   ; GPL - XML utilities;5/14/11  17:05
 ;;0.1;C0C;nopatch;noreleasedate
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
NORMAL(OUTXML,INXML)    ;NORMALIZES AN XML STRING PASSED BY NAME IN INXML
 ; INTO AN XML ARRAY RETURNED IN OUTXML, ALSO PASSED BY NAME
 ;
 N ZI,ZN,ZTMP
 S ZN=1
 S @OUTXML@(ZN)=$P(@INXML,"><",ZN)_">"
 S ZN=ZN+1
 F  S @OUTXML@(ZN)="<"_$P(@INXML,"><",ZN) Q:$P(@INXML,"><",ZN+1)=""  D  ;
 . S @OUTXML@(ZN)=@OUTXML@(ZN)_">"
 . S ZN=ZN+1
 Q
 ;
