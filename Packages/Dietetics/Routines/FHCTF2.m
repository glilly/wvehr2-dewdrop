FHCTF2  ; HISC/REL - Tickler File Utilities ;4/26/91  12:12
        ;;5.5;DIETETICS;**20**;Jan 28, 2005;Build 7
FILE    ; File Entry
        S %=$P(FHTF,"^",1) I $D(^FH(119,FHDUZ,"I")) G F1
        I '$D(^FH(119,FHDUZ)) S ^FH(119,FHDUZ,0)=FHDUZ,^FH(119,"B",FHDUZ,FHDUZ)=""
        S ^FH(119,FHDUZ,"I",0)="^119.01D^0^0"
        L +^FH(119,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) S FH3=$P(^FH(119,0),"^",3),FH4=$P(^FH(119,0),"^",4)
        I FHDUZ>FH3 S FH3=FHDUZ
        S FH4=FH4+1
        S $P(^FH(119,0),"^",3)=FH3,$P(^FH(119,0),"^",4)=FH4
        L -^FH(119,0)
F1      I $D(^FH(119,FHDUZ,"I",%)) S %=%+.000001 G F1
        S ^FH(119,FHDUZ,"I",%,0)=FHTF K %,FHTF Q
