DVBABURL        ;ALB/SPH - CAPRI URL ;10/15/2005
        ;;2.7;AMIE;**104,136**;Apr 10, 1995;Build 2
        ;
URL(Y,WHICH)    ; 
        S Y=""
        ; 1=VBA's AMIE Worksheet Website
        ; 2=CAPRI training website
        ; 3=VistAWeb website
        ; 999=Debug/Test Code
        I WHICH=1 S Y="http://152.124.238.193/bl/21/rating/Medical/exams/index.htm"
        I WHICH=2 S Y="http://vaww.cpep.med.va.gov/capri/"
        I WHICH=3 D
        . I '$$PROD^XUPROD S Y="-1^VistAWeb disabled for non-production systems." Q
        . S Y="https://vistaweb.med.va.gov/CapriPage.aspx"
        I WHICH=4 S Y="M21-1, Part VI, Rating Board Procedures^http://152.124.238.193/bl/21/Publicat/Manuals/Part6/601.htm#Exam"
        I WHICH=999 S Y="http://vhaannweb2.v11.med.va.gov/VwDesktop/CapriPage.aspx"
        Q 
        ;
