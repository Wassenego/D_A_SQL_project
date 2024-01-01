-- Vytvoření první tabulky
CREATE OR REPLACE TABLE t_Marek_Sykora_project_SQL_primary_final AS
SELECT f.*,
	s.industry_code,
	s.industry_branch,
	s.average_salary
FROM (
	SELECT YEAR(cp.date_from) AS `year`,
		cpc.name AS food_name,
		round(AVG(cp.value), 2) AS average_price,
		cpc.price_value,
		cpc.price_unit
	FROM czechia_price cp
	JOIN czechia_price_category cpc ON cpc.code = cp.category_code 
	WHERE region_code IS NULL
	GROUP BY `year`, 
		cpc.name
) f 
JOIN (
	SELECT cp.payroll_year,
		cpib.code AS industry_code,
		cpib.name AS industry_branch,
		round(AVG(cp.value), 0) average_salary  
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code 
	WHERE value_type_code = 5958 
		AND calculation_code = 200 
		AND industry_branch_code IS NOT NULL
	GROUP BY cp.payroll_year, 
		cp.industry_branch_code
	ORDER BY payroll_year, 
		cp.industry_branch_code
) s ON s.payroll_year = f.`year`
ORDER BY f.`year`,
	s.industry_code,
	f.food_name
;

-- Vytvoření druhé tabulky
CREATE OR REPLACE TABLE t_Marek_Sykora_project_SQL_secondary_final
SELECT e.`year`,
	e.GDP,
	e.population
FROM economies e
WHERE country = 'Czech Republic'
	AND `year` BETWEEN 2006 AND 2018
ORDER BY `year`
;

-- 1.dotaz - 	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 		Varianta s výpisem všech kombinací a se slovním hodnocením  	    	
SELECT ms1.industry_branch,
	ms2.`year` AS `year`,
	CONCAT(ms1.average_salary,' Kč') AS previous_year_salary,
	CONCAT(ms2.average_salary,' Kč') AS current_year_salary,
	CASE 
		WHEN ms1.average_salary < ms2.average_salary THEN 'Průměrný plat vzrostl'
		ELSE 'Průměrný plat klesl'
	END AS salary_evaluation	
FROM (
	SELECT ms.industry_code,
		ms.industry_branch,
		ms.`year`,
		ms.average_salary
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.`year`, 
		ms.industry_code
	ORDER BY ms.industry_code, 
		ms.`year` 
) ms1
JOIN (
	SELECT ms.industry_code,
		ms.industry_branch,
		ms.`year`,
		ms.average_salary
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.`year`, 
		ms.industry_code
	ORDER BY ms.industry_code, 
		ms.`year` 
) ms2 ON (ms1.`year` + 1) = ms2.`year` 
	AND ms1.industry_code = ms2.industry_code 
ORDER BY ms1.industry_code, 
	ms1.`year`
;

-- 1.dotaz - 	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 		Výpis pouze odvětví a roků, kdy mzdy klesly
SELECT sd.industry_branch,
	sd.next_year AS year_of_decreased_avg_salary
FROM (
	SELECT ms1.industry_branch,
		ms1.`year` AS previous_year,
		ms2.`year` AS next_year,
		CASE 
			WHEN ms1.average_salary < ms2.average_salary THEN 1
			ELSE 0
		END AS salary_evaluation	
	FROM (
		SELECT ms.industry_code,
			ms.industry_branch,
			ms.`year`,
			ms.average_salary
		FROM t_marek_sykora_project_sql_primary_final ms
		GROUP BY ms.`year`, ms.industry_code
		ORDER BY ms.industry_code, ms.`year` 
	) ms1
	JOIN (
		SELECT ms.industry_code,
			ms.industry_branch,
			ms.`year`,
			ms.average_salary
		FROM t_marek_sykora_project_sql_primary_final ms
		GROUP BY ms.`year`, ms.industry_code
		ORDER BY ms.industry_code, ms.`year` 
	) ms2 
		ON (ms1.`year` + 1) = ms2.`year` 
		AND ms1.industry_code = ms2.industry_code 
	ORDER BY ms1.industry_code, 
		ms1.`year`
) sd
WHERE sd.salary_evaluation = 0
ORDER BY year_of_decreased_avg_salary, 
	sd.industry_branch
;

-- 2.dotaz - 	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 		Verze, kdy ponechám potraviny v řádcích - není tak přehledná, speciálně, pokud by se přidávaly další potraviny
SELECT ms.`year`,
	ms.industry_branch,
	ms.average_salary AS avg_salary,
	ms.food_name,
	ms.average_price AS avg_price,
	CONCAT(ROUND(ms.average_salary / ms.average_price, 0),' ', ms.price_unit) AS amount_in_avg_salary
FROM t_marek_sykora_project_sql_primary_final ms
WHERE (ms.`year` = (SELECT MIN(ms1.`year`) FROM t_marek_sykora_project_sql_primary_final ms1) 
	OR ms.`year` = (SELECT MAX(ms2.`year`) FROM t_marek_sykora_project_sql_primary_final ms2))
	AND (ms.food_name LIKE 'Mléko%' OR ms.food_name LIKE 'Chléb%')
ORDER BY ms.industry_branch, 
	ms.food_name;

-- 2.dotaz - 	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 		Verze, kdy transponuji potraviny do sloupců
SELECT ms.`year`,
	ms.industry_branch,
	ms.average_salary AS avg_salary,
	CASE 
		WHEN ms.food_name LIKE 'Chléb%' THEN ms.average_price
	END AS bread_price,
	CONCAT(ROUND(ms.average_salary / ms.average_price, 0),' ', ms.price_unit) AS amount_in_avg_salary,
	m.milk_price,
	m.amount_in_avg_salary
FROM t_marek_sykora_project_sql_primary_final ms
JOIN (
	SELECT ms.`year`,
		ms.industry_branch,
		ms.average_salary AS avg_salary,
		CASE 
			WHEN ms.food_name LIKE 'Mléko%' THEN ms.average_price
		END AS milk_price,
		CONCAT(ROUND(ms.average_salary / ms.average_price, 0),' ', ms.price_unit) AS amount_in_avg_salary
	FROM t_marek_sykora_project_sql_primary_final ms
	WHERE (ms.`year` = (SELECT MIN(ms1.`year`) FROM t_marek_sykora_project_sql_primary_final ms1) 
		OR ms.`year` = (SELECT MAX(ms2.`year`) FROM t_marek_sykora_project_sql_primary_final ms2))
		AND ms.food_name LIKE 'Mléko%'
	ORDER BY ms.industry_branch
) m ON ms.`year` = m.`year` 
	AND ms.industry_branch = m.industry_branch 
	AND ms.average_salary = m.avg_salary
WHERE (ms.`year` = (SELECT MIN(ms1.`year`) FROM t_marek_sykora_project_sql_primary_final ms1) 
	OR ms.`year` = (SELECT MAX(ms2.`year`) FROM t_marek_sykora_project_sql_primary_final ms2))
	AND ms.food_name LIKE 'Chléb%'
ORDER BY ms.industry_branch, 
	ms.`year`
;

-- 3.dotaz - 	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
--		Verze s percentuálním meziročním nárůstem jednotlivých potravin pro každý rok - ke kontrole
SELECT ms1.food_name,
	ms1.`year` AS previous_year,
	ms2.`year` AS current_year,
	ms2.average_price,
	ms2.average_price / ms1.average_price * 100 - 100 AS growth_rate
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

-- 4.dotaz - 	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- 		Verze, kdy porovnáváme meziroční nárůst cen potravin s meziročním nárůstem platů každého odvětví zvlášť
SELECT tms.current_year AS `year`,
	tms.food_name,
	tms.food_growth_rate,
	tms.industry_branch,
	tms.salary_growth_rate,
	tms.rate_diff
FROM (
	SELECT ms1.food_name,
		ms1.`year` AS previous_year,
		ms1.average_price AS avg_price_previous,
		ms2.`year` AS current_year,
		ms2.average_price AS avg_price_current,
		ROUND(ms2.average_price / ms1.average_price * 100 - 100, 2) AS food_growth_rate,
		ms1.industry_branch,
		ms1.average_salary AS avg_salary_previous,
		ms2.average_salary AS avg_salary_current,
		ROUND(ms2.average_salary / ms1.average_salary * 100 - 100, 2) AS salary_growth_rate,
		ROUND(ms2.average_price / ms1.average_price * 100 - ms2.average_salary / ms1.average_salary * 100, 2) AS rate_diff
	FROM t_marek_sykora_project_sql_primary_final ms1
	JOIN (
		SELECT ms.`year`,
			ms.food_name,
			ms.average_price,
			ms.industry_branch,
			ms.average_salary 
		FROM t_marek_sykora_project_sql_primary_final ms
		ORDER BY ms.food_name, 
			ms.`year` 
	) ms2 ON ms1.`year` = ms2.`year` - 1 
		AND ms1.food_name = ms2.food_name 
		AND ms1.industry_branch = ms2.industry_branch
	GROUP BY ms1.food_name, 
		ms1.`year`, 
		ms1.industry_branch 
	ORDER BY ms1.food_name, 
		ms1.`year`
) tms
WHERE tms.rate_diff >= 10
ORDER BY rate_diff DESC;
;

-- 4.dotaz - 	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- 		Verze, kdy porovnáváme meziroční nárůst cen potraviny s průměrným meziročním nárůstem platu všech odvětví dohromady
SELECT tms.current_year AS `year`,
	tms.food_name,
	tms.food_growth_rate,
	ROUND(AVG(tms.salary_growth_rate), 2) AS avg_salary_growth_rate,
	ROUND(AVG(tms.rate_diff), 2) AS avg_rate_diff
FROM (
	SELECT ms1.food_name,
		ms1.`year` AS previous_year,
		ms1.average_price AS avg_price_previous,
		ms2.`year` AS current_year,
		ms2.average_price AS avg_price_current,
		ROUND(ms2.average_price / ms1.average_price * 100 - 100, 2) AS food_growth_rate,
		ms1.industry_branch,
		ms1.average_salary AS avg_salary_previous,
		ms2.average_salary AS avg_salary_current,
		ROUND(ms2.average_salary / ms1.average_salary * 100 - 100, 2) AS salary_growth_rate,
		ROUND(ms2.average_price / ms1.average_price * 100 - ms2.average_salary / ms1.average_salary * 100, 2) AS rate_diff
	FROM t_marek_sykora_project_sql_primary_final ms1
	JOIN (
		SELECT ms.`year`,
			ms.food_name,
			ms.average_price,
			ms.industry_branch,
			ms.average_salary 
		FROM t_marek_sykora_project_sql_primary_final ms
		ORDER BY ms.food_name, ms.`year` 
	) ms2 ON ms1.`year` = ms2.`year` - 1 
		AND ms1.food_name = ms2.food_name 
		AND ms1.industry_branch = ms2.industry_branch
	GROUP BY ms1.food_name, ms1.`year`, 
		ms1.industry_branch 
	ORDER BY ms1.food_name, ms1.`year`
	) tms
WHERE tms.rate_diff >= 10
GROUP BY `year`, 
	tms.food_name,
	tms.food_growth_rate
ORDER BY avg_rate_diff DESC
;

-- 5.dotaz - 	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
SELECT tms.current_year AS `year`,
	ROUND(AVG(tms.food_growth_rate), 2) AS avg_food_growth_rate,
	ROUND(AVG(tms.salary_growth_rate), 2) AS avg_salary_growth_rate,
	tms2.GDP_growth_rate
FROM (
	SELECT ms1.food_name,
		ms2.`year` AS current_year,
		ROUND(ms2.average_price / ms1.average_price * 100 - 100, 2) AS food_growth_rate,
		ms1.industry_branch,
		ms1.average_salary AS avg_salary_previous,
		ms2.average_salary AS avg_salary_current,
		ROUND(ms2.average_salary / ms1.average_salary * 100 - 100, 2) AS salary_growth_rate,
		ROUND(ms2.average_price / ms1.average_price * 100 - ms2.average_salary / ms1.average_salary * 100, 2) AS rate_diff
	FROM t_marek_sykora_project_sql_primary_final ms1
	JOIN (
		SELECT ms.`year`,
			ms.food_name,
			ms.average_price,
			ms.industry_branch,
			ms.average_salary 
		FROM t_marek_sykora_project_sql_primary_final ms
		ORDER BY ms.food_name, ms.`year` 
	) ms2 ON ms1.`year` = ms2.`year` - 1 
		AND ms1.food_name = ms2.food_name 
		AND ms1.industry_branch = ms2.industry_branch
	GROUP BY ms1.food_name, 
		ms1.`year`, 
		ms1.industry_branch 
	ORDER BY ms1.food_name, 
		ms1.`year`
) tms
JOIN (
	SELECT tmss.current_year AS `year`,
		ROUND(tmss.current_year_GDP / tmss.previous_year_GDP * 100 - 100, 2) AS GDP_growth_rate
	FROM (
		SELECT tms1.`year` AS previous_year,
			tms1.GDP AS previous_year_GDP,
			tms2.`year` AS current_year,
			tms2.GDP AS current_year_GDP
		FROM t_marek_sykora_project_sql_secondary_final tms1
	JOIN t_marek_sykora_project_sql_secondary_final tms2 
	ON tms2.`year` - 1 = tms1.`year`
	) tmss
) tms2 ON tms2.`year` = tms.current_year
GROUP BY `year`
ORDER BY `year`
;



