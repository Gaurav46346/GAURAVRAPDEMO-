@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel BO view'
define root view entity ZI_RAP_TRAVEL_GAUR
  as select from zrap_travel_gau as Travel

  composition [0..*] of ZI_RAP_BOOKING_GAUR as _Booking

  association [0..1] to /DMO/I_Agency      as _Agency   on $projection.AgencyId = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer    as _Customer on $projection.CustomerId = _Customer.CustomerID
  association [0..1] to I_Currency         as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  key travel_uuid        as TravelUuid,
      travel_id          as TravelId,
      agency_id          as AgencyId,
      customer_id        as CustomerId,
      begin_date         as BeginDate,
      end_date           as EndDate,
      booking_fee        as BookingFee,
      total_price        as TotalPrice,
      currency_code      as CurrencyCode,
      description        as Description,
      status             as Status,
      createdby          as CreatedBy,
      createdat          as CreatedAt,
      lastchangedby      as LastChangedBy,
      lastchangedat      as LastChangedAt,
      locallastchangedat as LocalLastChangedAt,

      /* associations */
      _Booking,
      _Agency,
      _Customer,
      _Currency
}
