@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for qc label'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_QC_LABEL_VH as select from I_InspectionLot as a
      left outer join I_ProductDescription        as c on a.Material = c.Product
{
    key a.InspectionLot,
    a.Material,
    a.Batch,
    c.ProductDescription
   
}
