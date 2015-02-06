
allData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallEffects.csv' USING PigStorage(',') AS (movie:int,user:int,centered_rating:float) ;


data_clean = FOREACH allData GENERATE movie, user, centered_rating ;
data_clean2 = FOREACH allData GENERATE movie as movie2, user as user2, centered_rating as centered_rating2 ; 
pairs = JOIN data_clean BY user, data_clean2 BY user2 ; 

pairs = FOREACH pairs GENERATE movie, user, centered_rating, movie2, user2, centered_rating2 ;

pairs_unique = FILTER pairs by movie < movie2 ;

coratings1 = FOREACH pairs_unique GENERATE user, movie, movie2, centered_rating, centered_rating2, (centered_rating * centered_rating) AS ratingSq, (centered_rating2 * centered_rating2) AS rating2Sq, (centered_rating * centered_rating2) AS dotProduct ; 
    
aggregate_pairs = GROUP coratings1 BY (movie, movie2) ;
coratings2 = FOREACH aggregate_pairs GENERATE group, COUNT(coratings1.movie) AS num, SUM(coratings1.centered_rating) AS ratingSum, SUM(coratings1.centered_rating2) AS rating2Sum, SUM(coratings1.ratingSq) AS ratingSqSum, SUM(coratings1.rating2Sq) AS rating2SqSum, SUM(coratings1.dotProduct) AS dotProductSum ;
 

-- filter enough obs for each pair:
coratings2 = FILTER coratings2 BY num >= 2;

recommendations = FOREACH coratings2 GENERATE group.movie, group.movie2, (double)(num * dotProductSum - ratingSum * rating2Sum) / ( SQRT((double)(num * ratingSqSum - ratingSum * ratingSum)) * SQRT((double)(num * rating2SqSum - rating2Sum * rating2Sum)) ) AS correlation ;

ordered = ORDER recommendations BY movie, correlation DESC ; 


DUMP ordered ; 

STORE ordered INTO '$CONTAINER/$PSEUDO/DonnotLaugel/smallReco.csv' USING PigStorage(',') ;