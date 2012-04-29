ONCCSRS ;Hines OIFO/GWB - Re-stage using current version; 05/11/05
        ;;2.11;ONCOLOGY;**43,46,48**; Mar 07, 1995;Build 13
        ;
        ;Re-stage 2004+ cases using current CS Version
        K DIRUT
        N ZZIS,IOP,POP
        S ZZIS="MQ"
        D OPEN^%ZISUTL("ONCCSRS",,.ZZIS) Q:$G(POP)
        D USE^%ZISUTL("ONCCSRS")
        I $D(IO("Q")) D TASK G END
        D RS D CLOSE^%ZISUTL("ONCCSRS") G END
        Q
        ;
RS      D SAVDEV^%ZISUTL("ONCCSRS")
        S VER=$P($$VERSION^ONCSAPIV,U,2)
        S VERDSP=$E(VER,1,2)_"."_$E(VER,3,4)_"."_$E(VER,5,6)
        S DIVISION=$P(^DIC(4,DUZ(2),0),U,1)
        W !?3,"Restaging using CS Version ",VERDSP," for ",DIVISION
        S CTR=0,SUCCTR=0,ERRCTR=0
        S XDT=3040000 F  S XDT=$O(^ONCO(165.5,"ADX",XDT)) Q:XDT=""  S IEN=0 F  S IEN=$O(^ONCO(165.5,"ADX",XDT,IEN)) Q:IEN=""  I $$DIV^ONCFUNC(IEN)=DUZ(2) D  G:$G(DIRUT)=1 EXIT
        .I $P($G(^ONCO(165.5,IEN,"CS1")),U,11)="" Q
        .I +$P($G(^ONCO(165.5,IEN,"CS1")),U,11)>+VER Q
        .I $P($G(^ONCO(165.5,IEN,"CS1")),U,11)=VER Q
        .S PN=$$GET1^DIQ(165.5,IEN,.02)
        .S AN=$$GET1^DIQ(165.5,IEN,.05)
        .S SEQ=$$GET1^DIQ(165.5,IEN,.06)
        .S PID=$$GET1^DIQ(165.5,IEN,61)
        .S PSCODE=$$GET1^DIQ(165.5,IEN,20.1)
        .K INPUT,STORE,DISPLAY,STATUS,ONCSAPI
        .D CLEAR^ONCSAPIE(1)
        .S INPUT("AGE")=$$AGEDX^ONCACDU1(IEN)
        .S:$L(INPUT("AGE"))=1 INPUT("AGE")="00"_INPUT("AGE")
        .S:$L(INPUT("AGE"))=2 INPUT("AGE")=0_INPUT("AGE")
        .S INPUT("BEHAV")=$E($$GET1^DIQ(165.5,IEN,22.3,"I"),5)
        .S INPUT("EXT")=$$GET1^DIQ(165.5,IEN,30.2,"I")
        .S INPUT("EXTEVAL")=$$GET1^DIQ(165.5,IEN,29.1,"I")
        .S INPUT("GRADE")=$$GET1^DIQ(165.5,IEN,24,"I")
        .S INPUT("HIST")=$E($$GET1^DIQ(165.5,IEN,22.3,"I"),1,4)
        .S INPUT("LNPOS")=$$GET1^DIQ(165.5,IEN,32,"I")
        .S:$L(INPUT("LNPOS"))=1 INPUT("LNPOS")=0_INPUT("LNPOS")
        .S INPUT("LNEXAM")=$$GET1^DIQ(165.5,IEN,33,"I")
        .S:$L(INPUT("LNEXAM"))=1 INPUT("LNEXAM")=0_INPUT("LNEXAM")
        .S INPUT("METS")=$$GET1^DIQ(165.5,IEN,34.3,"I")
        .S INPUT("METSEVAL")=$$GET1^DIQ(165.5,IEN,34.4,"I")
        .S INPUT("NODES")=$$GET1^DIQ(165.5,IEN,31.1,"I")
        .S INPUT("NODESEVAL")=$$GET1^DIQ(165.5,IEN,32.1,"I")
        .S PS=$$GET1^DIQ(165.5,IEN,20,"I")
        .S:PS'="" PS=$TR($$GET1^DIQ(164,PS,1,"I"),".","")
        .S INPUT("SITE")=PS
        .S INPUT("SIZE")=$$GET1^DIQ(165.5,IEN,29.2,"I")
        .S INPUT("SSF1")=$$GET1^DIQ(165.5,IEN,44.1,"I")
        .S INPUT("SSF2")=$$GET1^DIQ(165.5,IEN,44.2,"I")
        .S INPUT("SSF3")=$$GET1^DIQ(165.5,IEN,44.3,"I")
        .S INPUT("SSF4")=$$GET1^DIQ(165.5,IEN,44.4,"I")
        .S INPUT("SSF5")=$$GET1^DIQ(165.5,IEN,44.5,"I")
        .S INPUT("SSF6")=$$GET1^DIQ(165.5,IEN,44.6,"I")
        .S RC=$$CALC^ONCSAPI3(.ONCSAPI,.INPUT,.STORE,.DISPLAY,.STATUS)
        .D USE^%ZISUTL("ONCCSRS")
        .I $P(RC,U,1)<0 W !!?3,PID,"  ",PSCODE,"  ",AN,"/",SEQ," encountered a CS error" S ERRCTR=ERRCTR+1
        .I $P(RC,U,1)>0 W !!?3,PID,"  ",PSCODE,"  ",AN,"/",SEQ," encountered a CS warning" S ERRCTR=ERRCTR+1
        .I $P(RC,U,1)=0 S SUCCTR=SUCCTR+1 D
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,1)=STORE("T")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,2)=STORE("TDESCR")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,3)=STORE("N")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,4)=STORE("NDESCR")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,5)=STORE("M")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,6)=STORE("MDESCR")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,7)=STORE("AJCC")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,8)=STORE("SS1977")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,9)=STORE("SS2000")
        ..S $P(^ONCO(165.5,IEN,"CS1"),U,11)=$G(STATUS("APIVER"))
        ..I $P($G(^ONCO(165.5,IEN,7)),U,2)=3 D
        ...S EDITS="NO" S D0=IEN D NAACCR^ONCGENED K EDITS
        ...S CHECKSUM=$$CRC32^ONCSNACR(.ONCDST)
        ...I CHECKSUM'=$P($G(^ONCO(165.5,IEN,"EDITS")),U,1) D
        ....S $P(^ONCO(165.5,IEN,"EDITS"),U,1)=CHECKSUM
        .S CTR=CTR+1 W "."
        D RMDEV^%ZISUTL("ONCCSRS")
        ;
EXIT    W !
        S TAB=$S($L(CTR)=1:5,$L(CTR)=2:4,$L(CTR)=3:3,1:3)
        S SUCTAB=$S($L(SUCCTR)=1:5,$L(SUCCTR)=2:4,$L(SUCCTR)=3:3,1:3)
        S ERRTAB=$S($L(ERRCTR)=1:5,$L(ERRCTR)=2:4,$L(ERRCTR)=3:3,1:3)
        ;
        W:CTR=1 !?TAB,CTR," primary was re-staged using CS Version ",VERDSP
        W:CTR'=1 !?TAB,CTR," primaries were re-staged using CS Version ",VERDSP
        W !
        W:SUCCTR=1 !?SUCTAB,SUCCTR," primary was successfully restaged"
        W:SUCCTR'=1 !?SUCTAB,SUCCTR," primaries were successfully restaged"
        W:ERRCTR=1 !?ERRTAB,ERRCTR," primary encountered an error or warning"
        W:ERRCTR'=1 !?ERRTAB,ERRCTR," primaries encountered errors or warnings"
        D ^%ZISC
        W ! D PAUSE^ONCOPA2A
        Q
        ;
TASK    ;Queue a task
        K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE
        S ZTRTN="RS^ONCCSRS",ZTREQ="@",ZTSAVE("ZTREQ")=""
        S ZTDESC="ONCOTRAX Restage CS"
        D ^%ZTLOAD D CLOSE^%ZISUTL("ONCCSRS") W !,"Request Queued",!
        K ZTSK
        Q
        ;
END     Q
