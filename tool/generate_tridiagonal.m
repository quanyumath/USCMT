function A = generate_tridiagonal(n)
% 生成三对角矩阵（支持稀疏/全矩阵输出）
% 输入参数：
%   n: 矩阵维度 (n×n)
% 输出：
%   A: 三对角矩阵（默认稀疏存储，可用 full(A) 转换为全矩阵）

data = [-1 * ones(n, 1), 2 * ones(n, 1), -1 * ones(n, 1)]; % 主对角线、上副对角线、下副对角线元素
diag_positions = [-1, 0, 1]; % 对角线位置（主对角线为0，上副为+1，下副为-1）
A = spdiags(data, diag_positions, n, n);
A = full(A);
A = full(A); A(1, 1) = 1; A(end, end) = 1;
end