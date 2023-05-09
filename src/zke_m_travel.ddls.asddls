@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MANAGED SCENARIO OF ROOT ENTITY'
define root view entity ZKE_M_TRAVEL as select from /dmo/travel as _Travel
composition[0..*] of ZKE_M_BOOKING as Booking
association[1] to /DMO/I_Agency as _Agency
on $projection.AgencyId = _Agency.AgencyID
association[1] to /DMO/I_Customer as _Customer
on $projection.CustomerId = _Customer.CustomerID
association[1] to I_Currency as _Currency
on $projection.CurrencyCode = _Currency.Currency
{
    key _Travel.travel_id as TravelId,
    _Travel.agency_id as AgencyId,
    _Travel.customer_id as CustomerId,
    _Travel.begin_date as BeginDate,
    _Travel.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    _Travel.booking_fee as BookingFee,
     @Semantics.amount.currencyCode: 'CurrencyCode'
    _Travel.total_price as TotalPrice,
    _Travel.currency_code as CurrencyCode,
    _Travel.description as Description,
    _Travel.status as Status,
    @Semantics.user.createdBy: true
    _Travel.createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    _Travel.createdat as Createdat,
    @Semantics.user.lastChangedBy: true
    _Travel.lastchangedby as Lastchangedby,
        @Semantics.systemDateTime.lastChangedAt: true
    _Travel.lastchangedat as Lastchangedat,
    _Agency ,
    _Customer,
    _Currency,
    Booking
}
