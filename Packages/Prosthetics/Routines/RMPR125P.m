RMPR125P ;HINES OI/SPS-PRE INSTALL ROUTINE FOR P125;6:32 AM  1 Jan 2012
 ;;3.0;PROSTHETICS;**125**;Feb 09, 1996;Build 21;WorldVistA 30-June-08
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
 S DIK="^DD(660,",DA=49,DA(1)=660 D ^DIK
 ;Begin WorldVistA change
 ;K DA,DIK,
 K DA,DIK
 ;End WorldVistA change
 Q
 ;
 ;END
