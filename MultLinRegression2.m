dataStructMap1 = loadConfiguration2('C:\users\bschneider\Documents\School\Thesis\SensorsLetters\Alex\timings.csv');
dataStructMap2 = loadConfiguration2('C:\users\bschneider\Documents\School\Thesis\SensorsLetters\Brad\timings.csv');
dataStructMap3 = loadConfiguration2('C:\users\bschneider\Documents\School\Thesis\SensorsLetters\Carol\timings.csv');


keys = dataStructMap1.keys;
for i = 1:numel(keys)
   vestData = [];
   pvData = [];
   
   key = cell2mat(keys(i));
   dataSets1 = dataStructMap1(key);
   dataSets2 = dataStructMap2(key);
   dataSets3 = dataStructMap3(key);

   %x,y,z,u,v
   vestData = [varNormalize(dataSets1(1).avgData, 2) varNormalize(dataSets1(2).avgData, 2) ...
                                                     varNormalize(dataSets1(3).avgData, 2); ...
               varNormalize(dataSets2(1).avgData, 2) varNormalize(dataSets2(2).avgData, 2) ...
                                                     varNormalize(dataSets2(3).avgData, 2); ...
               varNormalize(dataSets3(1).avgData, 2) varNormalize(dataSets3(2).avgData, 2) ...
                                                     varNormalize(dataSets3(3).avgData, 2); ];
   
% vestData = [varNormalize(dataSets1(1).rawData, 2), varNormalize(dataSets1(2).rawData, 2), ...
%               varNormalize(dataSets1(3).rawData, 2); ...
%             varNormalize(dataSets2(1).rawData, 2), varNormalize(dataSets2(2).rawData, 2), ...
%                                           varNormalize(dataSets2(3).rawData, 2); ...
%             varNormalize(dataSets3(1).rawData, 2), varNormalize(dataSets3(2).rawData, 2), ...
%                                                      varNormalize(dataSets3(3).rawData,2); ];
                                                 
%    pvData = [varNormalize(dataSets1(4).avgData, 2) varNormalize(dataSets1(5).avgData, 2); ...
%              varNormalize(dataSets2(4).avgData, 2) varNormalize(dataSets2(5).avgData, 2); ...
%              varNormalize(dataSets3(4).avgData, 2) varNormalize(dataSets3(5).avgData, 2)];

pvData = [dataSets1(4).rawData, dataSets1(5).rawData; ...
            dataSets2(4).rawData, dataSets2(5).rawData; ...
            dataSets3(4).rawData, dataSets3(5).rawData];
   
   %Think we need to diff, then normalize
   %pvData = diff(pvData);
    
   %pvData = [varNormalize(diff(dataSets1(4).avgData, 2)) varNormalize(diff(dataSets1(5).avgData, 2)); ...
   %          varNormalize(diff(dataSets2(4).avgData, 2)) varNormalize(diff(dataSets2(5).avgData, 2)); ...
   %          varNormalize(diff(dataSets3(4).avgData, 2)) varNormalize(diff(dataSets3(5).avgData, 2))];
   
   %use this version, but put the diff in excel, re-align the data there,
   %and use the loadconfiguration function
   %pvData = [varNormalize(movingAvgFilter(diff(dataSets1(4).rawData), 7), 2) varNormalize(movingAvgFilter(diff(dataSets1(5).rawData), 7), 2); ...
   %          varNormalize(movingAvgFilter(diff(dataSets2(4).rawData), 7), 2) varNormalize(movingAvgFilter(diff(dataSets2(5).rawData), 7), 2); ...
   %          varNormalize(movingAvgFilter(diff(dataSets3(4).rawData), 7), 2) varNormalize(movingAvgFilter(diff(dataSets3(5).rawData), 7), 2)];
   
   
         
   %dataSet = dataStructMap(key)
%    for j = 1:numel(dataSets)
%       dataSet = dataSets(j);
%       name = sprintf(dataSet.name)
%       %Expect that the datasets are name with 'vest' or 'pivothead'
%       if strfind(name, 'vest')
%           %want to normalize the data before adding
%           vestData = [vestData varNormalize(dataSet.avgData, 2)];
%       elseif strfind(name, 'pivothead')
%           %want to normalize the data before adding
%           pvData = [pvData varNormalize(dataSet.avgData, 2)];
%       end
%    end
   
   
   %resample the pivothead data to be the same length as the vest
   [p1,q1] = rat(64/30);
   rsPivotheadData = resample(pvData, p1, q1);
   
   %find the min length to make them the exact same length
   mins = min(size(rsPivotheadData), size(vestData));
   length = mins(1);
   
   %form a table from the data
   tbl = table(vestData(1:length,1), vestData(1:length,2), vestData(1:length,3), ...
   rsPivotheadData(1:length,1), ...
   rsPivotheadData(1:length,2), 'VariableNames', ...
   {'VestAccX', 'VestAccY', 'VestAccZ', 'PVMotU', 'PVMotV'});

   %perform correlation
   [c,p] = corr(rsPivotheadData(1:length,1:end),vestData(1:length,1:end))
   
   
   
   mdlU = stepwiselm(tbl, 'PVMotU~1', 'ResponseVar', 'PVMotU', 'PredictorVars',...
      {'VestAccX', 'VestAccY', 'VestAccZ'}, 'Criterion', 'adjrsquared')
   
   mdlV = stepwiselm(tbl, 'PVMotV~1', 'ResponseVar', 'PVMotV', 'PredictorVars',...
      {'VestAccX', 'VestAccY', 'VestAccZ'}, 'Criterion', 'adjrsquared')
   
%    mdlU = fitlm(tbl, 'PVMotU~1+VestAccX*VestAccY*VestAccZ', 'ResponseVar', 'PVMotU', 'PredictorVars',...
%        {'VestAccX', 'VestAccY', 'VestAccZ'})
%    
%    mdlV = fitlm(tbl, 'PVMotV~1+VestAccX*VestAccY*VestAccZ', 'ResponseVar', 'PVMotV', 'PredictorVars',...
%        {'VestAccX', 'VestAccY', 'VestAccZ'})
   
   % plot raw data for inspection
   figure;
   plot(rsPivotheadData(:,1));
   hold on;
   plot(vestData(:,3));
   % plot raw data for inspection
   figure;
   plot(rsPivotheadData(:,2));
   hold on;
   plot(vestData(:,2));
   
   
   %plot signal in frequency domain (amplitude spectrum)
%    [f1, P1] = timeToFreq(rsPivotheadData(:,1), 64);
%    [f2, P2] = timeToFreq(vestData(:,3), 64);
%    figure;
%    subplot(2,1,1);
%    plot(f1, P1);
%    subplot(2,1,2);
%    plot(f2, P2);
%    %plot signal in frequency domain (amplitude spectrum)
%    [f1, P1] = timeToFreq(rsPivotheadData(:,2), 64);
%    [f2, P2] = timeToFreq(vestData(:,2), 64);
%    figure;
%    subplot(2,1,1);
%    plot(f1, P1);
%    subplot(2,1,2);
%    plot(f2, P2);
   
   
   %wavelet coherence with predictors
    figure;
    wcoherence(rsPivotheadData(1:mdlU.NumObservations,1), mdlU.Fitted, 64);
    figure;
    wcoherence(rsPivotheadData(1:mdlV.NumObservations,2), mdlV.Fitted, 64);
   
end




