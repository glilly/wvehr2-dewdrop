VAFHLZDP        ;ALB/MLI,TDM - Creates HL7 segments ZDP and/or ZIC ; 12/12/05 3:49pm
        ;;5.3;Registration;**33,653,688**;Aug 13, 1993;Build 29
        ;
        ; This routine will return the ZDP (dependent) segment for the
        ; dependent specified by the variable VAFIEN.
        ;
EN(VAFIEN,VAFSTR,VAFNUM,VAFMTDT,VAFIADT)        ; Call to produce ZDP segment for given individual
        ;
        ;
        ;  Input:  VAFIEN   as IEN of PATIENT RELATION (#408.12) file
        ;          VAFSTR   as string of desired fields separated by commas
        ;          VAFNUM   as the number desired for the set id (default = 1)
        ;          VAFMTDT  as the date of the means test (default = DT)
        ;          VAFIADT  as spouse/dependent inactivation date (optional)
        ;
        ; Output:  String of fields forming HL7 ZDP segment
        ;
        N NODE,NODE0,X,VAFY,NODE1
        S NODE=$$DEM^DGMTU1(+$G(VAFIEN))
        I $G(VAFSTR)']"" G QUIT
        S $P(VAFY,HLFS,7)="",VAFSTR=","_VAFSTR_","
        S $P(VAFY,HLFS,1)=$S($G(VAFNUM):VAFNUM,1:1)
        S VAFMTDT=$S($G(VAFMTDT):VAFMTDT,1:DT)
        I VAFSTR[",2," S X=$$HLNAME^HLFNC($P(NODE,"^",1)),$P(VAFY,HLFS,2)=$S(X]"":X,1:HLQ) ; name
        I VAFSTR[",3," S $P(VAFY,HLFS,3)=$S($P(NODE,"^",2)]"":$P(NODE,"^",2),1:HLQ) ; sex
        I VAFSTR[",4," S X=$$HLDATE^HLFNC($P(NODE,"^",3)),$P(VAFY,HLFS,4)=$S(X]"":X,1:HLQ) ; dob
        I VAFSTR[",5," S $P(VAFY,HLFS,5)=$S($P(NODE,"^",9)]"":$P(NODE,"^",9),1:HLQ) ; ssn
        I VAFSTR[",6," D
        .S NODE0=$G(^DGPR(408.12,+$G(VAFIEN),0))
        .S $P(VAFY,HLFS,6)=$S($P(NODE0,"^",2)]"":$P(NODE0,"^",2),1:HLQ) ; relationship to patient
        I VAFSTR[",7," S $P(VAFY,HLFS,7)=+$G(VAFIEN) ; internal entry number
        I VAFSTR[",8,",$$REL^DGMTU1(VAFIEN)="SPOUSE" D
        .S NODE1=$$NODE1(+$G(VAFIEN))
        .S $P(VAFY,HLFS,8)=$S($P(NODE1,"^")]"":$P(NODE1,"^"),1:HLQ) ; spouse's maiden name
        I VAFSTR[",9," D
        .S X=-($E(VAFMTDT,1,3)-1_"1231.9"),X=-$O(^DGPR(408.12,+$G(VAFIEN),"E","AID",X))
        .S X=$$HLDATE^HLFNC(X),$P(VAFY,HLFS,9)=$S(X]"":X,1:HLQ) ; effective date
        I VAFSTR[",10," S $P(VAFY,HLFS,10)=$S($P(NODE,"^",10)]"":$P(NODE,"^",10),1:HLQ) ; pseudo ssn reason
        I VAFSTR[",11," S X=$$HLDATE^HLFNC($G(VAFIADT)),$P(VAFY,HLFS,11)=$S(X]"":X,1:HLQ) ; inactivation date
        ;
QUIT    Q "ZDP"_HLFS_$G(VAFY)
        ;
NODE1(DGPRI)    ;GET Node 1 of Patient Relation
        N DGVPI,DGVP1
        S DGVPI=$P($G(^DGPR(408.12,DGPRI,0)),"^",3)
        I DGVPI]"" S DGVP1=$G(@("^"_$P(DGVPI,";",2)_+DGVPI_",1)"))
        Q $S($G(DGVP1)]"":DGVP1,1:"")
