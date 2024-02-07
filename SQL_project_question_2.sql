/* Vypracoval: Marek Sýkora
Discord username: wassenego
Discord display name: Marek S.
Final version: 7.2.2024 */

-- 2.dotaz - 	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 		Verze, kdy ponechám potraviny v řádcích - není tak přehledná, speciálně, pokud by se přidávaly další potraviny, nyní bez použití funkce LIKE
SELECT ms.`year`,
	ms.industry_branch,
	ms.average_salary AS avg_salary,
	ms.food_name,
	ms.average_price AS avg_price,
	ROUND(ms.average_salary / ms.average_price, 0) AS amount_in_avg_salary,
	ms.price_unit
FROM t_marek_sykora_project_sql_primary_final ms
WHERE (ms.`year` = (SELECT MIN(ms1.`year`) FROM t_marek_sykora_project_sql_primary_final ms1) 
	OR ms.`year` = (SELECT MAX(ms2.`year`) FROM t_marek_sykora_project_sql_primary_final ms2))
	AND (ms.food_name = 'Mléko polotučné pasterované' OR ms.food_name = 'Chléb konzumní kmínový')
ORDER BY ms.industry_branch, 
	ms.food_name
;

-- 2.dotaz - 	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 		Verze, kdy transponuji potraviny do sloupců, nyní bez vnořeného SELECTu a bez použití funkce LIKE
SELECT ms.`year`,
	ms.industry_branch,
	ms.average_salary,
	CASE 
		WHEN ms.food_name = 'Chléb konzumní kmínový' THEN ms.average_price
	END AS bread_price,
	ROUND(ms.average_salary / ms.average_price, 0) AS amount_in_avg_salary,
	ms.price_unit,
	CASE 
		WHEN m.food_name = 'Mléko polotučné pasterované' THEN m.average_price
	END AS milk_price,
	ROUND(m.average_salary / m.average_price, 0) AS amount_in_avg_salary,
	m.price_unit
FROM t_marek_sykora_project_sql_primary_final ms
JOIN t_marek_sykora_project_sql_primary_final m
	ON ms.`year` = m.`year` 
	AND ms.industry_branch = m.industry_branch 
	AND ms.average_salary = m.average_salary 
WHERE (ms.`year` = (SELECT MIN(ms1.`year`) FROM t_marek_sykora_project_sql_primary_final ms1) 
	OR ms.`year` = (SELECT MAX(ms2.`year`) FROM t_marek_sykora_project_sql_primary_final ms2))
 	AND (m.food_name = 'Mléko polotučné pasterované' AND ms.food_name = 'Chléb konzumní kmínový')
ORDER BY ms.industry_branch, 
	ms.`year`
;
