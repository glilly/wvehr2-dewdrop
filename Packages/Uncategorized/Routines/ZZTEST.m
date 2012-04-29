ZZTEST ;Test rouitne to show HL7 extracts from VOE DOQIT ; 8/26/05 11:27am
 ;
 Q
TEST ;
 W !,"Building extract manually",!!
 S DUZ("AG")="E",DUZ=9,DUZ(0)="@",DUZ(2)=67
 D AUTO^PXRMETX("VOE DOQ-IT CAD EXTRACTION")
 D AUTO^PXRMETX("VOE DOQ-IT DM EXTRACTION")
 D AUTO^PXRMETX("VOE DOQ-IT HF EXTRACTION")
 W !,"Extract completed"
 Q
