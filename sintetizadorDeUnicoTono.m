
% Sintetizador de un unico tono...

clc
clear all

% Tiempo duración del tono en segundos(s)...
TD = 0.250;

% Frecuencia de muestreo en Hz...
Fs = 40000;

validInputs = ['1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '0'; '*'; '#'];

% Vector de tiempo, 250 ms en total...
T = linspace(0, 0.25, 10001);

isContained = false(1);

while isContained == false(1)
    
    disp('Ingrese el digito cuyo tono desea generar...');
    digit = input('', 's');
    
    for j = 1:1:12
        if digit == validInputs(j)
            isContained = true(1);
            
        end
    end
    
    if isContained == false(1)
        disp('El valor ingresado no es valido...');
    end
end

[f1, f2] = getFrequencies(digit);
[y, t] = DTMF(f1, f2, Fs, TD);

soundsc(y, Fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Transformada de Fourier...

Y_fft = fft(y);
Y_fft_cent = fftshift(Y_fft);

Y_mag = abs(Y_fft_cent);
Y_phase = unwrap(angle(Y_fft_cent));

f = linspace(-Fs/2, Fs/2, length(y));       % Dominio de la frecuencia...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot...

plot(f, Y_mag, 'r');
grid on;
xlabel('Frecuencia (Hz)'), ylabel('Magnitud (dB)');








