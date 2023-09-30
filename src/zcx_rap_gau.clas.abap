CLASS zcx_rap_gau DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    CONSTANTS:
      BEGIN OF date_int,
        msgid TYPE symsgid VALUE 'ZRAP_GAU',
        msgno TYPE symsgno VALUE '001',
        attr1  TYPE scx_attrname VALUE 'ENDDATE',
        attr2  TYPE scx_attrname VALUE 'BEGINDATE',
        attr3 TYPE scx_attrname VALUE ' ',
        attr4 TYPE scx_attrname VALUE ' ',
      END OF date_int,

      BEGIN OF agency_unknown,
        msgid TYPE symsgid VALUE 'ZRAP_GAU',
        msgno TYPE symsgno VALUE '002',
        att1  TYPE scx_attrname VALUE 'AGENCYID',
        att2  TYPE scx_attrname VALUE ' ',
        attr3 TYPE scx_attrname VALUE ' ',
      END OF agency_unknown,

      BEGIN OF noauth,
        msgid TYPE symsgid VALUE 'ZRAP_GAU',
        msgno TYPE symsgno VALUE '003',
        att1  TYPE scx_attrname VALUE ' ',
        att2  TYPE scx_attrname VALUE ' ',
        attr3 TYPE scx_attrname VALUE ' ',
      END OF noauth.


    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        severity TYPE if_abap_behv_message=>t_severity
*        textid   LIKE if_t100_message=>default_textid OPTIONAL
        enddate TYPE /dmo/end_date OPTIONAL
        begindate TYPE /dmo/begin_date OPTIONAL
        agencyid TYPE  /dmo/agency_id OPTIONAL.

   DATA:
       enddate TYPE /dmo/end_date READ-ONLY,
       begindate TYPE /dmo/begin_date READ-ONLY,
       agencyid TYPE string READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_rap_gau IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->agencyid = | { agencyid ALPHA = OUT } |.
    me->enddate = enddate.
    me->begindate = begindate.
    me->if_abap_behv_message~m_severity = severity.
  ENDMETHOD.


ENDCLASS.
