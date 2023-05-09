@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'First Child Entity of Travel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKE_M_BOOKING as select from /dmo/booking as Booking
association to parent ZKE_M_TRAVEL as Travel on
$projection.TravelId = Travel.TravelId
association[1..1] to /DMO/I_Customer as Customer on
$projection.CustomerId = Customer.CustomerID
association[1..1] to /DMO/I_Carrier as Carrier on
$projection.CarrierId = Carrier.AirlineID
association[1..1] to /DMO/I_Connection as Connection on
$projection.CarrierId = Connection.AirlineID and 
$projection.ConnectionId = Connection.ConnectionID
{
    key Booking.travel_id as TravelId,
    key Booking.booking_id as BookingId,
    Booking.booking_date as BookingDate,
    Booking.customer_id as CustomerId,
    Booking.carrier_id as CarrierId,
    Booking.connection_id as ConnectionId,
    Booking.flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Booking.flight_price as FlightPrice,
    Booking.currency_code as CurrencyCode,
    @UI.hidden: true
    Travel.Lastchangedat as lastChangeAT,
    Carrier,
    Customer,
    Connection,
    Travel
}
