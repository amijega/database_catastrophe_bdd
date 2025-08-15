
--TABLES TEMPORAIRES--

CREATE TABLE tmp (name VARCHAR, alpha_2 VARCHAR, alpha_3 VARCHAR, country_code INT, iso_3166_2 VARCHAR,region varchar, sub_region VARCHAR, intermediate_region VARCHAR, region_code INT, sub_region_code INT, intermediate_region_code INT);

\copy tmp FROM /home/solene/Bureau/BUT_1/BDD/SAE/github.csv DELIMITER ',' CSV HEADER

CREATE TABLE tmp2 (country VARCHAR, iso2 CHAR(2), iso3 CHAR(3), region_code INT, region VARCHAR, sub_region_code INT, sub_region VARCHAR, disaster VARCHAR, year INT, number INT);

\copy tmp2 FROM /home/solene/Bureau/BUT_1/BDD/SAE/Climate.csv DELIMITER ',' CSV HEADER

--INSERT DES DONNÉES DANS LA BDD--

INSERT INTO REGION (name,region_code) SELECT DISTINCT region,region_code FROM tmp WHERE region_code IS NOT NULL;

INSERT INTO SUB_REGION (name,sub_region_code,region_code) SELECT DISTINCT sub_region,sub_region_code,region_code FROM tmp WHERE sub_region_code IS NOT NULL AND region_code IS NOT NULL;

INSERT INTO COUNTRY (name,country_code,sub_region_code) SELECT DISTINCT name,country_code,sub_region_code FROM tmp WHERE sub_region_code IS NOT NULL;
UPDATE COUNTRY SET ISO2=tmp2.iso2, ISO3=tmp2.iso3 FROM tmp2 WHERE COUNTRY.name=tmp2.country;

INSERT INTO DISASTER (disaster) SELECT DISTINCT disaster FROM tmp2 WHERE tmp2.disaster IS NOT NULL;

INSERT INTO climate_disaster (country_code, disaster_code, year,number) SELECT country_code, disaster_code,year, number FROM country, disaster, tmp2 WHERE tmp2.country=country.name AND tmp2.disaster=disaster.disaster AND tmp2.year IS NOT NULL AND tmp2.number IS NOT NULL GROUP BY (country_code, disaster_code, year, number);

--SUPPRESSION DES TABLES TEMPORAIRES--

DROP TABLE tmp;
DROP TABLE tmp2;
