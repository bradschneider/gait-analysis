%compare the optical flow at different noise levels
folderName = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\pivotheadVids\120601\configs\';
%fileRoot = 'VID_0011_gaussBlur_';
ext = '.csv';

pers = figure;
rawFig = figure;

%load the vest data once
vestConfig = loadConfiguration(strcat(folderName, 'vest.cfg'));
vestData = vestConfig.rawData;

%iterate over the video data
for i=1:5    
    config = loadConfiguration(strcat(folderName, 'gaussBlur', num2str(i), '.cfg'));
    uData = config.rawData;
    avgUData = config.avgData;
    normUData = varNormalize(config.avgData, 2);
    %uData = getCSVFileData(strcat(folderName, fileRoot, num2str(i), ext), ...
    %    'mean.u', 1, 675);
    
    %vData = getCSVFileData(strcat(folderName, fileRoot, num2str(i), ext), ...
    %    ' mean.v', 1, 675);
    
    %build periodograms
    figure(pers);
    [d, per] = generatePeriodogram(uData, '', 30);
    subplot(3,5,i);
    plot(per(:,1), per(:,2));
    %ylim([0, 22]);
    
    [d, per] = generatePeriodogram(avgUData, '', 30);
    subplot(3,5,5+i);
    plot(per(:,1), per(:,2));
    %ylim([0, 22]);
    
    [d, per] = generatePeriodogram(normUData, '', 30);
    subplot(3,5,10+i);
    plot(per(:,1), per(:,2));
    %ylim([0, 1]);
    
    if mod(i,2)==1
        figure(rawFig);
        subplot(3,3,ceil(i/2));
        plot(uData);
        title(num2str(i));
        
        subplot(3,3,3+ceil(i/2));
        hist(uData);
     %   xlim([-25,25]);
        title(num2str(i));
        
        subplot(3,3,6+ceil(i/2));
        hist(normUData);
      %  xlim([-3,3]);
        title(num2str(i));
    end
    
    [ci,pi] = corr(uData, vestData);
    
    c(i) = ci;
    p(i) = pi;
    
    
    %outliers1 = findOutliers(uData, 2);
    %size(outliers1)
    
end