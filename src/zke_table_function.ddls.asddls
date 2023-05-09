@EndUserText.label: 'TABLE FUNCTION'
define table function ZKE_TABLE_FUNCTION
with parameters 
@Environment.systemField: #CLIENT
p_client : abap.clnt
returns {
  CLIENT : abap.clnt;
  company_name : abap.char( 256 );
  total_sales : abap.curr( 15, 2);
  currency_code : abap.cuky( 5 );
  customer_rank : abap.int4;
  
}
implemented by method zke_cls_amdp=>get_total_sales;