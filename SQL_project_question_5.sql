/*Vypracoval: Marek Sýkora
Discord username: wassenego
Discord display name: Marek S.*/

-- 5.dotaz - 	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
SELECT tms.current_year AS `year`,
	tms2.country,
	ROUND(AVG(tms.food_growth_rate), 2) AS avg_food_growth_rate,
	ROUND(AVG(tms.salary_growth_rate), 2) AS avg_salary_growth_rate,
	-- ROUND(AVG(tms.rate_diff), 2) AS rate_diff,
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
		tmss.country,
		ROUND(tmss.current_year_GDP / tmss.previous_year_GDP * 100 - 100, 2) AS GDP_growth_rate
	FROM (
		SELECT tms1.country,
			tms1.`year` AS previous_year,
			tms1.GDP AS previous_year_GDP,
			tms2.`year` AS current_year,
			tms2.GDP AS current_year_GDP			
		FROM t_marek_sykora_project_sql_secondary_final tms1
	JOIN t_marek_sykora_project_sql_secondary_final tms2 
	ON tms2.`year` - 1 = tms1.`year` AND tms2.country = tms1.country
	WHERE tms2.country = 'Czech Republic'
	) tmss
) tms2 ON tms2.`year` = tms.current_year
GROUP BY tms2.`year`
ORDER BY `year`
;



	