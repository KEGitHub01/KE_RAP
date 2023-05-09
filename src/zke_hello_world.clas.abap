CLASS zke_hello_world DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zke_hello_world IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write(
      EXPORTING
        data   = |Hello { sy-uname }, welcome to ABAP on cloud and RAP course|
*        name   =
*      RECEIVING
*        output =
    ).


  ENDMETHOD.
ENDCLASS.
