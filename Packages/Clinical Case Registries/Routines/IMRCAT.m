IMRCAT ;SF-ISC/CNP-PRINT INSTRUCTIONS FOR CATEGORIZING IMR PATIENTS ;4/8/93  14:34
V ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ; called from ^DD(158,4,0) - CATEGORY
 W !!,"The categories for each are as follows:"
CAT1 W !!,"1. HIV+, CD4+ (T4) Count 500/mm3 or Greater."
 W !,"   a. Confirmed HIV serum antibody positive (two positive ELISAs and"
 W !,"      a confirmatory Western Blot)"
 W !,"   b. CD4+ (T4) count 500/mm3 or greater."
CAT2 W !!!,"2. HIV+, CD4+ Count between 200 and 500/mm3."
 W !,"   a. Confirmed HIV serum antibody positive (two positive ELISAs and"
 W !,"      a confirmatory Western Blot)"
 W !,"   b. CD4+ (T4) count 200 and 500/mm3."
 R !!,"Press return to continue: ",IMRORES:DTIME G:'$T!(IMRORES["^") EXIT
CAT3 W !!,"3. AIDS with CD4+ (T4) LESS THAN 200/mm3."
 W !,"   a. Confirmed HIV serum antibody positive (two positive ELISAs and"
 W !,"      a confirmatory Western Blot)"
 W !,"   b. CD4+ (T4) count less than 200/mm3 or CD4+ percent less than 14."
 W !,"   c. No AIDs defining diseases.  See below (Category 4)."
CAT4 W !!,"4. AIDS WITH AIDS DEFINING DISEASES."
 W !,"   a. Confirmed HIV serum antibody positive (2 positive ELISAs and"
 W !,"      a confirmatory Western Blot) as above"
 W !,"   b. CDC defined diseases (see MMWR, December 18, 1992, Vol. 41/RR-17"
 W !,"      for listing of AIDs defining diseases)."
EXIT W !! K IMRORES Q
