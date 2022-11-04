use ecommecer_db_dw;

delimiter //

create procedure sp_data_load_dim_time ()
begin

	SET @d0 = (select if(count(*) > 0, max(FULL_DATE), '2016-01-01 00:00:00.000000') from DIM_TIME);
	SET @d1 = date_format(NOW(), "%Y-%m-%d %H:00:00.000000") ;
	 
	SET @date = @d0;

	WHILE @date <=  @d1 DO
		INSERT INTO DIM_TIME (FULL_DATE,DAYMONTH,WEEKDAY,MONTH_NUM,MONTH_NAME,QUARTER_NUM,
			YEAR_NUM,SEASON,WEEKEND,DATE_TEXT,HOUR_NUM)
		values
		(
			date_format(@date, "%Y-%m-%d %H:00:00.000000") ,
			day(@date),
			dayname(@date),
		    month(@date),
		    monthname(@date),
		    quarter(@date),
		    year(@date),
		    (
			CASE WHEN date_format(@date, "%Y%m%d") BETWEEN CONCAT(CONVERT(year(@date), CHAR(4)  ),'0923') 
			AND CONCAT(CONVERT(year(@date), CHAR(4) ),'1220') THEN
				'Spring'
			WHEN date_format(@date, "%Y%m%d") BETWEEN CONCAT(CONVERT(year(@date), CHAR(4)),'0321') 
			AND CONCAT(CONVERT(year(@date), CHAR(4)),'0620') THEN
				'Autumn'
			WHEN date_format(@date, "%Y%m%d") BETWEEN CONCAT(CONVERT(year(@date), CHAR(4)),'0621') 
			AND CONCAT(CONVERT(year(@date),CHAR(4)),'0922') THEN
				'Winter'
			ELSE
				'Summer'
			END
			),
		    if(dayname(@date) = 'Saturday' or dayname(@date) = 'Sunday', 1, 0),
		    date_format(@date, "%d/%m/%Y"),
		    HOUR(@date)
		);
		SET @date = ADDDATE(@date,INTERVAL 1 HOUR);
	END WHILE;

end

//
delimiter ;