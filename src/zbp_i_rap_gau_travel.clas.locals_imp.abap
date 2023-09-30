CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS setStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~setStatus.
    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.
    METHODS validateAgencyID FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateAgencyID.
    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS action_auth RETURNING VALUE(action_allowed) TYPE abap_boolean.
    METHODS readonly_auth RETURNING VALUE(readonly_allowed) TYPE abap_boolean.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR Travel RESULT result.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
   READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
     ENTITY Travel
     FIELDS ( OverallStatus )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travels).

   result = VALUE #( for travel IN lt_travels
            LET lv_accept = COND #( WHEN travel-OverallStatus = 'A' THEN if_abap_behv=>fc-o-disabled
                                    ELSE if_abap_behv=>fc-o-enabled )
                lv_reject = COND #( WHEN travel-OverallStatus = 'C' THEN if_abap_behv=>fc-o-disabled
                else if_abap_behv=>fc-o-enabled )
                IN ( %tky = travel-%tky
                     %action-acceptTravel = lv_accept
                     %action-rejectTravel = lv_reject ) ).



  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR key IN keys
                  ( %tky          = key-%tky
                    OverallStatus = 'A' )
                ).

    READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
     ENTITY Travel
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travels).

    result = VALUE #( FOR ls_travel IN lt_travels
                      ( %tky   = ls_travel-%tky
                        %param = ls_travel ) ).

  ENDMETHOD.

  METHOD setStatus.
    READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
     ENTITY Travel
     FIELDS ( OverallStatus )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travels).

    DELETE lt_travels WHERE OverallStatus IS NOT INITIAL.

    MODIFY ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
    ENTITY Travel
        UPDATE FIELDS ( OverallStatus )
        WITH VALUE #( FOR ls_travel IN lt_travels
                      ( %tky          = ls_travel-%tky
                        OverallStatus = 'O' ) )
                      REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD validateDates.

    READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
    ENTITY Travel
    FIELDS ( TravelId BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(ls_travel).
      IF ls_travel-EndDate LT ls_travel-BeginDate.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = ls_travel-%tky

                        %msg = NEW ZCX_RAP_GAU( severity = if_abap_behv_message=>severity-error
                                                textid = zcx_rap_gau=>date_int
                                                enddate = ls_travel-EndDate
                                                begindate = ls_travel-BeginDate ) )

        TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.



  METHOD validateAgencyID.
    READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
     ENTITY Travel
     FIELDS ( AgencyId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travels).


    DATA(lt_temp) = lt_travels.
    DELETE lt_temp WHERE AgencyId IS INITIAL.


    IF  lt_temp IS NOT INITIAL.
      SELECT FROM /dmo/agency
      FIELDS agency_id
      FOR ALL ENTRIES IN @lt_temp
      WHERE agency_id = @lt_temp-AgencyId
      INTO TABLE @DATA(lt_agencydb).
    ENDIF.

    LOOP AT lt_travels INTO DATA(ls_travel).

      IF  ls_travel-AgencyId IS INITIAL OR NOT line_exists( lt_agencydb[ agency_id = ls_travel-AgencyId ] ).
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = ls_travel-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Agency ID Unknown' ) )
        TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rejectTravel.

    "Modify Entity with Overall Status as 'C'
    MODIFY ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR key IN keys
                  ( %tky          = key-%tky
                    OverallStatus = 'C' )
                ).

    "Read entity with updated values
    READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
     ENTITY Travel
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travels).

    "Pass into returning parameter
    result = VALUE #( FOR ls_travel IN lt_travels
                      ( %tky   = ls_travel-%tky
                        %param = ls_travel ) ).

  ENDMETHOD.



  METHOD get_instance_authorizations.
    READ ENTITIES OF zi_rap_gau_travel IN LOCAL MODE
      ENTITY Travel
      FIELDS ( OverallStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).
*    CHECK requested_authorizations-%update = if_abap_behv=>mk-on.
     result = VALUE #( for travel IN lt_travels
                      LET lv_flag = COND #( when travel-OverallStatus = 'C' THEN if_abap_behv=>auth-unauthorized
                                            else if_abap_behv=>auth-allowed )
                                    IN ( %tky = travel-%tky
                                         %update = lv_flag ) ).
*    LOOP AT lt_travels INTO DATA(ls_travel).
*      IF  ls_travel-OverallStatus = 'C'.
*
*        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
*        APPEND VALUE #( %tky = ls_travel-%tky
*                        %msg = new_message_with_text(
*                        severity = if_abap_behv_message=>severity-error
*                        text     = 'No Aithorization to edit !' )
*                      ) TO reported-travel.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.

*    IF
**  requested_authorizations-%update = '01' OR
*    requested_authorizations-%action-acceptTravel = if_abap_behv=>mk-on OR requested_authorizations-%action-rejectTravel = if_abap_behv=>mk-on.
*      IF action_auth( ) = abap_true.
*        result-%action-acceptTravel = if_abap_behv=>auth-allowed.
*        result-%action-rejectTravel = if_abap_behv=>auth-allowed.
*
*      ELSE.
*        result-%action-acceptTravel = if_abap_behv=>auth-unauthorized.
*        result-%action-rejectTravel = if_abap_behv=>auth-unauthorized.
*      ENDIF.
*
*
*    ENDIF.

    IF readonly_auth(  ) = abap_true.
      result-%action-acceptTravel = if_abap_behv=>auth-unauthorized.
      result-%action-rejectTravel = if_abap_behv=>auth-unauthorized.
*        result-%create = if_abap_behv=>auth-allowed.
      result-%delete = if_abap_behv=>auth-unauthorized.
      result-%update = if_abap_behv=>auth-unauthorized.

    ENDIF.

  ENDMETHOD.

  METHOD action_auth.
    "
    action_allowed = abap_true.
  ENDMETHOD.

  METHOD readonly_auth.
    readonly_allowed = abap_false.
  ENDMETHOD.

  METHOD get_global_features.
  ENDMETHOD.

ENDCLASS.
