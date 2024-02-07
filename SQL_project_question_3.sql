/*Vypracoval: Marek Sýkora
Discord username: wassenego
Discord display name: Marek S.*/

-- 3.dotaz - 	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
--		Verze s percentuálním meziročním nárůstem jednotlivých potravin pro každý rok - ke kontrole
SELECT ms1.food_name,
	ms1.`year` AS previous_year,
	ms1.average_price AS prev_year_avg_price,
	ms2.`year` AS current_year,
	ms2.average_price AS current_year_avg_price,
	ROUND(ms2.average_price / ms1.average_price * 100 - 100, 2) AS growth_rate
FROM t_marek_sykora_project_sql_primary_final ms1
JOIN (
	SELECT ms.`year`,
		ms.food_name,
		ms.average_price
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.food_name, 
		ms.`year`
	ORDER BY ms.food_name, 
		ms.`year` 
) ms2 ON ms1.`year` = ms2.`year` - 1 
	AND ms1.food_name = ms2.food_name 
GROUP BY ms1.food_name, 
	ms1.`year`
ORDER BY ms1.food_name, 
	ms1.`year`
;

-- 3.dotaz - 	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- 		Verze, která vytvoří a seřadí průměrný percentuální meziroční nárůst ve srovnatelné období v dostupných datech cen potravin
--		Průměr procentuální změny je trošku nepraktický ukazatel, protože nereflektuje celkovou změnu, nicméně správně a přesně odpovídá na otázku 
SELECT ms1.food_name,
	ROUND(AVG(ms2.average_price / ms1.average_price * 100 - 100), 2) AS avg_growth_rate
FROM t_marek_sykora_project_sql_primary_final ms1
JOIN (
	SELECT ms.`year`,
		ms.food_name,
		ms.average_price
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.food_name, 
		ms.`year`
	ORDER BY ms.food_name, 
		ms.`year` 
) ms2 ON ms1.`year` = ms2.`year` - 1 
	AND ms1.food_name = ms2.food_name 
GROUP BY ms1.food_name
ORDER BY avg_growth_rate
; 

-- 3.dotaz - 	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- 		Verze, kdy vezmeme cenu v prvním roce sledování a porovnáme s cenou v posledním roce. Tahle odpověď je přesnější ukazatel, ale spíš odpovídá
--      na otáku "Která potravina zdražila nejméně za sledované období?". Pořadí potravin se neshoduje s předchozím výsledkem
SELECT ms1.food_name,
	ms1.`year` AS first_year,
	ms1.average_price AS first_year_avg_price,
	ms2.`year` AS last_year,
	ms2.average_price AS last_year_avg_price,
	ROUND(ms2.average_price / ms1.average_price * 100 - 100, 2) AS growth_rate
FROM t_marek_sykora_project_sql_primary_final ms1
JOIN t_marek_sykora_project_sql_primary_final ms2 ON ms1.food_name = ms2.food_name
WHERE ms1.`year` = 2006 AND ms2.`year` = 2018
GROUP BY food_name
ORDER BY growth_rate
;
