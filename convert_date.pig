
allData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/allNetflixData.csv' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray );

values = FOREACH allData GENERATE (datetime) ToDate(date,'yyyy-MM-dd') AS date2 ;

STORE values INTO '$CONTAINER/$PSEUDO/DonnotLaugel/allNetflixDataClean.csv' USING PigStorage(',') ;