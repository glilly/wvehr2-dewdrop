MPIFVTQ ;SLC/ARS-BUILD DATA TO QUERY MPI RESPONSE PROCESS (ADDPAT) ;JUL 16, 1997
 ;;1.0; MASTER PATIENT INDEX VISTA ;**1,9,17,21,23,28,33,35**;30 Apr 99
 ;
 ; Integration Agreements Utilized:
 ;  ^DPT( -9 node check - #2762
 ;  ^DPT( "MPI" node - #2070
 ;  EXC, START, STOP ^RGHLLOG - #2796
 ;  NAME^VAFCPID2 - #3492
 ;
 Q  ;NOT an entry point
 ;
VTQ1(MPIIT,MPIOUT,HL,MPIQRYNM,MPISND) ;
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
 N MPITEST,MPISSN,MPIDTH,MPINM,MPIDOB,ERR
 S MPIOUT(0)=""
 I '$D(MPISND) S MPISND="00122;00108.1;00108.2;00110;00740;00111;00108.4;00126.1;00126.2;00108.3"
 ;validation check
 I '$D(HL) S MPIOUT(0)="-1^no encoding characters" Q
 I $G(HL("FS"))=""!($G(HL("ECH"))="") S MPIOUT(0)="-1^no encoding characters" Q
 I MPIIT="" S MPIOUT(0)="-1^invalid DFN" Q
 I $G(^DPT(MPIIT,-9))'="" S MPIOUT(0)="-1^Patient merged "_^DPT(MPIIT,-9) Q
 S MPIMPI=$G(^DPT(MPIIT,"MPI"))
 S:MPIMPI'="" MPIZICN=$P(^DPT(MPIIT,"MPI"),"^",1)
 I '$D(MPIFRES),$G(MPIZICN)'="" S MPIOUT(0)="-1^ICN already assigned "_MPIZICN Q
 S MPITEST=$G(^DPT(MPIIT,0))
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
EXC(IEN) ;
 Q:'$D(^DPT(IEN))
 D LOCAL^MPIFQ3(IEN)
 D START^RGHLLOG()
 D EXC^RGHLLOG(209,"DFN= "_IEN_" is Missing Required Field(s)",IEN)
 D STOP^RGHLLOG()
 Q
 ;
VTQC(MPISSN,MPIDTH,MPISND,HL,MPIQRYNM,MPIOUT,MPIIT) ;
 N MPIPOB,MPIPOBS,MPINM,MPI2MN,MPI1NM,QUERY,MPIDOB,RDF,MPIMOD
 N MPIHDTH,MPIZDOB,MPIXDOB,MPIMPI,MPIZICN,QUEDOB,MPI2NM,MPICS,MPIESC,MPIHDOB,MPIMNM,MPIMN
 N MPINMSFX,MPIRS,MPISCS,MPISEX,MPIZLOC
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
 ;
 I $G(MPIOUT(0))="" S MPIOUT(0)="1^good data"
 S MPIOUT(2)=QUERY
 Q
