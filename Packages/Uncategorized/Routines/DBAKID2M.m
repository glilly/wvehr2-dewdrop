DBAKID2M ; Restore patches from HFS files to MailMan ;9/28/02  12:53
 ; Get path to HFS patches
 ; Order through all messages
 I '$D(DUZ) D ^XUP
 S SAVEDUZ=DUZ,DUZ=.5
 S DIR(0)="F^2:60",DIR("A")="Full path, up to but not including patch names" D ^DIR G:Y="^" EXIT S ROOT=Y
 K FILE S ARRAY("*")=""
 S Y=$$LIST^%ZISH(ROOT,"ARRAY","FILE") I 'Y W !,"Error getting directory list" G EXIT
 K ERROR S PATCH="" F  S PATCH=$O(FILE(PATCH)) Q:PATCH=""  D  Q:$D(ERROR)
 . K ^TMP($J)
 . ; Gather the message
 . S Y=$$FTG^%ZISH(ROOT,PATCH,$NA(^TMP($J,1,0)),2) I 'Y W !,"Error copying to global" S ERROR=1 Q
 . S XMSUBJ=PATCH
 . S ^TMP($J,1,0)="$TXT "_^TMP($J,1,0)
 . S ^TMP($J,3,0)="$END TXT"
 . S ^TMP($J,4,0)="$KID "_^TMP($J,6,0)
 . S Y=$O(^TMP($J,""),-1) K ^TMP($J,Y)
 . S ^TMP($J,Y-1,0)="$END KID "_^TMP($J,6,0)
 . ; Deliver the message
 . D SENDMSG^XMXAPI(.5,XMSUBJ,$NA(^TMP($J)),SAVEDUZ,,.XMZ)
 . I $D(XMERR) W !,"MailMan error, see ^TMP(""XMERR"",$J)" S ERROR=1 Q
 . ; Set MESSAGE TYPE to KIDS build
 . S $P(^XMB(3.9,XMZ,0),"^",7)="K"
 W !,"Done"
EXIT S DUZ=SAVEDUZ K ROOT,DIC,Y,DIR,FILE,XMSUBJ,PATCH,^TMP($J),ERROR,SAVEDUZ,XMZ
 Q
