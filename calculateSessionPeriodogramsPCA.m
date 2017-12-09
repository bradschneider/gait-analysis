
pStartEndTimes = [[1774,2010] [3160,3362] [4290,4496] [5386,5620] [6448,6654] [7515,7760]];
%startEndTimes = [[4920,5356] [7012,7434] [9400,9852] [11783,12217] [14089,14512] [16486, 16872]];

pivotheadRate = 30;
vestRate = 64;

%PIVOTHEAD
pDataLoc = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\pivotheadVids\117248\vid_0007.csv';
pFigureFolder = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\pivotheadVids\117248\pcaFiltered';
pivotheadDataCols = { 'mean.u', ' mean.v'};

for i = 1:numel(pivotheadDataCols)
   pData(:, i) = movingAvgFilter(getCSVFileData(pDataLoc, pivotheadDataCols{i}, -1, -1), 7);
end

pCoeffs = pca(pData);
pData = (pCoeffs * pData')';

for i = 1:numel(pStartEndTimes)/2
    for col = 1:numel(pivotheadDataCols)
        stInd = (i*2)-1;
        endInd = (i*2);
        raw = pData(pStartEndTimes(stInd):pStartEndTimes(endInd), col);
        [data, p] = generatePeriodogram(raw, 'C:\users\bschneider\Desktop\test.csv', pivotheadRate, 1);

        fig = figure;
        plot(p(:,1), p(:,2))
        theTitle = strcat('Pivothead ', num2str(i), ' Periodogram_', num2str(col));
        title(theTitle);
        saveas(fig, strcat(pFigureFolder, '\', theTitle, '.jpg')); 

        fig = figure;
        plot(data)
        theTitle = strcat('Pivothead ', num2str(i), ' Data_', num2str(col));
        title(theTitle);
        saveas(fig, strcat(pFigureFolder, '\', theTitle, '.jpg'));
    end    
end


%vest
% dataLoc = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\acceleration_X.csv';
% figureFolder = 'C:\Users\bschneider\Documents\School\Thesis\Hexoskin\sessions\record_117248\';
% 
% for i = 1:numel(startEndTimes)/2
%     stInd = (i*2)-1;
%     endInd = (i*2);
%     raw = getCSVFileData(dataLoc, 2, startEndTimes(stInd), startEndTimes(endInd));
%     [data, p] = generatePeriodogram(raw, 'C:\users\bschneider\Desktop\test.csv', vestRate, 1);
%         
%     fig = figure;
%     plot(p(:,1), p(:,2))
%     axis([0 inf 0 400])
%     theTitle = strcat('Vest ', num2str(i), ' Periodogram_magFilter');
%     title(theTitle);
%     saveas(fig, strcat(figureFolder, '\', theTitle, '.jpg')); 
%     
%     fig = figure;
%     plot(data)
%     theTitle = strcat('Vest ', num2str(i), ' Data_magFilter');
%     title(theTitle);
%     saveas(fig, strcat(figureFolder, '\', theTitle, '.jpg'));
%     
% end

