dataStructMap = loadConfiguration2('C:\users\bschneider\Documents\School\Thesis\SensorsLetters\Brad\timings.csv');

keys = dataStructMap.keys;
for i = 1:numel(keys)
   vestData = [];
   pvData = [];
   
   key = cell2mat(keys(i));
   dataSet = dataStructMap(key);

   %x,y,z,u,v
   vestData = [dataSet(1).rawData dataSet(2).rawData ...
                                                     dataSet(3).rawData;];
   
   %vestData = cumsum(vestData);
                                                 
   pvData = [varNormalize(dataSet(4).avgData, 2) varNormalize(dataSet(5).avgData, 2); ];
   
        
   pvData2 = diff(pvData);
   
end