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
	SELECT ms.`year`,
		ms.industry_code,
		ms.industry_branch,
		ms.average_salary
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.`year`, ms.industry_code 
	) AS ms1
JOIN (
	SELECT ms.`year`,
		ms.industry_code,
		ms.industry_branch,
		ms.average_salary
	FROM t_marek_sykora_project_sql_primary_final ms
	GROUP BY ms.`year`, ms.industry_code 
	) AS ms2 
	ON (ms1.`year` + 1) = ms2.`year` 
ORDER BY ms1.industry_code, ms1.`year`
;
