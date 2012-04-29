DG53P782        ;ALB/RC-UPDATE FOR FILE 13 ; 5/15/08 11:56am
        ;;5.3;Registration;**782**;Aug 13, 1993;Build 8
        Q
EN      ;Post install entry point
        ;create KIDS checkpoints with call backs
        N DGX,Y
        F DGX="POST" D
        . S Y=$$NEWCP^XPDUTL(DGX,DGX+"DG53P782")
        . I 'Y D BMES^XPDUTL("ERROR creating "_DGX_" checkpoint.")
        Q
POST    ;Post Install
        D UP^DG53P782 ;Update Religion Entries.
        D ADD^DG53P782 ;Add Religion Entries.
        Q
UP      N DA,DIE,DR
        N DGCNT,X,OLDTEXT,NEWTEXT,UPDENTRY
        D BMES^XPDUTL("Updating religions")
        F DGCNT=1:1 S UPDENTRY=$P($T(UPDTABLE+DGCNT),";;",2) Q:UPDENTRY="EXIT"  D
        .S OLDTEXT=$P(UPDENTRY,"^",1),NEWTEXT=$P(UPDENTRY,"^",2)
        .S DA=$O(^DIC(13,"B",OLDTEXT,0))
        .S DIE=13,DR=".01///^S X=NEWTEXT"
        .D
        ..I DA D ^DIE Q
        ..D BMES^XPDUTL(OLDTEXT_" does not exist or has already been updated.")
        Q
ADD     ;Add entries to the religion file
        N DGCNT,X,NEWENTRY,NEWCODE,NEWREL,RELCHECK
        D BMES^XPDUTL("Adding Religions")
        F DGCNT=1:1  S NEWENTRY=$P($T(NEWTABLE+DGCNT),";;",2) Q:NEWENTRY="EXIT"  D
        .S NEWREL=$P(NEWENTRY,"^",1),NEWCODE=$P(NEWENTRY,"^",2)
        .;Don't add the religion if it already exists.
        .S RELCHECK=$O(^DIC(13,"B",NEWREL,0)) D
        ..I RELCHECK D BMES^XPDUTL(NEWREL_" already exists.") Q
        ..N DA,DIC,DLAYGO
        ..S DIC="^DIC(13,",DIC(0)="L",DLAYGO=13
        ..S X=NEWREL,DIC("DR")="3///^S X=NEWCODE"
        ..K DD,D0 D FILE^DICN K DIC,DA,DLAYGO
        Q
UPDTABLE        ;Table of religions being updated.
        ;;BUDDHIST^ZEN BUDDHISM
        ;;CATHOLIC^ROMAN CATHOLIC CHURCH
        ;;JEHOVAH'S WITNESS^JEHOVAH'S WITNESSES
        ;;JEWISH^JUDAISM
        ;;LATTER-DAY SAINTS^LATTER DAY SAINTS
        ;;PROTESTANT, OTHER^PROTESTANT
        ;;UNITARIAN; UNIVERSALIST^UNITARIAN-UNIVERSALISM
        ;;EXIT
NEWTABLE        ;Table of religions being added.
        ;;AFRICAN RELIGIONS^32
        ;;AFRO-CARIBBEAN RELIGIONS^33
        ;;AGNOSTICISM^34
        ;;ANGLICAN^35
        ;;ANIMISM^36
        ;;ATHEISM^37
        ;;BABI & BAHA'I FAITHS^38
        ;;BON^39
        ;;CAO DAI^40
        ;;CELTICISM^41
        ;;CHRISTIAN (NON-SPECIFIC)^42
        ;;CONFUCIANISM^43
        ;;CONGREGATIONAL^44
        ;;CYBERCULTURE RELIGIONS^45
        ;;DIVINATION^46
        ;;FOURTH WAY^47
        ;;FREE DAISM^48
        ;;FULL GOSPEL^49
        ;;GNOSIS^50
        ;;HINDUISM^51
        ;;HUMANISM^52
        ;;INDEPENDENT^53
        ;;JAINISM^54
        ;;MAHAYANA^55
        ;;MEDITATION^56
        ;;MESSIANIC JUDAISM^57
        ;;MITRAISM^58
        ;;NEW AGE^59
        ;;NON-ROMAN CATHOLIC^60
        ;;OCCULT^61
        ;;ORTHODOX^62
        ;;PAGANISM^63
        ;;PROCESS, THE^64
        ;;REFORMED/PRESBYTERIAN^65
        ;;SATANISM^66
        ;;SCIENTOLOGY^67
        ;;SHAMANISM^68
        ;;SHIITE (ISLAM)^69
        ;;SHINTO^70
        ;;SIKISM^71
        ;;SPIRITUALISM^72
        ;;SUNNI (ISLAM)^73
        ;;TAOISM^74
        ;;THERAVADA^75
        ;;UNIVERSAL LIFE CHURCH^76
        ;;VAJRAYANA (TIBETAN)^77
        ;;VEDA^78
        ;;VOODOO^79
        ;;WICCA^80
        ;;YAOHUSHUA^81
        ;;ZOROASTRIANISM^82
        ;;ASKED BUT DECLINED TO ANSWER^83
        ;;EXIT
