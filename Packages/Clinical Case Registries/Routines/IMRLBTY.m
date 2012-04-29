IMRLBTY ; HCIOFO/FAI - ADD LAB TYPE TO EXTRACT  ; 03/23/01  10:51
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**13**;Feb 09, 1998
 ; Process new entries first, then process existing entries
START S A="" F  S A=$O(^IMR(158.9,1,3,A)),B="" Q:A=""  F  S B=$O(^IMR(158.9,1,3,A,B)),C="" Q:B=""  F  S C=$O(^IMR(158.9,1,3,A,B,C)),D="" Q:C=""  F  S D=$O(^IMR(158.9,1,3,A,B,C,D)),L="" Q:D=""  F  S L=$O(^IMR(158.9,1,3,A,B,C,D,"B",L)) Q:L=""  D M
 Q
M S IMRGR=$P($G(^IMR(158.9,1,3,A,B,C,0)),U,1)
 S GROUP=$P($G(^IMR(158.96,IMRGR,0)),U,1)
 S:L=IMRLABT $P(^TMP($J,"IMRX",IMRC),U,10)=GROUP
 Q
CLEAR ; Kill Variables
 K IMRT1,IMRT2,DFN,IMRLD,IMRLD1,IMRLD2
 Q
