% Plot Figures for iTBS
% Load necessary functions
clear
addpath("Function\")

% Load Model Parameters
modelParameter = importdata("opti_GPW_Final.mat");
X_optimum = modelParameter.X_optimum;
synapses = [X_optimum.syn_k, X_optimum.mem_k];
StageI = [X_optimum.Influx_base, X_optimum.rec_k, X_optimum.bcm_k, X_optimum.Ca_decay];
Faci_set = [X_optimum.A_f,X_optimum.B_f,X_optimum.K_f,X_optimum.h_f];
Inhi_set = [X_optimum.A_i,X_optimum.B_iup,X_optimum.B_idown,X_optimum.h_i,X_optimum.K_i];
AfterCurvePara = [X_optimum.K_up, X_optimum.h_up, X_optimum.h_down, X_optimum.A_span,...
    X_optimum.B_span_half,X_optimum.h_span];

% Initial state
initial_syn = 1; mem_syn = 1; Ca0 = 0.1;
tstep = 0.01; iniY = [initial_syn;mem_syn;StageI(1);Ca0;0;0];

%% iTBS Figure: two panels
f = figure('Color',[1 1 1]);
set(gcf,'unit','centimeters','position',[3,2,24,18],...
    'PaperUnits','centimeters','PaperOrientation','landscape',...
    'PaperSize',[24,18]);
% left panel and right panel
rw = 0.6; % [0,1], right panel width
rp = uipanel("Parent",f,'Position',[rw,0,1-rw,1],'BorderType','none','BackgroundColor',[1 1 1]);
lp = uipanel("Parent",f,"Position",[0,0,rw,1],'BorderType','none','BackgroundColor',[1 1 1]);

% China Color Scheme
colorScheme = {'#184293','#508AB2','#A1D0C7','#D5BA82','#D6BBC1','#B36A6F','#C52A20'};

% Left panel: Calcium Influx, Calcium concentration, Substances
% concentration, MEP changes;
% iTBS1800 as the longest duration
iTBS1800.T = 65; iTBS1800.Bt = 10;
iTBS1800.tbi = 0.16; iTBS1800.tgap = 8;
iTBS1800.duration = 190*10;
iTBS1800.tpoints = 0:0.1:8000;
% simulation curve
[simY,~,time_axis] = simFunction_ODE(iTBS1800,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);

%% left panel figure
tp1 = tiledlayout(lp,4,1,'TileSpacing','compact','Padding','compact');
Fontsize = 12;
xlabel(tp1, 'Time in second', 'FontSize', Fontsize, 'Interpreter','latex')

% Calcium Influx Rate
nexttile(tp1,1)
plot(time_axis,simY(3,:),'Color',colorScheme{1},'LineWidth',1)
axis padded
title('\textbf{A.} Calcium Influx Rate','FontSize',Fontsize,'Interpreter','latex')
ylabel('$[Flux] (\mu M/s)$','FontSize',Fontsize,'Interpreter','latex')

% Calcium Concentration Transient
nexttile(tp1,2)
plot(time_axis,simY(4,:),'Color',colorScheme{1},'LineWidth',1)
axis padded
title('\textbf{B.} Calcium Concentration','FontSize',Fontsize,'Interpreter','latex')
ylabel('$[Ca^{2+}]_\textrm{i} (\mu M)$','FontSize',Fontsize,'Interpreter','latex')

% Faci and Inhi Substances
nexttile(tp1,3)
hold on
plot(time_axis,simY(5,:),"Color",colorScheme{1},"LineWidth",1)
plot(time_axis,simY(6,:),"Color",colorScheme{end},"LineWidth",1)
axis padded
legend('$[Faci]$','$[Inhi]$','Interpreter','latex','Location','northeast')
title('\textbf{C.} $[Faci]$ and $[Inhi]$','FontSize',Fontsize,'Interpreter','latex')
ylabel('Concentration','FontSize',Fontsize,'Interpreter','latex')
box on

% MEP Changes Dynamics
nexttile(tp1,4)
hold on
box on
plot(time_axis,simY(1,:),'Color',colorScheme{1},"LineWidth",1)
yline(1,'Color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{D.} MEP Changes','FontSize',Fontsize,'Interpreter','latex')
ylabel('$M_\textrm{net}$','FontSize',Fontsize,'Interpreter','latex')

%% add annotations
% iTBS600
xaxis = 188.5;
yaxis = simY(1,time_axis == xaxis);
text(xaxis,yaxis-0.14,{'$\uparrow$', 'iTBS600'},'Interpreter','latex',...
    'HorizontalAlignment','center')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')
% iTBS1200
xaxis = 384.5;
yaxis = simY(1,time_axis == xaxis);
text(xaxis-10,yaxis-0.01,'iTBS1200 $\rightarrow$','Interpreter','latex',...
    'HorizontalAlignment','right')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')
% iTBS1800
xaxis = 582.9;
yaxis = simY(1,time_axis == xaxis);
text(xaxis-10,yaxis+0.01,'iTBS1800 $\rightarrow$','Interpreter','latex',...
    'HorizontalAlignment','right')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')


%% right panel: aftereffect curves for iTBS600, iTBS1200, and iTBS1800
tp2 = tiledlayout(rp,3,1,'TileSpacing','compact','Padding','compact');
ylabel(tp2,'Normalised MEP','FontSize',Fontsize,'Interpreter','latex')
xlabel(tp2, 'Time in second', 'FontSize', Fontsize, 'Interpreter','latex')

% iTBS600
iTBS600.T = 20; iTBS600.Bt = 10;
iTBS600.tbi = 0.16; iTBS600.tgap = 8;
iTBS600.duration = 190;
iTBS600.tpoints = 0:0.1:8000;
[~,aftereffect_Points,~] = simFunction_ODE(iTBS600,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% iTBS600 aftereffect curve
nexttile(tp2,1)
hold on
box on
plot(iTBS600.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
axis padded
title('\textbf{E.} iTBS600','FontSize',Fontsize,'Interpreter','latex')


% iTBS1200
iTBS1200.T = 40; iTBS1200.Bt = 10;
iTBS1200.tbi = 0.16; iTBS1200.tgap = 8;
iTBS1200.duration = 190*2;
iTBS1200.tpoints = 0:0.1:8000;
[~,aftereffect_Points,~] = simFunction_ODE(iTBS1200,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% iTBS1200 aftereffect curve
nexttile(tp2,2)
hold on
box on
plot(iTBS1200.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
yline(0,'color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{F.} iTBS1200','FontSize',Fontsize,'Interpreter','latex')

% iTBS1800
iTBS1800.T = 60; iTBS1800.Bt = 10;
iTBS1800.tbi = 0.16; iTBS1800.tgap = 8;
iTBS1800.duration = 190*3;
iTBS1800.tpoints = 0:0.1:8000;
[~,aftereffect_Points,~] = simFunction_ODE(iTBS1800,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% iTBS1800 aftereffect curve
nexttile(tp2,3)
hold on
box on
plot(iTBS1800.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
yline(0,'color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{G.} iTBS1800','FontSize',Fontsize,'Interpreter','latex')


%% save figures
print(gcf,'.\Figures\iTBSAftereffectPlots','-dpdf','-vector')






