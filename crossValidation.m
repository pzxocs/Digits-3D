function [outputStruct, bestPar] = crossValidation(trainData, trainClass, kFolds,...
                                kArray, wArray, dataType, distance )
%crossVlidation function
%   INPUT: trainData/trainClass - data samples and their labels.
%          kFolds - array of trainData indices for cross validation, from
%                   {splitData} function.
%          kArray - array of nearest neighbors parameter.
%          wArray - array of adjustment window in dtw function.
%          dataType - matlab {array} with uniform resampled data or {cell} array
%                   with nonuniform length.
%          distance - DTW or euc distance measure
%   OUTPUT: bestPar - best parameters based on k-Fold cross-validation
%           outputStruct - struct with accuracy and classifier parameters
%           for each cross-validation iteration.
m=length(kArray);
n=length(wArray);
if n==0
    n=1;
end
bestAcc=0;
switch dataType
    case 'array'
        for i=1:m
            for j=1:n
                for k=1:length(kFolds(:,1))
                    testData=trainData(kFolds(k,:),:,:);
                    testClass=trainClass(kFolds(k,:));
                    buffData=trainData;
                    buffData(kFolds(k,:),:,:)=[];
                    buffClass=trainClass;
                    buffClass(kFolds(k,:))=[];
                    C = knn( buffData, buffClass, testData,...
                                    kArray(i), dataType, distance, wArray(j));
                    accArray(k)=(length(C)-sum(testClass(:)~=C(:)))/length(C);
                end
                field1 = 'Acc';  value1 = accArray;
                    field2 = 'Neighbors';  value2 = kArray(i);
                    field3 = 'WindowSize';  value3 = wArray(j);
                    field4 = 'dataType';  value4 = {dataType};
                    field5 = 'distance';  value5 = {distance};
                    outputStruct(i,j) = struct(field1,value1,...
                                           field2,value2,...
                                           field3,value3,...
                                           field4,value4,...
                                           field5,value5);
               if mean(outputStruct(i,j).Acc)>bestAcc
                   bestAcc=mean(outputStruct(i,j).Acc);
                   bestPar=outputStruct(i,j);
               end
            end
        end
    case 'cell'
         for i=1:length(kArray)
            for j=1:length(wArray)
                for k=1:length(kFolds(:,1))
                    testData=trainData(1,kFolds(k,:));
                    testClass=trainClass(kFolds(k,:));
                    buffData=trainData;
                    buffData(kFolds(k,:))=[];
                    buffClass=trainClass;
                    buffClass(kFolds(k,:))=[];
                    C = knn( buffData, buffClass, testData,...
                                    kArray(i), dataType, distance, wArray(j));
                    accArray(k)=(length(C)-sum(testClass(:)~=C(:)))/length(C);
                end
                field1 = 'Acc';  value1 = accArray;
                    field2 = 'Neighbors';  value2 = kArray(i);
                    field3 = 'WindowSize';  value3 = wArray(j);
                    field4 = 'dataType';  value4 = {dataType};
                    field5 = 'distance';  value5 = {distance};
                    outputStruct(i,j) = struct(field1,value1,...
                                           field2,value2,...
                                           field3,value3,...
                                           field4,value4,...
                                           field5,value5);
               if mean(outputStruct(i,j).Acc)>bestAcc
                   bestAcc=mean(outputStruct(i,j).Acc);
                   bestPar=outputStruct(i,j);
               end
            end
        end
end

