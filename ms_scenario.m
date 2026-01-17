function Omega = ms_scenario(dim, ms, missingrate)

dim1 = dim(1); dim2 = dim(2); dim3 = dim(3); dim4 = dim(4);
if strcmp(ms, 'random')
    Pomega = round(rand(dim)+0.5-missingrate);
elseif strcmp(ms, 'FM1') % Fiber missing (FM)
    A = round(rand(dim2, dim3, dim4)+0.5-missingrate);
    A = reshape(A, [1, dim2, dim3, dim4]);
    Pomega = repmat(A, [dim1, 1, 1, 1]);
elseif strcmp(ms, 'FM2')
    A = round(rand(dim1, dim3, dim4)+0.5-missingrate);
    A = reshape(A, [dim1, 1, dim3, dim4]);
    Pomega = repmat(A, [1, dim2, 1, 1]);
elseif strcmp(ms, 'FM3')
    A = round(rand(dim1, dim2, dim4)+0.5-missingrate);
    A = reshape(A, [dim1, dim2, 1, dim4]);
    Pomega = repmat(A, [1, 1, dim3, 1]);
end
Omega = find(Pomega == 1);
end