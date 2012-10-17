GMRVBMI ;HIOFO/YH,FT-EXTRACT HEIGHT TO CALCULATE BMI FOR WEIGHT; 5/8/07
        ;;5.0;GEN. MED. REC. - VITALS;**23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ; <None>
        ;
HT      ;OBTAIN ALL HEIGHTS FOR THE PATIENT
        D HT^GMVBMI
        Q
CALBMI(GBMI,GMRVDEC)    ;OBTAIN HEIGHT TO CALCULATE BMI
        ; GBMI(1)=DATE/TIME WEIGHT WAS TAKEN (Required)
        ; GBMI(2)=WEIGHT (Required)
        ; GMRVDEC = # of decimal places to return (optional)
        ;          Value can be 0, 1, 2, or 3
        ;          Default is 0
        S GMRVDEC=$G(GMRVDEC,0)
        S GMRVDEC=$S(GMRVDEC=3:3,GMRVDEC=2:2,GMRVDEC=1:1,1:0)
        D CALBMI^GMVBMI(.GBMI,GMRVDEC)
        Q
