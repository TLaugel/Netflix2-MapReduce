
A = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Train-$dateMin/p*' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray);

MA = GROUP A BY movie;
MB = FOREACH MA GENERATE group AS movieid,
                        SUM($1.rating)/(float)COUNT($1.rating) AS avg_movie_rating:float;
AMA = JOIN A BY movie, MB BY movieid;

UA = GROUP AMA BY user;
UB = FOREACH UA GENERATE group AS userid,
                        (SUM($1.rating) - SUM($1.avg_movie_rating)) AS rbar_user:float;
AMUA = JOIN AMA BY user, UB by userid;

OUT = FOREACH AMUA GENERATE movie, user, (rating - rbar_user) as centered_rating:float;
OUT2 = ORDER OUT BY user ;

STORE OUT2 INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Effects-$dateMin.csv' USING PigStorage(',');
