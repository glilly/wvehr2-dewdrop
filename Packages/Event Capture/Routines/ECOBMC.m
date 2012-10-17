ECOBMC  ;BP/CMF - Methods object
        ;;2.0;EVENT CAPTURE;**100**;8 May 96;Build 21
        ;@author  - Chris Flegel
        ;@date    - 17 May 2009
        ;@version - 1.0
        ;;
        Q
        ;;private methods
ADD(RESULT,HANDLE,VALUE)        ; add Method object to list
        N CREATE,CHILD,ITEM,X
        D METHOD(.CREATE,HANDLE_".Get_namespace")
        S CHILD=$$CREATE^ECOBM(CREATE)
        D COLLECT^ECOBL(.ITEM,HANDLE,CHILD)
        D METHOD^ECOBM(.RESULT,CHILD_".SetName."_VALUE)
        D METHOD(.X,HANDLE_".Criteria.Index."_ITEM)
        S RESULT=CHILD
        Q
        ;;
INFO(RESULT,HANDLE,PARAMS)      ; view method details
        N METHOD,JUSTIFY,OFFSET
        D PARSE("Offset",PARAMS)
        D METHOD(.METHOD,HANDLE_".First")
        F  Q:METHOD="-1^End of list"  D
        .D METHOD^ECOBM(.RESULT,METHOD_".ShowName."_JUSTIFY)
        .D METHOD^ECOBM(.RESULT,METHOD_".ShowDescription."_OFFSET)
        .D METHOD^ECOBM(.RESULT,METHOD_".ShowParams."_OFFSET)
        .D METHOD^ECOBM(.RESULT,METHOD_".ShowReturns."_OFFSET)
        .D METHOD(.METHOD,HANDLE_".Next")
        .Q
        Q
OVERRIDE(RESULT,HANDLE,VALUE)   ; override established method
        N LIST,CHILD
        S RESULT="-1^Method does not exist to override"
        D METHOD(.LIST,HANDLE_".Find."_VALUE)
        D METHOD(.CHILD,LIST_".First")
        I CHILD'="-1^End of list" S RESULT=CHILD
        D DESTROY^ECOBL(LIST)
        Q
        ;;
PARSE(PARSE,VALUE)       ;
        D PARSE^ECOBL(PARSE,VALUE) ; parent method
        Q
        ;;
PROPERTY(HANDLE,SCOPE,PROPERTY,VALUE)   ; parent method
        D PROPERTY^ECOBL(HANDLE,SCOPE,PROPERTY,VALUE)
        Q
        ;;
        ;; public methods
CREATE(NAME)     ;
        ; call parent first
        N HANDLE,X
        S HANDLE=$$CREATE^ECOBL(NAME)
        ;;
        D SELF^ECOB(.RESULT,HANDLE,"Methods","Methods","METHOD^ECOBMC(.RESULT,ARGUMENT)","ECOBL")
        ;;
        D METHOD(.X,HANDLE_".Criteria.SetArgument.GetName")
        D METHOD(.X,HANDLE_".Criteria.SetOnReturn.handle")
        Q HANDLE
        ;;
DESTROY(HANDLE)  ;
        ; call parent last
        N CHILD
        D METHOD(.CHILD,HANDLE_".First")
        F  Q:+CHILD=-1  D
        .D DESTROY^ECOBM(CHILD)
        .D METHOD(.CHILD,HANDLE_".Next")
        .Q
        Q $$DESTROY^ECOBL(HANDLE)
        ;;
METHOD(RESULT,ARGUMENT)  ;
        ; argument=(name.count[handle]).method.(additional.params...)
        N HANDLE,METHOD,PARAMS
        D PARSE("Handle",ARGUMENT)
        D PARSE("Method",ARGUMENT)
        D PARSE("Params",ARGUMENT)
        I METHOD="Add" D ADD(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Override" D OVERRIDE(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Info" D INFO(.RESULT,HANDLE,PARAMS) Q
        D METHOD^ECOBL(.RESULT,ARGUMENT)
        Q
        ;;
