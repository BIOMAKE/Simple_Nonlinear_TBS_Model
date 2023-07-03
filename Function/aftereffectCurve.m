function curve_Points = aftereffectCurve(protocol,Mnet,AfterCurvePara)
%This function is for Stage III.
%Function inputs:
%protocol - structure type, contains experimental measurements, protocol
%information
%Mnet - the peak amplitude
%AfterCurvePara - [k_up, h_up, h_down, A_span, B_span_half, h_span]

%%%%%%%% Function Parameters %%%%%%%%%
%% Protocol parameters
T = protocol.T; %number of trains
Bt = protocol.Bt; %number of bursts
TBS_duration = protocol.duration; %TBS duration
tpoints = protocol.tpoints; %time points of MEP measurements

%% Stage III parameters
K_up = AfterCurvePara(1); %the half rising time
h_up = AfterCurvePara(2); %power coefficient for rising curve
h_down = AfterCurvePara(3); %power coefficient for decaying curve

% Hill function for aftereffect time span
A_span = AfterCurvePara(4)*1000; %seconds, the maximum time span of aftereffects
B_span_half = AfterCurvePara(5)*1000; %seconds, the time at which time span reaches at half itself
h_span = AfterCurvePara(6); %power coefficient

%% Function
t_span = A_span*(3*Bt*T)^h_span/(B_span_half^h_span + (3*Bt*T)^h_span); %time span

curve_Points = Mnet*(tpoints.^h_up)./(tpoints.^h_up + (K_up*TBS_duration)^h_up).* ...
    (t_span + K_up*TBS_duration)^h_down./(tpoints.^h_down + (t_span + K_up*TBS_duration)^h_down);

end
