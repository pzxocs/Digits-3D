%% 
% clc;clear;close all
%% data Loading
% type 'help parseDigits' to get a brief explanation of the implemented method
digits= parseDigits();
%% data Preprocessing
% description of steps inside {dataPreprocessing} funcition)
[digitsArray, preprocessedData]=dataPreprocessing(digits);
%% dtw Demonstration
figure
 dtw(preprocessedData{3}{3}(:,1),preprocessedData{9}{33}(:,1))
  legend('X axis (digit 3, 3 sample)','X axis (digit 9, 33 sample)','Location','Best');
figure 
dtw(preprocessedData{3}{3}(:,2),preprocessedData{9}{33}(:,2))
  legend('Y axis (digit 3, 3 sample)','Y axis (digit 9, 33 sample)','Location','Best');
figure 
dtw(preprocessedData{5}{5}(:,1),preprocessedData{5}{88}(:,1))
  legend('X axis (digit 5, 5 sample)','X axis (digit 5, 88 sample)','Location','Best');
figure
dtw(preprocessedData{5}{5}(:,2),preprocessedData{5}{88}(:,2))
  legend('Y axis (digit 5, 5 sample)','Y axis (digit 5, 88 sample)','Location','Best');
%% split data and Knn demonstration and K-fold cross-validation

[trainDataArray, trainClassArray, testArray, testClassArray, kFoldsArray]=...
    splitData(digitsArray, [0.5 0.5], 10, 'array');
% [trainDataCell, trainClassCell, testCell, testClassCell, kFoldsCell]=...
%     splitData(preprocessedData,[0.5 0.5], 10,'cell');

C = knn( trainDataArray, trainClassArray, testArray, 1, 'array','dtw');
acc = (length(C)-sum(testClassArray(:)~=C(:)))/length(C)

figure
subplot(1,2,1)
labels=["0",'1','2','3','4','5','6','7','8','9'];
confusionchart(confusionmat(double(testClassArray), C),labels);
title(['DTW, uniform length, data split 50/50%, Accuracy: ',num2str(acc)])

[trainDataArray, trainClassArray, testArray, testClassArray, kFoldsArray]=...
    splitData(digitsArray, [0.1 0.9], 10, 'array');

C = knn( trainDataArray, trainClassArray, testArray, 1, 'array','dtw');
acc = (length(C)-sum(testClassArray(:)~=C(:)))/length(C)

subplot(1,2,2)
labels=["0",'1','2','3','4','5','6','7','8','9'];
confusionchart(confusionmat(double(testClassArray), C),labels);
title(['DTW, uniform length, data split 10/90%,Accuracy: ',num2str(acc)]);

%% Evaluate best parameters with 10-Fold cross-validation. 
% Do not run, take a lot of time to complete!

% Split non-uniform length data
[trainDataCell, trainClassCell, testCell, testClassCell, kFoldsCell]=...
    splitData(preprocessedData,[0.6 0.4], 10,'cell');

% Split resampled (uniform length) data
[trainDataArray, trainClassArray, testArray, testClassArray, kFoldsArray]=...
     splitData(digitsArray, [0.6 0.4], 10, 'array');


% numNeibors to test
kArray=[1:5];
% only "array" dataType works with euc distance
dataType='array';
distance='euc';

[resultStruct1, bestPar1] = crossValidation(trainDataArray, trainClassArray, kFoldsArray,...
                                 kArray, 1, dataType, distance)
                             
% numNeibors to test
kArray=[1:5];
% only "array" dataType works with euc distance
dataType='cell';
distance='euc';
[resultStruct2, bestPar2] = crossValidation(trainDataCell, trainClassCell, kFoldsCell,...
                                 kArray, 1, dataType, distance )
% numNeibors to test                            
kArray=[1:5];
% adjusment window size to test for dtw distance measure
wArray=[1:5];
dataType='array';
distance='dtw';
[resultStruct3, bestPar3] = crossValidation(trainDataArray, trainClassArray, kFoldsArray,...
                                 kArray, wArray, dataType, distance )
kArray=[1:5];
wArray=[1:5];
dataType='cell';
distance='dtw';

[resultStruct4, bestPar4] = crossValidation(trainDataCell, trainClassCell, kFoldsCell,...
                                 kArray, wArray, dataType, distance )
       
mkdir ./validationData
save('./validationData/resultStruct1','resultStruct1');
save('./validationData/resultStruct2','resultStruct2');
save('./validationData/resultStruct3','resultStruct3');
save('./validationData/resultStruct4','resultStruct4');

save('./validationData/bestPar1','bestPar1');
save('./validationData/bestPar2','bestPar2');
save('./validationData/bestPar3','bestPar3');
save('./validationData/bestPar4','bestPar4');
%% Evaluate best perfomance with less train data!
% Do not run, take a lot of time to complete!

% Evaluate how amount of train data impact on classificator accuracy
proportionArray=[0.8 0.2;
                 0.4 0.6;
                 0.2 0.8;
                 0.1 0.9;
                 0.05 0.95]
% Split non-uniform length data
for i=1:length(proportionArray)
[trainDataCell, trainClassCell, testCell, testClassCell, kFoldsCell]=...
splitData(preprocessedData,[proportionArray(i,1) proportionArray(i,2)], 10,'cell');

% Split resampled (uniform length) data
[trainDataArray, trainClassArray, testArray, testClassArray, kFoldsArray]=...
splitData(digitsArray, [proportionArray(i,1) proportionArray(i,2)], 10, 'array');

% numNeibors Best for ARRAY EUC
kArray=[bestPar1.Neighbors];
dataType=bestPar1.dataType;
distance=bestPar1.distance;

[resultStruct5(i), ~] = crossValidation(trainDataArray, trainClassArray, kFoldsArray,...
                                 kArray, 1, dataType, distance );            
% Final validation
C = knn( trainDataArray, trainClassArray, testArray, 1, 'array','euc');
acc = (length(C)-sum(testClassArray(:)~=C(:)))/length(C);
finalAcc(1,i)=acc;

% numNeibors Best for CELL EUC
kArray=[bestPar2.Neighbors];
dataType=bestPar2.dataType;
distance=bestPar2.distance;

[resultStruct6(i), ~] = crossValidation(trainDataCell, trainClassCell, kFoldsCell,...
                                 kArray, 1, dataType, distance );            
% Final validation
C = knn( trainDataCell, trainClassCell, testCell, 1, 'cell','euc');
acc = (length(C)-sum(testClassCell(:)~=C(:)))/length(C);
finalAcc(2,i)=acc;

% numNeibors Best for ARRAY DTW
kArray=[bestPar3.Neighbors];
% adjusment window size Best for ARRAY DTW
wArray=[bestPar3.WindowSize];
dataType=bestPar3.dataType;
distance=bestPar3.distance;
[resultStruct7(i), ~] = crossValidation(trainDataArray, trainClassArray, kFoldsArray,...
                                 kArray, wArray, dataType, distance )         
% Final validation
C = knn( trainDataArray, trainClassArray, testArray, 1, 'array','dtw',bestPar3.WindowSize);
acc = (length(C)-sum(testClassArray(:)~=C(:)))/length(C);
finalAcc(3,i)=acc;

% numNeibors Best for CELL DTW
kArray=[bestPar4.Neighbors];
% adjusment window size Best for CELL DTW
wArray=[bestPar4.WindowSize];
dataType=bestPar4.dataType;
distance=bestPar4.distance;
[resultStruct8(i), ~] = crossValidation(trainDataCell, trainClassCell, kFoldsCell,...
                                 kArray, wArray, dataType, distance )
                             
% Final validation
C = knn( trainDataCell, trainClassCell, testCell, 1, 'cell','dtw',bestPar4.WindowSize);
acc = (length(C)-sum(testClassCell(:)~=C(:)))/length(C);
finalAcc(4,i)=acc;

end



save('./validationData/resultStruct5','resultStruct5');
save('./validationData/resultStruct6','resultStruct6');
save('./validationData/resultStruct7','resultStruct7');
save('./validationData/resultStruct8','resultStruct8');
save('./validationData/finalAcc','finalAcc');

%% Final accuracy evaluation with 0.1 / 0.9 data split

[trainDataArray, trainClassArray, testArray, testClassArray, kFoldsArray]=...
splitData(digitsArray, [0.05 0.95], 10, 'array');
[trainDataCell, trainClassCell, testCell, testClassCell, kFoldsCell]=...
splitData(preprocessedData,[0.05 0.95], 10,'cell');

% euc distance - Elapsed time is 0.485119 seconds,  0.8978 acc
tic
C = knn( trainDataArray, trainClassArray, testArray, 1, 'array','euc');
acc = (length(C)-sum(testClassArray(:)~=C(:)))/length(C)
toc

% euc, with uneven legnth - Elapsed time is 11.662569 seconds, 0.5589 acc
tic
C = knn( trainDataCell, trainClassCell, testCell, 1, 'cell','euc');
acc = (length(C)-sum(testClassCell(:)~=C(:)))/length(C)
toc

% dtw, with resampled data - Elapsed time is 12.194667 seconds, 0.9022 acc
tic
C = knn( trainDataArray, trainClassArray, testArray, 1, 'array','dtw', 5);
acc = (length(C)-sum(testClassArray(:)~=C(:)))/length(C)
toc

% dtw, with uneven legnth - Elapsed time is 14.886285 seconds,  0.9156 acc
tic
C = knn( trainDataCell, trainClassCell, testCell, 1, 'cell','dtw', 5);
acc = (length(C)-sum(testClassCell(:)~=C(:)))/length(C)
toc
%% ETC plotting
load('./validationData/resultStruct1');
load('./validationData/resultStruct2');
load('./validationData/resultStruct3');
load('./validationData/resultStruct4');
load('./validationData/resultStruct5');
load('./validationData/resultStruct6');
load('./validationData/resultStruct7');
load('./validationData/resultStruct8');


[m,n]=size(resultStruct4);
meanArr=[];
figure
for i=1:m
    for j=1:n
        plot(j,mean(resultStruct4(i,j).Acc),'o');hold on;
        meanArr=[mean(resultStruct4(i,j).Acc), meanArr];
    end
end
plot(1:length(resultStruct4),...
    ones(1,length(resultStruct4))*mean(meanArr),'r--')

title(['Euclidean, uniform length, meanAcc: ',num2str(mean(meanArr))]);
xlabel("Number of neighbors")
ylabel("Accuracy");
ylim([0.85 1]);

[m,n]=size(resultStruct1);
meanArr=[];
figure
for i=1:m
    for j=1:n
        plot(i,mean(resultStruct1(i,j).Acc),'o');hold on;
        meanArr=[mean(resultStruct1(i,j).Acc), meanArr];
    end
end
plot(1:length(resultStruct1),...
    ones(1,length(resultStruct1))*mean(meanArr),'r--')

title(['Euclidean, nonuniform length, meanAcc: ',num2str(mean(meanArr))]);
xlabel("Number of neighbors")
ylabel("Accuracy");
ylim([0.5 1]);


[m,n]=size(resultStruct2);
figure
meanArr=[];

for i=1:m
    subplot(2,3,i)
    for j=1:n
        plot(j,mean(resultStruct2(j,i).Acc),'o');hold on;
        meanArr=[mean(resultStruct2(j,i).Acc), meanArr];
    end
    plot(1:length(resultStruct2),...
    ones(1,length(resultStruct2))*mean(meanArr),'r--')
    title(['Dtw, uniform length, WindowS: ', num2str(i),' meanAcc: ',num2str(mean(meanArr))]);
    xlabel("Number of neighbors")
    ylabel("Accuracy");
    ylim([0.85 1]);
    meanArr=[];
end

[m,n]=size(resultStruct3);
figure
meanArr=[];
for i=1:m
    subplot(2,3,i)
    for j=1:n
        plot(j,mean(resultStruct3(j,i).Acc),'o');hold on;
        meanArr=[mean(resultStruct3(j,i).Acc), meanArr];
    end
    plot(1:length(resultStruct3),...
    ones(1,length(resultStruct3))*mean(meanArr),'r--')
    title(['Dtw, nonuniform length, WindowS: ', num2str(i),' meanAcc: ',num2str(mean(meanArr))]);
    xlabel("Number of neighbors")
    ylabel("Accuracy");
    ylim([0.85 1]);
    meanArr=[];
end

titleLast=["Euclidean, uniform length, meanAcc: ";
        'Euclidean, nonuniform length, meanAcc: ';
        'DTW, uniform length, meanAcc: ';
        'DTW, nonuniform length, meanAcc: ';]
[m,n]=size(finalAcc);
meanArr=[];
figure
for i=1:m
    subplot(2,2,i);
    for j=1:n
        plot(j,mean(finalAcc(i,j)),'o');hold on;
        meanArr=[mean(finalAcc(i,j)), meanArr];
    end
    plot(1:length(finalAcc),...
    ones(1,length(finalAcc))*mean(meanArr),'r--');
    title([titleLast(i,1),num2str(mean(meanArr))]);
    xlabel("Amount of test data (0.8, 0.4, 0.2, 0.1, 0.05)")
    ylabel("Accuracy");
    meanArr=[];
end

ylim([0.6 1]);




