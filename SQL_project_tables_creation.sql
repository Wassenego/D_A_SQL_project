/*Vypracoval: Marek Sýkora
Discord username: wassenego
Discord display name: Marek S.*/

-- Vytvoření první tabulky
CREATE OR REPLACE TABLE t_marek_sykora_project_sql_primary_final AS
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
CREATE OR REPLACE TABLE t_marek_sykora_project_sql_secondary_final
WITH europian_countries AS (
	SELECT country
	FROM countries c 
	WHERE continent = 'Europe'
)
SELECT e.`year`,
	c.country,
	e.GDP,
	e.gini,
	e.population
FROM europian_countries c
JOIN economies e ON e.country = c.country
WHERE `year` BETWEEN 2006 AND 2018
ORDER BY c.country, 
	e.`year`
;

