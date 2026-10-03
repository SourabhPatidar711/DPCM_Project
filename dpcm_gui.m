function dpcm_gui
% DPCM_GUI - MATLAB GUI Based Differential Pulse Code Modulation
% Run this file by typing: dpcm_gui
%
% The GUI demonstrates:
%   1. Original analog-like sine signal
%   2. Sampling
%   3. Differential encoding
%   4. Uniform quantization
%   5. DPCM decoding / reconstruction
%   6. MSE and SNR calculation

clc;

% -------------------- Default parameters --------------------
defaultFreq = 5;          % Hz
defaultFs   = 100;        % samples/sec
defaultQ    = 16;         % quantization levels
defaultAmp  = 1;
duration    = 1;          % seconds

% -------------------- Main window ---------------------------
fig = uifigure('Name','DPCM - Differential Pulse Code Modulation', ...
    'Position',[80 50 1250 760], ...
    'Color',[0.96 0.97 0.99]);

% Title
uilabel(fig,'Text','DPCM Simulation & Analysis', ...
    'Position',[35 710 700 35], ...
    'FontSize',24,'FontWeight','bold', ...
    'FontColor',[0.05 0.18 0.40]);

uilabel(fig,'Text','Differential Pulse Code Modulation | MATLAB GUI', ...
    'Position',[38 685 600 24], ...
    'FontSize',13,'FontColor',[0.25 0.30 0.38]);

% -------------------- Control panel --------------------------
panel = uipanel(fig,'Title','Simulation Parameters', ...
    'Position',[25 500 300 160], ...
    'FontSize',13,'FontWeight','bold');

uilabel(panel,'Text','Signal Frequency (Hz)', ...
    'Position',[15 105 145 22]);
freqField = uieditfield(panel,'numeric', ...
    'Position',[170 105 100 24], ...
    'Value',defaultFreq,'Limits',[0.1 1000]);

uilabel(panel,'Text','Sampling Frequency (Hz)', ...
    'Position',[15 70 145 22]);
fsField = uieditfield(panel,'numeric', ...
    'Position',[170 70 100 24], ...
    'Value',defaultFs,'Limits',[1 5000]);

uilabel(panel,'Text','Quantization Levels', ...
    'Position',[15 35 145 22]);
qField = uieditfield(panel,'numeric', ...
    'Position',[170 35 100 24], ...
    'Value',defaultQ,'Limits',[2 256],'RoundFractionalValues','on');

% Buttons
runBtn = uibutton(fig,'push','Text','RUN DPCM', ...
    'Position',[35 445 130 38], ...
    'FontSize',13,'FontWeight','bold', ...
    'BackgroundColor',[0.10 0.45 0.80], ...
    'FontColor',[1 1 1], ...
    'ButtonPushedFcn',@runDPCM);

resetBtn = uibutton(fig,'push','Text','RESET', ...
    'Position',[180 445 110 38], ...
    'FontSize',13,'FontWeight','bold', ...
    'ButtonPushedFcn',@resetGUI);

% -------------------- Information panel ----------------------
infoPanel = uipanel(fig,'Title','DPCM Results', ...
    'Position',[25 275 300 150], ...
    'FontSize',13,'FontWeight','bold');

mseLabel = uilabel(infoPanel,'Text','MSE: --', ...
    'Position',[20 95 250 25],'FontSize',12);
snrLabel = uilabel(infoPanel,'Text','SNR: --', ...
    'Position',[20 65 250 25],'FontSize',12);
stepLabel = uilabel(infoPanel,'Text','Quantizer Step: --', ...
    'Position',[20 35 250 25],'FontSize',12);

statusPanel = uipanel(fig,'Title','Status', ...
    'Position',[25 130 300 120], ...
    'FontSize',13,'FontWeight','bold');

statusLabel = uilabel(statusPanel, ...
    'Text','Ready. Enter parameters and click RUN DPCM.', ...
    'Position',[15 25 270 65], ...
    'FontSize',11,'WordWrap','on');

% -------------------- Plot areas -----------------------------
ax1 = uiaxes(fig,'Position',[350 510 410 210]);
title(ax1,'1. Original Signal');
xlabel(ax1,'Time (s)'); ylabel(ax1,'Amplitude');
grid(ax1,'on');

ax2 = uiaxes(fig,'Position',[790 510 410 210]);
title(ax2,'2. Sampled Signal');
xlabel(ax2,'Sample Index'); ylabel(ax2,'Amplitude');
grid(ax2,'on');

ax3 = uiaxes(fig,'Position',[350 275 410 210]);
title(ax3,'3. Difference Signal');
xlabel(ax3,'Sample Index'); ylabel(ax3,'Difference');
grid(ax3,'on');

ax4 = uiaxes(fig,'Position',[790 275 410 210]);
title(ax4,'4. Quantized Difference');
xlabel(ax4,'Sample Index'); ylabel(ax4,'Quantized');
grid(ax4,'on');

ax5 = uiaxes(fig,'Position',[350 40 410 210]);
title(ax5,'5. Reconstructed Signal');
xlabel(ax5,'Sample Index'); ylabel(ax5,'Amplitude');
grid(ax5,'on');

ax6 = uiaxes(fig,'Position',[790 40 410 210]);
title(ax6,'6. Original vs Reconstructed');
xlabel(ax6,'Sample Index'); ylabel(ax6,'Amplitude');
grid(ax6,'on');

% -------------------- Run DPCM -------------------------------
function runDPCM(~,~)
    f = freqField.Value;
    Fs = fsField.Value;
    L = qField.Value;

    if Fs <= 2*f
        uialert(fig, ...
            'Sampling frequency must be greater than 2 × signal frequency (Nyquist criterion).', ...
            'Invalid Sampling Frequency');
        return;
    end

    if L < 2 || L > 256
        uialert(fig,'Quantization levels must be between 2 and 256.','Invalid Input');
        return;
    end

    statusLabel.Text = 'Running DPCM simulation...';
    drawnow;

    % Time vector and original signal
    t = 0:1/(20*Fs):duration;
    x = defaultAmp*sin(2*pi*f*t);

    % Sampling
    ts = 0:1/Fs:duration;
    xs = defaultAmp*sin(2*pi*f*ts);

    % ---------------- DPCM Encoder ----------------
    % Prediction: previous reconstructed/sample value
    prediction = zeros(size(xs));
    prediction(1) = 0;

    d = zeros(size(xs));
    for k = 2:length(xs)
        prediction(k) = xs(k-1);
        d(k) = xs(k) - prediction(k);
    end

    % Quantization range
    dmax = max(abs(d));
    if dmax == 0
        dmax = 1;
    end

    % Uniform quantizer
    step = (2*dmax)/L;
    qd = step * (floor(d/step) + 0.5);

    % Force zero to zero
    qd(abs(d) < step/2) = 0;

    % ---------------- DPCM Decoder ----------------
    xr = zeros(size(xs));
    for k = 2:length(xs)
        xr(k) = xr(k-1) + qd(k);
    end

    % ---------------- Performance ----------------
    err = xs - xr;
    mse = mean(err.^2);

    signalPower = mean(xs.^2);
    if mse > 0
        snrVal = 10*log10(signalPower/mse);
    else
        snrVal = Inf;
    end

    % ---------------- Plotting ----------------
    cla(ax1);
    plot(ax1,t,x,'LineWidth',1.5);
    hold(ax1,'on');
    stem(ax1,ts,xs,'filled','MarkerSize',3);
    hold(ax1,'off');
    title(ax1,'1. Original Signal + Samples');

    cla(ax2);
    stem(ax2,1:length(xs),xs,'filled','MarkerSize',3);
    title(ax2,'2. Sampled Signal');

    cla(ax3);
    stem(ax3,1:length(d),d,'filled','MarkerSize',3);
    title(ax3,'3. Difference Signal');

    cla(ax4);
    stem(ax4,1:length(qd),qd,'filled','MarkerSize',3);
    title(ax4,sprintf('4. Quantized Difference (%d Levels)',L));

    cla(ax5);
    plot(ax5,1:length(xr),xr,'LineWidth',1.5);
    title(ax5,'5. Reconstructed Signal');

    cla(ax6);
    plot(ax6,1:length(xs),xs,'LineWidth',1.4);
    hold(ax6,'on');
    plot(ax6,1:length(xr),xr,'--','LineWidth',1.4);
    hold(ax6,'off');
    legend(ax6,{'Original','Reconstructed'},'Location','best');
    title(ax6,'6. Original vs Reconstructed');

    % Labels
    mseLabel.Text = sprintf('MSE: %.6f',mse);
    if isfinite(snrVal)
        snrLabel.Text = sprintf('SNR: %.3f dB',snrVal);
    else
        snrLabel.Text = 'SNR: Infinite';
    end
    stepLabel.Text = sprintf('Quantizer Step: %.6f',step);

    statusLabel.Text = sprintf( ...
        'DPCM completed successfully.\nSamples: %d\nFrequency: %.2f Hz\nSampling: %.2f Hz\nLevels: %d', ...
        length(xs),f,Fs,L);

    drawnow;
end

% -------------------- Reset ----------------------------------
function resetGUI(~,~)
    freqField.Value = defaultFreq;
    fsField.Value = defaultFs;
    qField.Value = defaultQ;

    cla(ax1); cla(ax2); cla(ax3);
    cla(ax4); cla(ax5); cla(ax6);

    title(ax1,'1. Original Signal');
    title(ax2,'2. Sampled Signal');
    title(ax3,'3. Difference Signal');
    title(ax4,'4. Quantized Difference');
    title(ax5,'5. Reconstructed Signal');
    title(ax6,'6. Original vs Reconstructed');

    mseLabel.Text = 'MSE: --';
    snrLabel.Text = 'SNR: --';
    stepLabel.Text = 'Quantizer Step: --';
    statusLabel.Text = 'Ready. Enter parameters and click RUN DPCM.';
end

% Run once at startup
runDPCM();
end
