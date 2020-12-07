function C = knn(trainData, trainClass, testData, k, dataType, distance, w)
% k-Nearest Neighbors classifier.
%   INPUT: trainData - data to train classifier.
%          trainClass - labels for classifier training.
%          testData - input data to classify
%          k - number of nearest neighbors to take into account
%          dataType - cell (nonuniform length) or arrray - uniform length
%          distance - 'euc' or 'dtw', euclidean and dynamic time warping.
%          w - parameter for adjusting window in Dynamic Time Warping.
%   OUTPUT: C - out classes for testData.

    switch distance
        case 'euc'
            if dataType=="cell"
                func=@(x,y) pdist2(x,y,'euclidean','Smallest',1);
            else
                func=@(x,y) sum((x-y).^2).^0.5;
            end
        case 'dtw'
            if exist('w','var')
                func=@(x,y) dtw(x,y,w);
            else
                func=@(x,y) dtw(x,y);
            end
        otherwise
            if dataType=="cell"
                if exist('w','var')
                    func=@(x,y) dtw(x,y,w);
                else
                    func=@(x,y) dtw(x,y);
                end 
            else
                func=@(x,y) sum((x-y).^2).^0.5;
            end
    end
    switch dataType
        case 'array'              
            [M, ~, ~] = size(trainData); % trainData count
            [N, ~, ~] = size(testData); % testData count
            % calculate distances
            dist = zeros(N, M);
            for i = 1 : N
                for j = 1 : M
                    dist(i, j) = norm([func(testData(i, :, 1),trainData(j, :, 1))...
                                   func(testData(i, :, 2),trainData(j, :, 2))]);
      
%                     dist(i, j) = norm([dtw(testData(i, :, 1),trainData(j, :, 1))...
%                                    dtw(testData(i, :, 2),trainData(j, :, 2))]);
                end
            end
        case 'cell'
            [~, M] = size(trainData); % trainData count
            [~, N] = size(testData); % testData count
            % calculate distances
            dist = zeros(N, M);
            if distance=='dtw'
                for i = 1 : N
                for j = 1 : M
                      dist(i, j) =  norm([func(testData{i}( :, 1),trainData{j}( :, 1))...
                                   func(testData{i}( :, 2),trainData{j}( :, 2))]);

%                     dist(i, j) =  norm([dtw(testData{i}( :, 1),trainData{j}( :, 1))...
%                                    dtw(testData{i}( :, 2),trainData{j}( :, 2))]);
                end
            end
            else
                for i = 1 : N
                    for j = 1 : M
                          dist(i, j) =  norm(func(testData{i},trainData{j}));
    %                     dist(i, j) =  norm([dtw(testData{i}( :, 1),trainData{j}( :, 1))...
    %                                    dtw(testData{i}( :, 2),trainData{j}( :, 2))]);
                    end
                end
            end
    end

    % Init output labels variable
    C = zeros(N, 1);
    for i = 1 : N
        % Sort distances
        [~, ind] = sort(dist(i, :), 'ascend');
        % Reset classes for the
        classes = zeros(k, 1);
        % Get classes for neighbors
        for j = 1 : k
            classes(j) = trainClass(ind(j));
        end
        % Calculate dominating class
        C(i) = mode(classes);
    end
end