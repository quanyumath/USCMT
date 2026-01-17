function anomaly = generate_anomaly_labels(crash_label, human_label)

    % 获取矩阵大小
    [M, N] = size(crash_label);

    % 初始化 anomaly 矩阵
    anomaly = zeros(M, N);

    % 时间窗口对应列偏移
    delta_human = round(1800/30); % 60
    delta_crash = round(900/30);  % 30
    delta_incident_start = round(900/30);  % 30
    delta_incident_end = round(6300/30);   % 210

    % 找到 human_label == 1 的列
    human_cols = find(any(human_label == 1, 1));
    for i = 1:length(human_cols)
        col = human_cols(i);
        target_cols = col:min(N, col + delta_human);
        anomaly(:, target_cols) = 1;
    end

    % 找到 crash_label == 1 的列
    crash_cols = find(any(crash_label == 1, 1));
    for i = 1:length(crash_cols)
        col = crash_cols(i);
        start_col = max(1, col - delta_crash);
        end_col = min(N, col + delta_crash);
        anomaly(:, start_col:end_col) = 1;
    end

    % 合并 human_label 和 crash_label
    incident_cols = unique([human_cols, crash_cols]);
    for i = 1:length(incident_cols)
        col = incident_cols(i);
        start_col = min(N, col + delta_incident_start);
        end_col = min(N, col + delta_incident_end);
        % 仅在 anomaly 还未标记为 1 时，标记为 -1
        mask = anomaly(:, start_col:end_col) == 0;
        anomaly(:, start_col:end_col) = anomaly(:, start_col:end_col) + (-1) .* mask;
    end

end
