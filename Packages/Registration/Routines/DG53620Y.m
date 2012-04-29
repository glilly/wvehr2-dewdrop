DG53620Y ;Plano/DW-Modify NEW-STYLE XREF ;11:50 AM  29 Nov 2004
 ;;5.3;Registration;**620**;Aug 13, 1993
 ;
 ;Continued after DG53620X
ANAM341 ;ANAM341 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM341"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.341."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.341 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.341,.DG20NAME,1.09,+$P($G(^DPT(DA,""NAME"")),U,9),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.341,1.09) Q"
 S DGXR("VAL",1)=.341
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
 ;
ANAM201 ;ANAM201 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("ROOT FILE")=2.01
 S DGXR("NAME")="ANAM201"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with the .01 field."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.01 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2.01,.DA,.01,.DG20NAME,100.03,,""CL30"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2.01,.DA,.01,100.03) Q"
 S DGXR("VAL",1)=.01
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
 ;
ANAM1001 ;ANAM1001 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("ROOT FILE")=2.101
 S DGXR("NAME")="ANAM1001"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #30."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #30 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2.101,.DA,30,.DG20NAME,100.21,,""CL30"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2.101,.DA,30,100.21) Q"
 S DGXR("VAL",1)=30
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
 ;
