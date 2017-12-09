function [ data ] = getCSVFileData( filename, headerName, startFrame, endFrame )
%GETCSVFILEDATA Summary of this function goes here
%   Detailed explanation goes here

%read the csv with u,v for each frame
m = importdata(filename, ',', 1);   
if ischar(headerName)
    headers = m.colheaders;
    col = 0;
    for i = 1:numel(headers)
        if strcmp(headerName, headers(i))
            col = i;       
            break
        end
    end
    
else %assume its a number
    col = headerName;    
end

if col > 0
    if or(startFrame < 0, endFrame < 0)
        data = m.data(:, col);
    else
        data = m.data(startFrame:endFrame, col);
    end
end  

end

