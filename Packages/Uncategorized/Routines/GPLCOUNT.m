GPLCOUNT ;WV/GPL - Debuggin the ewd parser ;06/17/11
 ;;0.1;C0C;;Jun 17, 2011;Build 38
 ;
 Q
 ;
COUNT ;
 ; COUNT THE RECORDS IN ^CacheTempEWD and the lines in each records
 S COUNT1=0 ; HOW MANY JOBS
 S COUNT2=0 ; HOW MANY LINES IN THE JOB
 S ZI=""
 F  S ZI=$O(^CacheTempEWD(ZI)) Q:ZI=""  D  ;
 . S COUNT2=0
 . S COUNT1=COUNT1+1
 . S ZJ=""
 . F  S ZJ=$O(^CacheTempEWD(ZI,ZJ)) Q:ZJ=""  D  ;
 . . S COUNT2=COUNT2+1
 . S ^GPL("EWDJOBS",ZI,COUNT2)=""
 Q
 ;
