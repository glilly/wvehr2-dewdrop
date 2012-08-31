BPSUTIL2        ;BHAM ISC/SS - General Utility functions ;08/01/2006
        ;;1.0;E CLAIMS MGMT ENGINE;**7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
        ;/**
        ;Creates a new entry (or node for multiple with .01 field)
        ;
        ;BPFILE - file/subfile number
        ;BPIEN - ien of the parent file entry in which the new subfile entry will be inserted
        ;BPVAL01 - .01 value for the new entry
        ;NEWRECNO -(optional) specify IEN if you want specific value
        ; Note: "" then the system will assign the entry number itself.
        ;BPFLGS - FLAGS parameter for UPDATE^DIE
        ;LCKGL - fully specified global refernece to lock
        ;LCKTIME - time out for LOCK, if LOCKTIME=0 then the function will not lock the file 
        ;BPNEWREC - optional, flag = if 1 then allow to create a new top level record 
        ;Examples
        ;top level:
        ; D INSITEM(366.14,"",IBDATE,"")
        ;to create with the specific ien
        ; W $$INSITEM^BPSUTIL2(9002313.77,"",55555555,45555,,,,1)
        ; 
        ;1st level multiple:
        ; subfile number = #366.141
        ; parent file #366.14 entry number = 345
        ; D INSITEM(366.141,345,"SUBMIT","")
        ; to create mupltiple entry with particular entry number = 23
        ; D INSITEM(366.141,345,"SUBMIT",23)
        ;
        ;2nd level multiple
        ;parent file #366.14 entry number = 234
        ;parent multiple entry number = 55
        ;create mupltiple entry INSURANCE
        ; D INSITEM(366.1412,"55,234","INS","")
        ; results in :
        ; ^IBCNR(366.14,234,1,55,5,0)=^366.1412PA^1^1
        ; ^IBCNR(366.14,234,1,55,5,1,0)=INS
        ; ^IBCNR(366.14,234,1,55,5,"B","INS",1)=
        ;  (DD node for this muptiple =5 ) 
        ;  
        ;output :
        ; positive number - record # created
        ; <=0 - failure
        ;  See description above
INSITEM(BPFILE,BPIEN,BPVAL01,NEWRECNO,BPFLGS,LCKGL,LCKTIME,BPNEWREC)    ;*/
        I ('$G(BPFILE)) Q "0^Invalid parameter"
        I +$G(BPNEWREC)=0 I $G(NEWRECNO)>0,'$G(BPIEN) Q "0^Invalid parameter"
        I $G(BPVAL01)="" Q "0^Null"
        N BPLOCK S BPLOCK=0
        ;I '$G(BPFILE) Q -1
        ;I '$G(BPVAL01) Q -1
        N BPSSI,BPIENS,BPFDA,BPERR
        I '$G(NEWRECNO) N NEWRECNO S NEWRECNO=$G(NEWRECNO)
        I BPIEN'="" S BPIENS="+1,"_BPIEN_"," I $L(NEWRECNO)>0 S BPSSI(1)=+NEWRECNO
        I BPIEN="" S BPIENS="+1," I $L(NEWRECNO)>0 S BPSSI(1)=+NEWRECNO
        S BPFDA(BPFILE,BPIENS,.01)=BPVAL01
        I $L($G(LCKGL)) L +@LCKGL:(+$G(LCKTIME)) S BPLOCK=$T I 'BPLOCK Q -2  ;lock failure
        D UPDATE^DIE($G(BPFLGS),"BPFDA","BPSSI","BPERR")
        I BPLOCK L -@LCKGL
        I $D(BPERR) D BMES^XPDUTL($G(BPERR("DIERR",1,"TEXT",1),"Update Error")) Q -1  ;D BMES^XPDUTL(BPERR("DIERR",1,"TEXT",1)) 
        Q +$G(BPSSI(1))
        ;
        ;fill fields
        ;Input:
        ;FILENO file number
        ;FLDNO field number
        ;RECIEN ien string 
        ;NEWVAL new value to file (internal format)
        ;Output:
        ;0^ NEWVAL^error if failure
        ;1^ NEWVAL if success
FILLFLDS(FILENO,FLDNO,RECIEN,NEWVAL)    ;
        I '$G(FILENO) Q "0^Invalid parameter"
        I '$G(FLDNO) Q "0^Invalid parameter"
        I '$G(RECIEN) Q "0^Invalid parameter"
        I $G(NEWVAL)="" Q "0^Null"
        N RECIENS,FDA,ERRARR
        S RECIENS=RECIEN_","
        S FDA(FILENO,RECIENS,FLDNO)=NEWVAL
        D FILE^DIE("","FDA","ERRARR")
        I $D(ERRARR) Q "0^"_NEWVAL_"^"_ERRARR("DIERR",1,"TEXT",1)
        Q "1^"_NEWVAL
        ;
        ;API to return the GROUP INSURANCE PLAN associated with the
        ;PRIMARY INSURANCE in the BPS TRANSACTION File
        ;Input:
        ;BPIEN59 = IEN of entry in BPS TRANSACTION File
        ;Output:
        ;IEN of GROUP INSURANCE PLAN file^INSURANCE COMPANY Name
GETPLN59(BPIEN59)       ;
        N IENS,GRPNM
        S IENS=+$G(^BPST(BPIEN59,9))_","_BPIEN59_","
        S GRPNM=$$GET1^DIQ(9002313.59902,IENS,"PLAN ID:INSURANCE COMPANY")
        Q +$G(^BPST(BPIEN59,10,+$G(^BPST(BPIEN59,9)),0))_"^"_GRPNM
        ;
GETPLN77(BPIEN77)       ;
        N BPINSIEN,BPSINSUR,BPINSDAT
        S BPINSIEN=0
        ;get the USED FOR THE REQUEST=1 (active) entry in the multiple
        S BPINSIEN=$O(^BPS(9002313.77,BPIEN77,5,"C",1,BPINSIEN))
        I +BPINSIEN=0 Q 0
        ;get BPS IBNSURER DATA pointer
        S BPSINSUR=+$P($G(^BPS(9002313.77,BPIEN77,5,BPINSIEN,0)),U,3)
        I BPSINSUR=0 Q 0
        ;get 0th node of the BPS INSURER DATA
        S BPINSDAT=$G(^BPS(9002313.78,BPSINSUR,0))
        I BPINSDAT="" Q 0
        Q $P(BPINSDAT,U,8)_"^"_$P(BPINSDAT,U,7)
