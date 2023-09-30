CLASS zcl_generate_data_gau DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generate_data_gau IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "Delete Existing entries
    DELETE FROM zrap_travel_gau.
    DELETE FROM zrap_booking_gau.

    "Insert from Demo Tables

    INSERT zrap_travel_gau FROM (
    SELECT FROM /dmo/travel
    FIELDS
    uuid( ) AS travel_uuid,
    travel_id  AS travel_id ,
      agency_id    AS agency_id,
      customer_id  AS customer_id,
      begin_date   AS begin_date,
      end_date     AS end_date,
      booking_fee  AS booking_fee,
      total_price  AS total_price,
      currency_code AS currency_code,
      description AS description,
      CASE status
      WHEN 'B' THEN 'A' "accepted
      WHEN 'P' THEN 'C' "cancelled
      ELSE 'O' END,     "open
      createdby     AS created_by            ,
         createdat     AS createdat            ,
         lastchangedby AS lastchangedby       ,
         lastchangedat AS lastchangedat       ,
         lastchangedat AS locallastchangedat
         ORDER BY travel_id UP TO 200 ROWS

    ).
    COMMIT WORK.

    INSERT zrap_booking_gau FROM (
    SELECT FROM /dmo/booking AS a
                JOIN zrap_travel_gau AS b
                ON a~travel_id = b~travel_id
           FIELDS
           uuid(  ) AS booking_uuid,
           b~travel_uuid AS travel_uuid,
           a~booking_id AS bookingid,
           a~booking_date AS booking_date,
           a~customer_id AS customer_id,
           a~carrier_id AS carrier_id,
           a~connection_id AS connection_id,
           a~flight_date AS flight_date,
           a~flight_price AS flight_price,
           a~currency_code AS currency_code,
           b~createdby AS createdby,
           b~createdat AS createdat,
           b~lastchangedby AS lastchangedby,
           b~lastchangedat AS lastchangedat,
           b~locallastchangedat AS locallastchangedat


     ).
    COMMIT WORK.
    out->write( 'Travel and Booking data Inserted Successfully.' ).
  ENDMETHOD.
ENDCLASS.
