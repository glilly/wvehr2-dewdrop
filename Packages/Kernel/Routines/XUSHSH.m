XUSHSH ;SF-ISC/STAFF - PASSWORD ENCRYPTION ;3/23/89  15:09 ; 4/14/05 1:22pm
 ;;8.0;KERNEL;;Jul 10, 1995
 ;; This is the public domain version of the VA Kernel.
 ;; Use this routine for your own encryption algorithm
 ;; Input in X
 ;; Output in X
 ;; Algorithm for VistA Office EHR encryption (BSL)
A ;
 S X=$$EN(X)
 Q
EN(X) ; GENERIC HASHING ENCRYPTION -- USES ASCII ENCODING
 N %HASH S %HASH=""
 N %CHAR
 F %CHAR=1:1:$L(X) D
 . I %CHAR#2 S %HASH=$A(X,%CHAR)_%HASH
 . E  S %HASH=%HASH_$A(X,%CHAR)
 Q %HASH
