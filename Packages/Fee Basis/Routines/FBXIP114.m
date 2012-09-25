FBXIP114 ;ALB/RC-PATCH INSTALL ROUTINE ;8:45 AM  20 Feb 2012
 ;;3.5;FEE BASIS;**114**;JAN 30, 1995;Build 7;WorldVistA 30-June-08
 ;
 ;Modified from FOIA VISTA,
 ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
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
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;
PS ; post-install entry point
 ; create KIDS checkpoints with call backs
 N FBX
 F FBX="EN" D
 .S Y=$$NEWCP^XPDUTL(FBX,FBX_"^FBXIP114")
 .I 'Y D BMES^XPDUTL("ERROR Creating "_FBX_" Checkpoint.")
 Q
 ;
EN ; Begin Post-Install
 ;re-index "AF" cross reference.
 ;Begin WorldVistA change
 I '+$P($G(^FBAA(161.7,0)),U,4) Q  ;PREVENT DIK ERROR
 ;End WorldVistA change
 N DIK
 S DIK="^FBAA(161.7,",DIK(1)="13^AF"
 D ENALL2^DIK ;Kill existing "AF" cross-reference.
 D ENALL^DIK ;Re-create "AF" cross-reference.
 Q
 ;FBXIP114
