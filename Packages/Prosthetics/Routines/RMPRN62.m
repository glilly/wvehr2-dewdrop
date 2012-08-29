RMPRN62 ;Hines OIFO/HNC -NPPD CALCULATIONS ;02/14/98
        ;;3.0;PROSTHETICS;**31,39,48,50,57,70,84,91,103,134,144**;Feb 09, 1996;Build 17
        ;
        ; ODJ - patch 50 - 7/28/00 - add line label REP to mark start of
        ;                            repair lines.
        ; HNC - patch 57 - 4/5/01 - add Dental Implant
        ;
        ; AAC - Patch 84 - 02-25-04; additions, deletions and change descriptions for Groups and lines
        ; AAC - patch 84 - add new lines 100 H,100 I,400 H,900 N,910 B,R10 A,R10 B,R10 C,R60 D.
        ; AAC - patch 84 - change desc -100 D,100 G,900 I,900 J,R20 B,R20 C,R91 F.
        ;
        ; AAC - Patch 91 - 06/23/04 -  NPPD line R10, no longer used, but keep in display as historical listing.
        ;
        ; AAC - Patch 103 - 01/17/05 - NPPD Categories/lines - New and Repair
        ;
        ; AAC - Patch 134 - 01/25/07 - NPPD Categories/lines - New and Repair
        ;
        ; AAC - patch 144 - 03/03/08 - NPPD Categories/lines - New and Repair
        ;
        ;build array or tmp
DES     ;description of line numbers
        ;;100 A;MOTORIZED
        ;;100 A1;SCOOTERS
        ;;100 B;MANUAL CUSTOM
        ;;100 C;STANDARD
        ;;100 D;WC ACCESSORIES
        ;;100 E;CUSHION FOAM
        ;;100 F;CUSHION SPEC
        ;;100 G;LIFTS(INCLUDING WC,SCOOTERS)
        ;;100 H;NSC VAN MOD
        ;;100 I;SCOOTER ACCESSORIES
        ;;200 A;LEG IPOP
        ;;200 B;LEG TEM
        ;;200 C;LEG PART FOOT
        ;;200 E;LEG SYMES
        ;;200 F;LEG B/K
        ;;200 G;LEG A/O
        ;;200 H;LEG A/K
        ;;200 I;LEG COMPONENT
        ;;300 A;ARM B/E
        ;;300 B;ARM A/E
        ;;300 C;COSMETIC GLOVES
        ;;300 D;ARM A/O
        ;;300 E;TERMINAL DEVICES
        ;;300 F;EXT.POWERED,ARM
        ;;400 A;ORTHOSIS ANKLE
        ;;400 B;ORTHOSIS LEG AK
        ;;400 C;ORTHOSIS, SPINAL
        ;;400 D;ORTHOSIS AL/OTH
        ;;400 E;ELAS HOSE, EA
        ;;400 F;ORTHOSIS, KNEE
        ;;400 G;CORSET/BELT
        ;;400 H;ORTHOSIS,WHO
        ;;400 X;ORTHOSIS UNKNOWN
        ;;500 A;ARCH SUPT, EA
        ;;500 B;SHOE INLAY, EA
        ;;500 C;SHOE MOLDED, EA
        ;;500 D;SHOE ORTH OTH
        ;;500 E;INSERTS, SHOE
        ;;500 F;SHOES A/O, EA
        ;;600 1;EYEGLASSES PR
        ;;600 A;* NO LONGER USED *
        ;;600 B;HEAR AID & ACCESS
        ;;600 C;AID FOR BLIND
        ;;600 D;CONT LENS, EA.
        ;;600 E;EAR INSERT/MOLD
        ;;600 F;ASSIST LISTEN DEVICES
        ;;600 G;SPEECH DEVICES
        ;;700 A;EYE
        ;;700 B;FACIAL
        ;;700 C;BODY, OTHER
        ;;700 D;BREAST PROSTHESIS
        ;;800 A;OXYGEN EQP
        ;;800 B;OXYGEN CONCEN
        ;;800 C;MOVED TO REPAIR
        ;;800 D;OXYGEN, SUPPLIES
        ;;800 E;MOVED TO REPAIR
        ;;800 F;VENTILATOR, A/O
        ;;800 G;RESPIRATORY EQUIPMENT
        ;;800 H;RESPIRATORY SUPPLIES
        ;;900 A;WALKING AIDS
        ;;900 B;PATIENT LIFT
        ;;900 C;BED HOSP STD
        ;;900 D;BED HOSP SPEC
        ;;900 E;MATTRESS STAN
        ;;900 F;MATTRESS SPEC
        ;;900 G;BED, ACCESSORIES
        ;;900 H;ENVIRON CONTR
        ;;900 I;HOME SAFETY EQUIPMENT
        ;;900 J;INSTALLATION/LABOR
        ;;900 K;MED EQP AL/OTH
        ;;900 L;RECREATIONAL EQUIPMENT
        ;;900 M;COMPUTER EQUIP
        ;;900 N;TELEHEALTH
        ;;910 A;MED SUP AL/OTH
        ;;910 B;BATTERIES
        ;;920 A;HOME DIAL EQP
        ;;920 B;HOME DIAL SUP
        ;;930 A;MOD VANS
        ;;930 B;ADAPT EQP AL/OTH
        ;;940 A;HISA SC
        ;;940 B;HISA NSC
        ;;960 A; H&N ALL OTHER
        ;;960 A1; H&N INTRAOCULAR LENS
        ;;960 A2; H&N HEAD
        ;;960 A3; H&N NECK
        ;;960 A4; H&N EYES A/O
        ;;960 B; ABDOMEN ALL OTHER
        ;;960 B1; ABDOMEN STENT
        ;;960 B2; ABDOMEN MESH
        ;;960 B3; ABDOMEN CATHETER
        ;;960 C; UE ALL OTHER
        ;;960 C1; UE ARM
        ;;960 C2; UE SHOULDER
        ;;960 C3; UE HAND
        ;;960 D; LE ALL OTHER
        ;;960 D1; LE HIP
        ;;960 D2; LE KNEE
        ;;960 D3; LE FOOT
        ;;960 E; THORACIC ALL OTHER
        ;;960 E1; THOR PACEMAKER/LEADS
        ;;960 E2; THOR ICD/LEADS
        ;;960 E3; THOR STENTS
        ;;960 E4; THOR VALVES
        ;;960 F; DENTAL IMPLANTS
        ;;960 G; ALL SCRWS,PLTS,ANCRS,ETC.
        ;;960 X; SI UNKNOWNS(ALL)
        ;;970 A; BIOLOGICAL IMPLANTS 
        ;;999 A;AL/OTH ITEMS
        ;;999 P1;PEDS DME
        ;;999 P2;ALL OTHER PEDS
        ;;999 X;HCPCS NOT GRP
        ;;999 Z;NO HCPCS
REP     ;;R10;* NO LONGER USED *
        ;;R10 A;WHEELCHAIR
        ;;R10 B;LIFTS
        ;;R10 C;NSC VAN MOD
        ;;R20 A;LEG A/K
        ;;R20 B;* NO LONGER USED *
        ;;R20 C;LEG B/K
        ;;R20 D;LEG ALL OTHER 
        ;;R30;ART ARM,TOTAL
        ;;R40;ORTHOSIS TOTAL
        ;;R50 A;ORTH SHOE ALL
        ;;R50 B;SHOE MOD
        ;;R50 C;A/O ITEM SERV
        ;;R60 A;AID FOR BLIND
        ;;R60 B;EYEGLASS RPR
        ;;R60 C;HEAR AID & ACCESS
        ;;R60 D;ASSISTIVE LISTENING DEVICES
        ;;R70;HOME DIAL EQU
        ;;R80 A;PATIENT LIFTS
        ;;R80 B;REPAIR TO ECU
        ;;R80 C;MED EQUIP A/O
        ;;R80 D;HME DELIVERY/PU
        ;;R80 E;TELEHEALTH
        ;;R90;ALL OTHER
        ;;R90 A;RECREATIONAL EQUIPMENT
        ;;R90 B;TRAINING
        ;;R91 A;CONCENTRATOR
        ;;R91 B;VENTILATOR
        ;;R91 C;EQUIPMENT A/O
        ;;R91 D;SERVICE VISIT
        ;;R91 E;COMPRESSED O2
        ;;R91 F;LIQUID O2(LBS)
        ;;R91 G;LIQUID DELIVERY SYSTEM
        ;;R91 H;RESPIRATORY EQUIP
        ;;R92 A;VAN MODS
        ;;R92 B;AUTO ADPT EQUIP
        ;;R99 A;SHIPPING
        ;;R99 P;MISC PEDS
        ;;R99 X;HCPCS NOT GRP
        ;;R99 Z;NO HCPCS
        ;;END
