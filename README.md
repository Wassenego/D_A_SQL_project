# SQL projekt
Datová akademie: 26. 10. 2023 - 25. 1. 2024  
Vypracoval: Marek Sýkora

## Úvod do projektu:
Na analytickém oddělení naší nezávislé společnosti, která se zabývá životní úrovní občanů, jsme se dohodli, že se pokusíme odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

## Data pro analýzu:
Pro získání relevantních dat jsme k dispozici měli několik datových sad:  
### Primární tabulky:  
_`czechia_payroll`_ – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.  
_`czechia_payroll_calculation`_ – Číselník kalkulací v tabulce mezd.  
_`czechia_payroll_industry_branch`_ – Číselník odvětví v tabulce mezd.  
_`czechia_payroll_unit`_ – Číselník jednotek hodnot v tabulce mezd.  
_`czechia_payroll_value_type`_ – Číselník typů hodnot v tabulce mezd.  
_`czechia_price`_ – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.  
_`czechia_price_category`_ – Číselník kategorií potravin, které se vyskytují v našem přehledu.   

### Číselníky sdílených informací o ČR:     
_`czechia_region`_ – Číselník krajů České republiky dle normy CZ-NUTS 2.  
_`czechia_district`_ – Číselník okresů České republiky dle normy LAU.    

### Dodatečné tabulky:  
_`countries`_ - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.  
_`economies`_ - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.    

__Podmínkou bylo neprovádět změny v primárních tabulkách. Transformace hodnot by měly být provedeny až v tabulkách nebo pohledech vytvořených pro účely projektu, aby byla zajištěna integrita a správnost dat.__

## Výstup projektu:
Výstupem projektu jsou dvě klíčové tabulky v databázi:

__`t_Marek_Sykora_project_SQL_primary_final`__: Obsahuje data mezd a cen potravin za Českou republiku sjednocená na totožné porovnatelné období – společné roky.  
__`t_Marek_Sykora_project_SQL_secondary_final`__: Obsahuje dodatečná data o HDP, gini a populaci v evropských státech z období shodujícím se s předchozí tabulkou.

## SQL Skript a Repozitář na GitHubu:
Celkové SQL skripty, včetně průvodní dokumentace a popisu výsledků, jsou k dispozici v repozitáři na GitHubu. Repozitář slouží ke správě a dokumentaci projektu a je dostupný na následujícím odkazu:  (https://github.com/Wassenego/D_A_SQL_project/blob/main/SQL_project.sql).

## Výzkumné otázky a odpovědi:  
__1.  Vývoj mezd v odvětvích: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?__  
      -  V některých odvětvích mzdy klesali, obzvláště v několika letech po krizovém roku 2008. Dalším rokem se snižováním platů v celé řadě oblastí byl pak rok 2013.   
__2.  Porovnání dostupnosti potravin: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?__      
      - Nejméně chleba
__3.  Zdražování potravin: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?__    
      - V 
__4.  Výrazný nárůst cen: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?__    
      - V
__5.  Vliv HDP na mzdy a ceny potravin: Má výška HDP vliv na změny ve mzdách a cenách potravin? Projeví se růst HDP na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?__    
      - V

## Závěr:
V mém zpracování projektu se celou dobu střetávaly dva pohledy na SQL problematiku a to vytvoření dotazů s detailními výsledky a velkým množství informací a vytvoření dotazů s minimálním počtem informací, ale s co nejkonkrétnějšími výsledky. První řešení by mělo být pro uživatele, který by s informacemi dále pracovali, tvořil reporty, grafy a vyvozovali . Druhé řešení mi přišlo vyhovující pro koncového, i laického, uživatele výsledku. Protože jsem se nedokázal rozhodnout, která z variant je v projektu vyžadována, vytvořil jsem pro první čtyři otázky vždy dvě varianty dotazů. Po  z obou variant vždy 

