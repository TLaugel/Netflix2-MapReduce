values = LOAD '/any/DonnotLaugel/allNetflixData.csv' USING PigStorage(',') AS (movie:int user:int rating:int date:datetime);
values_Train = FILTER values BY date <= datetime($dateMin) ;
values_Test = FILTER values BY date > datetime($dateMin) ;
STORE values_Train INTO '/any/DonnotLaugel/NetflixData_Train-$dateMin.csv' USING PigStorage(',') ;
STORE values_Test INTO '/any/DonnotLaugel/NetflixData_Test-$dateMin.csv' USING PigStorage(',') ;