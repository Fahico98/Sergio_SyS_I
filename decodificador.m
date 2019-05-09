
% Decodificador...

clc
clear all;

% Frecuencia de muestreo...
Fs = 40000;

% Tiempo de cada muestra...
Ts = 1/Fs;

% Tiempo de grabación...
Tr = 3.75;

% Vector de tiempo para toda la grabación, 3750 ms en total...
T = linspace(0, Tr, 150000);

% Numero de muestras por tono...
Ns_tone = 10000;

% Vector de tiempo para un solo tono, 250 ms en total...
T_tone = linspace(0, 0.25, Ns_tone + 1);

% Limites de frecuencia para filtración...
omegaLess = 690;
omegaHigher = 1480;

recObj = audiorecorder(Fs, 16, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Captura de tonos...

disp('Por favor empiece la reproducción en...');
pause(1);
disp('3...');
pause(1);
disp('2...');
pause(1);
disp('1...');
pause(1);
disp('¡Ahora!');
recordblocking(recObj, Tr);
disp('Ya puede finalizar la reproducción.');

y = getaudiodata(recObj);
soundsc(y, Fs)
Y = y';

tonesArray = zeros(7, Ns_tone + 1);

gap = Ns_tone;
step = 0;

for i = 1:1:7
    if i == 1
        tonesArray(1, :) = Y(1 , 25000 : 25000 + Ns_tone);
        step = (2 * gap) + Ns_tone;
    else
        tonesArray(i, :) = Y(1, step + gap : step + (2 * gap));
        step = step + gap + Ns_tone;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot...

% for i = 1:1:7
%     figure
%     plot(T_tone, tonesArray(i, :), 'r');
%     grid on;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRF y Filtrado de la señal completa...

Y_fft = fft(Y);
Y_center = fftshift(Y_fft);

Y_mag = abs(Y_center);
Y_phase = unwrap(angle(Y_center));

f = linspace(-Fs/2, Fs/2, length(Y));

Y_mag_filtered = BandPassFilter(Y_mag, f, omegaLess, omegaHigher);
Y_phase_filtered = BandPassFilter(Y_phase, f, omegaLess, omegaHigher);

subplot(3, 1, 1);
plot(T, Y, 'k');
grid on;
xlabel('Tiempo (s)'), ylabel('Amplitud');

subplot(3, 1, 2);
plot(f, Y_mag_filtered, 'r');
grid on;
xlabel('Frecuencia (Hz)'), ylabel('Magnitud (dB)');

subplot(3, 1, 3);
plot(f, Y_phase_filtered, 'b');
grid on;
xlabel('Frecuencia (Hz)'), ylabel('Fase (rad)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRF para los tonos...

tonesArray_fft = zeros(7, Ns_tone + 1);
tonesArray_fft_center = zeros(7, Ns_tone + 1);
tonesArray_mag = zeros(7, Ns_tone + 1);
tonesArray_phase = zeros(7, Ns_tone + 1);

for i = 1:1:7
    tonesArray_fft(i, :) = fft(tonesArray(i, :));
    tonesArray_fft_center(i, :) = fftshift(tonesArray_fft(i, :));
    tonesArray_mag(i, :) = abs(tonesArray_fft_center(i, :));
    tonesArray_phase(i, :) = unwrap(angle(tonesArray_fft_center(i, :)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Filtrado de tonos...

tonesArray_filtered = zeros(7, Ns_tone + 1);

f = linspace(-Fs/2, Fs/2, Ns_tone + 1);

for i = 1:1:7
    tonesArray_filtered(i, :) = BandPassFilter(tonesArray_mag(i, :), f, omegaLess, omegaHigher);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot...

% for i = 1:1:7
%     figure;
%     plot(f, tonesArray_filtered(i, :), 'r');
%     grid on;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Decodificación de tonos...

freqDecode = zeros(7, 2);
f_abs = abs(f);

for i = 1:1:7
    [peaks, locs] = findpeaks(tonesArray_filtered(i, :));
    [M, I] = max(peaks);
    tonesArray_filtered(i, locs(I)) = 0;
    freqDecode(i, 1) = f_abs(locs(I));
    first = f_abs(locs(I));
    
    [peaks, locs] = findpeaks(tonesArray_filtered(i, :));
    [M, index] = max(peaks);
    tonesArray_filtered(i, locs(I)) = 0;
    buffer = f_abs(locs(I));
    
    while buffer < first + 50 & buffer > first - 50
        [peaks, locs] = findpeaks(tonesArray_filtered(i, :));
        [M, I] = max(peaks);
        tonesArray_filtered(i, locs(I)) = 0;
        buffer = f_abs(locs(I));
    end
    
    freqDecode(i, 2) = buffer;
end

output = char.empty(0, 7);

for i = 1:1:7
    
    if freqDecode(i, 1) > freqDecode(i, 2)
        f1 = freqDecode(i, 2);
        f2 = freqDecode(i, 1);
    else
        f1 = freqDecode(i, 1);
        f2 = freqDecode(i, 2);
    end
    output(1, i) = getDigit(f1, f2);
end

output

% length(f)
% length(Y_mag)
% length(Y_phase)

% Y_filtered_mag = BandPassFilter(Y_mag, f, 690, 1500);
% Y_filtered_phase = BandPassFilter(Y_phase, f, 690, 1500);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Transformada de Fourier...

Y_fft = fft(Y);
Y_center = fftshift(Y_fft);

Y_mag = abs(Y_center);
Y_phase = unwrap(angle(Y_center));

tonesArray_fft = zeros(7, Ns_tone + 1);
tonesArray_fft_cent = zeros(7, Ns_tone + 1);
tonesArray_mag = zeros(7, Ns_tone + 1);
tonesArray_phase = zeros(7, Ns_tone + 1);

for i = 1:1:7
    tonesArray_fft(i, :) = fft(tonesArray(i, :));
    tonesArray_fft_cent(i, :) = fftshift(tonesArray_fft(i, :));
    
    tonesArray_mag(i, :) = abs(tonesArray_fft_cent(i, :));
    tonesArray_phase(i, :) = unwrap(angle(tonesArray_fft_cent(i, :)));
end

f = linspace(-Fs/2, Fs/2, Ns_tone + 1);       % Dominio de la frecuencia...
%f = linspace(-Fs/2, Fs/2, length(Y));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot...

% f2 = figure;
% plot(T, Y, 'r');
% grid on;


%subplot(2, 1, 1);
% plot(T, Y, 'r');
% grid on;
% xlabel('Tiempo (s)'), ylabel('Amplitud');

% subplot(2, 1, 2);
% plot(f, Y_mag, 'r');
% grid on;
% xlabel('Frecuencia (Hz)'), ylabel('Amplitud');

% subplot(3, 1, 3);
% plot(f, tonesArray_mag(7, :), 'r');
% grid on;
% xlabel('Tiempo (s)'), ylabel('Amplitud');


% subplot(3, 1, 1);
% plot(T, tonesArray_mag(1, :), 'k');
% grid on;
% xlabel('Tiempo (s)'), ylabel('Amplitud');
% 
% subplot(3, 1, 2);
% plot(f, Y_mag, 'r');
% grid on;
% xlabel('Frecuencia (Hz)'), ylabel('Magnitud (dB)');
% 
% subplot(3, 1, 3);
% plot(f, Y_phase, 'b');
% grid on;
% xlabel('Frecuencia (Hz)'), ylabel('Fase (rad)');








