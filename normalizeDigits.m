function normalizedDigits = normalizeDigits(digits)
% Perform z-score normalization using matlab built-in funciton.
%   Center and scale data to have mean 0 and standard deviation 1.
%   INPUT: digits - cell array from "loadDigits" funciton.
%   OUTPUT: normalizedDigits - cell array with centered and scaled data.

normalizedDigits=digits;
[~,m]=size(digits);
[~,n]=size(digits{1});
for digit=1:m 
    for sampleNumber=1:n
        normalizedDigits{digit}{sampleNumber}=...
            normalize(digits{digit}{sampleNumber},'zscore');
    end
end

end

