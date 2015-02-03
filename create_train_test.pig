
values = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/allNetflixData.csv' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray);

values_Train = FILTER values BY (datetime) ToDate(date,'yyyy-MM-dd') <= (datetime) ToDate((chararray) $dateMin,'yyyyMMdd');

STORE values_Train INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Train-$dateMin.csv' USING PigStorage(',') ;

values_Test = FILTER values BY (datetime) ToDate(date,'yyyy-MM-dd') > (datetime) ToDate((chararray) $dateMin,'yyyyMMdd');

STORE values_Test INTO '$CONTAINER/$PSEUDO/DonnotLaugel/NetflixData_Test-$dateMin.csv' USING PigStorage(',') ;