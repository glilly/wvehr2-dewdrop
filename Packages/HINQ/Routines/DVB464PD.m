DVB464PD ;ALB/MJB - DISABILITY FILE UPDATE ;6:32 PM  26 Feb 2012
 ;;4.0;HINQ;**64**;03/25/92;Build 25;;WorldVistA 30-June-08
 ;
 ;Modified from FOIA VISTA,
 ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
 ;General Public License See attached copy of the License.
 ;
 ;This program is free software; you can redistribute it and/or modify
 ;it under the terms of the GNU General Public License as published by
 ;the Free Software Foundation; either version 2 of the License, or
 ;(at your option) any later version.
 ;
 ;This program is distributed in the hope that it will be useful,
 ;but WITHOUT ANY WARRANTY; without even the implied warranty of
 ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ;GNU General Public License for more details.
 ;
 ;You should have received a copy of the GNU General Public License along
 ;with this program; if not, write to the Free Software Foundation, Inc.,
 ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 ;
 ;This routine is the main install routine that will update the
 ;DISABILITY CONDITION (#31) file with requested changes to file.
 Q  ;no direct entry
 ;
POST(DVBTMP,DVBTOT) ;post-install driver for updating the (#31) file
 ;This procedure will call a series of routines that contain the data
 ;element values that will be used to delete requested VBA-ICD9 mapping.
 ;
 ;  Input:
 ;    DVBTMP - Closed Root global reference for error reporting
 ;    DVBTOT - Total number of ICD9 codes filed
 ;
 ;  Output:
 ;    DVBTMP - Temp file of error messages (if any)
 ;    DVBTOT - Total number of ICD9 codes filed
 ;
 N DVBCNT
 S DVBTMP=$G(DVBTMP)
 S DVBTOT=$G(DVBTOT) I DVBTOT']"" S DVBTOT=0
 I DVBTMP']"" S DVBTMP=$NA(^TMP("DVB464PD",$J)) K @DVBTMP
 D BLDXRF(DVBTMP,.DVBTOT)
 ;Begin WorldVistA change
 Q
 ;End WorldVistA change
 ;
BLDXRF(DVBTMP,DVBTOT) ;call delete VBA/ICD9 codes
 ;
 ;  Input:
 ;    DVBRTN - Post Install routine to process VBA/ICD9 codes
 ;    DVBTMP - Closed Root global reference for error reporting
 ;    DVBTOT - Total number of ICD9 codes filed
 ;
 ;  Output:
 ;    DVBTOT - Total number of ICD9 codes filed
 ;
 N DVBLINE  ;$TEXT code line
 N DVBLN    ;line counter incrimenter
 N DVBTAG   ;line tag of routine to process
 N DVBVBA   ;VBA DX code (external value)
 N DVBVB    ;DX CODE
 ;
 S (DVBLN,DVBVBA)=0
 ;
 F DVBLN=1:1 S DVBTAG="DELCODE+"_DVBLN,DVBLINE=$T(@DVBTAG) S DVBVB=$P(DVBLINE,";",3,999) Q:DVBLINE["EXIT"  D
 .;get VBA DX CODE var setup
 .S DVBVBA=$P(DVBVB,"^",1)
 .I '$O(^DIC(31,"C",DVBVBA,"")) D
 ..S @DVBTMP@("ERROR",DVBVBA)="DX CODE not found in (#31) file"
 ..S DVBVBA=0
 ..;
 .;quit back to loop if no VBA code ien found (just in case)
 .I 'DVBVBA Q
 .;
 .D BLDVBA(DVBVBA,DVBLINE,.DVBTOT)
 Q
 ; ;
BLDVBA(DVBVBA,DVBLINE,DVBTOT) ;extract ICD9 codes from text line
 ;
 ;  Input:
 ;    DVBVBA - VBA DX code (external value)
 ;   DVBLINE - $TEXT code line of ICD9's
 ;    DVBTOT - Total number of ICD9 codes filed
 ;
 ;  Output:
 ;    DVBTOT - Total number of ICD9 codes filed
 ;
 Q:'$G(DVBVBA)
 Q:$G(DVBLINE)'[";"
 ;
 N DVBDATA,DVBI,DVBICD,DVBICDEN,DVBIEN,DVBMATCH,DVBX
 ;
 ;loop in case there might be multiple VBA ien's setup
 I DVBVBA'="" S DVBIEN=0
 F  S DVBIEN=$O(^DIC(31,"C",DVBVBA,DVBIEN)) Q:DVBIEN=""  D
 . S DVBX=$P(DVBVB,"^",1)
 . S (DVBI,DVBICD)=0
 . F DVBI=1:1 S DVBDATA=$P(DVBX,"^",DVBI) Q:DVBDATA=""  D
 . . Q:DVBDATA[";"
 . . S DVBICD=$P(DVBVB,"^",2),DVBMATCH=+$P(DVBVB,"^",3)
 . . ; - get ICD9 pointer from ICD DIAGNOSIS (#80) file
 . . S DVBICDEN=+$$ICDDX^ICDCODE(DVBICD,DT)
 . . I 'DVBICDEN!(DVBICDEN<0)!(DVBICD=DVBICDEN) D  Q
 . . . S @DVBTMP@("ERROR",DVBVBA,DVBIEN,DVBICD)="not found in ICD DIAGNOSIS (#80) file"
 . . ;
 . . Q:'$D(^DIC(31,DVBIEN,"ICD","B",DVBICDEN))  ;
 . . ;
 . . I '$$FILEICD(DVBIEN,DVBICDEN,DVBMATCH) D  Q
 . . . S @DVBTMP@("ERROR",DVBVBA,DVBIEN,DVBICD)="error filing to (#31) file"
 . . S DVBTOT=DVBTOT+1
 Q
 ;
 ;
FILEICD(DVBIEN,DVBICDEN,DVBMATCH) ;file code mapping to delete icds from (#31) file
 ;
 ;  Input:
 ;    DVBIEN    - ien of VBA DX CODE in file (#31)
 ;    DVBICDEN  - ien of ICD9 code in file (#80)
 ;    DVBMATCH  - match code (1 or 0)
 ;
 ;  Output:
 ;    Function result - 1 on success, 0 on failure
 ;
 ; Fields :
 ; (#20) RELATED ICD9 CODES - ICD;0 POINTER Multiple (#31.01)
 ;   (#31.01) -- RELATED ICD9 CODES SUB-FILE
 ;    Field(s):
 ;    .01 RELATED ICD9 CODES - 0;1 POINTER TO ICD DIAGNOSIS FILE (#80)
 ;    .02 ICD9 MATCH - 0;2 SET ('0' FOR PARTIAL MATCH; '1' FOR MATCH;)
 ;
 N DVBERR,DVBFDA,DVBRSLT,DIK
 S DVBRSLT=0
 ;
 I $G(DVBIEN),$G(DVBICDEN),$G(DVBMATCH)]"" D
 .S DA(1)=DVBIEN
 .S DA=$O(^DIC(31,DA(1),"ICD","B",DVBICDEN,0)) Q:DA'>0  D
 ..W !!,"DELETING FROM DISABILITY CODE "_DVBVBA_""
 ..W !!,"DELETING ICD CODE "_DVBICD_" FROM MAPPING"
 ..;I DA'>0 D  Q:DA'>0
 ..S DIK="^DIC(31,"_DA(1)_",""ICD""," D ^DIK K DA
 .S:'$D(DVBERR) DVBRSLT=1
 Q DVBRSLT
 ;
 ;
 ;codes to be deleted
DELCODE ;DISABILITY CODE^ICDCODE
 ;;5017^274.0
 ;;6004^364.21
 ;;6028^366.10
 ;;6028^366.11
 ;;6028^366.12
 ;;6028^366.13
 ;;6028^366.14
 ;;6028^366.15
 ;;6028^366.16
 ;;6028^366.17
 ;;6028^366.18
 ;;6028^366.19
 ;;6028^366.30
 ;;6028^366.31
 ;;6028^366.32
 ;;6028^366.33
 ;;6028^366.34
 ;;6028^366.41
 ;;6028^366.42
 ;;6028^366.43
 ;;6028^366.44
 ;;6028^366.50
 ;;6028^366.51
 ;;6028^366.52
 ;;6028^366.53
 ;;6028^366.8
 ;;6028^366.9
 ;;6028^366.10
 ;;6028^366.11
 ;;6028^366.12
 ;;6028^366.13
 ;;6028^366.14
 ;;6028^366.15
 ;;6028^366.16
 ;;6028^366.17
 ;;6028^366.18
 ;;6028^366.19
 ;;6028^366.30
 ;;6028^366.31
 ;;6028^366.32
 ;;6028^366.33
 ;;6028^366.34
 ;;6028^366.41
 ;;6028^366.42
 ;;6028^366.43
 ;;6028^366.44
 ;;6028^366.50
 ;;6028^366.51
 ;;6028^366.52
 ;;6028^366.53
 ;;6028^366.8
 ;;6028^366.9
 ;;6031^375.30
 ;;6031^375.31
 ;;6031^375.32
 ;;6031^375.33
 ;;6031^375.41
 ;;6031^375.42
 ;;6033^379.32
 ;;6033^379.33
 ;;6033^379.34
 ;;6066^369.62
 ;;6066^V45.78
 ;;6067^369.07
 ;;6068^369.13
 ;;6069^369.17
 ;;6069^369.62
 ;;6070^369.62
 ;;6071^369.08
 ;;6072^369.14
 ;;6073^369.18
 ;;6073^369.68
 ;;6074^369.68
 ;;6078^369.75
 ;;6092^368.2
 ;;6845^511.8
 ;;7827^695.1
 ;;6017^076.0
 ;;6017^076.1
 ;;6017^076.9
 ;;EXIT
 Q
