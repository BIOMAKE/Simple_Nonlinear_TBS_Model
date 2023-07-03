% Plot Figures for cTBS
% Load necessary functions
clear
addpath("Function\")

% Load model parameters
modelParameter = importdata("opti_GPW_Final.mat");
X_optimum = modelParameter.X_optimum;
synapses = [X_optimum.syn_k, X_optimum.mem_k];
StageI = [X_optimum.Influx_base, X_optimum.rec_k, X_optimum.bcm_k, X_optimum.Ca_decay];
Faci_set = [X_optimum.A_f,X_optimum.B_f,X_optimum.K_f,X_optimum.h_f];
Inhi_set = [X_optimum.A_i,X_optimum.B_iup,X_optimum.B_idown,X_optimum.h_i,X_optimum.K_i];
AfterCurvePara = [X_optimum.K_up, X_optimum.h_up, X_optimum.h_down, X_optimum.A_span,...
    X_optimum.B_span_half,X_optimum.h_span];

% Initial state for the ODE system
initial_syn = 1; mem_syn = 1; Ca0 = 0.1;
tstep = 0.01; iniY = [initial_syn;mem_syn;StageI(1);Ca0;0;0];

%% cTBS Figure: two panels
f = figure('Color',[1 1 1]);
set(gcf,'unit','centimeters','position',[3,2,24,19],...
    'PaperUnits','centimeters','PaperOrientation','landscape',...
    'PaperType','<custom>','PaperSize',[24,19]);

% left panel and right panel
rw = 0.6; % [0,1], right panel width
rp = uipanel("Parent",f,'Position',[rw,0,1-rw,1],'BorderType','none','BackgroundColor',[1 1 1]);
lp = uipanel("Parent",f,"Position",[0,0,rw,1],'BorderType','none','BackgroundColor',[1 1 1]);
% China Color Scheme
colorScheme = {'#184293','#508AB2','#A1D0C7','#D5BA82','#D6BBC1','#B36A6F','#C52A20'};

% Left panel: Calcium Influx, Calcium concentration, Substances
% concentration, MEP changes;
% cTBS1800 as the longest duration
cTBS1800.T = 1; cTBS1800.Bt = 600;
cTBS1800.tbi = 0.16; cTBS1800.tgap = 0;
cTBS1800.duration = 800;
cTBS1800.tpoints = 0:0.1:8000;
% simulation curve
[simY,~,time_axis] = simFunction_ODE(cTBS1800,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);

%% left panel figure
Fontsize = 12;
tp1 = tiledlayout(lp,4,1,'TileSpacing','compact','Padding','Compact');
xlabel(tp1, 'Time in second', 'FontSize', Fontsize, 'Interpreter','latex')

% Calcium Influx Rate
nexttile(tp1,1)
plot(time_axis,simY(3,:),'Color',colorScheme{1},'LineWidth',1)
axis padded
title('\textbf{A.} Calcium Influx Rate','FontSize',Fontsize,'Interpreter','latex')
ylabel('$[Flux] (\mu M/s)$','FontSize',Fontsize,'Interpreter','latex')

% Calcium Concentration Trasient
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
legend('$[Faci]$','$[Inhi]$','Location','southeast','Interpreter','latex')
title('\textbf{C.} $[Faci]$ and $[Inhi]$','FontSize',Fontsize,'Interpreter','latex')
ylabel('Concentration','FontSize',Fontsize,'Interpreter','latex')
box on

% MEP Changes Dynamics
nexttile(tp1,4)
box on
hold on
plot(time_axis,simY(1,:),'Color',colorScheme{1},"LineWidth",1)
yline(1,'Color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{D.} MEP Changes','FontSize',Fontsize,'Interpreter','latex')
ylabel('$M_\textrm{net}$','FontSize',Fontsize,'Interpreter','latex')

%% add annotations
% cTBS300
xaxis = 20;
yaxis = simY(1,time_axis == xaxis);
text(xaxis,yaxis+0.1,{'cTBS300', '$\downarrow$'},'Interpreter','latex',...
    'HorizontalAlignment','center')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')

% cTBS600
xaxis = 40;
yaxis = simY(1,time_axis == xaxis);
text(xaxis+2,yaxis,'$\leftarrow$ cTBS600','Interpreter','latex',...
    'HorizontalAlignment','left')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')

% cTBS1200
xaxis = 80;
yaxis = simY(1,time_axis == xaxis);
text(xaxis-2,yaxis,'cTBS1200 $\rightarrow$','Interpreter','latex',...
    'HorizontalAlignment','right')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')

% cTBS1800
xaxis = 119.84;
yaxis = simY(1,time_axis == xaxis);
text(xaxis+1,yaxis-0.1,{'$\uparrow$', 'cTBS1800'},'Interpreter','latex',...
    'HorizontalAlignment','right')
scatter(xaxis,yaxis,'MarkerFaceColor',colorScheme{1},...
    'MarkerEdgeColor',colorScheme{1},'LineWidth',1,'Marker','*')


%% right panel: aftereffect curves for cTBS300, cTBS600, and cTBS1200
tp2 = tiledlayout(rp,4,1,'TileSpacing','compact','Padding','Compact');
ylabel(tp2,'Normalised MEP','FontSize',Fontsize,'Interpreter','latex')
xlabel(tp2, 'Time in second', 'FontSize', Fontsize, 'Interpreter','latex')

% cTBS300
cTBS300.T = 1; cTBS300.Bt = 100;
cTBS300.tbi = 0.16; cTBS300.tgap = 0;
cTBS300.duration = 20;
cTBS300.tpoints = 0:0.1:2500;
[~,aftereffect_Points,~] = simFunction_ODE(cTBS300,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% cTBS300 aftereffect curve
nexttile(tp2,1)
hold on
box on
plot(cTBS300.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
yline(0,'color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{E.} cTBS300','FontSize',Fontsize,'Interpreter','latex')



% cTBS600
cTBS600.T = 1; cTBS600.Bt = 200;
cTBS600.tbi = 0.16; cTBS600.tgap = 0;
cTBS600.duration = 40;
cTBS600.tpoints = 0:0.1:8000;
[~,aftereffect_Points,~] = simFunction_ODE(cTBS600,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% cTBS600 aftereffect curve
nexttile(tp2,2)
hold on
box on
plot(cTBS600.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
yline(0,'color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{F.} cTBS600','FontSize',Fontsize,'Interpreter','latex')


% cTBS1200
cTBS1200.T = 1; cTBS1200.Bt = 400;
cTBS1200.tbi = 0.16; cTBS1200.tgap = 0;
cTBS1200.duration = 80;
cTBS1200.tpoints = 0:0.1:8000;
[~,aftereffect_Points,~] = simFunction_ODE(cTBS1200,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% cTBS1200 aftereffect curve
nexttile(tp2,3)
hold on
box on
plot(cTBS1200.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
yline(0,'color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{G.} cTBS1200','FontSize',Fontsize,'Interpreter','latex')


% cTBS1800
cTBS1800.T = 1; cTBS1800.Bt = 600;
cTBS1800.tbi = 0.16; cTBS1800.tgap = 0;
cTBS1800.duration = 120;
cTBS1800.tpoints = 0:0.1:8000;
[~,aftereffect_Points,~] = simFunction_ODE(cTBS1800,AfterCurvePara,tstep,iniY,synapses,StageI,Faci_set,Inhi_set);
% cTBS1800 aftereffect curve
nexttile(tp2,4)
hold on
box on
plot(cTBS1800.tpoints,aftereffect_Points,'color',colorScheme{1},'linewidth',1)
yline(0,'color','k','LineWidth',1,'LineStyle','--')
axis padded
title('\textbf{H.} cTBS1800','FontSize',Fontsize,'Interpreter','latex')


%%
print(gcf,'.\Figures\cTBSAftereffectPlots','-dpdf','-vector')







