function [digitsArray, preprocessedData] = dataPreprocessing(digits)
%DATAPREPROCESSING unite all the necessary steps to obtain a quality data: 
%centering, rescaling, smoothing, dimensionality reduction and resampling.
%Also some demonstrations included
% INPUT: raw {digits} cell array from "parseData" function
% OUTPUT: digitsArray - contains RESAMPLED to unit length preprocessedData!
%         preprocessedData - contains NOT RESAMPLED data with uneven
%         length.

% Let's observe some samples from raw data.
figure
legendS=["1st sample","10th sample","50th sample","100th sample"];
titleS="Digit 0, Raw data observation";
plotSamples(3, digits, 0, [1,10,50,100], legendS, titleS)

% After plotting some random samples we can consider about:
% 1) Normalizing the data (z-score), center and scale data to have 
% mean 0 and standard deviation 1.
% 2) Noise reduction or smoothing.
% !3) Bad data samples or outliers removal !Point to improve, has not been
% done
% 4) Dimensonality reduction

% Step 1 normalizing data
digitsNormalized=normalizeDigits(digits);

% Plot the data after normalization
figure
legendS=["1st sample","10th sample","50th sample","100th sample"];
titleS="Digit 0, Normalized data observation";
plotSamples(3, digitsNormalized, 0, [1,10,50,100], legendS, titleS)

% Step 2 smooth the date, using moving average filter with windows size 10

digitsSmoothed3=smoothDigits(digitsNormalized, 3);
% Plot the data after smoothing
figure;
subplot(2,2,1)
legendS=["1st sample","10th sample","50th sample","100th sample"];
titleS="Digit 0, Smoothed data, window size - 3";
plotSamples(3, digitsSmoothed3, 0, [1,10,50,100], legendS, titleS)

digitsSmoothed5=smoothDigits(digitsNormalized, 5);
% Plot the data after smoothing
subplot(2,2,2)
legendS=["1st sample","10th sample","50th sample","100th sample"];
titleS="Digit 0, Smoothed data, window size - 5";
plotSamples(3, digitsSmoothed5, 0, [1,10,50,100], legendS, titleS)

digitsSmoothed10=smoothDigits(digitsNormalized, 10);
% Plot the data after smoothing
subplot(2,2,3)
legendS=["1st sample","10th sample","50th sample","100th sample"];
titleS="Digit 0, Smoothed data, windows size - 10";
plotSamples(3, digitsSmoothed10, 0, [1,10,50,100], legendS, titleS)

digitsSmoothed15=smoothDigits(digitsNormalized, 15);
% Plot the data after smoothing
subplot(2,2,4)
legendS=["1st sample","10th sample","50th sample","100th sample"];
titleS="Digit 0, Smoothed data, window size 15";
plotSamples(3, digitsSmoothed15, 0, [1,10,50,100], legendS, titleS)

% Step 3 - Skipped

% Step 4

% Apply PCA to find out intrinsic number of dimensions          

[coeff, score, latent, tsquared, explained] = pca(digitsSmoothed10{1}{1}); 

% From {explained} variable we can conclude that a third dimension in a
% data set has a very small variance, so we can ignore it.

% 
preprocessedData=cell(1,10);
for digit=1:10 
    for sampleNumber=1:100
        preprocessedData{digit}{sampleNumber}=...
            digitsSmoothed10{digit}{sampleNumber}(:,1:2);
    end
end

% As an in input sample to each digit has different length if we want to use
% euclidean distance and get sensible results it is necessary
% to form a unit length for all the samples. 
% Resample parameter p/q  we will define by
% analyzing histogram which represents distribution of lengts among
% samples.

% counting overall length
digitsLength=zeros(1,1000);

for i=1:10
    for j=1:100
        digitsLength((i-1)*100+j)=length(digits{i}{j});
    end
end

figure
histogram(digitsLength);hold on;
title("Distribution of length among samples");
xlabel("Length of an x_i sample")
ylabel("Amount of samples on each bound");

% The most frequent length is in boundary from 40 to 50. 50 - resample
% length
 
% For resampling we use built-in matlab function resample
% Prepare resampled digitsArray
digitsArray=resampleDigits(preprocessedData,50);
