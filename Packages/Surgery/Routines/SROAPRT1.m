SROAPRT1        ;BIR/MAM - PREOP INFO (PAGE 1) ;05/28/10
        ;;3.0; Surgery ;**38,47,125,153,166,174**;24 Jun 93;Build 8
        N SRX,Y F I=200,200.1,206 S SRA(I)=$G(^SRF(SRTN,I))
        S Y=$P(SRA(200),"^"),SRX=402,SRAO(1)=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(206),"^"),SRX=236,SRAO("1A")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(206),"^",2),SRX=237,SRAO("1B")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",2),SRX=346,SRAO("1C")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",3),SRX=202,SRAO("1D")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",4),SRX=246,SRAO("1E")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",6),SRX=325,SRAO("1F")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200.1),"^",8),SRX=237.1,SRAO("1G")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",7),SRX=238,SRAO("1H")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200.1),"^",2),SRX=492,SRAO("1I")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",9),SRX=241,SRAO(2)=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",10),SRX=204,SRAO("2A")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",11),SRX=203,SRAO("2B")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",12),SRX=326,SRAO("2C")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",13),SRX=244,SRAO(3)=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",15),SRX=212,SRAO("3A")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200.1),"^"),SRX=486,SRAO(4)=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",16),SRX=213,SRAO("4A")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",30),SRX=242,SRAO(5)=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",35),SRX=396,SRAO("5A")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",31),SRX=394,SRAO("5B")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",32),SRX=220,SRAO("5C")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",33),SRX=266,SRAO("5D")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",34),SRX=395,SRAO("5E")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",36),SRX=208,SRAO("5F")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",40),SRX=206,SRAO(6)=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",41),SRX=329,SRAO("6A")=$$OUT(SRX,Y)_"^"_SRX
        S Y=$P(SRA(200),"^",42),SRX=330,SRAO("6B")=$$OUT(SRX,Y)_"^"_SRX
        W:$E(IOST)="P" ! W !,?28,"PREOPERATIVE INFORMATION",!!
        W "GENERAL:",?31,$P(SRAO(1),"^"),?40,"HEPATOBILIARY:",?72,$P(SRAO(3),"^")
        W !,"Height: ",?22,$J($P(SRAO("1A"),"^"),15),?40,"Ascites:",?72,$P(SRAO("3A"),"^")
        W !,"Weight:",?22,$J($P(SRAO("1B"),"^"),15)
        W !,"Diabetes Mellitus:",?31,$P(SRAO("1C"),"^"),?40,"GASTROINTESTINAL:",?72,$P(SRAO(4),"^")
        W !,"Current Smoker W/I 1 Year:",?31,$P(SRAO("1D"),"^"),?40,"Esophageal Varices:",?72,$P(SRAO("4A"),"^")
        W !,"ETOH > 2 Drinks/Day:",?31,$P(SRAO("1E"),"^")
        W !,"Dyspnea: ",?13,$J($P(SRAO("1F"),"^"),25),?40,"CARDIAC:",?72,$P(SRAO(5),"^")
        W !,"Preop Sleep Apnea:",?30,$P(SRAO("1G"),"^"),?40,"CHF Within 1 Month:",?72,$P(SRAO("5A"),"^")
        W !,"DNR Status: ",?31,$P(SRAO("1H"),"^"),?40,"MI Within 6 Months:",?72,$P(SRAO("5B"),"^")
        W !,"Preop Funct Status: ",$J($P(SRAO("1I"),"^"),17),?40,"Previous PCI:",?72,$P(SRAO("5C"),"^")
        W !,?40,"Previous Cardiac Surgery:",?72,$P(SRAO("5D"),"^")
        W !,"PULMONARY:",?31,$P(SRAO(2),"^"),?40,"Angina Within 1 Month:",?72,$P(SRAO("5E"),"^")
        W !,"Ventilator Dependent:",?31,$P(SRAO("2A"),"^"),?40,"Hypertension Requiring Meds:",?72,$P(SRAO("5F"),"^")
        W !,"History of Severe COPD:",?31,$P(SRAO("2B"),"^")
        W !,"Current Pneumonia:",?31,$P(SRAO("2C"),"^"),?40,"VASCULAR:",?72,$P(SRAO(6),"^")
        W !,?40,"Revascularization/Amputation:",?72,$P(SRAO("6A"),"^")
        W !,?40,"Rest Pain/Gangrene:",?72,$P(SRAO("6B"),"^")
        Q
OUT(SRFLD,SRY)  ; get data in output form
        N C,Y
        S Y=SRY,C=$P(^DD(130,SRFLD,0),"^",2) D:Y'="" Y^DIQ
        I Y="NO STUDY" S Y="NS"
        I SRFLD=237.1 S Y=$E(Y,1,7)
        I SRFLD=236!(SRFLD=237)!(SRFLD=346) S Y=$E(Y,1,15)
        I SRFLD=240!(SRFLD=492) D
        .I SRY=2 S Y="PARTIAL DEPENDENT" Q
        .I SRY=4 S Y=Y_"  "
        I SRFLD=325,$L(Y)=2 S Y=Y_"     "
        Q Y
