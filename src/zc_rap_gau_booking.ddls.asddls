@EndUserText.label: 'Booking Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_RAP_GAU_BOOKING
  as projection on ZI_RAP_GAU_BOOKING
{
  key BookingUuid,
      TravelUuid,
      @Search.defaultSearchElement: true
      BookingId,
      BookingDate,
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID' } }]
      CustomerId,
      @ObjectModel.text.element: [ 'CarrierName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Carrier', element: 'AirlineID' } }]
      CarrierId,
      _Carrier.Name as CarrierName,
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                          additionalBinding: [{ localElement: 'CarrierId' , element: 'AirlineID' },
                                                              { localElement: 'FlightDate', element: 'FlightDate' },
                                                              { localElement: 'FlightPrice', element: 'Price' },
                                                              { localElement: 'CurrencyCode', element: 'CurrencyCode' } ]
                                                         } ]
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }]
      CurrencyCode,
      //      Createdby,
      //      Createdat,
      //      Lastchangedby,
      //      Lastchangedat,
      LocalLastChangedAt,
      /* Associations */
      _Carrier,
      _Connection,
      _Currency,
      _Customer,
      _Flight,
      _Travel : redirected to parent ZC_RAP_GAU_TRAVEL
}
