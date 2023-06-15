@EndUserText.label: 'Approver CDS for Travel'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo:{
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title : { type : #STANDARD, value : 'TravelId'},
    description : { type : #STANDARD, value : 'Description'}
    }
    
 @Search.searchable: true
define root view entity ZKE_M_TRAVEL_APPROVER as projection on ZKE_M_TRAVEL
{
     @UI.facet: [{
                    id : 'Travel',
                    purpose : #STANDARD,
                    type : #IDENTIFICATION_REFERENCE,
                    label: 'Travel',
                    position: 10
     },
     {
        id: 'Booking',
        purpose:#STANDARD,
        type: #LINEITEM_REFERENCE,
        label:'Booking',
        position: 20,
        targetElement: 'Booking'
     }]
     @UI: {
           selectionField: [{position: 10 }],
           lineItem: [{position: 10 }],
           identification: [{position: 10 }]
            }
     @Search.defaultSearchElement: true
     @ObjectModel.text.element: ['Description']
    key TravelId,
     @UI: {
           selectionField: [{position: 20}],
           lineItem: [{position: 20 }],
           identification: [{position: 20 }]
            }
     @Consumption.valueHelpDefinition: [{entity:{name: '/DMO/I_Agency',element: 'AgencyID'}}]
     @ObjectModel.text.element: ['AgencyName']
    AgencyId,
    _Agency.Name as AgencyName,
     @UI: {
           selectionField: [{position: 30 }],
           lineItem: [{position: 30 }],
           identification: [{position: 30 }]
            }
     @Consumption.valueHelpDefinition: [{entity:{name: '/DMO/I_Customer',element: 'CustomerID'}}]
     @ObjectModel.text.element: ['CustomerName']
    CustomerId,
    _Customer.FirstName as CustomerName,
         @UI: {
           lineItem: [{position: 40 }],
           identification: [{position: 40 }]
            }
    BeginDate,
    @UI.identification: [{position: 50 }]
    EndDate,
      @UI.identification: [{position: 60 }]
       @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
         @UI: {
           lineItem: [{position: 50 }],
           identification: [{position: 70 }]
            }
         @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
      @UI.identification: [{position: 80 }]
       @Consumption.valueHelpDefinition: [{entity:{name: 'I_Currency',element: 'Currency'}}]
    CurrencyCode,
      @UI.identification: [{position: 11 }]
    Description,
      @UI.lineItem: [{position: 90 , label: 'CreateCopy'},
                        {type: #FOR_ACTION, label:'Accept', dataAction: 'acceptTravel'},
                       {type: #FOR_ACTION, label:'Reject', dataAction: 'rejectTravel'} ]
      @UI.identification: [{position: 90 , label: 'status [O-open,A-Accepted,X-Rejected]'},
                         {type: #FOR_ACTION, label:'Accept', dataAction: 'acceptTravel'},
                          {type: #FOR_ACTION, label:'Reject', dataAction: 'rejectTravel'}]
    Status,
    Createdby,
    Createdat,
    Lastchangedby,
    @UI.hidden: true
    Lastchangedat,
    /* Associations */
    Booking : redirected to composition child ZKE_M_BOOKING_APPROVER,
    _Agency,
    _Currency,
    _Customer
}
