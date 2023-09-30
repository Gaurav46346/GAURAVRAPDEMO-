@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Connection Dimension'
@Metadata.ignorePropagatedAnnotations: true

@Analytics.dataCategory: #DIMENSION
@Analytics.internalName: #LOCAL
@ObjectModel.representativeKey: 'ConnectionId'

define view entity ZI_RAP_CONNECTION_GAU
  as select from /dmo/connection
  association [1] to ZI_RAP_Carrier_GAU as _Carrier on $projection.CarrierId = _Carrier.CarrierId
{
      @ObjectModel.text.element: ['Trip']
      @ObjectModel.foreignKey.association: '_Carrier'
  key carrier_id                                           as CarrierId,
  key connection_id                                        as ConnectionId,
      airport_from_id                                      as AirportFromId,
      airport_to_id                                        as AirportToId,
      concat(airport_from_id, concat('->', airport_to_id)) as Trip,
      departure_time                                       as DepartureTime,
      arrival_time                                         as ArrivalTime,
      distance                                             as Distance,
      distance_unit                                        as DistanceUnit,
      _Carrier
}
