ECOBL   ;BP/CMF - List object
        ;;2.0;EVENT CAPTURE;**100**;8 May 96;Build 21
        ;@author  - Chris Flegel
        ;@date    - 17 May 2009
        ;@version - 1.0
        ;;
        Q
        ;;private methods
ADD(RESULT,HANDLE,VALUE)        ; add simple list item
        N ITEM,X
        D PARSE("Handle",HANDLE)
        D GET(.ITEM,HANDLE,"Pu","Count")
        S ITEM=ITEM+1
        S @HANDLE@("Pr","list",ITEM)=VALUE
        D METHOD(.X,HANDLE_".Criteria.SetLastItem."_ITEM)
        D METHOD(.X,HANDLE_".Criteria.SetLastValue."_VALUE)
        D SET(.X,HANDLE,"Pu","Count",ITEM)
        D METHOD(.X,HANDLE_".Criteria.Index."_ITEM)
        S RESULT=ITEM
        Q
        ;;
CLEAR(RESULT,HANDLE,PARAMS)     ; restore to default state
        D METHOD(.RESULT,HANDLE_".Criteria.Clear")
        K @HANDLE@("Pr","list")
        D SET(.RESULT,HANDLE,"Pu","Count",0)
        Q
        ;;
COLLECT(RESULT,HANDLE,CHILD)    ; add a child object to the list
        N ITEM
        D PARSE("Handle",HANDLE)
        D ADD(.ITEM,HANDLE,CHILD)
        S @HANDLE@("Pr","list","Handle",CHILD)=ITEM
        S RESULT=ITEM
        Q
        ;;
FIRST(RESULT,HANDLE,PARAMS)      ;
        D METHOD(.RESULT,HANDLE_".Criteria.First")
        Q
        ;;
FIND(RESULT,HANDLE,PARAMS)       ;
        D METHOD(.RESULT,HANDLE_".Criteria.Find."_PARAMS)
        Q
        ;;
FIND1(RESULT,HANDLE,PARAMS)      ;
        D METHOD(.RESULT,HANDLE_".Criteria.Find1."_PARAMS)
        Q
        ;;
        ;;
GET(RESULT,HANDLE,SCOPE,PROPERTY)        ;
        ; if unique get methods, call them first, else call parent
        D GET^ECOB(.RESULT,HANDLE,SCOPE,PROPERTY)
        Q 
           ;;
GETITEM(RESULT,HANDLE,ITEM)     ; get simple list item
        N NAME,COUNT
        D PARSE("Handle",HANDLE)
        S RESULT=$G(@HANDLE@("Pr","list",ITEM))
        Q
        ;;
INFO(RESULT,HANDLE,PARAMS)       ;
        N NAME,COUNT,ITEMS,I,OUT,JUSTIFY,OFFSET
        D PARSE("Offset",PARAMS)
        D METHOD(.ITEMS,HANDLE_".ShowCount."_JUSTIFY)
        D METHOD(.OUT,HANDLE_".First")
        F  Q:+OUT=-1  D
        .W !,$J(OUT,OFFSET)
        .D METHOD(.OUT,HANDLE_".Next")
        .Q
        Q
        ;;
ISHANDLE(HANDLE,VALUE)  ; is value a collected handle
        Q:(HANDLE="")!(VALUE="") 0
        Q $D(@HANDLE@("Pr","list","Handle",VALUE))
        ;
LAST(RESULT,HANDLE,PARAMS)      ; get the last referenced item from the list
        D METHOD(.RESULT,HANDLE_".Criteria.Last")
        Q
        ;;
NEXT(RESULT,HANDLE,PARAMS)      ; get the next item from the list
        D METHOD(.RESULT,HANDLE_".Criteria.Next")
        Q
        ;;
SET(RESULT,HANDLE,SCOPE,PROPERTY,VALUE)  ;
        ; if unique set methods, call them first, else call parent
        D SET^ECOB(.RESULT,HANDLE,SCOPE,PROPERTY,VALUE)
        Q 
        ;;
SETITEM(RESULT,HANDLE,ITEM,VALUE)       ; set simple list item
        N NAME,COUNT,X
        D PARSE("Handle",HANDLE)
        I '$D(@HANDLE@("Pr","list",ITEM)) D  Q
        .S RESULT="-1^Item "_ITEM_" does not exist"
        S @HANDLE@("Pr","list",ITEM)=VALUE
        D SET(.RESULT,HANDLE,"Pr","last",ITEM)
        D METHOD(.X,HANDLE_".Criteria.Index."_ITEM)
        Q
        ;;
SHOW(RESULT,HANDLE,SCOPE,PROPERTY,JUSTIFY)      ; parent method
        D SHOW^ECOB(.RESULT,HANDLE,SCOPE,PROPERTY,JUSTIFY)
        Q
        ;;
PARSE(PARSE,VALUE)       ;
        I PARSE="Child" D  Q
        .S CHILD=$P(VALUE,"Handle.",2)
        .Q
        I PARSE="Count" D  Q
        .S COUNT=$P(VALUE,".",2)
        .Q
        I PARSE="Get" D  Q
        .S PROPERTY=$P(VALUE,".",3)
        .S PROPERTY=$P(VALUE,"Get",2)
        .Q
        I PARSE="Handle" D  Q
        .S HANDLE=$P(VALUE,".")
        .Q
        I PARSE="Justify" D  Q
        .S JUSTIFY=$S(+VALUE:+VALUE,1:0)
        .Q
        I PARSE="Method" D  Q
        .S METHOD=$P(VALUE,".",2)
        .Q
        I PARSE="Offset" D  Q
        .S JUSTIFY=$S(+VALUE:+VALUE,1:0)
        .S OFFSET=JUSTIFY+5
        .Q
        I PARSE="Params" D  Q
        .S PARAMS=$P(VALUE,".",3,99)
        .Q
        I PARSE="Set" D  Q
        .S PROPERTY=$P(VALUE,".",3)
        .S PROPERTY=$P(PROPERTY,"Set",2)
        .Q
        I PARSE="SetItem" D  Q
        .S SETITEM=+$P(VALUE,".")
        .S SETVALUE=$P(VALUE,".",2)
        .Q
        I PARSE="SetValue" D  Q
        .S SETVALUE=$P(VALUE,".",4)
        .Q
        Q
        ;;
PROPERTY(HANDLE,SCOPE,PROPERTY,VALUE)   ; parent method
        D PROPERTY^ECOB(HANDLE,SCOPE,PROPERTY,VALUE)
        Q
        ;;
ECOBC(RESULT,HANDLE,PROPERTY,ARGUMENT)  ; handler for Criteria
        N CHILD
        D GET(.CHILD,HANDLE,"Pr",PROPERTY)
        D METHOD^ECOBC(.RESULT,CHILD_"."_ARGUMENT)
        Q
        ;;
        ;; public methods
CREATE(NAME)     ;
        ; call parent first
        N HANDLE,CHILD,COUNT,X
        S HANDLE=$$CREATE^ECOB(NAME)
        D PROPERTY(HANDLE,"Pu","Count",0)
        D PROPERTY(HANDLE,"Pr","list",0)
        D PROPERTY(HANDLE,"Pr","last","")
        D SELF^ECOB(.X,HANDLE,"EC LIST","Basic list","METHOD^ECOBL(.RESULT,ARGUMENT)","ECOB2")
        ; complex properties last
        S CHILD=$$CREATE^ECOBC(NAME)
        D COLLECT^ECOB(HANDLE,CHILD,"Pr","Criteria")
        D SET^ECOB(.X,CHILD,"Pr","_collector",HANDLE)
        ;
        Q HANDLE
        ;;
DESTROY(HANDLE)  ;
        ; call parent last
        N CHILD
        D GET(.CHILD,HANDLE,"Pr","Criteria")
        D DESTROY^ECOBC(CHILD)
        Q $$DESTROY^ECOB2(HANDLE)
        ;;
METHOD(RESULT,ARGUMENT)  ;
        ; argument= handle.method.(additional.params...)
        N HANDLE,METHOD,PARAMS
        D PARSE("Handle",ARGUMENT)
        D PARSE("Method",ARGUMENT)
        D PARSE("Params",ARGUMENT)
        I METHOD="Add" D ADD(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Clear" D CLEAR(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Criteria" D ECOBC(.RESULT,HANDLE,METHOD,PARAMS) Q
        I METHOD="Collect" D COLLECT(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Find" D FIND(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Find1" D FIND1(.RESULT,HANDLE,PARAMS) Q
        I METHOD="First" D FIRST(.RESULT,HANDLE,PARAMS) Q
        I METHOD="GetItem" D GETITEM(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Info" D INFO(.RESULT,HANDLE,PARAMS) Q
        I METHOD="IsHandle" S RESULT=$$ISHANDLE(HANDLE,PARAMS) Q
        I METHOD="Last" D LAST(.RESULT,HANDLE,PARAMS) Q
        I METHOD="Next" D NEXT(.RESULT,HANDLE,PARAMS) Q
        ; development methods last
        I METHOD="SetItem" D  Q
        .N SETITEM,SETVALUE
        .D PARSE("SetItem",PARAMS)
        .D SETITEM(.RESULT,HANDLE,SETITEM,SETVALUE)
        .Q
        D METHOD^ECOB2(.RESULT,ARGUMENT)
        Q
        ;;
