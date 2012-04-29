PRSARC05        ;DWS/ALB-RECESS UTILITY ;DEC 05, 2006  09:58
        ;;4.0;PAID;**112**;Sep 21, 1995;Build 54
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        Q
RSPP(WK,IEN,PP) ;SAME RESULTS AS RES USING DIFFERENT PARAMETERS
        ;IEN  THE EMPLOYEE IEN FROM FILE 450
        ;PP   Pay period to return results for in YYYY-NN format i.e. 2006-01 for example
        ;WK   Set to -1 if pay period is not found.  Otherwise results for RES are passed through.
        N I,SFY,EFY,SDT,EDT S I=$O(^PRST(458,"AB",PP,0)) I 'I S WK=-1 Q
        S I=^PRST(458,I,1),SDT=$P(I,U),EDT=$P(I,U,14)
        S (SFY,EFY)=$S($E(SDT,4,7)>930:PP+1,1:+PP)
        D RES(.WK,IEN,SFY,EFY,SDT,EDT) Q
RES(WK,IEN,SFY,EFY,SDT,EDT)     ;RETURN NUMBER OF HOURS OF RECESS IN WK ARRAY
        ;IEN  THE EMPLOYEE IEN FROM FILE 450
        ;SFY  THE FISCAL YEAR OF THE START OF THE TIME PERIOD
        ;EFY  THE FISCAL YEAR OF THE END OF THE TIME PERIOD
        ;SDT  THE DATE OF THE START OF THE TIME PERIOD
        ;EDT  THE DATE OF THE END OF THE TIME PERIOD
        ;WK(X)   THE NUMBER OF HOURS OF RECESS SCHEDULED IN THE WEEK BEGANNING
        ;        ON DAY X.  X IS A FILEMAN DATE FOR THE FIRST DAY OF THE WEEK.
        N DA,FY,H,HRS,I,J,K,L,PPI S PPI=$P($G(^PRST(458,"AD",SDT)),U) S:'PPI PPI=$P(^PRST(458,0),U,3)
        D TOURHRS^PRSARC07(.HRS,PPI,IEN)
        S DA=$O(^PRST(458.8,"AC",IEN,SFY,0)),I=SDT-7,K=1,FY=SFY Q:'DA
        D  I SFY'=EFY S DA=$O(^PRST(458.8,"AC",IEN,EFY,0)) D:DA
        .F  S I=$O(^PRST(458.8,DA,1,"AC",I)) Q:I=""!(I>EDT)  D
        ..S J=$O(^(I,0)),L=^PRST(458.8,DA,1,J,0),H=$P(L,U,2)
        ..I H="" S H=HRS("W"_$$WK($P(L,U,3)))
        ..S WK($P(L,U,3))=H
        Q
WK(X)   ;RETURN 1 FOR THE FIRST WEEK OF THE PAY PERIOD AND 2 FOR THE SECOND
        ;WEEK
        N %H D H^%DTC Q %H\7#2+1
