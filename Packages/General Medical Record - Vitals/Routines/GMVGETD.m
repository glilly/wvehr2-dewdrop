GMVGETD ;HOIFO/YH,FT-EXTRACTS WARD/ROOM-BED/PT AND PT VITALS ;5/10/07
        ;;5.0;GEN. MED. REC. - VITALS;**3,22**;Oct 31, 2002;Build 22
        ;
        ; This routine uses the following IAs:
        ; #1380  - ^DG(405.4 references   (controlled)
        ; #1377  - ^DIC(42 references     (controlled)
        ; #10035 - FILE 2 references      (supported)
        ; #10039 - FILE 42 references     (supported)
        ; #10103 - ^XLFDT calls           (supported)
        ;
        ; This routine supports the following IAs:
        ; #4416 - GMV EXTRACT REC RPC is called at GETVM  (private)
        ; #4358 - GMV LATEST VM RPC is called at GETLAT (private)
        ;
GETVM(RESULT,GMRVDATA)  ;GMV EXTRACT REC [RPC entry point]
        ;RETURNS VITALS/MEASUREMENTS FOR A PARTICULAR PATIENT A FOR GIVEN DATE/TIME SPAN IN RESULT ARRAY.
        ;GMRVDATA = DFN^END DATE VITAL TAKEN^VITAL TYPE (OPTIONAL)^START DATE VITAL TAKEN
        N GMVDAYS,DFN,GMRVSDT,GMRVFDT,GMVTYPE S DFN=+$P(GMRVDATA,"^"),GMRVSDT=+$P(GMRVDATA,"^",2),GMVDAYS=$P(GMRVDATA,"^",4),GMVTYPE=$P(GMRVDATA,"^",3) K ^TMP($J,"GRPC")
        S GMRVFDT=$P(GMRVSDT,".",1)_".2400"
        I GMVDAYS'="" S GMRVSDT=$P(GMVDAYS,".",1)
        S:GMVTYPE'="" GMVTYPE(1)=$P(^GMRD(120.51,$O(^GMRD(120.51,"C",GMVTYPE,0)),0),"^")
        D EN1^GMVGETD1
        I '$D(^TMP($J,"GRPC")) S ^TMP($J,"GRPC",1)="0^NO "_$S(GMVTYPE'="":GMVTYPE(1),1:"VITALS/MEASUREMENTS ")_" ENTERED WITHIN THIS PERIOD"
        S RESULT=$NA(^TMP($J,"GRPC"))
        K GMRDT,GMRVARY,GMRVITY,GMRVX,GMRZZ
        Q
GETLAT(RESULT,GMRDFN)   ;GMV LATEST VM [RPC entry point]
        ; RETURNS THE LATEST VITALS/MEASUREMENTS FOR A GIVEN PATIENT(GMRDFN)
        ; IN RESULT ARRAY.
        K ^TMP($J,"GRPC") D EN1^GMVLAT0(GMRDFN)
        S RESULT=$NA(^TMP($J,"GRPC"))
        Q
WARDLOC(RESULT,DUMMY)   ;GMV WARD LOCATION [RPC entry point]
        ;RETURNS MAS WARD LOCATIONS IN RESULT ARRAY
        K ^TMP($J,"GWARD"),^TMP($J,"GMRV") N GMRWARD,GINDEX,GN,GMR
        S DUMMY=$G(DUMMY)
        S DUMMY=$$UP^XLFSTR(DUMMY)
        S DUMMY=$S(DUMMY="P":"P",1:"A")
        D LIST^DIC(42,"","","","*","","","","I '$$INACT42^GMVUT2(+Y)","","^TMP($J,""GMRV"")")
        S GINDEX=+$P($G(^TMP($J,"GMRV","DILIST",0)),"^")
        I GINDEX>0 D
        . S (GMR,GN)=0 F  S GN=$O(^TMP($J,"GMRV","DILIST",1,GN)) Q:GN'>0  D
        . . S GMRWARD(1)=^TMP($J,"GMRV","DILIST",1,GN),GMRWARD=+^TMP($J,"GMRV","DILIST",2,GN)
        . . I DUMMY="P" D  Q
        . . . I $O(^DPT("CN",GMRWARD(1),0))>0 S GMR=GMR+1,^TMP($J,"GWARD",GMR)=GMRWARD_"^"_GMRWARD(1)_U_^DIC(42,GMRWARD,44)
        . . I DUMMY="A" D
        . . . S GMR=GMR+1,^TMP($J,"GWARD",GMR)=GMRWARD_"^"_GMRWARD(1)_U_^DIC(42,GMRWARD,44)
        K ^TMP($J,"GMRV") S RESULT=$NA(^TMP($J,"GWARD"))
        Q
WARDPT(RESULT,GMRWARD)  ;GMV WARD PT [RPC entry point]
        ;RETURNS A LIST OF PATIENTS ADMITTED TO A GIVEN MAS WARD(GMRWARD) IN RESULT ARRAY.
        Q:'$D(^DPT("CN",GMRWARD))
        N OUT,GN,DFN,DFN1,GMVPAT
        K ^TMP($J,"GMRPT")
        S (GN,DFN)=0 F  S DFN=$O(^DPT("CN",GMRWARD,DFN)) Q:DFN'>0  D
        . I $D(^DPT(DFN,0)) D
        . . S GMVPAT=""
        . . D PTINFO^GMVUTL3(.GMVPAT,DFN)
        . . S OUT($P(^DPT(DFN,0),"^"),DFN)=DFN_"^"_$P(^DPT(DFN,0),"^")_"^"_GMVPAT
        I '$D(OUT) Q
        S DFN=""
        F  S DFN=$O(OUT(DFN)) Q:DFN=""  D
        .S DFN1=0
        .F  S DFN1=$O(OUT(DFN,DFN1)) Q:'DFN1  D
        ..S GN=GN+1,^TMP($J,"GMRPT",GN)=OUT(DFN,DFN1)
        ..Q
        .Q
        S RESULT=$NA(^TMP($J,"GMRPT"))
        Q
ROOMBED(RESULT,GMRWARD) ;GMV ROOM/BED [RPC entry point]
        ;RETURNS A LIST OF ROOMS/BEDS FOR A GIVEN MAS WARD(GMRWARD) IN RESULT ARRAY.
        Q:'$D(^DIC(42,"B",GMRWARD))
        N GN,GROOM,GWARD,GMVTMP K ^TMP($J,"GROOM")
        S (GN,GROOM)=0,GWARD=$O(^DIC(42,"B",GMRWARD,0)) I GWARD'>0 S ^TMP($J,"GROOM",1)="NO ROOM" G QUIT
        F  S GROOM=$O(^DG(405.4,"W",GWARD,GROOM)) Q:GROOM'>0  I $D(^DG(405.4,GROOM)) D
        . S GMVTMP($P($P(^DG(405.4,GROOM,0),"^"),"-",1))=GROOM
        . ;S GN=GN+1,^TMP($J,"GROOM",GN)=GROOM_"^"_$P(^DG(405.4,GROOM,0),"^")
        . Q
        S GROOM="",GN=0
        F  S GROOM=$O(GMVTMP(GROOM)) Q:GROOM=""  D
        . S GN=GN+1,^TMP($J,"GROOM",GN)=GMVTMP(GROOM)_"^"_GROOM
        . Q
QUIT    S RESULT=$NA(^TMP($J,"GROOM"))
        Q
