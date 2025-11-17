data = readtable('keyword_trend_factors (n2).csv');
x = data.Trend_2000_2018;
y = data.Total_Count_5yrs;
size = data.Total_Count_24yrs;

% 使用 log1p 函数进行 log 变换，可以处理负值和零值
x = log1p(abs(x));  % 取绝对值再进行 log1p 变换
y = log1p(abs(y)); 

% avgSize = mean(size);
% stdSize = std(size);
% size = (size - avgSize) / stdSize+1;


% 计算每个气泡的颜色值 (趋势因子的平均值)
colorValues = data.Trend;

% 创建散点图，并将气泡大小和颜色设置为对应变量
% 增大气泡大小：将 size 乘以一个系数，例如 50
scatter(x, y, size*6, colorValues, 'filled','MarkerEdgeColor', 'k', MarkerFaceAlpha= 0.7, MarkerEdgeAlpha= 1); 

% 设置颜色映射为热力图
colormap(jet); 

% 根据气泡大小调整坐标轴范围
xlim([3, 6]);
ylim([3, 6]);

% 添加颜色条 (图例)
colorbar; 
caxis([min(colorValues), max(colorValues)]); 
ylabel(colorbar, '趋势因子 (T)','FontSize', 18); 

% 添加文本标签 (关键词)，增大字体大小
for i = 1:height(data)
    text(x(i), y(i), data.Keyword{i}, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontSize', 15); % 将字体大小设置为 10
end

% 设置坐标轴标签和标题 (注意添加 log 指示)
xlabel('2000-2018年关键词的频率 (log(f_1))','FontSize', 20);
ylabel('2019-2024年关键词的趋势频率 (log(f_2))','FontSize', 20);
title('水中EDCs研究趋势气泡图','FontSize', 24);


% 添加参考线 (注意 log 变换后的参考线)
hold on; 
plot([-10, 10], [-10, 10], 'k--');
hold off;

% 添加框线
box on; 

% 设置坐标轴线宽
set(gca, 'LineWidth', 1.5); % 将坐标轴线宽设置为 1.5
pbaspect([1 0.8 1]);