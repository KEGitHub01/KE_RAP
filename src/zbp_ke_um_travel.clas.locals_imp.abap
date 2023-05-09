CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    types : tt_travel_failed   type table for failed ZKE_UM_TRAVEL.
    types : tt_travel_reported type table for REPORTED ZKE_UM_TRAVEL.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS set_booked_status FOR MODIFY
      IMPORTING keys FOR ACTION Travel~set_booked_status RESULT result.

    METHODS map_messages
        IMPORTING
            cid type string OPTIONAL
            travel_id type /dmo/travel_id OPTIONAL
            messages type /dmo/t_message
        EXPORTING
            failed_added type abap_boolean
        changing
            failed type tt_travel_failed
            reported type tt_travel_reported.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    data: messages type /dmo/t_message,
          travel_in type /dmo/travel,
          travel_out type /dmo/travel.

    "Step 1: We get the data from Fiori
    loop at entities ASSIGNING FIELD-SYMBOL(<travel_Create>).

    "Step 2: Check the data
    "Step 3: Modify data if needed
    "Step 4: Call legacy ABAP code to perform create
        travel_in = CORRESPONDING #( <travel_Create> mapping from entity using control ).

        /dmo/cl_flight_legacy=>get_instance(  )->create_travel(
          EXPORTING
            is_travel             = CORRESPONDING /dmo/s_travel_in( travel_in )
          IMPORTING
            es_travel             = travel_out
            et_messages           = data(lt_messages)
        ).

        /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        map_messages(
          EXPORTING
            cid          = <travel_Create>-%cid
            travel_id    = <travel_Create>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

        if data_failed = abap_false.
            INSERT value #( %cid = <travel_Create>-%cid
                            travelid = <travel_Create>-TravelId
             ) into table mapped-travel.
        ENDIF.

    ENDLOOP.
    "Step 5: Map the message from the legacy ABAP code to RAP output format

  ENDMETHOD.

  METHOD update.
   data: messages type /dmo/t_message,
          travel   type /dmo/travel,
          travel_u type /dmo/s_travel_inx.

    "Step 1: What is the data which is passed by the developer from the screen
    loop at entities ASSIGNING FIELD-SYMBOL(<travel_update>).

    "Step 2: Check the validity of the data
        travel = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).

    "Step 3: Map the data to the structure compatible for update
        travel_u-travel_id = travel-travel_id.

    "Step 4: Map the update flag structure
        travel_u-_intx = CORRESPONDING #( <travel_update> mapping from entity ).

    "Step 5: Call the existing ABAP code in Company to update data
        /dmo/cl_flight_legacy=>get_instance(  )->update_travel(
          EXPORTING
            is_travel              = CORRESPONDING /dmo/s_travel_in( travel )
            is_travelx             = travel_u
*            it_booking             =
*            it_bookingx            =
*            it_booking_supplement  =
*            it_booking_supplementx =
          IMPORTING
*            es_travel              =
*            et_booking             =
*            et_booking_supplement  =
            et_messages            = data(lt_messages)
        ).
    "Step 6: Error Handling
        /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        map_messages(
          EXPORTING
            cid          = <travel_update>-%cid_ref
            travel_id    = <travel_update>-TravelId
            messages     = messages
*          IMPORTING
*            failed_added =
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
        data: messages type /dmo/t_message,
              travel_out type /dmo/travel.

          loop at keys ASSIGNING FIELD-SYMBOL(<travel_delete>).

                /dmo/cl_flight_legacy=>get_instance(  )->delete_travel(
                EXPORTING
                    iv_travel_id = <travel_delete>-TravelId
                IMPORTING
                    et_messages = data(lt_messages)
                     ).

                  /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
                  EXPORTING
                        it_messages = lt_messages
                  IMPORTING
                        et_messages = messages
                        ).

                  map_messages(
          EXPORTING
            cid          = <travel_delete>-%cid_ref
            travel_id    = <travel_delete>-TravelId
            messages     = messages
*          IMPORTING
*            failed_added =
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

          ENDLOOP.
  ENDMETHOD.

  METHOD read.
        data : messages type /dmo/t_message,
               travel_out type /dmo/travel,
               lv_failed type flag.

            loop at keys ASSIGNING FIELD-SYMBOL(<travel_to_read>) GROUP BY <travel_to_read>-travelid.

                /dmo/cl_flight_legacy=>get_instance(  )->get_travel(
                EXPORTING
                     iv_travel_id           = <travel_to_read>-TravelId
                    iv_include_buffer      = abap_false
                IMPORTING
                      es_travel              = travel_out
                     et_messages            = data(lt_messages)
        ).
           /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        map_messages(
          EXPORTING
            travel_id    = <travel_to_read>-TravelId
            messages     = messages
          IMPORTING
            failed_added = lv_failed
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).
            if lv_failed = abap_false.

            INSERT CORRESPONDING #( travel_out mapping to entity ) into table result.

        ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD lock.

        TRY.
            data(lo_lock) = cl_abap_lock_object_factory=>get_instance( iv_name ='/DMO/ETRAVEL').
        CATCH cx_abap_lock_failure into data(exception).
            RAISE SHORTDUMP exception.
        ENDTRY.

        loop at keys ASSIGNING FIELD-SYMBOL(<fs_travel>).
            try.
                lo_lock->enqueue(
                it_parameter = value #( ( name = 'TRAVEL_ID' value = ref #( <fs_travel>-TravelId ) ) )
                ).
            catch cx_abap_foreign_lock into data(foreign_lock).
                 map_messages(
                             EXPORTING
                                       travel_id    = <fs_travel>-TravelId
                                       messages     = value #( (
                                                                    msgid ='/DMO/CM_FLIGHT_LEGAC'
                                                                    msgty = 'E'
                                                                    msgno ='032'
                                                                    msgv1 = <fs_travel>-TravelId
                                                                    msgv2 = foreign_lock->user_name
                                                                    ) )
*                             IMPORTING
*                                       failed_added = lv_failed
                             CHANGING
                                       failed       = failed-travel
                                        reported     = reported-travel
        ).
         CATCH cx_abap_lock_failure into exception.
            RAISE SHORTDUMP exception.
            endtry.
            endloop.
  ENDMETHOD.

  METHOD map_messages.

    failed_added = abap_false.

    loop at messages into data(message).

        if message-msgty = 'E' or message-msgty = 'A'.

            append value #( %cid = cid
                            travelid = travel_id
                            %fail-cause = /dmo/cl_travel_auxiliary=>get_cause_from_message(
                                            msgid        = message-msgid
                                            msgno        = message-msgno
*                                           is_dependend = abap_false
                                          )
             ) to failed.

             failed_added = abap_True.

        ENDIF.

        append value #( %msg = new_message(
                                id = message-msgid
                                number = message-msgno
                                v1 = message-msgv1
                                v2 = message-msgv2
                                v3 = message-msgv3
                                v4 = message-msgv4
                                severity = if_abap_behv_message=>severity-information
                                )
                            %cid = cid
                            travelid = travel_id )
             to reported.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.

   READ ENTITIES OF ZKE_UM_TRAVEL IN LOCAL MODE
      ENTITY Travel
        FIELDS ( TravelID Status )
        WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_result)
    FAILED failed.

    result = VALUE #(
      FOR ls_travel IN lt_travel_result (
        %key                                = ls_travel-%key
        %features-%action-set_booked_status = COND #( WHEN ls_travel-Status = 'B'
                                                      THEN if_abap_behv=>fc-o-disabled
                                                      ELSE if_abap_behv=>fc-o-enabled )
                                                            ) ).

  ENDMETHOD.

  METHOD set_booked_status.

        data: messages type /dmo/t_message,
              travel_out type /dmo/travel,
              travel_set_booked_status Like line of result.

          clear result.

          loop at keys ASSIGNING FIELD-SYMBOL(<travel_set_booked_status>).
                DATA(travel_id) = <travel_set_booked_status>-TravelId.

                /dmo/cl_flight_legacy=>get_instance(  )->set_status_to_booked(
                EXPORTING
                    iv_travel_id = travel_id
                IMPORTING
                    et_messages = data(lt_messages)
                    ).

                /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
                EXPORTING
                    it_messages = lt_messages
                IMPORTING
                    et_messages = messages
                 ).

       map_messages(
          EXPORTING
*            cid          =
            travel_id    = travel_id
            messages     = messages
          IMPORTING
            failed_added = data(lv_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

        if lv_failed = abap_false.
            /dmo/cl_flight_legacy=>get_instance(  )->get_travel(
            EXPORTING
                iv_travel_id = travel_id
                iv_include_buffer = abap_false
            IMPORTING
                es_travel = travel_out
                ).
             travel_set_booked_status-%param = CORRESPONDING #( travel_out mapping to entity ).
             travel_set_booked_status-%param-travelid = travel_id.
             append travel_set_booked_status to result.

             endif.
          ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZKE_UM_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZKE_UM_TRAVEL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
        /dmo/cl_flight_legacy=>get_instance(  )->save( ).
  ENDMETHOD.

  METHOD cleanup.
           /dmo/cl_flight_legacy=>get_instance(  )->initialize(  ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
