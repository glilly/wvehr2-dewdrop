XMASEC  ;(WASH ISC)/GM-Secure Packman Message ; 4/7/09 2:54pm
        ;;8.0;MailMan;**41**;Jun 28, 2002;Build 3
        N XMABORT,XMPAKMAN
        S XMABORT=0,XMPAKMAN=1
        D PSECURE^XMPSEC(XMZ,.XMABORT)
        Q
