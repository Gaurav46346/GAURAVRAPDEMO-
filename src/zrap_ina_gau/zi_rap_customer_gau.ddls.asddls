@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Customer Dimension'
@Metadata.ignorePropagatedAnnotations: true

@Analytics.dataCategory: #DIMENSION
@Analytics.internalName: #LOCAL
@ObjectModel.representativeKey: 'CustomerId'

define view entity ZI_RAP_CUSTOMER_GAU
  as select from /dmo/customer
  association [1] to I_Country as _Country on $projection.CountryCode = _Country.Country
{

      @ObjectModel.text.element: ['CustomerName']
  key customer_id                                  as CustomerId,
      first_name                                   as FirstName,
      last_name                                    as LastName,
      concat_with_space(first_name, last_name, 10) as CustomerName,
      title                                        as Title,
      street                                       as Street,
      postal_code                                  as PostalCode,
      city                                         as City,
      country_code                                 as CountryCode,
      phone_number                                 as PhoneNumber,
      // email_address as EmailAddress,
      // local_created_by as LocalCreatedBy,
      // local_created_at as LocalCreatedAt,
      // local_last_changed_by as LocalLastChangedBy,
      // local_last_changed_at as LocalLastChangedAt,
      // last_changed_at as LastChangedAt
      // Association
      _Country
}
