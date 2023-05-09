@AbapCatalog.sqlViewName: 'ZKECDSIVSOH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for SALES ORDER HEADER'
define view ZKE_CDS_IV_SOH as select from zke_so_hdr as HDR
association[1] to zke_so_item as _Item 
on $projection.OrderId = _Item.order_id
association[1] to I_Currency as _Currency
on $projection.CurrencyCode = _Currency.Currency
{
    key HDR.order_id as OrderId,
    HDR.order_no as OrderNo,
    HDR.buyer as Buyer,
    HDR.gross_amount as GrossAmount,
    HDR.currency_code as CurrencyCode,
    HDR.created_by as CreatedBy,
    HDR.created_on as CreatedOn,
    HDR.changed_by as ChangedBy,
    HDR.changed_on as ChangedOn,
    _Item,
    _Currency._Text[Language = $session.system_language].CurrencyShortName
}
