-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- Využiji VIEW z předchozí výzkumné otázky (procentuelni_narust_a_pokles pnap) pro ceny potravin
-- a zjistím si procentuální nárůst nebo pokles průměrných cen všech potravin za jednotlivé roky.
-- Vytvořím z tohoto nové VIEW price_percentual_change.

CREATE VIEW price_percentual_change AS 
SELECT 
	pnap."year",
	round(AVG(pnap.mezirocne))
FROM procentuelni_narust_a_pokles pnap
GROUP BY pnap."year"
ORDER BY pnap."year";

-- Pro platy si vytvořím VIEW se shodnými roky a průměrným platem pro všechna odvětví v těchto letech.
-- Následně použiji funkci lag() a vzorec pro procentuální meziroční porovnání výše mezd.

CREATE VIEW payroll_percentual_change AS 
SELECT 
	round(avg(tpkpspf.pay)) AS average_pay_of_all_brach,
	tpkpspf.payroll_year,
	lag(round(avg(tpkpspf.pay))) OVER (ORDER BY tpkpspf.payroll_year) AS year_before,
	round( ( round(avg(tpkpspf.pay)) - ( lag(round(avg(tpkpspf.pay))) OVER (ORDER BY tpkpspf.payroll_year) ) ) / 
	( round(avg(tpkpspf.pay)) ) * 100 ) AS interannual_percentage_change
FROM "t_petr_knezinek_project_SQL_primary_final" tpkpspf
GROUP BY tpkpspf.payroll_year
ORDER BY tpkpspf.payroll_year;

-- JOINEM spojím obě VIEW do jedné tabulky a vidím jednoznačné srovnání.

SELECT 
	ppc2."year" AS year_of_comparison,
	ppc2.round AS foodprice_change,
	ppc.interannual_percentage_change AS payroll_change
FROM price_percentual_change ppc2 JOIN payroll_percentual_change ppc
ON ppc2."year" = ppc.payroll_year;

-- V žádném roce nebyl meziroční nárůst cen potravin vyšší než meziroční nárůst mezd o 10 %.
