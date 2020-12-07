function smoothedDigits = smoothDigits(digits, windowSize)
% Perform 1-D moving average filter with given {windowSize}
%   INPUT: digits - cell array with samples
%          windowSize - size of a slide windows for moving average filter
%   OUTPUT: smoothedDigits - smoothed cell array 
[~,m]=size(digits);
[~,n]=size(digits{1});
smoothedDigits=digits;
for digit=1:m 
    for sampleNumber=1:n
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
         smoothedDigits{digit}{sampleNumber}(:,1)=...
             filter(b,a,digits{digit}{sampleNumber}(:,1));
         smoothedDigits{digit}{sampleNumber}(:,2)=...
             filter(b,a,digits{digit}{sampleNumber}(:,2));
         smoothedDigits{digit}{sampleNumber}(:,3)=...
             filter(b,a,digits{digit}{sampleNumber}(:,3));
    end
end

end

