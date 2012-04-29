LA7VORM4 ;DALOI/DLR - LAB ORM (Order) message builder ;1/27/07  12:25
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**73**;Sep 27, 1994;Build 7
 ; Modified from FOIA VISTA,
 ; Copyright (C) 2007 WorldVistA
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
 ; You should have received a copy of the GNU General Public License
 ; along with this program; if not, write to the Free Software
 ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 ;
IN1 ;
 N CNT
 N IN1,INS0,INS1,INS2,INS3,INS4,LA7DATA,LA7DUR,LA7DURU,LA76205,LA762801,LA7X
 N ADDR0,ADDR1,ADDR2,ADDR3,ADDR4,ADDR5
 S CNT=0
 S OCT=0,X=""
 ; $O through insurances
 F  S OCT=$O(^DPT(DFN,.312,OCT)) Q:OCT'?1N.N  D
 . S INS0=$G(^DPT(DFN,.312,OCT,0))
 . S INS1=$G(^DPT(DFN,.312,OCT,1))
 . S INS2=$G(^DPT(DFN,.312,OCT,2))
 . S INS3=$G(^DPT(DFN,.312,OCT,3))
 . S INS4=$G(^DPT(DFN,.312,OCT,4))
 . S IN1(0)="IN1"
 . S IN1(1)=OCT
 . S IN1(2)=$P(INS0,"^",2) ;"insurance plan id"
 . S IN1(3)=$P(INS0,"^",1) ;"insurance co id"
 . S IN1(4)=$P($G(^DIC(36,IN1(3),0)),"^",1) ; "coName"
 . S ADDR0=$G(^DIC(36,IN1(3),.11))
 . S ADDR1=$P(ADDR0,"^",1) ;STR 1
 . S ADDR2=$P(ADDR0,"^",2) ;STR 2
 . S ADDR3=$P(ADDR0,"^",3) ;STR 3
 . S ADDR4=$P(ADDR0,"^",4) ;CITY
 . S ADDR5=$P($G(^DIC(5,$P(ADDR0,"^",5),0)),"^",2) ;STATE
 . S ADDR6=$P(ADDR0,"^",6) ;ZIP
 . S IN1(5)=ADDR1_$E(HLECH,1)_ADDR2_$E(HLECH,1)_ADDR3_$E(HLECH,1)_ADDR4_$E(HLECH,1)_ADDR5_$E(HLECH,1)_ADDR6 ;"coAddress"
 . S IN1(7)=$P($G(^DIC(36,IN1(3),.13)),"^") ;"coPhone"
 . S IN1(8)=$P($G(^IBA(355.3,IN1(3),0)),"^",4) ;"GroupNo"
 . S IN1(11)=$P(INS2,"^",9) ;"InsuredsGroupEmpName"
 . S IN1(16)=$P(INS0,"^",17) ;"NameInsured"
 . I $P(INS0,"^",17)'="" S IN1(17)=$P($G(^DG(408.11,$P(INS0,"^",17),0)),"^",1) ;"InsuredRelationToPatient"
 . S IN1(18)=$P(INS3,"^",1) ;"InsuredDOB"
 . S ADDR1=$P(INS3,"^",6) ;STR 1
 . S ADDR2=$P(INS3,"^",7) ;STR 2
 . S ADDR3=$P(INS3,"^",8) ;CITY
 . S ADDR4="" I INS3'="" S ADDR4=$P(INS3,"^",9)
 . I ADDR4'="" S ADDR4=$P($G(^DIC(5,ADDR4,0)),"^",2) ;STATE
 . S ADDR5=$P(INS3,"^",10) ;ZIP
 . S IN1(19)=ADDR1_$E(HLECH,1)_ADDR2_$E(HLECH,1)_ADDR3_$E(HLECH,1)_ADDR4_$E(HLECH,1)_ADDR5 ;"InsuredAddy"
 . S IN1(32)="T" ;"BillingStatus"
 . S IN1(35)="" ;"CompanyPlanCode"
 . S IN1(36)=$P(INS0,"^",2) ;"PolicyNum"
 . S ADDR1=$P(INS2,"^",2) ;STR 1
 . S ADDR2=$P(INS2,"^",3) ;STR 2
 . S ADDR3=$P(INS2,"^",4) ;STR 2
 . S ADDR4=$P(INS2,"^",5) ;CITY
 . S ADDR5="" I INS2'="" S ADDR5=$P(INS2,"^",6)
 . I INS2'="" S ADDR5=$P($G(^DIC(5,ADDR5,0)),"^",2) ;STATE
 . S ADDR6=$P(INS2,"^",7) ;ZIP
 . S IN1(44)=ADDR1_$E(HLECH,1)_ADDR2_$E(HLECH,1)_ADDR3_$E(HLECH,1)_ADDR4_$E(HLECH,1)_ADDR5_$E(HLECH,1)_ADDR6 ;"InsuredsEmpAddress"
 . S IN1(47)="" ;"CoverageType"
 . D BUILDSEG^LA7VHLU(.IN1,.LA7DATA,LA7FS)
 . D FILESEG^LA7VHLU(GBL,.LA7DATA)
 . D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 ;
 Q
 ;
GT1 ;
 Q
 ;
NTE ;
 Q
 ;
DG1(ORNUM) ; Get diagnosis info
 N DXIEN,DXV,ICD9,ICDR,OCT,ORFMDAT,ORIFN,CNT
 N DG1,LA7DATA,LA7DUR,LA7DURU,LA76205,LA762801,LA7X
 S CNT=0
 S ^BRAD("ORNUM")=ORNUM
 ;S ORIFN=+^OR(100,ORNUM,5.1,1,0)
 S OCT=0,X=""
 ; Get the date of the order for CSV/CTD usage
 S ORFMDAT=$$ORFMDAT^ORWDBA3(ORNUM)
 ; $O through diagnoses for an order
 F  S OCT=$O(^OR(100,ORNUM,5.1,OCT)) Q:OCT'?1N.N  D
 . S CNT=CNT+1
 . ; DXIEN=Dx IEN
 . S DXIEN=+^OR(100,ORNUM,5.1,OCT,0)
 . ; Get Dx record for date ORFMDAT
 . S ICDR=$$ICDDX^ICDCODE(DXIEN,ORFMDAT)
 . ; Get Dx verbiage and ICD code
 . S DXV=$P(ICDR,U,4),ICD9=$P(ICDR,U,2)
 .S DG1(0)="DG1"
 .S DG1(1)=CNT
 .S DG1(3)=ICD9
 .D BUILDSEG^LA7VHLU(.DG1,.LA7DATA,LA7FS)
 .D FILESEG^LA7VHLU(GBL,.LA7DATA)
 .D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 Q
