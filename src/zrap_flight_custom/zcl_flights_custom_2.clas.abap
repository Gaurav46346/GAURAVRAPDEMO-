CLASS zcl_flights_custom_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_flights_custom_2 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      SELECT FROM /dmo/flight
        FIELDS carrier_id, connection_id, flight_date, price, currency_code, plane_type_id, seats_max, seats_occupied
        INTO TABLE @DATA(flights) UP TO 10 ROWS.

      IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( lines( flights ) ).
        io_response->set_data( flights ).
      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
