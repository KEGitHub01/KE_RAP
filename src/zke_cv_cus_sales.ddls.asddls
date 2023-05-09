@AbapCatalog.sqlViewName: 'ZKECVCUSSALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION VIEW OF TOTAL SALES'
define view ZKE_CV_CUS_SALES as select from  ZKE_CDS_CO_SALES_CUBE

{ 
   ZKE_CDS_CO_SALES_CUBE._BP.CompanyName as companyName,
    ZKE_CDS_CO_SALES_CUBE._BP.Country as Country,
    sum(GrossAmount) as Total_Amount,
   sum (Quantity) as Total_Quantity


}
group by _BP.CompanyName, _BP.Country
