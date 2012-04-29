PSOPXRM1 ;BHAM ISC/MR - Returns Patient's Prescrition info ; 07/12/2004
 ;;7.0;OUTPATIENT PHARMACY;**118**;DEC 1997
 ;
NVA(DAS,DATA) ;Return data on non-VA meds.
 N EM,IND1,IND2,IND3,IND4,TEMP,TEMP1
 S IND1=$P(DAS,";",1),IND2=$P(DAS,";",2),IND3=$P(DAS,";",3),IND4=$P(DAS,";",4)
 ;W !,"IN NVA^PSOPXRM1" BREAK
 S TEMP=^PS(55,IND1,IND2,IND3,IND4)
 S TEMP1=^PS(50.7,$P(TEMP,U,1),0)
 ;DBIA #2223
 S DATA("ORDERABLE ITEM")=$P(TEMP1,U,1)
 ;DBIA #2174
 S DATA("DOSAGE FORM")=^PS(50.606,$P(TEMP1,U,2),0)
 S DATA("DISPENSE DRUG")=$P(TEMP,U,2)
 S DATA("DOSAGE")=$P(TEMP,U,3)
 S DATA("MEDICATION ROUTE")=$P(TEMP,U,4)
 S DATA("SCHEDULE")=$P(TEMP,U,5)
 S TEMP1=$P(TEMP,U,6)
 S DATA("STATUS")=$S(TEMP1="":"ACTIVE",1:$$EXTERNAL^DILFD(55.05,5,"",TEMP1,.EM))
 S DATA("DISCONTINUED DATE")=$P(TEMP,U,7)
 S DATA("ORDER NUMBER")=$P(TEMP,U,8)
 S DATA("START DATE")=$P(TEMP,U,9)
 S DATA("DOCUMENTED DATE")=$P(TEMP,U,10)
 S DATA("DOCUMENTED BY")=$P(TEMP,U,11)
 S DATA("CLINIC")=$P(TEMP,U,12)
 ;W !,"NVA^PSOPXRM1 DONE" BREAK
 Q
 ;
 ;====================================================
PSRX(DAS,RXAR) ; Returns Rx Information
 ; Input:  DAS  - String containing the ^PSRX location where the data
 ;                is located, separated by ";" (semi-colon).
 ;                Example: "329832;1;1;0" -> ^PSRX(329832,1,1,0)
 ;Output: .RXAR - Array/Global to be returned with the Rx Info (by Ref)
 ;                Return:  RXAR(Field Name)=Internal Value
 ;
 N SB1,SB2,SB3,I,DA
 ;
 ; - Retrieving ^PSRX subscripts
 F I=1:1:3 S @("SB"_I)=$P(DAS,";",I)
 ;
 ; - Call appropriate sub-routine (Original, Refill or Partial)
 S DA=SB1 K RXAR D @($S(SB3="":"ORIG",SB2'="P":"REFL",1:"PRTL"))
 ;
 ; - Retrieve common fields
 S RXAR("STATUS")=+$G(^PSRX(DA,"STA"))
 ;
END Q
 ;
ORIG ; - Retrieve Original fields
 N RX0,RX2 S RX0=$G(^PSRX(DA,0)),RX2=$G(^PSRX(DA,2))
 S RXAR("DAYS SUPPLY")=$P(RX0,"^",8)
 S RXAR("PHARMACIST")=$P(RX2,"^",3)
 S RXAR("RELEASED DATE/TIME")=$P(RX2,"^",13)
 Q
 ;
REFL ; - Retrieve Refill fields
 N RF0 S RF0=$G(^PSRX(DA,1,SB3,0))
 S RXAR("DAYS SUPPLY")=$P(RF0,"^",10)
 S RXAR("PHARMACIST")=$P(RF0,"^",5)
 S RXAR("RELEASED DATE/TIME")=$P(RF0,"^",18)
 Q
 ;
PRTL ; - Retrieve Partial fields
 N PT0 S PT0=$G(^PSRX(DA,"P",SB3,0))
 S RXAR("DAYS SUPPLY")=$P(PT0,"^",10)
 S RXAR("PHARMACIST")=$P(PT0,"^",5)
 S RXAR("RELEASED DATE/TIME")=$P(PT0,"^",19)
 Q
