-- Pro získání procentuálních rozdílů cen potravin v jednotlivých letech
-- je třeba upravit tabulku s potravinami a přidat sloupec s výpočtem v procentech 
-- (((nová cena)-(předchozí cena)) / (předchozí cena)) * 100%.

CREATE VIEW procentuelni_narust_a_pokles AS 
SELECT 
	AVG(tpkpspf.average_food_price) AS prumerna_cena_za_rok,
	tpkpspf."year",
	tpkpspf.food_name,
	lag(AVG(tpkpspf.average_food_price)) OVER (PARTITION BY food_name ORDER BY tpkpspf."year") AS predchozi_cena,
	round(((AVG(tpkpspf.average_food_price) - (lag(AVG(tpkpspf.average_food_price)) OVER (PARTITION BY food_name ORDER BY tpkpspf."year"))) / 
	AVG(tpkpspf.average_food_price)) * 100) AS mezirocne
FROM "t_petr_knezinek_project_SQL_primary_final" tpkpspf
GROUP BY tpkpspf.food_name, tpkpspf."year"
ORDER BY tpkpspf.food_name, tpkpspf."year"

SELECT 
	pnap.food_name,
	SUM(pnap.mezirocne)
FROM procentuelni_narust_a_pokles pnap
GROUP BY pnap.food_name

-- Z porovnání za celé období je patrné, že tyto potraviny celkově zlevnily:
-- Cukr krystalový, Konzumní brambory, Rajská jablka červená kulatá (nejvíce).
-- Na stejné ceně ve srovnávaném období zůstalo Pečivo pšeničné bílé.
-- Ostatní potraviny ve sledovaném období zdražily, nejvíce Těstoviny vaječné a Máslo.
