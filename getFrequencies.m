
% getFrequencies function...

function [f1, f2] = getFrequencies(digit)
    switch digit
        case '1'
            f1 = 697;
            f2 = 1209;
        case '2'
            f1 = 697;
            f2 = 1336;
        case '3'
            f1 = 697;
            f2 = 1477;
        case '4'
            f1 = 770;
            f2 = 1209;
        case '5'
            f1 = 770;
            f2 = 1336;
        case '6'
            f1 = 770;
            f2 = 1477;
        case '7'
            f1 = 852;
            f2 = 1209;
        case '8'
            f1 = 852;
            f2 = 1336;
        case '9'
            f1 = 852;
            f2 = 1477;
        case '*'
            f1 = 941;
            f2 = 1209;
        case '0'
            f1 = 941;
            f2 = 1336;
        case '#'
            f1 = 941;
            f2 = 1477;
    end
end