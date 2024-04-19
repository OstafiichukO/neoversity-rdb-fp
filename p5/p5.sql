CREATE OR REPLACE FUNCTION fn_average_cases(period_length INT, frequency VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    total_cases NUMERIC := 0;
    periods_count INT := 0;
    period_start_date DATE := CURRENT_DATE;
BEGIN
    IF frequency = 'month' THEN
        period_start_date := period_start_date - INTERVAL '1 month' * period_length;
    ELSIF frequency = 'quarter' THEN
        period_start_date := period_start_date - INTERVAL '3 months' * period_length;
    ELSE
        RETURN NULL; -- Return NULL if an invalid frequency is provided
    END IF;
    
    FOR period_start_date IN SELECT generate_series(period_start_date, CURRENT_DATE, frequency) LOOP
        total_cases := total_cases + (SELECT COUNT(*) FROM infectious_cases_normalized WHERE date_column >= period_start_date AND date_column <= period_start_date + INTERVAL '1 ' || frequency);
        periods_count := periods_count + 1;
    END LOOP;
    
    IF periods_count = 0 THEN
        RETURN NULL; -- Return NULL if no periods were found
    END IF;
    
    RETURN total_cases / periods_count;
END;
$$ LANGUAGE plpgsql;
