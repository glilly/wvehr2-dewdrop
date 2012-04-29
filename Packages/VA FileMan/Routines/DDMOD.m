DDMOD ;SFISC/MKO-DD MODIFICATION APIS ;1:45 PM  11 Dec 2001
 ;;22.0;VA FileMan;**12,53,95**;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
DELIX(DIFIL,DIFLD,DIXR,DIFLG,DIKDOUT,DIKDMSG) ;Delete traditional xref
 G DELIXX^DIKD
 ;
DELIXN(DIFIL,DIXR,DIFLG,DIKDOUT,DIKDMSG) ;Delete new-style index
 G DELIXNX^DIKD2
 ;
CREIXN(DIKCXREF,DIFLG,DIXR,DIKCOUT,DIKCMSG) ;Create new-style index
 G CREIXNX^DIKCR
 ;
FILESEC(DIFIL,DISEC,DIMSGA) ;Set File Security Codes
 ; DIFIL = File Number
 ; .DISEC = Is the array for each security node
 ; DIMSGA = If passed where the error message is placed
 I (('$D(^DIC(+$G(DIFIL),0))#2)!(+$G(DIFIL)<2)) D  Q
 . D CLEAN^DILF
 . I $G(DIMSGA)'="" D BLD^DIALOG(401,+$G(DIFIL),,DIMSGA,"F") Q
 . D BLD^DIALOG(401,+$G(DIFIL))
 I '$D(DISEC) Q
 N I
 ; DIC(DIFIL,0,"DD") 'Data Dictionary' Security
 ; DIC(DIFIL,0,"RD") 'Read' Security
 ; DIC(DIFIL,0,"WR") 'Write' Security
 ; DIC(DIFIL,0,"DEL") 'Delete' Security
 ; DIC(DIFIL,0,"LAYGO") 'Laygo' Security
 ; DIC(DIFIL,0,"AUDIT") 'Audit Security
 F I="DD","RD","WR","DEL","LAYGO","AUDIT" I $D(DISEC(I))#2 S ^DIC(DIFIL,0,I)=DISEC(I)
 Q
