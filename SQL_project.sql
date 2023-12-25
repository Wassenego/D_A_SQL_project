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
	GROUP BY `year`, cpc.name
	) f 
JOIN (
	SELECT cp.payroll_year,
		cpib.code AS industry_code,
		cpib.name AS industry_branch,
		round(AVG(cp.value), 0) average_salary  
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code 
	WHERE value_type_code = 5958 AND calculation_code = 200 AND industry_branch_code IS NOT NULL
	GROUP BY cp.payroll_year, cp.industry_branch_code
	ORDER BY payroll_year, cp.industry_branch_code) s ON s.payroll_year = f.`year`
ORDER BY f.`year`, s.industry_code, f.food_name
;

CREATE OR REPLACE TABLE t_Marek_Sykora_project_SQL_secondary_final;

-- 1.dotaz - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT ms1.industry_branch,
	ms1.`year` AS previous_year,
	ms2.`year` AS next_year,
	CONCAT(ms1.average_salary,' Kč') AS previous_year_salary,
	CONCAT(ms2.average_salary,' Kč') AS next_year_salary,
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
	GROUP BY ms.`year`, ms.industry_code
	ORDER BY ms.industry_code, ms.`year` 
	) AS ms1
JOIN (
	SELECT ms.industry_code,
		ms.industry_branch,
		ms.`year`,
		ms.average_salary
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.`year`, ms.industry_code
	ORDER BY ms.industry_code, ms.`year` 
	) AS ms2 
	ON (ms1.`year` + 1) = ms2.`year` AND ms1.industry_code = ms2.industry_code 
ORDER BY ms1.industry_code, ms1.`year`
;

-- 1.dotaz 	- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 			- konkrétní specifikace odvětví a roků, kdy mzdy klesly

SELECT sd.industry_branch,
	sd.next_year AS year_of_decreased_avg_salary
FROM (
	SELECT ms1.industry_branch,
		ms1.`year` AS previous_year,
		ms2.`year` AS next_year,
		CONCAT(ms1.average_salary,' Kč') AS previous_year_salary,
		CONCAT(ms2.average_salary,' Kč') AS next_year_salary,
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
		) AS ms1
	JOIN (
		SELECT ms.industry_code,
			ms.industry_branch,
			ms.`year`,
			ms.average_salary
		FROM t_marek_sykora_project_sql_primary_final ms
		GROUP BY ms.`year`, ms.industry_code
		ORDER BY ms.industry_code, ms.`year` 
		) AS ms2 
		ON (ms1.`year` + 1) = ms2.`year` AND ms1.industry_code = ms2.industry_code 
	ORDER BY ms1.industry_code, ms1.`year`
	) AS sd
WHERE sd.salary_evaluation = 0
ORDER BY year_of_decreased_avg_salary, sd.industry_branch
;

-- 2.dotaz 	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 			Verze, kdy ponechám potraviny v řádcích - není tak přehledná
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
ORDER BY ms.industry_branch, ms.food_name;

-- 2.dotaz 	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- 			Verze, kdy transponuji potraviny do sloupců
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
	) AS m ON ms.`year` = m.`year` AND ms.industry_branch = m.industry_branch AND ms.average_salary = m.avg_salary
WHERE (ms.`year` = (SELECT MIN(ms1.`year`) FROM t_marek_sykora_project_sql_primary_final ms1) 
	OR ms.`year` = (SELECT MAX(ms2.`year`) FROM t_marek_sykora_project_sql_primary_final ms2))
	AND ms.food_name LIKE 'Chléb%'
ORDER BY ms.industry_branch, ms.`year`;



SELECT MIN(ms.`year`) FROM t_marek_sykora_project_sql_primary_final ms;














