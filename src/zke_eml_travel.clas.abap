CLASS zke_eml_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA lv_type type c VALUE 'A'.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zke_eml_travel IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

       case lv_type.
             when 'R'.

                   READ ENTITIES OF ZKE_UM_TRAVEL
                      ENTITY TRAVEL
                        ALL FIELDS WITH
                            VALUE #( ( TravelId = '00000013' ) ( TravelId = '00000002' ) )
                            RESULT DATA(lt_result)
                            FAILED DATA(failed)
                            REPORTED data(reported).

                         if lt_result is not INITIAL.
                                out->write(
                                  EXPORTING
                                    data   = lt_result
                                ).
                           endif.
                         if failed is not initial.
                                out->write(
                                  EXPORTING
                                    data   = failed
                                ).
                         endif.

             when 'C'.
                    data(lv_description) = 'Welcome to RAP'.
*                    data(lv_agencyid) = '070022'.
*                    data(lv_my_agencyid) = '0700999'.

                        select single customer_id from /dmo/customer into @data(lv_customer_id).
                        select single agency_id from /dmo/agency into @data(lv_agency).

                     MODIFY ENTITIES OF zke_um_travel
                     ENTITY Travel
                        CREATE  fields ( AgencyId CustomerId BeginDate EndDate Description Status )
                        with value #( (
                                    %cid = 'MycontentID_100'
                              AgencyId = lv_agency
                                CustomerId = lv_customer_id
                                    BeginDate = cl_abap_context_info=>get_system_date(  )
                                    EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                    Description = lv_description
                                    status = conv #( /dmo/if_flight_legacy=>travel_status-new )
                         ) )
                         update fields ( AgencyId Description Status )
                                with value #( (
                                                   %cid_ref = 'MycontentID_100'
                                                    Description = 'Changed by My code!'
                                                    Status = conv #( /dmo/if_flight_legacy=>travel_status-planned )
                                                     ) )
                                              MAPPED data(ls_mapped)
                                              FAILED data(lt_failed)
                                              reported data(lt_reported).

                                     commit ENTITIES.
                                            out->write(
                                              EXPORTING
                                                data   = ls_mapped-travel
                                            ).

*                READ ENTITIES OF zke_um_travel
*                ENTITY Travel
*                ALL FIELDS WITH
*                VALUE #( ( TravelId = ls_mapped-travel[ 1 ]-TravelId ) )
*                RESULT data(lt_result_received).
*
*                out->write(
*                  EXPORTING
*                    data   = lt_result_received
*                ).

                                      if lt_failed is not initial.
                                            out->write(
                                              EXPORTING
                                                 data   = lt_failed
                                                ).
                                       endif.

             when 'U'.
                MODIFY ENTITIES OF zke_um_travel
                ENTITY Travel
                    UPDATE fields ( AgencyId Description )
                    with VALUE #( ( TravelId = '00004127' ) ( AgencyId = '070006') ( Description = 'Updated RAP Field' ) )
                    failed failed
                    reported reported.
            COMMIT ENTITIES.
                    if failed is not initial.
                        out->write(
                          EXPORTING
                            data   = failed
                        ).
                    endif.

             when 'D'.
                Modify ENTITIES OF zke_um_travel
                    entity travel
                        delete from value #( ( TravelId = '00004166' ) )
                        failed failed
                        reported reported.

                        commit entities.
                        if failed is not initial.
                            out->write(
                              EXPORTING
                                data   = failed
                                        ).
                        endif.
             when 'A'.
                Modify ENTITIES OF zke_um_travel
                entity travel
                    EXECUTE set_booked_status
                        from value #( ( TravelId = '00004127' ) )
                        result data(lt_result_a)
                        failed failed
                        reported reported.

                    COMMIT ENTITIES.

        endcase.

  ENDMETHOD.
ENDCLASS.
