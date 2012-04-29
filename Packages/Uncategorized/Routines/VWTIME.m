VWTIME ; Report Age in Time / Date;5:33 AM  11 Feb 2010
 ;;1.0;WorldVistA;;WorldVistA 30-June-08;Build 40
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
 QUIT  ;  No Fall Through
 ;  =============
 ; FDT = First Date/Time (SD)
 ;  W $$DIF^VWTIME(3090512.1145)
DIF(SD,ED) ; Now a Call will look like the above
 N BUF,DED,DSD,EH,EI,FTD
 S SD=$G(SD),ED=$G(ED)
 I ED="" D NOW^%DTC S ED=%
 I SD<.00001 D NOW^%DTC S SD=%  ; Invalid start date is set to now
 S X=SD
 D
 . I SD="" S ER=99 Q
 . ;
 . ; Convert both Values to Fileman Time to Decimal.
 . ;  We are interested in just the differences
 . ;
 . I SD>1400000 D
 . . S X=$$F2D(SD)
 . . D H^%DTC
 . . S SD=%H_","_$TR($J(%T,5)," ","0")
 . .QUIT
 . S DST=$$F2D(SD)
 . S DET=$$F2D(ED)
 .QUIT
 ;  Decimal Date/Times calculated in DST (start) and DET (end),
 ;   differeence of DET-DST is FTD - First Time and Date, DTD - Declining Time and Date
 S (DTD,FTD)=DET-DST
 ; Time Frames
 ; 1 Minute = .000694444444444444444
 ; 1 Hour   = .0416666666666666666
 ; 1 Day    = 1
 ; 1 WeeK   = 7
 ; 1 Month  = 30.5
 ; 1 Year   = 365.249
 N BUF,DAY,HR,MIN,MON,WK,YR
 S BUF=""
 S DAY=1
 S SEP=""
 D
 . N HR,MON,YR,WEEK
 . S MON=30.49,YR=365.249,HR=1/24,WEEK=7
 . I FTD>(2*YR)    D
 . . S T=DTD\YR
 . . S BUF=BUF_SEP_T_" Year"
 . . S:T>1 BUF=BUF_"s"
 . . S DTD=(DTD#YR),SEP=", "
 . . .QUIT
 . QUIT:FTD>(20*YR)
 . ;
 . ;  Time Calculations
 . I FTD>(4*MON) I FTD<(18*YR)   D
 . . S T=DTD\MON
 . . S BUF=BUF_SEP_T_" Month"
 . . S:T>1 BUF=BUF_"s"
 . . S DTD=(DTD#MON),SEP=", "
 . .QUIT
 . QUIT:FTD>(18*YR)
 . I FTD>29 I FTD<4*WEEK          D
 . . S T=DTD\WEEK
 . . S BUF=BUF_SEP_T_" Week"
 . . S:T>1 BUF=BUF_"s"
 . . S DTD=(DTD#WEEK),SEP=", "
 . .QUIT
 . ;  Time Calculations
 . I FTD<29 I DTD'<2        D
 . . S T=DTD\1
 . . S BUF=BUF_SEP_T_" Day"
 . . S:T>1 BUF=BUF_"s"
 . . S DTD=(DTD#DAY),SEP=", "
 . .QUIT
 . I DTD>.999999&(FTD<4)    D
 . . S T=DTD\HR
 . . S BUF=BUF_SEP_T_" Hour"
 . . S:T>1 BUF=BUF_"s"
 . . S DTD=(DTD#HR),SEP=", "
 . .QUIT
 . D:(FTD<4.00000001)
 . . N MIN,HR
 . . S HR=1/24,SEP=$G(SEP)
 . . S MIN=HR/60
 . . ;
 . . I DTD>MIN    D
 . . . S T=DTD\MIN
 . . . S BUF=BUF_SEP_T_" Minute"
 . . . S:T>1 BUF=BUF_"s"
 . . . S DTD=(DTD#MIN),SEP=", "
 . .QUIT
 . . ;
 . . S SEC=MIN/60
 . . I DTD>SEC    D
 . . . S T=DTD\SEC
 . . . S BUF=BUF_SEP_T_" Second"
 . . . S:T>1 BUF=BUF_"s"
 . . . S DTD=(DTD#SEC),SEP=", "
 . . .QUIT
 . .QUIT
 . ; I DTD    S BUF=BUF_" Less than a Minute"
 .QUIT
 QUIT BUF
 ;  ==========
 ;  W $$BRIEF^VWTIME(DOB)    >>> Years^Months^Weeks^Days^Hours^Minutes^Seconds
BRIEF(SD,ED) ; Now a Call will look like the above
 N BUF,DED,DSD,EH,EI,FTD,BUF
 S SD=$G(SD),ED=$G(ED)
 I ED="" D NOW^%DTC S ED=%
 S:SD<2 SD=""
 S BUF="INVALID INPUT"
 D:SD   ; SD has been checked and passed if it passes here
 . S X=SD
 . ;
 . ; Convert both Values to Fileman Time to Decimal.
 . ;  We are interested in just the differences
 . ;
 . ; I SD>1400000 D
 . ; . S X=$$F2D(SD)
 . ; .  D H^%DTC
 . ; .  S SD=%H_","_$TR($J(%T,5)," ","0")
 . ; .QUIT
 . ;  If we get here, we have the ST and ET defined and ready
 . S DST=$$F2D(SD)
 . S DET=$$F2D(ED)
 . D TDIFF(.BUF)
 .QUIT
 QUIT BUF
 ;  ===========
TDIFF(BF) ; Time Difference formulation
 ;  Decimal Date/Times calculated in DST (start) and DET (end),
 ;   differeence of DET-DST is FTD - First Time and Date, DTD - Declining Time and Date
 S (DTD,FTD)=DET-DST
 ; Time Frames
 ; 1 Minute = .000694444444444444444
 ; 1 Hour   = .0416666666666666666
 ; 1 Day    = 1
 ; 1 WeeK   = 7
 ; 1 Month  = 30.5
 ; 1 Year   = 365.249
 N DAY,HR,MIN,MON,WK,YR
 S $P(BF,"^",7)=""
 S DAY=1
 S SEP=""
 D
 . N HR,MON,YR,WEEK
 . S MON=30.49,YR=365.249,HR=1/24,WEEK=7
 . I FTD>(2*YR)    D
 . . S $P(BF,"^")=DTD\YR
 . . S DTD=(DTD#YR)
 . .QUIT
 . ;
 . ;  Time Calculations
 . I FTD>(4*MON) I FTD<(18*YR)   D
 . . S $P(BF,"^",2)=DTD\MON
 . . S DTD=(DTD#MON)
 . .QUIT
 . D   ; I FTD>29 I FTD<4*WEEK          D
 . . S $P(BF,"^",3)=DTD\WEEK
 . . S DTD=(DTD#WEEK)
 . .QUIT
 . ;  Time Calculations
 . D   ; I FTD<29 I DTD'<2        D
 . . S $P(BF,"^",4)=DTD\1
 . . S DTD=(DTD#DAY)
 . .QUIT
 . D    ; I DTD>.999999&(FTD<4)    D
 . . S $P(BF,"^",5)=DTD\HR
 . . S DTD=(DTD#HR)
 . .QUIT
 . S MIN=1/(24*60)
 . D   ; :(FTD<4.00000001)
 . . N HR
 . . S HR=1/24
 . . S MIN=HR/60
 . . ;
 . . ; I DTD>MIN    D
 . . S $P(BF,"^",6)=DTD\MIN
 . . S DTD=(DTD#MIN)
 . .QUIT
 . . ;
 . S SEC=MIN/60
 . ; I DTD>SEC    D
 . S $P(BF,"^",7)=DTD\SEC
 . S DTD=(DTD#SEC)
 . .QUIT
 . ; I DTD    S BF=BF_" Less than a Minute"
 .QUIT
 QUIT
 ;  ==========
F2D(X) ;  Conver FM Date/Time to Decimal
 N %H,%T,%Y
 D H^%DTC
 QUIT $$H2D(%H_","_%T)
 ;  ========
H2D(X) ; Convert Horolog to Decimal Days
 N D,T
 S D=$P(X,","),T=$P(X,",",2)/86400
 QUIT D+T
 ;  =============
LONGAGE(VWAGE,VWDFN) ; RPC FOR LONG AGE
 N VWDOB
 S VWDOB=$P(^DPT(VWDFN,0),"^",3)
 S VWAGE=$$DIF(VWDOB)
 QUIT
 ;  =============
BRFAGE(VWAGE,VWDFN) ; RPC FOR BRIEF AGE
 N VWDOB
 S VWDOB=$P(^DPT(VWDFN,0),"^",3)
 S VWAGE=$$BRIEF(VWDOB)
 QUIT
 ;  =============
RPCREG ; Register NEW RPCs
 N MENU,RPC,FDA,FDAIEN,ERR,DIERR
 S MENU="OR CPRS GUI CHART"
 F RPC="VWTIME LONG AGE","VWTIME BRIEF AGE" D
 . S FDA(19,"?1,",.01)=MENU
 . S FDA(19.05,"?+2,?1,",.01)=RPC
 . D UPDATE^DIE("E","FDA","FDAIEN","ERR")
 .QUIT
 QUIT
 ;  ============
