function digits = parseDigits()
% Load digits from './training_data/' directory  and return them as cell 
% array with shape {n}{m} where n - digit label and m - sample label
addpath('./training_data'); 

directory= './training_data/';

fileName = '*';

fileFormat = '.mat';

files=dir(strcat(directory,fileName,fileFormat));

allFileNames = {files(:).name};

digits=cell(1,10);

for k = 1 : length(allFileNames)
  digit=str2double(allFileNames{k}(8))+1;
  sampleNumber=str2double(allFileNames{k}(10:13));
  digits{digit}{sampleNumber}=load(allFileNames{k}).pos;
end

end

