PSO7P302        ; SMT - Disable PSO SPEED RENEW protocol ; 3/18/08 7:53am
        ;;7.0;OUTPATIENT PHARMACY;;MARCH 2008;Build 8
        Q
        ;
START   ;Manuall disable PSO SPEED RENEW Protocol.
        N PRIEN
        S PRIEN=$O(^ORD(101,"B","PSO SPEED RENEW",0))
        I $D(^ORD(101,PRIEN,0)) S $P(^ORD(101,PRIEN,0),"^",3)="TEMPORARILY OUT OF USE via PSO*7*302"
        Q
