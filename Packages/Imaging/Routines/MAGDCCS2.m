MAGDCCS2 ;WOIFO/MLH - DICOM Correct - Clinical Specialties - subroutines ; 05/06/2004  06:32
 ;;3.0;IMAGING;**10,11,30**;16-September-2004
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 Q
 ; Routine to create the MAGDY variable needed by MAGDCCS routine when
 ; manually correcting DICOM FIX files. 
EN ;
 ; MAGDY variable to be created during this execution.
 N D,DIC,DZ,MAGBEG,MAGEND,MAGDFN,MAGOUT,MAGX,MAGXX,INFO,MAGNME,MAGSSN
 S MAGBEG=1070101,MAGEND=$$DT^XLFDT
 W !,"*** Select a request/consult with whose ***"
 W !,"***  TIU note to associate this image   ***"
 S DIC="^GMR(123,",DIC(0)="AENZ"
 S DIC("A")="Enter patient or request/consultation: "
 S D="F",DZ="??"
 S DIC("W")="W ""  REQ/CON #"",Y"
 S DIC("W")=DIC("W")_",""  "",$$GET1^DIQ(123,Y,1)" ; TO SERVICE
 S DIC("W")=DIC("W")_",""  "",$$GET1^DIQ(123,Y,.02)" ; PATIENT NAME
 ;
 D IX^DIC
 Q:$D(DUOUT)
 Q:'$D(Y(0))  ; nothing selected
 S (MAGDFN,MAGX)=$P(Y(0),U,2)_"~"_Y
 ;
 D ONE ; Lookup was on req/con number and successful
 Q
 ;
PTINFO() ;
 N INFO,MAGOUT
 I '$D(MAGDFN) Q ""
 D GETS^DIQ(2,MAGDFN,".01;.09","E","MAGOUT","MAGERR")
 I $D(MAGERR) Q ""
 I $D(MAGOUT) D  Q INFO
 . S INFO=$G(MAGOUT(2,MAGDFN_",",.01,"E"))
 . S INFO=INFO_"^"_$G(MAGOUT(2,MAGDFN_",",.09,"E"))
 Q ""
 ;
ONE ; Process the single entry that was selected.
 ; MAGDFN,MAGX variables expected from EN
 I 'MAGDFN,'+MAGX Q
 N BEG,CASE,CDATE,CS,DATA,END,FLDS,INFO,MAGCASE,MAGCNI,MAGDATE,MAGDTI
 N MAGEXST,MAGLOC,MAGNME,MAGOUT,MAGPIEN,MAGPRC,MAGPSET,MAGPST,MAGRPT
 N PP,PSET,RAENTRY,RAMEMLOW,RAPRTSET,RIEN,STAT,X,X1,X2,XX
 N RARPT,RADFN,RADTI,RACNI ;<--Variables needed for EN1^RAUTL20
 ; RAUTL20 used to retrieve if case is part of a print set.
 N MAGRCARY ; array of req/con data from file 123
 N MAGIENS  ; internal entry number for MAGRCARY
 ;
 S MAGDFN=$P(MAGX,"~"),INFO=$$PTINFO
 S MAGNME=$P(INFO,"^"),MAGSSN=$P(INFO,"^",2)
 S MAGCASE=$P($P(MAGX,"~",2),U)
 S (MAGPRC,MAGDTI,MAGCNI,MAGPIEN,MAGLOC,MAGDATE,MAGEXST,MAGPST)=""
 K MAGRCARY D GETS^DIQ(123,MAGCASE,"*","EI","MAGRCARY")
 ;
 S MAGIENS=$O(MAGRCARY(123,""))
 S MAGPRC=MAGRCARY(123,MAGIENS,4,"E") ; procedure
 S MAGLOC=MAGRCARY(123,MAGIENS,1,"E") ; to service
 S MAGDATE=MAGRCARY(123,MAGIENS,.01,"E") ; request date
 S MAGPST=MAGRCARY(123,MAGIENS,8,"E") ; procedure status
 W !,"PATIENT: ",MAGNME,?51,"SSN: ",MAGSSN
 W !,"Req/Con No.",?13,"Procedure",?38,"To Service",?58,"Req Date"
 W !,"-----------",?13,"---------",?38,"----------------",?58,"--------"
 W !,MAGCASE,?13,MAGPRC,?38,MAGLOC,?58,MAGDATE
 W !,"Exam status: ",MAGEXST," "," ",$G(MAGPST)
 D MAGDY
 Q
 ;
MAGDY ;
 S MAGDY=MAGDFN_"^"_MAGNME_"^"_MAGSSN_"^"_"GMRC-"_MAGCASE_"^"_MAGPRC_"^"_MAGDTI
 S MAGDY=MAGDY_"^"_MAGCNI_"^"_MAGPIEN_"^"_$G(MAGPST)_"^"
 K MAGNME,MAGSSN,MAGCASE,MAGPRC,MAGDTI,MAGCNI,MAGPIEN,MAPST
 Q
