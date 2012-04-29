DGRP3   ;ALB/MRL - REGISTRATION SCREEN 3/CONTACT INFORMATION ;11/5/06  20:31
        ;;5.3;Registration;**634**;Aug 13, 1993;Build 38
        ; Modified from FOIA VISTA,
        ; Copyright (C) 2007 WorldVistA
        ;
        ; This program is free software; you can redistribute it and/or modify
        ; it under the terms of the GNU General Public License as published by
        ; the Free Software Foundation; either version 2 of the License, or
        ; (at your option) any later version.
        ;
        ; This program is distributed in the hope that it will be useful,
        ; but WITHOUT ANY WARRANTY; without even the implied warranty of
        ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ; GNU General Public License for more details.
        ;
        ; You should have received a copy of the GNU General Public License
        ; along with this program; if not, write to the Free Software
        ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
        S DGRPW=1,DGRPS=3 D H^DGRPU F I=.21,.211,.33,.331,.34 S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
        S DGAD=.21,DGA1=3,DGA2=1 D:$P(DGRP(.21),"^",1)]"" AL^DGRPU(24) S DGAD=.211,DGA1=3,DGA2=2 D:$P(DGRP(.211),"^",1)]"" AL^DGRPU(27)
        F DGRPI=.21,.211 S DGRPI1=$S(DGRPI=".21":"X",1:"X1") D SET
        S Z=1 D WW^DGRPV W "      NOK: " S Z=$E($P(X,"^",1),1,22),Z1=28 D WW1^DGRPV S DGRPW=0,Z=2 D WW^DGRPV W " NOK-2: ",$E($P(X1,"^",1),1,25) D AW
        S DGRPW=1,DGAD=.33,DGA1=3,DGA2=1 D:$P(DGRP(.33),"^",1)]"" AL^DGRPU(24) S DGAD=.331,DGA1=3,DGA2=2 D:$P(DGRP(.331),"^",1)]"" AL^DGRPU(27)
        F DGRPI=.33,.331 S DGRPI1=$S(DGRPI=".33":"X",1:"X1") D SET
        S Z=3 D WW^DGRPV W "  E-Cont.: " S Z=$E($P(X,"^",1),1,25),Z1=25 D WW1^DGRPV S DGRPW=0,Z=4 D WW^DGRPV W " E2-Cont.: ",$E($P(X1,"^",1),1,25) D AW
        K DGA S DGRPW=1,DGAD=.34,DGA1=3,DGA2=1 D:$P(DGRP(.34),"^",1)]"" AL^DGRPU(24) S DGRPI=.34,DGRPI1="X" D SET S Z=5 D WW^DGRPV W " Designee: ",$E($P(X,"^",1),1,25),?50,"Relation: ",$E($P(X,"^",2),1,25)
        F I=0:0 S I=$O(DGA(I)) Q:'I  S Z="              "_$E(DGA(I),1,27) W !,Z
        W !?7,"Phone: ",$P(X,"^",3),?41,"Work Phone: ",$P(X,"^",4)
        ;New EHR code    ;DAOU/WCJ  2/7/05
        ;New fields for agency EHR
        I $G(DUZ("AG"))="E" S DGRPW=0,Z=6 W ! D WW^DGRPV S DGRPI=$G(^DPT(DFN,19900)) D
        .W "Year arrived in U.S.: ",$P(DGRPI,"^",6),!
        .W "Mother's Country of Birth: ",$P(DGRPI,"^",4),!
        .W "Father's Country of Birth: ",$P(DGRPI,"^",5),!
        ;End EHR modifications
Q       K DGRPI,DGRPI1
        G ^DGRPP
        ;
SET     S DGRPX=DGRPU_"^"_DGRPU_"^"_DGRPU_"^"_DGRPU
        F DGRPX1=1,2,9,11 I $P(DGRP(DGRPI),"^",DGRPX1)]"" S $P(DGRPX,"^",$S(DGRPX1=1:1,DGRPX1=2:2,DGRPX1=9:3,1:4))=$P(DGRP(DGRPI),"^",DGRPX1)
        S @DGRPI1=DGRPX
        K DGRPX,DGRPX1
        Q
AW      W !?4,"Relation: ",$E($P(X,"^",2),1,25),?43,"Relation: ",$E($P(X1,"^",2),1,25) F I=0:0 S I=$O(DGA(I)) Q:'I  S Z=$E(DGA(I),1,27) S:(I#2) Z="              "_Z W:(I#2)!($X>50) ! W:(I#2) Z I '(I#2) W ?53,Z
        W !?7,"Phone: ",$P(X,"^",3),?46,"Phone: ",$P(X1,"^",3)
        W !?2,"Work Phone: ",$P(X,"^",4),?41,"Work Phone: ",$P(X1,"^",4)
        K DGA
        Q
