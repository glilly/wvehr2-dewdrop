ZVEMSGR ;DJB,VSHL**VShell Global - ZOSF Nodes ; 12/15/00 11:49pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
ZOSF ;Load system specific code into ZOSF nodes
 NEW I,ND,TXT,VEND
 KILL ^%ZVEMS("ZOSF")
 S ^%ZVEMS("ZOSF")="System specific code"
 F I=1:1 S TXT=$T(SYS+I) Q:$P(TXT,";",3)="***"  D  ;
 . S ND=$P(TXT,";",3)
 . S VEND=$P(TXT,";",4)
 . S ^%ZVEMS("ZOSF",VEND,ND)=$P(TXT,";",5,999) ;Vendor specific code
 Q
SYS ;System specific code
 ;;EON;8;U $I:(:::::1)
 ;;EOFF;8;U $I:(::::1)
 ;;TRMON;8;U $I:(::::::::$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))
 ;;TRMOFF;8;U $I:(::::::::$C(13,27))
 ;;TRMRD;8;S Y=$ZB
 ;;EON;18;U $I:("":"-S")
 ;;EOFF;18;U $I:("":"+S")
 ;;TRMON;18;U $I:("":"+I+T")
 ;;TRMOFF;18;U $I:("":"-I-T":$C(13,27))
 ;;TRMRD;18;S Y=$A($ZB),Y=$S(Y<32:Y,Y=127:Y,1:0)
 ;;***
