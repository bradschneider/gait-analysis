vestDataLocs = { 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_X.csv', ...
    'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_Y.csv', ...
    'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_Z.csv'};

for i = 1:numel(vestDataLocs)
   vData(:, i) = getCSVFileData(vestDataLocs{i}, 2, -1, -1);
end

vCoeffs = pca(vData)


pivotheadDataCols = { 'mean.u', ' mean.v'};

for i = 1:numel(pivotheadDataCols)
   pData(:, i) = movingAvgFilter(getCSVFileData('C:\Users\bschneider\Documents\School\Thesis\Hexoskin\pivotheadVids\117248\VID_0007.csv', ...
       pivotheadDataCols{i}, -1, -1), 1);
end

pCoeffs = pca(pData)
