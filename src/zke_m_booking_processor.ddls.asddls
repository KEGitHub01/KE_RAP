@EndUserText.label: 'PROJECTION ON BOOKING PROCESSOR'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo:{
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title : { value : 'BookingId'}
    }
    
 @Search.searchable: true
define view entity ZKE_M_BOOKING_PROCESSOR as projection on ZKE_M_BOOKING
{
    @UI.facet: [{
                id : 'Booking',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Booking',
                position: 10
         }]

    @Search.defaultSearchElement: true
    key TravelId,
        @UI: { lineItem: [{ position: 10}],
             identification : [{position : 10}]
        }
        @Search.defaultSearchElement: true
    key BookingId,
       @UI: { lineItem: [{ position: 20}],
             identification : [{position : 20}]
        }
    BookingDate,
       @UI: { lineItem: [{ position: 30}],
             identification : [{position : 30}]
        }
       @Consumption.valueHelpDefinition: [{entity:{name: '/DMO/I_Customer',element: 'CustomerId'}}]    
    CustomerId,
       @UI: { lineItem: [{ position: 40}],
             identification : [{position : 40}]
        }
       @Consumption.valueHelpDefinition: [{entity:{name: '/DMO/I_Carrier',element: 'AirlineID'}}]
         @ObjectModel.text.element: ['AirlineName']
    CarrierId,
    Carrier.Name as AirlineName,
        @UI: { lineItem: [{ position: 50}],
             identification : [{position : 50}]
        }
       @Consumption.valueHelpDefinition: [{entity:{name: '/DMO/I_Flight',element: 'ConnectionID'},
                                           additionalBinding: [{localElement: 'FlightDate',element: 'FlightDate'},
                                           {localElement: 'CarrierId',element: 'AirlineID'},
                                           {localElement: 'FlightDate',element: 'Price'},
                                           {localElement: 'CurrencyCode',element: 'CurrencyCode'}]
       }]      
  
    ConnectionId,
        @UI: { lineItem: [{ position: 60}],
             identification : [{position : 60}]
        }
          @Consumption.valueHelpDefinition: [{entity:{name: '/DMO/I_Flight',element: 'FlightDate'},
                                           additionalBinding: [{localElement: 'ConnectionId',element: 'ConnectionID'},
                                           {localElement: 'CarrierId',element: 'AirlineID'},
                                           {localElement: 'FlightDate',element: 'Price'},
                                           {localElement: 'CurrencyCode',element: 'CurrencyCode'}]
       }]        
    FlightDate,
        @UI: { lineItem: [{ position: 70}],
             identification : [{position : 70}]
        }
     @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
        @UI: { lineItem: [{ position: 80}],
             identification : [{position : 80}]
        }
    CurrencyCode,
    @UI.hidden: true
    lastChangeAT,
    /* Associations */
    Carrier,
    Connection,
    Customer,
    Travel : redirected to parent ZKE_M_TRAVEL_PROCESSOR
}
