ONCPRE48        ;Hines OIFO/GWB - PRE-INSTALL routine for patch ONC*2.11*48
        ;;2.11;ONCOLOGY;**48**;Mar 07, 1995;Build 13
        ;
ITEM11  ;Kill ONCOLOGY DATA EXTRACT FORMAT (160.16) data
        K ^ONCO(160.16)
        Q
