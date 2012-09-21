DVB464P2        ;ALB/MJB - DISABILITY FILE UPDATE ; 6/28/10 1:34pm
        ;;4.0;HINQ;**64**;03/25/92;Build 25
        ;
        ;This routine will continue the update of the
        ;DISABILITY CONDITION (#31) file with the mapping of Rated
        ;Disabilities (VA) VBA DX CODES to specific ICD DIAGNOSIS codes with 
        ;2009-2010 DX mappings.
        ;
        ;  ;no direct entry
        ;
        ; ; Fields :
        ; (#20) RELATED ICD9 CODES - ICD;0 POINTER Multiple (#31.01)
        ;   (#31.01) -- RELATED ICD9 CODES SUB-FILE
        ;    Field(s):
        ;    .01 RELATED ICD9 CODES - 0;1 POINTER TO ICD DIAGNOSIS FILE (#80)
        ;    .02 ICD9 MATCH - 0;2 SET ('0' FOR PARTIAL MATCH; '1' FOR MATCH;)
        ;
        ;The following TEXT lines are a combination of a single 4 digit VBA
        ;rated disabilities code and related ICD9 DIAGNOSIS code to be 
        ;mapped together.  Each IDC9 code also has a (1/0)
        ;match value that will be filed with it.
        ;
        ;DISABILITY CODE^ICDCODE^MATCH - FULL(1) OR PARTIAL(0)
TEXT    ;
        ;;6006^362.10^0
        ;;6006^362.11^0
        ;;6006^362.13^0
        ;;6006^362.14^0
        ;;6006^362.15^0
        ;;6006^362.16^0
        ;;6006^362.17^0
        ;;6006^362.18^0
        ;;6006^362.20^0
        ;;6006^362.21^0
        ;;6006^362.22^0
        ;;6006^362.23^0
        ;;6006^362.24^0
        ;;6006^362.25^0
        ;;6006^362.26^0
        ;;6006^362.27^0
        ;;6006^362.30^0
        ;;6006^362.31^0
        ;;6006^362.32^0
        ;;6006^362.33^0
        ;;6006^362.34^0
        ;;6006^362.35^0
        ;;6006^362.36^0
        ;;6006^362.37^0
        ;;6006^362.50^0
        ;;6006^362.51^0
        ;;6006^362.52^0
        ;;6006^362.53^0
        ;;6006^362.54^0
        ;;6006^362.55^0
        ;;6006^362.56^0
        ;;6006^362.60^0
        ;;6006^362.61^0
        ;;6006^362.62^0
        ;;6006^362.63^0
        ;;6006^362.64^0
        ;;6006^362.65^0
        ;;6006^362.66^0
        ;;6006^362.81^0
        ;;6006^362.82^0
        ;;6006^362.83^0
        ;;6006^362.84^0
        ;;6006^362.81^0
        ;;6006^363.31^0
        ;;6008^361.10^0
        ;;6008^361.11^0
        ;;6008^361.12^0
        ;;6008^361.13^0
        ;;6008^361.14^0
        ;;6008^362.40^0
        ;;6008^362.41^0
        ;;6008^362.42^0
        ;;6008^362.43^0
        ;;6009^371.30^0
        ;;6009^371.31^0
        ;;6009^371.32^0
        ;;6009^371.33^0
        ;;6009^371.72^0
        ;;6009^371.82^0
        ;;6009^371.20^0
        ;;6009^371.21^0
        ;;6009^371.22^0
        ;;6009^371.23^0
        ;;6009^371.24^0
        ;;6011^362.56^0
        ;;6012^364.82^0
        ;;6013^365.62^0
        ;;6013^365.63^0
        ;;6013^365.65^0
        ;;6013^365.81^0
        ;;6017^372.34^0
        ;;6025^375.30^0
        ;;6025^375.31^0
        ;;6025^375.32^0
        ;;6025^375.33^0
        ;;6025^375.41^0
        ;;6025^375.42^0
        ;;6025^375.43^0
        ;;6025^375.51^0
        ;;6025^375.52^0
        ;;6025^375.53^0
        ;;6025^375.54^0
        ;;6025^375.55^0
        ;;6025^375.56^0
        ;;6025^375.57^0
        ;;6025^375.61^0
        ;;6025^375.81^0
        ;;6026^362.85^0
        ;;6027^366.10^0
        ;;6027^366.11^0
        ;;6027^366.12^0
        ;;6027^366.13^0
        ;;6027^366.14^0
        ;;6027^366.15^0
        ;;6027^366.16^0
        ;;6027^366.17^0
        ;;6027^366.18^0
        ;;6027^366.19^0
        ;;6027^366.30^0
        ;;6027^366.31^0
        ;;6027^366.32^0
        ;;6027^366.33^0
        ;;6027^366.34^0
        ;;6027^366.41^0
        ;;6027^366.42^0
        ;;6027^366.43^0
        ;;6027^366.44^0
        ;;6027^366.50^0
        ;;6027^366.51^0
        ;;6027^366.52^0
        ;;6027^366.53^0
        ;;6027^366.8^0
        ;;6027^366.9^0
        ;;6035^371.60^0
        ;;6035^371.61^0
        ;;6035^371.62^0
        ;;6036^V42.5^1
        ;;6036^996.51^1
        ;;6036^V42.5^1
        ;;6036^996.51^1
        ;;6037^372.51^1
        ;;6037^372.51^1
        ;;6066^369.22^1
        ;;6066^369.24^1
        ;;6066^369.72^1
        ;;6066^369.25^1
        ;;6066^369.75^1
        ;;6320^136.21^0
        ;;6320^136.29^0
        ;;6516^784.42^0
        ;;6817^416.2^1
        ;;6819^209.21^0
        ;;6819^511.81^0
        ;;6820^209.61^0
        ;;6845^511.89^1
        ;;7005^414.3^1
        ;;7343^209.00^0
        ;;7343^209.01^0
        ;;7343^209.02^0
        ;;7343^209.03^0
        ;;7343^209.10^0
        ;;7343^209.11^0
        ;;7343^209.12^0
        ;;7343^209.13^0
        ;;7343^209.14^0
        ;;7343^209.15^0
        ;;7343^209.16^0
        ;;7343^209.17^0
        ;;7343^209.23^0
        ;;7343^209.72^0
        ;;7344^209.63^0
        ;;7344^209.40^0
        ;;7344^209.41^0
        ;;7344^209.42^0
        ;;7344^209.43^0
        ;;7344^209.50^0
        ;;7344^209.51^0
        ;;7344^209.52^0
        ;;7344^209.53^0
        ;;7344^209.54^0
        ;;7344^209.55^0
        ;;7344^209.56^0
        ;;7344^209.57^0
        ;;7345^571.42^1
        ;;7522^607.84^0
        ;;7528^209.24^0
        ;;7529^209.64^0
        ;;7610^625.70^0
        ;;7610^625.71^0
        ;;7610^625.79^0
        ;;7628^621.34^0
        ;;7628^621.35^0
        ;;7700^285.3^0
        ;;7703^204.02^1
        ;;7703^204.12^1
        ;;7703^204.22^1
        ;;7703^204.82^1
        ;;7703^204.92^1
        ;;7703^205.02^1
        ;;7703^205.12^1
        ;;7703^205.22^1
        ;;7703^205.82^1
        ;;7703^205.92^1
        ;;7703^206.02^1
        ;;7703^206.12^1
        ;;7703^206.22^1
        ;;7703^206.82^1
        ;;7703^206.92^1
        ;;7703^207.02^1
        ;;7703^207.12^1
        ;;7703^207.22^1
        ;;7703^207.82^1
        ;;7703^208.02^1
        ;;7703^208.12^1
        ;;7703^208.22^1
        ;;7703^208.82^1
        ;;7703^208.92^1
        ;;7705^289.84^1
        ;;7818^209.31^0
        ;;7818^209.32^0
        ;;7818^209.33^0
        ;;7818^209.34^0
        ;;7818^209.35^0
        ;;7820^078.12^0
        ;;7827^695.10^1
        ;;7827^695.11^1
        ;;7827^695.12^1
        ;;7827^695.13^1
        ;;7827^695.14^1
        ;;7827^695.15^1
        ;;7827^695.19^1
        ;;7913^249.00^1
        ;;7913^249.01^1
        ;;7913^249.11^1
        ;;7913^249.20^1
        ;;7913^249.21^1
        ;;7913^249.30^1
        ;;7913^249.31^1
        ;;7913^249.40^1
        ;;7913^249.41^1
        ;;7913^249.50^1
        ;;7913^249.51^1
        ;;7913^249.60^1
        ;;7913^249.61^1
        ;;7913^249.70^1
        ;;7913^249.71^1
        ;;7913^249.80^1
        ;;7913^249.81^1
        ;;7913^249.90^1
        ;;7913^249.91^1
        ;;7913^366.41^1
        ;;7913^362.01^1
        ;;7913^362.02^1
        ;;7913^362.03^1
        ;;7913^362.04^1
        ;;7913^362.05^1
        ;;7913^362.06^1
        ;;7913^362.07^1
        ;;7913^357.2^1
        ;;8100^346.02^1
        ;;8100^346.03^1
        ;;8100^346.12^1
        ;;8100^346.13^1
        ;;8100^346.22^1
        ;;8100^346.23^1
        ;;8100^346.70^1
        ;;8100^346.71^1
        ;;8100^346.72^1
        ;;8100^346.73^1
        ;;8100^346.82^1
        ;;8100^346.83^1
        ;;8100^346.92^1
        ;;8100^346.93^1
        ;;8100^346.50^1
        ;;8100^346.51^1
        ;;8100^346.52^1
        ;;8100^346.53^1
        ;;8100^346.30^1
        ;;8100^346.31^1
        ;;8100^346.32^1
        ;;8100^346.33^1
        ;;8100^346.40^1
        ;;8100^346.41^1
        ;;8100^346.60^1
        ;;8100^346.61^1
        ;;8100^346.62^1
        ;;8100^346.63^1
        ;;8100^339.00^0
        ;;8100^339.01^0
        ;;8100^339.02^0
        ;;8100^339.03^0
        ;;8100^339.04^0
        ;;8100^339.05^0
        ;;8100^339.09^0
        ;;8100^339.10^0
        ;;8100^339.11^0
        ;;8100^339.12^0
        ;;8100^339.20^0
        ;;8100^339.21^0
        ;;8100^339.22^0
        ;;8100^339.3^0
        ;;8100^339.41^0
        ;;8100^339.42^0
        ;;8100^339.43^0
        ;;8100^339.44^0
        ;;8100^339.81^0
        ;;8100^339.85^0
        ;;8100^339.89^0
        ;;EXIT
