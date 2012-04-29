IMRCALL ;ISC-SF.SEA/JLI-CALL TO VADPT FOR IMR ROUTINES ;8/23/91  14:00
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
CALL ; get patient's demographic data.
 ; input - DFN
 ; output - VADM array
 N I,J,X,A,K,K1,NC,NF,NQ,T
 D DEM^VADPT
 Q
NS ; get patient's name and ssn
 D CALL S IMRNAM=VADM(1),IMRSSN=$P(VADM(2),U) K VA,VADM
 Q
