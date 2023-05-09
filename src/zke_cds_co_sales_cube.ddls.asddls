@AbapCatalog.sqlViewName: 'ZKECOSALESCUBE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COMPOSITE VIEW, CUBE'
define view ZKE_CDS_CO_SALES_CUBE as select from ZKE_CDS_IV_SOH 
association[1] to ZKE_CDS_IV_BP as _BP
on $projection.Buyer = _BP.BpId
association[1] to ZKE_CDS_IV_PRODUCT as _PROD
on $projection.Product =  _PROD.ProductId
{
    key ZKE_CDS_IV_SOH.OrderId,
    key ZKE_CDS_IV_SOH._Item.item_id as ItemID,
    ZKE_CDS_IV_SOH.OrderNo,
    ZKE_CDS_IV_SOH.Buyer,
    ZKE_CDS_IV_SOH.CurrencyCode,
    /* Associations */
    ZKE_CDS_IV_SOH._Item.product as Product,
    ZKE_CDS_IV_SOH._Item.amount as GrossAmount,
    ZKE_CDS_IV_SOH._Item.currency as Currency,
    ZKE_CDS_IV_SOH._Item.qty as Quantity,
    ZKE_CDS_IV_SOH._Item.uom as UnitOfMeasure,
   _BP,
   _PROD
}
