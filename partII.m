%% Initialisation
clear
d = dir('MXB201_2026_Project_data/faces/*.pgm');
N = length(d);
I = imread([d(1).folder, '/', d(1).name]);
[rows,cols] = size(I);
M = rows*cols;
A = zeros(M, N);  % big matrix, whose columns are the images

% Read images as columns of the matrix
for j = 1:N
    I = imread([d(j).folder, '/', d(j).name]);
    A(:,j) = I(:);
end

%% Calculate Mean Face

mean_face = mean(A, 2);

%% Mean Centered SVD

A_centered = A - mean_face;
[U, ~, V] = svd(A_centered, 'econ');

%% Get moustache value

% get projection of each other centered face onto the moustache eigenface, 
% checking how close each face is to target moustache eigenface
moustache_eigenface = U(:, 13);
scores = (moustache_eigenface' * A_centered)';

normalisedScores = (scores - min(scores)) / (max(scores) - min(scores));

threshold = 0.75;