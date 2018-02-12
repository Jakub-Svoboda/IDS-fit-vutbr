/*
* Project: IDS project #2
* Authors: Jakub Svoboda - xsvobo0z, Michael Schmid - xschmi08
* Date: 25. February 2017
*/

/*Delete index*/
DROP INDEX jmeno_index;
/*Delete sequences*/
DROP SEQUENCE pacient_seq;
DROP SEQUENCE lecba_seq;
DROP SEQUENCE lek_seq;
DROP SEQUENCE pojistovna_seq;
DROP SEQUENCE vysetreni_seq;
DROP SEQUENCE lekar_seq;
DROP SEQUENCE faktura_seq;
DROP SEQUENCE navsteva_seq;
DROP SEQUENCE sestra_seq;
DROP SEQUENCE vykon_seq;
DROP SEQUENCE predepsany_lek_seq;
/*Delete tables*/
DROP TABLE pacient CASCADE CONSTRAINTS;
DROP TABLE lecba CASCADE CONSTRAINTS;
DROP TABLE lek CASCADE CONSTRAINTS;
DROP TABLE pojistovna CASCADE CONSTRAINTS;
DROP TABLE vysetreni CASCADE CONSTRAINTS;
DROP TABLE lekar CASCADE CONSTRAINTS;
DROP TABLE faktura CASCADE CONSTRAINTS;
DROP TABLE navsteva CASCADE CONSTRAINTS;
DROP TABLE sestra CASCADE CONSTRAINTS;
DROP TABLE osetreni CASCADE CONSTRAINTS;
DROP TABLE vykon CASCADE CONSTRAINTS;
DROP TABLE predepsany_lek CASCADE CONSTRAINTS;
DROP TABLE vlastni_pacient CASCADE CONSTRAINTS;
DROP TABLE cizi_pacient CASCADE CONSTRAINTS;
DROP TABLE akutni_navsteva CASCADE CONSTRAINTS;
DROP TABLE objednana_navsteva CASCADE CONSTRAINTS;

/*Create sequence*/
CREATE SEQUENCE pacient_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE lecba_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE lek_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE pojistovna_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE vysetreni_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE lekar_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE faktura_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE navsteva_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE sestra_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE vykon_seq START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE predepsany_lek_seq START WITH 1 INCREMENT BY 1 NOCYCLE;


CREATE TABLE pacient (
  id_pacient NUMBER PRIMARY KEY,
  rodne_cislo NUMBER NOT NULL CHECK(REGEXP_LIKE(rodne_cislo,'[0-9][0-9](0|1|2|3|5|6|7|8)[0-9][0-3][0-9][0-9]{3,4}')),
  jmeno VARCHAR(50) NOT NULL,
  prijmeni VARCHAR(50) NOT NULL,
  pohlavi VARCHAR2(10) CHECK (pohlavi='muž' or pohlavi='žena') NOT NULL,
	adresa VARCHAR(100) NOT NULL,
  id_pojistovna NUMBER NOT NULL
);

CREATE TABLE lecba(
	id_lecba NUMBER NOT NULL PRIMARY KEY,
	pocet_dni_uzivani NUMBER NOT NULL,
	mnozstvi NUMBER NOT NULL,
  id_lek NUMBER NOT NULL,
  id_pacient NUMBER NOT NULL,
  id_pojistovna NUMBER NOT NULL
);

CREATE TABLE lek(
	id_lek NUMBER NOT NULL PRIMARY KEY,
	nazev VARCHAR(50) NOT NULL,
	predpis NUMBER(1) CHECK(predpis=1 OR predpis=0) NOT NULL
);

CREATE TABLE pojistovna(
	id_pojistovna NUMBER NOT NULL PRIMARY KEY,
	jmeno VARCHAR(50) NOT NULL
);

CREATE TABLE vysetreni(
	id_vysetreni NUMBER NOT NULL PRIMARY KEY,
	datum VARCHAR(10) NOT NULL,		/*DD.MM.YYYY*/
	popis VARCHAR(255) NOT NULL,
  id_lekar NUMBER NOT NULL,
  id_pacient NUMBER NOT NULL
);

CREATE TABLE lekar(
	id_lekar NUMBER NOT NULL PRIMARY KEY,
	jmeno VARCHAR(50) NOT NULL,
	prijmeni VARCHAR(50) NOT NULL,
	cislo_uctu VARCHAR(50) NOT NULL
);

CREATE TABLE faktura(
	id_faktura NUMBER NOT NULL PRIMARY KEY,
	datum VARCHAR(10) NOT NULL,		/*DD.MM.YYYY*/
	castka NUMBER,
  id_pojistovna NUMBER NOT NULL,
  id_pacient NUMBER NOT NULL,
  id_lekar NUMBER NOT NULL
);

CREATE TABLE navsteva(
	id_navsteva NUMBER NOT NULL PRIMARY KEY,
	datum VARCHAR(10) NOT NULL,		/*DD.MM.YYYY*/
	popis VARCHAR(255) NOT NULL,
  id_pacient NUMBER NOT NULL,
	id_lekar NUMBER NOT NULL
);


CREATE TABLE sestra(
	id_sestra NUMBER NOT NULL PRIMARY KEY,
	jmeno VARCHAR(50) NOT NULL,
	prijmeni VARCHAR(50) NOT NULL
);

CREATE TABLE vykon(
	nazev VARCHAR(50) NOT NULL PRIMARY KEY,
	popis VARCHAR(255) NOT NULL
);

CREATE TABLE osetreni(
	nazev VARCHAR(50) NOT NULL,
  id_navsteva NUMBER NOT NULL,
  CONSTRAINT fk_osetreni PRIMARY KEY (id_navsteva, nazev),
  FOREIGN KEY (id_navsteva) REFERENCES navsteva(id_navsteva),
  FOREIGN KEY (nazev) REFERENCES vykon(nazev)

);

CREATE TABLE predepsany_lek(
	id_lek NUMBER NOT NULL,
	id_navsteva NUMBER NOT NULL,
  CONSTRAINT fk_predepsany_lek PRIMARY KEY (id_lek, id_navsteva),
  FOREIGN KEY (id_navsteva) REFERENCES navsteva(id_navsteva),
  FOREIGN KEY (id_lek) REFERENCES lek(id_lek)
);

CREATE TABLE vlastni_pacient(
	pacient_ref NUMBER NOT NULL REFERENCES pacient(id_pacient),
	PRIMARY KEY(pacient_ref)
);

CREATE TABLE cizi_pacient(
	pacient_ref NUMBER NOT NULL REFERENCES pacient(id_pacient),
	PRIMARY KEY(pacient_ref)
);

CREATE TABLE akutni_navsteva(
	navsteva_ref NUMBER NOT NULL REFERENCES navsteva(id_navsteva),
	PRIMARY KEY(navsteva_ref)
);

CREATE TABLE objednana_navsteva(
	navsteva_ref NUMBER NOT NULL REFERENCES navsteva(id_navsteva),
	id_sestra NUMBER NOT NULL,
	PRIMARY KEY(navsteva_ref)
);

ALTER TABLE pacient ADD CONSTRAINT fk_pojistovna FOREIGN KEY (id_pojistovna) REFERENCES pojistovna(id_pojistovna);
ALTER TABLE lecba ADD CONSTRAINT fk_lek FOREIGN KEY (id_lek) REFERENCES lek(id_lek);
ALTER TABLE lecba ADD CONSTRAINT fk_pacient FOREIGN KEY (id_pacient) REFERENCES pacient(id_pacient);
ALTER TABLE lecba ADD CONSTRAINT fk_pojistovna2 FOREIGN KEY (id_pojistovna) REFERENCES pojistovna(id_pojistovna);
ALTER TABLE vysetreni ADD CONSTRAINT fk_lekar FOREIGN KEY (id_lekar) REFERENCES lekar(id_lekar);
ALTER TABLE vysetreni ADD CONSTRAINT fk_pacient2 FOREIGN KEY (id_pacient) REFERENCES pacient(id_pacient);
ALTER TABLE faktura ADD CONSTRAINT fk_pojistovna3 FOREIGN KEY (id_pojistovna) REFERENCES pojistovna(id_pojistovna);
ALTER TABLE faktura ADD CONSTRAINT fk_pacient3 FOREIGN KEY (id_pacient) REFERENCES pacient(id_pacient);
ALTER TABLE faktura ADD CONSTRAINT fk_lekar2 FOREIGN KEY (id_lekar) REFERENCES lekar(id_lekar);
ALTER TABLE navsteva ADD CONSTRAINT fk_pacient4 FOREIGN KEY (id_pacient) REFERENCES pacient(id_pacient);
ALTER TABLE objednana_navsteva ADD CONSTRAINT fk_sestra FOREIGN KEY (id_sestra) REFERENCES sestra(id_sestra);
ALTER TABLE navsteva ADD CONSTRAINT fk_lekar3 FOREIGN KEY (id_lekar) REFERENCES lekar (id_lekar);


/*-----------------------------------------------------------*/
/*--------------------------TRIGGERY-------------------------*/
/*-----------------------------------------------------------*/

/*Trigger na overeni spravnosti ceskeho ibanu.*/
CREATE OR REPLACE TRIGGER iban_trigger
	BEFORE INSERT OR UPDATE
	OF cislo_uctu
	ON lekar
	FOR EACH ROW
	DECLARE
		kod_zeme VARCHAR(2);
		kontrolni_kod VARCHAR(2);
		cislo_uctu VARCHAR(20);
		iban_zamestnance lekar.cislo_uctu%TYPE;
		iban_kontrola varchar(24);
		iban_kontrola_prevod VARCHAR(50);
		string_index INT;
		string_char CHAR;
	BEGIN
    iban_zamestnance := :NEW.cislo_uctu;
		string_index:=1;
		kod_zeme:=substr(iban_zamestnance, 1,2);
		kontrolni_kod:=substr(iban_zamestnance, 3,2);
		cislo_uctu:=substr(iban_zamestnance, 5,20);
		IF (length(iban_zamestnance) != 24) THEN
			RAISE_APPLICATION_ERROR(-20000,'Délka českého iban musí být 24');
		END IF;
		IF (kod_zeme!='CZ') THEN
			RAISE_APPLICATION_ERROR(-20001, 'Zadejte český iban');
		END IF;
    iban_kontrola := concat(concat(cislo_uctu,kod_zeme),kontrolni_kod);
    WHILE (string_index<=length(iban_kontrola)) LOOP
      string_char:=substr(iban_kontrola, string_index, 1);
			IF (ascii(string_char)>=65 AND ascii(string_char)<=90) THEN
				iban_kontrola_prevod := concat(iban_kontrola_prevod,TO_CHAR((ascii(string_char)-55)));
			ELSE
				iban_kontrola_prevod:= concat(iban_kontrola_prevod,string_char);
			END IF;
      string_index:=string_index+1;
		END LOOP;
    IF (mod(to_number(iban_kontrola_prevod),97)!=1) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Kontrolní číslo nesouhlasí');
    END IF;
	END;

/*Pokud je nový pacient zadán s primárním klíčem NULL, vygeneruje mu nové ID ze sekvence.*/
CREATE OR REPLACE TRIGGER id_pacient_trigger
BEFORE INSERT ON pacient
FOR EACH ROW
   BEGIN
       SELECT pacient_seq.nextval INTO :NEW.id_pacient FROM dual;
   END;
/



/*-----------------------------------------------------------*/
/*-------------------------PROCEDURY-------------------------*/
/*-----------------------------------------------------------*/

/*Vypočítá, kolik průměrné zaplatil pacient s id předaným v argumentu za faktury. Při dělení nulou vyvolá vyjímku,
* obsahuje cursor a využívá proměnné s datovým typem odkazujícím se jinou tabulku.
*/
CREATE OR REPLACE PROCEDURE pacient_prumerne_zaplatil(id_pacient_arg NUMBER) AS
  BEGIN
    DECLARE CURSOR cursor_zaplatil is
    SELECT P.id_pacient, P.jmeno, P.prijmeni, F.castka
    FROM  pacient P, faktura F
    WHERE F.id_pacient = P.id_pacient AND P.id_pacient = id_pacient_arg;
			id_pacient pacient.id_pacient%TYPE;
			jmeno pacient.jmeno%TYPE;
			prijmeni pacient.prijmeni%TYPE;
			zaplatil faktura.castka%TYPE;
			castka_celkem faktura.castka%TYPE;
			castka_prumer faktura.castka%TYPE;
			pocet_faktur NUMBER;
			BEGIN
				pocet_faktur := 0;
				castka_celkem := 0;
				OPEN cursor_zaplatil;
				LOOP
					FETCH cursor_zaplatil INTO id_pacient, jmeno, prijmeni, zaplatil;
					EXIT WHEN cursor_zaplatil%NOTFOUND;
					pocet_faktur:=pocet_faktur+1;
					castka_celkem := castka_celkem + zaplatil;
				END LOOP;
				CLOSE cursor_zaplatil;
				castka_prumer := castka_celkem / pocet_faktur;
				DBMS_OUTPUT.put_line('Pacient ' || jmeno || ' ' || prijmeni || ' zaplatil pruměrně: ' || castka_prumer || 'Kč za fakturu.');
				EXCEPTION WHEN ZERO_DIVIDE THEN
					BEGIN
					DBMS_OUTPUT.put_line('Pacient s ID: ' || id_pacient_arg || ' nemá v databázi žádné faktury.');
				END;
			END;
	END;
/

/*Vyhledá v databázi výkonů provedéný výkon a vypíše jeho název a datailní popis. Obsahuje ošetření vyjímky pro neexistující vyšetření.*/
CREATE OR REPLACE PROCEDURE detaily_vykonu(id_vykon_arg vykon.nazev%TYPE) AS
  jmeno vykon.nazev%TYPE;
  popis vykon.popis%TYPE;
  BEGIN
    SELECT  V.nazev, V.popis
    INTO jmeno, popis
    FROM vykon V
    WHERE V.nazev = id_vykon_arg;
      DBMS_OUTPUT.put_line('Výkon ' || jmeno || ': ' || popis);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line('Vyšetření s názvem ' || id_vykon_arg ||' v databázi není.');
  END;



INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'valium', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'aspirin', 0);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'acylpyrin', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'morfium', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'paracetamol', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'gabagama', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'ibuprofen', 0);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'vikodin', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'m-iodbenzylguanidin', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'panadol', 0);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'kabiven', 1);
INSERT INTO lek(id_lek, nazev, predpis) VALUES (lek_seq.nextval,'Cabometyx', 1);

INSERT INTO pojistovna(id_pojistovna, jmeno) VALUES (pojistovna_seq.nextval, 'Pojišťovna ministerstva vnitra');
INSERT INTO pojistovna(id_pojistovna, jmeno) VALUES (pojistovna_seq.nextval, 'Revírní Bratrská Pokladna');
INSERT INTO pojistovna(id_pojistovna, jmeno) VALUES (pojistovna_seq.nextval, 'Vojenská Zdravotní pojišťovna');
INSERT INTO pojistovna(id_pojistovna, jmeno) VALUES (pojistovna_seq.nextval, 'Všeobecná Zdravotní pojišťovna');
INSERT INTO pojistovna(id_pojistovna, jmeno) VALUES (pojistovna_seq.nextval, 'Zaměstnanecká pojišťovna Škoda');

INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 9407035517, 'Jan', 'Nemocný', 'muž','Hlavní 10',1);
INSERT INTO vlastni_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo,jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 9158065147,'Jana', 'Nemocná', 'žena','Hlavní 10',1);
INSERT INTO vlastni_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 8203142178,'Láďa', 'Hruška', 'muž','Chutná 12',3);
INSERT INTO vlastni_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL ,7612195272, 'Jirka', 'Babica', 'muž','Záporná 8',3);
INSERT INTO cizi_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL ,6701293577, 'Jack', 'ONeill', 'muž','Hlavní 30',1);
INSERT INTO vlastni_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 9511131894,'Jack', 'Sparrow', 'muž','Lodní 1',3);
INSERT INTO cizi_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 8561126585,'Keira', 'Knightley', 'žena','Brněnská 420',3);
INSERT INTO cizi_pacient(pacient_ref) VALUES (pacient_seq.currval);
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 690814564,'Dan', 'Nekonečný', 'muž','Ohnivá 15',2);
INSERT INTO vlastni_pacient(pacient_ref) VALUES (pacient_seq.currval);

INSERT INTO lekar(id_lekar, jmeno, prijmeni, cislo_uctu) VALUES (lekar_seq.nextval, 'Doktorus','Medikus', 'CZ6907101781240000004159');
INSERT INTO lekar(id_lekar, jmeno, prijmeni, cislo_uctu) VALUES (lekar_seq.nextval, 'Radim','Uzel', 'CZ6508000000192000145399');

INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '03.07.2012', 422, 1,3,1);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '25.07.2019', 67, 1,5,2);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '21.12.2012', 666, 2,8,1);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '03.07.2012', 42, 1,4,1);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '07.11.2014', 302, 1,5,2);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '26.07.2019', 3000, 1,5,2);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '26.07.2019', 100, 1,5,1);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (faktura_seq.nextval, '26.07.2019', 202, 1,5,2);

INSERT INTO lecba(id_lecba, pocet_dni_uzivani, mnozstvi, id_lek, id_pacient, id_pojistovna) VALUES (lecba_seq.nextval, 7, 3, 1, 3, 2);
INSERT INTO lecba(id_lecba, pocet_dni_uzivani, mnozstvi, id_lek, id_pacient, id_pojistovna) VALUES (lecba_seq.nextval, 21, 6, 4, 5,1);
INSERT INTO lecba(id_lecba, pocet_dni_uzivani, mnozstvi, id_lek, id_pacient, id_pojistovna) VALUES (lecba_seq.nextval, 28, 1, 5, 8, 2);
INSERT INTO lecba(id_lecba, pocet_dni_uzivani, mnozstvi, id_lek, id_pacient, id_pojistovna) VALUES (lecba_seq.nextval, 21, 2, 1, 4,3);

INSERT INTO sestra(id_sestra, jmeno, prijmeni) VALUES (sestra_seq.nextval, 'Alenka', 'Databázová');
INSERT INTO sestra(id_sestra, jmeno, prijmeni) VALUES (sestra_seq.nextval, 'Martina', 'Relační');

INSERT INTO navsteva(id_navsteva, datum, popis, id_pacient, id_lekar) VALUES (navsteva_seq.nextval, '03.09.2012', 'Podezření na horečku, změřená teplota',3,2);
INSERT INTO objednana_navsteva(navsteva_ref, id_sestra) VALUES (1,1);
INSERT INTO navsteva(id_navsteva, datum, popis, id_pacient, id_lekar) VALUES (navsteva_seq.nextval, '03.02.2015', 'Nevolnost, změřen tlak',5,1);
INSERT INTO akutni_navsteva(navsteva_ref) VALUES (2);
INSERT INTO navsteva(id_navsteva, datum, popis, id_pacient,id_lekar) VALUES (navsteva_seq.nextval, '21.07.2013', 'Preventivní kontrola',8,1);
INSERT INTO objednana_navsteva(navsteva_ref, id_sestra) VALUES (3,2);
INSERT INTO navsteva(id_navsteva, datum, popis, id_pacient, id_lekar) VALUES (navsteva_seq.nextval, '07.12.2016', 'Očkování',4,2);
INSERT INTO objednana_navsteva(navsteva_ref, id_sestra) VALUES (4,1);

INSERT INTO predepsany_lek(id_lek, id_navsteva) VALUES (1,1);
INSERT INTO predepsany_lek(id_lek, id_navsteva) VALUES (4,2);
INSERT INTO predepsany_lek(id_lek, id_navsteva) VALUES (5,3);
INSERT INTO predepsany_lek(id_lek, id_navsteva) VALUES (1,4);

INSERT INTO vysetreni(id_vysetreni, datum, popis, id_lekar, id_pacient) VALUES (vysetreni_seq.nextval, '03.09.2012', 'Změřená teplota', 1, 3);
INSERT INTO vysetreni(id_vysetreni, datum, popis, id_lekar, id_pacient) VALUES (vysetreni_seq.nextval, '03.02.2015', 'Změřený tlak', 1, 5);
INSERT INTO vysetreni(id_vysetreni, datum, popis, id_lekar, id_pacient) VALUES (vysetreni_seq.nextval, '21.07.2013', 'Kontrola zraku', 2, 8);
INSERT INTO vysetreni(id_vysetreni, datum, popis, id_lekar, id_pacient) VALUES (vysetreni_seq.nextval, '07.12.2016', 'Očkování proti tetanu', 1, 4);
INSERT INTO vysetreni(id_vysetreni, datum, popis, id_lekar, id_pacient) VALUES (vysetreni_seq.nextval, '07.12.2016', 'Očkování proti žloutence', 1, 4);

INSERT INTO vykon(nazev, popis) VALUES ('Rentgen', 'pacientovi proveden rentgen části těla. Výsledky jsou odeslány zpět do ordinace');
INSERT INTO vykon(nazev, popis) VALUES ('Magnetická rezonance', 'pacientovi provedena MRI a výsledky jsou odeslány do ordinace');
INSERT INTO vykon(nazev, popis) VALUES ('Změření zraku', 'Pacientovi je změřen zrak a případně předepsány brýle');
INSERT INTO vykon(nazev, popis) VALUES ('Sádra', 'Pacientovi je zasádrována zlomená ruka');
INSERT INTO vykon(nazev, popis) VALUES ('Operace slepého střeva', 'Pacientovi je vyoperováno slepé střevo');

INSERT INTO osetreni(nazev, id_navsteva) VALUES ('Rentgen', 2);
INSERT INTO osetreni(nazev, id_navsteva) VALUES ('Změření zraku', 3);
INSERT INTO osetreni(nazev, id_navsteva) VALUES ('Magnetická rezonance', 4);



/*-----------------------------------------------------------*/
/*-------------------Dotazy SELECT-------------------*/
/*-----------------------------------------------------------*/

/*
 * Vypis pacientu a jimi uzivanych leku
 */
SELECT
	pacient.id_pacient,
	pacient.jmeno,
	pacient.prijmeni,
	lecba.id_lecba
FROM pacient
INNER JOIN lecba
ON pacient.id_pacient=lecba.id_pacient;

/*
 * Vypis pacientu a jejich pojistoven
 */
SELECT
	pacient.id_pacient,
	pacient.jmeno,
	pacient.prijmeni,
	pojistovna.jmeno
FROM pacient
INNER JOIN pojistovna
ON pacient.id_pojistovna=pojistovna.id_pojistovna;

/*
 * Vypise provedene vysetreni, jmeno a prijmeni lekare, ktery jej provedl a jmeno a prijmeni pacienta
 */
SELECT
	lekar.jmeno,
	lekar.prijmeni,
	vysetreni.datum,
	vysetreni.popis,
	pacient.jmeno,
	pacient.prijmeni
FROM lekar
INNER JOIN vysetreni
ON vysetreni.id_lekar=lekar.id_lekar
INNER JOIN pacient
ON pacient.id_pacient=vysetreni.id_pacient;

/*
 * Vypise lekare a pocet jimi vypsanych faktur
 */
SELECT
	lekar.jmeno,
	lekar.prijmeni,
	COUNT(faktura.id_faktura) AS pocet_faktur
FROM lekar
INNER JOIN faktura
ON lekar.id_lekar=faktura.id_lekar
GROUP BY
	lekar.id_lekar,
	lekar.jmeno,
	lekar.prijmeni;


/*
 * Vypise celkovou castku vynalozenou na faktury jednotlivymi pojistovnami
 */
SELECT
	pojistovna.jmeno,
	pojistovna.id_pojistovna,
	SUM(faktura.castka) AS vydaje_na_faktury
FROM pojistovna
INNER JOIN faktura
ON pojistovna.id_pojistovna=faktura.id_pojistovna
GROUP BY
	pojistovna.id_pojistovna,
	pojistovna.jmeno;

/*
 * Vypise vykony, ktere jiz byly predepsany v teto ordinaci
 */
SELECT vykon.nazev, vykon.popis
FROM vykon
WHERE EXISTS
			(SELECT * FROM osetreni WHERE osetreni.nazev=vykon.nazev);

/*
 * Vypise pacienty, kterym byla hrazena faktura na castku 300 a vice
 */
SELECT pacient.jmeno, pacient.prijmeni
FROM pacient
WHERE id_pacient IN(SELECT faktura.id_faktura FROM faktura WHERE castka>=300);

/*-----------------------------------------------------------*/
/*----------------------Volání procedur----------------------*/
/*-----------------------------------------------------------*/
/*Ukázkové volání procedury na výpočet průměrné částky na faktuře pro pacienta. Pacient s ID 1 nemá žádné faktury, procedura vyvolá vyjímku.*/
CALL pacient_prumerne_zaplatil(5);
CALL pacient_prumerne_zaplatil(3);
CALL pacient_prumerne_zaplatil(1);

/*Ukázkové volání procedury na výpis popisu výkonu. Ve třetím případě daný zákrok neexistuje, procedura vyvolá vyjímku.*/
CALL detaily_vykonu('Rentgen');
CALL detaily_vykonu('Magnetická rezonance');
CALL detaily_vykonu('Hello_World');

/*-----------------------------------------------------------*/
/*-------------------Explain Plan a Indexy-------------------*/
/*-----------------------------------------------------------*/

/* První ukázka je Explain Plan bez použití indexu.
* V druhém dotazu je využíván index pro jméno.
*/
EXPLAIN PLAN FOR
SELECT P.jmeno, P.prijmeni, COUNT(*) Pocet_faktur
FROM faktura F NATURAL JOIN pacient P
WHERE P.jmeno = 'Jack' AND P.prijmeni = 'ONeill' AND F.castka>50
GROUP BY P.jmeno, P.prijmeni;
SELECT * FROM TABLE(dbms_xplan.display);


CREATE INDEX jmeno_index ON pacient(jmeno);
EXPLAIN PLAN FOR
SELECT P.jmeno, P.prijmeni, COUNT(*) Pocet_faktur
FROM faktura F NATURAL JOIN pacient P
WHERE P.jmeno = 'Jack' AND P.prijmeni = 'ONeill' AND F.castka>50
GROUP BY P.jmeno, P.prijmeni;
SELECT * FROM TABLE(dbms_xplan.display);


/*-----------------------------------------------------------*/
/*---------------------------Práva---------------------------*/
/*-----------------------------------------------------------*/
GRANT ALL ON AKUTNI_NAVSTEVA TO XSVOBO0Z;
GRANT ALL ON CIZI_PACIENT TO XSVOBO0Z;
GRANT ALL ON FAKTURA TO XSVOBO0Z;
GRANT ALL ON LECBA TO XSVOBO0Z;
GRANT ALL ON LEK TO XSVOBO0Z;
GRANT ALL ON LEKAR TO XSVOBO0Z;
GRANT ALL ON NAVSTEVA TO XSVOBO0Z;
GRANT ALL ON OBJEDNANA_NAVSTEVA TO XSVOBO0Z;
GRANT ALL ON OSETRENI TO XSVOBO0Z;
GRANT ALL ON PACIENT TO XSVOBO0Z;
GRANT ALL ON POJISTOVNA TO XSVOBO0Z;
GRANT ALL ON PREDEPSANY_LEK TO XSVOBO0Z;
GRANT ALL ON SESTRA TO XSVOBO0Z;
GRANT ALL ON VLASTNI_PACIENT TO XSVOBO0Z;
GRANT ALL ON VYKON TO XSVOBO0Z;
GRANT ALL ON VYSETRENI TO XSVOBO0Z;

GRANT EXECUTE ON detaily_vykonu TO XSVOBO0Z;
GRANT EXECUTE ON pacient_prumerne_zaplatil TO XSVOBO0Z;

/*-----------------------------------------------------------*/
/*----------------Materializovaný pohled---------------------*/
/*-----------------------------------------------------------*/

--ALTER SESSION SET CURRENT_SCHEMA = xschmi08;
--ALTER SESSION SET CURRENT_SCHEMA = xsvobo0z;

DROP MATERIALIZED VIEW pacientView;

CREATE MATERIALIZED VIEW LOG ON xschmi08.pacient WITH PRIMARY KEY, ROWID;
CREATE MATERIALIZED VIEW LOG ON xschmi08.faktura WITH PRIMARY KEY, ROWID;

CREATE MATERIALIZED VIEW pacientView NOLOGGING CACHE BUILD IMMEDIATE REFRESH FAST ON COMMIT ENABLE QUERY REWRITE AS
  SELECT P.ROWID AS pacient_ID, F.ROWID as faktura_ID
  FROM xschmi08.pacient P, xschmi08.faktura F
  WHERE P.id_pacient = F.id_pacient AND F.castka > 200;

GRANT ALL ON pacientView TO XSVOBO0Z;

SELECT * FROM pacientView;
INSERT INTO pacient(id_pacient, rodne_cislo, jmeno, prijmeni, pohlavi, adresa, id_pojistovna) VALUES (NULL , 9008034444, 'George', 'Clooney', 'muž','Smetanova 88',2);
INSERT INTO faktura(id_faktura, datum, castka, id_pojistovna, id_pacient, id_lekar) VALUES (9999, '03.07.2012', 422, 1,9,1);
SELECT * FROM pacientView;