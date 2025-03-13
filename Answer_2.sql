-- Vyselektujeme z tabulky t_petr_knezinek_project_SQL_primary_final potřebné údaje pro chléb a mléko a roky 2006 a 2018.
-- Následně spočítáme množství, které lze v daných letech koupit.

CREATE VIEW average_price_of_bread AS 
SELECT 
	tpkpspf.average_food_price AS bread_price,
	tpkpspf."year",
	tpkpspf.food_name,
	round(AVG(tpkpspf.pay)) AS pay
FROM "t_petr_knezinek_project_SQL_primary_final" tpkpspf
WHERE tpkpspf."year" = 2006 AND tpkpspf.food_name = 'Chléb konzumní kmínový' OR 
	tpkpspf."year" = 2018 AND tpkpspf.food_name = 'Chléb konzumní kmínový'
GROUP BY tpkpspf.average_food_price, tpkpspf."year", tpkpspf.food_name

SELECT 
	pay/bread_price AS pocet_bochniku
FROM average_price_of_bread

-- V roce 2006 si člověk s průměrnou mzdou mohl koupit 1 271 bochníků chleba
-- a v roce 2018 to bylo o něco více, tedy 1 332 bochníků chleba.

CREATE VIEW average_price_of_milk AS 
SELECT 
	tpkpspf.average_food_price AS milk_price,
	tpkpspf."year",
	tpkpspf.food_name,
	round(AVG(tpkpspf.pay)) AS pay
FROM "t_petr_knezinek_project_SQL_primary_final" tpkpspf
WHERE tpkpspf."year" = 2006 AND tpkpspf.food_name = 'Mléko polotučné pasterované' OR 
	tpkpspf."year" = 2018 AND tpkpspf.food_name = 'Mléko polotučné pasterované'
GROUP BY tpkpspf.average_food_price, tpkpspf."year", tpkpspf.food_name

SELECT 
	pay/apom.milk_price AS pocet_bochniku
FROM average_price_of_milk apom

-- V roce 2006 si člověk s průměrnou mzdou mohl koupit 1 453 litrů mléka
-- a v roce 2018 to bylo o něco více, tedy 1 599 litrů mléka.
