CLASS zcl_cds_scalar_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
     CLASS-METHODS:
      execute FOR SCALAR FUNCTION ZCDS_SCALAR_FUNCTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_cds_scalar_function IMPLEMENTATION.
 METHOD execute BY DATABASE FUNCTION
                 FOR HDB
                 LANGUAGE SQLSCRIPT
                 OPTIONS READ-ONLY.
    result = portion / total * 100;
  ENDMETHOD.
ENDCLASS.
