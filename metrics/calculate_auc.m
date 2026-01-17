function [X_pr, Y_pr, T_pr, roc_auc] = calculate_auc(test_errors, anomaly_labels)
    % test_errors: m x n (m节点, n时刻)
    % anomaly_labels: m x n (m节点, n时刻)

    % 计算每个时间点的异常分数 (最大误差)
    score = max(test_errors, [], 1);  % 1 x n，每个时间点的最大值

    % 提取每个时间点的标签 (如果所有节点都一样，只取一行)
    % 如果有 -1，则忽略该时间点
    time_labels = anomaly_labels(1, :); % 默认取第一个节点的标签

    % 检查其他节点标签是否一致
    if ~all(all(anomaly_labels == anomaly_labels(1, :)))
        warning('不同节点标签不一致，仅使用第一个节点的标签。');
    end

    % 过滤掉 -1
    valid_idx = time_labels ~= -1;
    score = score(valid_idx);
    time_labels = time_labels(valid_idx);

    % 计算 AUC
    [X_pr, Y_pr, T_pr, roc_auc] = perfcurve(time_labels, score, 1);
end

