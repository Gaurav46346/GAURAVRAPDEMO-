@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Query for Booking'


@Analytics.query: true


define view entity ZC_RAP_BOOKINGQUERY_GAU as select from ZRAP_BookingCube_GAU {
@AnalyticsDetails.query.axis: #ROWS
key TravelID,
@AnalyticsDetails.query.axis: #ROWS
key BookingID,
@AnalyticsDetails.query.axis: #ROWS
BookingDate,
@AnalyticsDetails.query.axis: #ROWS
CustomerID,
@AnalyticsDetails.query.axis: #ROWS
AirlineID,
@AnalyticsDetails.query.axis: #ROWS
ConnectionId,
@AnalyticsDetails.query.axis: #ROWS
FlightDate,
@AnalyticsDetails.query.axis: #ROWS
CurrencyCode,
@AnalyticsDetails.query.axis: #ROWS
AgencyID,
@AnalyticsDetails.query.axis: #COLUMNS
CustomerCountry,
@AnalyticsDetails.query.axis: #ROWS
CustomerCity,
@AnalyticsDetails.query.axis: #ROWS
Trip,


  TotalOfBookings,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  currency_conversion (
  amount => FlightPrice,
  source_currency => CurrencyCode,
  target_currency => cast( 'EUR' as abap.cuky( 5 ) ) ,
  exchange_rate_date => cast ('20200101' as abap.dats),
  exchange_rate_type => 'M'
  ) as FlightPrice    

}
