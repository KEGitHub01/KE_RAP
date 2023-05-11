CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CreateTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~CreateTravelByTemplate RESULT result.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD CreateTravelByTemplate.
        "Step 1: Use keys to read data from selected records
            READ ENTITIES OF zke_m_travel IN LOCAL MODE
            ENTITY Travel
            FIELDS ( TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode ) with
            CORRESPONDING #( keys )
            RESULT data(lt_read_result).
         "Step 2: Create internal table with new data
            data lt_create type table for create zke_m_travel.

                    select max( travel_id ) from /dmo/travel into @data(lv_travel_id).
            data(lv_today) = cl_abap_context_info=>get_system_date( ).

            lt_create = value #( for row in lt_read_result index into idx (
                                            %cid = row-TravelId
                                            TravelId = lv_travel_id + idx
                                            AgencyId = row-AgencyId
                                            CustomerId =  row-CustomerId
                                            BeginDate = lv_today
                                            EndDate = lv_today + 30
                                            BookingFee = row-BookingFee
                                            TotalPrice = row-TotalPrice
                                            CurrencyCode = row-CurrencyCode
                                            Description = 'Auto Created'
                                            Status = 'O'
             ) ).
          "Step 3: use internal table to create new BO record
                    MODIFY ENTITIES OF zke_m_travel in local mode
                    ENTITY Travel
                  create FIELDS ( TravelId AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode Description Status )
                  with lt_create
                  MAPPED data(lt_mapped).

          "Step 4: read newly created data
                read ENTITIES OF zke_m_travel
                ENTITY Travel
                ALL FIELDS WITH
                CORRESPONDING #( lt_mapped-travel )
                result data(lt_final_result).

            result = value #( for key in lt_mapped-travel index into idx (
                                                %cid_ref = keys[ key entity %key = key-%cid ]-%cid_ref
                                                %key = key-%cid
                                                %param-%tky = key-%key
            ) ).







  ENDMETHOD.

ENDCLASS.
