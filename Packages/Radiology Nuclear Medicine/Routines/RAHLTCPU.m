RAHLTCPU        ; HIRMFO/GJC - Rad/Nuc Med HL7 TCP/IP Bridge utilities;10/10/07
        ;;5.0;Radiology/Nuclear Medicine;**84**;Mar 16, 1998;Build 13
        ;
LOCKX(RAERR,UNLOCK)     ;lock/unlock the Rad/Nuc Med Patient record at one of two levels:
        ;If part of a printset (RAY3(25)=2) lock at the "DT" level
        ;Else lock at the "P" or case level
        ;Input: RADFN, RADTI, & RACNI are all assumed to be defined.
        ;       UNLOCK: if defined the function unlocks the encounter at the appropriate level
        ;Returns: RAERR (lock attempt only) if $D(RAERR)#2 lock failed, else lock successful
        N RANODE,RAY3 S RAY3=$G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),RAY3(25)=$P(RAY3,U,25)
        S RANODE=$S(RAY3(25)=2:$NA(^RADPT(RADFN,"DT",RADTI)),1:$NA(^RADPT(RADFN,"DT",RADTI,"P",RACNI)))
        I $G(UNLOCK)=1 L -@RANODE Q
        L +@RANODE:DILOCKTM E  S RAERR=$S(RAY3(25)=2:"Encounter",1:"Accession")_" locked within VistA"
        Q
        ;
LOCKR(RAERR,UNLOCK)     ;lock/unlock the report associated with an exam record/
        ;Input: RADFN, RADTI, & RACNI are all assumed to be defined.
        ;       UNLOCK: if defined the function unlocks the report lock
        ;Returns: RAERR (lock attempt only) if $D(RAERR)#2 lock failed, else lock successful
        N RANODE,RAY3 S RAY3=$G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),RAY3(17)=$P(RAY3,U,17)
        Q:RAY3(17)=""  S RANODE=$NA(^RARPT(RAY3(17)))
        I $G(UNLOCK)=1 L -@RANODE Q
        L +@RANODE:DILOCKTM E  S RAERR="The report has been locked within VistA"
        Q
        ;
