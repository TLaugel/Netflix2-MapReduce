--todo change testdata file name
testData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract_test.csv' USING PigStorage(',') AS (movietest:int,usertest:int,ratingtest:float,date:chararray ) ;
trainData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract.csv' USING PigStorage(',') AS (movietrain:int,usertrain:int,ratingtrain:float,date:chararray ) ;
covar = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallReco.csv' USING PigStorage(',') AS (movie:int,movie2:int,correlation:float ) ;

--join test and train: foreach test review (usertest, movietest,ratingtest), we will have all the reviews in train by the same user
testtrain = JOIN testData BY usertest, trainData BY usertrain ;  

-- join with covariance table: for each couple (test review, train review), we will have the corresponding correlation obtained with the covar table
withcovar = JOIN testtrain BY (movietrain, movietest), covar BY (movie, movie2) ;

-- let us drop useless variables
cleaned = FOREACH withcovar GENERATE usertest, movietest, ratingtest, movietrain, ratingtrain, correlation ;

-- order by dicreasing correlation, keep 3 nn
ordered = ORDER cleaned BY usertest, movietest, correlation DESC ; 
-- o1 = GROUP ordered BY (usertest, movietest) ;
-- o2 = FOREACH o1 {
--    o2A = ORDER ordered BY correlation DESC ;
--    o2B = LIMIT o2A 3
--    GENERATE FLATTEN(group), FLATTEN(o2B.correlation), FLATTEN(o2B.ratingtrain) ;
--}

-- need to find a way to keep for each test review the first X lines
limited = FILTER ordered BY ratingtrain>=0; --no NaN? ca nenleve pas les NaN mais ca fait marcher le script/...


-- we have here the nearest neighbours, time to predict the rating
-- for each test review, we count the occurences of each rating value in the trained movies associated
A = GROUP limited BY (usertest, movietest, ratingtrain) ;
B = FOREACH A GENERATE FLATTEN(group), COUNT(limited.ratingtrain) as votes, FLATTEN(limited.ratingtest) ; 
C = GROUP B BY (usertest, movietest) ;
D = FOREACH C {
    DA = ORDER B BY votes DESC ;
    DB = LIMIT DA 1 ;
    GENERATE FLATTEN(group), FLATTEN(DB.votes), FLATTEN(DB.ratingtrain) AS prediction, FLATTEN(DB.ratingtest) ;
}

--DUMP D ;

--C = FOREACH B GENERATE group.usertest, group.movietest, group.ratingtrain AS prediction, votes ;

-- we order to take the most represented class
--D = ORDER C BY usertest, movietest, votes DESC ;


-- garder la premiere ligne


STORE D INTO '$CONTAINER/$PSEUDO/DonnotLaugel/smallPred.csv' USING PigStorage(',') ;