MAGUXRF ;WOIFO/SRR - Imaging MUMPS cross-references ; 03/08/2005  09:16
 ;;3.0;IMAGING;**51**;26-August-2005
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
SETACT D AC(1) Q
KILLACT D AC(0) Q
 ;
AC(SETKIL) N ACTION,ROUTINE,TYPE
 ; "AC" Cross Reference for OBJECT TYPE - ACTION subfile
 ;  ^MAG(2005.02,"AC",OBJECT TYPE,ACTION)=OBJECT TYPE^ACTION ROUTINE
 S TYPE=$P(^MAG(2005.02,DA(1),0),"^",1)
 S ACTION=^MAG(2005.02,DA(1),1,DA,0)
 S ROUTINE=$P(ACTION,".",2),ACTION=$P(ACTION,".",1)
 S:SETKIL ^MAG(2005.02,"AC",TYPE,ACTION)=TYPE_"^"_ROUTINE
 K:'SETKIL ^MAG(2005.02,"AC",TYPE,ACTION)
 K MAGACT1,MAGMETH,MAG
 Q
 ;
SETPX ; Set PACS switch on; check fields first
 ; Write checks
 S ^MAG(2006.1,"APACS")=1
 Q
 ;
KILPX ; Stop PACS system
 K ^MAG(2006.1,"APACS")
 Q
 ;
SETPDPX ; Set P(atient) D(ate) PX(procedure)
 D SET Q:PDT=""  Q:DFN=""
 S ^MAG(2005,"APDPX",DFN,PDT,PX,DA)=""
 Q
 ;
SET S X0=^MAG(2005,DA,0),X2=$G(^(2))
 S PDT=$P(X2,U,5) I PDT="" S PDT=$P(X2,U) Q:PDT=""
 S DFN=$P(X0,U,7) Q:DFN=""
 ;
4 S PX=$P(X0,U,8) I PX="" S PX="OTHER"
 Q
 ;
KILPDPX ; Kill
 D SET Q:PDT=""  Q:DFN=""
 K ^MAG(2005,"APDPX",DFN,PDT,PX,DA)
 Q
 ;
SETPPXD ; #5:Set (patient=X=DFN); #6:PX(procedure); #15:DT(procedure date/time)
 ; Xref for patient field#5=Patient name (in form of DFN)
 ; ^MAG(2005,"APPXDT",X,PX,reverseDT)=""
 N CDT,RDT,PX,ER
 D SETUP Q:$D(ER)
 S ^MAG(2005,"APPXDT",X,PX,RDT,DA)=""
 S ^MAG(2005,"APDTPX",X,RDT,PX,DA)=""
 Q
 ;
SETUP ; Set up for patient Xref's-for field #5l
 S PX=$P(^MAG(2005,DA,0),U,8),CDT=$P($G(^(2)),U,5)
 I CDT="" S ER=1 Q
 I PX="" S ER=1 Q
 S RDT=9999999.9999-CDT
 Q
 ;
KILPPXD ;#5:KILL (PATIENT=X=DFN); #6:PX(PROCEDURE); #15:DT(PROCEDURE DATE/TIME)
 N CDT,PX,RDT,ER
 D SETUP Q:$D(ER)
 K ^MAG(2005,"APPXDT",X,PX,RDT,DA)
 K ^MAG(2005,"APDTPX",X,RDT,PX,DA)
 Q
 ;
SETPPXD6 ;#5:SET (PATIENT=X=DFN); #6:PX(PROCEDURE); #15:DT(PROCEDURE DATE/TIME)
 ;XREF FOR PROCEDURE,FIELD#6
 N DFN,CDT,RDT,ER
 D SETUP6 Q:$D(ER)
 S ^MAG(2005,"APPXDT",DFN,X,RDT,DA)=""
 S ^MAG(2005,"APDTPX",DFN,RDT,X,DA)=""
 Q
 ;
SETUP6 ; Set up for procedure xref-field#6
 S DFN=$P(^MAG(2005,DA,0),U,7),CDT=$P($G(^(2)),U,5)
 I CDT="" S ER=1 Q
 I DFN="" S ER=1 Q
 S RDT=9999999.9999-CDT
 Q
 ;
KILPPXD6 ;#5:KILL (PATIENT=X=DFN); #6:PX(PROCEDURE); #15:DT(PROCEDURE DATE/TIME)
 N DFN,CDT,RDT,ER
 D SETUP6 Q:$D(ER)
 K ^MAG(2005,"APPXDT",DFN,X,RDT,DA)
 K ^MAG(2005,"APDTPX",DFN,RDT,X,DA)
 Q
 ;
SETPPXD5 ;#5:SET (PATIENT=X=DFN); #6:PX(PROCEDURE); #15:DT(PROCEDURE DATE/TIME)
 ;XREF FOR FIELD#15
 ;^MAG(2005,"APPXDT",DFN,PX,reverseDT)=""
 N DFN,PX,RDT,ER
 D SETUP5 Q:$D(ER)
 S ^MAG(2005,"APPXDT",DFN,PX,RDT,DA)=""
 S ^MAG(2005,"APDTPX",DFN,RDT,PX,DA)=""
 Q
 ;
SETUP5 ; Set up for for date/time procedure field#15
 S DFN=$P(^MAG(2005,DA,0),U,7),PX=$P(^(0),U,8)
 I PX="" S ER=1 Q
 I DFN="" S ER=1 Q
 S RDT=9999999.9999-X
 Q
 ;
KILPPXD5 ;#5:SET (PATIENT=X=DFN); #6:PX(PROCEDURE); #15:DT(PROCEDURE DATE/TIME)
 N DFN,CDT,ER
 D SETUP5 Q:$D(ER)
 K ^MAG(2005,"APPXDT",DFN,PX,RDT,DA)
 K ^MAG(2005,"APDTPX",DFN,RDT,PX,DA)
 Q
 ;
SETDCM ; Set the cross reference for DICOM SERIES NUM
 ; and DICOM IMAGE NUM fields of the OBJECT GROUP Multiple
 N MAGDSN,MAGDIN
 I '$$BOTHNUM(.MAGDSN,.MAGDIN) Q
 S Z=+^MAG(2005,DA(1),1,DA,0)
 S ^MAG(2005,DA(1),1,"ADCM",MAGDSN,MAGDIN,Z,DA)=""
 Q
 ;
KILLDSN ; Kill the cross reference for DICOM SERIES NUM
 N MAGDSN,MAGDIN
 I '$$BOTHNUM(.MAGDSN,.MAGDIN) Q
 S Z=+^MAG(2005,DA(1),1,DA,0)
 K ^MAG(2005,DA(1),1,"ADCM",X,MAGDIN,Z,DA)
 Q
 ;
KILLDIN ; Kill the DICOM IMAGE NUM cross reference
 ; of the OBJECT GROUP Multiple
 N MAGDSN,MAGDIN
 I '$$BOTHNUM(.MAGDSN,.MAGDIN) Q
 S Z=+^MAG(2005,DA(1),1,DA,0)
 K ^MAG(2005,DA(1),1,"ADCM",MAGDSN,X,Z,DA)
 Q
 ;
BOTHNUM(MAGDSN,MAGDIN) ;
 S MAGDSN=$P($G(^MAG(2005,DA(1),1,DA,0)),U,2)
 S MAGDIN=$P($G(^MAG(2005,DA(1),1,DA,0)),U,3)
 ;GEK 4/4/00
 ; Changed to test for "", not to test I 'DINUM (0 would fail)
 I ((MAGDIN="")!(MAGDSN="")) Q 0
 Q 1
