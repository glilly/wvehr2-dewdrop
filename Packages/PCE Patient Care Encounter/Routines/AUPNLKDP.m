AUPNLKDP ; IHS/CMI/LAB - PGMR DOCUMENTATION FOR AUPNLK (PATIENT LOOKUP) 24-MAY-1993 ;1/29/07  09:05
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
PGMR ; Programmer documentation
 ;
 ;  There are seven functional routines in the IHS PATIENT LOOKUP:
 ;
 ;  AUPNLK   - Main driver
 ;  AUPNLK1  - Looks up on xrefs
 ;  AUPNLK2  - Adds new patients
 ;  AUPNLK3  - Checks for duplicates
 ;  AUPNLKD  - Actual duplicate checking logic.  Called by AUPNLK3
 ;  AUPNLKID - Prints identifiers and duplicate patient messages
 ;  AUPNLKUT - Contains functions common to multiple routines
 ;
 ;  AUPNLKI is the initialization logic for AUPNLK.
 ;
 ;  Routines broken up because of size will create a new
 ;  routine with B appended (e.g. AUPNLKB & AUPNLK2B).
 ;
 ;  Use caution with the following variables:
 ;
 ;  AUPDIC, AUPDICS, AUPDICW - All used to save a variable that needs
 ;                             to be restored.
 ;  AUPX - Input value for patient lookup.  Common to most routines.
 ;  AUPDFN - Flag indicating lookup status - patient DFN if found.
 ;           Common to most routines.
 ;  AUP("DR") - Used to build DIC("DR") string - AUPNLK2 only.
 ;  AUP("NOPRT^") - Used to suppress printing in PRTAUP^AUPNLKUT.
 ;                  Used by AUPNLK and AUPNLK1.
 ;  AUPS(s) - Used to store all xref lookup hits.  Used by AUPNLK,
 ;            AUPNLK1, and AUPNLKUT.  Contains the patient's NAME_"^"_
 ;            LOOKUP VALUE which caused the hit.
 ;  AUPNICK(s) - Indicates hit on ALIAS.  Used by AUPNLK, AUPNLK1,
 ;               AUPNLKUT.
 ;  AUPIFNS(s) - Used to table all xref lookup hits stored by hit
 ;               sequence.  Used by AUPNLK, AUPNLK1, and AUPNLKUT.
 ;  AUPCNT - Indicates # of hits stored in AUPIFNS(s).  Used by
 ;           AUPNLK, AUPNLK1, and AUPNLKUT.
 ;  AUPNUM - Used to display AUPIFNS(s) list.  Used by AUPNLK, AUPNLK1
 ;           and AUPNLKUT.
 ;  AUPSEL - Indicates patient from AUPIFNS(s) selected by user.
 ;           Used by AUPNLK, AUPNLK1, and AUPNLKUT.
 ;  AUPIFN - Patient DFN taken from xrefs by $O.  Used by AUPNLK,
 ;           AUPNLK1, and AUPNLKUT.
 ;  AUPIDS(s) - Used to build list of identifiers.  Created by
 ;              AUPNLK2 but referenced by AUPNLK3.
 ;  AUPD(s) - List of potential duplicates.  Created by AUPNLKD
 ;            but referenced by AUPNLK3.
 ;
M ; MARKER FOR INSERTIONS
