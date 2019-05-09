
% getDigit fuction...

function [digit] = getDigit(f1, f2)

    f2_array = [1209, 1336, 1477];
    f1_array = [697, 770, 852, 941];
    gap = 5;
    digit = '-';
    
    if (f1_array(1) - gap <= f1 & f1 <= f1_array(1) + gap) & (f2_array(1) - gap <= f2 & f2 <= f2_array(1) + gap)
        digit = '1';
    elseif (f1_array(1) - gap <= f1 & f1 <= f1_array(1) + gap) & (f2_array(2) - gap <= f2 & f2 <= f2_array(2) + gap)
        digit = '2';
    elseif (f1_array(1) - gap <= f1 & f1 <= f1_array(1) + gap) & (f2_array(3) - gap <= f2 & f2 <= f2_array(3) + gap)
        digit = '3';
    elseif (f1_array(2) - gap <= f1 & f1 <= f1_array(2) + gap) & (f2_array(1) - gap <= f2 & f2 <= f2_array(1) + gap)
        digit = '4';
    elseif (f1_array(2) - gap <= f1 & f1 <= f1_array(2) + gap) & (f2_array(2) - gap <= f2 & f2 <= f2_array(2) + gap)
        digit = '5';
    elseif (f1_array(2) - gap <= f1 & f1 <= f1_array(2) + gap) & (f2_array(3) - gap <= f2 & f2 <= f2_array(3) + gap)
        digit = '6';
    elseif (f1_array(3) - gap <= f1 & f1 <= f1_array(3) + gap) & (f2_array(1) - gap <= f2 & f2 <= f2_array(1) + gap)
        digit = '7';
    elseif (f1_array(3) - gap <= f1 & f1 <= f1_array(3) + gap) & (f2_array(2) - gap <= f2 & f2 <= f2_array(2) + gap)
        digit = '8';
    elseif (f1_array(3) - gap <= f1 & f1 <= f1_array(3) + gap) & (f2_array(3) - gap <= f2 & f2 <= f2_array(3) + gap)
        digit = '9';
    elseif (f1_array(4) - gap <= f1 & f1 <= f1_array(4) + gap) & (f2_array(1) - gap <= f2 & f2 <= f2_array(1) + gap)
        digit = '*';
    elseif (f1_array(4) - gap <= f1 & f1 <= f1_array(4) + gap) & (f2_array(2) - gap <= f2 & f2 <= f2_array(2) + gap)
        digit = '0';
    elseif (f1_array(4) - gap <= f1 & f1 <= f1_array(4) + gap) & (f2_array(3) - gap <= f2 & f2 <= f2_array(3) + gap)
        digit = '#';
    end
end