@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consuption for qc label'
@Metadata.allowExtensions: true
define root view entity ZC_QC_LABEL as projection on ZI_QC_LABEL
{
    key InspectionLot,
    Material,
    Batch,
    ProductDescription,
    base64,
    m_ind
}
