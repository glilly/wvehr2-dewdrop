C0QGEN ;GPL - Test Patient Reminder List Generator;7/5/11 8:50pm
 ;;1.0;MU PACKAGE;;;Build 19
 ;
 ;2011 George Lilly <glilly@glilly.net> - Licensed under the terms of the GNU
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
 Q
 ;
EN ; generate random patient lists for C0Q testing
 ;
 ; -- here are the attributes in the C0Q PATIENT LIST file
 ;
 ;^C0Q(301,"CATTR","FailedDemographics",9)=""
 ;^C0Q(301,"CATTR","HasAdvancedDirective",15)=""
 ;^C0Q(301,"CATTR","HasAllergy",24)=""
 ;^C0Q(301,"CATTR","HasDemographics",25)=""
 ;^C0Q(301,"CATTR","HasMed",26)=""
 ;^C0Q(301,"CATTR","HasMedOrders",10)=""
 ;^C0Q(301,"CATTR","HasMedRecon",19)=""
 ;^C0Q(301,"CATTR","HasProblem",27)=""
 ;^C0Q(301,"CATTR","HasSmokingStatus",12)=""
 ;^C0Q(301,"CATTR","HasVitalSigns",16)=""
 ;^C0Q(301,"CATTR","NoAdvancedDirective",17)=""
 ;^C0Q(301,"CATTR","NoAllergy",28)=""
 ;^C0Q(301,"CATTR","NoMed",5)=""
 ;^C0Q(301,"CATTR","NoMedOrders",11)=""
 ;^C0Q(301,"CATTR","NoMedRecon",20)=""
 ;^C0Q(301,"CATTR","NoProblem",29)=""
 ;^C0Q(301,"CATTR","NoSmokingStatus",13)=""
 ;^C0Q(301,"CATTR","NoVitalSigns",18)=""
 ;^C0Q(301,"CATTR","Over65",14)=""
 ;^C0Q(301,"CATTR","Patient",30)=""
 ;^C0Q(301,"CATTR","XferOfCare",21)=""
 N ZI S ZI=0
 N ZX,ZY
 K C0QLIST ; variable to pass to update
 F  S ZI=$O(^DPT(ZI)) Q:+ZI=0  D  ; for every patient in the database
 . ;
 . S C0QLIST("Patient",ZI)="" ; everyone is a patient
 . ;
 . I $$YN(90) S C0QLIST("HasDemographics",ZI)="" ;
 . E  S C0QLIST("FailedDemographics",ZI)="" ;
 . ;
 . I $$YN(40) S C0QLIST("HasAdvancedDirective",ZI)="" ;
 . E  S C0QLIST("NoAdvancedDirective",ZI)="" ;
 . ;
 . I $$YN(60) S C0QLIST("HasAllergy",ZI)="" ;
 . E  S C0QLIST("NoAllergy",ZI)="" ;
 . ;
 . I $$YN(65) S C0QLIST("HasMed",ZI)="" ;
 . E  S C0QLIST("NoMed",ZI)="" ;
 . ;
 . I $$YN(80) S C0QLIST("HasMedOrders",ZI)="" ;
 . E  S C0QLIST("NoMedOrders",ZI)="" ;
 . ;
 . I $$YN(35) S C0QLIST("HasMedRecon",ZI)="" ;
 . E  S C0QLIST("NoMedRecon",ZI)="" ;
 . ;
 . I $$YN(80) S C0QLIST("HasProblem",ZI)="" ;
 . E  S C0QLIST("NoProblem",ZI)="" ;
 . ;
 . I $$YN(70) S C0QLIST("HasSmokingStatus",ZI)="" ;
 . E  S C0QLIST("NoSmokingStatus",ZI)="" ;
 . ;
 . I $$YN(85) S C0QLIST("HasVitalSigns",ZI)="" ;
 . E  S C0QLIST("NoVitalSigns",ZI)="" ;
 . ;
 . I $$YN(20) S C0QLIST("Over65",ZI)="" ;
 D FILE^C0QPRML ; update the patient list file
 ; then update the measure set
 D UPDATE^C0QUPDT(.G,8) ; the MU 2011 INP ATTESTATION measure set ien
 Q
 ;
YN(ZPCT) ; extrinsic which says yes or no based on a percent ZPCT
 ; for example $$YN(70) will say "yes" 70% of the time
 N ZN
 S ZN=0
 I $R(100)<ZPCT S ZN=1
 Q ZN
 ;
