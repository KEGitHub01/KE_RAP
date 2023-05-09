@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS ENTITY FOR SALES'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKE_CDS_CO_SLS_ENT as select from ZKE_CDS_IV_SOH 
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
    @Semantics.amount.currencyCode: 'Currency'
    ZKE_CDS_IV_SOH._Item.amount as GrossAmount,
    ZKE_CDS_IV_SOH._Item.currency as Currency,
    @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
    ZKE_CDS_IV_SOH._Item.qty as Quantity,
    ZKE_CDS_IV_SOH._Item.uom as UnitOfMeasure,
   _BP,
   _PROD
}
