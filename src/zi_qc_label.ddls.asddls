@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface for qc label'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_QC_LABEL as select from I_InspectionLot as a
    left outer join ztb_qc_label        as b on a.InspectionLot = b.inspectionlot
      left outer join I_ProductDescription        as c on a.Material = c.Product
{
    key a.InspectionLot,
    a.Material,
    a.Batch,
    c.ProductDescription,
          b.base64_3 as base64,
      b.m_ind
   
}
