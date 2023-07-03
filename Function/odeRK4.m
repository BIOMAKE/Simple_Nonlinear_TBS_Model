function [simY, simT] = odeRK4(funIn,stimuli,tspan,tstep,iniY)
% This function calculates ODE using Runge-Kutta 4th order method
% Input:
% funIn - the ODE function handle @(t,Y,stimuli)funIn;
% stimuli - the external time-varying input, rTMS protocol train
% tspan - the simulation time span;
% tstep - the simulation time step;
% iniY - the initial point;

% Output:
% simY - simulation of the system, a n*length(tspan) matrix, n - the number
% of states;
% simT - simulation time span, the same as tspan;


%% Parameter
dt = tstep;
simT = tspan;
simY = zeros(size(iniY,1), length(tspan)); 
simY(:,1) = iniY;

%Main Function (either Euler or RK45 method)
for i = 1:(length(tspan)-1)
    k1 = funIn(tspan(i), simY(:,i), stimuli(i));
    k2 = funIn(tspan(i)+0.5*dt, simY(:,i)+0.5*dt*k1, stimuli(i));
    k3 = funIn(tspan(i)+0.5*dt, simY(:,i)+0.5*dt*k2, stimuli(i));
    k4 = funIn(tspan(i)+dt, simY(:,i)+dt*k3, stimuli(i));
    simY(:,i+1) = simY(:,i) + 1/6.*(k1 + 2*k2 + 3*k3 + k4).*dt;
    %simY(:,i+1) = simY(:,i) + k1*dt;
end

end






