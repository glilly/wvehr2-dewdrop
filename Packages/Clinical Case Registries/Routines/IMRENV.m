IMRENV ;HCIOFO/FT-Environment Check  ;10/22/97  10:50
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
EN1 ; Was IMR*2.0*23 installed?
 I +$$PATCH^XPDUTL("IMR*2.0*23")=0 D BMES^XPDUTL("Please install IMR*2*23 first. ICR v2.1 Installation halted.") S XPDABORT=2
 Q
