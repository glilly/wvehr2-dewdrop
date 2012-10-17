MPIFA40 ;BP/CMC-BUILD A40 MERGE MESSAGE ; 6/12/2010  3:06 PM
        ;;1.0; MASTER PATIENT INDEX VISTA ;**22,41,51,55**;30 Apr 99;Build 3
        ;
        ; Integration Agreements Utilized:
        ;  START, EXC, STOP^RGHLLOG - #2796
        ;  BLDEVN, BLDPD1, BLDPID^VAFCQRY - #3630
        ;
A40(DFN,DFN2,PICN)      ;BUILD AND SEND A40
        ;PICN should only be passed if the primary icn is different than the one currently stored in DFN
        N PID,PD1,EVN,PD1,MRG,MPI,RESLT,CNT,ICN1,ICN2,STN,SITA,TMP
        D INIT^HLFNC2("MPIF ADT-A40 SERVER",.HL)
        I $O(HL(""))="" Q "-1^"_$P(HL,"^",2)
        S HLECH=HL("ECH"),HLFS=HL("FS"),COMP=$E(HL("ECH"),1),REP=$E(HL("ECH"),2),SUBCOMP=$E(HL("ECH"),4)
        S ERR=""
        D BLDEVN^VAFCQRY(DFN,"1,2",.EVN,.HL,"A40",.ERR)
        Q:ERR'="" ERR
        D BLDPID^VAFCQRY(DFN,1,"ALL",.PID,.HL,.ERR) ;**41
        Q:ERR'="" ERR
        I $G(PICN)'="" D 
        .;RESET ICN IN PID TO BE THIS (PICN) PRIMARY ICN
        .I PICN[-1 S PICN=HL("Q")
        .I PICN'["V",PICN'=HL("Q") S PICN=PICN_"V"_$$CHECKDG^MPIFSPC(PICN)
        .S STN=$P($$SITE^VASITE,"^",3)
        .I $E($P(PICN,"^"),1,3)=STN S SITA=STN
        .I $E($P(PICN,"^"),1,3)'=STN S SITA="200M"
        .S PICN=PICN_COMP_COMP_COMP_"USVHA"_SUBCOMP_SUBCOMP_"0363"_COMP_"NI"_COMP_"VA FACILITY ID"_SUBCOMP_SITA_SUBCOMP_"L"
        .S TMP=$P(PID(1),HLFS,4)
        .S $P(TMP,REP,1)=PICN
        .S $P(PID(1),HLFS,4)=TMP
        .S $P(PID(1),HLFS,3)=PICN
        D BLDPD1^VAFCQRY(DFN,"3",.PD1,.HL,.ERR)
        Q:ERR'="" ERR
        D BLDMRG(DFN2,"1,7",.MRG,.HL,.ERR)
        S HLA("HLS",1)=EVN(1)
        S HLA("HLS",3)=PD1(1)
        S HLA("HLS",4)=MRG
        S CNT=0 F  S CNT=$O(PID(CNT)) Q:CNT=""  D
        .I CNT=1 S HLA("HLS",2)=PID(CNT)
        .I CNT>1 S HLA("HLS",2,CNT-1)=PID(CNT)
        S MPI=$$MPILINK^MPIFAPI()
        Q:$P($G(MPI),"^")=-1 "-1^No logical link defined for the MPI"
        S HLL("LINKS",1)="MPIF ADT-A40 CLIENT^"_MPI
        D GENERATE^HLMA("MPIF ADT-A40 SERVER","LM",1,.MPIFRSLT,"","") ;**41
        S RESLT=$S(+MPIFRSLT:MPIFRSLT,1:$P(MPIFRSLT,"^",3))
        S ^XTMP("MPIFA40%"_DFN,0)=$$FMADD^XLFDT(DT,5)_"^"_DT_"^"_"MPIA40 msg to MPI for DFN "_DFN
        I +RESLT D
        .S ICN1=$$GETICN^MPIF001(DFN),ICN2=$$GETICN^MPIF001(DFN2)
        .S ^XTMP("MPIFA40%"_DFN,DFN2,"MPI",0)="A"
        .S ^XTMP("MPIFA40%"_DFN,DFN2,"MPI",1)=ICN1_"^"_ICN2_"^"_RESLT
        K HLA,HLEID,HLL("LINKS"),COMP,REP,SUBCOMP,HLECH,HLFS,HLA("HLA"),HLA("HLS"),MPIFRSLT ;**41
        Q RESLT
        ;
RES     ;
        N NXT
        ; MPIC_1109/Patch 55: If the sending or receiving application is not
        ; MPIF TRIGGER, then just ignore this application acknowledgment. This
        ; message is not sent from MPI, and was probably sent in error.
        Q:$G(HL("SAN"))'="MPIF TRIGGER"!($G(HL("RAN"))'="MPIF TRIGGER")  ;**55
        F NXT=1:1 X HLNEXT Q:HLQUIT'>0  D
        .I $E(HLNODE,1,3)="MSA" S DFN=$P($P(HLNODE,HL("FS"),7),"=",2)
        .I $E(HLNODE,1,3)="MSA"&($P(HLNODE,HL("FS"),4)'="") D
        ..; ERROR RETURNED IN MSA - LOG EXCEPTION
        ..D START^RGHLLOG(HLMTIEN,"","")
        ..D EXC^RGHLLOG(208,$P(HLNODE,HL("FS"),4)_" for HL msg# "_HLMTIEN,DFN)
        ..D STOP^RGHLLOG(0)
        K ^XTMP("MPIFA40%"_DFN)
        Q
        ;
BLDMRG(IEN,FLD,SEG,HL,ERR)      ; bld MRG segment ONLY FIELDS 2 AND 8 SUPPORTED
        N NODE,MPIZN,MG,X,COMP,SUBCOMP,REP,NAME,ICN,SITE
        S COMP=$E(HL("ECH"),1),SUBCOMP=$E(HL("ECH"),4),REP=$E(HL("ECH"),2),ICN=""
        S MPIZN=$D(^DPT(IEN,0))
        I MPIZN="" S ERR="-1^No such DFN entry "_IEN Q
        S SEG="MRG"
        ;repeat prior ID's including ICN and DFN
        S NODE=$$MPINODE^MPIFAPI(IEN)
        I +NODE=-1 S NODE="" ;**51
        I NODE'="" S ICN=$P(NODE,"^",1)_"V"_$P(NODE,"^",2) ;**51
        S SITE=$P($$SITE^VASITE(),"^",3) ;**51
        I ICN=""!(ICN="V") S ICN=HL("Q") ;**51
        S MG(2)=ICN_COMP_COMP_COMP_"USVHA"_SUBCOMP_SUBCOMP_"0363"_COMP_"NI"_COMP_"VA FACILITY ID"_SUBCOMP_SITE_SUBCOMP_"L"_REP_IEN_COMP_COMP_COMP_"USVHA"_SUBCOMP_SUBCOMP_"0363"_COMP_"PI"_COMP_"VA FACILITY ID"_SUBCOMP_SITE_SUBCOMP_"L" ;**41
        ;NAME
        S NAME("FILE")=2,NAME("IENS")=IEN,NAME("FIELD")=.01
        S MG(8)=$$HLNAME^XLFNAME(.NAME,"",COMP)
        S $P(MG(8),COMP,7)="L"
        S $P(SEG,HL("FS"),2)=MG(2)
        S $P(SEG,HL("FS"),8)=MG(8)
        Q
