SELECT id, 
       MAX("Number_rabies") AS max_value, 
       MIN("Number_rabies") AS min_value, 
       AVG(CASE WHEN "Number_rabies" <> 0 THEN "Number_rabies" END) AS average_value 
FROM infectious_cases_normalized
WHERE "Number_rabies" IS NOT NULL
GROUP BY id
ORDER BY average_value DESC
LIMIT 10;
