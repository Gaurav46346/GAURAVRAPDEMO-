@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_RAP_TRAVELGAURD'
define root view entity ZC_RAP_TRAVELGAURD
  provider contract transactional_query
  as projection on ZR_RAP_TRAVELGAURD
{
  key TravelUUID,
  TravelID,
  AgencyID,
  CustomerID,
  BeginDate,
  EndDate,
  BookingFee,
  TotalPrice,
  CurrencyCode,
  Description,
  Status,
  Locallastchangedat
  
}
