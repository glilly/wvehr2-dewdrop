HLOP147 ;ALB/CJM-Pre & Post install ;01/12/2010
        ;;1.6;HEALTH LEVEL SEVEN;**147**;Oct 13, 1995;Build 15
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
PRE     ;
        ;
        N WORK
        L +^HLTMP("PROCESS MANAGER"):0
        I '$T D ABORT Q
        D CHKDEAD^HLOPROC1(.WORK)
        I $O(^HLTMP("HL7 RUNNING PROCESSES",""))'="" D ABORT
        L -^HLTMP("PROCESS MANAGER")
        Q
ABORT   ;
        S XPDABORT=1
        D BMES^XPDUTL("HLO processes are still running and prevent this installation from completing")
        Q
