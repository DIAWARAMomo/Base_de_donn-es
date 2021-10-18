/* 
Dao THAUVIN
Mohammed DIAWARA
*/
DROP TABLE if EXISTS ParticipationMEP CASCADE;
DROP TABLE if EXISTS ParticipationMEM CASCADE;
DROP TABLE if EXISTS ParticipationMEC CASCADE;
DROP TABLE if EXISTS ParticipationMSM CASCADE;
DROP TABLE if EXISTS ParticipationMSC CASCADE;
DROP TABLE if EXISTS ParticipationMSP CASCADE;
DROP TABLE if EXISTS MatchSPoint CASCADE;
DROP TABLE if EXISTS MatchSMetre CASCADE;
DROP TABLE if EXISTS MatchSChrono CASCADE;
DROP TABLE if EXISTS MatchEChrono CASCADE;
DROP TABLE if EXISTS MatchEMetre CASCADE;
DROP TABLE if EXISTS MatchEPoint CASCADE;
DROP TABLE if EXISTS MatchEquipe CASCADE;
DROP TABLE if EXISTS MatchSolo CASCADE;
DROP TABLE if EXISTS EpreuveEquipe CASCADE;
DROP TABLE if EXISTS EpreuveSolo CASCADE;
DROP TABLE if EXISTS Membre CASCADE;
DROP TABLE if EXISTS Equipe CASCADE;
DROP TABLE if EXISTS Sport CASCADE;
DROP TABLE if EXISTS Athlete CASCADE;
DROP TABLE if EXISTS Pays CASCADE;

CREATE TABLE Pays(
	idP serial primary key,
	nom VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Athlete(
	idA serial primary key,
	prenom VARCHAR(255),
	nom VARCHAR(255) NOT NULL,
	naissance date,
	sexe CHAR(3) CHECK(sexe='MAL' OR sexe='FEM') NOT NULL  DEFAULT 'MAL',
	idP integer NOT NULL REFERENCES Pays ON delete CASCADE
);


CREATE TABLE Sport(
	idS serial primary key,
	nom VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Equipe (
	idE serial primary key,
	idP integer NOT NULL REFERENCES Pays ON delete CASCADE
);


CREATE TABLE EpreuveSolo (
	idES serial primary key,
	nom VARCHAR(255) NOT NULL,
	sexe CHAR(3) CHECK(sexe='MAL' OR sexe='FEM' OR sexe='MIX') NOT NULL  DEFAULT 'MAL',
	mor integer REFERENCES Athlete ON delete SET NULL,
	margent integer REFERENCES Athlete ON DELETE SET NULL,
	mbronze integer REFERENCES Athlete ON DELETE SET NULL,
	idS INTEGER NOT NULL REFERENCES Sport ON DELETE CASCADE,
	UNIQUE(idS,nom,sexe),
	CHECK(mor<>margent),
	CHECK(mor<>mbronze),
	CHECK(mbronze<>margent)
);

CREATE TABLE EpreuveEquipe (
	idEE serial primary key,
	nom VARCHAR(255) NOT NULL,
	idS integer NOT NULL REFERENCES Sport ON DELETE CASCADE,
	mor integer REFERENCES Equipe ON DELETE SET NULL,
	margent integer REFERENCES Equipe ON DELETE SET NULL,
	mbronze integer REFERENCES Equipe ON DELETE SET NULL,
	sexe CHAR(3) CHECK(sexe='MAL' OR sexe='FEM' OR sexe='MIX') NOT NULL  DEFAULT 'MAL',
	UNIQUE(idS,nom,sexe),
	CHECK(mor<>margent),
	CHECK(mor<>mbronze),
	CHECK(mbronze<>margent)
);



CREATE TABLE Membre (
	idA integer REFERENCES Athlete ON DELETE CASCADE,
	idE integer REFERENCES Equipe ON DELETE CASCADE,
	primary key(idA,idE)
);

CREATE TABLE MatchSolo (
	idMS serial primary key,
	jour date NOT NULL,
	gagnant integer REFERENCES Athlete ON DELETE SET NULL,
	idES integer NOT NULL REFERENCES EpreuveSolo ON DELETE CASCADE,
	tour VARCHAR(255)
);

CREATE TABLE MatchEquipe (
	idME serial primary key,
	jour date NOT NULL,
	gagnant integer REFERENCES Equipe ON DELETE SET NULL,
	idEE integer NOT NULL REFERENCES EpreuveEquipe ON DELETE CASCADE,
	tour VARCHAR(255)
);

CREATE TABLE MatchSChrono (
	idMS serial REFERENCES MatchSolo ON DELETE CASCADE,
	primary key(idMS)
);

CREATE TABLE MatchSMetre (
	idMS serial REFERENCES MatchSolo ON DELETE CASCADE,
	primary key(idMS)
);

CREATE TABLE MatchSPoint (
	idMS serial REFERENCES MatchSolo ON DELETE CASCADE,
	primary key(idMS)
);

CREATE TABLE MatchEChrono (
	idME serial REFERENCES MatchEquipe ON DELETE CASCADE,
	primary key(idME)
);

CREATE TABLE MatchEMetre (
	idME serial REFERENCES MatchEquipe ON DELETE CASCADE,
	primary key(idME)
);

CREATE TABLE MatchEPoint (
	idME serial REFERENCES MatchEquipe ON DELETE CASCADE,
	primary key(idME)
);

CREATE TABLE ParticipationMEM (
	idE integer REFERENCES Equipe ON DELETE CASCADE,
	idMEM serial REFERENCES MatchEMetre ON DELETE CASCADE,
	distance integer,
	primary key(idE,idMEM)
);

CREATE TABLE ParticipationMEC (
	idE integer REFERENCES Equipe ON DELETE CASCADE,
	idMEC serial REFERENCES MatchEChrono ON DELETE CASCADE,
	temps time,
	primary key(idE,idMEC)
);

CREATE TABLE ParticipationMEP (
	idE integer REFERENCES Equipe ON DELETE CASCADE,
	idMEP serial REFERENCES MatchEPoint ON DELETE CASCADE,
	score numeric(6,3),
	primary key(idE,idMEP)
);

CREATE TABLE ParticipationMSM (
	idA integer REFERENCES Athlete ON DELETE CASCADE,
	idMSM serial REFERENCES MatchSMetre ON DELETE CASCADE,
	distance numeric(6,3),
	primary key(idA,idMSM)
);

CREATE TABLE ParticipationMSC (
	idA integer REFERENCES Athlete ON DELETE CASCADE,
	idMSC serial REFERENCES MatchSChrono ON DELETE CASCADE,
	temps time,
	primary key(idA,idMSC)
);

CREATE TABLE ParticipationMSP (
	idA integer REFERENCES Athlete ON DELETE CASCADE,
	idMSP serial REFERENCES MatchSPoint ON DELETE CASCADE,
	score numeric(6,3),
	primary key(idA,idMSP)
);
