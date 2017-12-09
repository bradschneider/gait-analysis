folderName = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_120601\configs\vest\';
files = dir(strcat(folderName, '*.cfg'));
vestData = [];
i = 1;
for file = files'
    data = [];
    config = loadConfiguration(strcat(folderName, file.name));
    for j = 1:numel(config)
        %want to normalize the data before adding
        data = [data varNormalize(config(j).avgData, 2)'];
    end
    vestData = [vestData, data'];
    i = i + 1;
end

folderName = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_120601\configs\pivothead\';
files = dir(strcat(folderName, '*.cfg'));
pivotheadData = [];
i = 1;
for file = files'
    data = [];
    config = loadConfiguration(strcat(folderName, file.name));
    for j = 1:numel(config)
        data = [data varNormalize(config(j).avgData, 2)'];
    end
    pivotheadData = [pivotheadData, data'];
    i = i + 1;
end

%resample the pivothead data to be the same length as the vest
[p1,q1] = rat(64/30);
rsPivotheadData = resample(pivotheadData, p1, q1);

%find the offset by the maximum signal cross-correlation
% use u and z since the correlation appears to typically be greater
[f, lag] = xcorr(rsPivotheadData(:,1), vestData(:,3));
[pks, locs] = findpeaks(f, lag);
%use max peak location as offset
[val, ind] = max(pks);
offset = locs(ind);
%offset of 0 will cause problems
if offset == 0
    offset = 1;
end

offset = 1;

%find the min length to make them the exact same length
mins = min(size(rsPivotheadData), size(vestData));
length = mins(1);
%account for offset if too large for length
if length+(offset-1) > size(rsPivotheadData)
    length = length - (length+(offset-1)-size(rsPivotheadData));
end

%form a table from the data
tbl = table(vestData(1:length,1), vestData(1:length,2), vestData(1:length,3), ...
    rsPivotheadData(1+(offset-1):length+(offset-1),1), ...
    rsPivotheadData(1+(offset-1):length+(offset-1),2), 'VariableNames', ...
    {'VestAccX', 'VestAccY', 'VestAccZ', 'PVMotU', 'PVMotV'});

%perform correlation
[c,p] = corr(rsPivotheadData(offset:length+(offset-1),1:end),vestData(1:length,1:end))



