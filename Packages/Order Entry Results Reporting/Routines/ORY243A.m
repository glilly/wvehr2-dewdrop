ORY243A ;SLCOIFO - Pre and Post-init for patch OR*3*243 ;4/25/07  14:12
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
INPQCONV        ;
        N DA,DIE,DR,INPDG,TEXT,TYPE,UDDG,X0
        S TEXT(1)="Converting Inpatient Medications Quick Orders to"
        S TEXT(2)="Unit Dose Medications Quick Orders."
        D MES^XPDUTL(.TEXT)
        S UDDG=$O(^ORD(100.98,"B","UNIT DOSE MEDICATIONS","")) Q:UDDG'>0
        S INPDG=$O(^ORD(100.98,"B","INPATIENT MEDICATIONS","")) Q:INPDG'>0
        S DIE="^ORD(101.41,"
        S DA=0 F  S DA=$O(^ORD(101.41,DA)) Q:DA'>0  D
        . S X0=$G(^ORD(101.41,DA,0))
        .I $P(X0,U,4)="Q",$P(X0,U,5)=INPDG D
        ..S DR="5///^S X=UDDG" D ^DIE
        Q
        ;
IVORCON ;
        N ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO,TEXT,ZTSK
        S ZTDESC="Delayed IV Order conversion"
        S TEXT=ZTDESC_" has been queued, task number "
        S ZTRTN="IVORCONQ^ORY243A"
        S ZTIO=""
        S ZTDTH=$$NOW^XLFDT
        D ^%ZTLOAD
        I $D(ZTSK) S TEXT=TEXT_ZTSK D MES^XPDUTL(.TEXT)
        Q
        ;
IVORCONQ        ;
        ;This code convert pre CPRS 27 delayed IV orders to a new order.
        N DELSTAT,EVNT,FDA,MSG,IVDIAL,NODE,PAT,ORIEN
        S IVDIAL=$O(^ORD(101.41,"B","PSJI OR PAT FLUID OE","")) Q:IVDIAL'>0
        S DELSTAT=$O(^ORD(100.01,"B","DELAYED","")) Q:DELSTAT'>0
        S PAT="" F  S PAT=$O(^OR(100,"AEVNT",PAT)) Q:PAT=""  D
        .S EVNT="" F  S EVNT=$O(^OR(100,"AEVNT",PAT,EVNT)) Q:EVNT=""  D
        ..S ORIEN="" F  S ORIEN=$O(^OR(100,"AEVNT",PAT,EVNT,ORIEN)) Q:ORIEN=""  D
        ...S NODE=$G(^OR(100,ORIEN,0))
        ...I +$P(NODE,U,5)'=IVDIAL Q
        ...I $P($G(^OR(100,ORIEN,3)),U,3)'=DELSTAT Q
        ...I $D(^OR(100,ORIEN,4.5,"ID","TYPE"))>0 Q
        ...S FDA(100.045,"+2,"_ORIEN_",",.01)=20
        ...S FDA(100.045,"+2,"_ORIEN_",",.02)="OR GTX IV TYPE"
        ...S FDA(100.045,"+2,"_ORIEN_",",.03)=1
        ...S FDA(100.045,"+2,"_ORIEN_",",.04)="TYPE"
        ...S FDA(100.045,"+2,"_ORIEN_",",1)="C"
        ...D UPDATE^DIE("E","FDA","","MSG")
        Q
        ;
