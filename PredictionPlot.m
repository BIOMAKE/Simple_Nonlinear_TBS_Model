%% This script plots the prediction for both iTBS and cTBS
clear
addpath("Function\")

%
modelParameter = importdata("opti_GPW_Final.mat");

% Model parameters
X_optimum = modelParameter.X_optimum;
BCM = [X_optimum.syn_k, X_optimum.slo_k, X_optimum.mem_k];
StageI = [X_optimum.Influx_base, X_optimum.rec_k, X_optimum.bcm_k, X_optimum.Ca_decay];
Faci_set = [X_optimum.A_f,X_optimum.B_f,X_optimum.K_f,X_optimum.h_f];
Inhi_set = [X_optimum.A_i,X_optimum.B_iup,X_optimum.B_idown,X_optimum.h_i,X_optimum.K_i];
AfterCurvePara = [X_optimum.K_up, X_optimum.h_up, X_optimum.h_down, X_optimum.A_span,...
    X_optimum.B_span_half,X_optimum.h_span];

% Initial state
initial_syn = 1; mem_syn = 1; Ca0 = 0.08; % um
tstep = 0.01; iniY = [initial_syn;mem_syn;StageI(1);Ca0;0;0];


%% Figure
f = figure('Color',[1 1 1]);
set(gcf,'unit','centimeters','position',[3,2,20,10],...
    'PaperUnits','centimeters','PaperOrientation','landscape',...
    'PaperSize',[20,10]);

% China Color Scheme
colorScheme = {'#184293','#508AB2','#A1D0C7','#D5BA82','#D6BBC1','#B36A6F','#C52A20'};
Fontsize = 12;

%% iTBS
iTBS1800.T = 165; iTBS1800.Bt = 10;
iTBS1800.tbi = 0.16; iTBS1800.tgap = 8;
iTBS1800.duration = 190*10;
iTBS1800.tpoints = 0:0.1:8000;
% simulation curve
[simY,~,time_axis] = simFunction_ODE(iTBS1800,AfterCurvePara,tstep,iniY,BCM,StageI,Faci_set,Inhi_set);
% MEP Changes
hold on
box on
plot(time_axis,simY(1,:),'Color',colorScheme{1},"LineWidth",1,'LineStyle','-')

%% cTBS
cTBS1800.T = 1; cTBS1800.Bt = 8000;
cTBS1800.tbi = 0.16; cTBS1800.tgap = 0;
cTBS1800.duration = 800;
cTBS1800.tpoints = 0:0.1:8000;
% simulation curve
[simY,~,time_axis] = simFunction_ODE(cTBS1800,AfterCurvePara,tstep,iniY,BCM,StageI,Faci_set,Inhi_set);
% MEP Changes
plot(time_axis,simY(1,:),'Color',colorScheme{end},"LineWidth",1)

%%
yline(1,'Color','k','LineWidth',1,'LineStyle','--')
axis padded
title('TBS: MEP Changes','FontSize',Fontsize,'Interpreter','latex')
ylabel('$M_\textrm{net}$','FontSize',Fontsize,'Interpreter','latex')
xlabel('Time in second','FontSize',Fontsize,'Interpreter','latex')
legend('iTBS','cTBS','','Interpreter','latex')


%%
exportgraphics(f,'.\Figures\PredictionPlots.pdf');




