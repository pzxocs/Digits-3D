function C = digit_classify(input)
% DIGIT_CLASSIFY function perform necessary data transformation
% 1) REQUIRES train data from ./preprocessedData/digitsArray.mat file!
% 2) randomly choose train samples from data file and perform classification
%   INPUT: a single double array with shape (:,3)
%   OUTPUT: class label
input={{input}};
input=normalizeDigits(input);
input=smoothDigits(input,10);
input={{input{1}{1}(:,1:2)}};
input=resampleDigits(input,50);
load('./preprocessedData/digitsArray.mat');
[trainDataArray, trainClassArray, ~, ~, ~]=...
    splitData(digitsArray, [0.6 0.4],[], 'array');
C = knn( trainDataArray, trainClassArray, input, 1, 'array','dtw', 5);
end

