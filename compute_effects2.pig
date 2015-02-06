
allData = LOAD '$CONTAINER/$PSEUDO/DonnotLaugel/smallExtract.csv' USING PigStorage(',') ;


STORE tablefinal INTO '$CONTAINER/$PSEUDO/DonnotLaugel/smallEffects.csv' USING PigStorage(',') ;