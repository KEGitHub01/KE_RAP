CLASS zke_class_pool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zke_class_pool IMPLEMENTATION.
 METHOD if_oo_adt_classrun~main.
    data: itab type TABLE OF string,
          wa like line of itab.

      data(lo_earth) = new zke_cls_earth( ).
      append lo_earth->leave_orbit( ) to itab.

       data(lo_int) = new zke_cls_int_planet(  ).
       append lo_int->enter_orbit( ) to itab.
      append lo_int->leave_orbit( ) to itab.

       data(lo_mars) = new zke_cls_mars( ).
       append lo_mars->enter_orbit( ) to itab.
      append lo_mars->Manuvour( ) to itab.
      append lo_mars->land( ) to itab.

          out->write(
          Exporting
          data = itab
          ).
  ENDMETHOD.
ENDCLASS.
