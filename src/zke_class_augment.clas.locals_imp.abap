CLASS lhc_ZKE_M_TRAVEL_PROCESSOR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE zke_m_travel_processor.

    METHODS augment_update FOR MODIFY
      IMPORTING entities FOR UPDATE zke_m_travel_processor.

ENDCLASS.

CLASS lhc_ZKE_M_TRAVEL_PROCESSOR IMPLEMENTATION.

  METHOD augment_create.
        data : travel_create type table for create ZKE_M_TRAVEL.
               travel_create = CORRESPONDING #( entities ).

               loop at travel_create ASSIGNING FIELD-SYMBOL(<travel>).

                        <travel>-AgencyId = '070004'.
                        <travel>-Status = 'O'.
                        <travel>-%control-AgencyID = if_abap_behv=>mk-on.
                        <travel>-%control-Status = if_abap_behv=>mk-off.

                endloop.
                modify augmenting entities of ZKE_M_TRAVEL entity Travel create from travel_create.

  ENDMETHOD.

  METHOD augment_update.

  ENDMETHOD.

ENDCLASS.
