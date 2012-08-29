SPNADF2 ;SAN DIEGO/WDE AD HOC REPORTS: OUTCOMES  FILE (#154.1) ;08/23/96  15:23
 ;;2.0;Spinal Cord Dysfunction;**14,15,19,20**;01/02/1997
 ;;2.0;QM Integration Module;;Apr 06, 1994
 ; *** Set up required and optional variables and call Ad Hoc Rpt Gen
 S SPNMRTN="MENU^SPNADF2",SPNORTN="OTHER^SPNADF",SPNDIC=154.1
 S SPNMHDR="FIM"
 D ^SPNAHOC0
 Q
MENU ; *** Build the menu array
 S SPNMENU=1
 F SP=1:1 S X=$P($T(TEXT+SP),";",3,99) Q:X=""  D
 . S SPNMENU(SPNMENU)=X,SPNMENU=SPNMENU+1
 . Q
OTHER ; *** Set up other (optional) EN1^DIP variables
 S DIS(0)="I $$EN2^SPNPRTMT(+$P($G(^SPNL(154.1,D0,0)),U))"
 S DISUPNO=0
 Q
TEXT ;;*** Sort Yes/No ^ Menu Text ^ ~Field # ^ DIR(0)           
 ;;1^Patient^~.01;"Patient"^PAO^2:AEMNQZ^D POINTER^SPNAHOC2
 ;;1^SSN^~999.01^FAO^1:60^
 ;;1^Date of Birth^~999.02;"Date Of Birth"^DAO^::AETS^D DATE^SPNAHOC2
 ;;1^Date of Death^~999.09;"Date Of Death"^DAO^::AETS^D DATE^SPNAHOC2
 ;;1^Age^~999.025;"Age"^FAO^1:60^
 ;;1^Care Type^1003;"Care Type"^SAOM^1:INPATIENT;2:OUTPATIENT;3:ANNUAL EVALUATION;4:CONTINUUM OF CARE;^D SET^SPNAHOC2
 ;;1^Care Start Date^~1001;"Care Start Date"^DAO^::AETS^D DATE^SPNAHOC2
 ;;1^Care End Date^~1002;"Care End Date"^DAO^::AETS^D DATE^SPNAHOC2
 ;;0^Record Type^~.02;"Record Type"^SAOM^1:Self Report of Function;2:FIM;3:ASIA;4:CHART;5:FAM;6:DIENER;7:DUSOI;8:Multiple Sclerosis;^D SET^SPNAHOC2
 ;;1^Score Type^.021;"Score Type"^PAO^154.3:AEMNQZ^D POINTER^SPNAHOC2
 ;;1^Division^~.023;"Division"^FAO^1:5
 ;;1^Disposition^~.024;"Disposition"^PAO^154.12:AEMNQZ^D POINTER^SPNAHOC2
 ;;1^Respondent Type^~.03;"Respondent Type"^SAOM^1:PATIENT;2:CLINICIAN;3:PROXY;^D SET^SPNAHOC2
 ;;1^Date Recorded^~.04;"Date Recorded"^DAO^::AETS^D DATE^SPNAHOC2
 ;;1^Clinician^1.01,~.01;"Clinician"^PAO^200:AEMNQZ^D POINTER^SPNAHOC2
 ;;1^Eating^~.05;"Eating"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Grooming^~.06;"Grooming"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Bathing^~.07;"Bathing"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Dressing Upper Body^~.08;"Dressing Upper Body"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Dressing Lower Body^~.09;"Dressing Lower Body"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Toileting^~.1;"Toileting"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Bladder Management^~.11;"Bladder Management"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Bowel Management^~.12;"Bowel Management"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Xfer Bed/Chr/Whlchr^~.13;"Xfer To Bed/Chair/Wheelchair"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Xfer Toilet^~.14;"Xfer To Toilet"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Xfer to Tub/Shower^~.15;"Xfer To Tub/Shower"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Walk/Wheelchair^~.16;"Walk/Wheelchair"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Method of Wlk/Whlchr^~.161;"Method Of Walk/Wheelchair"^SAOM^W:WALK;C:WHEELCHAIR;B:BOTH;^D SET^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Stairs^~.17;"Stairs"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)<3
 ;;1^Comprehension Level^~.18;"Comprehension"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)=3
 ;;1^Method of Comprehension^~.181;"Method Of Comprehension"^SAOM^A:AUDITORY;V:VISUAL;B:BOTH;^D SET^SPNAHOC2
 ;;1^Expression Level^~.19;"Expression"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)=3
 ;;1^Method of Expression^~.191;"Method Of Expression"^SAOM^V:VOCAL;N:NONVOCAL;B:BOTH;^D SET^SPNAHOC2
 ;;1^Social Interaction^~.2;"Social Interaction"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)=4
 ;;1^Problem Solving^~.21;"Problem Solving"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)=4
 ;;1^Memory^~.22;"Memory"^PAO^154.11:AEMNQZ^D POINTER^SPNAHOC2|I $P(^(0),U,3)=3
 ;;1^FIM Motor Score^~999.03;"Motor Score (FIM)"^FAO^1:60^
 ;;1^FIM Cognitive Score^~999.04;"Cognitive Score (FIM)"^FAO^1:60^
 ;;1^FIM Total Score^~999.05;"Total Score (FIM)"^FAO^1:60^
 ;;1^Length of Rehab in Days^~999.08;"Length of Rehab in Days"^FAO^1:60^
