
values = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/allNetflixDataClean.csv' USING PigStorage(',') AS (movie:int,user:int,rating:int,date2:chararray,date:datetime);

values_Train = FILTER values BY date <= ToDate('2009-06-30','YYYY-MM-dd');

STORE values_Train INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Train-2009-06-30.csv' USING PigStorage(',') ;