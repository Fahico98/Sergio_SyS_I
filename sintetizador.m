
% Sintetizador...

clc
clear all

% Tiempo duración del tono en segundos(s)...
TD = 0.250;

% Frecuencia de muestreo en Hz...
Fs = 40000;

validInputs = ['1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '0'; '*'; '#'];

disp('Inserte los 7 digitos de su llamada separados por Enter...');

% Vector vacio de 250 ms de duración...
delayArray = zeros(1, 10001);

% Vector vacio donde se almacenaran los tonos generados por cada entrada...
Y = [];

% Vector de tiempo, 3750 ms en total...
T = linspace(0, 3.75, 150015);

% Se agrega un delay de 250 ms al principio de la transmisión...
Y = [Y, delayArray];

i = 1;

while i <= 7
    digit = input('', 's');
    isContained = false(1);
    
    for j = 1:1:12
        if digit == validInputs(j)
            isContained = true(1);
        end
    end
    
    if isContained == false(1)
        disp('El ultimo valor ingresado no es valido...');
        i = i - 1;
    else
        [f1, f2] = getFrequencies(digit);
        [y, t] = DTMF(f1, f2, Fs, TD);
        
        Y = [Y, y, delayArray];
        
        soundsc(y, Fs)
    end
    
    i = i + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Guardar y Reproducir...

% fileName = '1234567.wav';
% audiowrite(fileName, Y, Fs);
% 
% disp('Desea reproducir la transmisión generada... (si/no)');
% 
% play = input('', 's');
% 
% if play == 'si' | play == 'SI'
%     soundsc(Y, Fs)
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Transformada de Fourier...

Y_fft = fft(Y);
Y_fft_cent = fftshift(Y_fft);

Y_mag = abs(Y_fft_cent);
Y_phase = unwrap(angle(Y_fft_cent));

f = linspace(-Fs/2, Fs/2, length(Y));       % Dominio de la frecuencia...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot...

subplot(3, 1, 1);
plot(T, Y, 'k');
grid on;
xlim([0, 3.75]);
xlabel('Tiempo (s)'), ylabel('Amplitud');

subplot(3, 1, 2);
plot(f, Y_mag, 'r');
grid on;
xlim([670, 1520]);
xlabel('Frecuencia (Hz)'), ylabel('Magnitud (dB)');

subplot(3, 1, 3);
plot(f, Y_phase, 'b');
grid on;
xlim([670, 1520]);
xlabel('Frecuencia (Hz)'), ylabel('Fase (rad)');








