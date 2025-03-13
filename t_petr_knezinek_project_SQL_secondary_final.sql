-- Potřebuji spojit tabulky countries a economies, 
-- a to (dle prozkoumání) na základě sloupce country.
SELECT * FROM countries c

SELECT * FROM economies e

CREATE TABLE t_petr_knezinek_project_SQL_secondary_final AS 
	SELECT
		c.country,
		e."year",
		e.gdp AS HDP,
		e.gini,
		e.population
	FROM countries c LEFT JOIN economies e
	ON c.country = e.country
	WHERE c.continent = 'Europe'
	AND e."year" BETWEEN 2006 AND 2018
	ORDER BY e."year"
