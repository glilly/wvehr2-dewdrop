MPIFVTQ ;SLC/ARS-BUILD DATA TO QUERY MPI RESPONSE PROCESS (ADDPAT) ; 8/15/08 5:01pm
        ;;1.0; MASTER PATIENT INDEX VISTA ;**1,9,17,21,23,28,33,35,52**;30 Apr 99;Build 7
        ;
        ; Integration Agreements Utilized:
        ;  ^DPT( -9 node check - #2762
        ;  ^DPT( "MPI" node - #2070
        ;  EXC, START, STOP ^RGHLLOG - #2796
        ;  NAME^VAFCPID2 - #3492
        ;
        Q  ;NOT an entry point
        ;
VTQ1(MPIIT,MPIOUT,HL,MPIQRYNM,MPISND)   ;
        ;MPIIT=DFN in patient file.
        ;MPIOUT=Array you want the VTQ/RDF put into.
        ;HL=Array of encoding characters and Field separator.
        ;MPIQRYNM=Name of query to put into message.
        ;MPISND (OPTIONAL) = item #'s separated by ; to be used to query.
        ;  default is DOB;SSN;LAST NAME;FIRST NAME;SUFFIX OF NAME;SEX;DOD;
        ;  POB-CITY;POB-STATE;MIDDLE NAME
        ;
        ;If invalid DFN, Patient Merged, if ICN already assigned, Test SSN, the VTQ query is not built and -1^'error message' returned in MPIOUT(0).
        ;
        ;If DOB does not contain a 7 digit date OR if name is not present, -1^Missing Required fields will be returned in MPIOUT(0).
        ;
        ;If patient has a date of death, the VTQ query is built with MPIOUT(0) returned with 0^Patient has date of death.  Programmer to decide if VTQ should be sent.
        ;
        N MPITEST,MPISSN,MPIDTH,MPINM,MPIDOB,ERR,MPITST11,MPITST13
        S MPIOUT(0)=""
        I '$D(MPISND) S MPISND="00122;00108.1;00108.2;00110;00740;00111;00108.4;00126.1;00126.2;00108.3;00114.1;00114.2;00114.3;00114.4;00114.5;00114.6;00114.8;00114.9;00116;00119;00125;00127;00100"
        ;validation check
        I '$D(HL) S MPIOUT(0)="-1^no encoding characters" Q
        I $G(HL("FS"))=""!($G(HL("ECH"))="") S MPIOUT(0)="-1^no encoding characters" Q
        I MPIIT="" S MPIOUT(0)="-1^invalid DFN" Q
        I $G(^DPT(MPIIT,-9))'="" S MPIOUT(0)="-1^Patient merged "_^DPT(MPIIT,-9) Q
        S MPIMPI=$G(^DPT(MPIIT,"MPI"))
        S:MPIMPI'="" MPIZICN=$P(^DPT(MPIIT,"MPI"),"^",1)
        I '$D(MPIFRES),$G(MPIZICN)'="" S MPIOUT(0)="-1^ICN already assigned "_MPIZICN Q
        S MPITEST=$G(^DPT(MPIIT,0))
        S MPITST11=$G(^DPT(MPIIT,.11)),MPITST13=$G(^DPT(MPIIT,.13))
        I MPITEST="" S MPIOUT(0)="-1^invalid DFN" Q
        I $P(MPITEST,"^")=""&($P(MPITEST,"^",2)="")&($P(MPITEST,"^",3)="")&($P(MPITEST,"^",9)="") D  Q
        .K MPIARR
        .S MPIOUT(0)="-1^stub entry in DPT"
        .S MPIARR(991.01)="@",MPIARR(991.02)="@",MPIARR(991.03)="@",MPIARR(991.05)="@",MPIARR(992)=MPIZICN,MPIARR(993)=+$$SITE^VASITE()
        .S ERR=$$DELALLTF^VAFCTFU(MPIZICN) ;clean up tf list
        .S ERR=$$UPDATE^MPIFAPI(MPIIT,"MPIARR",1,1) K MPIARR
        .;PATCH 33 - stub entry with local, remove local and don't send to MPI
        S MPISSN=$P(MPITEST,"^",9)
        S MPIDTH=""
        S:$G(^DPT(MPIIT,.35))'="" MPIDTH=$P(^DPT(MPIIT,.35),"^",1)
        I $G(MPIDTH)'="" S MPIOUT(0)="0^Patient has Date of Death "_MPIDTH
        D VTQC(MPISSN,MPIDTH,MPISND,.HL,MPIQRYNM,.MPIOUT,MPIIT)
        Q
EXC(IEN)        ;
        Q:'$D(^DPT(IEN))
        D LOCAL^MPIFQ3(IEN)
        D START^RGHLLOG()
        D EXC^RGHLLOG(209,"DFN= "_IEN_" is Missing Required Field(s)",IEN)
        D STOP^RGHLLOG()
        Q
        ;
VTQC(MPISSN,MPIDTH,MPISND,HL,MPIQRYNM,MPIOUT,MPIIT)     ;
        N MPIPOB,MPIPOBS,MPINM,MPI2MN,MPI1NM,QUERY,MPIDOB,RDF,MPIMOD
        N MPIHDTH,MPIZDOB,MPIXDOB,MPIMPI,MPIZICN,QUEDOB,MPI2NM,MPICS,MPIESC,MPIHDOB,MPIMNM,MPIMN
        N MPINMSFX,MPIRS,MPISCS,MPISEX,MPIZLOC,MPISTR1,MPISTR2,MPISTR3,MPICITY,MPISTPRV,XNOD
        N MPIZIPPL,MPICNTRY,MPICNTY,MPIRESPH,MPIMRTST,MPIETH,MPIDLT,MPIMBI
        I $G(MPIQRYNM)="" S MPIQRYNM="VTQ_PID_ICN_LOAD_1"
        S MPICS=$E(HL("ECH"),1)
        S MPIRS=$E(HL("ECH"),2)
        S MPISCS=$E(HL("ECH"),4)
        S MPIESC=$E(HL("ECH"),3)
        ;build RDF as the third segment
        D BLDRDF^MPIFSA2(.MPIOUT,3,MPIRS,MPICS)
        S QUERY="VTQ"_HL("FS")_MPIIT_HL("FS")_"T"_HL("FS")_MPIQRYNM_HL("FS")_"ICN"_HL("FS")
        ;
        I MPISND["00108" S MPINM=$P(MPITEST,"^") D NAME^VAFCPID2(MPIIT,.MPINM) ;agressive name reformatting
        ; ^ sending all or part of name
        I MPISND["00108.1" S MPI2NM=$P(MPINM,",",1) I MPI2NM'="" S QUERY=QUERY_"@00108.1"_MPICS_"EQ"_MPICS_MPI2NM
        ; ^ sending last name
        ;I MPISND["00122"&(MPISSN'="")&(MPISSN'["P") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00122"_MPICS_"EQ"_MPICS_MPISSN
        ; ^ **35 SENDING PSUEDO TO KNOW THAT THE SITE HAS A VALUE FOR SSN
        I MPISND["00122"&(MPISSN'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00122"_MPICS_"EQ"_MPICS_MPISSN
        ; ^ sending SSN
        I MPISND["00108.2" S MPI1NM=$P(MPINM,",",2),MPI1NM=$P(MPI1NM," ",1) I MPI1NM'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.2"_MPICS_"EQ"_MPICS_MPI1NM
        ; ^ sending first name
        I MPISND["00110" D
        .S MPIDOB=$P(MPITEST,"^",3)
        .Q:MPIDOB=""
        .S MPIHDOB=$$HLDATE^HLFNC(MPIDOB)
        .; send date of birth (convert to hl7 date format)
        .S MPIMOD=MPIDOB#100
        .I MPIQRYNM'="VTQ_PID_ICN_LOAD_1" S MPIZDOB=MPICS_"AND"_MPIRS_"@00110"_MPICS_"GN"_MPICS_MPIHDOB
        .I MPIQRYNM="VTQ_PID_ICN_LOAD_1" S MPIZDOB=MPICS_"AND"_MPIRS_"@00110"_MPICS_"EQ"_MPICS_MPIHDOB
        .S MPIXDOB=MPICS_"AND"_MPIRS_"@00110"_MPICS_"EQ"_MPICS_MPIHDOB
        .S QUEDOB=$S(MPIMOD>0:MPIXDOB,1:MPIZDOB)
        .S QUERY=QUERY_QUEDOB
        ; ^ sending date of birth
        I $D(MPIDTH),(MPISND["00740")&(MPIDTH'="") S MPIHDTH=$$HLDATE^HLFNC(MPIDTH),QUERY=QUERY_MPICS_"AND"_MPIRS_"@00740"_MPICS_"EQ"_MPICS_MPIHDTH
        ; ^ sending date of death
        I MPISND["00111" S:$G(^DPT(MPIIT,0))'="" MPISEX=$P(^DPT(MPIIT,0),"^",2) I MPISEX'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00111"_MPICS_"EQ"_MPICS_MPISEX
        ; ^ sending Sex
        I MPISND["00108.4" S MPI1NM=$P(MPINM,",",2),MPINMSFX=$P(MPI1NM," ",3) I MPINMSFX'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.4"_MPICS_"EQ"_MPICS_MPINMSFX
        ; ^ sending suffix name
        I MPISND["00126.1" S MPIPOB=$P(^DPT(MPIIT,0),"^",11) I MPIPOB'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00126.1"_MPICS_"EQ"_MPICS_MPIPOB
        ; send place of birth - city
        I MPISND["00126.2" S MPIPOBS=$P(^DPT(MPIIT,0),"^",12) I MPIPOBS'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00126.2"_MPICS_"EQ"_MPICS_$P($G(^DIC(5,+MPIPOBS,0)),"^",2)
        ; send place of birth - state
        I MPISND["00108.3" S MPIMN=$P($P(MPINM,",",2)," ",2) I MPIMN'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00108.3"_MPICS_"EQ"_MPICS_MPIMN
        ; send middle name
        ; **52 - Initiate project
        ; get address data
        D ADDR(MPITST11)
        I MPISND["00114.1"&(MPISTR1'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.1"_MPICS_"EQ"_MPICS_MPISTR1
        ; ^ send Street address line 1
        I MPISND["00114.2"&(MPISTR2'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.2"_MPICS_"EQ"_MPICS_MPISTR2
        ; ^ send Street Address Line 2
        I MPISND["00114.3"&(MPICITY'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.3"_MPICS_"EQ"_MPICS_MPICITY
        ; ^ send City
        ;I MPISND["00114.4"&(MPISTPRV'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.4"_MPICS_"EQ"_MPICS_MPISTPRV
        ; ^ send State/Province depending on US or Foreign address
        ;I MPISND["00114.5"&(MPIZIPPL'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.5"_MPICS_"EQ"_MPICS_MPIZIPPL
        ; ^ send Zip code/ Postal code depending on US or Foreign address
        ;I MPISND["00114.6"&(MPICNTRY'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.6"_MPICS_"EQ"_MPICS_MPICNTRY
        ; ^ send Country
        I MPISND["00114.8"&(MPISTR3'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.8"_MPICS_"EQ"_MPICS_MPISTR3
        ; ^ send Address Line 3
        ;I MPISND["00114.9"&(MPICNTY'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00114.9"_MPICS_"EQ"_MPICS_MPICNTY
        ; ^ send County
        I MPISND["00116" S MPIRESPH=$P(MPITST13,"^") I MPIRESPH'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00116"_MPICS_"EQ"_MPICS_MPIRESPH
        ; ^ send Residence Phone
        ;I MPISND["00119" S MPIMRTST=$P(MPITEST,"^",5) I MPIMRTST'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00119"_MPICS_"EQ"_MPICS_MPIMRTST
        ; ^ send Marital Status
        ;I MPISND["00125" S XNOD=$O(^DPT(MPIIT,.06,"")) I XNOD'="" S MPIETH=$P($G(^DPT(MPIIT,.06,XNOD,0)),"^") I MPIETH'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00125"_MPICS_"EQ"_MPICS_MPIETH
        ; ^ send Ethnicity
        ;I MPISND["00127" S MPIMBI=$P($G(^DPT(MPIIT,"MPIMB")),"^") I MPIMBI'="" S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00127"_MPICS_"EQ"_MPICS_MPIMBI
        ; ^ send Multiple Birth Indicator
        ;S MPIDLT=$$GETDLT(MPIIT)
        ;I MPISND["00100"&(MPIDLT'="") S QUERY=QUERY_MPICS_"AND"_MPIRS_"@00100"_MPICS_"EQ"_MPICS_MPIDLT
        ; ^ send Date Last Treated
        I $G(MPIOUT(0))="" S MPIOUT(0)="1^good data"
        S MPIOUT(2)=QUERY
        Q
GETDLT(MPIIT)   ;Get Date Last Treated
        N TFIEN,TFZN
        S TFIEN=$O(^DGCN(391.91,"APAT",MPIIT,+$$SITE^VASITE,0))
        I $G(TFIEN)'="" S TFZN=^DGCN(391.91,TFIEN,0)
        Q $P($G(TFZN),"^",3)
        ;
ADDR(MPITST11)  ;Get Address information
        ;
        S MPISTR1=$P($G(MPITST11),"^") ;Street address line 1
        S MPISTR2=$P($G(MPITST11),"^",2) ;Street address line 2
        S MPISTR3=$P($G(MPITST11),"^",3) ;Street address line 3
        S MPICITY=$P($G(MPITST11),"^",4) ;City
        ;S MPICNTRY=$P($G(MPITST11),"^",10) ;Country
        ;S MPICNTY=$P($G(MPITST11),"^",7) ;County
        ;I MPICNTRY=""!(MPICNTRY=1) D
        ;. ;Have USA address
        ;. S MPISTPRV=$P($G(MPITST11),"^",5) ;State
        ;. S MPIZIPPL=$P($G(MPITST11),"^",6) ;Zip code
        ;I MPICNTRY'="",(MPICNTRY'=1) D
        ;. ;Foreign Country
        ;. S MPISTPRV=$P($G(MPITST11),"^",8) ;Province
        ;. S MPIZIPPL=$P($G(MPITST11),"^",9) ;Postal code
        Q
