@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS ENTITY FOR customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKE_UM_CUSTOMER as select from /dmo/customer as Customer
association to I_Country as _Country
on $projection.CountryCode = _Country.Country
{
    key Customer.customer_id as CustomerId,
    concat(concat(title, concat('',first_name)),concat('',last_name)) as CustomerName,
    Customer.street as Street,
    Customer.postal_code as PostalCode,
    Customer.city as City,
    Customer.country_code as CountryCode,
    Customer.phone_number as PhoneNumber,
    Customer.email_address as EmailAddress,
    _Country

}
