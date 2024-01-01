# SQL projekt
Datová akademie: 26. 10. 2023 - 25. 1. 2024  
Vypracoval: Marek Sýkora

## Úvod do projektu:
Na analytickém oddělení nezávislé společnosti, specializující se na hodnocení životní úrovně občanů, jsme se rozhodli provést analýzu, která nám poskytne odpovědi na klíčové výzkumné otázky související s dostupností základních potravin. Tyto otázky budou sloužit jako podklad pro prezentaci výsledků na konferenci zaměřené na danou oblast.

## Data pro analýzu:
Pro získání relevantních dat jsme k dispozici měli několik datových sad, včetně informací o mzdách v různých odvětvích _(czechia_payroll)_, cenách vybraných potravin (czechia_price), demografických údajích o regionech a okresech v České republice (czechia_region, czechia_district), a dalších mezinárodních informacích o státech světa (countries, economies).
Podmínkou bylo neprovádět změny v primárních tabulkách. Transformace hodnot by měly být provedeny až v tabulkách nebo pohledech vytvořených pro účely projektu, aby byla zajištěna integrita a správnost dat.

## Výstup projektu:
Výstupem projektu jsou dvě klíčové tabulky v databázi:

`t_Marek_Sykora_project_SQL_primary_final`: Obsahuje data mezd a cen potravin za Českou republiku sjednocená na totožné porovnatelné období – společné roky.
`t_Marek_Sykora_project_SQL_secondary_final`: Obsahuje dodatečná data o HDP a populaci v České republice z období shodujícím se s předchozí tabulkou.

## SQL Skript a Repozitář na GitHubu:
Celkové SQL skripty, včetně průvodní dokumentace a popisu mezivýsledků, jsou k dispozici v repozitáři na GitHubu. Repozitář slouží ke správě a dokumentaci projektu a je dostupný na následujícím odkazu:  (https://github.com/Wassenego/D_A_SQL_project/blob/main/SQL_project.sql).

## Výzkumné otázky a odpovědi:  
1.  Vývoj mezd v odvětvích: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
  -  V některých letech mzdy klesali, obzvláště po krizovém roku 2008. Dalším rokem se snižováním platů v celé řadě oblastí pak byl rok 2013. 
2.  Porovnání dostupnosti potravin: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?    
   - Nejméně chleba
3.  Zdražování potravin: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?  
   - 
4.  Výrazný nárůst cen: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?  
   -
5.  Vliv HDP na mzdy a ceny potravin: Má výška HDP vliv na změny ve mzdách a cenách potravin? Projeví se růst HDP na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?  
   -

## Závěr:
V mém zpracování projektu se celou dobu střetávaly dva pohledy na SQL problematiku a to vytvoření dotazů s detailními výsledky a velkým množství informací a vytvoření dotazů s minimálním počtem informací, ale s co nejkonkrétnějšími výsledky. První řešení by mělo být pro uživatele, který by s informacemi dále pracovali, tvořil reporty, grafy a vyvozovali . Druhé řešení mi přišlo vyhovující pro koncového, i laického, uživatele výsledku. Protože jsem se nedokázal rozhodnout, která z variant je v projektu vyžadována, vytvořil jsem pro první čtyři otázky vždy dvě varianty dotazů. Po  z obou variant vždy 

