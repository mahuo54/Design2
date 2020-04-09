%% Guitar 1
filename = 'guitar1.mp3';

results = AnalyseAudioFile(filename, 109.375, 0.9920, 1.184);
results = [results; AnalyseAudioFile(filename, 234.375, 0.9920, 1.184)];

results_global = AnalyseAudioFileAcrossAllFrequency(filename, 0.9920, 1.184);

%% Guitar 2
filename = 'guitar2.mp3';
results = [results; AnalyseAudioFile(filename, 281.25, 1.28, 1.376)];
results = [results; AnalyseAudioFile(filename, 421.875, 1.28, 1.376)];

results = [results; AnalyseAudioFile(filename, 203.125, 7.1, 7.25)];
results = [results; AnalyseAudioFile(filename, 234.375, 7.1, 7.25)];

results_global = [results_global; AnalyseAudioFileAcrossAllFrequency(filename, 1.28, 1.376)];
results_global = [results_global; AnalyseAudioFileAcrossAllFrequency(filename, 7.1, 7.25)];

%time = [7.264];
%freq = [195.3125 460.9375];

%time = [7.264]; 7.1
%freq = [203.125 234.375];

%% Guitar 3
filename = 'guitar3.mp3';
results = [results; AnalyseAudioFile(filename, 921.875, 4, 4.15)];
results_global = [results_global; AnalyseAudioFileAcrossAllFrequency(filename, 4, 4.15)];

results = [results; AnalyseAudioFile(filename, 2187.5, 10.752, 11)];
results = [results; AnalyseAudioFile(filename, 625, 10.752, 11)];
results = [results; AnalyseAudioFile(filename, 1671.875, 10.752, 11)];
results_global = [results_global; AnalyseAudioFileAcrossAllFrequency(filename, 10.752, 11)];


results = [results; AnalyseAudioFile(filename, 1671.875, 25.2795, 26.5)];
results = [results; AnalyseAudioFile(filename, 875, 25.3405, 25.6)]; %Hautement non linéaire, prendre bruit global a la place
results_global = [results_global; AnalyseAudioFileAcrossAllFrequency(filename, 25.3405, 25.6)];



% [pks,locs] = FindFrequencyAtPeak(y,Fs, 25.2 ,26.5); %Clairement. On peut voir deux pics ainsi. 
%time = [25.2795 26.1436]
%freq = [140.625 289.0625]

%% Save result data set and analyse it.
k_freq = [];
for i = 1:size(results,1)
   k_freq(i) = log(results{i,6})/(results{i,4})*-1;
end
k_global = [];
for i = 1:size(results_global,1)
   k_global(i) = log(results_global{i,6})/(results_global{i,4})*-1;
end

g1 = repmat({'Analyse fréquentielle'}, length(k_freq),1);
g2 = repmat({'Puissance du signal'}, length(k_global),1);
boxplot([k_freq, k_global],[g1; g2]);
boxplot([k_freq, k_global]*0.00325,[g1; g2]);
ylabel('Coefficient de friction');
mean(k_global*0.00325);
median(k_global*0.00325);

1.96*std(k_global*0.00325)/sqrt(length(k_global));

%% Methods
%We return Matrix of observation (filename, startingTime, Frequency,
%AdjustedTime, idx, P ; Then the important, bit to say if used in
%regression, P ratio, time step.)

function results = AnalyseAudioFile(filename, frequency, timeOfTheSound, timeEnd)
[y, Fs] = audioread(filename);%Audio from Note_20200219_1456_otter.ai
windowSize = 1024;
win = kaiser(windowSize,5);
% spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
t_idx = find(t >= timeOfTheSound, 1, 'first');
t_end_idx = find(t <= timeEnd, 1, 'last');
f_idx = find(f >= frequency, 1, 'first'); 
ratios = P(f_idx,(t_idx+1):(t_end_idx+1))./ P(f_idx,(t_idx:t_end_idx));
results = cell( length(ratios),8);
for i = 1:length(ratios)
    results(i,:) = {filename, timeOfTheSound, frequency, t(2)-t(1), i ,ratios(i), P(f_idx,t_idx+i-1), P(f_idx,t_idx+i)};
end
end

function results = AnalyseAudioFileAcrossAllFrequency(filename, timeOfTheSound, timeEnd) %Copy past code... sad day for me
[y, Fs] = audioread(filename);%Audio from Note_20200219_1456_otter.ai
windowSize = 1024;
win = kaiser(windowSize,5);
% spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
t_idx = find(t >= timeOfTheSound, 1, 'first');
t_end_idx = find(t <= timeEnd, 1, 'last');
P_mean = mean(P);
ratios = P_mean((t_idx+1):(t_end_idx+1))./ P_mean((t_idx:t_end_idx));
results = cell( length(ratios),8);
for i = 1:length(ratios)
    results(i,:) = {filename, timeOfTheSound, -1, t(2)-t(1), i ,ratios(i), P_mean(t_idx+i-1), P_mean(t_idx+i)};
end
end
