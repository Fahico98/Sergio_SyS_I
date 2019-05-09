
% Band pass filter.

function [ X_filter ] = BandPassFilter(X, f, omegaLess, omegaHigher)
    H = ((f < -omegaLess) | (f > omegaLess)) & ((f > -omegaHigher) & (f < omegaHigher));
    X_filter = X .* H;
end
