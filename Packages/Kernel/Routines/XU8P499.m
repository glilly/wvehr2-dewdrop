XU8P499 ;ISF/RWF - Patch XU*8*499 Post-init ;09/15/08  12:14
        ;;8.0;KERNEL;**499**;Jul 10, 1995;Build 14
        Q
        ;
POST    ;
        I '$D(^XTV(8989.3,1,"PEER")) S ^XTV(8989.3,1,"PEER")="127.0.0.1"
        X ^%ZOSF("EON")
        W ! D RELOAD^ZTMGRSET W !
        X ^%ZOSF("EOFF")
        Q
