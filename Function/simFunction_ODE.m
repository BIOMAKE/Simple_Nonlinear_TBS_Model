function [simY, aftereffect_Points, time_axis] = simFunction_ODE(protocol,AfterCurvePara,tstep,iniY,BCM,StageI,Faci_set,Inhi_set)
%% This function simulate the ODE system
%Function inputs:
% pulseTrain - Input
% BCM - [synap_k, BCM_rate, BCM_p] - X(1:3)
% StageI - [Influx_base, Influx_rec, Influx_bcm, Ca_decay] - X(4:7)
% Faci_set - [A_f, B_f, K_f, h_f] - X(8:11)
% Inhi_set - [A_i, B_i, K_i, h_i] - X(12:15)
% AfterCurvePara:
% PowerCoeff - [k_up, h_up, h_down]
% SpanCoeff - [A_span, B_span_half, h_span]

%%% Protocol Train %%%
[protocol_train, time_axis] = impulseTrainGen(protocol);

%%% Calculate the Mnet %%%
funcIn = @(t,X,stimuli) calciumDynamics(t,X,stimuli,BCM,StageI,Faci_set,Inhi_set);
simY = odeRK4(funcIn,protocol_train,time_axis,tstep,iniY);
Mnet = (simY(1,end) - 1);

%%% Calculate the aftereffects %%%
aftereffect_Points = aftereffectCurve(protocol,Mnet,AfterCurvePara);

end