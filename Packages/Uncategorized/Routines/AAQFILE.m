AAQFILE ;FGO/JHS;Find/Delete File in Directory ; 11/26/05 9:50pm
 ;;1.0;AAQ LOCAL;;09-02-98;For Kernel V8.0 and NT-Cache
 I ^%ZOSF("OS")'["OpenM-NT" W $C(7),!,"This routine should be run only on Alpha OpenM-NT systems!  Halting.",! H 1 Q
 I '$D(DTIME) W !,"DTIME is not set.  Calling XUP to set up required variables.",!,"Press RETURN at the Select OPTION NAME: prompt.",!! D ^XUP
 W !!,"Find/Delete File in PATCHES or ANONYMOUS Directory on NT-Cache system.",!,"This will find or delete one file at a time, not wild card selections."
 D UCI^%ZOSV S X=$$NOW^XLFDT W !!,^DD("SITE"),"   ",Y,"   ",$$FMTE^XLFDT(X)
PAT ; Check if default directory is PATCHES instead of ANONYMOUS.
 I Y="TST,ROU" S AAQDIR="Y:\PATCHES\" G CKP
 ;;I Y="VAH,ROU" S AAQDIR="T:\PATCHES\" G CKP
 I Y="EHR,EHR" S AAQDIR="C:\PATCHES\" G CKP
 G CKUCI
 ; Valid directory check is done by trying to open TEST.TMP file.
CKP K POP D OPEN^%ZISH("TEST",AAQDIR,"TEST.TMP","W")
 G:POP=1 ANON
 D CLOSE^%ZISH("TEST"),DELTMP G WRDIR
ANON ; Initial setup by Avanti Team established following directories.
 I Y="TST,ROU" S AAQDIR="Y:\ANONYMOUS\" G CKA
 I Y="VAH,ROU" S AAQDIR="T:\ANONYMOUS\" G CKA
CKA K POP D OPEN^%ZISH("TEST",AAQDIR,"TEST.TMP","W")
 G:POP=1 NODEF
 D CLOSE^%ZISH("TEST"),DELTMP
WRDIR W !!,"Download Directory for Patches for this Site and UCI is: ",AAQDIR
ASKOK S %=1 W !,"Is this the correct directory" D YN^DICN G:%=1 ASKFN I %=0 W !!,"This routine will not work correctly if directory names are wrong."
 G:%=1 ASKFN
NODEF W !!,$C(7),"The PATCHES or ANONYMOUS Download Directory could not be found."
GETDIR R !!,"Enter the Drive:\Directory\ to use for this system: ",AAQDIR:DTIME
 I (AAQDIR="?")!(AAQDIR="") W !!,"Enter in the format Drive:\Directory\ or '^' to Exit." G GETDIR
 I AAQDIR["^" G NODIR
 S AAQLN=$L(AAQDIR) I $E(AAQDIR,AAQLN)'="\" W !!,$C(7),"The entry must include the trailing backslash." G GETDIR
 K POP D OPEN^%ZISH("TEST",AAQDIR,"TEST.TMP","W")
 W:POP=1 !!,$C(7),"ERROR: Directory Location could not be found, try again."
 G:POP=1 GETDIR
 D CLOSE^%ZISH("TEST"),DELTMP
ASKFN W !!,"Download Directory has been selected.  Enter partial Filename now."
 W !,"NOTE: Using *.* with the Filename will NOT work for lookup."
ASKFIL W !!,"Enter a portion of the Filename or press RETURN to Exit: " R AAQFN:DTIME I (AAQFN="")!(AAQFN="^") G EXIT
 I AAQFN[" " W $C(7),!!,"A <SPACE> cannot be used as part of the File Name.",! G ASKFIL
 I AAQFN["?" W $C(7),!!,"Enter only Letters, Numbers, and Underscore.",! G ASKFIL
 I (AAQFN[".G*")!(AAQFN[".K*") G SETFILE
 I (AAQFN[".g*")!(AAQFN[".k*") G SETFILE
 I (AAQFN["*")!(AAQFN[".") D NOEXT G ASKFIL
 G SETWILD
NOEXT W $C(7),!!,"RULE:  Do NOT use an extension or a '*' wild card in the File Name.",!,?7,"The characters *.* are automatically included with the name."
 W !!,"EXCEPTION:  When GBL and KID files have the same name,",!,?12,"Use FILENAME.G* and FILENAME.K* for lookup." Q
SETWILD S AAQFN=AAQFN_"*.*"
SETFILE S AAQFILE=$ZSEARCH(AAQDIR_AAQFN) W !,"File found: " I AAQFILE="" W $C(7),"None.  Try again." H 1 G ASKFIL
 W AAQFILE
ASKCOR S %=1 W !!,"Is this the correct filename" D YN^DICN I (%=0)!(%=2) W !!,"If the wrong file was found, use more characters for partial name lookup."
 G:%=2 ASKDIR G:%=0 ASKFIL
CKVMS G:AAQFILE'[";" ASKDEL
 S AAQREN=$P(AAQFILE,";"),AAQREN=$P(AAQREN,AAQDIR,2) W $C(7),!!,"The File Name contains a trailing VMS Version number.",!,"File "_AAQFILE_" should be Renamed "_AAQREN S:AAQFILE[".*" AAQWILD=$P(AAQFILE,".")_".*"
 S AAQWILD=AAQDIR_AAQFN
ASKREN S %=1 W !,"Do you want to Rename this file" D YN^DICN G:%=1 REN I %=0 W !!,"Answer 'Y' to Rename.  Answer 'N' skip Rename." G ASKREN
 S AAQFILE=$P(AAQFILE,".")_".*" G ASKDEL ;VMS name won't delete
REN S X=$ZF(-1,"REN "_AAQWILD_" "_AAQREN),AAQFILE=$ZSEARCH(AAQWILD) I AAQFILE[";" W $C(7),!!,"The File "_AAQFILE_" did not get renamed.  Try again." G ASKFN
 W !,"File has been Renamed "_AAQFILE,!,"Use lookup again if you want to delete." G EXIT
ASKDEL S %=2 W !!,"Do you want to delete the selected file" D YN^DICN G:%=1 DEL I %=0 W !!,"Answer 'Y' to delete file(s), answer 'N' to Exit."
 G EXIT
DEL S X=$ZF(-1,"DEL "_AAQFILE),AAQFILE=$ZSEARCH(AAQDIR_AAQFN) I AAQFILE="" W !,"File has been deleted!" G:AAQFILE="" EXIT
 W !,"One file deleted.  There are more "_AAQFN_" files in the directory." G SETFILE
DELTMP S AAQFILE="TEST.TMP",FILESPEC(AAQFILE)="",Y=$$DEL^%ZISH(AAQDIR,$NA(FILESPEC)) Q
ASKDIR S %=2 W !!,"Do you want to see a Listing of files in this directory" D YN^DICN G:%=1 ASKFS I (%=0)!(%=2) W !!,"Enter a 'wildcard' file specification using a FILESPEC* format."
 G:%=0 ASKDIR G:%=2 ASKFIL G:%=-1 EXIT
ASKFS W !!,"Enter a 'wildcard' file specification using a FILESPEC* format: " R AAQFS:DTIME I (AAQFS="")!(AAQFS="^") G EXIT
 I AAQFS[" " W $C(7),!!,"A <SPACE> cannot be used as part of the File Name.",! G ASKFS
 I AAQFS["?" W $C(7),!!,"Enter an alphanumeric string with a trailing asterisk.",! G ASKFS
 K AAQFSPEC,AAQLIST S AAQFSPEC(AAQFS)="",Y=$$LIST^%ZISH(AAQDIR,"AAQFSPEC","AAQLIST")
 W ! S AAQ=0 F J=0:0 S AAQ=$O(AAQLIST(AAQ)) W !,AAQ Q:AAQ=""
 G ASKFIL
NODIR W !!,$C(7),"PATCHES or ANONYMOUS Directory will not be used now." S AAQFN=""
CKUCI W !!,"Check the routine AAQFILE at Line Tags PAT and ANON",!,"for the appropriate UCI and Directory information.  Halting.",!
EXIT K %,%Y,AAQ,AAQDIR,AAQEXT,AAQFS,AAQFSPEC,AAQLIST,AAQLN,AAQREN,AAQWILD,FILESPEC,J,POP,X,Y
 Q  ;AAQFILE and AAQFN are killed in XPDZPAT or option Exit Action
