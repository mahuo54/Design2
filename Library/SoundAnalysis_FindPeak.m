%Find time and frequency of the sound - Results
filename = '.\guitar3.mp3';


%% Code
[y, Fs] = audioread(filename);%Audio from Note_20200219_1456_otter.ai
% sound(y,Fs); %Multiple sound. Let's
% [pks,locs] = GenerateGraphs(y,Fs);
% arrayfun(@(loc) sprintf('PlaySoundAt(y,Fs, %s, 0.2,10)',num2str(loc)), locs, 'UniformOutput', false);

%Checking sound for each peak



%% Guitar 1
% filename = '..\guitar1.mp3';
% time = [0.9920];
% freq = [2171.875 2460.9375];
%Checking sound for each peak
% PlaySoundAt(y,Fs, 0.6,0.3,10); %Bruit
% PlaySoundAt(y,Fs, 0.864,1,10); %Corde
% PlaySoundAt(y,Fs, 3.2,0.5,10); %Bruit

% [pks,locs] = FindFrequencyAtPeak(y,Fs, 0.864,1.5); %132.185 - bruit le reste on utilise


%% Guitar 2
% filename = '..\guitar2.mp3';
% time = [1.28];
% freq = [281.25 421.875];

%time = [7.264];
%freq = [ ]; %freq = [203.125 234.375]; % Made some changes to how I show
%the datas

%They aren't the same freq... I'm not linking this.

% PlaySoundAt(y,Fs, 1.056, 0.2,10) %Talk
% PlaySoundAt(y,Fs, 1.28, 0.3,10) %Corde mais sonne étrange suivi de parler @ t0.3
% PlaySoundAt(y,Fs, 3.712, 0.4,10) %Parler
% PlaySoundAt(y,Fs, 4.096, 0.4,10) % Bruit
% PlaySoundAt(y,Fs, 5.144, 0.8,10) %Bruit
% PlaySoundAt(y,Fs, 5.204, 0.8,10) % Bruit
% PlaySoundAt(y,Fs, 5.664, 0.4,10) % Bruit
% PlaySoundAt(y,Fs, 7.05, 0.2,10) %Enfin! Corde

% [pks,locs] = FindFrequencyAtPeak(y,Fs, 1.28,1.376); %132.185 - bruit le reste on utilise
% [pks,locs] = FindFrequencyAtPeak(y,Fs, 6.8, 7.4); %Semble y avoir du bruit

%% Guitar 3
% filename = '..\guitar3.mp3';

% PlaySoundAt(y,Fs, 3.904, 0.2,10) %Corde
% PlaySoundAt(y,Fs, 10.432, 0.2,10) %Blah blah
% PlaySoundAt(y,Fs, 10.752, 0.2,10) %Corde
% PlaySoundAt(y,Fs, 10.88, 0.4,10) %Corde + blah
% PlaySoundAt(y,Fs, 11.488, 0.2,10) %Blah
% PlaySoundAt(y,Fs, 11.616, 0.2,10) %Blah + légère corde
% PlaySoundAt(y,Fs, 15.456, 0.4,10) %Corde + blah blah + Identify freq first?
% PlaySoundAt(y,Fs, 17.344, 0.2,10) %Nope.
% PlaySoundAt(y,Fs, 17.504, 0.2,10) %Nope, corde mais accrochée
% PlaySoundAt(y,Fs, 20.32, 0.4,10) %Nope.
% PlaySoundAt(y,Fs, 20.736, 0.2,10) %Nope
% PlaySoundAt(y,Fs, 20.896, 0.4,10) %Tu l'en tu l'en tu l'entends tu
% PlaySoundAt(y,Fs, 21.184, 0.2,10) %reste de la phrase
% PlaySoundAt(y,Fs, 21.376, 0.2,10) %convo...
% PlaySoundAt(y,Fs, 22.464, 0.2,10)
% PlaySoundAt(y,Fs, 22.624, 0.2,10)
% PlaySoundAt(y,Fs, 22.816, 0.2,10)
% PlaySoundAt(y,Fs, 23.648, 0.2,10) %...
% PlaySoundAt(y,Fs, 24.608, 0.4,10) % 
% PlaySoundAt(y,Fs, 25.344, 0.4,10) %Corde, sonne fausse...
% PlaySoundAt(y,Fs, 27.328, 0.2,10) %%blah....
% PlaySoundAt(y,Fs, 27.488, 0.2,10)
% PlaySoundAt(y,Fs, 28.64, 0.2,10)
% PlaySoundAt(y,Fs, 28.896, 0.2,10)

% PlaySoundAt(y,Fs, 4, 0.6,10) %Corde
% PlaySoundAt(y,Fs, 10.6, 0.2 ,10) %Corde
% PlaySoundAt(y,Fs, 15.456, 1,10) %Corde + blah blah + Identify freq first?
% PlaySoundAt(y,Fs, 25, 1.8,1) %Corde, sonne fausse...

% [pks,locs] = FindFrequencyAtPeak(y,Fs,3.904 ,4.5); %Étrange au début, possiblement la corde accroche et se stabilise
%freq = [921.875] - correction temps @4

% [pks,locs] = FindFrequencyAtPeak(y,Fs,10.6 ,11.4); %bcp bruit. Semble bon
%freq = [2195.3125 632.8125 156.25]

% [pks,locs] = FindFrequencyAtPeak(y,Fs, 15.3594,16); %ou 
% bruit. Surtout le bruit...
%freq = [132.8125 265.625] %Not sure which freq to take. Discarded

[pks,locs] = FindFrequencyAtPeak(y,Fs, 25.2 ,26.5); %Clairement. On peut voir deux pics ainsi. 
%time = [25.2795 26.1436]
%freq = [140.625 289.0625]

%% Methods
function [pks,locs] = FindFrequencyAtPeak(y,Fs,peakTime, peakTimeEnd)
windowSize = 1024;
win = kaiser(windowSize,5);
% spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');

fig = figure;
idx = find(t >= peakTime,1,'first');% & t<= peakTimeEnd;
idxOnDuration = t >= peakTime & t<= peakTimeEnd;

subplot(3,1,1);
handlePlot1 = plot(f,P(:,idx));
ax1 = handlePlot1.Parent;
[pks,locs] = findpeaks(P(:,idx),f,'MinPeakDistance',50, 'MinPeakHeight',max(P(:,idx))/10);
text(locs+.02,pks,num2str(locs));
xlim([0 3000]);
xlabel('Fréquence (Hz))');
ylabel('PSD');
title('Densité spectrale de puissance à l''instant 25.2s selon la fréquence');

subplot(3,1,2);
P_mean = mean(P(:,idxOnDuration),2);
handlePlot2 = plot(f,P_mean);
ax2 = handlePlot2.Parent;
[pks,locs] = findpeaks(P_mean,f,'MinPeakDistance',50, 'MinPeakHeight',max(P_mean)/10);
text(locs+.02,pks,num2str(locs));
xlim([0 3000]);
xlabel('Fréquence (Hz))');
ylabel('PSD');
title('Densité spectrale de puissance moyenne entre 25.2 et 26.5s selon la fréquence');

subplot(3,1,3);
colorGradient = jet(length(locs));
h = strings;
for i=1:length(locs)
    xline(ax2, locs(i), 'Color', colorGradient(i,:));
    xline(ax1, locs(i), 'Color', colorGradient(i,:));
    plot(t(idxOnDuration),P(f==locs(i),idxOnDuration),'Color',colorGradient(i,:),'DisplayName', num2str(locs(i)));
    h(i) = num2str(locs(i));
    hold on;
end
leg = legend(h);
title('Densité spectrale de fréquence en fonction du temps pour les fréquences maximales');
xlabel('Temps (s))');
ylabel('PSD');
hold off;
dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','datatip',...
    'SnapToDataVertex','off','Enable','on')
set(dcm_obj,'UpdateFcn',@myupdatefcn)

end
function txt = myupdatefcn(~,event_obj)
% Customizes text of data tips

pos = get(event_obj,'Position');
txt = {['Temps : ',num2str(pos(1))],...
	      ['Amplitude : ',num2str(pos(2))], ...
          ['Freq : ', event_obj.Target.DisplayName]};

for l = event_obj.Target.Parent.Children
    set(l,'LineWidth',0.5) ;
end      
set(event_obj.Target,'LineWidth',2) ;      
end

function PlaySoundAt(y,Fs,t0, duration, NRep)
sound(repmat(y((Fs*t0):(Fs*(t0+duration))),NRep,1),Fs);
end

function [pks,locs] = GenerateGraphs(y,Fs)
%sound(y,Fs);
T = linspace(0, length(y)/Fs, length(y));

windowSize = 1024;
win = kaiser(windowSize,5);
subplot(3,1,1)
spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
[s,f,t,P] = spectrogram(y, win,windowSize/2,windowSize*2, Fs,'onesided','yaxis');
ylabel('Fréquence (kHz)');
xlabel('Temps (s)');
title('Spectrogramme du signal');

subplot(3,1,2)
plot(T,y);
ylabel('Signal');
xlabel('Temps (s)');
title('Signal en fonction du temps');

subplot(3,1,3)
plot(t,mean(P))
ylabel('PSD');
xlabel('Temps (s)');
title('Densité spectrale moyenne de puissance du signal en fonction du temps');

[pks,locs] = findpeaks(mean(P),t,'MinPeakDistance',0.1, 'MinPeakHeight',max(mean(P))/5);
text(locs+.02,pks,num2str(locs'))
end

function FakeSound(fs, freq, duration)
    amp=10;
    values=0:1/fs:duration;
    a=amp*sin(2*pi*freq*values);
    sound(a,fs)
end
