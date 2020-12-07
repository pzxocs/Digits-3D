function [trainSet, trainLabels, testSet, testLabels, kFolds] = ...
    splitData(digitsArray, proportion, k, dataType)
%SPLITDATA is disgned to divide given data set into train and test with
%given proportion. 
%   INPUT:
%   digitsArray - data set input, can be simple matlab array or cell array
%   proportion - [train, test], [0.6 0.4], digitsArray will be divided into
%   2 subsets accordingly to the proportion.
%   k - parameter for k-fold division of the train subset.
%   dataType - 'cell' or 'array'.
%   OUTPUT:
%   trainSet, testSet - data arrays
%   trainLabels, testLabels - labels for data arrays;
%   kFolds - splitted trainSet into {k} arrays with indices from testSet!
kFolds=[];
switch dataType
    case 'array'
        [m,~,~]=size(digitsArray);
        [trainInd,~,testInd] = dividerand(m,...
            proportion(1),0,proportion(2));
        trainSet=digitsArray(trainInd,:,:);
        trainLabels(:)= idivide(int32(trainInd(:)),int32(100),'ceil');
        testSet=digitsArray(testInd,:,:);
        testLabels(:)= idivide(int32(testInd(:)),int32(100),'ceil');
        if (exist('k','var'))
            buff=trainSet;
            kFoldInd=randperm(length(buff));
            for i=1:k
                kFolds(i,:)=kFoldInd(1:length(buff)*1/k);
                kFoldInd(1:length(buff)*1/k)=[];
            end
%             [trainInd,testInd] = dividerand(length(trainInd),...
%             proportion(1),proportion(2));
        end
    case 'cell'  
        [~,n]=size(digitsArray);
        [~,l]=size(digitsArray{1});
        trainIdx=1;
        testIdx=1;
        trainLabels=[];
        testLabels=[];
        for i=1:n
            [trainInd,~,testInd] = dividerand(l,...
                proportion(1),0,proportion(2));
            for j=1:length(trainInd)
                trainSet{trainIdx}=digitsArray{i}{trainInd(j)}(:,:);
                trainIdx=trainIdx+1;
            end
            trainLabels= [trainLabels,(ones(1,length(trainInd))+(i-1))];
            for j=1:length(testInd)
                testSet{testIdx}=digitsArray{i}{testInd(j)}(:,:);
                testIdx=testIdx+1;
            end
            testLabels= [testLabels,(ones(1,length(testInd))+(i-1))];
        end
        if (exist('k','var'))
            buff=trainSet;
            kFoldInd=randperm(length(buff));
            for i=1:k
                kFolds(i,:)=kFoldInd(1:length(buff)*1/k);
                kFoldInd(1:length(buff)*1/k)=[];
            end
        end

end
    
end

