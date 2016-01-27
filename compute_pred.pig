DEFINE Coalesce datafu.pig.util.Coalesce('lazy');

TEST = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract_test/p*' USING PigStorage(',') AS (movietest:int,usertest:int,ratingtest:float,date:chararray );
TRAIN = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract/p*' USING PigStorage(',') AS (movietrain:int,usertrain:int,ratingtrain:float,date:chararray);
COVAR = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallReco/p*' USING PigStorage(',') AS (movie:int,movie2:int,correlation:float);

-- // Script does a knn to predict a rating
%declare NB_NEIGHBORS 3


-- // join all data
TESTTRAIN = JOIN TEST BY usertest, TRAIN BY usertrain;
TESTTRAINC = JOIN TESTTRAIN BY (movietrain, movietest), COVAR BY (movie, movie2);
A = FOREACH TESTTRAINC GENERATE usertest AS user,
                                movietest,
                                ratingtest,
                                movietrain,
                                ratingtrain,
                                Coalesce(correlation, 0) AS correlation;

-- // keep k most correlated neighbors 
C = GROUP B BY (user, movietest, ratingtest);
D = FOREACH C {
                best_k = TOP('$NB_NEIGHBORS', 5, $1);
                GENERATE FLATTEN(group) AS (user, movietest, ratingtest),
                        FLATTEN(best_k) AS (movietrain, ratingtrain, correlation);


-- // count ratings occurrences
E = GROUP D BY (user, movietest, ratingtest, ratingtrain);
F = FOREACH E GENERATE FLATTEN(group) AS (user, movitetest, ratingtest, ratingtrain),
                    COUNT($1) AS votes:int;


-- // get prediction as most recurring vote
G = GROUP BY (user, movietest, ratingtest);
H = FOREACH G GENERATE FLATTEN(group) AS (user, movietest, ratingtest),
                    FLATTEN(TOP(1, 4, $1)) AS (prediction, votes);


STORE H INTO '$CONTAINER/$PSEUDO/DonnotLaugel/pred' USING PigStorage(',') ;
