
allData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallEffects.csv' USING PigStorage(',') AS (movie:int,user:int,centered_rating:float) ;


data_clean = FOREACH allData GENERATE movie, user, centered_rating ;
data_clean2 = FOREACH allData GENERATE movie as movie2, user as user2, centered_rating as centered_rating2 ; 
pairs = JOIN data_clean BY user, data_clean2 BY user2 ; 

pairs = FOREACH pairs GENERATE movie, user, centered_rating, movie2, user2, centered_rating2 ;

pairs_unique = FILTER pairs by movie < movie2 ;

coratings1 = FOREACH pairs_unique GENERATE user, movie, movie2, centered_rating, centered_rating2, (centered_rating * centered_rating) AS ratingSq, (centered_rating2 * centered_rating2) AS rating2Sq, (centered_rating * centered_rating2) AS dotProduct ; 
    
aggregate_pairs = GROUP coratings1 BY (movie, movie2) ;

DUMP aggregate_pairs ;
STORE aggregate_pairs INTO '$CONTAINER/$PSEUDO/DonnotLaugel/smallReco.csv' USING PigStorage(',') ;