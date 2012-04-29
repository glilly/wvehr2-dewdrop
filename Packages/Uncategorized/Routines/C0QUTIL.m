C0QUTIL ;JJOH/ZAG/GPL - Utilities for C0Q Package ;9/2/11 4:30pm
        ;;1.0;MU PACKAGE;;;Build 23
        ;
        ;2011 Licensed under the terms of the GNU General Public License
        ;See attached copy of the License.
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
AGE(DFN)        ; return current age in years and months
        ;
        Q:'$G(DFN)  ;quit if no there is no patient
        N DOB S DOB=$P(^DPT(+DFN,0),U,3) ;date of birth
        N YRS
        N DOD S DOD=+$G(^DPT(9,.35)) ;check for date of death
        I 'DOD D
        . N CDTE S CDTE=DT ;current date
        . S YRS=$E(CDTE,1,3)-$E(DOB,1,3)-($E(CDTE,4,7)<$E(DOB,4,7))
        E  D
        . S YRS=$E(DOD,1,3)-$E(DOB,1,3)-($E(DOD,4,7)<$E(DOB,4,7))
        ;
        ;Come back here and fix MONTHS and DAYS
        ;N CM S CM=+$E(DT,4,5) ;current month
        ;N CD S CD=+$E(DT,6,7) ;current day
        ;N BM S BM=+$E(DOB,4,5) ;birth month
        ;N BD S BD=+$E(DOB,6,7) ;birth day
        ;
        ;N DAYS S DAYS=""
        ;
        Q YRS ;_"y" gpl ..just want the number
        ;
        ;
DTDIFF(ZD1,ZT1,ZD2,ZT2,SHOW)    ; extrinsic which returns the number of minutes
        ; between 2 dates. ZD1 and ZD2 are fileman dates
        ; ZT1 AND ZT2 are valid times (military time) ie 20:10
        ; IF SHOW=1 DEBUGGING INTERMEDIATE VALUES WILL BE DISPLAYED
        I '$D(SHOW) S SHOW=0
        N GT1,GT2,GDT1,GDT2
        I ZT1[":" D  ;
        . S GT1=($P(ZT1,":",1)*3600)+($P(ZT1,":",2)*60) ; SECONDS
        . S GT2=($P(ZT2,":",1)*3600)+($P(ZT2,":",2)*60) ; SECONDS
        E  D  ;
        . S GT1=($E(ZT1,1,2)*3600)+($E(ZT1,3,4)*60)
        . S GT2=($E(ZT2,1,2)*3600)+($E(ZT2,3,4)*60)
        ;W:SHOW !,"SECONDS: ",GT1," ",GT2
        ;S %=GT1 D S^%DTC ; FILEMAN TIME
        ;S GDT1=ZD1_% ; FILEMAN DATE AND TIME
        ;S %=GT2 D S^%DTC ; FILEMAN TIME
        ;S GDT2=ZD2_% ; FILEMAN DATE AND TIME
        S GDT1=ZD1_"."_ZT1
        S GDT2=ZD2_"."_ZT2
        W:SHOW !,"FILEMAN: ",GDT1," ",GDT2
        N ZH1,ZH2
        S ZH1=$$FMTH^XLFDT(GDT1) ; $H FORMAT
        S ZH2=$$FMTH^XLFDT(GDT2) ; $H FORMAT
        W:SHOW !,"$H: ",ZH1," ",ZH2
        N ZSECS,ZMIN
        S ZSECS=$$HDIFF^XLFDT(ZH1,ZH2,2) ; DIFFERENCE IN $H
        W:SHOW !,"DIFF: ",ZSECS
        S ZMIN=ZSECS/60 ; DIFFERENCE IN MINUTES
        W:SHOW !,"MIN: ",ZMIN
        Q ZMIN
        ;
END     ;end of C0QUTIL
