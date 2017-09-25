% load masks
load('masks.mat');
nmasks = length(Masks); % number of game masks

% init area of mask
MaskArea = zeros(nmasks,1);
TotalArea = zeros(nmasks,1);

% for each mask, add up total number of pixels with orange mask
% RGB: 255,147,30
for m = 1:nmasks
    MaskPixels = find(Masks{m}(:,:,1) == 255 & ...
        Masks{m}(:,:,2) == 147 & ...
        Masks{m}(:,:,3) == 30);
    
    MaskArea(m) = length(MaskPixels);
    TotalArea(m) = size(Masks{m},1) * size(Masks{m},2);
    
end

% variables
PerArea = (MaskArea ./ TotalArea) * 100;

% create table
gameInfo = readtable('GameInfo.xlsx');
ReleaseYear = gameInfo.ReleaseYear;
gameList = gameInfo.Title;
genre = gameInfo.Genre;
HUDTable = table(gameList,PerArea,ReleaseYear,genre);

% graphing percent area HUD for all games
for n = 1:2
    if n == 1 % plot by release year
        T = sortrows(HUDTable,'ReleaseYear'); % sorted by release
    else % plot by PerArea
        T = sortrows(HUDTable,'PerArea'); % sorted by HUD screen size
    end
    bar_list = T.gameList';
    bar_values = T.PerArea;
    fig1 = figure(n);
    barh(bar_values);
    
    NewList = cell(50,1);
    % combine title with release year
    for x = 1:nmasks
        NewList{x} = strcat(T.gameList{x},' (',int2str(T.ReleaseYear(x)),')');
    end
    
    set(gca,'YtickLabel',NewList,'YTick',1:nmasks);
%     set(gca,'XTickLabelRotation',45);
    ylabel("Percentage of Screen Size")
    set(fig1,'Position',[100,100,1440,800])

    % set top and right axes
    ax1 = gca;
    ax2 = axes('Position', get(ax1, 'Position'),'Color', 'none');
    set(ax2, 'XAxisLocation', 'top','YAxisLocation','Right');
    % set the same Limits and Ticks on ax2 as on ax1;
    set(ax2, 'XLim', get(ax1, 'XLim'),'YLim', get(ax1, 'YLim'));
    set(ax2, 'XTick', get(ax1, 'XTick'), 'YTick', get(ax1, 'YTick'));
    OppTickLabels = T.ReleaseYear';
    % Set the x-tick and y-tick  labels for the second axes
%     set(ax2, 'XTickLabel', OppTickLabels);
    ax2.XLabel.String = 'Release Year';
    set(ax2,'XTickLabelRotation',90);
end

% graphing percent area averaged across genre
[D] = TableSort(T,'genre',{'PerArea'},1);
bar_gen = unique(HUDTable.genre);
bar_genc = categorical(bar_gen);

% more plotting with standard error
fig2 = figure(3);
set(fig2,'Position',[100,100,1440,800])
hold on;
b = barwitherr(D.errdata(1:9),D.data(1:9));
ax = gca;
ax.XTick = 1:9;
ax.XTickLabel = bar_gen;
xlabel('Genre')
ylabel("Percentage of Screen Size")
