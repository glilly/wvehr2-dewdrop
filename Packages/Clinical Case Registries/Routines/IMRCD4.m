IMRCD4 ;HCIOFO-FAI/SPS - HANDLE CHECKING OF CD4 VALUE INPUT ;05/11/00  06:49
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**9,5**;Feb 09, 1998
EN ; IMREDIT Entry Point
 D LIST,EDIT
 Q
LIST ; List CD4 values
 ; also called from IMR CDC4 input template
 D ^IMRLTST
 W !!
 Q
EDIT ; Edit CD4 Value
LAST ; Get Last CD4 Value
 K DR S DIE=158,DR="102.01;102.02;102.05;102.06;112.09;112.1;4;3.4;3.6;3.3;3.5;122" D ^DIE
NEWVL ; enter new viral load tests
 K DIR S DIR("A")="Want to add a new VIRAL LOAD test for this patient"
 S DIR(0)="Y" D ^DIR K DIR
 Q:$D(DIRUT)!(Y=0)
 K DR S DIE=158,DR="122" D ^DIE
 W !!,"You may enter another Viral Load Test, by entering the name below"
 K DR S DIE=158,DR="122" D ^DIE
 Q
GETVALS ; Get Lab Test Results
 D ^IMRLTST
 Q
CD4 ;
PERCNT ;
 D LIST
 Q
