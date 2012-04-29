BPSSCRCU ;BHAM ISC/SS - ECME SCREEN CONTINUOUS UPDATE AND CHANGE VIEW ;05-APR-05
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;
CU ;
 N BPKEY,BPTIME,X,Y
 S BPTIME=15 ;update every 15 seconds
 D RE^VALM4
 W "Press ""Q"" to quit."
 F  D  S BPKEY=$$READ^XGF(1,BPTIME) Q:(BPKEY="Q")!(BPKEY="q")
 . D UD^BPSSCRUD
 . D RE^VALM4
 . N %
 . D NOW^%DTC S Y=% X ^DD("DD")
 . W "The screen has been updated on "_Y_". Press ""Q"" to quit."
 Q
 ;
 ;select insurance from the list of the insurances which was built for the current user setting
 ;for the User Screen.
 ;input : none
 ;output : 1^name of the insurance or null
 ;0^ - if "^" or was not selected
SELINSUR() ;
 N DIR,Y,X
 N BPX,BPCNT,BPTEL
 S BPX=0,BPCNT=0
 K ^TMP($J,"BPSSCRINS","LOOKUP")
 F  S BPX=$O(^TMP($J,"BPSSCRINS","VAL",BPX)) Q:BPX=""  D
 . S BPCNT=BPCNT+1
 . S BPTEL=$O(^TMP($J,"BPSSCRINS","VAL",BPX,""))
 . S ^TMP($J,"BPSSCRINS","LOOKUP",BPCNT,0)=BPX_U_BPTEL
 . S ^TMP($J,"BPSSCRINS","LOOKUP","B",BPX,BPCNT)=""
 S ^TMP($J,"BPSSCRINS","LOOKUP",0)=U_U_BPCNT_U_BPCNT
 ;set DIR variables
 S DIR(0)="P^TMP($J,""BPSSCRINS"",""LOOKUP"",:AEQMZ"
 S DIR("A")="Select "
 S DIR("A",1)=""
 S DIR("A",2)="Select one of the insurances which were used by ECME to submit claims within"
 S DIR("A",3)="the date range specified by the user."
 S DIR("A",4)=""
 D ^DIR
 K ^TMP($J,"BPSSCRINS","LOOKUP")
 I X="^" Q "-1^"
 I $P(Y,U,2)="" Q "0^"
 Q 1_U_$P(Y,U,2)
 ;
