[y, Fs] = audioread('guitar1.mp3');%Audio from Note_20200219_1456_otter.ai
% sound(y,Fs);
t = linspace(0, length(y)/Fs, length(y));

windowSize = 1024;
win = kaiser(windowSize,5);
spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');

spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
view(-45,65)
xlim([0.9 2.5])
ylim([0.2 2])


%Peaks of sound by second
plot(t,mean(P))
[pks,locs] = findpeaks(mean(P),t,'MinPeakDistance',0.1, 'MinPeakHeight',max(mean(P))/5);
text(locs+.02,pks,num2str((1:numel(pks))'))

%Peaks of sound by frequency around one of the peak before
plot(f,mean(P,2));
[pks,locs] = findpeaks(mean(P,2),f,'MinPeakDistance',0.1, 'MinPeakHeight',max(mean(P,2))/5);
text(locs+.02,pks,num2str((1:numel(pks))'));
figure();
% I might want to check the distribution for each of those peaks?
find(t == 1.0560)
plot(f,P(:,33));
[pks,locs] = findpeaks(P(:,33),f,'MinPeakDistance',20, 'MinPeakHeight',max(P(:,33))/5);
text(locs+.02,pks,num2str((1:numel(pks))'));

find(t == 1.0560)

plot(f,P(:,33));
[pks,locs] = findpeaks(P(:,33),f,'MinPeakDistance',20, 'MinPeakHeight',max(P(:,33))/5);
text(locs+.02,pks,num2str((1:numel(pks))'));

% colorGradient = parula(length(locs));
% i = 1;
% for idx = locs'
%     p2 = P(f == idx,t > 0.8 & t < 2.5);
%     plot(t(t > 0.8 & t < 2.5),p2 ,'-x','Color',colorGradient(i,:))
% %     [pks,locs] = findpeaks(p2,t(t > 0.8 & t < 2.5),'MinPeakDistance',20, 'MinPeakHeight',max(p2)/5);
% %     text(locs+.02,pks,num2str((1:numel(pks))'));
%     hold on;
%     i = i+1;
% end
% hold off;

% figure()
% plot(f,mean(P(:,t > 1 & t < 2),2));
% [pks,locs] = findpeaks(P(:,33),f,'MinPeakDistance',20, 'MinPeakHeight',max(P(:,33))/5);
% text(locs+.02,pks,num2str((1:numel(pks))'));


%Fourier transform - For all time - Not really useful
[PSD,f] = FT_FromVector(y,t);
plot(f, PSD);
xlim([20 300]);
[pks,locs] = findpeaks(PSD,f,'MinPeakDistance',5, 'MinPeakHeight',max(PSD)/2);
text(locs+.02,pks,num2str((1:numel(pks))'))

f_peak = locs(pks == max(pks)); %Près de la tension que nous avions initialement...

for windowSize = [64 128 256 512 1024 2048]
    %     windowSize = 256;
    win = kaiser(windowSize,5);
    [s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
    disp([f(3)-f(2) t(3)-t(2) max(f) min(f)]);    
end

windowSize = 1024;
win = kaiser(windowSize,5);
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');

%Now we plot across time the freq around 110±10
idx_vector = find(f>(f_peak-10) & f<(f_peak+10)); %Si tu hais Matlab, tape des mains!
colorGradient = parula(length(idx_vector));

i=1; 
for idx = idx_vector'
    plot(t,P(idx,:),'-x','Color',colorGradient(i,:))
    i = i+1;
    hold on;
end
plot(t,max(P),'-x','Color','red')
hold off;


1/(t(2)-t(1));
sound(P(29,:),));

disp([f(3)-f(2) t(3)-t(2) max(f) min(f)]);    
f(3)-f(2)

[s,f,t] =  spectrogram(y, kaiser(256,5),[],[], Fs,'onesided','yaxis');

plot(t, s(3,:));




%% Methods
%We return Matrix of observation (filename, startingTime, Frequency,
%AdjustedTime, idx, P ; Then the important, bit to say if used in
%regression, P ratio, time step.)

function results = AnalyseAudioFile(filename, timeOfTheSound, frequency, nb_dt)
filename = 'guitar1.mp3';
timesOfTheSound = 0.9920;
frequency =    2.4609e+03;
nb_dt = 5;

[y, Fs] = audioread(filename);%Audio from Note_20200219_1456_otter.ai
windowSize = 1024;
win = kaiser(windowSize,5);
% spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
t_idx = find(t==timesOfTheSound);
f_idx = find(f == frequency);
ratios = P(f_idx,(t_idx+1):(t_idx+1+nb_dt))./ P(f_idx,(t_idx:t_idx + nb_dt));

for i = 1:length(ratios)
    results(i,:) = [filename timeOfTheSound frequency t(2)-t(1) i ratio P(f_idx:t_idx+i-1) P(f_idx:t_idx+i)];
end
% plot(t,mean(P))
% [pks,locs] = findpeaks(mean(P),t,'MinPeakDistance',0.1, 'MinPeakHeight',max(mean(P))/5);
% text(locs+.02,pks,num2str((1:numel(pks))'))
% h = strings;
% i = 1;
% for time = locs
%    plot(f, P(:, t == time)/ max(P(:, t == time))) ;
%    hold on;
%    h(i) = num2str(time);
%    i = i+1;
% end
% leg = legend(h);
% hold off;


%I want to repeat a segment of x sec
% startTime = 3.2960;
% interval = 0.25;
% TotalTime = 3;
% idxs = [startTime startTime+interval]*Fs;
% data = y(idxs(1):(idxs(2)-1));
% repeatedSound = repmat(data,TotalTime/interval,1);

end

