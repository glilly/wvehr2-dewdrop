IMRKIDS1 ;HCIOFO/SG - ERROR MESSAGES ; 6/5/02 9:43am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**18**;Feb 09, 1998
 ;
 Q
 ;
 ;***** RETURNS TEXT OF THE MESSAGE
 ;
 ; ERRCODE       Error code
 ; [.TYPE]       Type of the error
 ; [ARG1-ARG5]   Optional parameters that substitute the |n| "windows"
 ;               in the text of the message (for example, the |2| will
 ;               be substituted by the value of the ARG2).
 ;
MSG(ERRCODE,TYPE,ARG1,ARG2,ARG3,ARG4,ARG5) ;
 S TYPE=6  Q:ERRCODE'<0 ""
 N ARG,I1,I2,MSG
 ;--- Get a descriptor of the message
 S I1=-ERRCODE,MSG=$P($T(MSGLIST+I1),";;",2)
 S I1=+$TR($P(MSG,U,2)," "),MSG=$P(MSG,U,3,999)
 S:I1>0 TYPE=I1
 Q:MSG?." " "Unknown error ("_ERRCODE_")"
 ;--- Substitute parameters
 S I1=2
 F  S I1=$F(MSG,"|",I1-1)  Q:'I1  D
 . S I2=$F(MSG,"|",I1)  Q:'I2
 . X "S ARG=$G(ARG"_+$TR($E(MSG,I1,I2-2)," ")_")"
 . S $E(MSG,I1-1,I2-1)=ARG
 Q $$TRIM^XLFSTR(MSG)
 ;
 ;***** RETURNS TYPE OF THE MESSAGE
 ;
 ; ERRCODE       Error code
 ;
TYPE(ERRCODE) ;
 Q:ERRCODE'<0 0
 N I,TYPE  S I=-ERRCODE
 S I=$P($T(MSGLIST+I),";;",2),TYPE=+$TR($P(I,U,2)," ")
 Q $S(TYPE>0:TYPE,1:6)
 ;
 ;***** LIST OF THE MESSAGES (THERE SHOULD BE NOTHING AFTER THE LIST!)
 ;
 ; The error codes are provided in the table only for clarity.
 ; Text of the messages are extracted using the $TEXT function and
 ; absolute values of the ERRCODE parameter.
 ;
 ; Message Type:
 ;               1  Debug          4  Warning
 ;               2  Information    5  Database Error
 ;               3  Data Quality   6  Error
 ;
MSGLIST ; Code Type  Message Text
 ;;  -1 ^ 1 ^ User entered the "^"
 ;;  -2 ^ 6 ^ Timeout
 ;;  -3 ^ 6 ^ Cannot create the '|2|' checkpoint!
 ;;  -4 ^ 6 ^ Cannot complete the '|2|' checkpoint!
 ;;  -5 ^ 6 ^ Undefined variable: '|2|'
 ;;  -6 ^ 6 ^ Error during the |2|. See log files.
 ;;  -7 ^ 6 ^ Error code '|2|' is returned by the '|3|'
 ;;  -8 ^ 3 ^ Error code '|2|' is returned by the '|3|'
 ;;  -9 ^ 5 ^ FileMan DBS call error(s)|2|
 ;; -10 ^ 6 ^ Cannot lock the record(s) of |2|
 ;; -11 ^ 6 ^ Error(s) during processing of the patient data
 ;; -12 ^ 4 ^ Task has been interrupted by user
