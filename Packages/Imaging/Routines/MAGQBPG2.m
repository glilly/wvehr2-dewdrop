MAGQBPG2 ;WCIOFO - TS RMP Magnetic Server Purge processes [ 06/29/2001 18:28 ]
 ;;3.0;IMAGING;**8,20**;Apr 12, 2006
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way  |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
CNP(RESULT,IEN) ; [MAGQ PCHKN]
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 N FNAME,PIECE,ZNODE,BNODE,BNAME,PTR,HASH
 S IEN=+IEN,RESULT="^^^",U="^"
 F  S IEN=$O(^MAG(2005,IEN)) Q:IEN'?1N.N  D  Q:RESULT'="^^^"
 . S ZNODE=$G(^MAG(2005,IEN,0))
 . S FNAME=$P(ZNODE,U,2)
 . I (FNAME["\")!(FNAME[":") D
 . . S FNAME=$$FNX(FNAME)
 . . S $P(^MAG(2005,IEN,0),U,2)=FNAME
 . Q:$P(ZNODE,U,2)=""  ;PROBABLE GROUP HEAD
 . S BNODE=$G(^MAG(2005,IEN,"FBIG"))
 . S PTR=$P(ZNODE,U,3) I PTR?1N.N D
 . . S HASH=$P(^MAG(2005.2,PTR,0),U,8)
 . . S $P(^MAG(2005,IEN,0),U,3)=$$SHNAM^MAGQBPRG($P(^MAG(2005.2,PTR,0),U,2),HASH)
 . . S $P(RESULT,"^")=$$JBPATH^MAGQBPRG(FNAME,PTR)
 . S PTR=$P(ZNODE,U,4) I PTR?1N.N D
 . . S HASH=$P(^MAG(2005.2,PTR,0),U,8)
 . . S $P(^MAG(2005,IEN,0),U,4)=$$SHNAM^MAGQBPRG($P(^MAG(2005.2,PTR,0),U,2),HASH)
 . . S $P(RESULT,U,2)=$$JBPATH^MAGQBPRG($P(FNAME,".")_".ABS",PTR)
 . S PTR=$P(BNODE,U) I PTR?1N.N D
 . . S HASH=$P(^MAG(2005.2,PTR,0),U,8)
 . . S $P(^MAG(2005,IEN,"FBIG"),U)=$$SHNAM^MAGQBPRG($P(^MAG(2005.2,PTR,0),U,2),HASH)
 . . S BNAME=$P(FNAME,".")_".BIG"
 . . S $P(RESULT,"^",3)=$$JBPATH^MAGQBPRG(BNAME,PTR)
 . I RESULT'="^^^" S $P(RESULT,U,4)=IEN  ;IEN
 Q
FNX(NAME) ;FIX FILENAME
 I NAME[":" S NAME=$P(NAME,":",$L(NAME,":"))
 I NAME["\" S NAME=$P(NAME,"\",$L(NAME,"\"))
 Q NAME
CNPT ;
 N IEN,RESULT,%
 S IEN=0
 D NOW^%DTC
 F  D CNP(.RESULT,.IEN) W:RESULT[":" !,RESULT Q:IEN'?1N.N  D
 . S IEN=$P(RESULT,"^",4)
 Q
PGEPAR(RESULT) ; RPC[MAGQBP PARM]
 ;; RECORD PurgeParam
 ;; Status^MinAbs^MinFull^MinBig^ABS^PACABS^FULL^PACS^BIG^PACSBIG^RADHOLD
 ;; ^FilePrefix
 ;; FULL:8,PACS:9,PACSBIG:21,BIG:22,ABS:23,ABSPACS:24,RADHOLDS:13
 N ABS,FULL,PACSABS,PACS,BIG,PACSBIG,MINABS,MINFULL,MINBIG,PREFIX,NODE3
 N FILE,PLACE,FIELD,FLAGS
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S NODE3=$G(^MAG(2006.1,PLACE,3))
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 S U="^"
 S FILE=2006.1,FIELD="8;9;13;21;22;23;24",FLAGS="E"
 D GETS^DIQ(FILE,PLACE,FIELD,FLAGS,"ARR","ERR")
 S FULL=+ARR(2006.1,PLACE_",",8,"E"),TFULL(FULL)=""
 S ABS=+ARR(2006.1,PLACE_",",23,"E"),TABS(ABS)=""
 S PACS=+ARR(2006.1,PLACE_",",9,"E"),TFULL(PACS)=""
 S PACSABS=+ARR(2006.1,PLACE_",",24,"E"),TABS(PACSABS)=""
 S PACSBIG=+ARR(2006.1,PLACE_",",21,"E"),TBIG(PACSBIG)=""
 S BIG=+ARR(2006.1,PLACE_",",22,"E"),TBIG(BIG)=""
 S MINABS=+$O(TABS(0)),MINFULL=+$O(TFULL(0)),MINBIG=+$O(TBIG(0))
 S PREFIX=$$INIS(PLACE)
 K TABS,TFULL,TBIG
 S RESULT="1"_U_MINABS_U_MINFULL_U_MINBIG_U_ABS_U_PACSABS_U_FULL_U_PACS
 S RESULT=RESULT_U_BIG_U_PACSBIG_U_+ARR(2006.1,PLACE_",",13,"E")_U_PREFIX
 Q
 ;;
PGEUD(RESULT,FILENAME,EXT,IEN,DEVICE) ; RPC[MAGQBP UPDATE]
 N FTYPE,NODE,PIECE,PLACE
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S RESULT="0",FTYPE=$$FTYPE^MAGQBPRG(EXT)
 ;I $P($G(^MAG(2006.1,PLACE,"JBEX")),U,5) D IMAGEDEL^MAGGTID(.RESULT,IEN) Q
 S NODE=$S(FTYPE="BIG":"FBIG",1:0)
 S:DEVICE="JB" PIECE=$S(FTYPE="ABS":5,FTYPE="BIG":2,FTYPE="FULL":5,1:0)
 S:DEVICE="NET" PIECE=$S(FTYPE="ABS":4,FTYPE="BIG":1,FTYPE="FULL":3,1:0)
 I PIECE=0 D ELOG^MAGQBPRG(NODE,FTYPE) Q
 S RESULT="1"
 S:$D(^MAG(2005,IEN,NODE)) $P(^MAG(2005,IEN,NODE),U,PIECE)=""
 S:$D(^MAG(2005.1,IEN,NODE)) $P(^MAG(2005.1,IEN,NODE),U,PIECE)=""
 Q
INIS(PLACE) ;
 N ARRY,CNT,SUB,RESULT
 S ARRY($P($G(^MAG(2006.1,PLACE,0)),"^",2))=""
 S CNT=0
 F  S CNT=$O(^MAG(2006.1,PLACE,4,CNT)) Q:CNT'?1N.N  D
 . S ARRY(^MAG(2006.1,PLACE,4,CNT,0))=""
 S (SUB,RESULT)=""
 F  S SUB=$O(ARRY(SUB)) Q:SUB=""  D
 . S RESULT=$S(RESULT="":SUB,1:(RESULT_","_SUB))
 K ARRY
 Q RESULT
