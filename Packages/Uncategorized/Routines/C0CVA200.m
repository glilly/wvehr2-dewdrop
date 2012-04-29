C0CVA200 ;WV/C0C/SMH - Routine to get Provider Data;07/13/2008
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;Copyright 2008 Sam Habiel.  Licensed under the terms of the GNU
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
 Q
 ; This routine uses Kernel APIs and Direct Global Access to get
 ; Proivder Data from File 200.
 ;
  ; The Global is VA(200,*)
  ;
FAMILY(DUZ) ; Get Family Name; PUBLIC; EXTRINSIC
  ; INPUT: DUZ (i.e. File 200 IEN) ByVal
  ; OUTPUT: String
  N NAME S NAME=$P(^VA(200,DUZ,0),U)
  D NAMECOMP^XLFNAME(.NAME)
  Q NAME("FAMILY")
  ;
GIVEN(DUZ) ; Get Given Name; PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String
  N NAME S NAME=$P(^VA(200,DUZ,0),U)
  D NAMECOMP^XLFNAME(.NAME)
  Q NAME("GIVEN")
  ;
MIDDLE(DUZ) ; Get Middle Name, PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String
  N NAME S NAME=$P(^VA(200,DUZ,0),U)
  D NAMECOMP^XLFNAME(.NAME)
  Q NAME("MIDDLE")
  ;
SUFFIX(DUZ) ; Get Suffix Name, PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String
  N NAME S NAME=$P(^VA(200,DUZ,0),U)
  D NAMECOMP^XLFNAME(.NAME)
  Q NAME("SUFFIX")
  ;
TITLE(DUZ) ; Get Title for Proivder, PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String
  ; Gets External Value of Title field in New Person File.
  ; It's actually a pointer to file 3.1
  ; 200=New Person File; 8 is Title Field
  Q $$GET1^DIQ(200,DUZ_",",8)
  ;
NPI(DUZ) ; Get NPI Number, PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: Delimited String in format:
  ; IDType^ID^IDDescription
  ; If the NPI doesn't exist, "" is returned.
  ; This routine uses a call documented in the Kernel dev guide
  ; This call returns as "NPI^TimeEntered^ActiveInactive"
  ; It returns -1 for NPI if NPI doesn't exist.
  N NPI S NPI=$P($$NPI^XUSNPI("Individual_ID",DUZ),U)
  Q:NPI=-1 ""
  Q "NPI^"_NPI_"^HHS"
  ;
SPEC(DUZ) ; Get Provider Specialty, PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String: ProviderType/Specialty/Subspecialty OR ""
  ; Uses a Kernel API. Returns -1 if a specialty is not specified
  ; in file 200.
  ; Otherwise, returns IEN^Profession^Specialty^Sub­specialty^Effect date^Expired date^VA code
  N STR S STR=$$GET^XUA4A72(DUZ)
  Q:+STR<0 ""
  ; Sometimes we have 3 pieces, or 2. Deal with that.
  Q:$L($P(STR,U,4)) $P(STR,U,2)_"-"_$P(STR,U,3)_"-"_$P(STR,U,4)
  Q $P(STR,U,2)_"-"_$P(STR,U,3)
  ;
ADDTYPE(DUZ) ; Get Address Type, PUBLIC; EXTRINSIC
  ; INPUT: DUZ, but not needed really... here for future expansion
  ; OUTPUT: At this point "Work"
  Q "Work"
  ;
ADDLINE1(ADUZ) ; Get Address associated with this instituation; PUBLIC; EXTRINSIC ; CHANGED PARAMETER TO ADUZ TO KEEP FROM CRASHING GPL 1/09
  ; INPUT: DUZ ByVal
  ; Output: String.
  ;
  ; First, get site number from the institution file.
  ; 1st piece returned by $$SITE^VASITE, which gets the system institution
  N INST S INST=$P($$SITE^VASITE(),U)
  ;
  ; Second, get mailing address
  ; There are two APIs to get the address, one for physical and one for
  ; mailing. We will check if mailing exists first, since that's the
  ; one we want to use; then check for physical. If neither exists,
  ; then we return nothing. We check for the existence of an address
  ; by the length of the returned string.
  ; NOTE: API doesn't support Address 2, so I won't even include it
  ; in the template.
  N ADD
  S ADD=$$MADD^XUAF4(INST) ; mailing address
  Q:$L(ADD) $P(ADD,U)
  S ADD=$$PADD^XUAF4(INST) ; physical address
  Q:$L(ADD) $P(ADD,U)
  Q ""
  ;
CITY(ADUZ) ; Get City for Institution. PUBLIC; EXTRINSIC
    ;GPL CHANGED PARAMETER TO ADUZ TO KEEP $$SITE^VASITE FROM CRASHING
  ; INPUT: DUZ ByVal
  ; Output: String.
  ; See ADD1 for comments
  N INST S INST=$P($$SITE^VASITE(),U)
  N ADD
  S ADD=$$MADD^XUAF4(INST) ; mailing address
  Q:$L(ADD) $P(ADD,U,2)
  S ADD=$$PADD^XUAF4(INST) ; physical address
  Q:$L(ADD) $P(ADD,U,2)
  Q ""
  ;
STATE(ADUZ) ; Get State for Institution. PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; Output: String.
  ; See ADD1 for comments
  N INST S INST=$P($$SITE^VASITE(),U)
  N ADD
  S ADD=$$MADD^XUAF4(INST) ; mailing address
  Q:$L(ADD) $P(ADD,U,3)
  S ADD=$$PADD^XUAF4(INST) ; physical address
  Q:$L(ADD) $P(ADD,U,3)
  Q ""
  ;
POSTCODE(ADUZ) ; Get Postal Code for Institution. PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String.
  ; See ADD1 for comments
  N INST S INST=$P($$SITE^VASITE(),U)
  N ADD
  S ADD=$$MADD^XUAF4(INST) ; mailing address
  Q:$L(ADD) $P(ADD,U,4)
  S ADD=$$PADD^XUAF4(INST) ; physical address
  Q:$L(ADD) $P(ADD,U,4)
  Q ""
  ;
TEL(DUZ) ; Get Office Phone number. PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String.
  ; Direct global access
  N TEL S TEL=$G(^VA(200,DUZ,.13))
  Q $P(TEL,U,2)
  ;
TELTYPE(DUZ) ; Get Telephone Type. PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String.
  Q "Office"
  ;
EMAIL(DUZ) ; Get Provider's Email. PUBLIC; EXTRINSIC
  ; INPUT: DUZ ByVal
  ; OUTPUT: String
  ; Direct global access
  N EMAIL S EMAIL=$G(^VA(200,DUZ,.15))
  Q $P(EMAIL,U)
  ;
