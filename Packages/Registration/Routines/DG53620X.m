DG53620X ;Plano/DW-MODIFY NEW-STYLE XREF ;11:26 AM  1 Sep 2004
 ;;5.3;Registration;**620**;Aug 13, 1993
 ;
 Q
EN ;Entry point
 D NOP,ANAM01,ANAM211,ANAM2191,ANAM2401
 D ANAM2402,ANAM2403,ANAM331,ANAM3311
 D ANAM341^DG53620Y,ANAM201^DG53620Y,ANAM1001^DG53620Y
 Q
 ;
NOP ;NOP X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="NOP"
 S DGXR("TYPE")="R"
 S DGXR("USE")="LS"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="Index of standardized values that don't match .01 value."
 S DGXR("DESCR",1)="This cross reference facilitates PATIENT file lookups by a standardized name"
 S DGXR("DESCR",2)="value.  In addition to the standardization applied by Kernel name utilities,"
 S DGXR("DESCR",3)="hyphens and apostrophes are also removed from the name value.  This cross"
 S DGXR("DESCR",4)="reference is only set if the standardized name is different than the patient"
 S DGXR("DESCR",5)="name value stored in the NAME (#.01) field."
 S DGXR("VAL",1)=.01
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"LENGTH")=30
 S DGXR("VAL",1,"COLLATION")="F"
 S DGXR("VAL",1,"XFORM FOR STORAGE")="S X=$$NOP^XLFNAME7(X)"
 S DGXR("VAL",1,"XFORM FOR LOOKUP")="S X=$$NOP^XLFNAME7(X)"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
ANAM01 ;ANAM01 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM01"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with the .01 field."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.01 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.01,.DG20NAME,1.01,+$P($G(^DPT(DA,""NAME"")),U),""CL30"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.01,1.01) Q"
 S DGXR("VAL",1)=.01
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
ANAM211 ;ANAM211 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM211"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.211."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.211 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.211,.DG20NAME,1.02,+$P($G(^DPT(DA,""NAME"")),U,2),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.211,1.02) Q"
 S DGXR("VAL",1)=.211
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
 ;
ANAM2191 ;ANAM2191 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM2191"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.2191."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.2191 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.2191,.DG20NAME,1.03,+$P($G(^DPT(DA,""NAME"")),U,3),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.2191,1.03) Q"
 S DGXR("VAL",1)=.2191
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
 ;
ANAM2401 ;ANAM2401 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM2401"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.2401."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.2401 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.2401,.DG20NAME,1.04,+$P($G(^DPT(DA,""NAME"")),U,4),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.2401,1.04) Q"
 S DGXR("VAL",1)=.2401
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
ANAM2402 ;ANAM2402 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM2402"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.2402."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.2402 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.2402,.DG20NAME,1.05,+$P($G(^DPT(DA,""NAME"")),U,5),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.2402,1.05) Q"
 S DGXR("VAL",1)=.2402
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
ANAM2403 ;ANAM2403 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM2403"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.2403."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.2403 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.2403,.DG20NAME,1.06,+$P($G(^DPT(DA,""NAME"")),U,6),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.2403,1.06) Q"
 S DGXR("VAL",1)=.2403
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
ANAM331 ;ANAM331 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM331"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.331."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.331 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.331,.DG20NAME,1.07,+$P($G(^DPT(DA,""NAME"")),U,7),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.331,1.07) Q"
 S DGXR("VAL",1)=.331
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
ANAM3311 ;ANAM3311 X-REF
 N DGXR,DGRES,DGOUT
 S DGXR("FILE")=2
 S DGXR("NAME")="ANAM3311"
 S DGXR("TYPE")="MU"
 S DGXR("USE")="A"
 S DGXR("EXECUTION")="F"
 S DGXR("ACTIVITY")="IR"
 S DGXR("SHORT DESCR")="This index keeps the NAME COMPONENTS file in synch with field #.3311."
 S DGXR("DESCR",1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGXR("DESCR",2)="COMPONENTS (#20) file record associated with the #.3311 field synchronized"
 S DGXR("DESCR",3)="with the data value stored in that field."
 S DGXR("SET")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.3311,.DG20NAME,1.08,+$P($G(^DPT(DA,""NAME"")),U,8),""CL35"") K DG20NAME Q"
 S DGXR("KILL")="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.3311,1.08) Q"
 S DGXR("VAL",1)=.3311
 S DGXR("VAL",1,"SUBSCRIPT")=1
 S DGXR("VAL",1,"COLLATION")="F"
 D CREIXN^DDMOD(.DGXR,"kW",.DGRES,"DGOUT")
 Q
 ;
