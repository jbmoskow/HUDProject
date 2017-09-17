%% HUD Loader
% Loads the .png masks output by Adobe Illustrator which can then be saved
% to a .mat

% number of video games
nmasks = 50;

% init cell array
Masks = cell(1,nmasks);

% Load in mask images
for m = 1:nmasks
    filename = sprintf('mask-%02.2d.png',m);
    Masks{m} = imread(filename);
end

