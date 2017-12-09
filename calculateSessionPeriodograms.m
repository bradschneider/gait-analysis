
startEndTimes = [[840, 1100] [1470, 1710] [2085, 2235] [2725, 2880] [3260, 3355] [3705, 3820]];
%startEndTimes = [[4920,5356] [7012,7434] [9400,9852] [11783,12217] [14089,14512] [16486, 16872]];

pivotheadRate = 30;
vestRate = 64;

% dataLoc = 'C:/Users/bschneider/Documents/School/Thesis/sensorsLetters/Stephanie/VID_0004.csv';
% figureFolder = 'C:\Users\bschneider\Desktop';
dataLoc = 'C:\Users\bschneider\Documents\School\Thesis\UC collab\data\6\VID_0018.csv';
figureFolder = 'C:\Users\bschneider\Documents\School\Thesis\UC collab\data\6';

for i = 1:numel(startEndTimes)/2
    stInd = (i*2)-1;
    endInd = (i*2);
    
    raw = getCSVFileData(dataLoc, ' mean.v', startEndTimes(stInd), startEndTimes(endInd));
    [dataU, pU] = generatePeriodogram(raw, 'C:\users\bschneider\Desktop\test.csv', pivotheadRate, 7);
    
%      raw = getCSVFileData(dataLoc, 2, startEndTimes(stInd), startEndTimes(endInd));
%      [dataU, pU] = generatePeriodogram(raw, 'C:\users\bschneider\Desktop\test.csv', vestRate, 16);    
    
    [pk1, lc1] = findpeaks(pU(:,2), 'SortStr', 'descend', 'NPeaks', 1);
    %[pk2, lc2] = findpeaks(pV(:,2), 'SortStr', 'descend', 'NPeaks', 1);
           
    fig = figure;
    plot(pU(:,1), pU(:,2))
    theTitle = strcat('Pivothead ', num2str(i), ' OptFlow-U');
    title(theTitle);
    text(pU(lc1,1), pk1, strcat(num2str(round(pU(lc1,1), 3)), ' Hz'))
    saveas(fig, strcat(figureFolder, '\', theTitle, '.jpg'));
    
    figure;
    plot(dataU);
    
%     fig = figure;
%     plot(pV(:,1), pV(:,2))
%     theTitle = strcat('Pivothead ', num2str(i), ' Periodogram-V');
%     title(theTitle);
%     text(pV(lc2,1), pk2, strcat(num2str(round(pV(lc2,1), 3)), ' Hz'))
%     saveas(fig, strcat(figureFolder, '\', theTitle, '.jpg'));
%     fig = figure;
%     plot(data)
%     theTitle = strcat('Pivothead ', num2str(i), ' Data_vFilter');
%     title(theTitle);
%     saveas(fig, strcat(figureFolder, '\', theTitle, '.jpg'));
    
end

