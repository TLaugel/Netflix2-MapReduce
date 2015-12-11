
AA = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Effects-$dateMin.csv' USING PigStorage(',') AS (movie:int,user:int,centered_rating:float);

-- // create unique movie pairs
AB = FOREACH A GENERATE movie, user, centered_rating;
AB2 = FOREACH A GENERATE movie AS movie2, user AS user2, centered_rating AS centered_rating2; 
PA = JOIN AB BY user, AB2 BY user2; 
PB = FILTER PA BY movie < movie2 ;


-- // create correlation coefficient
CA = GROUP PB BY (movie, movie2);
CB = FOREACH CA GENERATE FLATTEN(group) AS (movie, movie2),
                        COUNT($1) AS count:int,
                        SUM($1.centered_rating) AS ratingSum:float,
                        SUM($1.centered_rating2) AS rating2Sum:float,
                        SUM($1.centered_rating * $1.centered_rating) AS ratingSqSum:float,
                        SUM($1.centered_rating2 * $1.centered_rating2) AS rating2SqSum:float,
                        SUM($1.centered_rating * $1.centered_rating2) AS dotProductSum:float;

CC = FILTER CB BY count >= 10;

COVAR = FOREACH CC GENERATE movie,
                            move2,
                            (double)(count * dotProductSum - ratingSum * rating2Sum) / ( SQRT((double)(num * ratingSqSum - ratingSum * ratingSum)) * SQRT((double)(num * rating2SqSum - rating2Sum * rating2Sum)) ) AS correlation:float;

STORE COVAR INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Reco-$dateMin.csv' USING PigStorage(',') ;
