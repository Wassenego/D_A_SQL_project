/*Vypracoval: Marek Sýkora
Discord username: wassenego
Discord display name: Marek S.*/

-- 1.dotaz - 	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 		Varianta s výpisem všech kombinací a se slovním hodnocením  	    	
SELECT 
	ms.industry_branch,
	ms1.`year` AS `year`,
	ms.average_salary AS previous_year_salary,
	'Kč' AS unit,
	ms1.average_salary AS current_year_salary,
	'Kč' AS unit,
	CASE 
		WHEN ms.average_salary < ms1.average_salary THEN 'Průměrný plat vzrostl'
		ELSE 'Průměrný plat klesl'
	END AS salary_evaluation	
FROM t_marek_sykora_project_sql_primary_final ms
JOIN t_marek_sykora_project_sql_primary_final ms1 
	ON (ms.`year` + 1) = ms1.`year` 
	AND ms.industry_code = ms1.industry_code
GROUP BY 
	ms.industry_branch, 
	ms.`year` 
ORDER BY 
	ms1.industry_code, 
	ms1.`year`
;

-- 1.dotaz - 	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 		Výpis pouze odvětví a roků, kdy mzdy klesly
SELECT 
	ms.industry_branch,
	ms.industry_code,
	ms1.`year` AS `year`,
	CASE 
		WHEN ms.average_salary < ms1.average_salary THEN 1
		ELSE "Pokles mzdy"
	END AS salary_evaluation
FROM t_marek_sykora_project_sql_primary_final ms
JOIN t_marek_sykora_project_sql_primary_final ms1 
	ON (ms.`year` + 1) = ms1.`year` 
	AND ms.industry_code = ms1.industry_code
GROUP BY 
	ms.industry_branch, 
	ms.`year` 
HAVING salary_evaluation != 1
ORDER BY `year`
;

-- 1.dotaz - 	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- 		Varianta s výpisem všech kombinací a se slovním hodnocením - alternativní verze 	    	
SELECT 
	ms2.industry_branch,
	ms2.industry_code,
	ms2.`year` AS `year`
FROM (
	SELECT 
		ms.industry_branch,
		ms.industry_code,
		ms1.`year` AS `year`,
		CASE 
			WHEN ms.average_salary < ms1.average_salary THEN 1
			ELSE 0
		END AS salary_evaluation	
	FROM t_marek_sykora_project_sql_primary_final ms
	JOIN t_marek_sykora_project_sql_primary_final ms1 
		ON (ms.`year` + 1) = ms1.`year` 
		AND ms.industry_code = ms1.industry_code
	GROUP BY 
		ms.industry_branch, 
		ms.`year`
) ms2
WHERE ms2.salary_evaluation = 0
ORDER BY ms2.`year`
;