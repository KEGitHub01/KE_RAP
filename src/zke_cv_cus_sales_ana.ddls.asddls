@AbapCatalog.sqlViewName: 'ZKECVCUSSALESANA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final CDS view on top of consumptionV'
define view ZKE_CV_CUS_SALES_ANA as select from ZKE_CV_CUS_SALES
association[1] to ZKE_TABLE_FUNCTION as _TotalSales on
$projection.companyName = _TotalSales.company_name
{
    ZKE_CV_CUS_SALES.companyName,
    ZKE_CV_CUS_SALES.Country,
    ZKE_CV_CUS_SALES.Total_Amount,
    ZKE_CV_CUS_SALES.Total_Quantity,
    _TotalSales(p_client: $session.client).customer_rank
}
