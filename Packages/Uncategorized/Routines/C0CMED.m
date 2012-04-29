C0CMED ; WV/CCDCCR/GPL/SMH - CCR/CCD Medications Driver; Mar 23 2009
 ;;1.0;C0C;;May 19, 2009;Build 2
 ; Copyright 2008,2009 George Lilly, University of Minnesota and Sam Habiel.
 ; Licensed under the terms of the GNU General Public License.
 ; See attached copy of the License.
 ;
 ; This program is free software; you can redistribute it and/or modify
 ; it under the terms of the GNU General Public License as published by
 ; the Free Software Foundation; either version 2 of the License, or
 ; (at your option) any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; You should have received a copy of the GNU General Public License along
 ; with this program; if not, write to the Free Software Foundation, Inc.,
 ; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 ; --Revision History
 ; July 2008 - Initial Version/GPL
 ; July 2008 - March 2009 various revisions
 ; March 2009 - Reconstruction of routine as driver for other med routines/SMH
 ;
 Q
EXTRACT(MEDXML,DFN,MEDOUTXML) ; Private; Extract medications into provided XML template
 ; DFN passed by reference
 ; MEDXML and MEDOUTXML are passed by Name
 ; MEDXML is the input template
 ; MEDOUTXML is the output template
 ; Both of them refer to ^TMP globals where the XML documents are stored
 ;
 ; -- This ep is the driver for extracting medications into the provided XML template
 ; 1. VA Outpatient Meds are in C0CMED1
 ; 2. VA Pending Meds are in C0CMED2
 ; 3. VA non-VA Meds are in C0CMED3
 ; 4. VA Inpatient IV Meds are in C0CMED4 (not functional)
 ; 5. VA Inpatient UD Meds are in C0CMED5 (doesn't exist yet)--March 2009
 ; 6. RPMS Meds are in C0CMED6. Need to create other routines for subdivisions of RPMS Meds is not known at this time.
 ;
 ; --Get parameters for meds
 S @MEDOUTXML@(0)=0 ; By default, empty.
 N C0CMFLAG
 S C0CMFLAG=$$GET^C0CPARMS("MEDALL")_"^"_$$GET^C0CPARMS("MEDLIMIT")_"^"_$$GET^C0CPARMS("MEDACTIVE")_"^"_$$GET^C0CPARMS("MEDPENDING")
 W:$G(DEBUG) "Med Parameters: ",!
 W:$G(DEBUG) "ALL: ",+C0CMFLAG,!
 W:$G(DEBUG) "LIMIT: ",$P(C0CMFLAG,U,2),!
 W:$G(DEBUG) "ACTIVE: ",$P(C0CMFLAG,U,3),!
 W:$G(DEBUG) "PEND: ",$P(C0CMFLAG,U,4),!
 ; --Find out what system we are on and branch out...
 W:$G(DEBUG) "Agenecy: ",$G(DUZ("AG"))
 I $$RPMS^C0CUTIL() D RPMS QUIT
 I ($$VISTA^C0CUTIL())!($$WV^C0CUTIL())!($$OV^C0CUTIL()) D VISTA QUIT
RPMS
 ;D EXTRACT^C0CMED6(MEDXML,DFN,MEDOUTXML,C0CMFLAG) QUIT
 N MEDCOUNT S MEDCOUNT=0
 K ^TMP($J,"MED")
 N HIST S HIST=$NA(^TMP($J,"MED","HIST")) ; Meds already dispensed
 N NVA S NVA=$NA(^TMP($J,"MED","NVA")) ; non-VA Meds
 S @HIST@(0)=0,@NVA@(0)=0 ; At first, they are all empty... (prevent undefined errors)
 D EXTRACT^C0CMED6(MEDXML,DFN,HIST,.MEDCOUNT,C0CMFLAG) ; Historical OP Meds
 D:+C0CMFLAG EXTRACT^C0CMED3(MEDXML,DFN,NVA,.MEDCOUNT) ; non-VA Meds
 I @HIST@(0)>0 D
 . D CP^C0CXPATH(HIST,MEDOUTXML)
 . W:$G(DEBUG) "HAS ACTIVE OP MEDS",!
 I @NVA@(0)>0 D
 . I @HIST@(0)>0 D INSINNER^C0CXPATH(MEDOUTXML,NVA)
 . ;E  D CP^C0CXPATH(NVA,MEDOUTXML)
 . W:$G(DEBUG) "HAS NON-VA MEDS",!
 Q
VISTA
 N MEDCOUNT S MEDCOUNT=0
 K ^TMP($J,"MED")
 N HIST S HIST=$NA(^TMP($J,"MED","HIST")) ; Meds already dispensed
 N PEND S PEND=$NA(^TMP($J,"MED","PEND")) ; Pending Meds
 N NVA S NVA=$NA(^TMP($J,"MED","NVA")) ; non-VA Meds
 K @HIST K @PEND K @NVA ; MAKE SURE THEY ARE EMPTY
 S @HIST@(0)=0,@PEND@(0)=0,@NVA@(0)=0 ; At first, they are all empty... (prevent undefined errors)
 ; N IPIV ; Inpatient IV Meds
 N IPUD S IPUD=$NA(^TMP($J,"MED","IPUD")) ; Inpatient UD Meds
 K @IPUD
 S @IPUD@(0)=0
 ;
 D EXTRACT^C0CMED1(MEDXML,DFN,HIST,.MEDCOUNT,C0CMFLAG) ; Historical OP Meds
 D:$P(C0CMFLAG,U,4) EXTRACT^C0CMED2(MEDXML,DFN,PEND,.MEDCOUNT) ; Pending Meds
 ;D:+C0CMFLAG EXTRACT^C0CMED3(MEDXML,DFN,NVA,.MEDCOUNT) ; non-VA Meds
 D EXTRACT^C0CMED3(MEDXML,DFN,NVA,.MEDCOUNT) ; non-VA Meds GPL
 D EXTRACT^C0CNMED4(MEDXML,DFN,IPUD,.MEDCOUNT) ; inpatient gpl
 I @HIST@(0)>0 D
 . D CP^C0CXPATH(HIST,MEDOUTXML)
 . W:$G(DEBUG) "HAS ACTIVE OP MEDS",!
 I @PEND@(0)>0 D
 . I @HIST@(0)>0 D INSINNER^C0CXPATH(MEDOUTXML,PEND) ;Add Pending to Historical
 . E  D CP^C0CXPATH(PEND,MEDOUTXML) ; No historical, just copy
 . W:$G(DEBUG) "HAS OP PENDING MEDS",!
 I @NVA@(0)>0 D
 . I @HIST@(0)>0!(@PEND@(0)>0) D INSINNER^C0CXPATH(MEDOUTXML,NVA)
 . E  D CP^C0CXPATH(NVA,MEDOUTXML)
 . W:$G(DEBUG) "HAS NON-VA MEDS",!
 I @IPUD@(0)>0 D
 . I @HIST@(0)>0!(@PEND@(0)>0)!(@NVA@(0)>0) D INSINNER^C0CXPATH(MEDOUTXML,IPUD)
 . E  D CP^C0CXPATH(IPUD,MEDOUTXML)
 . W:$G(DEBUG) "HAS INPATIENT MEDS",!
 N ZI
 S ZI=$NA(^TMP("C0CCCR",$J,"MEDMAP"))
 M ^TMP("C0CRIM","VARS",DFN,"MEDS")=@ZI ; PERSIST MEDS VARIABLES
 K @ZI ; CLEAN UP MED MAP AFTER - GPL 10/10
 K @PEND
 K @HIST
 K @NVA
 K @IPUD
 Q
