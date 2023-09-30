CLASS zcl_rap_eml_3337 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rap_eml_3337 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    SELECT * FROM zi_rap_gau_travel ORDER BY TravelId
*    INTO TABLE @DATA(lt_travel) UP TO 10 ROWS
*    .
**    SELECT FROM zi_rap_gau_travel
**    FIELDS
*
**    out->write( lt_travel ).
*
**    READ ENTITIES OF zi_rap_gau_travel
**    ENTITY travel BY \_Booking
***    FIELDS ( TravelId AgencyId CustomerId )
**    ALL FIELDS
**    WITH VALUE #( ( TravelUuid = 'A23B29209E3ED99E180035A67BF6E95B' ) )
**    RESULT DATA(lt_travels).
**    out->write( lt_travels ).
*
*    READ ENTITIES OF zi_rap_gau_travel
*    ENTITY travel
**    BY \_Booking
*    ALL FIELDS
*    WITH VALUE #( ( TravelUuid = 'A23B29209E3ED99E180035A67BF6E95B' ) )
**    WITH VALUE #( ( TravelUuid = '11111111111111111111111111111111' ) )
*    RESULT DATA(travels)
*    FAILED DATA(failed)
*    REPORTED DATA(reported).
**    out->write( 'Before' ).
*    out->write( travels ).
**    MODIFY ENTITIES OF zi_rap_gau_travel
**    ENTITY Travel
**    UPDATE SET FIELDS WITH VALUE #( ( TravelUuid = 'A23B29209E3ED99E180035A67BF6E95B' Description = 'My Vacation' )  ).
**
**    COMMIT ENTITIES
**     RESPONSE OF zi_rap_gau_travel
**     FAILED DATA(commit).
**
**    out->write( 'After' ).
**    out->write( travels ).
**    out->write( failed ).
**    out->write( reported ).

DATA: lv_int TYPE ztype_int4.

lv_int = 120.

out->write( lv_int ).

  ENDMETHOD.
ENDCLASS.
