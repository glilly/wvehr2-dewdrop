IMRP020 ;HCIOFO/SG - PATCH 20 INSTALLATION ; 2/14/03 9:40am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**20**;Feb 09, 1998
 ;
 ;***** ENVIRONMENT CHECK ENTRY POINT
ENVCHK ;
 Q:'$G(XPDENV)
 N I,IMRBUF,RC,SDT,TMP,ZTSK
 ;--- Check status of the nightly extract
 D OPTSTAT^XUTMOPT("IMR REGISTRY DATA",.IMRBUF)
 S (RC,SDT)=0
 F I=1:1:$G(IMRBUF)  K ZTSK  D  I $G(ZTSK(1))=2  S RC=1  Q
 . S ZTSK=$P(IMRBUF(I),"^")  Q:'ZTSK
 . D STAT^%ZTLOAD
 . S TMP=$P(IMRBUF(I),"^",2)
 . I TMP>0  S:'SDT!(TMP<SDT) SDT=TMP
 I RC  D  S XPDABORT=2  Q
 . W !,"Nightly extract must not be running during installation!",!
 ;---
 I SDT>0  D
 . S TMP=$$FMTE^XLFDT(SDT)
 . S TMP="on "_$P(TMP,"@")_" at "_$P(TMP,"@",2)
 . W !,"The nightly extract is scheduled to run "_TMP_"."
 . W !,"If you are going to schedule the installation, please, choose"
 . W !,"an appropriate time so that the post-install will either"
 . W !,"finish well before the nightly extract or start after its"
 . W !,"completion.",!
 E  D
 . W !,"The nighlty extract (the [IMR REGISTRY DATA] option is not"
 . W !,"scheduled. Do not forget to schedule it after completion of"
 . W !,"the installation.",!
 Q
