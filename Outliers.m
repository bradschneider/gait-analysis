folderName = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\configs\vest\';
files = dir(strcat(folderName, '*.cfg'));
vestData = [];
i = 1;
for file = files'
    data = [];
    config = loadConfiguration(strcat(folderName, file.name), false);
    for j = 1:numel(config)
        %want to normalize the data before adding        
        data = [data varNormalize(config(j).avgData, 2)'];
        %data = [data config(j).rawData'];
    end
    vestData = [vestData, data'];
    i = i + 1;
end

folderName = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\configs\pivothead\';
files = dir(strcat(folderName, '*.cfg'));
pivotheadData = [];
i = 1;
for file = files'
    data = [];
    config = loadConfiguration(strcat(folderName, file.name), true);
    for j = 1:numel(config)
        data = [data varNormalize(config(j).avgData, 2)'];
        %data = [data config(j).rawData'];
    end
    pivotheadData = [pivotheadData, data'];
    i = i + 1;
end

%resample the pivothead data to be the same length as the vest
[p1,q1] = rat(64/30);
rsPivotheadData = resample(pivotheadData, p1, q1);

rate = 64;
[datau, pu] = generatePeriodogram(vestData(:,3), 'test', rate);

fig = figure;
plot(pu(:,1), pu(:,2))
theTitle = strcat('Vest Z');
title(theTitle);

outliers1 = findOutliers(rsPivotheadData(:,1), 2);
outliers2 = findOutliers(rsPivotheadData(:,2), 2);

%----------produce colorized plot
figure;
hold on;
outlierEnd = 0;
for i = 1:size(outliers1)
    scatter(outlierEnd+1:outliers1(i)-1, rsPivotheadData(outlierEnd+1:outliers1(i)-1, 1), 'b', '.');
    outlierBegin = outliers1(i);
    outlierEnd = outliers1(i);
    while (i < size(outliers1)) & (outliers1(i+1) - outliers(i) == 1)
        i = i+1;
        outlierEnd =outliers(i);
    end
    scatter(outlierBegin:outlierEnd, rsPivotheadData(outlierBegin:outlierEnd, 1), 'r');
end
hold off;

figure;
hold on;
outlierEnd = 0;
for i = 1:size(outliers2)
    scatter(outlierEnd+1:outliers2(i)-1, rsPivotheadData(outlierEnd+1:outliers2(i)-1, 2), 'b', '.');
    outlierBegin = outliers2(i);
    outlierEnd = outliers2(i);
    while (i < size(outliers2)) & (outliers2(i+1) - outliers(i) == 1)
        i = i+1;
        outlierEnd =outliers(i);
    end
    scatter(outlierBegin:outlierEnd, rsPivotheadData(outlierBegin:outlierEnd, 2), 'r');
end
hold off;

%end



%--------- Set up data with outliers
pvhdUPre = rsPivotheadData(:,1);
pvhdVPre = rsPivotheadData(:,2);

vestXPre = vestData(:,1);
vestYPre = vestData(:,2);
vestZPre = vestData(:,3);
%end

%---------- perform correlation (including outliers)
minLength = min(size(pvhdUPre), size(vestZPre));
corr(pvhdUPre(1:minLength), vestZPre(1:minLength))

tbl = table(vestXPre(1:minLength), vestYPre(1:minLength), vestZPre(1:minLength), ...
    pvhdUPre(1:minLength), pvhdVPre(1:minLength), ...
    'VariableNames', {'VestAccX', 'VestAccY', 'VestAccZ', 'PVMotU', 'PVMotV'});

mdlPre = stepwiselm(tbl, 'PVMotU~1', 'ResponseVar', 'PVMotU', 'PredictorVars', {'VestAccX', 'VestAccY', 'VestAccZ'});

%end


%--------- remove the outliers from the data
pvhdU = rsPivotheadData(:,1);
pvhdU(outliers1) = [];
pvhdV = rsPivotheadData(:,2);
pvhdV(outliers1) = [];

vestX = vestData(:,1);
vestX(outliers1) = [];
vestY = vestData(:,2);
vestY(outliers1) = [];
vestZ = vestData(:,3);
vestZ(outliers1) = [];

%end


%---------- perform correlation
minLength = min(size(pvhdU), size(vestZ));
corr(pvhdU(1:minLength), vestZ(1:minLength))

tbl = table(vestX(1:minLength), vestY(1:minLength), vestZ(1:minLength), ...
    pvhdU(1:minLength), pvhdV(1:minLength), ...
    'VariableNames', {'VestAccX', 'VestAccY', 'VestAccZ', 'PVMotU', 'PVMotV'});

mdlPost = stepwiselm(tbl, 'PVMotU~1', 'ResponseVar', 'PVMotU', 'PredictorVars', {'VestAccX', 'VestAccY', 'VestAccZ'});

%end

