REPORT Z001EST_FIS_JUR.

TABLES: kna1, lfa1.

  TYPES: BEGIN OF ty_fisjur,
    cod(15)      TYPE c,
    name1        TYPE lfa1-name1,
    land1        TYPE lfa1-land1,
    regio        TYPE lfa1-regio,
    ort01        TYPE lfa1-ORT01,
    cnpfj(18)    TYPE c,
    type(10)     TYPE c,
    END OF ty_fisjur.

  DATA: it_kna1   TYPE TABLE OF kna1,
        it_lfa1   TYPE TABLE OF lfa1,
        it_fisjur TYPE TABLE OF ty_fisjur,
        wa_fisjur TYPE ty_fisjur,
        go_alv    TYPE REF TO cl_salv_table,
        tabname   TYPE tabname,
        gv_count  TYPE string,
        gv_filename TYPE string,
        gv_fullpath TYPE string.

SELECTION-SCREEN BEGIN OF BLOCK b1.
  PARAMETERS: rd01 RADIOBUTTON GROUP gp1 USER-COMMAND rad1 DEFAULT 'X',
              rd02 RADIOBUTTON GROUP gp1,
              rd03 RADIOBUTTON GROUP gp1.
  SELECTION-SCREEN COMMENT /1(20) text-vaz.
  SELECT-OPTIONS: r_kunnr FOR kna1-kunnr MODIF ID CLI,
                  r_lifnr FOR lfa1-lifnr MODIF ID FOR,
                  r_both  FOR lfa1-lifnr MODIF ID BOT,
                  r_land1 FOR kna1-land1,
                  r_regio FOR kna1-regio.
  SELECTION-SCREEN COMMENT /1(20) text-vaz.
  PARAMETER p_path TYPE string MODIF ID BOT.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
PERFORM: select_data.
PERFORM: process_data.
PERFORM: build_file.
PERFORM: output.

AT SELECTION-SCREEN OUTPUT.
  CASE abap_true .
      WHEN rd01.
        LOOP AT SCREEN.
          IF screen-group1 = 'FOR'.
            screen-active = 0.
          ENDIF.
          IF screen-group1 = 'CLI'.
            screen-active = 1.
          ENDIF.
          IF screen-group1 = 'BOT'.
            screen-active = 0.
          ENDIF.
          MODIFY SCREEN.
        ENDLOOP.
      WHEN rd02.
        LOOP AT SCREEN.
          IF screen-group1 = 'FOR'.
            screen-active = 1.
          ENDIF.
          IF screen-group1 = 'CLI'.
            screen-active = 0.
          ENDIF.
          IF screen-group1 = 'BOT'.
            screen-active = 0.
          ENDIF.
          MODIFY SCREEN.
        ENDLOOP.
      WHEN rd03.
        LOOP AT SCREEN.
          IF screen-group1 = 'FOR'.
            screen-active = 0.
          ENDIF.
          IF screen-group1 = 'CLI'.
            screen-active = 0.
          ENDIF.
          IF screen-group1 = 'BOT'.
            screen-active = 1.
          ENDIF.
          MODIFY SCREEN.
        ENDLOOP.
    ENDCASE.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.
  cl_gui_frontend_services=>file_save_dialog(
    EXPORTING
      window_title              = 'Informe o diretório para download' " Window Title
      default_extension         = 'txt'                               " Default Extension
      default_file_name         = 'export.txt'                        " Default File Name
      file_filter               = 'Arquivos Texto (*.txt)|*.txt|'     " File Type Filter Table
    CHANGING
      filename                  = gv_filename                         " File Name to Save
      path                      = p_path                              " Path to File
      fullpath                  = gv_fullpath                         " Path + File Name
    EXCEPTIONS
      cntl_error                = 1
      error_no_gui              = 2
      not_supported_by_gui      = 3
      invalid_default_file_name = 4
      others                    = 5
  ).

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .
  CASE abap_true .
      WHEN rd01.
       SELECT * FROM kna1
         INTO TABLE it_kna1
         WHERE kunnr IN r_kunnr
           AND land1 IN r_land1
           AND regio IN r_regio.

       IF r_land1 IS NOT INITIAL OR r_regio IS NOT INITIAL.
         SELECT COUNT( * )
           FROM kna1
           INTO gv_count
           WHERE land1 IN r_land1
             AND regio IN r_regio.
       ENDIF.

      WHEN rd02.
       SELECT * FROM lfa1
         INTO TABLE it_lfa1
         WHERE lifnr IN r_lifnr
           AND land1 IN r_land1
           AND regio IN r_regio.

      IF r_land1 IS NOT INITIAL OR r_regio IS NOT INITIAL.
        SELECT COUNT( * )
          FROM lfa1
          INTO gv_count
          WHERE land1 IN r_land1
            AND regio IN r_regio.
      ENDIF.
      WHEN rd03.
        SELECT kunnr name1 land1 regio ort01 stcd1
          FROM kna1
          INTO TABLE it_fisjur
          WHERE kunnr IN r_both
          AND land1 IN r_land1
          AND regio IN r_regio.
        MODIFY it_fisjur FROM VALUE #( type = 'CLIENTE') TRANSPORTING type WHERE type = ''.

        SELECT lifnr name1 land1 regio ort01 stcd1
          FROM lfa1
          APPENDING TABLE it_fisjur
          WHERE lifnr IN r_both
          AND land1 IN r_land1
          AND regio IN r_regio.
        MODIFY it_fisjur FROM VALUE #( type = 'FORNECEDOR') TRANSPORTING type WHERE type = ''.

        DESCRIBE TABLE it_fisjur LINES gv_count.
    ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
FORM process_data .

  DATA: lv_message TYPE string,
        lv_cnpj(18) TYPE c,
        lv_cpf(14) TYPE c.

  SORT it_kna1 BY name1.

  IF gv_count IS NOT INITIAL.
    CONCATENATE gv_count 'found' INTO lv_message.
    MESSAGE lv_message TYPE 'S'.
  ENDIF.

  IF it_fisjur IS NOT INITIAL.
    LOOP AT it_fisjur INTO wa_fisjur.
      IF wa_fisjur-cnpfj IS INITIAL.
        wa_fisjur-cnpfj = '00000000000000'.
      ENDIF.
      IF wa_fisjur-type = 'FORNECEDOR'.
        CONCATENATE wa_fisjur-cnpfj(2) '.' wa_fisjur-cnpfj+2(3) '.' wa_fisjur-cnpfj+5(3) '/' wa_fisjur-cnpfj+8(4) '-' wa_fisjur-cnpfj+12(2) INTO lv_cnpj.
        wa_fisjur-cnpfj = lv_cnpj.
        MODIFY it_fisjur FROM wa_fisjur INDEX sy-tabix.
        ELSE.
          CONCATENATE wa_fisjur-cnpfj(3) '.' wa_fisjur-cnpfj+3(3) '.' wa_fisjur-cnpfj+6(3) '-' wa_fisjur-cnpfj+9(2) INTO lv_cpf.
          wa_fisjur-cnpfj = lv_cpf.
          MODIFY it_fisjur FROM wa_fisjur INDEX sy-tabix.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  BUILD_FILE
*&---------------------------------------------------------------------*
FORM build_file .
  CHECK rd03 IS NOT INITIAL.
  CALL FUNCTION'GUI_DOWNLOAD'
    EXPORTING
      filename                  = gv_fullpath " Name of file
      filetype                  = 'ASC'       " File Type (ASC or BIN)
      write_field_separator     = 'X'         " Separate Columns by Tabs in Case of ASCII Download
    TABLES
      data_tab                  = it_fisjur   " Transfer table
    EXCEPTIONS
      file_write_error          = 1
      no_batch                  = 2
      gui_refuse_filetransfer   = 3
      invalid_type              = 4
      no_authority              = 5
      unknown_error             = 6
      header_not_allowed        = 7
      separator_not_allowed     = 8
      filesize_not_allowed      = 9
      header_too_long           = 10
      dp_error_create           = 11
      dp_error_send             = 12
      dp_error_write            = 13
      unknown_dp_error          = 14
      access_denied             = 15
      dp_out_of_memory          = 16
      disk_full                 = 17
      dp_timeout                = 18
      file_not_found            = 19
      dataprovider_exception    = 20
      control_flush_error       = 21
      others                    = 22
    .
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  OUTPUT
*&---------------------------------------------------------------------*
FORM output .
  IF rd01 IS NOT INITIAL.
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_alv
    CHANGING
      t_table        = it_kna1
  ).
  go_alv->get_columns( )->get_column( 'MANDT' )->set_technical( 'X' ).

   ELSEIF rd02 IS NOT INITIAL.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   = go_alv
      CHANGING
        t_table        = it_lfa1
    ).
  go_alv->get_columns( )->get_column( 'MANDT' )->set_technical( 'X' ).

   ELSE.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   = go_alv
      CHANGING
        t_table        = it_fisjur
    ).

    go_alv->get_columns( )->get_column( 'COD' )->set_long_text('Código').
    go_alv->get_columns( )->get_column( 'COD' )->set_medium_text('Código').
    go_alv->get_columns( )->get_column( 'COD' )->set_short_text('Cód').
    go_alv->get_columns( )->get_column( 'TYPE' )->set_long_text('Tipo').
    go_alv->get_columns( )->get_column( 'TYPE' )->set_medium_text('Tipo').
    go_alv->get_columns( )->get_column( 'TYPE' )->set_short_text('Tipo').
    go_alv->get_columns( )->get_column( 'CNPFJ' )->set_long_text('CPF / CNPJ').
    go_alv->get_columns( )->get_column( 'CNPFJ' )->set_medium_text('CPF / CNPJ').
    go_alv->get_columns( )->get_column( 'CNPFJ' )->set_short_text('CPF-CNPJ').

  ENDIF.
  go_alv->get_columns( )->set_optimize( 'X' ).


  go_alv->get_functions( )->set_all( 'X' ).
  go_alv->get_display_settings( )->set_striped_pattern( 'X' ).
  go_alv->display( ).
*    CATCH cx_salv_msg.    "
ENDFORM.
