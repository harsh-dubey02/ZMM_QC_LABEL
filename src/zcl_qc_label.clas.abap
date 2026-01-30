
CLASS zcl_qc_label DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_pdf_64
      IMPORTING
                VALUE(io_inspectionlot) TYPE  i_inspectionlot-inspectionlot    "<-write your input name and type
      RETURNING VALUE(pdf_64)              TYPE string..

  PRIVATE SECTION.

    METHODS build_xml
      IMPORTING
        VALUE(io_inspectionlot) TYPE  i_inspectionlot-inspectionlot  "<-write your input name and type
      RETURNING
        VALUE(rv_xml)              TYPE string.
ENDCLASS.



CLASS ZCL_QC_LABEL IMPLEMENTATION.


  METHOD get_pdf_64.

    DATA(lv_xml) = build_xml(
                      io_inspectionlot   = io_inspectionlot ).    "<-write your input name

    IF lv_xml IS INITIAL.
      RETURN.
    ENDIF.

    CALL METHOD zadobe_ads_class=>getpdf
      EXPORTING
        template = 'zqc_label/zqc_label'     "<-write your template and schema name
        xmldata  = lv_xml
      RECEIVING
        result   = DATA(lv_result).

    IF lv_result IS NOT INITIAL.
      pdf_64 = lv_result.
    ENDIF.

  ENDMETHOD.


  METHOD build_xml.


DATA: lv_user_name TYPE string ,
      gv_show_grn type string,
      gv_materialdocument type string,
      lv_stat(1000) type c.

TRY.
    lv_user_name = cl_abap_context_info=>get_user_formatted_name( ).
  CATCH cx_abap_context_info_error.
    lv_user_name = sy-uname.   " fallback
ENDTRY.



    SELECT SINGLE * FROM i_inspectionlot
    WHERE inspectionlot = @io_inspectionlot
    INTO @DATA(wa_inspec_lot).

    SELECT SINGLE * FROM I_InspLotUsageDecision
    WHERE inspectionlot = @io_inspectionlot
    INTO @DATA(wa_inspec_stat).

    CASE wa_inspec_stat-InspLotUsageDecisionValuation.
  WHEN 'A'.
    lv_stat = 'PASSED'.
  WHEN 'R'.
    lv_stat = 'REJECTED'.
  WHEN OTHERS.
    lv_stat = 'N/A'.
ENDCASE.

SHIFT wa_inspec_lot-InspectionLot LEFT DELETING LEADING '0'.

SELECT SINGLE *
  FROM i_inspectionlot
  WHERE inspectionlot = @io_inspectionlot
  and ( inspectionlottype = '01'
       OR inspectionlottype = '08' )
  INTO @DATA(wa_inspec_lt).

if wa_inspec_lt-MaterialDocument is NOT INITIAL.
 gv_show_grn = wa_inspec_lt-MaterialDocument.
else.
 gv_show_grn = 'N/A'.
ENDIF.

DATA:lv_date TYPE string.

lv_date = |{ sy-datum+6(2) }/{ sy-datum+4(2) }/{ sy-datum(4) }|.

"================ HEADER =================
*DATA(lv_header) =
* |<form1>| &&
* |  <batch>{  wa_inspec_lot-Batch }</batch>| &&
* |  <date>{ lv_date }</date>| &&
* |  <sign></sign>| &&
* |  <passed_reject>{ lv_stat }</passed_reject>| &&
* |  <inspection>{ lv_inspection }</inspection>| &&
* |  <date>{ lv_inspection_date }</date>|.

*DATA(lv_header) =
* |<form1>| &&
* |  <batch>{ wa_inspec_lot-Batch }</batch>| &&
* |  <date>{ lv_date }</date>|.
*
*
*DATA(lv_footer) =
* |  <sign></sign>| &&
* |  <passed_reject>{ lv_stat }</passed_reject>| &&
* |  <inspection>{ wa_inspec_lot-InspectionLot }</inspection>| &&
DATA(lv_header) =
 |<form1>| &&
 |  <batch>{ wa_inspec_lot-Batch }</batch>| &&
 |  <sign></sign>| &&
 |  <passed_reject>{ lv_stat }</passed_reject>| &&
 |  <inspection>{ wa_inspec_lot-InspectionLot }</inspection>| &&
 |  <GRNNO>{ wa_inspec_lt-MaterialDocument }</GRNNO>| &&
 |  <date>{ lv_date }</date>|.
 DATA(lv_footer) =
 |</form1>|.


* |</form1>|.

    rv_xml = lv_header && lv_footer.

  ENDMETHOD.
ENDCLASS.
