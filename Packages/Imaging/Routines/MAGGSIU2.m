MAGGSIU2        ;WOIFO/GEK - Utilities for Image Add/Modify ; [ 12/27/2000 10:49 ]
        ;;3.0;IMAGING;**7,8,85,59**;Nov 27, 2007;Build 20
        ;;Per VHA Directive 2004-038, this routine should not be modified.
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
MAKEFDA(MAGGFDA,MAGARRAY,MAGACT,MAGCHLD,MAGGRP,MAGGWP)  ;
        ;  Create the FileMan FDA Array
        ;  Create Imaging Action Codes Array (for Pre and Post processing)
        N MAGGFLD,MAGGDAT,GRPCT,WPCT,Z
        S Z="" F  S Z=$O(MAGARRAY(Z)) Q:Z=""  D  I $L(MAGERR) Q
        . S MAGGFLD=$P(MAGARRAY(Z),U,1),MAGGDAT=$P(MAGARRAY(Z),U,2,99)
        . ;  If this entry is one of the action codes, store it in the action array.
        . I $$ACTCODE^MAGGSIV(MAGGFLD) S MAGACT(MAGGFLD)=MAGGDAT Q
        . ;
        . ; If we are Creating a Group Entry, add any Images that are to be members of this group.
        . I MAGGFLD=2005.04 D  Q
        . . S MAGGRP=1
        . . I '+MAGGDAT Q  ; making a group entry, with no group entries yet. This is OK.
        . . S MAGCHLD(MAGGDAT)=""
        . . S GRPCT=GRPCT+1
        . . S MAGGFDA(2005.04,"+"_GRPCT_",+1,",.01)=MAGGDAT
        . ;
        . ; if we are getting a WP for Long Desc, set array to pass.
        . I MAGGFLD=11 D  ; this is one line of the WP Long Desc field.
        . . S WPCT=WPCT+1,MAGGWP(WPCT)=MAGGDAT
        . . S MAGGFDA(2005,"+1,",11)="MAGGWP"
        . ;  Set the Node for the UPDATE^DIC Call.
        . S MAGGFDA(2005,"+1,",MAGGFLD)=MAGGDAT
        . Q
        ; Patch 8.  Special processing for field 107 (ACQUISITION DEVICE)
        ;  We'll change any MAGGFDA(2005,"+1,",107) to MAGACT("ACQD")
        ;  This way the PRE processing of the array will check and create a new
        ;  ACQUISITION DEVICE file entry, if needed.
        I $D(MAGACT("107")) S MAGACT("ACQD")=MAGACT("107") K MAGACT("107")
        I $D(MAGGFDA(2005,"+1,",107)) S MAGACT("ACQD")=MAGGFDA(2005,"+1,",107) K MAGGFDA(2005,"+1,",107)
        Q
REQPARAM()      ;Do required parameters have values. Called from MAGGSIUI
        ; VARIABLES ARE SET AND KILLED IN THAT ROUTINE.
        N CT
        S CT=0
        S MAGRY(0)="1^Checking for Required parameter values..."
        I IDFN="" S CT=CT+1,MAGRY(CT)="DFN is Required. !"
        I '$D(IMAGES),'CMTH S CT=CT+1,MAGRY(CT)="List of Images is Required. !"
        ;
        I (PXPKG=""),(DOCCTG=""),(IXTYPE="") S CT=CT+1,MAGRY(CT)="Procedure or Category or Index Type is Required. !"
        I (PXPKG'=""),(DOCCTG'="") S CT=CT+1,MAGRY(CT)="Procedure OR Document Category. Not BOTH. !"
        ;
        I (PXPKG'=""),(PXIEN="") S CT=CT+1,MAGRY(CT)="Procedure IEN is Required. !"
        I (PXPKG=""),(PXIEN'="") S CT=CT+1,MAGRY(CT)="Procedure Package is Required. !"
        I (PXPKG'=""),(PXDT="") S CT=CT+1,MAGRY(CT)="Procedure Date is Required. !"
        ;
        ;Patch 8 index field check... could be using Patch 7 or Patch 8.
        ;  We're this far, so either PXIEN or DOCCTG is defined
        I (IXTYPE'=""),(DOCCTG'="") S CT=CT+1,MAGRY(CT)="Image Type OR Document Category. Not BOTH. !"
        ; MAGGSIA computes PACKAGE #40 and CLASS #41 when adding an Image (2005) entry.
        ;
        I TRKID="" S CT=CT+1,MAGRY(CT)="Tracking ID is Required. !"
        I ACQD="" S CT=CT+1,MAGRY(CT)="Acquisition Device is Required. !"
        ;   ACQS ( could ? ) default to users institution i.e. DUZ(2)
        I (ACQS="")&(ACQN="") S CT=CT+1,MAGRY(CT)="Acquisition Site IEN or Station Number is Required. !"
        I (ACQS]"")&(ACQN]"") S CT=CT+1,MAGRY(CT)="Station IEN or Station Number, Not BOTH. !"
        ;
        I STSCB="" S CT=CT+1,MAGRY(CT)="Status Handler (TAG^ROUTINE) is Required. !"
        ;
        I (DOCCTG'=""),(DOCDT="") S CT=CT+1,MAGRY(CT)="Document Date is Required. !"
        ;
        I (CT>0) S MAGRY(0)="0^Required parameter is null" Q MAGRY(0)
        ;Checks to stop Duplicate or incorrect Tracking ID's
        ;  //TODO: ?? check the Queue File, is this Tracking ID already Queued.
        I (TRKID'="") I $D(^MAG(2005,"ATRKID",TRKID)) S MAGRY(0)="0^Tracking ID Must be Unique !"
        I (TRKID'="") I ($L(TRKID,";")<2) S MAGRY(0)="0^Tracking ID Must have "";"" Delimiter"
        ;
        Q MAGRY(0)
