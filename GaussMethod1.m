% Load the casefile
mpc = group_10_casefile();

% Compute Ybus and Sbus (MATPOWER uses makeYbus; Sbus can be computed with makeSbus)
[Ybus, ~, ~] = makeYbus(mpc);
Sbus = makeSbus(mpc);

% Define initial voltages (usually a flat start)
V0 = ones(size(mpc.bus,1),1);
% For generator buses, use the specified voltage magnitudes:
ref = find(mpc.bus(:,2) == 3);   % Slack bus index
pv  = find(mpc.bus(:,2) == 2);    % PV buses
pq  = find(mpc.bus(:,2) == 1);    % PQ buses

% Get MATPOWER options (this supplies tolerances and iteration limits)
mpopt = mpoption('pf.tol', 1e-6, 'pf.gs.max_it', 100);

% Run the Gauss-Seidel power flow
[V, converged, iterations] = gausspf(Ybus, Sbus, V0, ref, pv, pq, mpopt);

% Display results
if converged
    fprintf('Gauss-Seidel converged in %d iterations.\n', iterations);
    disp(V);
else
    fprintf('Gauss-Seidel did not converge within %d iterations.\n', iterations);
end
