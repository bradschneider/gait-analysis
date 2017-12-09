folderName = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_120601\configs\vest\';
files = dir(strcat(folderName, '*.cfg'));
vestData = [];
i = 1;
for file = files'
    data = [];
    config = loadConfiguration(strcat(folderName, file.name));
    for j = 1:numel(config)
        %want to normalize the data before adding
        data = [data varNormalize(config(j).rawData, 2)'];
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
        data = [data varNormalize(config(j).rawData, 2)'];
    end
    pivotheadData = [pivotheadData, data'];
    i = i + 1;
end

%resample the pivothead data to be the same length as the vest
[p1,q1] = rat(64/30);
rsPivotheadData = resample(pivotheadData, p1, q1);

kalmanFilter = configureKalmanFilter('ConstantAcceleration', [0,0], [1 1 1]*1e5, [1 1 1]*1e5, 2);
mins = min(size(rsPivotheadData), size(vestData));
length = mins(1);

for i = 1:length
    pred = predict(kalmanFilter);
    actual = rsPivotheadData(i,:);
    correct(kalmanFilter, actual);
    
    preds(i,:) = pred;
end

