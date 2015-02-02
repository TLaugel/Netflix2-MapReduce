
allData = LOAD '/any/DonnotLaugel/allNetflixData.csv' USING PigStorage(',') AS (movie:int user:int rating:int date:datetime );

values_train = FILTER allData BY date <= datetime("2009-06-30") ;
values_test = FILTER allData BY date > datetime("2009-06-30") ;

STORE values_train INTO '/any/DonnotLaugel/NetflixData_Train-2009-06-30.csv' USING PigStorage(',') ;
STORE values_test INTO '/any/DonnotLaugel/NetflixData_Test-2009-06-30.csv' USING PigStorage(',') ;