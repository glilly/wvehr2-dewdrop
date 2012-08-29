RARIC ;HISC/FPT AISC/SAW-Radiologic Image Capture and Display Routine ;6/19/97  12:06
 ;;5.0;Radiology/Nuclear Medicine;**23,27**;Mar 16, 1998
 ;
CREATE ; create new stub entry in file 74
 ; called from ^MAGKEXC, ^MAGKEXC1
 ; If no report entry is created, RARPT will be undefined
 K RARPT
 ; --------------------------------------------------------------------
 ; Perform data validation checks for the following 'RA' namespaced
 ; variables: RADTE, RADFN, RADTI, RACN & RACNI (all should be defined)
 Q:'$D(RADTE)!('$D(RADFN))!('$D(RADTI))!('$D(RACN))!('$D(RACNI))
 ; Check the above variables to insure they consist of the proper
 ; sequence of characters.
 Q:RADTE'?7N1"."1.4N  ; Fileman internal date/time without seconds
 K RASULT D DT^DILF("T",RADTE,.RASULT)
 I RASULT=-1 K RASULT Q  ; invalid FM internal date format
 K RASULT
 Q:RADTI'?7N1"."1.4N  ; reverse chronological date/time without seconds
 Q:+RADFN'=RADFN  Q:'$D(^RADPT(RADFN,0))  ; not a number, or invalid ien
 Q:RACN'?1.5N  ; case #'s lie in the range of 1-99999
 Q:RACNI'?1N.N  ; must be a number, period
 Q:'$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0))  ; exam record missing
 Q:$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U)'=RACN  ; case/exam mismatch
 ; --------------------------------------------------------------------
 ; continue whether exam was purged or not -- 08/23/00
 N RAPRTSET,RAMEMARR,RA1
 D EN2^RAUTL20(.RAMEMARR) ; is this case part of a print set ?
 ; don't need to lock exam date's node
 N I,J,X S I=$P(^RARPT(0),"^",3)
LOCK S I=I+1 L +^RARPT(I):1
 I $T,'$D(^RARPT(I)),'$D(^RARPT("B",I)) G NEWOK
 L -^RARPT(I)
 S X=$G(^RAPRT(I,0))
 ;
 ; if lock-failed node belongs to this case, set rarpt & quit
 I $P(X,"^",2)=RADFN,(9999999.9999-$P(X,"^",3))=RADTI,$P($P(X,"^"),"-",2)=RACNI S RARPT=I G OUT
 ; if lock-failed node belongs to a printset with the same patient and 
 ; exam date/time as the current case, set rarpt & quit
 I RAPRTSET,$P(X,"^",2)=RADFN,(9999999.9999-$P(X,"^",3))=RADTI S RARPT=I G OUT
 ;
 G LOCK ; lock-failed node belongs to another case, thus try again
NEWOK S ^RARPT(I,0)=$E(RADTE,4,7)_$E(RADTE,2,3)_"-"_RACN,RARPT=I,^(0)=$P(^RARPT(0),"^",1,2)_"^"_I_"^"_($P(^(0),"^",4)+1) D NOW^%DTC S DT=X K %,%H,%I
 ; don't define "T" node
 S $P(^RARPT(I,0),"^",2,6)=RADFN_"^"_(9999999.9999-RADTI)_"^"_RACN_"^^"_DT ; don't stuff REPORTED DATE
 S:'$D(RAMDIV) RAMDIV=+$P(^RADPT(RADFN,"DT",RADTI,0),"^",3) S:'$D(RAMDV) RAMDV=$S($D(^RA(79,RAMDIV,.1)):^(.1),1:"") S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),"^",17)=RARPT
 S MAGSCN=$G(^MAG(2006.1,"AXSCN"))
 I ('MAGSCN)!(MAGSCN="N") S MAGSCN=""
 E  S MAGSCN="Images captured for this report."
 I $L(MAGSCN) S ^RARPT(RARPT,"R",0)="^^1^1^"_DT,^RARPT(RARPT,"R",1,0)=MAGSCN
 ; The orig. clin hist is now referenced directly from file 70, so
 ; comment out next 2 lines to stop copying orig. clin hist from file 70
 ;I $O(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"H",0)) S I=0 F J=0:1 S I=$O(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"H",I)) Q:I'>0  I $D(^(I,0)) S ^RARPT(RARPT,"H",(J+1),0)=^(0)
 ;S:J ^RARPT(RARPT,"H",0)="^^"_J_"^"_J_"^"_DT
 ;Update Activity Log with 'images collected' transaction
 S DA=RARPT,DIE="^RARPT(",DR="100///""NOW""",DR(2,74.01)="2////"_$S($D(RAESIG):"V",1:"C")_";3////"_DUZ D ^DIE K DA,DR,DE,DQ,DIE
 S DA=RARPT,DIK="^RARPT(",RAQUEUED=1 D IX1^DIK ;D:$D(RAMDV) UPSTAT^RAUTL0
 N RARPTN S RARPTN=$P(^RARPT(RARPT,0),"^")
 ;
 ; create a var RARIC to suppress display of info msg from ptr^rarte2
 ; if another case of this printset got cancelled
 I RAPRTSET N RARIC S RARIC=1 D PTR^RARTE2
 ; don't have to check raxit, since we're quitting now
 ;
 K DA,DIK,J,RAQUEUED
OUT L -^RARPT(RARPT)
 Q
PTR ; create pointer in file 74 for Imaging package
 ; called from MAGKEXC, MAGKEXC1 & MAGRIC
 ; input:   RARPT - IEN of Rad/NM Report file #74
 ;          MAGGP - IEN of record in file 2005 pointed to by a report
 ; returns: Y=0  - variable MAGGP does not exist
 ;          Y=-1 - FileMan could not create an entry
 ;          Y>0  - FileMan created an entry
 ;
 N DA,DIC
 I '$D(MAGGP) S Y=0 Q
 S DIC("P")=$P(^DD(74,2005,0),U,2)
 S DA(1)=RARPT,DIC="^RARPT("_DA(1)_",2005,",DIC(0)="LZ",X=MAGGP
 K DD,DO D FILE^DICN
 Q
