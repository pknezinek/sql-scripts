-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- Vyberu vhodné sloupce, vhodně seřadím, použiji funkci LAG na porovnání.

CREATE OR REPLACE VIEW rust_a_pokles_platu AS 
SELECT 
	DISTINCT(tpkpspf.pay),
	lag(tpkpspf.pay) OVER (PARTITION BY tpkpspf.industry_name ORDER BY tpkpspf.payroll_year) AS salary_difference,
	tpkpspf.industry_name,
	tpkpspf.payroll_year,
		CASE 
			WHEN pay > (lag(tpkpspf.pay) OVER (PARTITION BY tpkpspf.industry_name ORDER BY tpkpspf.payroll_year)) THEN 'plat roste'
			ELSE 'plat klesá'
		END AS rust_pokles	
FROM "t_petr_knezinek_project_SQL_primary_final" tpkpspf
ORDER BY tpkpspf.industry_name, tpkpspf.payroll_year

SELECT * FROM rust_a_pokles_platu rapp WHERE rapp.pay != rapp.salary_difference

SELECT DISTINCT(rapp.industry_name) FROM rust_a_pokles_platu rapp

-- Zde je seznam odvětví, ve kterých byl zaznamenán alespoň jeden meziroční pokles mezd.
SELECT 
	rapp.industry_name
FROM rust_a_pokles_platu rapp
WHERE rapp.rust_pokles = 'plat klesá'
	AND rapp.salary_difference IS NOT NULL
	AND rapp.pay != rapp.salary_difference
ORDER BY rapp.industry_name

-- Mzdy rostou po celou dobu (2006 až 2018) pouze v těchto pěti odvětvích: 
-- 1) Administrativní a podpůrné činnosti
-- 2) Doprava a skladování
-- 3) Ostatní činnosti
-- 4) Zdravotní a sociální péče
-- 5) Zpracovatelský průmysl 
-- Avšak v následujících odvětvích se objevil během sledovanéhoobdobí jediný rok poklesu mezd uvedený v závorkách.
-- Nejčastěji jde o rok 2013, ve kterém se nejvíce projevily dopady finanční krize z let 2008-2009.
-- 1) Informační a komunikační činnosti (2013)
-- 2) Peněžnictví a pojišťovnictví (2013)
-- 3) Činnost v oblasti nemovitostí (2013)
-- 4) Stavebnictví (2013)
-- 5) Vzdělávání (2010)
-- 6) Zásobování vodou; činnosti související s odpady a sanacemi (2013)
-- 7) Zemědělství, lesnictví, rybářství (2009)
-- V ostatních odvětvích mzdy meziročně klesaly vícekrát.
-- Z dlouhodobého hlediska však roste nominální hodnota mezd u všech odvětví.










