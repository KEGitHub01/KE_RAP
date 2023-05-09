*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class zke_cls_earth DEFINITION.
    PUBLIC SECTION.
    methods Leave_Orbit RETURNING VALUE(r_value) type string.
endclass.

class zke_cls_earth IMPLEMENTATION.
  METHOD leave_orbit.
    r_value = 'Leave the Earth Orbit'.
  ENDMETHOD.

ENDCLASS.

class zke_cls_int_planet DEFINITION.
    PUBLIC SECTION.
    METHODS Enter_Orbit RETURNING VALUE(e_value) type string.
    methods Leave_Orbit RETURNING VALUE(r_value) type string.
endclass.

class zke_cls_int_planet IMPLEMENTATION.
  METHOD Enter_Orbit.
    e_value = 'Enter the InterMediatory Planet Orbit'.
  ENDMETHOD.
  METHOD Leave_Orbit.
    r_value = 'Leave the InterMediatory Planet Orbit '.
  ENDMETHOD.
ENDCLASS.

class zke_cls_mars DEFINITION.
    PUBLIC SECTION.
    methods enter_orbit RETURNING VALUE(r_value) type string.
    methods Manuvour RETURNING VALUE(r_value) type string.
    methods land RETURNING VALUE(r_value) type string.
endclass.
class zke_cls_mars IMPLEMENTATION.
  METHOD enter_orbit.
    r_value = 'Enter into the mars Orbit'.
  ENDMETHOD.
   METHOD Manuvour.
    r_value = 'The satellite is Manuvoring'.
  ENDMETHOD.
   METHOD Land.
    r_value = 'Land on Mars, Mission accomplished..'.
  ENDMETHOD.
ENDCLASS.
