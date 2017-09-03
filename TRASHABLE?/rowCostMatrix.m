function rowCM = rowCostMatrix(rowIndex, histMatrix)
    H_i = repmat(histMatrix(rowIndex , :), max(size(histMatrix)), 1);
    rowCM = sum(((H_i - histMatrix).^2)./(H_i + histMatrix) , 2 )';
end