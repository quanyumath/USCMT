function [AUCs_all, Threshold] = AUCsMulti(Events_all, Labels_2D, methodNames)
% 输入：
%   Events_all: N×1 cell，每个 cell 是各种方法得到的大小为 Detectors×Days×Intervals 的3阶得分张量
%   Labels_2D: Detectors × (Days × Intervals) 的真实标签矩阵

%
% 输出：
%   AUCs_all: 1×N cell，每种方法的 AUC 数值


    N = numel(Events_all);

    % 预处理 Anomaly_crash_vec，只需要做一次
    Nway = size(Events_all{1});
    
    figure;
    hold on;
    colors = lines(N); % 自动生成N种颜色

    for i = 1:N
        E = Events_all{i};                  % 当前方法的 3D 输出

        E_unfolded = Unfold(permute(E, [1, 3, 2]), Nway, 1);  % 统一展开方式

        % AUC 计算
        [X_pr, Y_pr, T_pr, auc] = calculate_auc(E_unfolded, Labels_2D);
        j_scores = Y_pr - X_pr;
        [~, idx] = max(j_scores);
        Thr = T_pr(idx);
        
        plot(X_pr, Y_pr, 'LineWidth', 2, 'Color', colors(i,:), ...
            'DisplayName', methodNames{i});

        % 存入 cell
        Threshold(i) = Thr;
        AUCs_all(i) = auc;
    end
    % 图例和标签
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
%     title('ROC Curves');
%     legend('Location', 'Best');
    grid on;
    hold off;
end
