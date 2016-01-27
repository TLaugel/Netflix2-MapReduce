A = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/allNetflixData/p*' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray);

TRAIN = FILTER A BY ToDate(date,'yyyy-MM-dd') <= ToDate((chararray) $dateMin,'yyyyMMdd');

STORE TRAIN INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Train-$dateMin' USING PigStorage(',') ;

TEST = FILTER values BY ToDate(date,'yyyy-MM-dd') > ToDate((chararray) $dateMin,'yyyyMMdd');

STORE TEST INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Test-$dateMin' USING PigStorage(',') ;
