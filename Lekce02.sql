-- ORDER BY

-- Úkol 1:

SELECT
	`name`,
	`provider_type`
FROM healthcare_provider hp
ORDER BY `name`;

-- Úkol 2:

SELECT
	`provider_id`,
	`name`,
	`provider_type`
FROM healthcare_provider hp
ORDER BY
	`region_code`,
	`district_code`;
	
-- Úkol 3:

SELECT
	*
FROM czechia_district cd
ORDER BY `code` DESC;

-- Úkol 4:

SELECT
	*
FROM czechia_region cr
ORDER BY `name` DESC
LIMIT 5;

-- Úkol 5:

SELECT
	*
FROM healthcare_provider hp
ORDER BY
	`provider_type`,
	`name` DESC;

-- CASE Expression

-- Úkol 1:

SELECT
	*,
	CASE
		WHEN `region_code` = 'CZ010' THEN 1
		ELSE 0
	END AS `is_from_Prague`
FROM healthcare_provider hp;

-- Úkol 2:

SELECT
	*,
	CASE
		WHEN `region_code` = 'CZ010' THEN 1
		ELSE 0
	END AS `is_from_Prague`
FROM healthcare_provider hp
WHERE `region_code` = 'CZ010';
	
-- Úkol 3:

SELECT
	`name`,
	`municipality`,
	`longitude`,
	CASE
		WHEN `longitude` < 14 THEN 'Nejvíce na západě'
		WHEN `longitude` < 16 THEN 'Méně na západě'
		WHEN `longitude` < 18 THEN 'Více na východě'
		ELSE 'Nejvíce na východě'
	END AS `czechia_position`
FROM healthcare_provider hp;

-- Úkol 4:

SELECT
	`name`,
	`provider_type`,
	CASE
		WHEN `provider_type` = 'Lékárna' OR provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END AS `is_desired_type`
FROM healthcare_provider hp;

-- WHERE, IN a LIKE 

-- Úkol 1:

SELECT
	*
FROM healthcare_provider hp
WHERE `name` LIKE '%nemocnice%';

-- Úkol 2:

SELECT
	`name`,
	CASE
		WHEN `name` LIKE 'Lékárna%' THEN 1
		ELSE 0
	END AS `start_with_searched_name`
FROM healthcare_provider hp
WHERE `name` LIKE '%lékárna%';

-- Úkol 3

SELECT
	`name`,
	`municipality`
FROM healthcare_provider hp
WHERE `municipality` LIKE '____';

-- Úkol 4

SELECT
	`name`,
	`municipality`,
	`district_code`
FROM healthcare_provider hp
WHERE
	`municipality` IN ('Brno', 'Praha', 'Ostrava')
	OR `district_code` IN ('CZ0421', 'CZ0425');

-- Úkol 5

SELECT
	`provider_id`,
	`name`,
	`region_code`	
FROM healthcare_provider hp
WHERE `region_code` IN (
	SELECT
		`code`
	FROM czechia_region cr
	WHERE `name` IN ('Jihomoravský kraj', 'Středočeský kraj')
);

-- Úkol 6

SELECT
	*
FROM czechia_district cd
WHERE `code` IN (
	SELECT
		`district_code`
	FROM healthcare_provider hp
	WHERE `municipality` LIKE '____'
);

-- Pohledy (VIEW)

-- Úkol 1

CREATE OR REPLACE VIEW v_healtcare_provider_subset AS
	SELECT
		`provider_id`,
		`name`,
		`municipality`,
		`district_code`
	FROM healthcare_provider hp
	WHERE `municipality` IN ('Brno', 'Praha', 'Ostrava');

-- Úkol 2

SELECT
	*
FROM v_healtcare_provider_subset vhps;

SELECT
	*
FROM healthcare_provider hp
WHERE `provider_id` NOT IN (
	SELECT
		`provider_id`
	FROM v_healtcare_provider_subset vhps
);

-- Úkol 3

DROP VIEW IF EXISTS v_healtcare_provider_subset;

-- BONUSOVÁ CVIČENÍ

-- Countries: další cvičení

-- Úkol 1:

SELECT
	`country`,
	`national_dish`
FROM countries
WHERE `region_in_world` = 'Eastern Europe';

-- Úkol 2:

SELECT
	`country`,
	`currency_name`
FROM countries c
WHERE lower(`currency_name`) LIKE '%dollar%';

SELECT
	`country`,
	`currency_name`
FROM countries c
WHERE lower(`currency_name`) LIKE '%US Dollar%';

-- Úkol 3:

SELECT
	`country`,
	`abbreviation`,
	`domain_tld`
FROM countries c
WHERE lower(`abbreviation`) != substring(`domain_tld`, 2, 2);

-- Úkol 4:

SELECT
	`country`,
	`capital_city`
FROM countries c
WHERE `capital_city` LIKE '% %';

-- Úkol 5:

SELECT
	`country`,
	`religion`,
	`independence_date`
FROM countries c
WHERE 
	`independence_date` IS NOT NULL
	AND `religion` = 'Christianity'
ORDER BY `independence_date`;

-- Úkol 6:

SELECT
	`country`,
	`elevation`,
	`yearly_average_temperature`,
	`population`,
	`population_density`
FROM countries c
WHERE
	`elevation` > 2000
	OR `yearly_average_temperature` < 5
	OR `yearly_average_temperature` > 25
	OR (`population` > 10000000 AND `population_density` > 1000);

-- Úkol 7:

CREATE OR REPLACE VIEW v_radek_vach_hostile_countries AS
	SELECT
		`country`,
		`elevation`,
		`yearly_average_temperature`,
		`population`,
		`population_density`,
		IF (`elevation` > 2000, 1, 0) AS `mountainous`,
		IF (`yearly_average_temperature` < 5, 1, 1) AS `cold_weather`,
		IF (`yearly_average_temperature` > 2, 1, 0) AS `hot_weather`,
		IF (`population` > 10000000 AND `population_density` > 1000, 1, 0) AS `over_populated`
	FROM countries c
	WHERE 
		`elevation` > 2000
		OR `yearly_average_temperature` < 5
		OR `yearly_average_temperature` > 25
		OR (`population` > 10000000 AND `population_density` > 1000);

-- Úkol 8:

SELECT
	*
FROM v_radek_vach_hostile_countries
WHERE `mountainous` + `cold_weather` + `hot_weather` + `over_populated` > 1;

-- Úkol 9:

SELECT
	`country`,
	`life_expectancy`
FROM countries c
WHERE `life_expectancy` IS NOT NULL
ORDER BY `life_expectancy`;

-- Úkol 10:

SELECT
	*,
	`life_expectancy_2019` - `life_expectancy_1950` AS `life_expectancy_diff`
FROM `v_life_expectancy_comparison`
ORDER BY `life_expectancy_diff` DESC;

SELECT
	*,
	`life_expectancy_2019` - `life_expectancy_1950` AS `life_expectancy_diff`
FROM v_life_expectancy_comparison
WHERE `country` IN ('Zambia', 'Mozambique', 'Zimbabwe', 'Angola', 'Botswana')
ORDER BY `life_expectancy_diff` DESC;

-- Úkol 11:

SELECT
	`country`,
	`religion`
FROM countries c
WHERE `religion` = 'Buddhism';

-- Úkol 12:

SELECT
	`country`,
	`independence_date`
FROM countries c
WHERE
	`independence_date` < 1500;

-- Úkol 13:

SELECT
	`country`,
	`elevation`
FROM countries c
WHERE `elevation` > 2000;

-- Úkol 14:

SELECT
	`country`,
	`national_symbol`
FROM countries c
WHERE 
	`national_symbol` IS NULL
	OR `national_symbol` != 'animal';

-- Úkol 15:

SELECT
	`country`,
	`religion`
FROM countries c
WHERE
	`religion` NOT IN ('Christianity', 'Islam');

-- Úkol 16:

SELECT
	`country`,
	`currency_name`,
	`religion`
FROM countries c
WHERE
	`currency_name` = 'Euro'
	AND `religion` != 'Christianity';

-- Úkol 17:

SELECT
	`country`,
	`yearly_average_temperature`
FROM countries c
WHERE
	`yearly_average_temperature` < 0
	OR `yearly_average_temperature` > 30;

-- Úkol 18:

SELECT
	`country`,
	`independence_date`
FROM countries c
WHERE 
	`independence_date` >= 1800
	AND `independence_date` < 1900;

-- Úkol 19:

SELECT
	`country`,
	`population`,
	`surface_area`,
	round(`population` / `surface_area`, 2) AS `population_density_calculated`,
	round(`population_density`, 2) AS `population_density`,
	abs(round(`population` / `surface_area`, 2) - round(`population_density`, 2)) AS `diff`
FROM countries c;

-- Úkol 20:

SELECT
	`country`,
	`yearly_average_temperature` AS `yearly_average_temperature_c`,
	round(`yearly_average_temperature` * 9 / 5 + 32, 2) AS `yearly_average_temperature_f`
FROM countries c
WHERE `yearly_average_temperature` IS NOT NULL;

-- Úkol 21:

SELECT
	`country`,
	`yearly_average_temperature`,
	CASE
		WHEN `yearly_average_temperature` < 0 THEN 'freezing'
		WHEN `yearly_average_temperature` <= 10 THEN 'chilly'
		WHEN `yearly_average_temperature` <= 20 THEN 'mild'
		WHEN `yearly_average_temperature` <= 30 THEN 'warm'
		WHEN `yearly_average_temperature` > 30 THEN 'scorching'
	END AS `climate`
FROM countries c;

-- Úkol 22:

SELECT
	`country`,
	`north`,
	`south`,
	CASE
		WHEN `south` >= 0 THEN 'north'
		WHEN `north` <= 0 THEN 'south'
		WHEN `north` > 0 AND `south` < 0 THEN 'equator'
	END AS `N_S_hemisphere`
FROM countries c;

-- COVID-19: ORDER BY

-- Úkol 1:

SELECT
	`country`,
	`date`,
	`confirmed`
FROM covid19_basic cb
WHERE `country` = 'Austria'
ORDER BY `date` DESC;

-- Úkol 2:

SELECT
	`deaths`
FROM covid19_basic cb
WHERE `country` = 'Czechia';

-- Úkol 3:

SELECT
	`deaths`
FROM covid19_basic cb
WHERE `country` = 'Czechia'
ORDER BY `date` DESC;

-- Úkol 4:

SELECT
	sum(`confirmed`)
FROM covid19_basic cb
WHERE `date` = '2020-08-31';

-- Úkol 5:

SELECT
	DISTINCT `province`
FROM covid19_detail_us cdu
ORDER BY `province`;

-- Úkol 6:

SELECT
	*,
	`confirmed` - `recovered` AS `ill`
FROM covid19_basic cb
WHERE `country` = 'Czechia'
ORDER BY `date`;

-- Úkol 7:

SELECT
	`country`,
	`confirmed`
FROM covid19_basic_differences cbd
WHERE `date` = '2020-07-01'
ORDER BY `confirmed` DESC
LIMIT 10;

-- Úkol 8:

SELECT
	`country`,
	`confirmed`,
	IF (`confirmed` > 10000, 1, 0) AS `confirmed_more_then_10000`
FROM covid19_basic_differences cbd
WHERE `date` = '2020-07-01'
ORDER BY `confirmed` DESC;

-- Úkol 9:

SELECT
	`date`
FROM covid19_detail_us cdu
ORDER BY `date`;

SELECT
	`date`
FROM covid19_detail_us cdu
ORDER BY `date` DESC;

-- Úkol 10:

SELECT
	*
FROM covid19_basic cb
ORDER BY
	`country`,
	`date` DESC;

-- COVID-19: CASE Expression

-- Úkol 1:

SELECT
	`country`,
	`confirmed`,
	CASE
		WHEN `confirmed` > 10000 THEN 1
		ELSE 0
	END AS `confirmed_more_then_10000`
FROM covid19_basic_differences cbd
WHERE `date` = '2020-08-30'
ORDER BY `confirmed` DESC;

-- Úkol 2:

SELECT
	*,
	CASE 
		WHEN `country` IN ('Germany', 'France', 'Spain') THEN 'Evropa'
		ELSE 'Ostatní'
	END AS `flag_evropa`
FROM covid19_basic_differences cbd;

-- Úkol 3:

SELECT
	*,
	CASE
		WHEN `country` LIKE 'Ge%' THEN 'GE zeme'
		ELSE 'ostatní'
	END AS `flag_ge`
FROM covid19_basic_differences cbd
ORDER BY `flag_ge`;

-- Úkol 4:

SELECT
	*,
	CASE
		WHEN `confirmed` IS NULL OR `confirmed` <= 1000 THEN 'méně než 1 000'
		WHEN `confirmed` <= 10000 THEN '1001 - 10 000'
		WHEN `confirmed` > 10000 THEN 'více než 10 000'
		ELSE 'error'
	END AS `category`
FROM covid19_basic_differences cbd
ORDER BY `date` DESC;

-- Úkol 5:

SELECT
	*,
	CASE
		WHEN `country` IN ('China', 'US', 'India') AND `confirmed` > 10000 THEN 1
		ELSE 0
	END AS `flag`
FROM covid19_basic_differences cbd;

-- Úkol 6:

SELECT
	*,
	CASE
		WHEN `country` LIKE '%a' THEN 'A země'
		ELSE 'ne A země'
	END AS `flag_end_a`
FROM covid19_basic_differences cbd;

-- COVID-19: WHERE, IN a LIKE

-- Úkol 1:

CREATE OR REPLACE VIEW v_Radek_Vach_my_view AS
	SELECT
		*
	FROM covid19_basic cb
	WHERE `country` IN ('US', 'China', 'India');

-- Úkol 2:

SELECT
	*
FROM covid19_basic cb
WHERE `country` IN (
	SELECT
		DISTINCT `country`
	FROM lookup_table lt
	WHERE `population` >= 100000000
);

-- Úkol 3:

SELECT
	*
FROM covid19_basic cb
WHERE `country` IN (
	SELECT
		`country`
	FROM covid19_detail_us cdu
);

-- Úkol 4:

SELECT
	DISTINCT `country`
FROM covid19_basic cb
WHERE `country` IN (
	SELECT
		`country`
	FROM covid19_basic_differences cbd
	WHERE `confirmed` > 10000
);

-- Úkol 5:

SELECT
	DISTINCT `country`
FROM covid19_basic cb
WHERE `country` NOT IN (
	SELECT
		`country`
	FROM covid19_basic_differences cbd
	WHERE `confirmed` > 1000
);

-- Úkol 6:

SELECT
	DISTINCT `country`
FROM covid19_basic cb
WHERE `country` NOT LIKE 'A%';