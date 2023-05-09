@AbapCatalog.sqlViewName: 'ZKECDSIVBP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for BP'
define view ZKE_CDS_IV_BP as select from zke_bpa
association[1] to I_Country as _Country on
$projection.Country = _Country.Country
{
    key bp_id as BpId,
    bp_role as BpRole,
    company_name as CompanyName,
    country as Country,
    _Country._Text[Language=$session.system_language].CountryName as CountryName

}
