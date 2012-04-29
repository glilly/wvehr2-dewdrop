ORHLESC ;SLC/JMH - HL7 UTILITY ;11:26 AM  2 Apr 2001
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
        ; VAL = COMPONENT_REPETITION_ESCAPE_SUBCOMPONENT_FIELD
        ;
ESC(ORSTR,VAL)  ; REPLACE HL7 DELIMITER CHAR
        N SEPC,SEPR,SEPS,SEPF,SEPE,REPSEPC,REPSEPR,REPSEPS,REPSEPF,REPSEPE,I,HL7DEL
        I '$L($G(VAL)) S VAL="~|\&^"
        I $G(ORSTR)="" Q ""
        I $TR(ORSTR,$G(VAL))=ORSTR Q ORSTR
        N X,Y,Z,RES
        S SEPE=$E(VAL,3),REPSEPE=SEPE_"E"_SEPE
        S SEPC=$E(VAL,1),REPSEPC=SEPE_"S"_SEPE
        S SEPR=$E(VAL,2),REPSEPR=SEPE_"R"_SEPE
        S SEPS=$E(VAL,4),REPSEPS=SEPE_"T"_SEPE
        S SEPF=$E(VAL,5),REPSEPF=SEPE_"F"_SEPE
        S RES=ORSTR
        I $F(ORSTR,SEPE) S X=RES D
        . S Z=$P(X,SEPE,2,9999),Y=$P(X,SEPE)_REPSEPE_Z,RES=Y,X=Z I '$F(Z,SEPE) Q
        . F I=2:1 S Z=$P(X,SEPE,2,9999),Y=$P(RES,REPSEPE,1,I-1)_REPSEPE_$P(X,SEPE)_REPSEPE_Z,RES=Y,X=Z I '$F(Z,SEPE) Q
        ;
        I $F(RES,SEPC) F I=1:1 S Y=$P(RES,SEPC)_REPSEPC_$P(RES,SEPC,2,9999),RES=Y I '$F(RES,SEPC) Q
        I $F(RES,SEPR) F I=1:1 S Y=$P(RES,SEPR)_REPSEPR_$P(RES,SEPR,2,9999),RES=Y I '$F(RES,SEPR) Q
        I $F(RES,SEPS) F I=1:1 S Y=$P(RES,SEPS)_REPSEPS_$P(RES,SEPS,2,9999),RES=Y I '$F(RES,SEPS) Q
        I $F(RES,SEPF) F I=1:1 S Y=$P(RES,SEPF)_REPSEPF_$P(RES,SEPF,2,9999),RES=Y I '$F(RES,SEPF) Q
        Q RES
UNESC(ORSTR,VAL)        ;
        ; Remove Escape Characters from HL7 Message Text
        ; Escape Sequence codes:
        ;         F = field separator (ORFS)
        ;         S = component separator (ORCS)
        ;         R = repetition separator (ORRS)
        ;         E = escape character (ORES)
        ;         T = subcomponent separator (ORSS)
        N ORFS,ORCS,ORRS,ORES,ORSS
        I '$L($G(VAL)) S VAL="~|\&^"
        S ORFS=$E(VAL,5)
        S ORCS=$E(VAL,1)
        S ORRS=$E(VAL,2)
        S ORES=$E(VAL,3)
        S ORSS=$E(VAL,4)
        N ORCHR,ORREP,I1,I2,J1,J2,K,VALUE
        F ORCHR="F","S","R","E","T" S ORREP(ORES_ORCHR_ORES)=$S(ORCHR="F":ORFS,ORCHR="S":ORCS,ORCHR="R":ORRS,ORCHR="E":ORES,ORCHR="T":ORSS)
        S ORSTR=$$REPLACE^XLFSTR(ORSTR,.ORREP)
        F  S I1=$P(ORSTR,ORES_"X") Q:$L(I1)=$L(ORSTR)  D
        .S I2=$P(ORSTR,ORES_"X",2,99)
        .S J1=$P(I2,ORES) Q:'$L(J1)
        .S J2=$P(I2,ORES,2,99)
        .S VALUE=$$BASE^XLFUTL($$UP^XLFSTR(J1),16,10)
        .S K=$S(VALUE>255:"?",VALUE<32!(VALUE>127&(VALUE<160)):"",1:$C(VALUE))
        .S ORSTR=I1_K_J2
        Q ORSTR
REPLACE(X,Y,Z)  ;
        ; X is initial string
        ; Y is string to be replaced
        ; Z is string to replace
        N RET
        I X'[Y Q X
        S I=1,RET=$P(X,Y) F  S I=I+1,RET=RET_Z_$P(X,Y,I) Q:I=$L(X,Y)
        Q RET
