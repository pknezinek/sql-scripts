-- Důkladně si prostudujeme obě základní tabulky
-- Nalezneme průnik společných období (roky 2006 až 2018)

SELECT * FROM czechia_price cp
ORDER BY cp.date_from

SELECT * FROM czechia_payroll cp
ORDER BY cp.payroll_year

-- Tabulku t_petr_knezinek_project_SQL_primary_final vytvoříme
-- spojením tabulek přes společná období a připojíme tabulky
-- czechia_price_category a czechia_payroll_industry_branch kvůli názvům. 

CREATE TABLE t_petr_knezinek_project_SQL_primary_final AS 
SELECT 
	*
FROM (
		SELECT
			CAST(AVG(cp.value) AS integer) AS average_food_price,
			date_part('year', cp.date_from) AS year,
			cpc."name" AS food_name
		FROM czechia_price cp LEFT JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code
		GROUP BY food_name, "year"
		ORDER BY "year", average_food_price
		)
INNER JOIN (
		SELECT
			CAST(AVG(cp.value) AS integer) AS pay,
			cpib."name" AS industry_name,
			cp.payroll_year AS payroll_year
		FROM czechia_payroll cp LEFT JOIN czechia_payroll_industry_branch cpib
		ON cp.industry_branch_code = cpib.code
			WHERE 
				cp.value_type_code = 5958			--5958 je průměrná hrubá mzda na zaměstnance
				AND cp.unit_code = 200				--200 je přepočet v tisících na osobu
				AND cp.calculation_code = 100		--100 je fyzický nikoli přepočtený
				AND cp.industry_branch_code IS NOT NULL 
		GROUP BY industry_name, payroll_year
		ORDER BY payroll_year
		)
ON YEAR=payroll_year
ORDER BY "year"



