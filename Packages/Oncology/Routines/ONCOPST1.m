ONCOPST1 ;HIRMFO/RTK-DATA CONVERSION CALLED BY ONCOPST ;2/7/96
 ;;2.11;ONCOLOGY;**1,4**;Feb 07, 1996
 ;
 ;Routine to convert data in several fields in the ONCOLOGY PRIMARY
 ;file from pointers to the ONCOLOGY CONTACT file to pointers to the 
 ;new ACOS NUMBER file.  Pointers in the following fields in the
 ;ONCOLOGY PRIMARY file will be converted: 5,6,7,50.1,51.1,52.1,53.1,
 ;54.1,55.1,56.1,57.1 and SUB-FIELD 2 under field 60.  This routine
 ;also calls ^ONCOPST2, ^ONCOPST3 and ^ONCOPST4.
 ;
 ;W !!," Converting pointers to the ONCOLOGY CONTACT (165) file to pointers to the new"
 ;W !," ACOS NUMBER (160.19) file..."
 D ^ONCOPST3 ;Routine to loop thru 165 file add any new entries to 160.19
 S FIRST=$O(^ONCO(165.5,0)) Q:FIRST=""  I $P($G(^ONCO(165.5,FIRST,24)),"^",6)="" D
 .F XFIRST=0:0 S XFIRST=$O(^ONCO(165.5,XFIRST)) Q:XFIRST'>""  S $P(^ONCO(165.5,XFIRST,24),"^",6)="N"
 K ^TMP($J,"CONTINV"),^TMP($J,"NOTFND") S CNT=0
 F XPRI=0:0 S XPRI=$O(^ONCO(165.5,XPRI)) Q:XPRI'>""  D
 .S CNT=CNT+1 I CNT#100=0 W "."
 .Q:$P($G(^ONCO(165.5,XPRI,24)),"^",6)'="N"
 .D GETFLDS S NOTFOUND=0
 .S XXX="" F  S XXX=$O(PRIM(XXX)) Q:XXX=""  S CONPTR=$G(PRIM(XXX)) D
 ..S CONTACT=$G(^ONCO(165,CONPTR,0)),NEWACOS=$P($G(^ONCO(165,CONPTR,0)),"^",4)
 ..I CONTACT="" D DELETE Q
 ..I NEWACOS=""!(NEWACOS'?1"#"6N) S NOTFOUND=1,^TMP($J,"CONTINV",CONPTR)="" Q
 ..I NEWACOS?1"#"6N S NEWACOS=$E(NEWACOS,2,7)
 ..S ACOSIEN=$O(^ONCO(160.19,"B",NEWACOS,"")) I ACOSIEN="" S NOTFOUND=1,^TMP($J,"NOTFND",CONPTR)="" Q
 ..I ACOSIEN'="" D CONV
 ..Q
 .I NOTFOUND=1 S $P(^ONCO(165.5,XPRI,24),"^",6)="N" K PRIM,Z0,Z3,ZZ4 Q
 .I NOTFOUND'=1,$O(PRIM(""))'="" S ^ONCO(165.5,XPRI,0)=Z0,^ONCO(165.5,XPRI,3)=Z3 F X=0:0 S X=$O(ZZ4(X)) Q:X'>0  S ^ONCO(165.5,XPRI,4,X,0)=ZZ4(X)
 .I NOTFOUND'=1 S $P(^ONCO(165.5,XPRI,24),"^",6)="Y"
 .K PRIM,Z0,Z3,ZZ4 Q
 D ^ONCOPST2 ;routine to loop thru 160 file and convert field #24.5.
 I $O(^TMP($J,"CONTINV",""))'="" D
 .W !!?5,"Pointers to the following entries in the ONCOLOGY CONTACT (165) file could"
 .W !?5,"not be converted to point to the new ACOS NUMBER (160.19) file due to"
 .W !?5,"missing or invalid ACOS number data in the COMMENTS field (#3) of the"
 .W !?5,"ONCOLOGY CONTACT file:",!
 .W !,$J("Record #",15),"   Name"
 .W !,$J("--------",15),"   ----"
 .F X=0:0 S X=$O(^TMP($J,"CONTINV",X)) Q:X'>0  W !,$J(X,15),"   ",$P($G(^ONCO(165,X,0)),"^")
 .Q
 I $O(^TMP($J,"NOTFND",""))'="" D
 .W !!?5,"Pointers to the following entries in the ONCOLOGY CONTACT (165) file could"
 .W !?5,"not be converted to point to the new ACOS NUMBER (160.19) file due to an"
 .W !?5,"entry in the COMMENTS field (#3) of the ONCOLOGY CONTACT file that could"
 .W !?5,"not be found in the ACOS NUMBER file:",!
 .W !,$J("Record #",15),"   Name",?50,"# not found"
 .W !,$J("--------",15),"   ----",?50,"-----------"
 .F X=0:0 S X=$O(^TMP($J,"NOTFND",X)) Q:X'>0  W !,$J(X,15),"   ",$E($P($G(^ONCO(165,X,0)),"^"),1,30),?50,$P(^ONCO(165,X,0),"^",4)
 .Q
 I $O(^TMP($J,"CONTINV",""))'=""!($O(^TMP($J,"NOTFND",""))'="") D
 .W !!!?5,"Please ask the ONCOLOGY ADPAC to enter the correct ACOS numbers for the"
 .W !?5,"above entries in the COMMENTS field (#3) of the ONCOLOGY CONTACT (165)"
 .W !?5,"file.  Enter the ACOS number in the format '#nnnnnn' where 'nnnnnn' is the"
 .W !?5,"6-digit ACOS number, e.g. '#431910'.  For an ONCOLOGY CONCTACT that does"
 .W !?5,"not have an assigned ACOS number, enter a single '#' character and an entry"
 .W !?5,"will be added to the ACOS NUMBER file with a computed ACOS number.",!
 .W !?5,"When the correct numbers (or '#' characters) have been entered in the"
 .W !?5,"COMMENTS field, re-run the conversion by entering D ^ONCOPST1.  Continue"
 .W !?5,"this process until there are no exceptions."
 .Q
 I $O(^TMP($J,"CONTINV",""))="",$O(^TMP($J,"NOTFND",""))="" W !!?5,"No conversion exceptions." D ^ONCOPST4
 K ACOSIEN,ACOSIEN2,CCAD,CNT,CONTACT,CONTACT2,D,FIEN,FIRST,HOSPNAME,NEWACOS,NEWACOS2,NEWENTRY,NEWIEN,NEWNUM,NOTADD,NOTFOUND,PLACE,R,SUB,TMP,X,XCON,XFIRST,XPAT,XPRI,XXX,Z4
 K ^TMP($J,"CONTINV"),^TMP($J,"NOTFND"),^TMP($J,"NOTADD")
 Q
GETFLDS ;
 S Z0=$G(^ONCO(165.5,XPRI,0)),Z3=$G(^ONCO(165.5,XPRI,3)),Z4=$G(^ONCO(165.5,XPRI,4,0))
 I $P(Z0,"^",17)'="" S PRIM("DXF")=$P(Z0,"^",17)
 I $P(Z0,"^",18)'="" S PRIM("REF")=$P(Z0,"^",18)
 I $P(Z0,"^",19)'="" S PRIM("TRF")=$P(Z0,"^",19)
 I $P(Z3,"^",2)'="" S PRIM("SUR")=$P(Z3,"^",2)
 I $P(Z3,"^",5)'="" S PRIM("RAD")=$P(Z3,"^",5)
 I $P(Z3,"^",9)'="" S PRIM("CNS")=$P(Z3,"^",9)
 I $P(Z3,"^",12)'="" S PRIM("CHE")=$P(Z3,"^",12)
 I $P(Z3,"^",15)'="" S PRIM("HOR")=$P(Z3,"^",15)
 I $P(Z3,"^",18)'="" S PRIM("BRM")=$P(Z3,"^",18)
 I $P(Z3,"^",21)'="" S PRIM("HYP")=$P(Z3,"^",21)
 I $P(Z3,"^",24)'="" S PRIM("OTH")=$P(Z3,"^",24)
 I Z4="" Q
 F SUB=0:0 S SUB=$O(^ONCO(165.5,XPRI,4,SUB)) Q:SUB'>0  D
 .S ZZ4(SUB)=$G(^ONCO(165.5,XPRI,4,SUB,0)),PLACE="PLC"_SUB
 .I $P(ZZ4(SUB),"^",3)'="" S PRIM(PLACE)=$P(ZZ4(SUB),"^",3)
 .Q
 Q
CONV ;
 I "DXF^REF^TRF"[XXX D  Q  ;make changes to Z0
 .S R=$S(XXX="DXF":17,XXX="REF":18,XXX="TRF":19,1:999)
 .I R'=999 S $P(Z0,"^",R)=ACOSIEN
 .Q
 I "SUR^RAD^CNS^CHE^HOR^BRM^HYP^OTH"[XXX D  Q  ;make changes to Z3
 .S R=$S(XXX="SUR":2,XXX="RAD":5,XXX="CNS":9,XXX="CHE":12,XXX="HOR":15,XXX="BRM":18,XXX="HYP":21,XXX="OTH":24,1:999)
 .I R'=999 S $P(Z3,"^",R)=ACOSIEN
 .Q
 I XXX["PLC" D  Q  ;make changes to ZZ4(SUB) array
 .S R=$E(XXX,4,6),$P(ZZ4(R),"^",3)=ACOSIEN
 .Q
 Q
DELETE ; Delete dangling pointers.  If a field has a value which points to
 ; an entry in the CONTACT (165) file that no longer exists, delete it
 I XXX="" Q
 I XXX'["PLC" D @XXX Q
 I XXX["PLC" D PLC Q
DXF S $P(Z0,"^",17)="" Q
REF S $P(Z0,"^",18)="" Q
TRF S $P(Z0,"^",19)="" Q
SUR S $P(Z3,"^",2)="" Q
RAD S $P(Z3,"^",5)="" Q
CNS S $P(Z3,"^",9)="" Q
CHE S $P(Z3,"^",12)="" Q
HOR S $P(Z3,"^",15)="" Q
BRM S $P(Z3,"^",18)="" Q
HYP S $P(Z3,"^",21)="" Q
OTH S $P(Z3,"^",24)="" Q
PLC S R=$E(XXX,4,6),$P(ZZ4(R),"^",3)="" Q
