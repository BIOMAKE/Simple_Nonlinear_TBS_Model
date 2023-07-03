% Plot the hill equations for facilitation and inhibition substances
% respectively
clear
addpath("Function\")

% load model parameters
 modelParameter = importdata("opti_GPW_Final.mat");

%%
X_optimum = modelParameter.X_optimum;
BCM = [X_optimum.syn_k, X_optimum.slo_k, X_optimum.mem_k];
StageI = [X_optimum.Influx_base, X_optimum.rec_k, X_optimum.bcm_k, X_optimum.Ca_decay];
Faci_set = [X_optimum.A_f,X_optimum.B_f,X_optimum.K_f,X_optimum.h_f];
Inhi_set = [X_optimum.A_i,X_optimum.B_iup,X_optimum.B_idown,X_optimum.h_i,X_optimum.K_i];
AfterCurvePara = [X_optimum.K_up, X_optimum.h_up, X_optimum.h_down, X_optimum.A_span,...
    X_optimum.B_span_half,X_optimum.h_span];

% hill equation handle
threh1 = @(A,B,h,X) A.*X.^h./(B.^h + X.^h);
threh2 = @(A,X) 1./(1 + exp(-A.*X));

threh3 = @(A,Bup,Bdown,h,X) A .* X.^h./(Bup.^h + X.^h) .* (Bup+Bdown).^h./((Bup+Bdown).^h + X.^h);

%% Figure
f = figure('Color',[1 1 1]);
set(gcf,'unit','centimeters','position',[3,2,10,7],...
    'PaperUnits','centimeters','PaperOrientation','landscape',...
    'PaperSize',[10,7]);
% China Color Scheme
colorScheme = {'#184293','#508AB2','#A1D0C7','#D5BA82','#D6BBC1','#B36A6F','#C52A20'};
%
hold on
box on
axis padded
X = 0:0.0001:0.8;
plot(X,threh1(Faci_set(1),Faci_set(2),Faci_set(4),X),'color',colorScheme{1},'LineWidth',1)
hold on
plot(X,threh3(Inhi_set(1),Inhi_set(2),Inhi_set(3),Inhi_set(4),X),'color',colorScheme{7},'LineWidth',1)
legend('$[Faci]$', '$[Inhi]$','Interpreter','latex','location','best')
xlabel('$[Ca^{2+}]_\textrm{i} (\mu M)$','FontSize',12,'Interpreter','latex')
ylabel('Rate of Production','FontSize',12,'Interpreter','latex')


%%
exportgraphics(f,'.\Figures\substanceRate.pdf');





