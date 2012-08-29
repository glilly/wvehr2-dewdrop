DG53244U ;ALB/JDS,BPOIFO/KEITH - Patient Name Standardization ; 27 Jan 2002 11:55 PM
 ;;5.3;Registration;**244,620**;Aug 13, 1993
 ;Adapted from XLFNAME3 MKO
RUN(DGFLAG) ;Convert PATIENT file names;
 ;In: DGFLAG [ "U"  : Quit, use existing global
 ;           [ "K"  : Kill ^XTMP. generate global 
 ;           [ "P"  : Kill ^XTMP, update names, generate global
 ;
 ;Use existing global to print
 Q:DGFLAG="U"
 ;
 N DGIENS,DGNAM,DGNMSP,DGPVAL,DPTINV,DGQ,DGTOTAL,DGOUT,DGNCMG,DGNOFDEL
 N DGA,DGI,DPTFIL,DPTFLD,DPTIENS,DGFIELD,DGTYPE,DPTA,DPTI,VAFHCA08,DGZ
 N DPTVALUE,DGTEXT,VAFCA08,VAFCNO,DGENUPLD,DPTFN,DGPRUN,DGXRARY,DGMPI
 N DGICN
 ;Initialize variables
 S DGNMSP="DPTNAME",DGQ="""",DGOUT=0
 F DGI=1:1 S DGA=$T(FIELD+DGI) Q:(DGA'[";;")  D
 .S DGFIELD(DGI,$P($P(DGA,";;",2),U,3))=$P(DGA,";;",2) Q
 D XRARY^DG53244V
 ;Set up ^XTMP
 I '$G(^XTMP(DGNMSP,0,0)) D
 .K ^XTMP(DGNMSP)
 .S ^XTMP(DGNMSP,0)=$$FMADD^XLFDT(DT,90)_"^"_DT
 .I DGFLAG="P" D
 ..S ^XTMP(DGNMSP,0,0)=$$NOW^XLFDT(),$P(^XTMP(DGNMSP,0),U,4)=0
 ..S $P(^XTMP(DGNMSP,0),U,3)="Perform Name Conversion"
 ..Q
 .I DGFLAG="K" S $P(^XTMP(DGNMSP,0),U,3)="Generate Report Data"
 .I '$D(^XTMP(DGNMSP,"STATS")) D
 ..S $P(^XTMP(DGNMSP,"STATS",2,.01),U,7)="Patient name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.211),U,7)="Primary NOK name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.2191),U,7)="Secondary NOK name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.2401),U,7)="Father's name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.2402),U,7)="Mother's name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.2403),U,7)="Mother's maiden name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.331),U,7)="Prim. E-contact name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.3311),U,7)="2nd E-contact name"
 ..S $P(^XTMP(DGNMSP,"STATS",2,.341),U,7)="Designee name"
 ..S $P(^XTMP(DGNMSP,"STATS",2.01,.01),U,7)="Alias name"
 ..S $P(^XTMP(DGNMSP,"STATS",2.101,30),U,7)="Attorney's name"
 I DGFLAG="P" D
 .S $P(^XTMP(DGNMSP,0),U)=$$FMADD^XLFDT(DT,90)
 .S $P(^XTMP(DGNMSP,0),U,5)="RUN"
 .S DGPRUN=$O(^XTMP(DGNMSP,0,""),-1)+1
 .S ^XTMP(DGNMSP,0,DGPRUN)=$$NOW^XLFDT()_"^^"_+$P($G(^XTMP(DGNMSP,"STATS")),U)
 .D MGOUT^DG53244T(.DGNCMG)  ;Remove name change mail group
 .Q
 ;
 ;Prevent messages to HEC
 S DGENUPLD="ENROLLMENT/ELIGIBILITY UPLOAD IN PROGRESS"
 S VAFCNO=1  ;Prevent MPI messages
 S (VAFCA08,VAFHCA08)=1  ;Prevent PIMS Generic Messaging
 S DGNOFDEL=1  ;Prevent deletion of contact address fields
 ;
LOOP ;Loop through Patient file
 S DGIEN=+$P(^XTMP(DGNMSP,0),U,4)
 F  S DGIEN=$O(^DPT(DGIEN)) Q:'DGIEN!$$LAST()  D
 .;Skip merging patients
 .Q:$P($G(^DPT(DGIEN,0)),U)["MERGING INTO"
 .;Skip patients that have been merged to another record
 .Q:$D(^DPT(DGIEN,-9))
 .;Evaluate field values
 .S DGIENS=DGIEN_",",DGMPI=0
 .S DGZ=0 F  S DGZ=$O(DGFIELD(DGZ)) Q:'DGZ  D
 ..S DPTA=""  F  S DPTA=$O(DGFIELD(DGZ,DPTA)) Q:DPTA=""  D
 ...Q:'$D(^DPT(DGIEN,$P(DPTA,";")))
 ...S DGTYPE=DGFIELD(DGZ,DPTA),DPTFLD=$P(DGTYPE,U,2)
 ...S DPTMAX=$P(DGTYPE,U,5) S:'DPTMAX DPTMAX=35
 ...I $L(DPTA,";")=3 D  Q
 ....F DPTI=0:0 S DPTI=$O(^DPT(DGIEN,$P(DPTA,";"),DPTI)) Q:'DPTI  D
 .....S DPTIENS=DGIEN_","_DPTI_",",DPTFIL=$P(DGTYPE,U,6)
 .....S DPTVALUE=$P($G(^DPT(DGIEN,$P(DPTA,";"),DPTI,$P(DPTA,";",2))),U,$P(DPTA,";",3))
 .....Q:'$L(DPTVALUE)
 .....D UPDATE(DGFLAG,DPTFIL,DPTIENS,DPTFLD,DPTVALUE,DGNMSP,DPTMAX,DPTA)
 ...S DPTIENS=DGIEN_",",DPTFIL=2
 ...S DPTVALUE=$P($G(^DPT(DGIEN,$P(DPTA,";"))),U,$P(DPTA,";",2))
 ...Q:'$L(DPTVALUE)
 ...D UPDATE(DGFLAG,DPTFIL,DPTIENS,DPTFLD,DPTVALUE,DGNMSP,DPTMAX,DPTA,.DGMPI)
 ..S $P(^XTMP(DGNMSP,0),U,4)=DGIEN
 .I DGMPI D  ;Send MPI message
 ..D RMPI(1) S DGICN=$$GETICN^MPIF001(DGIEN)
 ..;No ICN, don't send message
 ..I +DGICN=-1 S DGICN=0 D RMPI(2)
 ..;Local ICN, don't send message
 ..I $P($$SITE^VASITE(),"^",3)=$E(DGICN,1,3) S DGICN=0 D RMPI(3)
 ..I DGICN'=0 N X S X="MPIFA31B" X ^%ZOSF("TEST") D RMPI(4) I $T S DGMPI=$$A31^MPIFA31B(DGIEN) D RMPI(5,DGMPI)
 ..;Log exception to MPI if problem generating ICN
 ..I +DGMPI=-1 D RMPI(6),START^RGHLLOG(),EXC^RGHLLOG(220,"Problem generating A31 "_$P(DGMPI,"^",2),DGIEN),STOP^RGHLLOG()
 ;Send notification message
 Q:DGFLAG'="P"
 D MGIN^DG53244T(DGNCMG)  ;Replace name change mail group
 I 'DGIEN,'DGOUT S $P(^XTMP(DGNMSP,0,0),U,2)=$$NOW^XLFDT()
 S $P(^XTMP(DGNMSP,0,DGPRUN),U,2)=$$NOW^XLFDT()
 S $P(^XTMP(DGNMSP,0,DGPRUN),U,4)=+$P(^XTMP(DGNMSP,"STATS"),U)
 S $P(^XTMP(DGNMSP,0),U,5)="STOP"
MSG K DGTEXT
 N XMY,XMTEXT,XMDUN,XMDUZ,XMSUB,XMZ,DGLINE
 S DGLINE="",$P(DGLINE,"-",80)=""
 S XMSUB="Patient Name Conversion Process"
 S XMY("G.PMSTRACK@FORUM.VA.GOV")=""
 S XMY(+$G(DUZ))="",(XMDUN,XMDUZ)="Patch DG*5.3*244"
 S DGTEXT(1,0)="The Patient Name Standardization conversion has completed" S DGTEXT=1
 I DGOUT D
 .S DGTEXT(1,0)="The Patient Name Standardization was Stopped"
 .S DGTEXT(2,0)="Please remember to complete the patient name conversion in the future."
 .S DGTEXT=2
 S DGOUT=0 D STATS^DG53244V(.DGTEXT)
 S XMTEXT="DGTEXT("
 D ^XMD
 Q
 ;
UPDATE(DGFLAG,DGFIL,DGIENS,DGFLD,DGNAM,DGNMSP,DPTMAX,DPTA,DGMPI) ;Process name field
 ;
 N DGAUD,DGFDA,DGMSG,DIERR,DGOLD
 ;Total names evaluated
 S $P(^XTMP(DGNMSP,"STATS"),U)=$P($G(^XTMP(DGNMSP,"STATS")),U)+1
 ;Total evaluated by field
 S $P(^XTMP(DGNMSP,"STATS",DGFIL,DGFLD),U)=$P($G(^XTMP(DGNMSP,"STATS",DGFIL,DGFLD)),U)+1
 ;Format name
 S DGOLD=$G(DGNAM)
 S DGNAM=$$FORMAT^XLFNAME7(.DGNAM,3,DPTMAX,,2,.DGAUD,$S(DGFLD=.2403:1,1:0))
 D:(DGAUD'=0) RECORD(DGFIL,DGFLD,DGIENS,DGNAM,.DGAUD,DGNMSP,DGIEN,DGOLD)
 Q:DGFLAG'="P"  ;Processing only
 Q:DGAUD=2  ;Unconvertible
 ;Update components if name is not changed
 I DGAUD=0 D  Q
 .N DGI,DA,X,DG20NAME,XUNOTRIG
 .F DGI=2.1,1.1 D
 ..S:(DGFIL=2) DA=DGIEN S:(DGFIL'=2) DA(1)=DGIEN,DA=$P(DGIENS,",",2)
 ..S X=DGNAM X DGXRARY($P(DGFIELD(DGZ,DPTA),U,7),DGI)
 ..Q
 .Q
 ;Update source name if different
 S DPTINV=$TR($$INV(DGIENS),":",",")_","
 S DGFDA(DGFIL,DPTINV,DGFLD)=DGNAM
 D FILE^DIE("","DGFDA","DGMSG") K DIERR,DGMSG
 ;Changes of interest to MPI
 I DGAUD=1,DGFIL=2 D
 .I DGFLD=.01 S DGMPI=1
 .I DGFLD=.2403,DGOLD_","'=DGNAM S DGMPI=1
 Q
 ;
LAST() ;Check stop point
 I $P(^XTMP(DGNMSP,0),U,5)="STOP" S DGOUT=1 Q DGOUT
 I $G(DGLIM)="SR",DGIEN>DGLIM(DGLIM) S DGOUT=1 Q DGOUT
 I DGIEN#100=0 D
 .I $G(DGLIM)="SD",$$NOW^XLFDT()>DGLIM(DGLIM) S DGOUT=1 Q
 .D STOP^DG53244V
 Q DGOUT
 ;
RECORD(DGFIL,DGFLD,DGREC,DGNAM,DGAUD,DGNMSP,DGIEN,DGOLD) ;file changes in ^XTMP
 ;^XTMP global format:
 ;^XTMP("DPTNAME",0)=purge_date^date_created^process^last_ien^
 ;                   stop_flag^name_change_mail_group
 ;^XTMP("DPTNAME",0,0)=conversion_start^conversion_end
 ;^XTMP("DPTNAME",0,n)=conversion_start^conversion_end^
 ;                     pts_evaluated_start^pts_evaluated_end
 ;^XTMP("DPTNAME",DFN,FILE,IFN,FIELD)=old_value^new_value^change_types
 ;^XTMP("DPTNAME",DFN,"MPI")=1^1^1^1^1^1 (status of MPI messaging)
 ;^XTMP("DPTNAME",DFN,"MPI","A31")=the result of call to $$A31^MPIFA31B
 ;^XTMP("DPTNAME","STATS")=names_evaluated^pts_w/changes^total_changes^
 ;                         type1_changes^type2_changes^type3_changes^
 ;                         type4_changes
 ;^XTMP("DPTNAME","STATS",FILE,FIELD)=total_evaluated^total_changed^
 ;                               type1_changes^type2_changes^
 ;                               type3_changes^type4_changes
 ;^XTMP("DPTNAME","B",NAME)=dfn
 ;
 ;Data change types: 1=name contains no comma
 ;                   2=parenthetical text is removed
 ;                   3=value could not be converted
 ;                   4=characters are removed or changed
 ;
 N DGIENS,DGIEN2,DGTSTR,DGI,DGN S DGTSTR=""
 S DGIEN2=$S($P(DGREC,",",2):$P(DGREC,",",2),1:DGIEN)
 ;Record values
 F DGI=1:1:4 I $D(DGAUD(DGI)) D
 .S DGTSTR=DGTSTR_DGI
 .;Field changes by type
 .S $P(^XTMP(DGNMSP,"STATS",DGFIL,DGFLD),U,(DGI+2))=$P($G(^XTMP(DGNMSP,"STATS",DGFIL,DGFLD)),U,(DGI+2))+1
 .;Total changes by type
 .S $P(^XTMP(DGNMSP,"STATS"),U,(DGI+3))=$P($G(^XTMP(DGNMSP,"STATS")),U,(DGI+3))+1
 .Q
 ;Total patients with changes
 I '$D(^XTMP(DGNMSP,DGIEN)) S $P(^XTMP(DGNMSP,"STATS"),U,2)=$P($G(^XTMP(DGNMSP,"STATS")),U,2)+1
 ;Total fields with changes
 S $P(^XTMP(DGNMSP,"STATS"),U,3)=$P($G(^XTMP(DGNMSP,"STATS")),U,3)+1
 ;Total changes by field
 S $P(^XTMP(DGNMSP,"STATS",DGFIL,DGFLD),U,2)=$P($G(^XTMP(DGNMSP,"STATS",DGFIL,DGFLD)),U,2)+1
 ;PATIENT field name change and types
 S ^XTMP(DGNMSP,DGIEN,DGFIL,DGIEN2,DGFLD)=DGOLD_U_DGNAM_U_DGTSTR
 ;Name x-ref
 S DGN=$P($G(^DPT(DGIEN,0)),U) S:DGN="" DGN=" "
 S ^XTMP(DGNMSP,"B",DGN,DGIEN)=""
 Q
 ;
RMPI(DGP,DGMPI) ;Record MPI notification status
 S $P(^XTMP("DPTNAME",DGIEN,"MPI"),U,DGP)=1
 Q:'$D(DGMPI)  S ^XTMP("DPTNAME",DGIEN,"MPI","A31")=DGMPI
 Q
 ;
INV(DGIENS) ;Invert the IENS
 N DGI,DGX
 Q:DGIENS?."," ""
 S:DGIENS'?.E1"," DGIENS=DGIENS_","
 S DGX="" F DGI=$L(DGIENS,",")-1:-1:1 S DGX=DGX_$P(DGIENS,",",DGI)_":"
 S:DGX?.E1":" DGX=$E(DGX,1,$L(DGX)-1)
 Q DGX
 ;
FIELD ;;
 ;;NAME^.01^0;1^1.01^30^^ANAM01
 ;;K-NAME^.211^.21;1^1.02^^^ANAM211
 ;;K2-NAME^.2191^.211;1^1.03^^^ANAM2191
 ;;FATHER'S NAME^.2401^.24;1^1.04^^^ANAM2401
 ;;MOTHER'S NAME^.2402^.24;2^1.05^^^ANAM2402
 ;;MOTHER'S MAIDEN^.2403^.24;3^1.06^^^ANAM2403
 ;;E-NAME^.331^.33;1^1.07^^^ANAM331
 ;;E2-NAME^.3311^.331;1^1.08^^^ANAM3311
 ;;D NAME^.341^.34;1^1.09^^^ANAM341
 ;;ALIAS^.01^.01;0;1^100.03^30^2.01^ANAM201
 ;;ATTORNEY^30^DIS;3;1^100.21^30^2.101^ANAM1001
