PSOQRART        ;HINES/RMS- TIU OBJECT FOR REMOTE ALLERGIES VIA RDI ; 30 Nov 2007  7:56 AM
        ;;7.0;OUTPATIENT PHARMACY;**294**;DEC 1997;Build 13
        ;
        ;Reference to CKP^GMTSUP supported by DBIA 4231
        ;References to ORRDI1 supported by DBIA 4659
ENHS    ;ENTRY POINT FOR HEALTH SUMMARY OF REMOTE ALLERGY/ADR DATA
        N PSOQHDR,PSOQRET,PSOQART,PSOQRART,PSOQFAC,PSOQREAC,PSOQRDI,PSOQDOWN
        Q:'$G(DFN)
        S PSOQHDR=$$HAVEHDR^ORRDI1 I '+$G(PSOQHDR) D  Q
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . W !,"Remote Data from HDR not available"
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        D  Q:$G(PSOQDOWN)
        . I $D(^XTMP("ORRDI","OUTAGE INFO","DOWN")) H $$GET^XPAR("ALL","ORRDI PING FREQ")/2
        . I $D(^XTMP("ORRDI","OUTAGE INFO","DOWN")) S PSOQDOWN=1 D
        .. D CKP^GMTSUP Q:$D(GMTSQIT)
        .. W !,"WARNING: Connection to Remote Data Currently Down",!
        .. D CKP^GMTSUP Q:$D(GMTSQIT)
        D  ;RDI/HDR CALL ENCAPSULATION
        . D SAVDEV^%ZISUTL("PSOQHFS")
        . S PSOQRET=$$GET^ORRDI1(DFN,"ART")
        . D USE^%ZISUTL("PSOQHFS")
        . D RMDEV^%ZISUTL("PSOQHFS")
        I PSOQRET=-1 D  Q
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . W !,"Connection to Remote Data Not Available"
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        I '$D(^XTMP("ORRDI","ART",DFN))!('+PSOQRET) D  Q
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . W !,"No Remote Allergy/ADR Data available for this patient"
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W !,"FACILITY",?40,"ALLERGY/ADR",!,"--------",?40,"-----------"
        D CKP^GMTSUP Q:$D(GMTSQIT)
        F PSOQART=1:1:PSOQRET D
        . S PSOQFAC=$G(^XTMP("ORRDI","ART",DFN,PSOQART,"FACILITY",0))
        . S PSOQREAC=$G(^XTMP("ORRDI","ART",DFN,PSOQART,"REACTANT",0))
        . Q:$$YESCHK
        . Q:PSOQFAC']""!(PSOQREAC']"")
        . S PSOQREAC=$P(PSOQREAC,U,2)
        . S PSOQRART(PSOQFAC,PSOQREAC)=""
        S PSOQFAC="" F  S PSOQFAC=$O(PSOQRART(PSOQFAC)) Q:PSOQFAC']""  D  ;
        . S PSOQREAC="" F  S PSOQREAC=$O(PSOQRART(PSOQFAC,PSOQREAC)) Q:PSOQREAC']""  D  ;
        .. D CKP^GMTSUP Q:$D(GMTSQIT)
        .. W !,PSOQFAC,?40,PSOQREAC
        .. D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
YESCHK()        ;DO NOT INCLUDE IF A 'YES' ASSESSMENT
        I $P(PSOQREAC,U,2)'="YES" Q 0
        I $P(PSOQREAC,U,2)="YES" I $P(PSOQREAC,U,3)["99VA8" Q 1
        Q 1 ;STOP IF THERE IS ANY PROBLEMATIC DATA
        ;----------------------------------------------------------
