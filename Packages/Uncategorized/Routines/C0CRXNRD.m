C0CRXNRD ; WV/SMH - CCR/CCD PROJECT: Routine to Read RxNorm files;11/15/08
 ;;0.1;C0C;nopatch;noreleasedate;Build 2
 W "No entry from top" Q
IMPORT(PATH)
 I PATH="" QUIT
 D READSRC(PATH),READCON(PATH),READNDC(PATH)
 QUIT
 ;
DELFILED(FN) ; Delete file data; PEP procedure; only for RxNorm files
 ; FN is Filenumber passed by Value
 QUIT:$E(FN,1,3)'=176  ; Quit if not RxNorm files
 D CLEAN^DILF ; Clean FM variables
 N ROOT S ROOT=$$ROOT^DILFD(FN,"",1) ; global root
 N ZERO S ZERO=@ROOT@(0) ; Save zero node
 S $P(ZERO,U,3,9999)="" ; Remove entry # and last edited
 K @ROOT ; Kill the file -- so sad!
 S @ROOT@(0)=ZERO ; It riseth again!
 QUIT
GETLINES(PATH,FILENAME) ; Get number of lines in a file
 D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
 U IO
 N I
 F I=1:1 R LINE Q:$$STATUS^%ZISH
 D CLOSE^%ZISH("FILE")
 Q I-1
READCON(PATH,INCRES) ; Open and read concepts file: RXNCONSO.RRF; EP
 ; PATH ByVal, path of RxNorm files
 ; INCRES ByVal, include restricted sources. 1 for yes, 0 for no
 I PATH="" QUIT
 S INCRES=+$G(INCRES) ; if not passed, becomes zero.
 N FILENAME S FILENAME="RXNCONSO.RRF"
 D DELFILED(176.001) ; delete data
 N LINES S LINES=$$GETLINES(PATH,FILENAME)
 D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
 IF POP D EN^DDIOL("Error reading file..., Please check...") G EX
 N C0CCOUNT
 F C0CCOUNT=1:1 D  Q:$$STATUS^%ZISH
 . U IO
 . N LINE R LINE
 . IF $$STATUS^%ZISH QUIT
 . I '(C0CCOUNT#1000) U $P W C0CCOUNT," of ",LINES," read ",! U IO ; update every 1000
 . N RXCUI,RXAUI,SAB,TTY,CODE,STR  ; Fileman fields numbers below
 . S RXCUI=$P(LINE,"|",1) ; .01
 . S RXAUI=$P(LINE,"|",8) ; 1
 . S SAB=$P(LINE,"|",12) ; 2
 . ; If the source is a restricted source, decide what to do based on what's asked.
 . N SRCIEN S SRCIEN=$$FIND1^DIC(176.003,"","QX",SAB,"B") ; SrcIEN in RXNORM SOURCES file
 . N RESTRIC S RESTRIC=$$GET1^DIQ(176.003,SRCIEN,14,"I") ; 14 is restriction field; values 0-4
 . ; If RESTRIC is zero, then it's unrestricted. Everything else is restricted.
 . ; If user didn't ask to include restricted sources, and the source is restricted, then quit
 . I 'INCRES,RESTRIC QUIT
 . S TTY=$P(LINE,"|",13) ; 3
 . S CODE=$P(LINE,"|",14) ; 4
 . S STR=$P(LINE,"|",15) ; 5
 . ; Remove embedded "^"
 . S STR=$TR(STR,"^")
 . ; Convert STR into an array of 80 characters on each line
 . N STRLINE S STRLINE=$L(STR)\80+1
 . ; In each line, chop 80 characters off, reset STR to be the rest
 . N J F J=1:1:STRLINE S STR(J)=$E(STR,1,80) S STR=$E(STR,81,$L(STR))
 . ; Now, construct the FDA array
 . N RXNFDA
 . S RXNFDA(176.001,"+1,",.01)=RXCUI
 . S RXNFDA(176.001,"+1,",1)=RXAUI
 . S RXNFDA(176.001,"+1,",2)=SAB
 . S RXNFDA(176.001,"+1,",3)=TTY
 . S RXNFDA(176.001,"+1,",4)=CODE
 . N RXNIEN S RXNIEN(1)=C0CCOUNT
 . D UPDATE^DIE("","RXNFDA","RXNIEN")
 . I $D(^TMP("DIERR",$J)) D EN^DDIOL("ERROR") G EX
 . ; Now, file WP field STR
 . D WP^DIE(176.001,C0CCOUNT_",",5,,$NA(STR))
EX D CLOSE^%ZISH("FILE")
 QUIT
READNDC(PATH) ; Open and read NDC/RxNorm/VANDF relationship file: RXNSAT.RRF
 I PATH="" QUIT
 N FILENAME S FILENAME="RXNSAT.RRF"
 D DELFILED(176.002) ; delete data
 N LINES S LINES=$$GETLINES(PATH,FILENAME)
 D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
 IF POP W "Error reading file..., Please check...",! G EX2
 F C0CCOUNT=1:1 Q:$$STATUS^%ZISH  D
 . U IO
 . N LINE R LINE
 . IF $$STATUS^%ZISH QUIT
 . I '(C0CCOUNT#1000) U $P W C0CCOUNT," of ",LINES," read ",! U IO ; update every 1000
 . IF LINE'["NDC|RXNORM"  QUIT
 . ; Otherwise, we are good to go
 . N RXCUI,NDC ; Fileman fields below
 . S RXCUI=$P(LINE,"|",1) ; .01
 . S NDC=$P(LINE,"|",11) ; 2
 . ; Using classic call to update.
 . N DIC,X,DA,DR
 . K DO
 . S DIC="^C0CRXN(176.002,",DIC(0)="F",X=RXCUI,DIC("DR")="2////"_NDC
 . D FILE^DICN
 . I Y<1 U $P W !,"THERE IS TROUBLE IN RIVER CITY",! G EX2
EX2 D CLOSE^%ZISH("FILE")
 QUIT
READSRC(PATH) ; Open the read RxNorm Sources file: RXNSAB.RRF
 I PATH="" QUIT
 N FILENAME S FILENAME="RXNSAB.RRF"
 D DELFILED(176.003) ; delete data
 D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
 IF POP W "Error reading file..., Please check...",! G EX3
 F I=1:1 Q:$$STATUS^%ZISH  D
 . U IO
 . N LINE R LINE
 . IF $$STATUS^%ZISH QUIT
 . U $P W I,! U IO  ; Write I to the screen, then go back to reading the file
 . N VCUI,RCUI,VSAB,RSAB,SON,SF,SVER,SRL,SCIT ; Fileman fields numbers below
 . S VCUI=$P(LINE,"|",1)        ; .01
 . S RCUI=$P(LINE,"|",2)        ; 2
 . S VSAB=$P(LINE,"|",3)        ; 3
 . S RSAB=$P(LINE,"|",4)        ; 4
 . S SON=$P(LINE,"|",5)         ; 5
 . S SF=$P(LINE,"|",6)          ; 6
 . S SVER=$P(LINE,"|",7)        ; 7
 . S SRL=$P(LINE,"|",14)  ; 14
 . S SCIT=$P(LINE,"|",25)       ; 25
 . ; Remove embedded "^"
 . S SCIT=$TR(SCIT,"^")
 . ; Convert SCIT into an array of 80 characters on each line
 . ; In each line, chop 80 characters off, reset SCIT to be the rest
 . N SCITLINE S SCITLINE=$L(SCIT)\80+1
 . F J=1:1:SCITLINE S SCIT(J)=$E(SCIT,1,80) S SCIT=$E(SCIT,81,$L(SCIT))
 . ; Now, construct the FDA array
 . N RXNFDA
 . S RXNFDA(176.003,"+"_I_",",.01)=VCUI
 . S RXNFDA(176.003,"+"_I_",",2)=RCUI
 . S RXNFDA(176.003,"+"_I_",",3)=VSAB
 . S RXNFDA(176.003,"+"_I_",",4)=RSAB
 . S RXNFDA(176.003,"+"_I_",",5)=SON
 . S RXNFDA(176.003,"+"_I_",",6)=SF
 . S RXNFDA(176.003,"+"_I_",",7)=SVER
 . S RXNFDA(176.003,"+"_I_",",14)=SRL
 . D UPDATE^DIE("","RXNFDA")
 . I $D(^TMP("DIERR",$J)) U $P W "ERR" G EX
 . ; Now, file WP field SCIT
 . D WP^DIE(176.003,I_",",25,,$NA(SCIT))
EX3 D CLOSE^%ZISH("FILE")
 Q
