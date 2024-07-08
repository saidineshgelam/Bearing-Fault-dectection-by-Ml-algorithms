%Brian O'Malley
%ENME 691 - Industrial AI
% Spring 2024

clc;clear;close;

%% Top Matter
format long; format compact;
set(0,'defaultTextInterpreter','latex'); %trying to set the default

sz = 60; %Marker Size
szz = sz/35;
lw = 1;
ms=8;
fs=25;
txtsz = 30;
txtFactor = 0.8;
ax = [0.9,1.4,0.0,2.0];
loc = 'southwest';
pos = [218,114,1478,796];
% txtsz = 24;
%%
%load in the data
dirTrainH = "F:\NOTES\Classes\Industrial AI\HW2\HW2\Homework 2\Training\Training\Healthy";
dirTrainF = "F:\NOTES\Classes\Industrial AI\HW2\HW2\Homework 2\Training\Training\Faulty";
dirTest = "F:\NOTES\Classes\Industrial AI\HW2\HW2\Homework 2\Testing\Testing";
filesH = dir(dirTrainH +'\*.txt');
filesF = dir(dirTrainF +'\*.txt');
filesT = dir(dirTest +'\*.txt');

shaftspeed = 20;% Hz
Fs = 2560;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 38400;             % Length of signal
time = (0:L-1)*T;        % Time vector
FsRange = Fs/L*(0:L-1);
%set the range of interest (shaft speed is ~20 Hz)
lowerBound = find(FsRange==15);
upperBound = find(FsRange==25);
%%
%transform healthy data

for i=1:length(filesH)
    tempStr = dirTrainH +"\"+filesH(i).name
    trainingDataH{i} =readtable(tempStr);
    t=abs(fft(trainingDataH{i}.Date3_26_2014));
    transFFT_H{i} = t; clear t;

end
%%
%transform faulty data
for i=1:length(filesF)
    tempStr = dirTrainF +"\"+filesF(i).name
    trainingDataF{i} =readtable(tempStr);
    t=abs(fft(trainingDataF{i}.Date3_26_2014));
    transFFT_F{i} = t; clear t;

end
%%
%transform testing data
for i=1:length(filesT)
    tempStr = dirTest +"\"+filesT(i).name
    testData{i} =readtable(tempStr);
    t=abs(fft(testData{i}.Date3_26_2014));
    transFFT_T{i} = t; clear t;

end
%%
%pick out the peak for the healthy data
for i=1:20
    temp = transFFT_H{i}/L*2;
    healthyMag(i) = max(temp(lowerBound:upperBound));
    clear temp;

end

%%
%pick out the peak for the fault data

for i=1:20
    temp = transFFT_F{i}/L*2;
    faultyMag(i) = max(temp(lowerBound:upperBound));
    clear temp;

end


%%
%pick out the peak for the Testing data

for i=1:30
    temp = transFFT_T{i}/L*2;
    testingMag(i) = max(temp(lowerBound:upperBound));
    clear temp;

end

%%
%plots of interest follow, 1 and 2 are the time domain amplitudes of 
%the healthy and faulty data, 3 and 4 are the frequency domain plots
%plot 5 demonstrates the feature extraction
%%
figure(1)
grid on; hold on; box on; axis square;
ax=gca;
ax.FontSize = fs;

xlim([0 15]);
ylim([-0.4 0.4]);
yticks([-0.4 -0.2 0 0.2 0.4]);

temp = table2array(trainingDataH{1});
plot(time,temp,'-b');
xlabel('Time [s]','FontSize',fs);
ylabel('Amplitude [-]','FontSize',fs);
clear temp;
% legend('Healthy','Faulty','Location','Northwest','FontSize',fs);
%%
figure(2)
grid on; hold on; box on; axis square;
ax=gca;
ax.FontSize = fs;

xlim([0 15]);
ylim([-0.4 0.4]);
yticks([-0.4 -0.2 0 0.2 0.4]);

temp = table2array(trainingDataF{1});
plot(time,temp,'-r');
xlabel('Time [s]','FontSize',fs);
ylabel('Amplitude [-]','FontSize',fs);
clear temp;
% legend('Healthy','Faulty','Location','Northwest','FontSize',fs);

%%

figure(3)
grid on; hold on; box on; axis square;
ax=gca;
ax.FontSize = fs;

xlim([0 60]);
ylim([0 0.005]);
yticks([ 0 0.001 0.002 0.003 0.004 0.005]);
temp = transFFT_H{1}/L*2;
plot(FsRange, temp,'-b');
xlabel('Frequency [Hz]','FontSize',fs);
ylabel('Amplitude [-]','FontSize',fs);
clear temp;

%%
figure(4)
grid on; hold on; box on; axis square;
ax=gca;
ax.FontSize = fs;

xlim([0 60]);
ylim([0 0.005]);
yticks([ 0 0.001 0.002 0.003 0.004 0.005]);
temp = transFFT_F{1}/L*2;
plot(FsRange, temp,'-r');
xlabel('Frequency [Hz]','FontSize',fs);
ylabel('Amplitude [-]','FontSize',fs);
clear temp;
% legend('Healthy','Faulty','Location','Northwest','FontSize',fs);
% end
%%
figure(5)
grid on; hold on; box on; axis square;
ax=gca;
ax.FontSize = fs;
yticks([ 0 0.01 0.02 0.03]);

xlim([0 20]);
ylim([0 0.03]);
plot(healthyMag,'-ob');
plot(faultyMag,'-or');
legend('Healthy','Faulty','Location','Northwest','FontSize',fs);
xlabel('# of Samples','FontSize',fs);
ylabel('Amplitude [-]','FontSize',fs);