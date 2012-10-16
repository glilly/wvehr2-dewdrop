C0SMART   ; GPL - Smart Container Entry Points;2/22/12  17:05
        ;;1.0;VISTA SMART CONTAINER;;Sep 26, 2012;Build 5
        ;Copyright 2012 George Lilly.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        Q
EN(ZRTN,ZPATID,ZTYP,ZFORM,DEBUG)        ; return a Smart RDF file section ZTYP
        ;  for patient ZPATID; ZFORM defaults to rdf
        ; ZRTN is passed by reference
        ; For now, ZPATID is the DFN
        ;
        I '$D(ZFORM) S ZFORM="rdf"
        K ZRTN ; CLEAN RETURN
        N C0SARY
        I ZTYP="patient" D EN^C0SNHIN(.C0SARY,ZPATID,"patient")
        E  D EN^C0SNHIN(.C0SARY,ZPATID,"patient;"_ZTYP)
        I $G(C0SARY("patient",1,"id@value"))'=ZPATID D  Q  ;
        . W !,"Error Retreiving Patient Record"
        ;
        K C0XFDA
        ;
        N C0SGR ; graph
        ;
        ; processing table
        ;
        N C0SCTRL
        S C0SCTRL("med")="D MED^C0SMED(.C0SGR,.C0SARY)"
        S C0SCTRL("patient")="D PATIENT^C0SDEM(.C0SGR,.C0SARY)"
        S C0SCTRL("lab")="D LAB^C0SLAB(.C0SGR,.C0SARY)"
        S C0SCTRL("problem")="D PROB^C0SPROB2(.C0SGR,.C0SARY)"
        ;
        I '$D(C0SCTRL(ZTYP)) W !,ZTYP," ","Not Supported" Q  ;
        N ZX
        S ZX=C0SCTRL(ZTYP)
        X ZX ; 
        ;
        I '$D(C0SGR) Q  ;
        ;
        D getGraph^C0XGET1(.ZRTN,C0SGR,ZFORM)
        ;
        Q
        ;
