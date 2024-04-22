CREATE TABLE IF NOT EXISTS countries(
id SERIAL PRIMARY KEY,
code VARCHAR(8) UNIQUE,
country VARCHAR(100) NOT NULL UNIQUE  -- Adjusted the length to 100 characters
);

INSERT INTO countries (code, country)
SELECT DISTINCT "Code", "Entity" FROM infectious_cases
ON CONFLICT (code) DO NOTHING; -- This line will skip insertion of duplicate codes

CREATE TABLE IF NOT EXISTS infectious_cases_normalized AS
SELECT * FROM infectious_cases;

ALTER TABLE infectious_cases_normalized
ADD COLUMN id SERIAL PRIMARY KEY,
ADD COLUMN country_id INT,
ADD CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES countries(id);

UPDATE infectious_cases_normalized i
SET country_id = c.id FROM countries c
WHERE c.code = i."Code" AND c.country = i."Entity";

ALTER TABLE infectious_cases_normalized
DROP COLUMN "Entity",
DROP COLUMN "Code";
