/* 
Dao THAUVIN
Mohammed DIAWARA
*/

--Vue utilisé

--Les medaillées : ensemble des personnes ayant optenu une médaille seul ou au sein d'une équipe
CREATE VIEW medaillees(medaille,gagnant,epreuve,epreuveid,sexe) AS (SELECT 'or' as medaille,mor as gagnant,nom,idES,sexe FROM epreuveSolo UNION SELECT 'argent' as medaille,margent as gagnant,nom,idES,sexe FROM epreuveSolo UNION SELECT 'bronze' as medaille,mbronze as gagnant,nom,idES,sexe FROM epreuveSolo 
UNION SELECT 'or' as medaille,idA as gagnant,nom,idEE,sexe FROM epreuveEquipe JOIN Membre ON Membre.ide=epreuveEquipe.mor UNION SELECT 'argent' as medaille,idA as gagnant,nom,idEE,sexe FROM epreuveEquipe JOIN Membre ON Membre.ide=epreuveEquipe.margent UNION SELECT 'bronze' as medaille,idA as gagnant,nom,idEE,sexe FROM epreuveEquipe JOIN Membre ON Membre.ide=epreuveEquipe.mbronze);


/*
Difficulté 1
*/

--1
SELECT DISTINCT Athlete.prenom,Athlete.nom FROM medaillees JOIN Athlete ON idA=gagnant JOIN pays ON pays.idp=athlete.idp WHERE pays.nom='Italie';

--2
SELECT epreuve,medaille,Athlete.nom,Pays.nom as nationalité FROM medaillees JOIN Athlete ON Athlete.idA=medaillees.gagnant JOIN pays ON pays.idP=Athlete.idP WHERE epreuve='100m' OR epreuve='200m' OR epreuve='400m' ORDER BY Epreuve,medaillees.sexe,medaille;

--3
SELECT prenom,Athlete.nom,EXTRACT(year FROM age(CURRENT_DATE,naissance)) as age FROM EpreuveEquipe JOIN MatchEquipe ON EpreuveEquipe.idEE=MatchEquipe.idEE JOIN ParticipationMEP ON ParticipationMEP.idMEP=MatchEquipe.idME JOIN Equipe ON Equipe.idE=ParticipationMEP.idE JOIN Membre ON Membre.idE=Equipe.idE JOIN Athlete ON Athlete.idA=membre.idA JOIN Pays ON Pays.idP=Athlete.idP WHERE EXTRACT(year FROM age(CURRENT_DATE,naissance))<25 AND EpreuveEquipe.nom='Handball' AND EpreuveEquipe.sexe='FEM' AND Pays.nom='France';

--4
SELECT medaillees.epreuve,medaille,temps FROM medaillees JOIN Athlete ON Athlete.idA=gagnant JOIN (SELECT MatchSolo.idES as idE,temps,ParticipationMSC.idA as part FROM MatchSolo JOIN ParticipationMSC ON ParticipationMSC.idMSC=MatchSolo.idMS UNION ALL SELECT MatchEquipe.idEE as idE,temps,Membre.idA as part  FROM MatchEquipe JOIN ParticipationMEC ON ParticipationMEC.idMEC=MatchEquipe.idME JOIN Membre ON Membre.idE=ParticipationMEC.idE) as matchs ON (Matchs.idE=medaillees.epreuveid AND matchs.part=Athlete.idA) WHERE Athlete.prenom='Michael' AND Athlete.nom='Phelps';

--5
SELECT DISTINCT Sport.nom FROM Sport JOIN EpreuveEquipe ON EpreuveEquipe.idS=Sport.idS;

--6
SELECT MIN(temps) as meilleurtemps FROM ParticipationMSC JOIN MatchSolo ON MatchSolo.idMS=ParticipationMSC.idMSC JOIN EpreuveSolo ON EpreuveSolo.idES=MatchSolo.idES WHERE EpreuveSolo.nom='Marathon';

/*
Difficulté 2
*/

--1
SELECT pays.nom,AVG(temps) as tempsmoyen from
Pays JOIN Athlete ON Pays.idp=Athlete.idP JOIN ParticipationMSC ON Athlete.idA=ParticipationMSC.idA JOIN MatchSolo ON MatchSolo.idms=ParticipationMSC.idMSC JOIN EpreuveSolo ON EpreuveSolo.ides=MatchSolo.idEs where EpreuveSolo.nom='200m nage libre' GROUP BY Pays.nom;

--2
SELECT Pays.nom,COUNT(mor.idP)+COUNT(margent.idp)+COUNT(mbronze.idP) as medailles FROM Pays LEFT JOIN (SELECT aor.idp FROM EpreuveSolo JOIN Athlete aor ON aor.idA=epreuveSolo.mor UNION SELECT eor.idp FROM EpreuveEquipe JOIN Equipe eor ON eor.idE=epreuveEquipe.mor) as mor ON mor.idp=Pays.idp LEFT JOIN(SELECT aargent.idp FROM EpreuveSolo JOIN Athlete aargent ON aargent.idA=epreuveSolo.margent UNION SELECT eargent.idp FROM EpreuveEquipe JOIN Equipe eargent ON eargent.idE=epreuveEquipe.margent) as margent ON margent.idp=Pays.idp LEFT JOIN (SELECT abronze.idp FROM EpreuveSolo JOIN Athlete abronze ON abronze.idA=epreuveSolo.mbronze UNION SELECT ebronze.idp FROM EpreuveEquipe JOIN Equipe ebronze ON ebronze.idE=epreuveEquipe.mbronze) as mbronze ON mbronze.idp=Pays.idp GROUP BY Pays.nom;

--3
select e.nom as epreuve,a.nom as nom_or,p.nom as nationalité_or,a2.nom as nom_argent,p2.nom as nationalité_argent from Athlete a,Pays p,EpreuveSolo e,Athlete a2,Pays p2 where mor=a.idA and margent=a2.idA and a.idp=p.idp and a2.idp=p2.idp;

--4
SELECT nom,prenom from Athlete WHERE Athlete.idA NOT IN(SELECT gagnant FROM medaillees WHERE medaille='or');

--5
SELECT sport.nom FROM SPort WHERE sport.ids NOT iN(select s.ids from Sport s,EpreuveSolo e,Pays p,Athlete aor,Athlete aargent,Athlete abronze where s.idS=e.idS AND e.mor=aor.idA and e.margent=aargent.idA and e.mbronze=abronze.idA and p.nom='France'and (p.idp=aor.idp or p.idp=aargent.idP or p.idp=abronze.idP)) AND Sport.idS NOT IN(SELECT idS FROM EpreuveEquipe);

--6
select a.prenom,a.nom,max(temps) as temps from Athlete a,ParticipationMSC pa,EpreuveSolo e,MatchSolo s1 where a.idA=pa.idA and s1.idMs=pa.idMsc and s1.idES=e.idES and e.nom='100m' group by a.prenom,a.nom HAVING max(temps)<'00:00:10.000';


/*
Difficulté 3
*/

--1
with datevictoire as (SELECT gagnant as idA,jour FROM MatchSolo UNION SELECT idA,jour FROM MatchEquipe JOIN Membre ON MatchEquipe.gagnant=Membre.ide)
SELECT DISTINCT prenom,nom FROM Athlete NATURAL JOIN datevictoire v1 JOIN datevictoire v2 ON v2.idA=v1.idA AND v1.jour=v2.jour-1 JOIN datevictoire v3 ON v3.idA=v2.idA AND v2.jour=v3.jour-1 JOIN datevictoire v4 ON v4.idA=v3.idA AND v3.jour=v4.jour-1 JOIN datevictoire v5 ON v5.idA=v4.idA AND v4.jour=v5.jour-1 JOIN datevictoire v6 ON v6.idA=v5.idA AND v5.jour=v6.jour-1 JOIN datevictoire v7 ON v7.idA=v6.idA AND v6.jour=v7.jour-1;    

--2 
SELECT Pays.nom FROM Pays WHERE NOT EXISTS(SELECT * FROM Sport WHERE Sport.ids NOT IN(
SELECT EpreuveSolo.ids FROM EpreuveSolo JOIN Athlete ON Athlete.idA=mor WHERE Athlete.idp=Pays.idp
UNION
SELECT EpreuveSolo.ids FROM EpreuveSolo JOIN Athlete ON Athlete.idA=margent WHERE Athlete.idp=Pays.idp
UNION
SELECT EpreuveSolo.ids FROM EpreuveSolo JOIN Athlete ON Athlete.idA=mbronze WHERE Athlete.idp=Pays.idp
UNION
SELECT EpreuveEquipe.ids FROM EpreuveEquipe JOIN Equipe ON Equipe.idE=mbronze WHERE Equipe.idp=Pays.idp
UNION
SELECT EpreuveEquipe.ids FROM EpreuveEquipe JOIN Equipe ON Equipe.idE=margent WHERE Equipe.idp=Pays.idp
UNION
SELECT EpreuveEquipe.ids FROM EpreuveEquipe JOIN Equipe ON Equipe.idE=mor WHERE Equipe.idp=Pays.idp
));

--3
SELECT Sport.nom,COUNT(ide) as nombreEpreuves FROM Sport LEFT JOIN (SELECT ides as ide,ids FROM EpreuveSolo UNION ALL SELECT idee as ide,ids FROM EpreuveEquipe) as epreuve ON Epreuve.idS=Sport.idS  GROUP BY Sport.nom ORDER BY nombreEpreuves LIMIT 5;

--4
--si on ne considère pas le sexe des epreuves
SELECT CAST((
(SELECT COUNT(mbronze)+(SELECT COUNT(mbronze) FROM EpreuveEquipe WHERE mbronze IN(SELECT DISTINCT ide FROM Membre NATURAL JOIN athlete WHERE athlete.sexe='FEM')) as nbbronze FROM EpreuveSolo JOIN Athlete ON Athlete.ida=EpreuveSolo.mbronze WHERE athlete.sexe='FEM')
+
(SELECT COUNT(margent)+(SELECT COUNT(margent) FROM EpreuveEquipe WHERE margent IN(SELECT DISTINCT ide FROM Membre NATURAL JOIN athlete WHERE athlete.sexe='FEM')) as nbargent FROM EpreuveSolo JOIN Athlete ON Athlete.ida=EpreuveSolo.margent WHERE athlete.sexe='FEM')
+
(SELECT COUNT(mor)+(SELECT COUNT(mor) FROM EpreuveEquipe WHERE mor IN(SELECT DISTINCT ide FROM Membre NATURAL JOIN athlete WHERE athlete.sexe='FEM')) as nbor FROM EpreuveSolo JOIN Athlete ON Athlete.ida=EpreuveSolo.mor WHERE athlete.sexe='FEM')
)
*100/
(CAST(COUNT(epreuve.mor)+COUNT(epreuve.margent)+COUNT(epreuve.mbronze) as numeric(6,3))) as numeric(6,3)) 
as pourcentagemedaillesfemmes
FROM (SELECT mor,margent,mbronze FROM EpreuveSolo UNION ALL SELECT mor,margent,mbronze FROM EpreuveEquipe) as epreuve;

--si on considère le sexe des épreuves
SELECT CAST(
(SELECT (COUNT(mor)+COUNT(margent)+COUNT(mbronze)) FROM (SELECT ides as ide,sexe,mor,margent,mbronze FROM EpreuveSolo UNION ALL SELECT idee as ide,sexe,mor,margent,mbronze FROM EpreuveEquipe) as epreuve WHERE Epreuve.sexe='FEM')
*100/
(CAST(COUNT(epreuve.mor)+COUNT(epreuve.margent)+COUNT(epreuve.mbronze) as numeric(6,2))) as numeric(6,2)) 
as pourcentagemedaillesfemmes
FROM (SELECT mor,margent,mbronze FROM EpreuveSolo UNION ALL SELECT mor,margent,mbronze FROM EpreuveEquipe) as epreuve;

/*
Bonus 
*/

--Le nombre d'épreuves se déroulant le 2016-08-14
SELECT COUNT(DISTINCT id) FROM (SELECT idee as id,jour FROM MatchEquipe UNION SELECT ides as id,jour FROM MatchSolo) as epreuves  WHERE epreuves.jour='2016-08-14';
--On compte le nombre d'id d'épreuves dont un match d'équipe ou solitaire ce passe le 2016-08-14

--Les athlètes ayant participés au JO de Rio 2016
SELECT DISTINCT prenom,nom FROM
(SELECT idA as typ FROM (SELECT idA FROM ParticipationMSP UNION SELECT idA FROM ParticipationMSC UNION SELECT idA FROM ParticipationMSM) as ParticipationSolo
UNION
SELECT idA as typ FROM (SELECT idA FROM ParticipationMEP NATURAL JOIN Membre UNION SELECT idA FROM ParticipationMEC NATURAL JOIN Membre UNION SELECT idA FROM ParticipationMEM NATURAL JOIN Membre) as ParticipationEquipe
) as participants NATURAL JOIN Athlete;
--On recupère l'id des athlètes des tables Participations (Solo : MSP/MSC/MSM puis Equipe : MEP/MEC/MEM) puis on récupère leurs noms et prenoms dans Athlete

--Les sportifs n'ayant pas participé ni à un match en equipe, ni à un match noté par point
SELECT prenom,nom FROM Athlete WHERE idA NOT IN(SELECT idA FROM ParticipationMEP NATURAL JOIN Membre UNION SELECT idA FROM ParticipationMEC NATURAL JOIN Membre UNION SELECT idA FROM ParticipationMEM NATURAL JOIN Membre) AND idA NOT IN(SELECT idA FROM participationMSP);
--On verifie tous les id d'Athletes n'étant pas dans les tables de participations en équipes en regardant s'il n'est pas membre d'une des équipes puis on verifie que l'id n'est pas dans celui des Participation des Matchs Solitaire par Point

/*
Trop Complexe
*/

--Les Athletes n'ayant jamais joué avec un Athlète ayant le même age que lui

/*
L'indice
*/

CREATE MATERIALIZED VIEW Indice AS (
SELECT Sport.idS,Sport.nom,jour,
COUNT(DISTINCT Matchs.idM) as NombreEvenements,
COUNT(DISTINCT Athletes.idA)
as NombreAthletes,
COUNT(DISTINCT Matchs.idM)*5+COUNT(DISTINCT Athletes.idA) as NombreVolontaires
FROM Sport JOIN (SELECT idS,idEE as idE,'equipe' as typ FROM EpreuveEquipe UNION SELECT idS,idES as idE,'solo' as typ FROM EpreuveSolo) as epreuve ON epreuve.idS=Sport.idS JOIN (SELECT idMS as idM,idES as idE,'solo' as typ,jour FROM MatchSolo UNION SELECT idME as idM, idEE as idE,'equipe' as typ,jour FROM MatchEquipe) as Matchs ON Matchs.idE=Epreuve.idE AND Matchs.typ=Epreuve.typ
JOIN
(SELECT DISTINCT idA as idA,idM,typ FROM 
(SELECT idA,idM,'solo' as typ FROM (SELECT idA,idMSC as idM FROM ParticipationMSC UNION ALL SELECT idA,idMSM as idM FROM ParticipationMSM UNION ALL SELECT idA,idMSP as idM FROM ParticipationMSP) as ParticipationSolo
UNION 
SELECT idA,idM,'equipe' as typ FROM (SELECT idE,idMEC as idM FROM ParticipationMEC UNION ALL SELECT idE,idMEM as idM FROM ParticipationMEM UNION ALL SELECT idE,idMEP as idM FROM ParticipationMEP) as ParticipationEquipe JOIN Membre ON Membre.idE=ParticipationEquipe.idE
) as Athlete) as Athletes ON Athletes.typ=Matchs.typ AND Matchs.idM =Athletes.idM
GROUP BY sport.idS,sport.nom,jour
); 

/*
Questions sur l'indice
*/

--nombre de volontaires par jour
SELECT jour,SUM(nombrevolontaires) as volontaires_par_jour FROM Indice GROUP BY jour;
--Les 10 sports(lieux) nécessitant le moins de volontaires
SELECT ids,nom,MAX(nombrevolontaires) as nbvolontaires FROM Indice GROUP BY ids,nom ORDER BY MAX(nombrevolontaires) LIMIT 10;
--Les 10 sports(lieux) nécessitant le plus de volontaires
SELECT ids,nom,MAX(nombrevolontaires) FROM Indice GROUP BY ids,nom ORDER BY MAX(nombrevolontaires) DESC LIMIT 10;
--Le jour demandant le plus de volontaires
SELECT jour,SUM(nombrevolontaires) as volontaires FROM Indice GROUP BY jour HAVING SUM(nombrevolontaires)=(SELECT MAX(indice) FROM (SELECT SUM(i.nombrevolontaires) as indice FROM Indice i GROUP BY jour) as indiceparjour);
