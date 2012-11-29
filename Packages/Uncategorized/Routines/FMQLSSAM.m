FMQLSSAM;       Caregraf - FMQL Schema Enhancement for Terminologies ; Jun 29th, 2011
           ;;0.9;FMQLQP;;Jun 29th, 2011
        
        
RESOLVE(FILENUM,IEN,DEFLABEL,SAMEAS)    
           Q:'$D(^DIC(FILENUM,0,"GL"))  ; catches CNode
           ; Q:IEN'=+IEN ; catch non numeric IEN
           I IEN'=+IEN S ^TMP("FMQLCORR","SAMEAS:IEN",FILENUM)=IEN Q
           I FILENUM="50.7" D RESOLVE50dot7(IEN,.SAMEAS) Q  ; PHARMACY ORDERABLE
           I FILENUM="50" D RESOLVE50(IEN,.SAMEAS) Q  ; DRUG
           I FILENUM="71" D RESOLVE71(IEN,.SAMEAS) Q  ; RAD/NUC PROCEDURE
           I FILENUM="790.2" D RESOLVE790dot2(IEN,.SAMEAS) Q  ; WV PROCEDURE
           I FILENUM="757" D RESOLVE757(IEN,.SAMEAS) Q  ; Major Concept
           I FILENUM="757.01" D RESOLVE757dot01(IEN,.SAMEAS) Q ; EXP
           I FILENUM="9999999.27" D RESOLVE9999999dot27(IEN,.SAMEAS) Q ; Prov Nav
           D RESOLVEVAFIXED(FILENUM,IEN,DEFLABEL,.SAMEAS) Q:$D(SAMEAS("URI"))
           D RESOLVESTANDARD(FILENUM,IEN,DEFLABEL,.SAMEAS) Q:$D(SAMEAS("URI"))
           D RESOLVEVUID(FILENUM,IEN,DEFLABEL,.SAMEAS) Q:$D(SAMEAS("URI"))
           Q
        
RESOLVEVUID(FILENUM,IEN,DEFLABEL,SAMEAS)        
           N VUID,VUIDE
           I (($G(DEFLABEL)="")!($G(IEN)="")) Q  ; RESOLVEDRUG, maybe more need this
           Q:'$D(^DD(FILENUM,"B","VUID",99.99))
           S SAMEAS("URI")="LOCAL"
           S VUIDE=^DIC(FILENUM,0,"GL")_IEN_","_"""VUID"""_")"
           I DEFLABEL["/" S DEFLABEL=$TR(DEFLABEL,"/","-")  ; TMP: names with /. TBD fix.
           I $G(@VUIDE) S SAMEAS("URI")="VA:"_$P($G(@VUIDE),"^",1) S SAMEAS("LABEL")=DEFLABEL  Q
           Q
        
RESOLVEVAFIXED(FILENUM,IEN,DEFLABEL,SAMEAS)     
           ; Setup config array if not yet defined (no default LOCAL)
           I '$D(^FMQLVASAMEAS) D
           . S ^FMQLVASAMEAS("5")="5"  ; State
           . ; S ^FMQLVASAMEAS("10")="10" TBD: Race Should have HL7 but doesn't. Recheck.
           . S ^FMQLVASAMEAS("11")="11"  ; Coded Value for Marital Status so fixed
           . Q
           I $D(^FMQLVASAMEAS(FILENUM)) S SAMEAS("URI")="VA:"_$TR(FILENUM,".","_")_"-"_IEN S SAMEAS("LABEL")=$P(DEFLABEL,"/",2) Q
           Q 
        
RESOLVESTANDARD(FILENUM,IEN,DEFLABEL,SAMEAS)    
           ; No default local: should all have codes!
           I FILENUM="80" D
           . Q:'$D(@("^ICD9("_IEN_",0)"))  ; TBD: log invalid
           . S SAMEAS("URI")="ICD9:"_$P(DEFLABEL,"/",2) 
           . S SAMEAS("LABEL")=$P(@("^ICD9("_IEN_",0)"),"^",3)
           I FILENUM="81" D
           . Q:'$D(@("^ICPT("_IEN_",0)")) 
           . S SAMEAS("URI")="CPT:"_$P(DEFLABEL,"/",2) 
           . S SAMEAS("LABEL")=$P(@("^ICPT("_IEN_",0)"),"^",2)
           I FILENUM="8932.1" D 
           . Q:'$D(@("^USC(8932.1,"_IEN_",0)")) 
           . S SAMEAS("URI")="PROVIDER:"_$P(@("^USC(8932.1,"_IEN_",0)"),"^",7) 
           . S SAMEAS("LABEL")=$P(@("^USC(8932.1,"_IEN_",0)"),"^",2) 
           Q
        
RESOLVE9999999dot27(IEN,SAMEAS) 
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^AUTNPOV(IEN,757))
           N SEVEN5701 S SEVEN5701=$P(^AUTNPOV(IEN,757),"^")
           Q:SEVEN5701=""
           D RESOLVE757dot01(SEVEN5701,.SAMEAS)
           Q ; don't fall back on a 757.01 that doesn't resolve to 757
        
RESOLVE757dot01(IEN,SAMEAS)     
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^LEX(757.01,IEN,1))
           N SEVEN57 S SEVEN57=$P(^LEX(757.01,IEN,1),"^")
           Q:SEVEN57=""
           D RESOLVE757(SEVEN57,.SAMEAS)
           Q
        
RESOLVE757(IEN,SAMEAS)  
           Q:'$D(^LEX(757,IEN,0))
           ; Even major concept has a major expression and its label comes from that
           N MJRE S MJRE=$P(^LEX(757,IEN,0),"^")
           Q:MJRE=""
           Q:'$D(^LEX(757.01,MJRE,0))
           N SAMEASLABEL S SAMEASLABEL=$P(^LEX(757.01,MJRE,0),"^")
           Q:SAMEASLABEL=""
           S SAMEAS("URI")="VA:757-"_IEN
           S SAMEAS("LABEL")=SAMEASLABEL
           Q
        
RESOLVE50dot7(IEN,SAMEAS)       
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^PSDRUG("ASP",IEN))
           N DRUGIEN S DRUGIEN=$O(^PSDRUG("ASP",IEN,""))
           D RESOLVE50(DRUGIEN,.SAMEAS)
           Q:SAMEAS("URI")'="LOCAL"
           N SAMEASLABEL S SAMEASLABEL=$P(^PSDRUG(DRUGIEN,0),"^")
           Q:SAMEASLABEL=""
           S SAMEAS("URI")="LOCAL:50-"_DRUGIEN
           S SAMEAS("LABEL")=SAMEASLABEL
           Q
           
RESOLVE50(IEN,SAMEAS)   
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^PSDRUG(IEN,"ND")) ; Not mandatory to map to VA Product
           N VAPIEN S VAPIEN=$P(^PSDRUG(IEN,"ND"),"^",3)
           ; Q:VAPIEN'=+VAPIEN ; catch corrupt IEN
           I VAPIEN'=+VAPIEN S ^TMP("FMQLCORR","SAMEAS:50_IEN",IEN)=VAPIEN Q  ; VAPIEN may be zero so can't be subscript
           D RESOLVEVUID("50.68",VAPIEN,$P(^PSDRUG(IEN,"ND"),"^",2),.SAMEAS)
           Q
        
        
RESOLVE71(IEN,SAMEAS)   
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^DIC(71,0,"GL"))
           N CODEAR S CODEAR=^DIC(71,0,"GL")
           D RESOLVETOCPT(IEN,CODEAR,9,.SAMEAS)
           Q
           
RESOLVE790dot2(IEN,SAMEAS)      
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^DIC(790.2,0,"GL"))
           N CODEAR S CODEAR=^DIC(790.2,0,"GL")
           D RESOLVETOCPT(IEN,CODEAR,8,.SAMEAS)
           Q
        
RESOLVETOCPT(IEN,CODEAR,CPTFI,SAMEAS)   
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(@(CODEAR_IEN_",0)"))
           N CPT S CPT=$P(@(CODEAR_IEN_",0)"),"^",CPTFI)
           Q:CPT=""
           Q:'$D(^ICPT("B",CPT))
           S CPTIEN=$O(^ICPT("B",CPT,""))
           N SAMEASLABEL S SAMEASLABEL=$P(^ICPT(CPTIEN,0),"^",2)
           Q:SAMEASLABEL=""
           S SAMEAS("URI")="CPT:"_CPT
           S SAMEAS("LABEL")=SAMEASLABEL
           Q
        
RESOLVE6304(STFIELD,FCODE)      
           Q:'$D(^LAB(60,"C",STFIELD))  ; "C" INDEX is for 5, location_data_name
           N SIXZERO S SIXZERO=$O(^LAB(60,"C",STFIELD,""))
           ; Issue for 64: in GWB Vista, some verify_wkld_code multiple have it. Just 60 now
           Q:'$D(^LAB(60,SIXZERO,0))
           N LABEL S LABEL=$P(^LAB(60,SIXZERO,0),"^")
           Q:LABEL=""
           S FCODE("URI")="60-"_SIXZERO
           S FCODE("LABEL")=LABEL
           Q
        
RESOLVE60(IEN,SAMEAS)   
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^LAB(60,IEN,64))
           ; Take Result NLT over National NLT
           N NLTIEN S NLTIEN=$S($P(^LAB(60,IEN,64),"^",2):$P(^LAB(60,IEN,64),"^",2),$P(^LAB(60,IEN,64),"^"):$P(^LAB(60,IEN,64),"^"),1:"")
           Q:NLTIEN=""
           Q:'$D(^LAM(NLTIEN))
           N WKLDCODE S WKLDCODE=$P(^LAM(NLTIEN,0),"^",2)
           S SAMEAS("URI")="NLT64:"_WKLDCODE
           S SAMEAS("LABEL")=$P(^LAM(NLTIEN,0),"^")
           D RESOLVE64(NLTIEN,.SAMEAS)
           Q
        
RESOLVE64(IEN,SAMEAS)   
           S:'$D(SAMEAS("URI")) SAMEAS("URI")="LOCAL"
           Q:'$D(^LAM(IEN,9))
           N DEFLN S DEFLN=$P(^LAM(IEN,9),"^")
           Q:DEFLN=""
           Q:'$D(^LAB(95.3,DEFLN))
           Q:'$D(^LAB(95.3,DEFLN,81))  ; shortname
           S SAMEAS("URI")="LOINC:"_$P(^LAB(95.3,DEFLN,0),"^")_"-"_$P(^LAB(95.3,DEFLN,0),"^",15)  ; code and check_digit
           S SAMEAS("LABEL")=^LAB(95.3,DEFLN,81)
           Q
