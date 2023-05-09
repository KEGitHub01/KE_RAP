@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity for Travel (root of BO)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}@Metadata.allowExtensions: true
define root view entity ZKE_UM_TRAVEL as select from /dmo/travel as Travel
association to ZKE_UM_AGENCY as Agency 
on $projection.AgencyId = Agency.AgencyId
association to ZKE_UM_CUSTOMER as Customer
on $projection.CustomerId = Customer.CustomerId
association to I_Currency as _Currency
on $projection.CurrencyCode = _Currency.Currency
association[1..1] to /DMO/I_Travel_Status_VH as _Status
on $projection.Status = _Status.TravelStatus
{
    @ObjectModel.text.element: ['Description']
   key Travel.travel_id as TravelId,
       @Consumption.valueHelpDefinition: [{entity: {name: 'ZKE_UM_AGENCY', element:'AgencyId'}}]
       @ObjectModel.text.element: ['AgencyName']
   Travel.agency_id as AgencyId,
   Agency.Name as AgencyName,
       @Consumption.valueHelpDefinition: [{entity: {name: 'ZKE_UM_CUSTOMER', element:'CustomerId'}}]
       @ObjectModel.text.element: ['CustomerName']
   Travel.customer_id as CustomerId,
   Customer.CustomerName as CustomerName,
   Travel.begin_date as BeginDate,
    @ObjectModel.text.element: ['TravelStatus']
   @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Travel_Status_VH', element:'TravelStatus'}}]
   Travel.status as Status,
   _Status._Text[Language = $session.system_language].TravelStatus as TravelStatus,
   Travel.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
   Travel.booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
   Travel.total_price as TotalPrice,
   Travel.currency_code as CurrencyCode,
   Travel.description as Description,  
   Travel.createdby as Createdby,
   Travel.createdat as Createdat,
   Travel.lastchangedby as Lastchangedby,
   Travel.lastchangedat as Lastchangedat,
   Agency,
   Customer,
   _Currency,
   _Status
}
