@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS ENTITY FOR Agency'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKE_UM_AGENCY as select from /dmo/agency as Agency
association to I_Country as _country
on $projection.CountryCode = _country.Country
{
    key Agency.agency_id as AgencyId,
    Agency.name as Name,
    Agency.street as Street,
    Agency.postal_code as PostalCode,
    Agency.city as City,
    Agency.country_code as CountryCode,
    Agency.phone_number as PhoneNumber,
    Agency.email_address as EmailAddress,
    Agency.web_address as WebAddress,
    _country

  
}
