IMRIPST1 ;HCIOFO/FT-ICR POST-INIT ROUTINE ; 11/17/97  10:08
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
DQ ; Queue pharmacy archive date search
 K ZTUCI,ZTDTH,ZTIO,ZTSAVE
 S ZTRTN="RXARC^IMRIPST1"
 S ZTDTH=$$NOW^XLFDT(),ZTIO="",ZTDESC="ICR-RX ARCHIVE DATE SEARCH"
 D ^%ZTLOAD
 K ZTUCI,ZTDTH,ZTIO,ZTSAVE
 Q
RXARC ; Check for outpatient pharmacy archive date and store in File 158.9
 S (IMRFN,IMRSAC)=0
 F  S IMRFN=$O(^IMR(158,IMRFN)) Q:IMRFN'>0  D
 .S X=+^IMR(158,IMRFN,0) ;get encoded patient id
 .D XOR^IMRXOR Q:'$D(^DPT(X,0))  ;decode patient id
 .S IMRDFN=X ;use patient's dfn
 .S IMRACF=$$RXARC^IMRUTL(IMRDFN) ;check archive date for patient
 .S:IMRACF>IMRSAC IMRSAC=IMRACF ;save latest archive date
 .Q
 ;if archive date is found, then store in File 158.9
 I IMRSAC>0 S DA=$O(^IMR(158.9,0)) I DA>0 D
 .S IMRSAC=IMRSAC\1
 .S DIE="^IMR(158.9,",DR="99///"_IMRSAC
 .D ^DIE
 .Q
 K DA,DIE,DR,IMRDFN,IMRFN,IMRSAC
 Q
AAAD ; Find all File 158 records where the AGE AT AIDS DIAGNOSIS (#15.8)
 ; is a negative value. Calculate the correct value or change to null.
 S IMRNODE=$G(^IMR(158,IMRX1,2))
 Q:$P(IMRNODE,U,16)>0
 S $P(IMRNODE,U,16)=""
 S X2=$P($G(^IMR(158,IMRX1,0)),U,35)
 I X2'>0 S X2=$P($G(^IMR(158,IMRX1,0)),U,23)
 I IMRDOB,X2 S IMRAAAD=$$AGE^IMRUTL(IMRDOB,X2)
 I $G(IMRAAAD) S $P(IMRNODE,U,16)=IMRAAAD
 S ^IMR(158,IMRX1,2)=IMRNODE
 Q
