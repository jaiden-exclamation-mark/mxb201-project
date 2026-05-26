%% Initialisation
clear
d = dir('MXB201_2026_Project_data/faces/*.pgm');
N = length(d);
I = imread([d(1).folder, '/', d(1).name]);
[rows,cols] = size(I);
M = rows*cols;
A = zeros(M, N);  % big matrix, whose columns are the images

screen_width = 1920;
screen_height = 1080;

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

%% Draw Figures

% Mean Face
width = 300;
height = screen_height * 0.5;
x_pos = (screen_width - width) * 0.5;
y_pos = height;

createFigure(x_pos, y_pos, width, height);
imshow(reshape(mean_face, rows, cols), [], 'InitialMagnification', 'fit');
addStyledText(5,15, 'Mean Face', 'w')

% First 20 Eigenfaces
width = screen_width * 0.4;
height = screen_height * 0.5;
x_pos = 0.0;
y_pos = 0.0;

createFigure(x_pos, y_pos, width, height);
t = tiledlayout(5, 4, 'TileSpacing', 'none', 'Padding', 'compact');
title(t, 'First 20 Eigenfaces');

for k = 1:20
    nexttile;
    eigenface = reshape(U(:, k), rows, cols);
    imshow(eigenface, [], 'InitialMagnification', 'fit');
    addStyledText(5, 15, sprintf('Eigenface No.%d', k), 'w');
end

% Random 30 Moustaches
face_count = 30;
test_indices = randperm(N, face_count);

width = screen_width * 0.6;
height = screen_height * 0.5;
x_pos = (screen_width-width) * 1.0;
y_pos = (screen_height-height) * 0.0;

createFigure(x_pos, y_pos, width, height);

t = tiledlayout(5, 6, 'TileSpacing', 'none', 'Padding', 'compact');

title(t, 'Moustache Detection on 30 Random Faces');


for i = 1:face_count
    idx = test_indices(i);
    nexttile;
    im_fig = imshow(reshape(A(:, idx), rows, cols), [], 'InitialMagnification', 'fit');
    if normalisedScores(idx) > threshold
        addStyledText(5, 15, sprintf('%d: yes', idx), 'g');
    else
        addStyledText(5, 15, sprintf('%d: no', idx), 'r');
    end
end


%% Helper Functions

function addStyledText(x, y, displayString, textColor)
    t = text(x, y, displayString);
    t.Color = textColor;
    t.FontSize = 12;
    t.FontWeight = 'bold';
    t.BackgroundColor = 'k';
end

function createFigure(x, y, w, h)
    f = figure();
    f.Position = [x,y,w,h];
    f.MenuBar = 'none';
    f.ToolBar = 'none';
end