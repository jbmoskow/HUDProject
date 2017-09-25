clear

I = imread('Left4Dead2-02.png');
% Igray = rgb2gray(I);
% imshow(Igray);

points = [0 0];
M{1} = load('Halo3mask.mat'); % load saved binary mask of HUD locations
M{2} = load('Left4Dead2mask.mat');

for i = 1:2 % for each mask
    [y,x] = find(M{i}.BW == 1); % find points where the mask is
    points = [points;x y];
end

% draw heat density map of point locations
grid = 256;

minvals = min(points);
maxvals = max(points);
rangevals = maxvals - minvals;
xidx = 1 + round((points(:,1) - minvals(1)) ./ rangevals(1) * (grid-1));
yidx = 1 + round((points(:,2) - minvals(2)) ./ rangevals(2) * (grid-1));
density = accumarray([yidx, xidx], 1, [grid,grid]);  %note y is rows, x is cols
imagesc(density, 'xdata', [minvals(1), maxvals(1)], 'ydata', [minvals(2), maxvals(2)]);