@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view entity, scalar func'

define view entity ZCDS_SCALAR_DEMO_FLIGHT
  as select from /dmo/flight
{
  key carrier_id             as Carrid,
  key connection_id             as Connid,
  key flight_date             as Fldate,
      seats_occupied           as BookedSeats,
      seats_max           as TotalSears,
      ZCDS_SCALAR_FUNCTION(
      portion => seats_occupied,
      total => seats_max ) as OccupationRatio
}
