
values = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/allNetflixData.csv' USING PigStorage(',') AS (movie:int,user:int,rating:int,date:chararray);

values_hist = GROUP values BY date;

hist = FOREACH values_hist GENERATE group,COUNT(values) AS nb ;

STORE hist INTO '$CONTAINER/$PSEUDO/DonnotLaugel/HistoNetflixData.csv' USING PigStorage(',');