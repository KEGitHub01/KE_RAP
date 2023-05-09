@AbapCatalog.sqlViewName: 'ZKECDSIVPRODUCT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for PRODUCT'
define view ZKE_CDS_IV_PRODUCT as select from zke_product
{
    key product_id as ProductId,
    name as Name,
    category as Category,
    price as Price,
    currency as Currency,
    discount as Discount
}
