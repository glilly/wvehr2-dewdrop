XUPCF   ;BT/BP-OAK Person Class File APIs; 2/4/2010
        ;;8.0;KERNEL;**541**; July 10, 1995;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified
        ;;these APIs are for updating Person Class File and for Kernal Team only.
        ;;
        ;;REFERENCED BY: PROVIDER TYPE(B), PROVIDER TYPE(C), CLASSIFICATION(D), 
        ;;              AREA OF SPECIALIZATION(E), VA CODE(F), X12 CODE(G)
        ;;^USC(8932.1,D0,0)= (#.01) PROVIDER TYPE [1F] ^ (#1) CLASSIFICATION [2F] ^ 
        ;;               ==>(#2) AREA OF SPECIALIZATION [3F] ^ (#3) STATUS [4S] ^ (#4) 
        ;;               ==>DATE INACTIVATED [5D] ^ (#5) VA CODE [6F] ^ (#6) X12 CODE 
        ;;               ==>[7F] ^ (#7) reserved [8F] ^ (#8) SPECIALTY CODE [9F] ^ 
        ;;^USC(8932.1,D0,11,0)=^8932.111^^  (#11) DEFINITION
        ;;^USC(8932.1,D0,11,D1,0)= (#.01) DEFINITION [1W] ^ 
        ;;^USC(8932.1,D0,90002)=  ^ (#90002) INDIVIDUAL/NON [2S] ^
        Q
        ;
GET(XUIEN)      ;
        I $G(XUIEN)'=+$G(XUIEN) W !,"Invalid IEN" Q
        W !,"PROVIDER TYPE",?24,": ",$$GET01(XUIEN)
        W !,"CLASSIFICATION",?24,": ",$$GET1(XUIEN)
        W !,"AREA OF SPECIALIZATION",?24,": ",$$GET2(XUIEN)
        W !,"STATUS",?24,": ",$$GET3(XUIEN)
        W !,"DATE INACTIVATED",?24,": ",$$GET4(XUIEN)
        W !,"VA CODE",?24,": ",$$GET5(XUIEN)
        W !,"X12 CODE",?24,": ",$$GET6(XUIEN)
        W !,"SPECIALTY CODE",?24,": ",$$GET8(XUIEN)
        Q
        ;
SET(XUIEN,XUDATA)       ;
        I $G(XUIEN)'=+$G(XUIEN) W !,"Invalid IEN" Q
        I $G(XUDATA)="" W !,"Invalid data" Q
        N XUDA01 S XUDA01=$P(XUDATA,"^",1),XUDA01=$$SET01(XUDA01,XUIEN)
        N XUDA1 S XUDA1=$P(XUDATA,"^",2),XUDA1=$$SET1(XUDA01,XUIEN)
        N XUDA2 S XUDA2=$P(XUDATA,"^",3),XUDA2=$$SET2(XUDA2,XUIEN)
        N XUDA3 S XUDA3=$P(XUDATA,"^",4),XUDA3=$$SET3(XUDA3,XUIEN)
        N XUDA4 S XUDA4=$P(XUDATA,"^",5),XUDA4=$$SET4(XUDA4,XUIEN)
        N XUDA5 S XUDA5=$P(XUDATA,"^",6),XUDA5=$$SET5(XUDA5,XUIEN)
        N XUDA6 S XUDA6=$P(XUDATA,"^",7),XUDA6=$$SET6(XUDA6,XUIEN)
        N XUDA8 S XUDA8=$P(XUDATA,"^",8),XUDA8=$$SET8(XUDA8,XUIEN)
        Q
        ;
GET01(XUIEN)    ;get PROVIDER TYPE by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        Q $P(XUNAME,"^",1)
        ;
SET01(XUPRO,XUIEN)      ;set/add a new PROVIDER TYPE by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",.01)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET1(XUIEN)     ;get CLASSIFICATION by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        Q $P(XUNAME,"^",2)
        ;
SET1(XUPRO,XUIEN)       ;set/add CLASSIFICATION by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",1)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET2(XUIEN)     ;get AREA OF SPECIALIZATION by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        Q $P(XUNAME,"^",3)
        ;
SET2(XUPRO,XUIEN)       ;set/add AREA OF SPECIALIZATION by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",2)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET3(XUIEN)     ;get STATUS by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        I $P(XUNAME,"^",4)="a" Q "Active"
        Q "Inactive"
        ;
SET3(XUPRO,XUIEN)       ;set/add STATUS by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",3)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET4(XUIEN)     ;get DATE INACTIVATED by IEN
        N XUNAME,XUDATE
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        S XUDATE=$P(XUNAME,"^",5)
        Q $$FMTE^XLFDT(XUDATE)
        ;
SET4(XUPRO,XUIEN)       ;set/add DATE INACTIVATED by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",4)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET5(XUIEN)     ;get VA CODE by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        Q $P(XUNAME,"^",6)
        ;
SET5(XUPRO,XUIEN)       ;set/add VA CODE by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",5)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET6(XUIEN)     ;get X12 CODE by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        Q $P(XUNAME,"^",7)
        ;
SET6(XUPRO,XUIEN)       ;set/add X12 CODE by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",6)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
        ;
GET8(XUIEN)     ;get SPECIALTY CODE by IEN
        N XUNAME
        I $G(XUIEN)'=+$G(XUIEN) Q "Invalid IEN"
        S XUNAME=$G(^USC(8932.1,XUIEN,0)) I XUNAME="" Q "Invalid IEN"
        Q $P(XUNAME,"^",9)
        ;
SET8(XUPRO,XUIEN)       ;set/addSPECIALTY CODE by IEN
        I $G(XUPRO)="" Q 0
        I $G(XUIEN)'=+$G(XUIEN) Q 0
        N FDA,FDAIEN
        S FDAIEN(1)=XUIEN
        S FDA(8932.1,"+1,",8)=XUPRO
        D UPDATE^DIE("","FDA","FDAIEN","ERR")
        Q 1
