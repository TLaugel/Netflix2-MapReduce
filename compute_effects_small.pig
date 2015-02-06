
allData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract.csv' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray ) ;
--smallExtract, smallEffects
--allNetflixDataClean, allEffects

moviegroup = GROUP allData BY movie ;
movie_effects = FOREACH moviegroup GENERATE group AS movieid, SUM(allData.rating)/(float)COUNT(allData.rating) AS avg_movie_rating ;
table = JOIN allData BY movie, movie_effects BY movieid ;

usergroup = GROUP table BY user ;
user_effects = FOREACH usergroup GENERATE group AS userid, (SUM(table.rating) - SUM(table.avg_movie_rating)) AS rbar_user ;
table2 = JOIN table BY user, user_effects by userid ;

tablefinal = FOREACH table2 GENERATE movie, user, (rating - rbar_user) as centered_rating ;

tablefinal = ORDER tablefinal BY user ;

DUMP tablefinal ; 

STORE tablefinal INTO '$CONTAINER/$PSEUDO/DonnotLaugel/smallEffects.csv' USING PigStorage(',') ;