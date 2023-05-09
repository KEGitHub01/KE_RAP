@AbapCatalog.sqlViewName: 'ZKECDSSOSAMPLE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS FOR SALES ORDER'
define root view ZKE_CDS_SO_SAMPLE as select from zke_so_sample
{
   @EndUserText.label: 'Sales Order Id'
@UI.facet: [{
type: #IDENTIFICATION_REFERENCE,
label: 'Sales Order',
purpose: #STANDARD
}]
@UI.identification: [{position: 1 }]
key so_id as SoId,
@EndUserText.label: 'Customer'
@UI.identification: [{position: 2 }]
customer as Customer,
@EndUserText.label: 'Amount'
@UI.identification: [{position: 3 }]
gross_amount as GrossAmount,
@EndUserText.label: 'Currency'
@UI.identification: [{position: 4 }]
currency_code as CurrencyCode,
@UI.identification: [{position: 5 }]
@EndUserText.label: 'Sales Org'
sales_org as SalesOrg
} 
