folderName = 'C:\Users\bschneider\Documents\School\Thesis\sensorsLetters\configs\vest\';
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

folderName = 'C:\Users\bschneider\Documents\School\Thesis\sensorsLetters\configs\pv\';
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

%apply PCA adjustments
vCoeffs = pca(vestData);
% pCoeffs = pca(pivotheadData);
% 
vestData = vestData * vCoeffs;
% pivotheadData = pivotheadData * pCoeffs;

%adjust the sample rate as needed for cross-correlation
[p1,q1] = rat(64/30);
rsPivotheadData = resample(pivotheadData, p1, q1);

%correlate the two data sets
for i = 1:size(rsPivotheadData, 2)
   for j = 1:size(vestData, 2)
       [corr, lag] = xcorr(rsPivotheadData(:,i), vestData(:,j));
       figure;
       plot(lag, corr);
   end
end


