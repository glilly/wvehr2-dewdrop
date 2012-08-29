VBECA1 ;DALOI/PWC - APIS TO RETURN BLOOD BANK DATA FOR LAB ;10/12/00  13:57
 ;;0.5;VBECS;**294**;Sep 6, 2000
 ; This routine retrieves data maintained by a regulated medical
 ; device.  The routine must not be modified by anyone other than the
 ; device manufacturer.
 ; This routine is not intended to be invoked by name
 QUIT
 ;Reference to FIND^DIC supported by IA #2051
 ;Reference to ^%DT supported by IA #10003
 ;Reference to GETS^DIQ() supported by IA #2056
 ;
 ; This routine is called by other packages to access blood bank data
 ;
ABORH(PATID,PATNAM,PATDOB,PARENT) ;
 ; Return the ABO/Rh value stored in file 63, fields .05 & .06
 ; for the DFN of the patient provided.  A space will be between
 ; values .05 and .06.
 ;
 N LRDFN,P5,P6
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN Q -1
 K LRERR,DIERR,ARR
 D GETS^DIQ(63,LRDFN_",",".05;.06","E","ARR","LRERR")
 S P5=ARR(63,LRDFN_",",.05,"E"),P6=ARR(63,LRDFN_",",.06,"E")
 S ANS=P5_" "_P6
 K ARR
 Q ANS
 ;
ABO(PATID,PATNAM,PATDOB,PARENT) ;
 ; Return the ABO value stored in file 63, fields .05 for the DFN
 ; of the patient provided.
 ;
 N LRDFN,P5
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN Q -1
 K LRERR,DIERR,ARR
 D GETS^DIQ(63,LRDFN_",",".05","E","ARR","LRERR")
 S P5=ARR(63,LRDFN_",",.05,"E"),ANS=P5
 K ARR
 Q ANS
 ;
RH(PATID,PATNAM,PATDOB,PARENT) ;
 ; Return the Rh value stored in file 63, fields .06 for the DFN
 ; of the patient provided.
 ;
 N LRDFN,P6
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN Q -1
 K LRERR,DIERR,ARR
 D GETS^DIQ(63,LRDFN_",",".06","E","ARR","LRERR")
 S P6=ARR(63,LRDFN_",",.06,"E"),ANS=P6
 K ARR
 Q ANS
 ;
AGPRES(PATID,PATNAM,PATDOB,PARENT,ARR) ; Get Antigens Present
 ; Return an array of identified antigens and antigen comments for
 ; the DFN of the patient provided.  If no antigens found, an empty
 ; array is returned ARR("AGPRES")="".
 ; The antigens are found in file 63.13 (multiple), fields .01 and .02.
 ;             ^LR(LRDFN,1
 ; Antigens is a pointer to Function Field file #61.3.
 ; ARR = the name of the array used to store antigens.
 ;   Array will contain the name of the antigen and any antigen comments
 ;        ARR("AGPRES",n) = Antigen ^ Antigen comment
 ;
 K ARR
 N LRDFN,A,I,X,P1,P2,P1A
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN S ARR=-1 Q
 S A=0 F I=1:1 S A=$O(^LR(LRDFN,1,A)) Q:A="B"!(A="")  D
 . S DATA=$G(^LR(LRDFN,1,A,0))
 . S P1=$P(DATA,"^",1),P2=$P(DATA,"^",2)
 . S P1A=$P($G(^LAB(61.3,P1,0)),"^",1)
 . S ARR("AGPRES",I)=P1A_"^"_P2
 S:'$D(ARR) ARR("AGPRES")=""    ;return empty array if none found
 Q
 ;
ABID(PATID,PATNAM,PATDOB,PARENT,ARR) ; Get Antiobodies Identified
 ; Return an array of identified antibodies and antibody comments for
 ; the DFN of the patient provided.  If no antibodies found, an empty
 ; array is returned ARR("ABID")="".
 ; The antibodies are found in file 63.075, fields .01 and .02.
 ;             ^LR(LRDFN,1.7
 ; Antibodies is a pointer to Function Field file #61.3.
 ; ARR = the name of the array used to store antibodies.
 ; Array will contain the name of the antibody and any antibody comments
 ;        ARR("ABID",n) = Antibody ^ Antibody comment
 ;
 K ARR
 N LRDFN,A,I,X,P2,P2,P1A
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN S ARR=-1 Q
 S A=0 F I=1:1 S A=$O(^LR(LRDFN,1.7,A)) Q:A=""  D
 . S DATA=$G(^LR(LRDFN,1.7,A,0))
 . S P1=$P(DATA,"^",1),P2=$P(DATA,"^",2)
 . S P1A=$P($G(^LAB(61.3,P1,0)),"^",1)
 . S ARR("ABID",I)=P1A_"^"_P2
 S:'$D(ARR) ARR("ABID")=""    ;return empty array if none found
 Q
 ;
AGAB(PATID,PATNAM,PATDOB,PARENT,ARR) ; Get RBC Antigens Absent
 ; Return an array of absent antigens and absent antigen comments for
 ; the DFN of the patient provided.  If no records found, an empty
 ; array is returned ARR("AGAB")="".
 ; The absent antigens are found in file 63.016, fields .01 and .02.\
 ;         ^LR(LRDFN,1.5
 ; Absent antigen is a pointer to Function Field file #61.3.
 ; ARR = the name of the array used to store absent antigens.
 ;   Array will contain the name of the antigen and any antigen comments
 ;        ARR("AGAB",n) = Absent Antigen ^ Absent Antigen comment
 ;
 K ARR
 N LRDFN,A,I,X,P1,P2,P1A,DATA
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN S ARR=-1 Q
 S A=0 F I=1:1 S A=$O(^LR(LRDFN,1.5,A)) Q:A=""  D
 . S DATA=$G(^LR(LRDFN,1.5,A,0))
 . S P1=$P(DATA,"^",1),P2=$P(DATA,"^",2)
 . S P1A=$P($G(^LAB(61.3,P1,0)),"^",1)
 . S ARR("AGAB",I)=P1A_"^"_P2
 S:'$D(ARR) ARR("AGAB")=""    ;return empty array if none found
 Q
 ;
TRRX(PATID,PATNAM,PATDOB,PARENT,ARR) ; Get Transfusion Reactions
 ; Return an array of transfusion reactions for the DFN of the
 ;   patient provided.  If no transfusion reactions found, an
 ;   empty array is returned  ARR("TRRX")'=""
 ; The transfusion reactions associated with a particular transfusion
 ;   episode are found in file #63.017, fields .01 and .11.
 ;                 ^LR(LRDFN,1.6
 ; Transfusion reactions that could not be associated with a particular
 ;   transfusion are found in file #63.0171, fields .01 & .02.
 ;                 ^LR(LRDFN,1.9
 ;
 ; ARR = the name of the array used to store transfusion reactions.
 ;   Array will contain both reactions where a particular unit or
 ;   transfusion was determined to be the cause of the reaction, and
 ;   those where no unit could be identified as being the cause of the
 ;   reaction.
 ; Transaction Type is a pointer to Blood Bank Utility File #65.4
 ;      ARR("TRRX",n) = Transfusion Date/Time ^ Transaction Type
 ;
 K ARR
 N LRDFN,A,P1,P2,P1A,P11,P11A,P2A,CNT,DATA
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN S ARR=-1 Q
 ; get the reactions associated with a particular transfusion
 S (A,CNT)=0 F  S A=$O(^LR(LRDFN,1.6,A)) Q:A=""  D
 . S DATA=$G(^LR(LRDFN,1.6,A,0))
 . S P1=$P(DATA,"^",1),P11=$P(DATA,"^",11) Q:P11=""   ;transaction type
 . S P11A=$S(P11'="":$P($G(^LAB(65.4,P11,0)),"^",1),1:"")
 . S CNT=CNT+1,ARR("TRRX",CNT)=P1_"^"_P11A D
 . . D FIND^DIC(66,,".02","A","`"_$P(DATA,"^",2),,,,,"VBECTRX")
 . . S ARR("TRRX",CNT)=ARR("TRRX",CNT)_"^"_VBECTRX("DILIST","ID",1,.02)_"^"_$P(DATA,"^",3) ;Added UNIT ID and COMPONENT
 . . S CMT=0 F  S CMT=$O(^LR(LRDFN,1.6,A,1,CMT)) Q:'CMT  S ARR("TRRX",CNT,CMT)=^LR(LRDFN,1.6,A,1,CMT,0)
 ; now get the reactions NOT associated with a particular transfusion
 S A=0 F  S A=$O(^LR(LRDFN,1.9,A)) Q:A=""  D
 . S DATA=$G(^LR(LRDFN,1.9,A,0))
 . S P1=$P(DATA,"^",1),P2=$P(DATA,"^",2) Q:P2=""    ;transaction type
 . S P2A=$S(P2'="":$P($G(^LAB(65.4,P2,0)),"^",1),1:"")
 . S CNT=CNT+1,ARR("TRRX",CNT)=P1_"^"_P2A
 . S CMT=0 F  S CMT=$O(^LR(LRDFN,1.9,A,1,CMT)) Q:'CMT  S ARR("TRRX",CNT,CMT)=^LR(LRDFN,1.9,A,1,CMT,0)
 S:'$D(ARR) ARR("TRRX")=""    ;return empty array if none found
 Q
 ;
BBCMT(PATID,PATNAM,PATDOB,PARENT,ARR) ; Get Blood Bank Comments
 ; Return an array of blood bank comments for the DFN of the patient
 ; provided.
 ; If no comments found, an empty array is returned ARR("BBCMT")="".
 ; The comments are found in file 63, fields .076. 
 ;        ^LR(LRDFN,3
 ; ARR = the name of the array that will be used to store comments.
 ;   Array will contain all the comment text.
 ;        ARR("BBCMT",n) = Blood Bank Comment Text
 ;
 K ARR
 N LRDFN,A,I,P76
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN S ARR=-1 Q
 S A=0 F I=1:1 S A=$O(^LR(LRDFN,3,A)) Q:A=""  D
 . S P76=$G(^LR(LRDFN,3,A,0))
 . S ARR("BBCMT",I)=P76
 S:'$D(ARR) ARR("BBCMT")=""    ;return empty array if none found
 Q
AUTO(PATID,PATNAM,PATDOB,PARENT,ARR) ; Get Available Autologous Units
 ; Return an array of available autologous units for the DFN of the
 ; patient provided.  If no comments found, an empty array is returned
 ; ARR("AUTO")="".  The autologous units are found in file 65 (Blood
 ; Inventory), fields 8.3.  First we will check to see if unit has not
 ; been dispositioned, therefore can be used for crossmatching 
 ; ("AU" level).  Next check if unit is autologous, then the array
 ; will return the component type (file 65, field .04) and 
 ; expiration date (file 65, field .06).  If expiration date has
 ; expired, or will expire today, then the array is sent back with
 ; the Component Type ^ "EXPIRED"  (literal text)
 ;  ARR = the name of the array that will store autologous units.
 ;  Array will contain the component type and the expiration date.
 ;       ARR("AUTO",n) = Component Type ^ Expiration Date
 ; Component Type is a pointer to Blood Product File (#66)
 ;
 K ARR
 N LRDFN,A,I,AU,AUT,CMP,COMP,CNT,DATA,EXPDT,EXP
 D PAT^VBECA1A  ;pass DFN, return LRDFN or 0 if not found
 I 'LRDFN S ARR=-1 Q
 I '$D(^LRD(65,"AU",LRDFN)) S ARR("AUTO")="" Q     ;no AP xref
 S (A,CNT)=0 F I=1:1 S A=$O(^LRD(65,"AU",LRDFN,A)) Q:A=""  D
 . S AUT=$G(^LRD(65,A,4)) Q:$P(AUT,"^")'=""  ; already dispositioned
 . S AU=$P(^LRD(65,A,8),"^",3) Q:AU'="A"     ; autologous unit
 . S DATA=$G(^LRD(65,A,0)),CMP=$P(DATA,"^",4),EXPDT=$P(DATA,"^",6)
 . S COMP=$P($G(^LAB(66,CMP,0)),"^",1)       ; ptr to blood product file
 . D EXPIRE(EXPDT) Q:EXP=1                   ;unit is expired
 . S CNT=CNT+1,ARR("AUTO",CNT)=COMP_"^"_EXPDT
 S:'$D(ARR) ARR("AUTO")=""    ;return empty array if none found
 Q
 ;
EXPIRE(X) ; check if date has expired
 S EXP=0,%DT="TXF" D ^%DT S X=Y K:Y<1 X
 I $D(X) S X(1)=X,%DT="T",X="N" D ^%DT S X=X(1) D
 . I $P(X,".")'>$P(Y,".") S EXP=1 Q    ; Unit expired or expires today
 . S EXP=0
 Q
