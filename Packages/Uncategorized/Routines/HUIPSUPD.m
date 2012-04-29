HUIPSUPD ; - updates orderable item file with PS Orderable Items  ; 2/1/05 5:09pm
 ;;1.0;1/25/05 7:55am - DLD - Pacific HUI;;;Build 1
 ;;This routine populates the drug orderable items
 ;
EN ; loop through PS(50.7 and add to OE Ordeable item
 N PSOIEN
 D DT^DICRW
 S PSOIEN=0 F  S PSOIEN=$O(^PS(50.7,PSOIEN)) Q:'PSOIEN  D ADD(PSOIEN)
 Q
ADD(PSOIEN) ; Calls PS Orderable Item update routines
 D EN^PSSPOIDT(PSOIEN),EN2^PSSHL1(PSOIEN,"MUP")
 Q
 ;
SET ; - updates view set
 N DIC,X,Y,IEN,D,TYPE,NM,DGNM,UPDTIME,ATTEMPT
 D DT^DICRW
 S DIC="^ORD(101.44,",DIC(0)="AQ"
 F  D ^DIC  Q:+Y  Q:X="^"
 Q:X="^"
 S IEN=+Y
 S NM=$P(Y,U,2),DGNM=$P(NM,"ORWDSET ",2),UPDTIME=$H,ATTEMPT=""
 W !,"Run ORWUL" D FVBLD^ORWUL
 Q
