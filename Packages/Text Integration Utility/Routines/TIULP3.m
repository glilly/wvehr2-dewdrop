TIULP3  ;BAY PINES/ELR - Functions determining privilege continued ;11/15/2006
        ;;1.0;TEXT INTEGRATION UTILITIES;**232**;Jun 20, 1997;Build 19
ISSURG(TIUDA)   ;
        NEW TIUY
        I +$$ISADDNDM^TIULC1(TIUDA) S TIUDA=+$P($G(^TIU(8925,TIUDA,0)),U,6)
        D ISSURG^TIUSROI(.TIUY,+$G(^TIU(8925,+TIUDA,0)))
        G SURGEX:TIUY'>0
        ;SEE IF IT IS AN NIR OR AR
        N TIUS0,TIUSNAME
        S TIUY=0
        G SURGEX:'$L(TIUDA)
        G SURGEX:'$D(^TIU(8925,+TIUDA,0))
        S TIUS0=+$G(^TIU(8925,+TIUDA,0))
        G SURGEX:'$L(TIUS0)
        S TIUSNAME=$$PNAME^TIULC1(+TIUS0)
        G SURGEX:'$L(TIUSNAME)
        I TIUSNAME="NURSE INTRAOPERATIVE REPORT" S TIUY=1 G SURGEX
        I TIUSNAME="ANESTHESIA REPORT" S TIUY=1 G SURGEX
SURGEX  Q TIUY
ACTION(TIUACTW) ;CHECK ACTION
        NEW TIUY S TIUY=0
        I (($G(TIUACTW)["DELETE RECORD")!($G(TIUACTW)["EDIT RECORD")!($G(TIUACTW)["ADDEND")) S TIUY=1 G ACTEX
ACTEX   Q TIUY
SURMSG(TIUACTW) ;SET SURGERY ERROR MSG
        NEW TIUY,TIUDOC S TIUDOC=""
        I TIUACTW["DELETE" S TIUDOC="DELETE"
        I TIUACTW["EDIT" S TIUDOC="EDIT"
        I TIUACTW["ADDEND" S TIUDOC="CREATE AN ADDENDUM FOR"
        I TIUACTW["AMENDMENT" S TIUDOC="AMEND"
        S TIUY="You must use the Surgery Package to "_TIUDOC_" this Document"
        Q TIUY
IDMSG(TIUMSG)   ;SET DELETE ID MSG
        S TIUMSG="You may NOT delete this parent ID note.  It has child ID notes attached. "
        S TIUMSG=TIUMSG_"If you need to delete this note you must first detach the child from the parent note."
        I $G(XQY0)["OR CPRS GUI CHART" D                 ;DBIA 3356
        . S TIUMSG=TIUMSG_" Select Action/Detach from Interdisciplinary Note to accomplish this."
        E  S TIUMSG=TIUMSG_"  Select the child note from the LM screen, then select Interdisciplinary Note."
        Q
