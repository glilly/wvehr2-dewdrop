PSSMRTUP        ;BIR/RTR-Process Standard Medication Route File Updates ;03/02/09
        ;;1.0;PHARMACY DATA MANAGEMENT;**147**;9/30/97;Build 16
        ;
        ;Reference to TMP("XUMF EVENT" supported by DBIA 5470
EN      ;
        I '$D(^TMP("XUMF EVENT",$J,51.23)) Q
        ;We are assuming the name of the .01 field will not change
        K ^TMP($J,"PSSMRPTX") K ^TMP($J,"PSSMRPCC") K ^TMP($J,"PSSMRUN")
        N PSSMRPCT
        S PSSMRPCT=1
        D NWRT
        D STCH
        D INACZ^PSSMRTUX
        D LOCALS
        D MAIL K ^TMP($J,"PSSMRPCC") K ^TMP($J,"PSSMRUN") K ^TMP($J,"PSSMRPTX")
        Q
        ;
        ;
MAIL    ;
        N XMTEXT,XMY,XMSUB,XMDUZ,XMMG,XMSTRIP,XMROU,XMYBLOB,XMZ,XMDUN
        I '$D(^TMP($J,"PSSMRPTX")) Q
        S XMSUB="Standard Medication Route File Update"
        S XMDUZ="Standard Medication Route File Processor"
        S XMTEXT="^TMP($J,""PSSMRPTX"","
        S XMY("G.PSS ORDER CHECKS")=""
        N DIFROM D ^XMD
        ;K ^TMP($J,"PSSMRPTX")
        Q
        ;
        ;
STAT(PSSMRPEN)  ;Return status of entry, assuming .01 and File 51.23
        I $P($$GETSTAT^XTID(51.23,.01,PSSMRPEN_","),"^")=1 Q 1
        Q 0
        ;
        ;
NWRT    ;New Medication Routes
        N PSSMRPL,PSSMRPLN,PSSMRPL1,PSSMRPST S PSSMRPL1=0
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries have been added to the Standard Medication Routes",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="(#51.23) File:",PSSMRPCT=PSSMRPCT+1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        F PSSMRPL=0:0 S PSSMRPL=$O(^TMP("XUMF EVENT",$J,51.23,"NEW",PSSMRPL)) Q:'PSSMRPL  D
        .S PSSMRPLN=$G(^PS(51.23,PSSMRPL,0)) I PSSMRPLN="" Q
        .S PSSMRPL1=1,PSSMRPST=$$STAT(PSSMRPL)
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P(PSSMRPLN,"^")_$S('PSSMRPST:"   (Inactive)",1:"") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     FDB Route: "_$S($P(PSSMRPLN,"^",2)'="":$P(PSSMRPLN,"^",2),1:"(None)") S PSSMRPCT=PSSMRPCT+1
        I 'PSSMRPL1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)" S PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
        Q
        ;
        ;
STCH    ;Status changes
        ;Sets PSSMRPCC TMP global, which holds inactivated and reactivated entries
        ;If 0.1 changes, which it should not, we are just showing the 'after' value
        N PSSMRPBB,PSSMRPDD,PSSMRPEE,PSSMRPFF,PSSMRPGG,PSSMRPXX,PSSMRPZZ,PSSMRPLL,PSSMRPZA,PSSMRPZB
        S PSSMRPFF=0
        F PSSMRPLL=0:0 S PSSMRPLL=$O(^TMP("XUMF EVENT",$J,51.23,"STATUS",PSSMRPLL)) Q:'PSSMRPLL  D
        .S PSSMRPBB=$G(^TMP("XUMF EVENT",$J,51.23,"STATUS",PSSMRPLL))
        .I PSSMRPBB="" Q
        .I $P(PSSMRPBB,"^",3)'=0,$P(PSSMRPBB,"^",3)'=1 Q
        .S PSSMRPZA=$$RPLCMNT^XTIDTRM(51.23,PSSMRPLL) S PSSMRPZB=$P(PSSMRPZA,";") S ^TMP($J,"PSSMRPCC",$S($P(PSSMRPBB,"^",3)=0:"INACT",1:"REACT"),PSSMRPLL)=$S('PSSMRPZB:0,PSSMRPZB=PSSMRPLL:0,1:PSSMRPZB)
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries have been inactivated in the Standard Medication",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="Routes (#51.23) File:",PSSMRPCT=PSSMRPCT+1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        K PSSMRPLL
        F PSSMRPLL=0:0 S PSSMRPLL=$O(^TMP($J,"PSSMRPCC","INACT",PSSMRPLL)) Q:'PSSMRPLL  D
        .S PSSMRPXX=+PSSMRPLL_"," I '$$SCREEN^XTID(51.23,.01,PSSMRPXX) K ^TMP($J,"PSSMRPCC","INACT",PSSMRPLL) Q
        .S PSSMRPFF=1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.23,+PSSMRPLL,0)),"^") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     FDB Route: "_$S($P($G(^PS(51.23,+PSSMRPLL,0)),"^",2)'="":$P($G(^PS(51.23,+PSSMRPLL,0)),"^",2),1:"(None)") S PSSMRPCT=PSSMRPCT+1
        .S PSSMRPDD=$G(^TMP($J,"PSSMRPCC","INACT",PSSMRPLL))
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Replacement Term: "_$S(+$G(PSSMRPDD):$P($G(^PS(51.23,+PSSMRPDD,0)),"^"),1:"(None)") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Replacement Term FDB Route: "_$S('$G(PSSMRPDD):"(None)",$P($G(^PS(51.23,+PSSMRPDD,0)),"^",2)'="":$P($G(^PS(51.23,+PSSMRPDD,0)),"^",2),1:"(None)") S PSSMRPCT=PSSMRPCT+1
        I 'PSSMRPFF S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
        S PSSMRPGG=0
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries have been reactivated in the Standard Medication",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="Routes (#51.23) File:",PSSMRPCT=PSSMRPCT+1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        F PSSMRPEE=0:0 S PSSMRPEE=$O(^TMP($J,"PSSMRPCC","REACT",PSSMRPEE)) Q:'PSSMRPEE  D
        .S PSSMRPZZ=+PSSMRPEE_"," I $$SCREEN^XTID(51.23,.01,PSSMRPZZ) K ^TMP($J,"PSSMRPCC","REACT",PSSMRPEE) Q
        .S PSSMRPGG=1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.23,+PSSMRPEE,0)),"^") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     FDB Route: "_$S($P($G(^PS(51.23,+PSSMRPEE,0)),"^",2)'="":$P($G(^PS(51.23,+PSSMRPEE,0)),"^",2),1:"(None)") S PSSMRPCT=PSSMRPCT+1
        I 'PSSMRPGG S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
        Q
        ;
        ;
LOCALS  ;
        ;Loop through 51.2, call INCT to see if entry is in INACT Global, if so, then unmap local entry, then Remap if there is a replacement entry
        ;Then if local entry is still unmapped, execute standard Med Route mapping logic
        ;INCT and SET will set the PSSMRUN TMP global as follows, where piece 1 one = 1 for Mapped/Remapped, or = 0 for unmapped
        ;TMP($J,"PSSMRUN",Lock variable,51.2 IEN)=0 or 1^Old Mapped Name^New Mapped Name
        D REMAP
        Q
        ;
        ;
REMAP   ;Attempt to remap any unmapped local medication routes
        N PSSRTIEN,PSSRTNAM,PSSRTSTS,PSSRTIX,PSSRTLOC,PSSRTLOP,PSSRTLOX,PSSRTSHL
        S PSSRTIX="" F  S PSSRTIX=$O(^PS(51.2,"B",PSSRTIX)) Q:PSSRTIX=""  D
        .F PSSRTIEN=0:0 S PSSRTIEN=$O(^PS(51.2,"B",PSSRTIX,PSSRTIEN)) Q:'PSSRTIEN  D
        ..I '$D(^PS(51.2,PSSRTIEN,0)) Q
        ..;I '$P($G(^PS(51.2,PSSRTIEN,0)),"^",4) Q
        ..S PSSRTLOC=0 L +^PS(51.2,PSSRTIEN):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I '$T S PSSRTLOC=1
        ..;Continue if record is locked, just do not set any data
        ..D INCT I $P($G(^PS(51.2,PSSRTIEN,1)),"^"),'$D(^TMP($J,"PSSMRPCC","INACT",+$P($G(^PS(51.2,PSSRTIEN,1)),"^"))) D UN Q
        ..K PSSRTNAM,PSSRTSTS I '$P($G(^PS(51.2,PSSRTIEN,0)),"^",4) D UN Q
        ..S PSSRTNAM=$P($G(^PS(51.2,PSSRTIEN,0)),"^") S PSSRTNAM=$$UP^XLFSTR(PSSRTNAM)
        ..S PSSRTSTS=$O(^PS(51.23,"B",PSSRTNAM,0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ..K PSSRTSTS,PSSRTSHL S PSSRTLOX=0 F PSSRTLOP=0:0 S PSSRTLOP=$O(^PS(51.23,"C",PSSRTNAM,PSSRTLOP)) Q:'PSSRTLOP  S PSSRTSTS=PSSRTLOP I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") S PSSRTLOX=PSSRTLOX+1 S PSSRTSHL=PSSRTSTS
        ..I PSSRTLOX=1 S PSSRTSTS=PSSRTSHL D SET D UN Q
        ..K PSSRTSTS I PSSRTNAM[" EAR" S PSSRTSTS=$O(^PS(51.23,"B","OTIC",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ..K PSSRTSTS I PSSRTNAM[" EYE" S PSSRTSTS=$O(^PS(51.23,"B","OPHTHALMIC",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ..K PSSRTSTS I PSSRTNAM="G TUBE"!(PSSRTNAM="G-TUBE")!(PSSRTNAM="J TUBE")!(PSSRTNAM="J-TUBE")!(PSSRTNAM="NG TUBE")!(PSSRTNAM="NG-TUBE") D  I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ...S PSSRTSTS=$O(^PS(51.23,"B","ENTERAL",0))
        ..K PSSRTSTS I PSSRTNAM="BY MOUTH" S PSSRTSTS=$O(^PS(51.23,"B","ORAL",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ..K PSSRTSTS I PSSRTNAM["NOSE"!(PSSRTNAM["NASAL")!(PSSRTNAM["NOSTRIL") S PSSRTSTS=$O(^PS(51.23,"B","NASAL",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ..K PSSRTSTS I PSSRTNAM="IVPB"!(PSSRTNAM="IV PUSH")!(PSSRTNAM="IV PIGGYBACK") S PSSRTSTS=$O(^PS(51.23,"B","INTRAVENOUS",0)) I PSSRTSTS,'$$SCREEN^XTID(51.23,.01,PSSRTSTS_",") D SET D UN Q
        ..D UN
        D FINAL
        Q
        ;
        ;
UN      ;Unlock Med Route
        I PSSRTLOC Q
        L -^PS(51.2,PSSRTIEN)
        Q
        ;
        ;
SET     ;Set Data, leaving USER as null, so the installer is not recorded as the user
        I '$D(^TMP($J,"PSSMRUN",$S(PSSRTLOC:"PSSLCK",1:"PSSUNLCK"),PSSRTIEN)) S ^TMP($J,"PSSMRUN",$S(PSSRTLOC:"PSSLCK",1:"PSSUNLCK"),PSSRTIEN)=1_"^^"_$P($G(^PS(51.23,PSSRTSTS,0)),"^") D OLDNM G SETPS
        S $P(^TMP($J,"PSSMRUN",$S(PSSRTLOC:"PSSLCK",1:"PSSUNLCK"),PSSRTIEN),"^",3)=$P($G(^PS(51.23,PSSRTSTS,0)),"^"),$P(^TMP($J,"PSSMRUN",$S(PSSRTLOC:"PSSLCK",1:"PSSUNLCK"),PSSRTIEN),"^")=1 D OLDNM
SETPS   I PSSRTLOC Q
        N %,PSSHASHP,X,%H,%I,PSSHASHZ,PSSHASHO
        K PSSHASHP,PSSHASHZ,PSSHASHO S PSSHASHO=$S($P($G(^PS(51.2,PSSRTIEN,1)),"^"):$P($G(^PS(51.2,PSSRTIEN,1)),"^"),1:"")
        S $P(^PS(51.2,PSSRTIEN,1),"^")=PSSRTSTS
        D NOW^%DTC S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",.01)=%
        S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",1)=""
        S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",2)=PSSHASHO
        S PSSHASHP(51.27,"+1,"_PSSRTIEN_",",3)=PSSRTSTS
        D UPDATE^DIE("","PSSHASHP",,"PSSHASHZ")
        Q
        ;
        ;
SETNW(PSSMRPQX,PSSMRPQZ)        ;
        ;Called from Replaced with term logic
        N %,PSSMRPQA,X,%H,%I,PSSMRPQB
        K PSSMRPQA,PSSMRPQB
        S $P(^PS(51.2,PSSRTIEN,1),"^")=PSSMRPQZ
        D NOW^%DTC S PSSMRPQA(51.27,"+1,"_PSSRTIEN_",",.01)=%
        S PSSMRPQA(51.27,"+1,"_PSSRTIEN_",",1)=""
        S PSSMRPQA(51.27,"+1,"_PSSRTIEN_",",2)=PSSMRPQX
        S PSSMRPQA(51.27,"+1,"_PSSRTIEN_",",3)=PSSMRPQZ
        D UPDATE^DIE("","PSSMRPQA",,"PSSMRPQB")
        Q
        ;
        ;
INCT    ;Check Inactivation global
        N PSSMRPJ6,PSSMRPJ7,PSSMRPJ8,PSSMRPOL,PSSMRPNW
        S PSSMRPJ6=$P($G(^PS(51.2,PSSRTIEN,1)),"^") Q:'PSSMRPJ6
        I '$D(^TMP($J,"PSSMRPCC","INACT",PSSMRPJ6)) Q
        ;Assuming .01 cannot change, if it does, would need old name from 51.23, and need to set piece 2 of INACT global above
        S PSSMRPOL=$P($G(^PS(51.23,+$G(PSSMRPJ6),0)),"^")
        S PSSMRPJ7=$P($G(^TMP($J,"PSSMRPCC","INACT",PSSMRPJ6)),"^")
        S PSSMRPJ8=$S('$G(PSSMRPJ7):"",'$D(^PS(51.23,+PSSMRPJ7,0)):"",1:+PSSMRPJ7)
        I PSSMRPJ8,$$SCREEN^XTID(51.23,.01,PSSMRPJ8_",") S PSSMRPJ8=""
        ;Still assuming .01 can't change, if so, need new name from 51.23 
        S PSSMRPNW=$S(+$G(PSSMRPJ8):$P($G(^PS(51.23,+$G(PSSMRPJ8),0)),"^"),1:"")
        I 'PSSRTLOC D SETNW(PSSMRPJ6,PSSMRPJ8)
        S ^TMP($J,"PSSMRUN",$S(PSSRTLOC:"PSSLCK",1:"PSSUNLCK"),PSSRTIEN)=$S('PSSMRPJ8:0_"^"_$G(PSSMRPOL),1:1_"^"_$G(PSSMRPOL)_"^"_$G(PSSMRPNW))
        Q
        ;
        ;
FINAL   ;
        ;Sets Local mapped and remapped sections of the mail message
        N PSSMRPP1,PSSMRPP2,PSSMRPP3,PSSMRPP4,PSSMRPP5
        S PSSMRPP5=0
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries in the Medication Routes (#51.2) File have been",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="mapped/remapped to a Standard Medication Route (#51.23) File entry.",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        F PSSMRPP1=0:0 S PSSMRPP1=$O(^TMP($J,"PSSMRUN","PSSUNLCK",PSSMRPP1)) Q:'PSSMRPP1  D
        .I '$P($G(^TMP($J,"PSSMRUN","PSSUNLCK",PSSMRPP1)),"^") Q
        .S PSSMRPP5=1
        .S PSSMRPP2=$G(^TMP($J,"PSSMRUN","PSSUNLCK",PSSMRPP1))
        .S PSSMRPP3=$S($P(PSSMRPP2,"^",2)="":"(None)",1:$P(PSSMRPP2,"^",2))
        .S PSSMRPP4=$S($P(PSSMRPP2,"^",3)="":"(None)",1:$P(PSSMRPP2,"^",3))
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.2,PSSMRPP1,0)),"^") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Previous Standard Route: "_PSSMRPP3 S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     New Standard Route: "_PSSMRPP4 S PSSMRPCT=PSSMRPCT+1
        I 'PSSMRPP5 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)" S PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
        D ATTN^PSSMRTUX S PSSMRPP5=0
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries in the Medication Routes (#51.2) File have been",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="unmapped from a Standard Medication Route (#51.23) File entry.",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        S PSSMRPP1=0
        F PSSMRPP1=0:0 S PSSMRPP1=$O(^TMP($J,"PSSMRUN","PSSUNLCK",PSSMRPP1)) Q:'PSSMRPP1  D
        .I $P($G(^TMP($J,"PSSMRUN","PSSUNLCK",PSSMRPP1)),"^") Q
        .S PSSMRPP5=1
        .S PSSMRPP2=$G(^TMP($J,"PSSMRUN","PSSUNLCK",PSSMRPP1))
        .S PSSMRPP3=$S($P(PSSMRPP2,"^",2)="":"(None)",1:$P(PSSMRPP2,"^",2))
        .S PSSMRPP4=$P(PSSMRPP2,"^",3) I PSSMRPP4="" S PSSMRPP4="(None)"
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.2,PSSMRPP1,0)),"^") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Previous Standard Route: "_PSSMRPP3 S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     New Standard Route: "_PSSMRPP4 S PSSMRPCT=PSSMRPCT+1
        I 'PSSMRPP5 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)" S PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
        ;
        ;
        ;Set Locked entries sections of mail message
        D ZERO^PSSMRTUX K PSSMRPP1,PSSMRPP2,PSSMRPP3,PSSMRPP4,PSSMRPP5
        S PSSMRPP5=0
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries in the Medication Routes (#51.2) File were to be",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="mapped/remapped to a Standard Medication Route (#51.23) File entry, but",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="could not occur because the Medication Route (#51.2) File entry was locked.",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        F PSSMRPP1=0:0 S PSSMRPP1=$O(^TMP($J,"PSSMRUN","PSSLCK",PSSMRPP1)) Q:'PSSMRPP1  D
        .I '$P($G(^TMP($J,"PSSMRUN","PSSLCK",PSSMRPP1)),"^") Q
        .S PSSMRPP5=1
        .S PSSMRPP2=$G(^TMP($J,"PSSMRUN","PSSLCK",PSSMRPP1))
        .S PSSMRPP3=$S($P(PSSMRPP2,"^",2)="":"(None)",1:$P(PSSMRPP2,"^",2))
        .S PSSMRPP4=$S($P(PSSMRPP2,"^",3)="":"(None)",1:$P(PSSMRPP2,"^",3))
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.2,PSSMRPP1,0)),"^") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Current Standard Route: "_PSSMRPP3 S PSSMRPCT=PSSMRPCT+1
        .D CHL^PSSMRTUX
        I 'PSSMRPP5 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)" S PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
        S PSSMRPP5=0
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries in the Medication Routes (#51.2) File were to be",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="unmapped from a Standard Medication Route (#51.23) File entry, but",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="could not occur because the Medication Route (#51.2) File entry was locked.",PSSMRPCT=PSSMRPCT+1
        S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
        S PSSMRPP1=0
        F PSSMRPP1=0:0 S PSSMRPP1=$O(^TMP($J,"PSSMRUN","PSSLCK",PSSMRPP1)) Q:'PSSMRPP1  D
        .I $P($G(^TMP($J,"PSSMRUN","PSSLCK",PSSMRPP1)),"^") Q
        .S PSSMRPP5=1
        .S PSSMRPP2=$G(^TMP($J,"PSSMRUN","PSSLCK",PSSMRPP1))
        .S PSSMRPP3=$S($P(PSSMRPP2,"^",2)="":"(None)",1:$P(PSSMRPP2,"^",2))
        .S PSSMRPP4=$P(PSSMRPP2,"^",3) I PSSMRPP4="" S PSSMRPP4="<delete mapping>"
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.2,PSSMRPP1,0)),"^") S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Current Standard Route: "_PSSMRPP3 S PSSMRPCT=PSSMRPCT+1
        .S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     New Standard Route: "_PSSMRPP4 S PSSMRPCT=PSSMRPCT+1
        I 'PSSMRPP5 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)"
        Q
        ;
        ;
OLDNM   ;
        I $P($G(^PS(51.2,PSSRTIEN,1)),"^") S $P(^TMP($J,"PSSMRUN",$S(PSSRTLOC:"PSSLCK",1:"PSSUNLCK"),PSSRTIEN),"^",2)=$P($G(^PS(51.23,+$P($G(^PS(51.2,PSSRTIEN,1)),"^"),0)),"^")
        Q
