-- Load the input data from HDFS
inputDialogue4 = LOAD 'hdfs:///user/subhankar/episodeIV_dialogues.txt' USING PigStorage('\t') AS (name:chararray,line:chararray);
inputDialogue5 = LOAD 'hdfs:///user/subhankar/episodeV_dialogues.txt' USING PigStorage('\t') AS (name:chararray,line:chararray);
inputDialogue6 = LOAD 'hdfs:///user/subhankar/episodeVI_dialogues.txt' USING PigStorage('\t') AS (name:chararray,line:chararray);

-- Filterout the first 2 lines from each file
ranked4 = RANK inputDialogue4;
onlyDialogue4 = FILTER ranked4 BY (rank_inputDialogue4 > 2);
ranked5 = RANK inputDialogue5;
onlyDialogue5 = FILTER ranked5 BY (rank_inputDialogue5 > 2);
ranked6 = RANK inputDialogue6;
onlyDialogue6 = FILTER ranked6 BY (rank_inputDialogue6 > 2);

--Merge the three inputs
inputData = UNION onlyDialogue4,onlyDialogue5,onlyDialogue6;

-- Group by name
groupByName = GROUP inputData BY name;

-- Count the number of lines by each character
names = FOREACH groupByName GENERATE $0 as name,COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;
-- Remove the outputs folder
rmf hdfs:///user/subhankar/outputs;

-- Store results in HDFS
STORE namesOrdered INTO 'hdfs:///user/subhankar/outputs' USING PigStorage('\t'); 
