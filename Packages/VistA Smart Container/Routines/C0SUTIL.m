C0SUTIL   ; GPL - Smart Processing Utilities ;2/22/12  17:05
        ;;0.1;C0S;nopatch;noreleasedate;Build 1
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
SPDATE(ZDATE)   ; extrinsic which returns the Smart date format yyyy-mm-dd
        ; ZDATE is a fileman format date
        N TMPDT
        S TMPDT=$$FMTE^XLFDT(ZDATE,"7D") ; ordered date
        S TMPDT=$TR(TMPDT,"/","-") ; change slashes to hyphens
        I TMPDT="" S TMPDT="UNKNOWN"
        N Z2,Z3
        S Z2=$P(TMPDT,"-",2)
        S Z3=$P(TMPDT,"-",3)
        I $L(Z2)=1 S $P(TMPDT,"-",2)="0"_Z2
        I $L(Z3)=1 S $P(TMPDT,"-",3)="0"_Z3
        Q TMPDT
        ;
