# SQL projekt
Datová akademie: 26. 10. 2023 - 25. 1. 2024  
Vypracoval: Marek Sýkora

## Úvod do projektu:
Na analytickém oddělení naší nezávislé společnosti, která se zabývá životní úrovní občanů, jsme se dohodli, že se pokusíme odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové vydefinovali základní otázky, na které se pokusím odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

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

__*Podmínkou bylo neprovádět změny v primárních tabulkách. Transformace hodnot by měly být provedeny až v tabulkách nebo pohledech vytvořených pro účely projektu, aby byla zajištěna integrita a správnost dat.*__

## Výstup projektu:
Výstupem projektu jsou dvě klíčové tabulky v databázi:

__`t_Marek_Sykora_project_SQL_primary_final`__: Obsahuje data mezd a cen potravin za Českou republiku sjednocená na totožné porovnatelné období – společné roky.  
__`t_Marek_Sykora_project_SQL_secondary_final`__: Obsahuje dodatečná data o HDP, gini a populaci v evropských státech z období shodujícím se s předchozí tabulkou.

## SQL Skript a Repozitář na GitHubu:
Celkové SQL skripty, včetně průvodní dokumentace a popisu výsledků, jsou k dispozici v repozitáři na GitHubu. Repozitář slouží ke správě a dokumentaci projektu a je dostupný na následujícím odkazu:  (https://github.com/Wassenego/D_A_SQL_project/blob/main/SQL_project.sql).

## Výzkumné otázky a odpovědi:  
__1.  Vývoj mezd v odvětvích: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?__  
      - V některých odvětvích mzdy klesali, obzvláště v několika letech po krizovém roku 2008. Dalším obdobím se snižováním platů v celé řadě oblastí byl pak rok 2013. To byl také jediný rok, kdy průměr platů ze všech odvětví dohromady oproti předchozímu roku klesl - o 0,78%. Celkově nejvíce rostly mzdy v roce 2018 a to průměrně o 7,88%. 
      - Odvětví, ve kterých mzdy ve sledovaném období nikdy neklesly: Zpracovatelský průmysl, Zdravotní a sociální péče a Ostatní činnosti.  
__2.  Porovnání dostupnosti potravin: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?__      
      - Nejméně chleba - průměrně 724kg za měsíc - se dalo koupit v roce 2006 (začátek sledovaného časového období) a to v případě, že jste pracovali v odvětví "Ubytování, stravování a pohostinství". Pokud jste pracovali ve stejném odvětví i v roce 2018 (konec sledovaného období), mohli jste si průměrně koupit o cca 70kg chleba více.  Nicméně nebylo pravidlem, že by se vždy v roce 2018 dalo koupit průměrně více chleba než v roce 2006. Asi u čtvrtiny odvětví kupní síla klesla.  
      - Nejvíce chleba si mohli koupit zaměstnanci v peněžnictví a pojišťovnictví v roce 2006 a to 2483kg za měsíc.  
      - Nejméně mléka - 808l - si opět mohli koupit pracovníci z oblasti "Ubytování, stravování a pohostinství" v roce 2006.  
      - Nejvíce mléka - 2862l - na měsíc si mohli pořídit lidé zaměstnáni v roce 2018 v oblasti "Informační a komunikační činnosti".   
      - Pouze v jedné oblasti došlo k tomu, že si pracovnící mohli koupit více mléka v roce 2006 než v roce 2018, a to v "Peněžnictví a pojišťovnictví".  
__3.  Zdražování potravin: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?__    
      - Dvě kategorie potravin ve sledovaném období vůbec nezdražily a to "Cukr krystalový", který zlevnil o 1,92% a také "Rajská jablka červená kulatá", která zlevnila o 0,74%.  
__4.  Výrazný nárůst cen: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?__   
      - Pokud bychom porovnávali meziroční nárůst cen jednotlivých potraviny s meziročním nárůstem platů v samostatných odvětvích, pak k největšímu rozdílu (a tím k nejhorší situaci pro nakupujícícho) došlo v roce 2007, pokud jste byl zaměstnán v Zásobování vodou; činnosti související s odpady a sanacemi a šel jste si do obchodu koupit papriky. Rozdíl meziročního nárůstu byl pro tuto situaci 89,47%. Celkem pak došlo během sledovaného období k 709 momentům, kdy byl meziroční nárůst cen poravin vyšší o více jak 10% než meziroční nárůst platů.  
      - Při porovnávání meziročního nárůstu cen jednotlivých potraviny s meziročním nárůstem platů (bez ohledu na odvětví), došlo celkem k 36 případům, kdy došlo k výrazně většímu meziročnímu nárůstu ceny určité potraviny vůči růstu průměrné mzdy. První tři příčky obsadily 'Papriky' v roce 2007 (87,91%), 'Konzumní brambory' v roce 2013 (61,1%) a 'Vejce slepičí čerstvá' v roce 2012 (52,15%).  
      - Pokud bychom nerozlišovali jednotlivé potraviny a udělali meziroční nárůst cen všech potravin, pak nikdy nedošlo k meziročnímu nárůstu cen potravin výrazně vyššímu než růst mezd (větší než 10 %). Maximální hodnota  byla 6.79% v roce 2013.  
__5.  Vliv HDP na mzdy a ceny potravin: Má výška HDP vliv na změny ve mzdách a cenách potravin? Projeví se růst HDP na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?__    
      - Po porovnání meziročního nárůstu cen potravin, platů a HDP jsem našel jen spojitost ve změnách platů, kdy při vzrůstajícím HDP se zvyšují platy v následujícím roce a opačně. Spojitost s cenami mezd jsem žádnou nenašel.   

## Závěr:  
V mém zpracování projektu si určitě všimnete, že mám na většinu otázek vypracováno více variant SQL dotazů. Tím, jak se z mi dařilo zadané otázky interpretovat často různě, snažil jsem se pokrýt veškeré množiny odpovědí. Případně se snažil dotazy připravit tak, aby při dodatečném upravování otázek např. uživatelem byly výsledky přehlednější. V reálném životě bych ale předpokládal detailnější komunikaci se zadavatelem k upřesnění požadovaného výsledku a následném vytvoření pouze jednoho perfektního dotazu k otázce. 
