CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

    METHODS calculateTotalFlightPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalFlightPrice.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES of ZKE_M_TRAVEL
    ENTITY Booking
    FIELDS ( CarrierId )
    WITH CORRESPONDING #( keys )
    RESULT data(lt_booking).


    result = value #( for ls_booking in lt_booking (
                                                       %tky = ls_booking-%tky
                                                       %field-BookingId = if_abap_behv=>fc-f-read_only
                                                       %field-BookingDate = if_abap_behv=>fc-f-read_only
                                                       %field-CustomerId = cond #( when ls_booking-CarrierId = 'AA'
                                                                                    then if_abap_behv=>fc-f-read_only
                                                                                    else if_abap_behv=>fc-f-unrestricted
                                                        )

     ) ).

  ENDMETHOD.

  METHOD calculateTotalFlightPrice.

    "Step 1: Define a internal table of all amount and currency codes
    types : BEGIN OF ty_amount,
                amount type /dmo/total_price,
                currency_code type /dmo/currency_code,
            END OF ty_amount.
    data: lt_all_amount type STANDARD TABLE OF ty_amount.

    "Step 2: Read data for our travel entity for booking fees
    READ ENTITIES of ZKE_M_TRAVEL
    ENTITY Travel
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT data(lt_travel).

    delete lt_travel where CurrencyCode is initial.

    "Step 3: Loop at all travel data
    loop at lt_travel assigning FIELD-SYMBOL(<fs_travel>).

        lt_all_amount = value #( ( amount = <fs_travel>-BookingFee currency_code = <fs_travel>-CurrencyCode ) ).

        "Step 3.1: Read the associated bookings inside each travel
        READ ENTITIES of ZKE_M_TRAVEL
        ENTITY Travel by \Booking
        FIELDS ( FlightPrice CurrencyCode )
        WITH VALUE #( (  %tky = <fs_travel>-%tky ) )
        RESULT data(lt_bookings).

        "Step 3.2: Loop over each booking and total amounts which are in common currencies
        loop at lt_bookings into data(booking) where CurrencyCode is not initial.
            collect value ty_amount( amount = booking-flightprice currency_code = booking-CurrencyCode )
            into lt_all_amount.
        endloop.
        "Step 3.2: Loop over each currency entry and do currency conversion
        clear <fs_travel>-TotalPrice.

        loop at lt_all_amount into data(ls_all_amount).

            if ls_all_amount-currency_code = <fs_travel>-CurrencyCode.
                <fs_travel>-TotalPrice += ls_all_amount-amount.
            else.
                /dmo/cl_flight_amdp=>convert_currency(
                  EXPORTING
                    iv_amount               = ls_all_amount-amount
                    iv_currency_code_source = ls_all_amount-currency_code
                    iv_currency_code_target = <fs_travel>-CurrencyCode
                    iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
                  IMPORTING
                    ev_amount               = data(lv_conv_amount)
                ).
                <fs_travel>-TotalPrice += lv_conv_amount.
            ENDIF.

        ENDLOOP.
        "Step 3.3: update the travel entity with total amount

        MODIFY ENTITIES of ZKE_M_TRAVEL
        in LOCAL MODE
        ENTITY travel
        UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( lt_travel ).


    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
