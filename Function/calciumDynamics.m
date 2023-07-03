function dXdt = calciumDynamics(t, X, stimuli, synpases, StageI, Faci_set, Inhi_set)
% This function is an ODE system with impulse train input.
%% Input Parameters
X1 = X(1); % MEP learning
X2 = X(2); % short memory of MEP for metaplasticity
X3 = X(3); % Calcium influx
X4 = X(4); % Calcium concentration
X5 = X(5); % Faci substance
X6 = X(6); % Inhi substance

%% Synaptic generation Parameters
syn_k = synpases(1);
mem_k = synpases(2);

%% Stage I parameters
Influx_base = StageI(1);
rec_k = StageI(2);
bcm_k = StageI(3);
Ca_decay = StageI(4);

%% Stage II parameters
% Hill function: calcium-dependent sensitivity constant for facilitation
A_f = Faci_set(1); % calcium sensitivity 
B_f = Faci_set(2); % the half concentration
K_f = Faci_set(3); % decay rate of facilitation substances
h_f = Faci_set(4); % power coefficient

% Hill function: calcium-dependent sensitivity constant for inhibition
A_i = Inhi_set(1); % calcium sensitivity
B_iup = Inhi_set(2); % the half concentration at up stage
B_idown = Inhi_set(3); % the half concentration at down stage
h_i = Inhi_set(4); % power coefficient
K_i = Inhi_set(5); % decay rate of inhibition substances


%% Stage I: State space function
% Initial value of synpatic
% Learning MEP changes
dX1dt = syn_k *( X5 * (2-X1) - X6 * X1);

% Short-time memory (BCM: sliding threshold)
dX2dt = mem_k * (X1^2 - X2);

% Calcium influx rate dynamics
dX3dt = rec_k * (Influx_base - X3) + bcm_k * X3/Influx_base * (X1 - X2);

% Calcium concentration dynamics
Ca0 = 0.1; % the resting calcium concentration, um
dX4dt = Ca_decay*(Ca0 - X4) + X3*stimuli;

%% Stage II: Faci and Inhi substance
% Faci
dX5dt = -K_f * X5 + A_f * X4^h_f/(B_f^h_f + X4^h_f);
% Inhi
dX6dt = -K_i * X6 + A_i * X4^h_i/(B_iup^h_i+X4^h_i) * ...
    (B_iup + B_idown)^h_i/((B_iup + B_idown)^h_i + X4^h_i);


%% Output
dXdt = [dX1dt;dX2dt;dX3dt;dX4dt;dX5dt;dX6dt];
end