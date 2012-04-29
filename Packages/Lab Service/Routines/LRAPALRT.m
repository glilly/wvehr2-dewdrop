LRAPALRT        ;DALOI/CKA - SEND AN AP ALERT AFTER THE REPORT HAS BEEN RELEASED;2/26/08
        ;;5.2;LAB SERVICE;**365**;Sep 27, 1994;Build 9
        ;
        ;
        N LRMSG,LREND,LRQUIT,LRIENS,LRSF,LRZ
        S LRQUIT=0
        D SECTION^LRAPRES
        I LRQUIT D END Q
        D ACCYR^LRAPRES
        I LRQUIT D END Q
        D LOOKUP^LRAPUTL(.LRDATA,LRH(0),LRO(68),LRSS,LRAD,LRAA)
        I LRDATA<1 S LRQUIT=1
        I LRQUIT D END Q
        I 'LRAU D
        .S LRDFN=LRDATA,LRI=LRDATA(1)
        .S LRA=^LR(LRDFN,LRSS,LRI,0)
        .S LRIENS=LRI_","_LRDFN_","
        .S LRZ(2)=$$GET1^DIQ(LRSF,LRIENS,.11,"I")
        .S LRAC=$$GET1^DIQ(LRSF,LRIENS,.06,"I")
        .D:'LRZ(2)
        ..W $C(7)
        ..S LRMSG="Report has not been released.  An alert cannot be sent."
        ..D EN^DDIOL(LRMSG,"","!!") K LRMSG
        ..S LRQUIT=1 Q
        I LRQUIT D END Q
        I LRAU D
        .S LRDFN=LRDATA
        .I $G(^LR(LRDFN,"AU"))="" D  Q
        ..S LRMSG="No information found for this accession in the "
        ..S LRMSG=LRMSG_"LAB DATA file (#63)."
        ..D EN^DDIOL(LRMSG,"","!!") K LRMSG
        ..S LRQUIT=1 Q
        .S LRZ=$$GET1^DIQ(63,LRDFN_",",14.7,"I")
        .D:'LRZ
        ..W $C(7)
        ..S LRMSG="Report has not been released.  An alert cannot be sent."
        ..D EN^DDIOL(LRMSG,"","!!") K LRMSG
        ..S LRQUIT=1 Q
        .S LRA=^LR(LRDFN,"AU")
        .S LRI=$P(LRA,U)
        .S LRAC=$$GET1^DIQ(63,LRDFN_",",14,"I")
        I LRQUIT D END Q
        D MAIN^LRAPRES1(LRDFN,LRSS,LRI,LRSF,LRP,LRAC)
END     D END^LRAPRES
        Q
