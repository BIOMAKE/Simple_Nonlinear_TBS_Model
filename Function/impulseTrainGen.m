function [protocol_train, time_axis] = impulseTrainGen(protocol)
% This function generates impulse train according to the TBS parameters
% Protocol parameters
T = protocol.T; %number of trains
Bt = protocol.Bt; %number of bursts in one train
tbi = protocol.tbi; %the interval between two bursts, unit: second
tgap = protocol.tgap; %the interval between two trains, unit: second
pulse_freq = 50; %Hertz

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Impulse Train %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%One Burst Setting
tstep = 0.01; % unit: second
pulse_time = round(2/pulse_freq + tstep, 2);
pulses = zeros(1,pulse_time/tstep);
pulses(1:1/pulse_freq/tstep:end) = 1;

% One burst gap setting
burst_gap = zeros(1,tbi/tstep-1);
burst = [pulses,burst_gap];

% One Train Setting
train_gap = zeros(1,tgap/tstep);
burst_train = [repmat(burst,1,Bt-1),pulses,train_gap];

% One TBS protocol
protocol_train = [repmat(burst_train,1,T-1),repmat(burst,1,Bt-1),pulses];
time_axis = 0:tstep:length(protocol_train)*tstep - tstep;

end