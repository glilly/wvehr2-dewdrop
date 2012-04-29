XQ82 ;SF-ISC.SEA/JLI - CLEAN OLD $JOB DATA OUT OF XUTL("XQ", & OTHERS ;05/26/2005  11:36
 ;;8.0;KERNEL;**59,67,157,258,312,353**;Jul 10, 1995;Build 1
 ;Make sure that can run from a DCL script
 N A,X,%DT,Y,J,K,DDATE,HDATA,HPID3,XQOS
 S DT=$$DT^XLFDT
 S HDATE=$H-7 ;Get seven days ago in $H days
 S DDATE=$$HTFM^XLFDT(HDATE) ;Get seven days ago in FM format
 S XQOS=^%ZOSF("OS"),HPID3=$E($$CNV^XLFUTL($J,16),1,3)
 S HJOB=$J
 ;Do work as a set of sub routines
 D L0,L1,L2,L3,L4,L5,L6
EXIT ;
 Q
 ;We keep track of jobs by putting data in ^XUTL("XQ",$J).
 ;Sign-on time is in ^($J,0) points to sign-on log.
 ;Holds the Menu stack.
 ;For any entry in user stack w/ date older than 7 days or w/o zero node
 ;kill XUTL("XQ",n) and corresponding UTILITY(n) and TMP(n) nodes.
L0 N %T
 F J=0:0 S J=$O(^XUTL("XQ",J)) Q:J'>0  I $S('$D(^(J,0)):1,1:^(0)<DDATE) D
 . I $G(^XUTL("XQ",J,"KEEPALIVE"))>HDATE Q  ;For long running jobs
 . I $D(^XUTL("XQ",J,"ZTSKNUM")) L +^%ZTSCH("TASK",^XUTL("XQ",J,"ZTSKNUM")):0 Q:'$T  L -^%ZTSCH("TASK",^XUTL("XQ",J,"ZTSKNUM"))
 . K ^XUTL("XQ",J),^UTILITY(J),^TMP(J)
 . Q
 Q:'$$CHECK  ;Check if we should skip pass 2.
 ;Now to check again for DEAD jobs on local node
 F J=0:0 S J=$O(^XUTL("XQ",J)) Q:J'>0  D
 . I $$DEAD(J) K ^XUTL("XQ",J),^UTILITY(J),^TMP(J)
 Q
 ;
 ;Loop thru UTILITY and look for nodes w/o corresponding XUTL("XQ",n)
L1 S A="" F  S A=$O(^UTILITY(A)) Q:A=""  D
 . I A>0,'$D(^XUTL("XQ",A)) K ^UTILITY(A) Q  ;UTILITY($J) w/o XUTL("XQ",$J) node.
 . Q:A>0  Q:"^ROU^GLO^LRLTR^"[("^"_A_"^")
 . F J=0:0 S J=$O(^UTILITY(A,J)) Q:J'>0  I '$D(^XUTL("XQ",J)) K ^UTILITY(A,J) ;Remove UTILITY(namespace,$J) w/o XUTL("XQ",$J)
 . Q
 Q
 ;
 ;Loop thru TMP and look for nodes w/o corresponding XUTL("XQ",n)
L2 S A="" F  S A=$O(^TMP(A)) Q:A=""  D
 . I A>0,'$D(^XUTL("XQ",A)) K ^TMP(A) Q  ;TMP($J) w/o XUTL("XQ",$J) node.
 . Q:A>0  ;Q:"^ROU^GLO^LRLTR^"[("^"_A_"^")
 . F J=0:0 S J=$O(^TMP(A,J)) Q:J'>0  I '$D(^XUTL("XQ",J)) K ^TMP(A,J) ;Remove TMP(namespace,$J) w/o XUTL("XQ",$J)
 . Q
 Q
 ;
L3 ;Now to cleanup the XTMP global w/ XTMP(namespace,0)<DT
 S A="" F  S A=$O(^XTMP(A)) Q:A=""  S J=$G(^XTMP(A,0)) I J<DT K ^XTMP(A)
 Q
 ;
L4 ;Now go thru and clean old ^XUSEC(0,"CUR",duz,sign-on) nodes.
 D L51("CUR")
 Q
 ;
L5 ;Now go through and clean old ^XUSEC(0,"AS*" nodes.
 D L51("AS1"),L51("AS2")
 Q
 ;
L6 ;Clean out old build nodes from ^XUTL
 S K=""
 F  S K=$O(^XUTL("XQO",K)) Q:K=""  D
 . I $D(^XUTL("XQO",K,"^BUILD")),($P($H,",",2)-^("^BUILD")>1800)!(^("^BUILD")>$P($H,",",2)) K ^("^BUILD")
 Q
 ;
L51(NDX) ;Clean old Sign-on log entries from X-ref
 N I,J,FDA,NOW,ERR,IEN
 S I="",NOW=$$NOW^XLFDT
 F  S I=$O(^XUSEC(0,NDX,I)) Q:I=""  F J=0:0 S J=$O(^XUSEC(0,NDX,I,J)) Q:(J'>0)  D
 . ;Look at every entry in the X-ref, check for data record
 . I $D(^XUSEC(0,J,0))[0 K ^XUSEC(0,NDX,I,J) Q  ;No data record.
 . Q:J'<DDATE  ;Keep for now
 . S FDA(3.081,J_",",3)=NOW,FDA(3.081,J_",",16)=1 D UPDATE^DIE("","FDA","IEN","ERR")
 . K FDA,IEN,ERR
 . Q
 Q
 ;
DEAD(X1) ;Check if X1 is a PID and DEAD
 ;Return 1 if should clean, 0 to skip
 I X1\1'=X1 Q 0
 I $E($$CNV^XLFUTL(X1,16),1,3)'=HPID3 Q 0
 ; X1 is a PID on this node, is PID active?..
 I $D(^$JOB(X1))=0 Q 1 ; Job is DEAD
 Q 0
 ;
CHECK() ;Check that we have the right enviroment to do pass 2
 ;Are we on VMS, is ^$JOB supported
 I XQOS["GT.M" Q 0
 I XQOS["DSM" Q 1
 I XQOS["OpenM" X "I $ZV[""VMS""" Q $T
 Q 0
 ;
