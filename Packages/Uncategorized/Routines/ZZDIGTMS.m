ZZDIGTMS        ;WORLDVIST/SO- FILEMAN ROUTINE SAVE GT.M;6:42 PM  19 Aug 2010
        ;;1.0;;;;Build 2
        N %,%I,%F,%S
        S %I=$I,%F=$P($P($P($ZRO,")"),"(",2)," ")_"/"_X_".m"
        O %F:(NEWVERSION)
        U %F
        D
        . S %S=0
        . F  S %S=$O(^UTILITY($J,0,%S))  Q:%S=""  Q:'$D(^(%S))  D
        .. S %=^UTILITY($J,0,%S)
        .. I $E(%)'=";" W %,!
        .. Q
        . Q
        C %F
        U %I
        ZLINK X
        Q
