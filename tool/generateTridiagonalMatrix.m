function A = generateTridiagonalMatrix(n)
% GENERATETRIDIAGONALMATRIX 生成特定模式的三对角矩阵并删除最后两行
%   A = generateTridiagonalMatrix(n) 返回一个 (n-2)×n 矩阵，其中：
%      - 每行以 [-1 2 -1] 开头，其余补零
%      - 模式向右移动，例如：
%         第一行: [-1 2 -1 0 0 ...]
%         第二行: [0 -1 2 -1 0 ...]
%         第三行: [0 0 -1 2 -1 ...]
%         删除最后两行后，矩阵尺寸为 (n-2)×n
%
% 示例:
%   A = generateTridiagonalMatrix(5); % 返回 3×5 矩阵
%   disp(A);

    if n <= 2
        error('输入 n 必须大于 2，否则无法删除最后两行。');
    end
    
    A_full = zeros(n, n); % 初始化全零矩阵
    
    for i = 1:n
        % 计算当前行 [-1 2 -1] 的起始位置
        start_col = i;
        end_col = min(i + 2, n); % 避免超出矩阵边界
        
        % 填充 [-1 2 -1]
        if start_col <= n - 2
            A_full(i, start_col:end_col) = [-1 2 -1];
        else
            % 处理最后几行（避免越界）
            remaining = n - start_col + 1;
            if remaining >= 3
                A_full(i, start_col:end_col) = [-1 2 -1];
            elseif remaining == 2
                A_full(i, start_col:end_col) = [-1 2];
            else % remaining == 1
                A_full(i, start_col:end_col) = -1;
            end
        end
    end
    
    % 删除最后两行
    A = A_full(1:end-2, :);
end