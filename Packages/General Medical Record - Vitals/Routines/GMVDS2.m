GMVDS2  ;HOIFO/RM,YH,FT-VITAL SIGNS DISPLAY ;6/7/07
        ;;5.0;GEN. MED. REC. - VITALS;**23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ;  #4290 - ^PXRMINDX global     (controlled)
        ; #10104 - ^XLFSTR calls        (supported)
        ;
        ;SETBP ; {called from GMVDS0}
        ;S GDT=GMRDAT,GDATE=GMRDAT+.00000014
        ;F  S GMRDAT=$O(^PXRMINDX(120.5,"PI",DFN,GMR(X),GMRDAT)) Q:GMRDAT'>0!(GMRDAT>GDATE)  S Y=0 F  S Y=$O(^PXRMINDX(120.5,"PI",DFN,GMR(X),GMRDAT,Y),-1) Q:$L(Y)'>0  D
        ;.I Y=+Y D
        ;..D F1205^GMVUTL(.GMVCLIO,Y)
        ;.I Y'=+Y D
        ;..D CLIO^GMVUTL(.GMVCLIO,Y)
        ;.S GMVCLIO(0)=$G(GMVCLIO(0)),GMVCLIO(5)=$G(GMVCLIO(5))
        ;.I GMVCLIO(0)=""!($P(GMVCLIO(0),U,8)="") Q
        ;.S GMRL=GMVCLIO(0)
        ;.S GMVLOOP=0,GMVQLIST=""
        ;.F GMVLOOP=1:1 Q:$P(GMVCLIO(5),U,GMVLOOP)=""  D
        ;..S GMVQNAME=$$FIELD^GMVGETQL(GMVLOOP,1,"E")
        ;..I GMVQNAME=""!(GMVQNAME=-1) Q
        ;..S GMVQLIST=GMVQLIST_$S(GMVQLIST'="":",",1:"")_GMVQNAME
        ;.D:X="BP" SETNODE^GMVDS0
        ;.D:X="P" SETP
        ;.Q
        ;S GMRDAT=GDT K GDT,GDATE
        ;Q
        ;SETP ;DISPLAY MULTIPLE PULSE
        ;S GMRL=GMVCLIO(0)
        ;N GG S GG=$P(GMRL,"^",8),OK=0 D  Q:'OK
        ;.I "REFUSEDPASSUNAVAILABLE"[$$UP^XLFSTR(GG) Q
        ;.I GMVCLIO(5)="" S OK=1 Q
        ;.I $P(GMVCLIO(5),U,GMVLOOP)=GAPICAL S OK=1 Q
        ;.I $P(GMVCLIO(5),U,GMVLOOP)=GBRACHI S OK=1 Q
        ;.I $P(GMVCLIO(5),U,GMVLOOP)=GRADIAL S OK=1
        ;S GMRL1=$P(GMRL,"^") ;adding trailing zeros to time if necessary
        ;S $P(GMRL1,".",2)=$P(GMRL1,".",2)_"0000"
        ;S $P(GMRL1,".",2)=$E($P(GMRL1,".",2),1,4)
        ;S $P(GMRL,"^")=GMRL1
        ;K GMRL1
        ;I GMRL'="" D
        ;.S GMRDATA(X,$P(GMRL,"^"),Y)=$P(GMRL,"^",8),GMRDATS=1
        ;.S GMRVARY(X,$P(GMRL,U,1),Y)=GMVQLIST
        ;.Q
        ;Q
