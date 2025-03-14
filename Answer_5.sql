-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to 
-- na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

SELECT * FROM "t_petr_knezinek_project_SQL_secondary_final" tpkpssf

-- Použijeme vytvořenou tabulku (t_petr_knezinek_project_SQL_secondary_final)
-- a zjistíme si z ní potřebné hodnoty. Následně pomocí funkce lag() a vzorce
-- uděláme meziroční srovnání. Vytvoříme VIEW hdp_percentual_change.

CREATE VIEW hdp_percentual_change AS 
SELECT 
	tpkpssf."year",
	tpkpssf.hdp,
	lag(tpkpssf.hdp) OVER (ORDER BY tpkpssf."year") AS year_before,
	round( ( tpkpssf.hdp - ( lag(tpkpssf.hdp) OVER (ORDER BY tpkpssf."year") ) ) /
	( lag(tpkpssf.hdp) OVER (ORDER BY tpkpssf."year") ) * 100 )
FROM "t_petr_knezinek_project_SQL_secondary_final" tpkpssf
WHERE tpkpssf.country = 'Czech Republic'

-- Připojíme k tomuto VIEW (hdp_percentual_change) oba dříve vytvořené VIEW (price_percentual_change; payroll_percentual_change)
-- a pohledem zjistíme, zda růst HDP ovlivňuje mzdy nebo ceny potravin.

SELECT
	ppc."year",
	hpc.round AS hdp_change,
	ppc.round AS price_change,
	ppc2.interannual_percentage_change AS payroll_change
FROM price_percentual_change ppc 
	JOIN payroll_percentual_change ppc2
		ON ppc."year" = ppc2.payroll_year
	JOIN hdp_percentual_change hpc
		ON ppc."year" = hpc."year"

-- Zde by bylo potřeba určit, co znamená "výraznější" vzrůst HDP. Ze zjištěných dat však vyplývá, že meziročně ve zkoumaném období 
-- neexistuje zvýšení HDP nad 10% a ani ceny potravin a mzdy zásadně nerostou při zvýšení HDP. 
-- Např. v roce 2015 se HDP zvýšilo přibližně o 5%, ale ceny potravin se snížily asi o 1% a mzdy se zvýšili jen asi o 2%.
