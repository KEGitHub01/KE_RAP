@AbapCatalog.sqlViewName: 'ZKECVPRODSALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total sales per Product'
define view ZKE_CV_PROD_SALES as select from ZKE_CDS_CO_SALES_CUBE
{
    ZKE_CDS_CO_SALES_CUBE._PROD.Name,
    sum(GrossAmount) as Total_Amount,  
    sum(Quantity) as Total_Quantity

}
group by _PROD.Name
