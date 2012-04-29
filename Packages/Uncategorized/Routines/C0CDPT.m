C0CDPT ;WV/CCRCCD/SMH - Routines to Extract Patient Data for CCDCCR; 6/15/08
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;
 ; Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
 ; General Public License.
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
 ; FAMILY       Family Name
 ; GIVEN        Given Name
 ; MIDDLE       Middle Name
 ; SUFFIX       Suffix Name
 ; DISPNAME     Display Name
 ; DOB          Date of Birth
 ; GENDER       Get Gender
 ; SSN          Get SSN for ID
 ; ADDRTYPE     Get Home Address
 ; ADDR1        Get Home Address line 1
 ; ADDR2        Get Home Address line 2
 ; CITY         Get City for Home Address
 ; STATE        Get State for Home Address
 ; ZIP          Get Zip code for Home Address
 ; COUNTY       Get County for our Address
 ; COUNTRY      Get Country for our Address
 ; RESTEL       Residential Telephone
 ; WORKTEL      Work Telephone
 ; EMAIL        Email Adddress
 ; CELLTEL      Cell Phone
 ; NOK1FAM      Next of Kin 1 (NOK1) Family Name
 ; NOK1GIV      NOK1 Given Name
 ; NOK1MID      NOK1 Middle Name
 ; NOK1SUF      NOK1 Suffi Name
 ; NOK1DISP     NOK1 Display Name
 ; NOK1REL      NOK1 Relationship to the patient
 ; NOK1ADD1     NOK1 Address 1
 ; NOK1ADD2     NOK1 Address 2
 ; NOK1CITY     NOK1 City
 ; NOK1STAT     NOK1 State
 ; NOK1ZIP      NOK1 Zip Code
 ; NOK1HTEL     NOK1 Home Telephone
 ; NOK1WTEL     NOK1 Work Telephone
 ; NOK1SAME     Is NOK1's Address the same the patient?
 ; NOK2FAM      NOK2 Family Name
 ; NOK2GIV      NOK2 Given Name
 ; NOK2MID      NOK2 Middle Name
 ; NOK2SUF      NOK2 Suffi Name
 ; NOK2DISP     NOK2 Display Name
 ; NOK2REL      NOK2 Relationship to the patient
 ; NOK2ADD1     NOK2 Address 1
 ; NOK2ADD2     NOK2 Address 2
 ; NOK2CITY     NOK2 City
 ; NOK2STAT     NOK2 State
 ; NOK2ZIP      NOK2 Zip Code
 ; NOK2HTEL     NOK2 Home Telephone
 ; NOK2WTEL     NOK2 Work Telephone
 ; NOK2SAME     Is NOK2's Address the same the patient?
 ; EMERFAM      Emergency Contact (EMER) Family Name
 ; EMERGIV      EMER Given Name
 ; EMERMID      EMER Middle Name
 ; EMERSUF      EMER Suffi Name
 ; EMERDISP     EMER Display Name
 ; EMERREL      EMER Relationship to the patient
 ; EMERADD1     EMER Address 1
 ; EMERADD2     EMER Address 2
 ; EMERCITY     EMER City
 ; EMERSTAT     EMER State
 ; EMERZIP      EMER Zip Code
 ; EMERHTEL     EMER Home Telephone
 ; EMERWTEL     EMER Work Telephone
 ; EMERSAME     Is EMER's Address the same the NOK?
 ;
 W "No Entry at top!" Q
 ;
 ;**Revision History**
 ; - June 15, 08: v0.1 using merged global
 ; - Oct 3, 08: v0.2 using fileman calls, many formatting changes.
 ;
 ; All methods are Public and Extrinsic
 ; All calls use Fileman file 2 (Patient).
 ; You can obtain field numbers using the data dictionary
 ;
FAMILY(DFN) ; Family Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.01)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("FAMILY")
GIVEN(DFN) ; Given Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.01)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("GIVEN")
MIDDLE(DFN) ; Middle Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.01)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("MIDDLE")
SUFFIX(DFN) ; Suffi Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.01)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("SUFFIX")
DISPNAME(DFN) ; Display Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.01)
 ; "G" is Given Name First; "MXc" is Mixed Case, With Suffx Preceded by Comma
 Q $$NAMEFMT^XLFNAME(.NAME,"G","MXc")
DOB(DFN) ; Date of Birth
 N DOB S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 ; Date in FM Date Format. Convert to UTC/ISO 8601.
 Q $$FMDTOUTC^C0CUTIL(DOB,"D")
GENDER(DFN) ; Gender/Sex
 Q $$GET1^DIQ(2,DFN,.02,"I")_"^"_$$GET1^DIQ(2,DFN,.02,"E") ;
SSN(DFN) ; SSN
 Q $$GET1^DIQ(2,DFN,.09)
ADDRTYPE(DFN) ; Address Type
 ; Vista only stores a home address for the patient.
 Q "Home"
ADDR1(DFN) ; Get Home Address line 1
 Q $$GET1^DIQ(2,DFN,.111)
ADDR2(DFN) ; Get Home Address line 2
 ; Vista has Lines 2,3; CCR has only line 1,2; so compromise
 N ADDLN2,ADDLN3
 S ADDLN2=$$GET1^DIQ(2,DFN,.112),ADDLN3=$$GET1^DIQ(2,DFN,.113)
 Q:ADDLN3="" ADDLN2
 Q ADDLN2_", "_ADDLN3
CITY(DFN) ; Get City for Home Address
 Q $$GET1^DIQ(2,DFN,.114)
STATE(DFN) ; Get State for Home Address
 Q $$GET1^DIQ(2,DFN,.115)
ZIP(DFN) ; Get Zip code for Home Address
 Q $$GET1^DIQ(2,DFN,.116)
COUNTY(DFN) ; Get County for our Address
 Q $$GET1^DIQ(2,DFN,.117)
COUNTRY(DFN) ; Get Country for our Address
 ; Unfortunately, it's not stored anywhere in Vista, so the inevitable...
 Q "USA"
RESTEL(DFN) ; Residential Telephone
 Q $$GET1^DIQ(2,DFN,.131)
WORKTEL(DFN) ; Work Telephone
 Q $$GET1^DIQ(2,DFN,.132)
EMAIL(DFN) ; Email Adddress
 Q $$GET1^DIQ(2,DFN,.133)
CELLTEL(DFN) ; Cell Phone
 Q $$GET1^DIQ(2,DFN,.134)
NOK1FAM(DFN) ; Next of Kin 1 (NOK1) Family Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.211)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("FAMILY")
NOK1GIV(DFN) ; NOK1 Given Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.211)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("GIVEN")
NOK1MID(DFN) ; NOK1 Middle Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.211)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("MIDDLE")
NOK1SUF(DFN) ; NOK1 Suffi Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.211)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("SUFFIX")
NOK1DISP(DFN) ; NOK1 Display Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.211)
 ; "G" is Given Name First; "MXc" is Mixed Case, With Suffx Preceded by Comma
 Q $$NAMEFMT^XLFNAME(.NAME,"G","MXc")
NOK1REL(DFN) ; NOK1 Relationship to the patient
 Q $$GET1^DIQ(2,DFN,.212)
NOK1ADD1(DFN) ; NOK1 Address 1
 Q $$GET1^DIQ(2,DFN,.213)
NOK1ADD2(DFN) ; NOK1 Address 2
 N ADDLN2,ADDLN3
 S ADDLN2=$$GET1^DIQ(2,DFN,.214),ADDLN3=$$GET1^DIQ(2,DFN,.215)
 Q:ADDLN3="" ADDLN2
 Q ADDLN2_", "_ADDLN3
NOK1CITY(DFN) ; NOK1 City
 Q $$GET1^DIQ(2,DFN,.216)
NOK1STAT(DFN) ; NOK1 State
 Q $$GET1^DIQ(2,DFN,.217)
NOK1ZIP(DFN) ; NOK1 Zip Code
 Q $$GET1^DIQ(2,DFN,.218)
NOK1HTEL(DFN) ; NOK1 Home Telephone
 Q $$GET1^DIQ(2,DFN,.219)
NOK1WTEL(DFN) ; NOK1 Work Telephone
 Q $$GET1^DIQ(2,DFN,.21011)
NOK1SAME(DFN) ; Is NOK1's Address the same the patient?
 Q $$GET1^DIQ(2,DFN,.2125)
NOK2FAM(DFN) ; NOK2 Family Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.2191)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("FAMILY")
NOK2GIV(DFN) ; NOK2 Given Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.2191)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("GIVEN")
NOK2MID(DFN) ; NOK2 Middle Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.2191)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("MIDDLE")
NOK2SUF(DFN) ; NOK2 Suffi Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.2191)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("SUFFIX")
NOK2DISP(DFN) ; NOK2 Display Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.2191)
 ; "G" is Given Name First; "MXc" is Mixed Case, With Suffx Preceded by Comma
 Q $$NAMEFMT^XLFNAME(.NAME,"G","MXc")
NOK2REL(DFN) ; NOK2 Relationship to the patient
 Q $$GET1^DIQ(2,DFN,.2192)
NOK2ADD1(DFN) ; NOK2 Address 1
 Q $$GET1^DIQ(2,DFN,.2193)
NOK2ADD2(DFN) ; NOK2 Address 2
 N ADDLN2,ADDLN3
 S ADDLN2=$$GET1^DIQ(2,DFN,.2194),ADDLN3=$$GET1^DIQ(2,DFN,.2195)
 Q:ADDLN3="" ADDLN2
 Q ADDLN2_", "_ADDLN3
NOK2CITY(DFN) ; NOK2 City
 Q $$GET1^DIQ(2,DFN,.2196)
NOK2STAT(DFN) ; NOK2 State
 Q $$GET1^DIQ(2,DFN,.2197)
NOK2ZIP(DFN) ; NOK2 Zip Code
 Q $$GET1^DIQ(2,DFN,.2198)
NOK2HTEL(DFN) ; NOK2 Home Telephone
 Q $$GET1^DIQ(2,DFN,.2199)
NOK2WTEL(DFN) ; NOK2 Work Telephone
 Q $$GET1^DIQ(2,DFN,.211011)
NOK2SAME(DFN) ; Is NOK2's Address the same the patient?
 Q $$GET1^DIQ(2,DFN,.21925)
EMERFAM(DFN) ; Emergency Contact (EMER) Family Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.331)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("FAMILY")
EMERGIV(DFN) ; EMER Given Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.331)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("GIVEN")
EMERMID(DFN) ; EMER Middle Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.331)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("MIDDLE")
EMERSUF(DFN) ; EMER Suffi Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.331)
 D NAMECOMP^XLFNAME(.NAME)
 Q NAME("SUFFIX")
EMERDISP(DFN) ; EMER Display Name
 N NAME S NAME=$$GET1^DIQ(2,DFN,.331)
 ; "G" is Given Name First; "MXc" is Mixed Case, With Suffx Preceded by Comma
 Q $$NAMEFMT^XLFNAME(.NAME,"G","MXc")
EMERREL(DFN) ; EMER Relationship to the patient
 Q $$GET1^DIQ(2,DFN,.331)
EMERADD1(DFN) ; EMER Address 1
 Q $$GET1^DIQ(2,DFN,.333)
EMERADD2(DFN) ; EMER Address 2
 N ADDLN2,ADDLN3
 S ADDLN2=$$GET1^DIQ(2,DFN,.334),ADDLN3=$$GET1^DIQ(2,DFN,.335)
 Q:ADDLN3="" ADDLN2
 Q ADDLN2_", "_ADDLN3
EMERCITY(DFN) ; EMER City
 Q $$GET1^DIQ(2,DFN,.336)
EMERSTAT(DFN) ; EMER State
 Q $$GET1^DIQ(2,DFN,.337)
EMERZIP(DFN) ; EMER Zip Code
 Q $$GET1^DIQ(2,DFN,.338)
EMERHTEL(DFN) ; EMER Home Telephone
 Q $$GET1^DIQ(2,DFN,.339)
EMERWTEL(DFN) ; EMER Work Telephone
 Q $$GET1^DIQ(2,DFN,.33011)
EMERSAME(DFN) ; Is EMER's Address the same the NOK?
 Q $$GET1^DIQ(2,DFN,.3305)
