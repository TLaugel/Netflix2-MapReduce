
values = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Train-$dateMin.csv' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray);

small = FILTER values BY ROUND(((int) $N )*RANDOM()) == 1;

STORE small INTO '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract.csv' USING PigStorage(',') ;