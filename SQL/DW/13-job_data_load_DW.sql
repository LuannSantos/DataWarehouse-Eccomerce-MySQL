use ecommerce_db_dw;

delimiter |

CREATE EVENT e_daily
    ON SCHEDULE
      EVERY 1 DAY
    COMMENT 'Carrega dados nas tabelas do DW'
    DO
      BEGIN
        call sp_data_load_dim_time();
        call sp_data_load_DW();
      END |

delimiter ;


SHOW EVENTS;