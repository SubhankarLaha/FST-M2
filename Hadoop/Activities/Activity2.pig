-- Load the input data from HDFS
inputFile = LOAD 'hdfs:///user/subhankar/input.txt' AS (line:chararray);
-- Tokenize the lines
words = FOREACH inputFile GENERATE FLATTEN(TOKENIZE(line)) as word;
-- Group words by word [MAP]
grpd = GROUP words BY word;
-- Counts the number of words [REDUCE]
totalcount = FOREACH grpd GENERATE $0, COUNT($1);

-- Delete the output folder
rmf hdfs:///user/subhankar/PigOutput
-- Store the output in HDFS
STORE totalcount INTO 'hdfs:///user/subhankar/PigOutput';

