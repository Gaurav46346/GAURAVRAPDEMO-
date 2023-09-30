CLASS zcl_ce_flightdemo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ce_flightdemo IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested(  ).

      DATA(lv_size) = io_request->get_paging( )->get_page_size( ).

      "Get Filter details
      DATA(lv_condition) = io_request->get_filter( )->get_as_sql_string( ).

      "Get Sorting Details
      DATA(lt_sort) = io_request->get_sort_elements(  ).

      DATA lv_orderby TYPE string.

      LOOP AT lt_sort INTO DATA(ls_sort).
        IF ls_sort-descending = abap_true.
          lv_orderby = |{ lv_orderby } { ls_sort-element_name } DESCENDING |.
        ELSE.
          lv_orderby = |{ lv_orderby } { ls_sort-element_name } ASCENDING |.
        ENDIF.
      ENDLOOP.

      IF  lv_orderby IS INITIAL.
        lv_orderby = 'CARRIER_ID'.
      ENDIF.

      "Fetch Data
      SELECT FROM /dmo/flight
      FIELDS carrier_id, connection_id, flight_date, price, currency_code, plane_type_id, seats_max, seats_occupied
      WHERE (lv_condition)
      ORDER BY (lv_orderby)
      INTO TABLE @DATA(lt_flight) UP TO @lv_size ROWS.

      IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( lines( lt_flight ) ).
      ENDIF.
      io_response->set_data( lt_flight ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
