/*Vypracoval: Marek Sýkora
Discord username: wassenego
Discord display name: Marek S.*/

-- 4.dotaz - 	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- 		Verze, kdy porovnáváme meziroční nárůst cen jednotlivých potravin s průměrným meziročním nárůstem platu společně pro všechna odvětví
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
	GROUP BY ms1.food_name, 
		ms1.`year`, 
		ms1.industry_branch 
	ORDER BY ms1.food_name, 
	ms1.`year`
) tms
GROUP BY `year`, 
	tms.food_name,
	tms.food_growth_rate
HAVING avg_rate_diff >= 10 
ORDER BY avg_rate_diff DESC
;

-- 4.dotaz - 	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- 		Verze, kdy porovnáváme průměrný meziroční nárůst cen všech potravin s průměrným meziročním nárůstem platu všech odvětví
SELECT tms.current_year AS `year`,
	ROUND(AVG(tms.food_growth_rate), 2) AS avg_food_growth_rate,
	ROUND(AVG(tms.salary_growth_rate), 2) AS avg_salary_growth_rate,
	ROUND(AVG(tms.rate_diff), 2) rate_diff
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
	ORDER BY ms1.food_name, ms1.`year`
	) tms
GROUP BY `year`
-- HAVING rate_diff >= 10 
ORDER BY rate_diff DESC
;

	