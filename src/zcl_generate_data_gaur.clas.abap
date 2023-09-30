CLASS zcl_generate_data_gaur DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generate_data_gaur IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "Insert Travel Data
    INSERT zrap_travel_gaur FROM (
    SELECT FROM /dmo/travel
    FIELDS
      uuid(  ) AS travel_uuid,
      travel_id AS travel_id,
      agency_id  AS agency_id,
    customer_id  AS customer_id,
    begin_date  AS begin_date,
    end_date    AS end_date,
    booking_fee  AS booking_fee,
    total_price    AS total_price,
    currency_code  AS currency_code,
    description    AS description,
    CASE status
    WHEN 'B' THEN 'A' "Accepted
    WHEN 'N' THEN 'X' "cancelled
    WHEN 'P' THEN 'O' "Open
    END AS status,
    createdby      AS createdby,
    createdat      AS createdat,
    lastchangedby  AS lastchangedby,
    lastchangedat  AS lastchangedat,
    lastchangedat AS locallastchangedat
    ORDER BY travel_id UP TO 250 ROWS
     ).

    COMMIT WORK.

    "Insert Booking Data
    INSERT zrap_book_gaur FROM (
    SELECT FROM /dmo/booking AS b
           JOIN  zrap_travel_gaur AS a
           ON a~travel_id = b~travel_id
     FIELDS
        uuid(  )  AS booking_uuid,
        a~travel_uuid AS travel_uuid,
          booking_id     AS booking_id,
          booking_date   AS booking_date,
          b~customer_id    AS customer_id,
          carrier_id    AS carrier_id,
          connection_id   AS connection_id,
          flight_date     AS flight_date,
          flight_price    AS flight_price,
          b~currency_code   AS currency_code,
          a~createdby      AS createdby,
            a~createdat      AS createdat,
            a~lastchangedby  AS lastchangedby,
            a~lastchangedat  AS lastchangedat,
            a~lastchangedat AS locallastchangedat

    ).
    COMMIT WORK.

    out->write( 'Data Insereted Successfully !' ).
  ENDMETHOD.
ENDCLASS.
