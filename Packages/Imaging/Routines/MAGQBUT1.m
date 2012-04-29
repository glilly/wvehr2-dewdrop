MAGQBUT1 ;WOIFO/RP; Utilities for Background [ 03/25/2001 11:20 ]
 ;;3.0;IMAGING;**7,8,20**;Apr 12, 2006
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 Q
BPPS(INPUT,WS,PROCESS) ;INPUT TRANSFORM FOR FILE 2006.8
 N IEN,FND,WSNAME,WSNAME2,ZNODE,PIECE,MAGX,MAGY,PLACE
 S U="^"
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 Q:'(+$P($G(^MAG(2006.8,WS,0)),U,12)) 0  ;NOT A BACKGROUND PROCESSOR
 Q:'INPUT 1
 S WSNAME=$$UPPER^MAGQE4($P($G(^MAG(2006.8,WS,1)),U)) ;Workstation Name
 Q:$L(WSNAME)<3 0 ;BP WS NOT PROPERLY INSTALLED
 Q:$O(^MAG(2006.8,"C",PLACE,WSNAME,""))'?1N.N 0
 F MAGX=12,13,14,15,16,17,20 D  Q:MAGY=PROCESS
 . S MAGY=$$GET1^DID(2006.8,MAGX,"","LABEL")
 . D:MAGY=PROCESS
 . . S PIECE=$$GET1^DID(2006.8,MAGX,"","GLOBAL SUBSCRIPT LOCATION")
 Q:MAGY'=PROCESS 0
 S PIECE=$P(PIECE,";",2)
 S IEN=0,WSNAME2="",FND=0
 F  S WSNAME2=$$UPPER^MAGQE4($O(^MAG(2006.8,"C",PLACE,WSNAME2))) Q:WSNAME2=""  D  Q:FND
 . Q:WSNAME2=WSNAME
 . S IEN=$O(^MAG(2006.8,"C",PLACE,WSNAME2,"")) Q:IEN'?1N.N
 . S ZNODE=$G(^MAG(2006.8,IEN,0))
 . Q:$P(ZNODE,"^",12)'="1"
 . S:($P(ZNODE,"^",PIECE)="1") FND="1"
 Q $S(FND="1":0,1:1)
RSQUE(RESULT,IEN,QUEUE) ;[MAGQB RSQUE]
 N PTR,PLACE
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S PTR=$O(^MAGQUEUE(2006.031,"C",PLACE,QUEUE,""))
 I $P(^MAGQUEUE(2006.031,PTR,0),"^")=QUEUE D
 . S $P(^MAGQUEUE(2006.031,PTR,0),"^",2)=IEN
 . ;D RQCNT^MAGQBTM(PLACE)
 Q
ICCL(SRVRCNT,NMESS,PLACE) ;UPDATE IMAGING DISTRIBUTION
 N Y,LOC,INDEX,CNT,IEN,ARRAY,SUB1,SUB2,NAME
 D NOW^%DTC S Y=% D DD^%DT
 S LOC=$$KSP^XUPARAM("WHERE")
 S CNT=1,^TMP($J,"MAGQ",CNT)="SITE: "_LOC
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="DATE: "_Y_" "_$G(^XMB("TIMEZONE"))
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="SENDER: "_$$PLNM^MAGQBUT5(PLACE)_" Imaging Background Processor"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="Total Cache Free: "_$P(SRVRCNT,U,2)_" gigabytes"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="Total Cache Available: "_$P(SRVRCNT,U,3)_" gigabytes"
 I $P(SRVRCNT,U,4) S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="An Automatic Purge process has been Activated."
 E  S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="The Automatic Purge process is NOT configured."
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="The "_$P(SRVRCNT,U)_" Imaging cache servers will"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="require operator intervention to ensure continued"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="availability.  The following MAG SERVER members"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="are being notified:"
 S INDEX=0,IEN=$$FIND1^DIC(3.8,"","MX","MAG SERVER","","","ERR")
 Q:IEN'?1N.N
 D GETS^DIQ(3.8,IEN_",","2*;11*;12*","","ARRAY")
 S (SUB1,SUB2)=""
 F  S SUB1=$O(ARRAY(SUB1)) Q:SUB1=""  D
 . F  S SUB2=$O(ARRAY(SUB1,SUB2)) Q:SUB2=""  D
 . . S NAME=$G(ARRAY(SUB1,SUB2,".01")) D:NAME'=""
 . . . S CNT=CNT+1,^TMP($J,"MAGQ",8+CNT)=NAME
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="The next notifications will occur in:"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)=NMESS
 D MAILIT
 S $P(^MAG(2006.1,$$PLACE^MAGBAPI($G(DUZ(2))),3),"^",11)=$$NOW^XLFDT
 K ARRAY
 Q
MAILIT ;Send the report to the Clinical Application Time
 N XMSUB
 S XMSUB="Image Cache Critically Low at "_LOC
MAILSHR ;Shared Mail server code
 ;If dropping in...must manage XMSUB
 N XMY,XMTEXT
 S XMTEXT="^TMP($J,""MAGQ"","
 S:$G(DUZ) XMY(DUZ)=""
 S XMY("G.MAG SERVER")=""
 S:$G(MAGDUZ) XMY(MAGDUZ)=""
 D ^XMD
 K ^TMP($J,"MAGQ")
 Q
ALLSERV(RESULT) ;
 ; RPC[MAGQ ALL SERVER]
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 N INDX,DATA,CNT,SHARE,CWL,VALUE,TMP,PLACE ;CWL=CURRENT WRITE LOCATION
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S CWL=$$CWL^MAGBAPI(PLACE)
 I CWL D
 . S DATA=$G(^MAG(2005.2,CWL,0))
 . S SHARE=$P(DATA,U,2)
 . S RESULT(0)=SHARE_U_CWL_U_+$P(DATA,U,5)_U_+$P(DATA,U,3)_U_$P(DATA,U)
 . Q
 E  S RESULT(0)="-1^The Current Write Location (CWL) could not be set."
 S INDX=0,U="^",CNT=1
 K ^TMP("MAGQAS")
 F  S INDX=$O(^MAG(2005.2,INDX)) Q:INDX'?1N.N  D
 . S DATA=$G(^MAG(2005.2,INDX,0))
 . Q:$P(DATA,U,6,7)'["1^MAG"
 . Q:$P(DATA,U,2)[":"
 . Q:($P(DATA,U,10)'=PLACE)
 . Q:$P(DATA,U,9)="1"  ;ROUTING SHARE
 . S SHARE=$P(DATA,U,2)
 . Q:$E(SHARE,1,2)'="\\"
 . I $E(SHARE,$L(SHARE))="\" S SHARE=$E(SHARE,1,$L(SHARE)-1)
 . S TMP(SHARE)=""
 . S VALUE=SHARE_U_INDX_U_+$P(DATA,U,5)_U_+$P(DATA,U,3)_U_$P(DATA,U)
 . I INDX=CWL D  Q  ;ELSE CONTINUE
 . . S RESULT(0)=VALUE_U_$G(^TMP("MAGQ","WSUD"))
 . . S ^TMP("MAGQAS",0)=VALUE ;1ST SHARE=CWL
 . S RESULT(CNT)=VALUE,CNT=CNT+1
 . S ^TMP("MAGQAS",CNT-1)=VALUE
 Q
ALLSHR(RESULT) ; RPC[MAGQBP ALL SHARES]
 N TMP,INDX,DATA,CNT,SHARE,CWL,VALUE,PLACE ;CWL=CURRENT WRITE LOCATION
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 S (CNT,INDX)=0,U="^"
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S CWL=$$CWL^MAGBAPI(PLACE)
 F  S INDX=$O(^MAG(2005.2,INDX)) Q:INDX'?1N.N  D
 . S DATA=$G(^MAG(2005.2,INDX,0))
 . Q:$P(DATA,U,6,7)'["1^MAG"
 . Q:$P(DATA,U,9)="1"  ;ROUTING SHARE
 . Q:$P(DATA,U,2)[":"
 . Q:($P(DATA,U,10)'=PLACE)
 . S SHARE=$P(DATA,U,2)
 . Q:$E(SHARE,1,2)'="\\"
 . I $E(SHARE,$L(SHARE))="\" S SHARE=$E(SHARE,1,$L(SHARE)-1)
 . Q:$D(TMP(SHARE))
 . S TMP(SHARE)=""
 S INDX=""
 F  S INDX=$O(TMP(INDX)) Q:INDX=""  D
 . S RESULT(CNT)=INDX,CNT=CNT+1
 K TMP
 Q
FSUPDT(RESULT,IEN,SPACE,SIZE) ;
 ;File Server Update
 ; RPC[MAGQ FS UPDATE]
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 N NODE,X,Y,INDEX,SHNAME,PLACE
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S X=$$NOW^XLFDT S Y=X D DD^%DT S ^TMP("MAGQ","WSUD")=Y
 S ^TMP("MAGQ","WSUD",XWBTIP)=Y
 I $G(^MAG(2005.2,IEN,0))="" S RESULT="-1^No Network Location Entry" Q
 S NODE=^MAG(2005.2,IEN,0)
 D FSW(IEN,NODE)
 S INDEX=0,SHNAME=$P(NODE,"^",2)
 ; NOW UPDATE THE SIZING FIELDS FOR SHARES OF SAME PHYS LOCATION
 F  S INDEX=$O(^MAG(2005.2,"AC",SHNAME,INDEX)) Q:INDEX'?1N.N  D
 . Q:INDEX=IEN
 . S NODE=^MAG(2005.2,INDEX,0)
 . D FSW(INDEX,NODE)
 S RESULT="1^Update Complete"
 Q
FSW(INDEX,NODE) ;
 I (($P(NODE,"^",3)'=(+SIZE))!($P(NODE,"^",5)'=(+SPACE))) D
 . S $P(NODE,"^",3)=+SIZE,$P(NODE,"^",5)=+SPACE,^MAG(2005.2,INDEX,0)=NODE
 Q
QUEUER(QUE,FROM,TO) ;
 N TYPE,INC,CNT,AR,TMP,PLACE,INST,MAGFILE
 I $$GET1^DIQ(200,+$G(DUZ),.01)="" D  Q
 . W !,"You must have a valid User ID (DUZ) to use this function!"
 I "^JBTOHD^PREFET^ABSTRACT^JUKEBOX^GCC^DELETE^EVAL^"'[QUE D  Q
 . W !,"Only JBTOHD, PREFET, ABSTRACT, JUKEBOX, DELETE, EVAL & GCC queues are valid!"
 . W !,"Input values: ""Queue type"",""From Image IEN"",""To Image IEN"""
 S CNT=0
 ;
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 ;
 S INST=$$GET1^DIQ(2006.1,PLACE,.01,"I")
 F INC=FROM:1:TO D
 . I ('$D(^MAG(2005,INC,0))&('$D(^MAG(2005.1,INC,0)))) Q
 . I ($P($G(^MAG(2005,INC,100)),U,3)'=INST)&($P($G(^MAG(2005.1,INC,100)),U,3)'=INST) Q
 . I ($P($G(^MAG(2005,INC,0)),"^",2)="")&($P($G(^MAG(2005.1,INC,0)),"^",2)="") Q  ;No full filename attribute
 . I (+$P($G(^MAG(2005,INC,1,0)),"^",4)>0)!(+$P($G(^MAG(2005.1,INC,1,0)),"^",4)>0) Q  ;GROUP PARENT
 . I "^DELETE^"[QUE D  Q
 . . S MAGXX=INC D VSTNOCP^MAGFILEB I $P(MAGFILE,U)="-1" W !,"Image # "_INC Q
 . . S MAGXX=INC D ABSNOCP^MAGFILEB I $P(MAGFILE,U)="-1" W !,"Image # "_INC Q
 . . S MAGXX=INC D BIGNOCP^MAGFILEB I $P(MAGFILE,U)="-1" W !,"Image # "_INC Q
 . . D IMAGEDEL^MAGGTID(.MAGFILE,INC,"","TESTING") Q
 . I "^JBTOHD^PREFET^"[QUE F TYPE="ABSTRACT","FULL","BIG" D
 . . Q:(TYPE="BIG")&('$D(^MAG(2005,INC,"FBIG"))&'$D(^MAG(2005.1,INC,"FBIG")))
 . . D MAPI(QUE,INC_"^"_TYPE,.CNT)
 . E  D MAPI(QUE,INC,.CNT)
 Q
MPAC(SW,FROM,TO) ;
 N INDEX
 I (SW'=1)&(SW'=0) W !,"The first parameter must equal 0 or 1" Q
 I (FROM<0)!((TO<0)!(TO<FROM)) W !,"The second parameter must be greater than 0 and less than the third!" Q
 S FROM=FROM-1
 F  S INDEX=$O(^MAG(2005,INDEX)) Q:INDEX'?1N.N  Q:INDEX>TO  D
 . I '$D(^MAG(2005,INDEX,0)) Q
 . I $P($G(^MAG(2005,INDEX,0)),"^",2)="" Q  ;No full filename attribute
 . I +$P($G(^MAG(2005,INDEX,1,0)),"^",4)>0 Q  ;GROUP PARENT
 . I (SW=1)&('$D(^MAG(2005,INDEX,"PACS"))) S ^MAG(2005,INDEX,"PACS")="TEST PACS" Q
 . I SW=0 K ^MAG(2005,INDEX,"PACS")
 Q
MAPI(TYP,PARAM,CNT) ;
 N PLACE
 S CNT=CNT+1,PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 W !,CNT," TYPE: ",TYP,": ",PARAM_" QUEUE #: ",@("$$"_TYP_"^MAGBAPI(PARAM,PLACE)")
 Q
BPQSL(RESULT,TYPE) ;
 ; RPC[MAGQB QSL]
 N STATUS,CNT,IEN,CP,PLACE
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S STATUS="",CNT=0
 F  S STATUS=$O(^MAGQUEUE(2006.03,"D",PLACE,TYPE,STATUS)) Q:STATUS=""  D
 . Q:+STATUS>0
 . S IEN=$O(^MAGQUEUE(2006.03,"D",PLACE,TYPE,STATUS,""))
 . S CP=$P(^MAGQUEUE(2006.031,$O(^MAGQUEUE(2006.031,"C",PLACE,TYPE,"")),0),"^",2)
 . Q:IEN>(CP)
 . S CNT=CNT+1,RESULT(CNT)=STATUS
 Q
