use ecommerce_db_dw;

delimiter |

CREATE EVENT e_daily
    ON SCHEDULE
      EVERY 1 DAY
    COMMENT 'Carrega dados nas tabelas de Stagging'
    DO
      BEGIN
        call sp_data_load_STAGE ();
      END |

delimiter ;


SHOW EVENTS;


