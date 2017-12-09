function [ loadedStructs ] = loadConfiguration( configFilename, addNoise )
%LOADCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

%assume format:
   %   configuration name
   %   file name
   %   header name
   %   sample rate (Hz)
   %   start time, end time
   %   start time, end time
   %   ...

data = importdata(configFilename, ',');
dataDisplayName = data.textdata{1};
dataFilename = data.textdata{2};

nextInd = 2;
if numel(data.textdata) == 3
    %column was given as text
    col = data.textdata{3};
    dataRate = data.data(1);
else
    col = data.data(1);
    dataRate = data.data(2);
    nextInd = 3;
end

numPairs = (numel(data.data)-(nextInd - 1))/2;
for i = 1:numPairs
   loadedStructs(i).displayName = dataDisplayName;
   loadedStructs(i).filename = dataFilename;
   loadedStructs(i).column = col;
   loadedStructs(i).sampleRate = dataRate;
   
   
   loadedStructs(i).startTime = data.data(nextInd);
   nextInd = nextInd + 1;
   loadedStructs(i).stopTime = data.data(nextInd);
   nextInd = nextInd + 1;
   
   %load the data from the file
   loadedStructs(i).rawData = getCSVFileData(dataFilename, col, loadedStructs(i).startTime, ...
        loadedStructs(i).stopTime);
    
   loadedStructs(i).avgData = movingAvgFilter(loadedStructs(i).rawData, floor(dataRate/4));
end

end

