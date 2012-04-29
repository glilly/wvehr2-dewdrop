DBARO ; Routine Method for Standard Extraction of Routines ;9/23/06  14:10
 N EXIT,ODIR,OFN,RTN
 I '$D(DTIME) N DTIME S DTIME=300
 ; Routine Selector
 X ^%ZOSF("RSEL")
 ;Output in ^UTILITY($J,rtn)
 S RTN=$O(^UTILITY($J,9)),EXIT=0  ;
 D:$L(RTN)
 . F  D IFILE  Q:$L($G(IO))
 . D:$L($G(IO))&('EXIT)
 . . U $P
 . . W !,"Enter a Comment for the Routine Set.",!
 . . R ">>",COM:DTIME,!
 . . I '$T!($E(ODIR)="^") S EXIT=1 Q
 . . ;
 . . U IO
 . . W COM,!,$$HTE^XLFDT($H),!
 . . D RGET
 . . U $P
 . .QUIT
 .QUIT
 QUIT
 ;  ==============
IFILE ; Prompt and accept the Directory and File Combination
 N X
 W !,"Enter a valid directory path and file name for the receiving file"
 W !,"  enter '?' for Help, or '^' to exit now."
 W !,"  such as: /tmp/  and OUTRTNS.RO",!
 R !,"Directory > ",ODIR:DTIME,!
 I ('$T)!($E(ODIR)="^") S EXIT=1 Q
 R !,"Output File > ",OFNM:DTIME,!
 I ('$T)!($E(OFNM)="^") S EXIT=1 Q
 D OPEN^%ZISH("",ODIR,OFNM,"W")  U $P
 QUIT
 ;  ==============
RGET ; The file and the list of routines has been selected,
 ;   now go load the File.
 N XCNP,DIF,TMP,X,I,L,S,V
 I '$D(IORM) N IORM S IORM=255
 S S=$J("",12)
 ; RTN already has the first name.
 F  D  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""
 . K TMP S XCNP=0,DIF="TMP(",X=RTN X ^%ZOSF("LOAD")
 . U IO W RTN,!
 . F I=1:1:XCNP-1 W TMP(I,0),!
 . W !
 . U $P W:(($X+10)>80) ! W $E(RTN_S,1,10)
 . Q
 U IO
 W !!
 F I=1:1:5 W "#########",!
 I IOT="HFS" D ^%ZISC
 QUIT
 ;  ==============
