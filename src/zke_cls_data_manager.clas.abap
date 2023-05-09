CLASS zke_cls_data_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
    METHODS flush.
    METHODS fill_master_data.
    Methods fill_transaction_data.
  PRIVATE SECTION.
ENDCLASS.



CLASS zke_cls_data_manager IMPLEMENTATION.
 METHOD if_oo_adt_classrun~main.
    flush( ).
    fill_master_data( ).
    fill_transaction_data(  ).
    out->write(
      EXPORTING
        data   = 'processing is completed successfully!'
    ).
  ENDMETHOD.
  METHOD fill_master_data.
    data : lt_bp type table of zke_bpa,
           lt_prod type table of zke_product.

          append value #(
                    bp_id = 1000
                    bp_role = '01'
                    company_name = 'TACUM'
                    street = 'Victoria Street'
                    city = 'Kolkatta'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.
                     append value #(
                    bp_id = 1002
                    bp_role = '01'
                    company_name = 'SAP'
                    street = 'Rosvelt Street Road'
                    city = 'Walldorf'
                    country = 'DE'
                    region = 'EMEA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = 1001
                    bp_role = '01'
                    company_name = 'Asia High tech'
                    street = '1-7-2 Otemachi'
                    city = 'Tokyo'
                    country = 'JP'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = 1003
                    bp_role = '01'
                    company_name = 'AVANTEL'
                    street = 'Bosque de Duraznos'
                    city = 'Maxico'
                    country = 'MX'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = 1004
                    bp_role = '01'
                    company_name = 'Pear Computing Services'
                    street = 'Dunwoody Xing'
                    city = 'Atlanta, Georgia'
                    country = 'US'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = 1005
                    bp_role = '01'
                    company_name = 'PicoBit'
                    street = 'Fith Avenue'
                    city = 'New York City'
                    country = 'US'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = 1006
                    bp_role = '01'
                    company_name = 'TACUM'
                    street = 'Victoria Street'
                    city = 'Kolkatta'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = 1007
                    bp_role = '01'
                    company_name = 'Indian IT Trading Company'
                    street = 'Nariman Point'
                    city = 'Mumbai'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.

   append value #(
                    product_id = 101
                    name = 'Blaster Extreme'
                    category = 'Speakers'
                    price = 1500
                    currency = 'INR'
                    discount = 3
                    )
                    to lt_prod.
    append value #(
                    product_id = 102
                    name = 'Sound Booster'
                    category = 'Speakers'
                    price = 2500
                    currency = 'INR'
                    discount = 2
                    )
                    to lt_prod.
    append value #(
                    product_id = 100
                    name = 'Smart Office'
                    category = 'Software'
                    price = 1540
                    currency = 'INR'
                    discount = 32
                    )
                    to lt_prod.
    append value #(
                    product_id = 103
                    name = 'Smart Design'
                    category = 'Software'
                    price = 2400
                    currency = 'INR'
                    discount = 12
                    )
                    to lt_prod.
    append value #(
                    product_id = 104
                    name = 'Transcend Carry pocket'
                    category = 'PCs'
                    price = 14000
                    currency = 'INR'
                    discount = 7
                    )
                    to lt_prod.
    append value #(
                    product_id = 105
                    name = 'Gaming Monster Pro'
                    category = 'PCs'
                    price = 15500
                    currency = 'INR'
                    discount = 8
                    )
                    to lt_prod.

          insert zke_bpa from table @lt_bp.
          insert zke_product from table @lt_prod.
     ENDMETHOD.

       METHOD fill_transaction_data.
     data:
           lt_so type table of zke_so_hdr,
           lt_so_i type table of zke_so_item,
           lv_date type timestamp.


          get time stamp FIELD lv_date.

           append value #(
                order_id = 200
                order_no = 1
                buyer = 1000
                gross_amount = 1452
                currency_code = 'EUR'
                created_by = sy-uname
                created_on = lv_date
                changed_by = sy-uname
                changed_on = lv_date
         ) to lt_so.
           append value #(
                order_id = 201
                order_no = 2
                buyer = 1001
                gross_amount = 2512
                currency_code = 'EUR'
                created_by = sy-uname
                created_on = lv_date
                changed_by = sy-uname
                changed_on = lv_date
         ) to lt_so.
           append value #(
                order_id = 202
                order_no = 3
                buyer = 1005
                gross_amount = 1275
                currency_code = 'EUR'
                created_by = sy-uname
                created_on = lv_date
                changed_by = sy-uname
                changed_on = lv_date
         ) to lt_so.
           append value #(
                order_id = 204
                order_no = 4
                buyer = 1007
                gross_amount = 578
                currency_code = 'EUR'
                created_by = sy-uname
                created_on = lv_date
                changed_by = sy-uname
                changed_on = lv_date
         ) to lt_so.
           append value #(
                order_id = 203
                order_no = 5
                buyer = 1004
                gross_amount = 2654
                currency_code = 'EUR'
                created_by = sy-uname
                created_on = lv_date
                changed_by = sy-uname
                changed_on = lv_date
         ) to lt_so.
            append value #(
                item_id = 301
                order_id = 204
                product = 100
                qty =  6
                uom = 'EA'
                amount =  9000
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 302
                order_id = 204
                product = 100
                qty =  6
                uom = 'EA'
                amount =  9000
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 303
                order_id = 203
                product = 105
                qty =  4
                uom = 'EA'
                amount = 62000
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 304
                order_id = 203
                product = 105
                qty =  4
                uom = 'EA'
                amount =  62000
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 305
                order_id = 201
                product = 102
                qty =  7
                uom = 'EA'
                amount =  17500
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 306
                order_id = 201
                product = 102
                qty =  7
                uom = 'EA'
                amount =  17500
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 307
                order_id = 202
                product = 103
                qty =  2
                uom = 'EA'
                amount =  4800
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 308
                order_id = 202
                product = 103
                qty =  2
                uom = 'EA'
                amount = 4800
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 309
                order_id = 200
                product = 104
                qty =  1
                uom = 'EA'
                amount =  14000
                currency = 'INR'
         ) to lt_so_i.
               append value #(
                item_id = 310
                order_id = 200
                product = 104
                qty =  1
                uom = 'EA'
                amount = 14000
                currency = 'INR'
         ) to lt_so_i.

        insert zke_so_hdr from table @lt_so.
    insert zke_so_item from table @lt_so_i.
ENDMETHOD.
      METHOD flush.
         delete from : zke_bpa, zke_product, zke_so_hdr, zke_so_item.
         ENDMETHOD.


ENDCLASS.
