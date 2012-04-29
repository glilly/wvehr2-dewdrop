RMPR9CA ;OI-HINES/HNC -SUSPENSE RPC;12/27/2004
        ;;3.0;PROSTHETICS;**90,135,141,146**;Feb 09, 1996;Build 4
A1      ;roll and scroll entry point
        G A2
EN(RESULTS,RMIE68,RMPRDUZ,RMSUSTAT,RMPR664,RMPRTXT)     ;RPC entry point
A2      ;
        S RESULTS(0)="",STP=0
        K ^TMP($J)
        ;
CONT    ;RMSUSTAT is status 1=complete or 0=incomplete or 2=pending (incomplete)
        ;
        S RMIE=0
        F  S RMIE=$O(^RMPR(664,RMPR664,1,RMIE)) Q:RMIE'>0  D  Q:STP=1
        .S RMIE60=$P(^RMPR(664,RMPR664,1,RMIE,0),U,13) Q:'RMIE60
        .S ^TMP($J,RMIE60)=""
        .D FD Q:STP=1
        .D UPD
        I STP=1 G EXIT
        I RMSUSTAT=1 D CNOTE,FD
        I RMSUSTAT=0 D INOTE,FD
        I RMSUSTAT=2 D ONOTE,FD
        ;set status
        Q
CNOTE   ;(#12) COMPLETION NOTE
        ;set file 668
        ;^RMPR(668,D0,4,0)=^668.012^^
        ;if status is close, or 1
        ;RMPRTXT ;load into field #12
        ;^RMPR(668,D0,4,D1,0)
        ;
        I $P(^RMPR(668,RMIE68,0),U,10)="C" S RESULTS(0)="0^This Suspense has already been Closed!"
        S DA=RMIE68
        D NOW^%DTC S RMPREODT=%,GMRCAD=%
        S DIE="^RMPR(668,"
        S DR="5////^S X=RMPREODT;6////^S X=DUZ;14///^S X=""C""" D ^DIE
        N RMPRC
        S L="",LN=0
        F  S L=$O(RMPRTXT(L)) Q:L=""  D
        . I 'LN D  Q:RMPRC=""  ;strip leading space from 1st line, ignore blank line
        .. S RMPRC=$E($TR(RMPRTXT(L)," ","")) ;1st non space char
        .. S:RMPRC'="" RMPRTXT(L)=$E(RMPRTXT(L),$F(RMPRTXT(L),RMPRC)-1,$L(RMPRTXT(L))) ;extract from 1st non space char to end of line
        .. Q
        . S LN=LN+1,^RMPR(668,RMIE68,4,LN,0)=RMPRTXT(L)
        . Q
        S $P(^RMPR(668,RMIE68,4,0),"^",3)=LN
        K L,LN
        ;S DA=RMIE68,DIK="^RMPR(668," D IX1^DIK
        I '$P(^RMPR(668,DA,0),U,9) D
        .S DIE="^RMPR(668,"
        .S DR="7///^S X=""See Completion Note for Initial Action Taken."""
        .D ^DIE
        .S DR="10////^S X=RMPREODT;16////^S X=DUZ" D ^DIE
        K RMPREODT
        S GMRCO=$P(^RMPR(668,RMIE68,0),U,15)
        I GMRCO="" S RESULTS(0)="0^Completed Manual Suspense Action.  Suspense status has been updated to CLOSED." Q
        S RMPRCOM=0
        F  S RMPRCOM=$O(^RMPR(668,RMIE68,4,RMPRCOM)) Q:RMPRCOM=""  D
        .S GMRCOM(RMPRCOM)=^RMPR(668,RMIE68,4,RMPRCOM,0)
        I $G(GMRCOM)="" S GMRCOM="Not Noted"
        S GMRCSF="U"
        S GMRCA=10
        S GMRCALF="N"
        S GMRCATO=""
        S (GMRCORNP,GMRCDUZ)=DUZ
        S BDC=$$SFILE^GMRCGUIB(.GMRCO,.GMRCA,.GMRCSF,.GMRCORNP,.GMRCDUZ,.GMRCOM,.GMRCALF,.GMRCATO,.GMRCAD)
        I +BDC=1 S RESULTS(0)=1_"^"_$P(BDC,U,2)
        K GMRCO,GMRCA,GMRCSF,GMRCORNP,GMRCDUZ,GMRCOM,GMRCALF,GMRCATO,GMRCAD
        I RESULTS(0)="" S RESULTS(0)="0^Completed Suspense Action, and Posted note to CPRS Consult.  Suspense status has been updated to CLOSED."
        Q
ONOTE   ;Other note
        ;set file 668
        ;^RMPR(668,D0,4,0)=^668.012^^
        ;if status is pending, and already initial action note or 0
        ;^RMPR(668,D0,1,D1,0)= (#.01) ACTION DATE [1D]
        ;RMPRTXT ;load into field #11, #1
        ;^RMPR(668,D0,1,D1,1,0)=^668.111^^
        ;
        S RMPRDA1=RMIE68,DA(1)=RMIE68,DA=RMIE68
        D NOW^%DTC S X=%,GMRCWHN=%
        S DIC="^RMPR(668,"_RMIE68_",1,"
        S DIC(0)="CQL"
        S DIC("P")="668.011DA"
        S DLAYGO=668
        D ^DIC
        I Y=-1 S RESULTS(0)="1^Error Modifying Record!" Q
        ;S DIE=DIC K DIC
        S (DA,RMPRDA2)=+Y
        ;S DR="1" D ^DIE
        K DIE,DR,Y
        ;S ^RMPR(668,RMIE68,1,0)="^668.011DA^1^1"
        N RMPRC
        S L="",LN=0
        F  S L=$O(RMPRTXT(L)) Q:L=""  D
        . I 'LN D  Q:RMPRC=""  ;strip leading space from 1st line, ignore blank  line
        .. S RMPRC=$E($TR(RMPRTXT(L)," ","")) ;1st non space char
        .. S:RMPRC'="" RMPRTXT(L)=$E(RMPRTXT(L),$F(RMPRTXT(L),RMPRC)-1,$L(RMPRTXT(L))) ;extract from 1st non space char to end of line
        .. Q
        . S LN=LN+1,^RMPR(668,RMIE68,1,RMPRDA2,1,LN,0)=RMPRTXT(L)
        . Q
        S $P(^RMPR(668,RMIE68,1,RMPRDA2,1,0),"^",3)=LN
        K L,LN
        S GMRCO=$P(^RMPR(668,RMIE68,0),U,15)
        I GMRCO="" S RESULTS(0)="0^Completed Manual Suspense Action.  Suspense status has not changed." Q
        S RMPRCOM=0
        F  S RMPRCOM=$O(^RMPR(668,RMIE68,1,RMPRDA2,1,RMPRCOM)) Q:RMPRCOM=""  D
        .S GMRCOM(RMPRCOM)=^RMPR(668,RMIE68,1,RMPRDA2,1,RMPRCOM,0)
        D CMT^GMRCGUIB(.GMRCO,.GMRCOM,"",GMRCWHN,DUZ)
        K DA,RMPRDA1,RMPRDA2,RMPRCOM,GMRCOM,GMRCO,GMRCWHN
        S RESULTS(0)="0^Completed Suspense Action, and Posted note to CPRS Consult.  Suspense status has not changed."
        Q
INOTE   ;initial action note
        ;set file 668
        ;^RMPR(668,D0,3,0)=^668.07^^
        ;if status is pending, or 0
        ;RMPRTXT ;load into field #7
        ;^RMPR(668,D0,3,0)=^668.07^^
        ;
        I $D(^RMPR(668,RMIE68,3,1,0)) S RESULTS(0)="1^Initial Action Note Already Posted!" Q
        D NOW^%DTC S RMPREODT=%
        N RMPRC
        S ^RMPR(668,RMIE68,3,0)="^^^"_DT_"^"
        S L="",LN=0
        F  S L=$O(RMPRTXT(L)) Q:L=""  D
        . I 'LN D  Q:RMPRC=""  ;strip leading space from 1st line, ignore blank  line
        .. S RMPRC=$E($TR(RMPRTXT(L)," ","")) ;1st non space char
        .. S:RMPRC'="" RMPRTXT(L)=$E(RMPRTXT(L),$F(RMPRTXT(L),RMPRC)-1,$L(RMPRTXT(L))) ;extract from 1st non space char to end of line
        .. Q
        . S LN=LN+1,^RMPR(668,RMIE68,3,LN,0)=RMPRTXT(L)
        . Q
        S $P(^RMPR(668,RMIE68,3,0),"^",3)=LN
        K L,LN
        S DIE="^RMPR(668,"
        S DA=RMIE68
        S DR="10////^S X=RMPREODT;16////^S X=DUZ;14///^S X=""P"""
        D ^DIE
        S GMRCO=$P(^RMPR(668,RMIE68,0),U,15)
        I GMRCO="" S RESULTS(0)="0^Completed Manual Suspense Action.  Suspense status has been updated to PENDING" Q
        S RMPRCMT=0
        F  S RMPRCMT=$O(^RMPR(668,RMIE68,3,RMPRCMT)) Q:RMPRCMT=""  D
        .S GMRCMT(RMPRCMT)=^RMPR(668,RMIE68,3,RMPRCMT,0)
        D CMT^GMRCGUIB(GMRCO,.GMRCMT,DUZ,RMPREODT,DUZ)
        K RMPREODT,GMRCO,RMGMRCO,GMRCMT,RMPRCMT
        S RESULTS(0)="0^Completed Suspense Action, and Posted note to CPRS Consult.  Suspense status has changed to PENDING."
        Q
        ;
FD      ;file date
        N DIE,DIC,I,J,Y,RMDFN,RMI,RMDATE,RM680,RM6810,RMERROR,RM60L,RC
        N RMERR,RMCHK,DLAYGO,X,DR,RM668,RM60DAT,RMSTATUS
        N RM68CNT,RM60CNT,RMSI,RMSAMIS,RM68IEN,RM60IEN,RMSUS60,RMSUS68,RMD
        N RM68DATA,RM60TYP,RM68D,RM68TRAN,RMPRPRC,RM60IT,RMENTSUS,RMQUIT
        ;
        S RMERR=0
        S:RMSUSTAT="" RMSUSTAT=0
        L +^RMPR(660,RMIE60):2
        I $T=0 S RESULTS(0)="1^Someone else is Editing this entry!" S STP=1 Q
        S RM680=$G(^RMPR(668,RMIE68,0))
        S RM688=$G(^RMPR(668,RMIE68,8))
        S RM6810=$G(^RMPR(668,RMIE68,10))
        S RMAMIS=$P($G(^RMPR(660,RMIE60,"AMS")),U,1)
        ;code here for 668 fields
        S RMDATE=$P(RM680,U,1)
        S RMCODT=$P(RM680,U,5)
        S RMINDT=$P(RM680,U,9)
        S RMPRCO=$P(RM680,U,15)
        S RMDWRT=$P(RM680,U,16)
        S RMSTAT=$P(RM680,U,7)
        S RMTRES=$P(RM680,U,8)
        S RMTYRE=$S(RMTRES=1:"ROUTINE",RMTRES=2:"EYEGLASS",RMTRES=3:"CONTACT LENS",RMTRES=4:"OXYGEN",RMTRES=5:"MANUAL",1:"")
        S RMREQU=$P(RM680,U,11)
        S RMSERV=""
        I $G(RMREQU) D GETS^DIQ(200,RMREQU,"29","E","RMAA") S RMSERV=RMAA(200,RMREQU_",",29,"E")
        S RMPRDI=$E($P(RM688,U,2),1,16)
        S RMICD9=$P(RM688,U,3)
        ;
        S RMDAT(660,RMIE60_",",8.1)=RMDATE
        S RMDAT(660,RMIE60_",",8.2)=RMDWRT
        S RMDAT(660,RMIE60_",",8.3)=RMINDT
        S RMDAT(660,RMIE60_",",8.4)=RMCODT
        S RMDAT(660,RMIE60_",",8.5)=RMTYRE
        S RMDAT(660,RMIE60_",",8.6)=RMREQU
        S RMDAT(660,RMIE60_",",8.61)=RMSERV
        S RMDAT(660,RMIE60_",",8.7)=RMPRDI
        S RMDAT(660,RMIE60_",",8.8)=RMICD9
        S RMDAT(660,RMIE60_",",8.9)=RMPRCO
        S RMDAT(660,RMIE60_",",8.11)=RMSTAT
        I RMSUSTAT=2 S RMDAT(660,RMIE60_",",8.14)=0
        I RMSUSTAT'=2 S RMDAT(660,RMIE60_",",8.14)=RMSUSTAT
        D FILE^DIE("","RMDAT","RMERROR")
        I $D(RMERROR) S RMERR=1 S STP=1
        ;
        L -^RMPR(660,RMIE60)
        Q
UPD     ;update file 668 with 2319 records
        S DA(1)=RMIE68 K DD,DO,DIC
        S DIC="^RMPR(668,"_DA(1)_","_"10,"
        S DIC(0)="L",DLAYGO=668,X=RMIE60
        D FILE^DICN
        K X,DD,DO,DIC
        S DA(1)=RMIE68,DIC(0)="L",DLAYGO=668
        S DIC="^RMPR(668,"_DA(1)_","_"11,"
        S X=RMAMIS
        D FILE^DICN
        K DIC,X,DLAYGO,DD,DO
        Q
A3      G A4
EN1(RESULTS,DA) ;Broker entry to kill PO
        ;DA is passed
        S DIK="^RMPR(664," D ^DIK
        K DIK
A4      ;
        Q
ERR     ;exit on error
EXIT    ;
        K RMTYRE,RMTRES,RMSUSTAT,RMSTAT,RMSERV,RMEQU,RMPRTST,RMPRDUZ,RMPRDI,RMPRCO,RMPR664,RMIE68
        K RMIE60,RMIE,RMICD9,RMDWRT,RMDAT,RMCODT,RMAMIS,RMAA,RM688,RMPRTXT
        K BDC,BAD,%,RMINDT,RMPREQU,STP
        Q
