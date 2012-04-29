GMRAY18 ;SLC/DAN - Patch 18 Post-install ;12/20/04  14:54
 ;;4.0;Adverse Reaction Tracking;**18**;Mar 29, 1996
 ;This post-install will set up the cross references
 ;for sending data to the HDR when data is added or edited
 ;in files 120.8, 120.85, and 120.86.
 ;
 ;DBIA 2916 allows for calls to DDMOD that's used in all of the post-install routines for this patch.
 ;
 ;
 ;Set up cross references for file 120.8
 D ^GMRAY18A,^GMRAY18B,^GMRAY18C,^GMRAY18D,^GMRAY18E,^GMRAY18F,^GMRAY18G
 ;
 ;Set up cross references for file 120.86
 D ^GMRAY18H
 ;
 ;Set up cross references for file 120.85
 D ^GMRAY18I,^GMRAY18J,^GMRAY18K,^GMRAY18L,^GMRAY18M,^GMRAY18N,^GMRAY18P
 Q
