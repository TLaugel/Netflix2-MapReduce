
A = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Effects-$dateMin/p*' USING PigStorage(',') AS (movie:int,user:int,centered_rating:float);

-- // create unique movie pairs
A2 = FOREACH A GENERATE movie AS movie2, user AS user2, centered_rating AS centered_rating2;
B = JOIN A BY user, A2 BY user2; 


-- // create correlation coefficient
CA = GROUP B BY (movie, movie2);
CB = FOREACH CA {
                rating_sq = $1.centered_rating * $1.centered_rating;
                rating2_sq = $1.centered_rating2 * $1.centered_rating2;
                dot_prod = $1.centered_rating * $1.centered_rating2;

                GENERATE FLATTEN(group) AS (movie, movie2),
                        COUNT($1) AS count:int,
                        SUM($1.centered_rating) AS ratingSum:float,
                        SUM($1.centered_rating2) AS rating2Sum:float,
                        SUM(rating_sq) AS rating_sq_sum:float,
                        SUM(rating2_sq) AS rating2_sq_sum:float,
                        SUM(dot_prod) AS dot_prod_sum:float;
}

CC = FILTER CB BY count >= 10;

COVAR = FOREACH CC GENERATE movie,
                            move2,
                            (double)(count * dot_prod_sum - rating_sum * rating2_sum) / ( SQRT((double)(count * rating_sq_sum - rating_sum * rating_sum)) * SQRT((double)(count * rating2_sq_sum - rating2_sum * rating2_sum)) ) AS correlation:float;

STORE COVAR INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Reco-$dateMin' USING PigStorage(',') ;
