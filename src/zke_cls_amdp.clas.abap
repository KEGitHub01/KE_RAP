CLASS zke_cls_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    INTERFACES if_oo_adt_classrun.
    CLASS-METHODS add_number IMPORTING value(a) type i
                                       value(b) type i
                                EXPORTING value(result) type i.
      CLASS-METHODS get_customer_name IMPORTING value(i_bp_id) type zke_de_id
                                EXPORTING value(e_row) type char16.
      class-methods get_product_mrp importing value(i_tax) type i
                                    exporting value(otab) type ZKE_TTYPE_PROD.
      CLASS-METHODS get_total_sales for TABLE FUNCTION ZKE_TABLE_FUNCTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zke_cls_amdp IMPLEMENTATION.

  METHOD add_number BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
   OPTIONS read-only.
        result := :a + :b;
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
*    add_number(
*    EXPORTING
*        a = 10
*        b = 20
*        Importing
*        result = data(lv_result)
*        ).

*    get_customer_name(
*      Exporting
*        i_bp_id = 1005
*      importing
*        e_row = data(lv_result)
*        ).
*
*        out->write(
*        Exporting
*            data = |The Customer_Name for the given ID is { lv_result }|
*            ).

        get_product_mrp(
        exporting
            i_tax = 18
        importing
            otab = data(itab)
            ).

           out->write(
           exporting
                data = itab
                ).
  ENDMETHOD.

  METHOD get_customer_name by database procedure for HDB language sqlscript
  options read-only using zke_bpa.
   select company_name into e_row from zke_bpa where bp_id = :i_bp_id;

  ENDMETHOD.

  METHOD get_product_mrp by database procedure for HDB language sqlscript
  options read-only using zke_product.

    declare lv_count integer;
    declare i integer;
    declare lv_price_d integer;
    declare lv_mrp bigint;

    lt_prod = select * from zke_product;
     lv_count = record_count( :lt_prod );

     for i in 1..:lv_count do
       lv_price_d := :lt_prod.price[i] * ( 100 - :lt_prod.discount[i] ) / 100;
       lv_mrp := :lv_price_d * ( 100 + :i_tax ) / 100;
       if lv_mrp > 15000 then
               lv_mrp := lv_mrp * 0.90;
        end if;

      :otab.insert( (:lt_prod.name[i],:lt_prod.category[i],:lt_prod.price[i],:lt_prod.currency[i],:lt_prod.discount[i],
                          :lv_price_d, :lv_mrp ) , i);

        end for;

  ENDMETHOD.

  METHOD get_total_sales by database function for HDB language sqlscript
  options read-only using zke_bpa zke_so_hdr zke_so_item.
        return select bp.client, bp.company_name, sum( item.amount )as Total_sales, item.currency as currency_code,
                       rank() over( order by sum( item.amount) desc)  as customer_rank
                        from zke_bpa as bp
                        inner join zke_so_hdr as hdr
                        on bp.bp_id = hdr.buyer
                        inner join zke_so_item as item
                        on hdr.order_id = item.order_id
                        group by bp.client, bp.company_name,item.currency;

  ENDMETHOD.

ENDCLASS.
