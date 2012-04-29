LA7VHLU4        ;DALOI/JMC - HL7 segment builder utility ; 09/12/10
        ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,250005**;Sep 27, 1994;Build 3
        ;
        ; Reference to ^XMB global supported by DBIA #10091
        ;
        ; WV/JMC 12 Sep 2010 - PLTFM - added code to check "C" index on file #44 lookup
        ;
        ;
INST(LA74,LA7FS,LA7ECH) ; Build institution field
        ; Call with   LA74 = ien of institution in file #4
        ;                    if null/undefined then use Kernel Site file.
        ;            LA7FS = HL field separator
        ;           LA7ECH = HL encoding characters
        ;
        ; Returns facility that performed the testing (ID^text^99VA4)
        ;
        N LA7NVAF,LA7X,LA7Y,LA7Z
        ;
        S LA74=$G(LA74),LA7ECH=$G(LA7ECH),LA7Y=""
        ;
        ; If no institution, use Kernel Site default
        I LA74="" S LA74=+$P($G(^XMB(1,1,"XUS")),U,17)
        ;
        ; Value passed not a pointer - only build 2nd component
        I LA74'="",LA74'=+LA74 D
        . S $P(LA7Y,$E(LA7ECH,1),2)=$$CHKDATA^LA7VHLU3(LA74,LA7FS_LA7ECH)
        ;
        I LA74>0,LA74=+LA74 D
        . S LA7NVAF=$$NVAF^LA7VHLU2(LA74)
        . ; Build id - VA station #/DMIS code
        . I LA7NVAF<2 S LA7Y=$$ID^XUAF4($S(LA7NVAF=1:"DMIS",1:"VASTANUM"),LA74)
        . ; Build name using field #100, otherwise #.01
        . S LA7Z=$$NAME^XUAF4(LA74)
        . S $P(LA7Y,$E(LA7ECH,1),2)=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
        . ;
        . S $P(LA7Y,$E(LA7ECH,1),3)="99VA4"
        ;
        Q LA7Y
        ;
XCN(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build composite ID and name for person
        ; Call with   LA7DUZ = DUZ of person
        ;                      If not pointer to #200, then use as literal
        ;             LA7DIV = Institution of user
        ;              LA7FS = HL field separator
        ;             LA7ECH = HL encoding characters
        ;
        ;
        N LA7SITE,LA7VAF,LA7X,LA7Y,LA7Z,NAME
        ;
        S LA7Z=""
        ;
        ; Build from file #200
        I LA7DUZ>0,LA7DUZ?1.N D
        . S NAME("FILE")=200,NAME("FIELD")=.01,NAME("IENS")=LA7DUZ
        . S LA7Z=$$HLNAME^XLFNAME(.NAME,"S",$E(LA7ECH))
        . ; Commented out following lines, trying standardized name API above
        . ;S LA7X=$$GET1^DIQ(200,LA7DUZ_",",.01)
        . ;S LA7X=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH)
        . ;S LA7Z=$$HLNAME^HLFNC(LA7X,LA7ECH)
        . ; If no institution, use Kernel Site default
        . I LA7DIV="" S LA7DIV=+$P($G(^XMB(1,1,"XUS")),U,17)
        . S LA7SITE=$$RETFACID^LA7VHLU2(LA7DIV,0,1)
        . I $L(LA7SITE) D
        . . S LA7VAF=$$GET1^DIQ(4,LA7DIV_",","AGENCY CODE","I")
        . . I LA7VAF="V" S LA7SITE="VA"_LA7SITE
        . . S LA7DUZ=LA7DUZ_"-"_LA7SITE
        . S $P(LA7Y,$E(LA7ECH))=LA7DUZ
        ;
        ; If only name passed
        I 'LA7DUZ D
        . S LA7DUZ=$$CHKDATA^LA7VHLU3(LA7DUZ,LA7FS_LA7ECH)
        . S LA7Z=$$HLNAME^HLFNC(LA7DUZ,LA7ECH)
        ;
        S $P(LA7Y,$E(LA7ECH),2,7)=LA7Z
        ;
        Q LA7Y
        ;
        ;
XAD(LA7FN,LA7DA,LA7DT,LA7FS,LA7ECH)     ; Build extended address
        ; Call with LA7FN = Source File number
        ;                   Presently file #2 (PATIENT), #4 (INSTITUTION) or #200 (NEW PERSON)
        ;           LA7DA = Entry in source file
        ;           LA7DT = As of date in FileMan format
        ;           LA7FS = HL field separator
        ;          LA7ECH = HL encoding characters
        ;
        ; Returns extended address
        ;
        N LA7X,LA7Y,LA7Z
        ;
        S LA7Y=""
        ;
        ; Build from file #2
        I LA7FN=2,LA7DA D
        . N DFN,VAHOW,VAPA,VAERR,VAROOT,VATEST
        . S DFN=LA7DA
        . I LA7DT S (VATEST("ADD",9),VATEST("ADD",10))=LA7DT
        . D ADD^VADPT
        . I VAERR Q
        . S $P(LA7Y,$E(LA7ECH),1)=$$CHKDATA^LA7VHLU3(VAPA(1),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH),2)=$$CHKDATA^LA7VHLU3(VAPA(2),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH),3)=$$CHKDATA^LA7VHLU3(VAPA(4),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH),4)=$$CHKDATA^LA7VHLU3($P(VAPA(5),"^",2),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH),5)=$$CHKDATA^LA7VHLU3(VAPA(11),LA7FS_LA7ECH)
        . I VAPA(9) S $P(LA7Y,$E(LA7ECH),7)="C"
        . E  S $P(LA7Y,$E(LA7ECH),7)="P"
        . S $P(LA7Y,$E(LA7ECH),9)=$$CHKDATA^LA7VHLU3($P(VAPA(7),"^",2),LA7FS_LA7ECH)
        ;
        I LA7FN=4,LA7DA D
        . Q
        ;
        I LA7FN=200,LA7DA D
        . Q
        ;
        Q LA7Y
        ;
        ;
XON(LA7FN,LA7DA,LA7FS,LA7ECH)   ; Build extended composite name/id for organization
        ; Call with LA7FN = Source File number
        ;                   Presently #4 (INSTITUTION)
        ;           LA7DA = Entry in source file
        ;           LA7FS = HL field separator
        ;          LA7ECH = HL encoding characters
        ;
        ;
        N LA7X,LA7Y,LA7Z
        ;
        S LA7Y=""
        ;
        I LA7FN=4,LA7DA D
        . Q
        ;
        Q LA7Y
        ;
        ;
XTN(LA7FN,LA7DA,LA7FS,LA7ECH)   ; Build extended telecommunication number
        ; Call with LA7FN = Source File number
        ;                   Presently #4 (INSTITUTION)
        ;           LA7DA = Entry in source file
        ;           LA7FS = HL field separator
        ;          LA7ECH = HL encoding characters
        ;
        ;
        N LA7X,LA7Y,LA7Z
        ;
        S LA7Y=""
        ;
        I LA7FN=4,LA7DA D
        . Q
        ;
        Q LA7Y
        ;
        ;
XCNTFM(LA7X,LA7ECH)     ; Resolve XCN data type to FileMan (last name, first name, mi [id])
        ; Call with LA7X = HL7 field containing name
        ;         LA7ECH = HL7 encoding characters
        ;
        ; Returns   LA7Y = ID code^DUZ^FileMan name (DUZ=0 if name not found on local system).
        ;
        N LA7DUZ,LA7IDC,LA7Y,LA7Z,X
        ;
        ; Check for coding that indicates DUZ from a VA facility
        S LA7DUZ=0
        S (LA7IDC,LA7Z)=$P(LA7X,$E(LA7ECH))
        I LA7Z?.(1.N1"-VA"3N,1.N1"-VA"3N2U) D
        . N LA7J,LA7K
        . S LA7Z(1)=$P(LA7Z,"-"),LA7Z(2)=$P(LA7Z,"-",2)
        . S LA7K=$$FINDSITE^LA7VHLU2(LA7Z(2),1,1)
        . S LA7J=$$DIV4^XUSER(.LA7J,LA7Z(1))
        . I LA7K,$D(LA7J(LA7K)) S LA7DUZ=LA7Z(1)
        ;
        ; Check if code resolves to a valid user.
        I 'LA7DUZ,LA7Z=+LA7Z D
        . S X=$$ACTIVE^XUSER(LA7Z)
        . I X,$P(X,"^",2)'="" S LA7DUZ=LA7Z
        ;
        S LA7Y=$$FMNAME^HLFNC($P(LA7X,$E(LA7ECH),2,6),LA7ECH)
        ; HL function sometimes returns trailing "," on name
        S LA7Y=$$TRIM^XLFSTR(LA7Y,"R",",")
        ;
        ; Put identifying code at end of name in "[]".
        I $P(LA7X,$E(LA7ECH))'="",LA7Y'="" S LA7Y=LA7Y_" ["_$P(LA7X,$E(LA7ECH))_"]"
        ;
        Q LA7IDC_"^"_LA7DUZ_"^"_LA7Y
        ;
        ;
PLTFM(LA7PL,LA7ECH)     ; Resolve location from PL (person location) data type.
        ; Call with LA7PL = HL7 field containing person location
        ;          LA7ECH = HL7 encoding characters
        ;
        ; Returns    LA7Y = file #44 ien^name field (#.01)^division(institution)
        ;
        N LA7X,LA7Y,X,Y
        S LA7X=$P(LA7PL,$E(LA7ECH)),(LA7Y,Y)=""
        I LA7X?1.N S Y=$$GET1^DIQ(44,LA7X_",",.01)
        ; If not ien try as name
        I Y="" D
        . S X=$$FIND1^DIC(44,"","X",LA7X,"B^C")
        . I X S Y=LA7X,LA7X=X
        I Y'="" S LA7Y=LA7X_"^"_Y
        E  I $P(LA7PL,$E(LA7ECH),2)'="" S LA7Y="^"_$P(LA7PL,$E(LA7ECH),2)
        ;
        ; Process division (institution)
        S LA7X=$P(LA7PL,$E(LA7ECH),4),Y=""
        I LA7X'="" S Y=$$FINDSITE^LA7VHLU2(LA7X,1,1)
        S $P(LA7Y,"^",3)=Y
        ;
        Q LA7Y
