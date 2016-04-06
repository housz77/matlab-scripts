% Model parameters for testExample1.m

classdef Model
    
    properties(Constant)
        % Motion & Measurement 
        A = [1 T 0 0;...
             0 1 0 0;...
             0 0 1 T;...
             0 0 0 1];
        
        Q = 0.1 * diag([0 1 0 1]);
        
        H = [1 0 0 0;...
             0 0 1 0];
        
        R = 0.0001*diag([1 1]);
        
        % Survival & Detection Prob
        Ps = 1;
        Pd = 1;
        % Clutter density (poisson)
        betaFA = 0;
    end
end