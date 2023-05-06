clc;
clear all;
close all;

[y, Fs] = audioread('veta.wav');
win = 1024;

figure;
spectrogram(y, win, [], [], Fs, 'yaxis');

T = 1/Fs;
len = length(y)/Fs;
time = T:T:len;

figure;
plot(time, y)
xlabel('Time [s]')
ylabel('Amplitude [dB]')
title('Time signal waveform')

IMF_count = 12;
iter_count = 12;
stop_count = 6;

u = cell(IMF_count,1);
imf = cell(IMF_count,1);

u{1} = y;

for i = 1:12
    imf{i} = IMF(u{i}, iter_count, stop_count);
    u{i+1} = u{i} - imf{i};
end

figure
hold on
plot(T:T:(length(imf{1})/Fs), imf{1});
plot(T:T:(length(imf{2})/Fs), imf{2});
plot(T:T:(length(imf{4})/Fs), imf{4});
plot(T:T:(length(imf{6})/Fs), imf{6});
plot(T:T:(length(imf{10})/Fs), imf{10});
ylim([-0.8 0.8])
xlabel('Time [s]')
ylabel('Amplitude [dB]')
title('IMF comparison')
legend('1.IMF','2.IMF','4.IMF','6.IMF','10.IMF')

index = 1;

figure
hold on
for i = [1,2,4,6,10]
    y_fft = fft(u{i});
    len = length(y);
    part_2 = abs(y_fft / len);
    part_1 = part_2(1:(len/2+1));
    part_1(2:end-1) = 2*part_1(2:end-1);
    freq = Fs*(0:(len/2))/len;
    plot(freq, part_1);
    index = index+1;
end
legend('1.IMF','2.IMF','4.IMF','6.IMF','10.IMF')
box on
xlim([0 6500])
%ylim([0 0.01])
xlabel('Frequency [Hz]')
ylabel('Magnitude')

iter_count = 1;
IMF_used = 3;
pom = cell(IMF_used);

for i = [10, 30, 50]
    element = cell(IMF_used,1);
    used_IMF = cell(IMF_used, 1);
    element{1} = y;
    for j = 1:IMF_used
        used_IMF{j} = IMF(element{j}, i, stop_count);
        element{j+1} = element{j} - used_IMF{j};
        used_Hilb = hilbert(used_IMF{j});
        pom{iter_count, j} = Fs/ (2*pi)*diff(unwrap(angle(used_Hilb)));
    end
    iter_count = iter_count +1;
end


for i = 1:3
    for j = 1:3
        figure();
        plot(T:T:length(pom{i,j})/Fs,pom{i,j});
        ylabel('Frequency [Hz]')
        xlabel('Time [s]')
        
        if i == 1
            if j == 1
                title('1.IMF - 10 iterations')
            elseif j ==2
                title('1.IMF - 30 iterations')
            else
                title('1.IMF - 50 iterations')
            end
            
         elseif i == 2
            if j == 1
                title('2.IMF - 10 iterations')
            elseif j ==2
                title('2.IMF - 30 iterations')
            else
                title('2.IMF - 50 iterations')
            end
            
        else
            if j == 1
                title('3.IMF - 10 iterations')
            elseif j == 2
                title('3.IMF - 30 iterations')
            else
                title('3.IMF - 50 iterations')
            end
        end
    end
end
        
