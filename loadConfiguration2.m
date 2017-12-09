function [ dataStructMap ] = loadConfiguration2( configFilename, addNoise )
%LOADCONFIGURATION Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(configFilename);
currentLine = fgets(fid);

sourceMap = containers.Map;
datasetMap = containers.Map;

while ~(isempty(currentLine) | currentLine == -1)
    segments = strsplit(currentLine, ',');
    
    type = cell2mat(segments(1));
    
    if strcmp('#', type)
        % the row id's a data source
        ds = struct;
        ds.name = cell2mat(segments(2));
        ds.source = cell2mat(segments(3));
        
        %read the column and see if it is a number
        ds.column = cell2mat(segments(4));
        %leave as str2num. str2double provides 'NaN' instead of []
        colNum = str2num(ds.column);
        if ~isempty(colNum)
           ds.column = colNum; 
        end
        
        ds.fps = str2double(cell2mat(segments(5)));
        sourceMap(ds.name) = ds;
        
    elseif ~isempty(type)
        %the row defines a data set
        ds = struct;
        ds.name = type;
        ds.source = cell2mat(segments(2));
        ds.start = str2double(cell2mat(segments(3)));
        ds.end = str2double(cell2mat(segments(4)));        
    
        if ~isKey(datasetMap, ds.name)
           datasetMap(ds.name) = ds;
        else
            existing = datasetMap(ds.name);
            existing(numel(existing)+1) = ds;
            datasetMap(ds.name) = existing;
        end
    end
    %read the next line
    currentLine = fgets(fid);
end

fclose(fid);


dataStructMap = containers.Map;

keys = datasetMap.keys;
for i = 1:numel(keys)
   key = cell2mat(keys(i));
   dsList = datasetMap(key);
   for j = 1:numel(dsList)
       dsStruct = dsList(j);
       
       %get the data source name
       sourceStruct = sourceMap(dsStruct.source);
       
       rawData = getCSVFileData(sourceStruct.source, sourceStruct.column, dsStruct.start, ...
        dsStruct.end);
       avgData = movingAvgFilter(rawData, floor(sourceStruct.fps/4));
   
       dataStruct = struct;
       dataStruct.name = strcat(dsStruct.name, ':', sourceStruct.name);
       dataStruct.rawData = rawData;
       dataStruct.avgData = avgData;
       
       if ~isKey(dataStructMap, key)
           dataStructMap(key) = dataStruct;
        else
            existing = dataStructMap(key);
            existing(numel(existing)+1) = dataStruct;
            dataStructMap(key) = existing;
        end
   end
end


end

