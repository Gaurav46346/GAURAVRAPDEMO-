@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Booking Cube'
@Metadata.ignorePropagatedAnnotations: true

@Analytics.dataCategory: #CUBE
@Analytics.internalName: #LOCAL


define view entity ZRAP_BookingCube_GAU
  as select from ZI_RAP_Booking_GAU

  association [0..1] to ZI_RAP_CUSTOMER_GAU   as _Customer   on  $projection.CustomerID = _Customer.CustomerId  
  association [0..1] to ZI_RAP_Carrier_GAU    as _Carrier    on  $projection.AirlineID = _Carrier.CarrierId

  association [0..1] to ZI_RAP_CONNECTION_GAU as _Connection on  $projection.AirlineID    = _Connection.CarrierId
                                                                 and $projection.ConnectionId = _Connection.ConnectionId

  association [0..1] to ZI_RAP_Agency_GAU     as _Agency     on  $projection.AgencyID = _Agency.AgencyId

{
  key TravelID,
  key BookingID,
      BookingDate,
      @ObjectModel.foreignKey.association: '_Customer'
      CustomerID,
      @ObjectModel.foreignKey.association: '_Carrier'
      AirlineID,
      @ObjectModel.foreignKey.association: '_Connection'
      ConnectionID          as ConnectionId,
      FlightDate,
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      FlightPrice,
      CurrencyCode,
      @ObjectModel.foreignKey.association: '_Agency'
      AgencyID,

      @ObjectModel.foreignKey.association: '_CustomerCountry'
      _Customer.CountryCode as CustomerCountry,
      _Customer.City        as CustomerCity,
      _Connection.Trip      as Trip,

      /* Measures */

      @EndUserText.label: 'Total of Bookings'
      @Aggregation.default: #SUM
      1                     as TotalOfBookings,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @Aggregation.default: #SUM
      FlightPrice,


      /* Associations */
      _Carrier,
      _Connection,
      _Customer,
      _Travel,
      _Agency,
      _Customer._Country    as _CustomerCountry
}
