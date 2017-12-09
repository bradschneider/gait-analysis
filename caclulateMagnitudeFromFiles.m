dataLocs = {'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_X.csv', ...
    'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_Y.csv', ...
    'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_Z.csv'};

%concatenate the data from the files
for i = 1:numel(dataLocs)
    data(:,i) = movingAvgFilter(getCSVFileData(dataLocs{i}, 2, -1, -1), 16);
end

%generate the magnitude
mag = magnitude(data, 1);