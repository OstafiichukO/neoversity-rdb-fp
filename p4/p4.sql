-- Add a new column for the difference in years
ALTER TABLE infectious_cases_normalized 
ADD COLUMN year_difference INT;

-- Define a function to calculate the difference in years between two dates
CREATE OR REPLACE FUNCTION fn_year_difference(start_date_input DATE, end_date_input DATE)
RETURNS INT AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM end_date_input) - EXTRACT(YEAR FROM start_date_input);
END;
$$ LANGUAGE plpgsql;

-- Update the table to populate the new column with the calculated differences
UPDATE infectious_cases_normalized
SET year_difference = fn_year_difference(start_date, cur_date);
