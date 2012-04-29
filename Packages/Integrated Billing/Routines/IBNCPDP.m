IBNCPDP ;OAK/ELZ - APIS FOR NCPCP/ECME ;1/9/08  17:27
        ;;2.0;INTEGRATED BILLING;**223,276,363,383**;21-MAR-94;Build 11
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
RX(DFN,IBD)     ; pharmacy package call, passing in IBD by ref
        ; this is called by PSO for all prescriptions issued, return is
        ; a response to bill ECME or not with array for billing data elements
        ; third piece of return is an Eligibility indicator for the prescription
        ;
        ; IBD("IEN")         = Prescription IEN
        ;    ("FILL NUMBER") = Fill number (0 is initial)
        ;    ("FILL DATE")   = Fill or refill date
        ;    ("RELEASE DATE")= Date of the Rx release in FileMan format
        ;    ("NDC")         = NDC number for drug
        ;    ("DEA")         = DEA special handling info
        ;    ("COST")        = cost of medication being dispenced
        ;    ("AO")          = Agent Orange (0,1 OR Null)
        ;    ("EC")          = Environmental Contaminant (0,1 OR Null)
        ;    ("HNC")         = Head/neck cancer (0,1 OR Null)
        ;    ("IR")          = Ionizing radiation (0,1 OR Null)
        ;    ("MST")         = Military sexual trauma (0,1 OR Null)
        ;    ("SC")          = Service connected (0,1 OR Null)
        ;    ("CV")          = Combat Veteran (0,1 OR Null)
        ;    ("QTY")         = Quantity of med
        ;    ("EPHARM")      = #9002313.56 ien (E-PHARMACY division)
        ;
        ;
        ; IBD("INS",n,1) = insurance array to bill in n order
        ;                  file 355.3 ien (group)^bin^pcn^payer sheet^group id^
        ;                  cardholder id^patient relationship code^
        ;                  cardholder first name^cardholder last name^
        ;                  home plan state ^Payer Sheet B2 ^Payer Sheet B3
        ;                  Software/Vendor Cert ID ^ Ins Name
        ;    ("INS",n,2) = dispensing fee^basis of cost determination^
        ;                  awp or tort rate or cost^gross amount due^
        ;                  administrative fee
        ;
        ;   for basis of cost determination the following is used:
        ;      "07" would be sent for Usual & Customary
        ;      "01" would be sent for AWP
        ;      "05" would be sent for Cost calculations
        ;
        ;    ("INS",n,3) = group name^ins co ph 3^plan ID^
        ;                  insurance type (V=vet, T=tricare)^
        ;                  insurance company (#36) ien
        ;
        N IBRES,IBNB
        S IBRES=$$RX^IBNCPDP1(DFN,.IBD)
        ;remove "Not ECME billable: " from the reason text
        S IBNB="Not ECME billable: "
        I IBRES[IBNB S IBRES=$P(IBRES,U)_U_$P($P(IBRES,U,2),IBNB,2)_U_$P(IBRES,U,3)
        Q IBRES
        ;
        ;
STORESP(DFN,IBD)        ; this is an API for pharmacy/ecme to use to relay
        ; results of billing using the ecme software.  If electronic billing is
        ; successful, then bills will be established.  If not, then we will
        ; flag the entry in ct for paper or not billable.
        ;
        ; IBD("STATUS")       = Bill status (PAID, REJECTED,REVERSED
        ;                        CLOSED,RELEASED,or SUBMITTED)
        ;    ("FILL DATE")    = Fill Date
        ;    ("PRESCRIPTION") = Prescription IEN from drug file (#52)
        ;    ("FILL NUMBER")  = Fill or refill number
        ;    ("BILLED")       = Amount billed
        ;    ("PAID")         = Amount paid
        ;    ("BCID")         = Reference number to the claim for payment
        ;                       BCID stands for Bill Claim ID
        ;    ("PLAN")         = IEN of the the entry in the GROUP INSURANCE
        ;                       PLAN file(#355.3)(captured from the
        ;                       $$RX^IBNCPDP call)
        ;    ("COPAY")        = Patient's copay from ECME response
        ;    ("RX NO")        = RX number from file 52
        ;    ("DRUG")         = IEN of file #50 DRUG
        ;    ("DAYS SUPPLY")  = Days Supply
        ;    ("QTY")          = Quantity
        ;    ("NDC")          = NDC
        ;    ("CLOSE REASON") = Optional, Pointer to the IB file #356.8
        ;                      "CLAIMS TRACKING NON-BILLABLE REASONS"
        ;    ("CLOSE COMMENT")= Optional, if the close reason is defined
        ;                       then the Close Comment parameter may be
        ;                       sent to IB
        ;    ("DROP TO PAPER")= Optional, this parameter may be set to 1(TRUE)
        ;                       for certain Close Claim Reasons, indicating
        ;                       that that the closed episode still may be
        ;                       "dropped to paper" - passed to the Autobiller
        ;    ("RELEASE COPAY")= Optional, if the claim is being closed, setting
        ;                       this parameter to 1 (TRUE) indicates that the
        ;                       patients copay should be released off hold
        ;    ("DIVISION")     = Pointer to the MC DIVISION file (#40.8)
        ;    ("AUTH #")       = ECME approval/authorization number
        ;    ("CLAIMID")      = Reference Number to ECME
        ;    ("EPHARM")       = Optional, #9002313.56 ien (E-PHARMACY division)
        ;
        ;
        ; Return is the bill number for success or 1 if not billable.
        ; "0^reason" indicates not success
        ;
        Q $$ECME^IBNCPDP2(DFN,.IBD)
        ;
        ;
UPAWP(IBNDC,IBAWP,IBADT)        ; used to update AWPs.  This is an API that
        ; pharmacy will call.
        ;
        ;  IBNDC = NDC number to update with the price.
        ;  IBAWP = average wholesale price of the NDC
        ;  IBADT  = effective date of change (optional, default it today)
        ;
        ;  return will be a positive number indicating success.
        ;  if it is unsuccessful, then "0^reason" will be returned.
        ;
        Q $$UPAWP^IBNCPDP3(IBNDC,IBAWP,$G(IBADT,DT))
        ;
        ;
