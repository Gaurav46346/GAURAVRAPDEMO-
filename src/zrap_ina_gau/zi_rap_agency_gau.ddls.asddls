@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dimension for Agency'
@Metadata.ignorePropagatedAnnotations: true

@Analytics.dataCategory: #DIMENSION
@Analytics.internalName: #LOCAL
@ObjectModel.representativeKey: 'AgencyId'

define view entity ZI_RAP_Agency_GAU
  as select from /dmo/agency
{
      @ObjectModel.text.element: ['Name']
  key agency_id    as AgencyId,
      name         as Name,
      street       as Street,
      postal_code  as PostalCode,
      city         as City,
      country_code as CountryCode,
      phone_number as PhoneNumber
      //    ,
      //    email_address as EmailAddress,
      //    web_address as WebAddress
}
