DDMP    ;SFISC/DPC-IMPORT ASCII DATA ;3:40 PM  27 Mar 2010
        ;;22.0;VA FileMan;;Mar 30, 1999;Build 15
        ;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
FILE(DDMPF,DDMPFLDS,DDMPFLG,DDMPFSRC,DDMPFMT)   ;
        ;API for import tool.
        ;DDMPF - file# of primary import file.
        ;DDMPFLDS (by ref or value) - 1) name of import template (in [])
        ;         2) ;-delimited fields array. Primary file in top element.
        ;            Other nodes subscripted by subfile#.
        ;DDMPFLG (by ref.) - ("FLAGS"): 'E'xternal; 'F'ile contains specs
        ;                    ("MSGS"): Root to contain error messages.
        ;                    ("MAXERR"): Maximum # of errors allowed.
        ;                    ("IOP"): Device for report printing.
        ;                    ("QTIME"): Queue import time.
        ;DDMPFSRC (by ref.) -("PATH"): Path to source file
        ;                    ("FILE"): Source file name.
        ;DDMPFMT (by value or ref.) - 1) top node = foreign format.
        ;          2) ("FDELIM"):  Field delimiter.
        ;             ("FIXED"): YES if fixed format.
        ;             ("QUOTED"): YES if delimited fields quoted.
        ;
        I '$D(DIQUIET) N DIQUIET S DIQUIET=1
        I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
        N DDMPNCNT
        S DDMPFLG=$G(DDMPFLG("FLAGS"),$G(DDMPFLG)) I '$$VERFLG^DIEFU(DDMPFLG,"FE") G OUT
        S DDMPFLG("MAXERR")=$G(DDMPFLG("MAXERR"),1000)
        S DDMPFSRC("PATH")=$G(DDMPFSRC("PATH"))
        I $G(DDMPFSRC("FILE"))="" D BLD^DIALOG(202,"host source file","host source file") G OUT
        D GETFMT^DDMP1(.DDMPFMT) G:$G(DIERR) OUT
        D GETSRC^DDMP1(.DDMPFSRC) G:'$D(^TMP($J,"DDMP")) OUT
        S DDMPNCNT=$O(^TMP($J,"DDMP",""))
        I DDMPFLG["F" D  G:$G(DIERR) OUT
        . I $G(DDMPF)'=""!($D(DDMPFLDS)&($G(DDMPFLDS)'="")) D BLD^DIALOG(1833) Q
        . D INFILE^DDMP1("^TMP($J,""DDMP"")",.DDMPFMT,.DDMPF,.DDMPFLDS,.DDMPNCNT)
        E  I $G(DDMPF)=""!('$D(DDMPFLDS)) D BLD^DIALOG(202,"file or the fields","file or the fields") G OUT
        I DDMPNCNT="" D BLD^DIALOG(1812,DDMPFSRC("FILE"),DDMPFSRC("FILE")) G OUT
        I $E($G(DDMPFLDS))="[" N DDMPERR D  G:DDMPERR'=$G(DIERR) OUT ;import template processing
        . S DDMPERR=$G(DIERR)
        . D TMPL2DR^DDMP1(DDMPF,.DDMPFLDS)
        S DDMPFLDS(DDMPF)=$G(DDMPFLDS(DDMPF),$G(DDMPFLDS))
        I '$$RQIDOK^DDMP1(.DDMPFLDS) G OUT
        N DDMPSQ,DDMPFIEN S (DDMPSQ,DDMPFIEN)=0
        D FLDBLD(DDMPF,.DDMPFLDS,.DDMPSQ,.DDMPFIEN,1) G:$G(DIERR) OUT
        N DDMPIOP,ZTSK,POP ;Device and queuing setup.
        D DEV^DDMP2(.DDMPFLG,.DDMPIOP)
        I $G(DDMPIOP("NG")) D BLD^DIALOG(1850) G OUT
        I $G(DDMPIOP("Q")) D QUE^DDMP2(.DDMPIOP) G OUT
TASK    ;Entry point for queued imports.  If not queued, processing continues.
        N DDMPRPSB,DDMPLN,DDMPSTAT,POP
        D REP1^DDMP2(.DDMPRPSB,.DDMPLN)
        S DDMPSTAT("BEG")=$H,(DDMPSTAT("TOT"),DDMPSTAT("NG"))=0
        D PUTDRVR(.DDMPSQ,.DDMPFMT,.DDMPFLG,DDMPNCNT,.DDMPSTAT)
        D REP2^DDMP2(DDMPRPSB,DDMPLN,.DDMPSTAT)
OUT     I $D(ZTQUEUED) D
        . S ZTREQ="@"
        . D CLEAN^DIEFU
        E  I $G(DDMPFLG("MSGS"))]"" D CALLOUT^DIEFU(DDMPFLG("MSGS"))
        K ^TMP($J,"DDMP")
        ;K ^XTMP(DDMPRPSB) ;Deletes the report from XTMP
        Q
        ;
FLDBLD(DDMPF,DDMPFLDS,DDMPSQ,DDMPFIEN,DDMPTFIX) ;
        N DDMPI,DDMPNFLD,DDMPNIEN,DDMPINFD
        S DDMPFIEN=DDMPFIEN+1
        S DDMPNIEN="+"_DDMPFIEN_","_$G(DDMPFIEN("UP",DDMPF))
        F DDMPI=1:1 S DDMPINFD=$P(DDMPFLDS(DDMPF),";",DDMPI) Q:DDMPINFD=""  D  Q:$G(DIERR)
        . I DDMPINFD'["[" S DDMPNFLD=DDMPINFD
        . E  N DDMPOFIX S DDMPNFLD=+DDMPINFD,DDMPOFIX=$P($P(DDMPINFD,"]"),"[",2)
        . I '$$VFIELD^DIEFU(DDMPF,DDMPNFLD,"D") Q
        . N DDMP0P2
        . S DDMP0P2=$P($G(^DD(DDMPF,DDMPNFLD,0)),U,2)
        . I +DDMP0P2 D  Q
        . . N DDMPDWF
        . . I $P($G(^DD(+DDMP0P2,.01,0)),U,2)["W" D  Q
        . . . N DDMPE S DDMPE(1)="word processing",DDMPE("FILE")=DDMPF,DDMPE("FIELD")=DDMPNFLD
        . . . D BLD^DIALOG(520,"word processing",.DDMPE)
        . . S DDMPDWF=+DDMP0P2
        . . S DDMPFIEN("UP",DDMPDWF)=DDMPNIEN
        . . I '$D(DDMPFLDS(DDMPDWF)) D  Q
        . . . N DDMPP S DDMPP("FILE")=DDMPDWF
        . . . D BLD^DIALOG(525,.DDMPP,.DDMPP)
        . . D FLDBLD(DDMPDWF,.DDMPFLDS,.DDMPSQ,.DDMPFIEN,DDMPTFIX)
        . S DDMPSQ=DDMPSQ+1
        . I DDMPFMT("FIXED")="YES",'$G(DDMPOFIX) D BLD^DIALOG(1822)
        . S DDMPSQ(DDMPSQ)=DDMPF_"~"_DDMPNIEN_"~"_DDMPNFLD_"~"_$G(DDMPOFIX)
        Q
        ;
PUTDRVR(DDMPSQ,DDMPFMT,DDMPFLG,DDMPNODE,DDMPSTAT)       ;
        ;Sets up FDA and files data.
        ;DDMPSQ (by reference):   Contains specs for each field.
        ;DDMPFMT (by reference):  Format of imcoming data
        ;DDMPFLG (by reference):  Import control info.
        ;DDMPNODE (by value):     Number of first node containing data.
        N DDMPTPAR,DDMPNDCT,DDMPUPFG,DDMPREF
        I DDMPFLG["E" S DDMPUPFG="E"
        S DDMPNDCT=1
        S DDMPREF=$NA(^TMP($J,"DDMP",DDMPNODE))
        S DDMPTPAR(1)=^TMP($J,"DDMP",DDMPNODE)
        F  S DDMPREF=$Q(@DDMPREF) Q:DDMPREF'[($J_",""DDMP""")  D  Q:$G(DDMPSTAT("ABORT"))
        . I DDMPREF'["OVF" D
        . . D RECPROC
        . . K DDMPTPAR S DDMPNDCT=0
        . S DDMPNDCT=DDMPNDCT+1
        . S DDMPTPAR(DDMPNDCT)=@DDMPREF
        I $G(DDMPSTAT("ABORT")) Q
        D RECPROC
        Q
        ;
RECPROC ; Files a record from DDMPTPAR()
        N DDMPIENS
        K ^TMP($J,"DDMPFDA")
        D TOT(.DDMPSTAT) Q:$G(DDMPSTAT("ABORT"))
        D PARSE(.DDMPSQ,.DDMPTPAR,DDMPNDCT)
        I '$D(^TMP($J,"DDMPFDA")) D RECERR Q
        D UPDATE^DIE($G(DDMPUPFG),"^TMP($J,""DDMPFDA"")","DDMPIENS")
        I $G(DIERR) D
        . D RECERR
        E  I DDMPSTAT("TOT")-DDMPSTAT("NG")>1 S DDMPSTAT("LIEN")=DDMPIENS(1)
        E  S (DDMPSTAT("FIEN"),DDMPSTAT("LIEN"))=DDMPIENS(1)
        Q
        ;
TOT(DDMPSTAT)   ;
        S DDMPSTAT("TOT")=DDMPSTAT("TOT")+1
        I '$D(ZTQUEUED) W "."
        E  I DDMPSTAT("TOT")#10=0,$$S^%ZTLOAD D
        . S DDMPSTAT("ABORT")=2
        . S ZTSTOP=1
        Q
        ;
RECERR  ;
        N DDMPERLN,DDMPERR
        S DDMPSTAT("NG")=DDMPSTAT("NG")+1
        D LDXTMP^DDMP2("Record #"_DDMPSTAT("TOT")_" Rejected:")
        D MSG^DIALOG("AEB",.DDMPERR,$S($D(IOM):IOM-5,1:75))
        S DDMPERLN=0
        F  S DDMPERLN=$O(DDMPERR(DDMPERLN)) Q:'DDMPERLN  D LDXTMP^DDMP2("   "_DDMPERR(DDMPERLN))
        D CLEAN^DIEFU
        I DDMPSTAT("NG")'<DDMPFLG("MAXERR") S DDMPSTAT("ABORT")=1
        Q
        ;
PARSE(DDMPSQ,DDMPTPAR,DDMPNDCT) ;
        N DDMPQ,DDMPHOLD,DDMPIN,DDMPI,DDMPTVAL,DDMPVAL
        I DDMPTPAR(1)="" D BLD^DIALOG(1860) Q
        S DDMPQ="""",DDMPSQ=0
        F DDMPI=1:1:DDMPNDCT S DDMPIN=DDMPTPAR(DDMPI) F  Q:DDMPIN=""!($G(DIERR))  D
        . I $G(DDMPFMT("QUOTED"))="YES",($E(DDMPIN)=DDMPQ!($E($G(DDMPHOLD))=DDMPQ)) D
        . . I $G(DDMPHOLD)]"" D
        . . . I DDMPHOLD'=DDMPQ,$E(DDMPHOLD,$L(DDMPHOLD))=DDMPQ D
        . . . . S DDMPVAL=DDMPHOLD,DDMPHOLD=""
        . . . . S DDMPIN=$P(DDMPIN,DDMPFMT("FDELIM"),2,99)
        . . . E  D
        . . . . S DDMPVAL=DDMPHOLD_$P(DDMPIN,DDMPQ)_DDMPQ,DDMPHOLD=""
        . . . . S DDMPIN=$P($P(DDMPIN,DDMPQ,2,99),DDMPFMT("FDELIM"),2,99)
        . . E  D
        . . . S DDMPTVAL=$P(DDMPIN,DDMPQ,1,2)_$S($L(DDMPIN,DDMPQ)>2:DDMPQ,1:"")
        . . . ;Begin WorldVistA change ;03/27/2010 ;NO HOME 1.0
        . . . ;S DDMPIN=$P(DDMPIN,DDMPTVAL,2)
        . . . S DDMPIN=$E(DDMPIN,$L(DDMPTVAL)+1,$L(DDMPIN))
        . . . ;End WorldVistA chage
        . . . I DDMPIN=DDMPFMT("FDELIM") S DDMPIN="",DDMPVAL=DDMPTVAL Q
        . . . S DDMPIN=$P(DDMPIN,DDMPFMT("FDELIM"),2,99)
        . . . I DDMPIN="",DDMPI'=DDMPNDCT S DDMPHOLD=DDMPTVAL Q
        . . . S DDMPVAL=DDMPTVAL
        . E  I $G(DDMPFMT("FDELIM"))'="" D
        . . S DDMPTVAL=$P(DDMPIN,DDMPFMT("FDELIM"))
        . . I $L(DDMPIN,DDMPFMT("FDELIM"))=2,$P(DDMPIN,DDMPFMT("FDELIM"),2)="" S DDMPIN="",DDMPVAL=$G(DDMPHOLD)_DDMPTVAL,DDMPHOLD="" Q
        . . S DDMPIN=$P(DDMPIN,DDMPFMT("FDELIM"),2,99)
        . . I $G(DDMPHOLD)]"" S DDMPVAL=DDMPHOLD_DDMPTVAL,DDMPHOLD="" Q
        . . I DDMPIN="",DDMPI'=DDMPNDCT S DDMPHOLD=DDMPTVAL Q
        . . S DDMPVAL=DDMPTVAL
        . E  D
        . . N DDMPLEN,DDMPLAST
        . . I '$D(DDMPSQ(DDMPSQ+1)) D BLD^DIALOG(1862) Q
        . . S DDMPLEN=$P(DDMPSQ(DDMPSQ+1),"~",4)
        . . I $G(DDMPHOLD)]"" D
        . . . S DDMPVAL=DDMPHOLD_$E(DDMPIN,1,DDMPLEN-$L(DDMPHOLD))
        . . . S DDMPIN=$E(DDMPIN,DDMPLEN-$L(DDMPHOLD)+1,255)
        . . . S DDMPHOLD=""
        . . E  D
        . . . S DDMPTVAL=$E(DDMPIN,1,DDMPLEN)
        . . . S DDMPIN=$E(DDMPIN,DDMPLEN+1,255)
        . . . I DDMPIN="",DDMPI'=DDMPNDCT S DDMPHOLD=DDMPTVAL Q
        . . . S DDMPVAL=DDMPTVAL
        . . I $D(DDMPVAL) F  S DDMPLAST=$L(DDMPVAL) Q:$E(DDMPVAL,DDMPLAST)'=" "  S DDMPVAL=$E(DDMPVAL,1,DDMPLAST-1)
        . I $D(DDMPVAL) D  K DDMPVAL
        . . S DDMPSQ=DDMPSQ+1
        . . I '$D(DDMPSQ(DDMPSQ)) D BLD^DIALOG(1862) Q
        . . I $G(DDMPFMT("QUOTED"))="YES" S DDMPVAL=$TR(DDMPVAL,DDMPQ)
        . . D FDASET(DDMPVAL,DDMPSQ(DDMPSQ))
        I $G(DDMPFMT("FIXED"))="YES" F DDMPSQ=DDMPSQ+1:1 Q:'$D(DDMPSQ(DDMPSQ))  S DDMPVAL="" D FDASET(DDMPVAL,DDMPSQ(DDMPSQ))
        Q
        ;
FDASET(DDMPVAL,DDMPSPEC)        ;
        S ^TMP($J,"DDMPFDA",$P(DDMPSPEC,"~"),$P(DDMPSPEC,"~",2),$P(DDMPSPEC,"~",3))=DDMPVAL
        Q
        ;
