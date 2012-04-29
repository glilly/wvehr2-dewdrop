AUPNPAT2 ; IHS/CMI/LAB - PATIENT ELIGIBILITY EXTRINSICS ; [ 05/09/2003  8:02 AM ]
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
 Q
 ;
 ;---------
 ; MCR:     Input -  P = DFN
 ;                   D = Date
 ;          Output - 1 = Yes, patient is/was MCare eligible on date D.
 ;                   0 = No, or unable.
 ;
 ;      Examples: I $$MCR^AUPNPAT(DFN,2930701)
 ;                S AGMCR=$$MCR^AUPNPAT(DFN,DT)
 ;
MCR(P,D) ;EP - Is patient P medicare eligible on date D.  1 = yes, 0 = no.
 ; I = IEN in ^AUPNMCR multiple.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G MCRX
 I $P(^DPT(P,0),U,19) G MCRX
 I '$D(^AUPNPAT(P,0)) G MCRX
 I '$D(^AUPNMCR(P,11)) G MCRX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCRX
 S I=0
 F  S I=$O(^AUPNMCR(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNMCR(P,11,I,0),U)>D
 . I $P(^AUPNMCR(P,11,I,0),U,2)]"",$P(^(0),U,2)<D Q
 . S Y=1
 .Q
MCRX ;
 Q Y
 ;
 ;----------
 ; MCD:     Input -  P = DFN
 ;                   D = Date
 ;          Output - 1 = Yes, patient is/was MCaid eligible on date D.
 ;                   0 = No, or unable.
 ;
 ;      Examples: I $$MCD^AUPNPAT(DFN,2930701)
 ;                S AGMCD=$$MCD^AUPNPAT(DFN,DT)
 ;
MCD(P,D) ;EP - Is patient P medicaid eligible on date D.
 ; I = IEN.
 ; J = Node 11 IEN in ^AUPNMCD.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,J,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G MCDX
 I $P(^DPT(P,0),U,19) G MCDX
 I '$D(^AUPNPAT(P,0)) G MCDX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCDX
 S I=0 F  S I=$O(^AUPNMCD("B",P,I)) Q:I'=+I  D
 .Q:'$D(^AUPNMCD(I,11))
 .S J=0 F  S J=$O(^AUPNMCD(I,11,J)) Q:J'=+J  D
 ..Q:J>D
 ..I $P(^AUPNMCD(I,11,J,0),U,2)]"",$P(^(0),U,2)<D Q
 ..S Y=1
 ..Q
 .Q
 ;
MCDX ;
 Q Y
 ;
 ;----------
 ; MCDPN:   Input -  P = DFN
 ;                   D = Date
 ;                   F = Form for output of plan (Insurer) name.
 ; If F = "E", return external form, else pointer to INSURER file.
 ;          Output - Literal = Cleartext name of insurer.
 ;                   Number = Pointer to INSURER file.
 ;
 ;      Examples: I $$MCDPN^AUPNPAT(DFN,2930701)
 ;                S AGMCDPN=$$MCDPN^AUPNPAT(DFN,DT,"E")
 ;
MCDPN(P,D,F) ;EP - return medicaid plan name for patient P on date D in form F.
 ; I = IEN
 ; J = Node 11 IEN
 I '$G(P) Q ""
 I '$G(D) Q ""
 S F=$G(F)
 NEW I,J,Y
 S Y="",U="^"
 I '$D(^DPT(P,0)) G MCDPNX
 I $P(^DPT(P,0),U,19) G MCDPNX
 I '$D(^AUPNPAT(P,0)) G MCDPNX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCDPNX
 S I=0
 F  S I=$O(^AUPNMCD("B",P,I)) Q:I'=+I  D
 . Q:'$D(^AUPNMCD(I,11))
 . S J=0
 . F  S J=$O(^AUPNMCD(I,11,J)) Q:J'=+J  D
 .. Q:J>D
 .. I $P(^AUPNMCD(I,11,J,0),U,2)]"",$P(^(0),U,2)<D Q
 .. S Y=$P(^AUPNMCD(I,0),U,10)
 .. I Y]"" S Y=$S(F="E":$P(^AUTNINS(Y,0),U),1:Y)
 ..Q
 .Q
 ;
MCDPNX ;
 Q Y
 ;
 ;----------
 ; PI:      Input -  P = DFN
 ;                   D = Date
 ;          Output - 1 = Yes, patient is/was PI eligible on date D.
 ;                   0 = No, or unable.
 ;
 ;      Examples: I $$PI^AUPNPAT(DFN,2930701)
 ;                S AGPI=$$PI^AUPNPAT(DFN,DT)
 ;
PI(P,D) ;EP - Is patient P private insurance eligible on date D. 1= yes, 0=no.
 ; I = IEN
 ; Y = 1:yes, 0:no
 ; X = Pointer to INSURER file.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y,X
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G PIX
 I $P(^DPT(P,0),U,19) G PIX
 I '$D(^AUPNPAT(P,0)) G PIX
 I '$D(^AUPNPRVT(P,11)) G PIX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G PIX
 S I=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S X=$P(^AUPNPRVT(P,11,I,0),U) Q:X=""
 . Q:$P(^AUTNINS(X,0),U)["AHCCCS"
 . Q:$P(^AUPNPRVT(P,11,I,0),U,6)>D
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S Y=1
 .Q
PIX ;
 Q Y
 ;
 ;----------
 ; PIN:     Input -  P = DFN
 ;                   D = Date
 ;                   F = Form for output of plan (Insurer) name.
 ; If F = "E", return external form, else pointer to INSURER file.
 ;          Output - Literal = Cleartext name of insurer.
 ;                   Number = Pointer to INSURER file.
 ;
 ;      Examples: I $$PIN^AUPNPAT(DFN,2930701)
 ;                S AGPIN=$$PIN^AUPNPAT(DFN,DT,"E")
 ;
PIN(P,D,F) ;EP - return private insurer name for patient P on date D in form F
 ; I = IEN
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y,J
 S F=$G(F)
 S Y="",U="^",J=""
 I '$D(^DPT(P,0)) G PINX
 I $P(^DPT(P,0),U,19) G PINX
 I '$D(^AUPNPAT(P,0)) G PINX
 I '$D(^AUPNPRVT(P,11)) G PINX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G PINX
 S I=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S Y=$P(^AUPNPRVT(P,11,I,0),U)
 . I $P(^AUTNINS(Y,0),U)["AHCCCS" Q
 . I $P(^AUPNPRVT(P,11,I,0),U,6)>D Q
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S J=$S(F="E":$P(^AUTNINS(Y,0),U),1:Y)
 .Q
PINX ;
 Q J
 ;
 ;Begin New Code;IHS/SET/GTH AUPN*99.1*8 10/04/2002
RRE(P,D) ;EP - Does pt have Railroad insurance on date?  1 = yes, 0 = no.
 ; I = IEN in ^AUPNRRE multiple.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) Q 0
 I $P($G(^DPT(P,0)),U,19) Q 0
 I '$D(^AUPNPAT(P,0)) Q 0
 I '$D(^AUPNRRE(P,11)) Q 0
 I $D(^DPT(P,.35)),$P(^DPT(P,.35),U)]"",$P($G(^DPT(P,.35)),U)<D Q 0
 S I=0
 F  S I=$O(^AUPNRRE(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNRRE(P,11,I,0),U)>D
 . I $P($G(^AUPNRRE(P,11,I,0)),U,2)]"",$P($G(^AUPNRRE(P,11,I,0)),U,2)<D Q
 . S Y=1
 .Q
RREX ;
 Q Y
 ;
 ;End New Code;IHS/SET/GTH AUPN*99.1*8 10/04/2002
