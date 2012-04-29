BPS10P6 ;OAK/ELZ - ENVIORNMENT CHECK FOR BPS*1*6 ;11/14/07  17:56
        ;;1.0;E CLAIMS MGMT ENGINE;**6**;JUN 2004;Build 10
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; environment check for BPS*1*6
        ; this check will make sure the post install from the previous BPS*1*5 completed
        ; if it did not complete this patch will not be installed
        ;
        I $D(^DD(9002313.992389,0)) D
        . W !,"WRITE OFF SELF PAY field of BPS SETUP file exists!!!!",!
        . W !,"You should log a Remedy ticket and contact EPS, the post install from patch"
        . W !,"BPS*1*5 did not complete, you will need to run EN1^BPS01P5 to complete the"
        . W !,"post install before you can install this patch."
        . S XPDABORT=1
        Q
        ;
