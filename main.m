function main()
% Execute UKF From example data generated by mat_disperse_v2

%% INITIALIZE PATH
initialize_path();

%% PARAMETERS TO BE IDENTIFIED AND PROCESS NOISE COVARIANCE (Q)
% thk = [5.0 10.0 10.0]';
% dns = [1.7 1.8 1.8 1.8]';
% vs = [200 300 400 500]';
% vp = [400 600 800 1000]';
params = {'thk1', 'thk2', 'thk3', 'dns1', 'dns2', 'dns3', 'dns4', 'vs1', 'vs2', 'vs3', 'vs4', 'vp1', 'vp2', 'vp3', 'vp4'}; % Material parameters to be estimated (nx1)
exact_p = [5.0, 10.0, 10.0, 1.7, 1.8, 1.8, 1.8, 200, 300, 400, 500,400, 600, 800, 1000]; % Exact parameters (nx1)
cov_q = [1e-6 * ones(1, length(params))]; % Normalized coefficient of variation of process noise (N_q x n)

%% INITIALIZATION OF THE FILTER
x_ini=1.4*ones(length(params),1)'.*exact_p;                  % Initial state (N_x x n) (e.g. [0.9*60,0.9*29000,0.9*0.01,0.9*18; 0.8*60,0.8*29000,0.9*0.01,0.8*18]
cov=0.1*ones(1,length(params));              	% Coefficient of variation (N_x x n) (e.g. [0.3,0.3,0.3,0.3; 0.15,0.15,0.15,0.15]; 
x_ini=bsxfun(@rdivide,x_ini,exact_p);     % Normalize the initial state


% Frecuency set
freq = linspace(5, 150, 20)';
nfreq = length(freq);

% New dispersion curve
[vr, ~, ~, ~, ~, ~] = mat_disperse(thk, dns, vp, vs, freq);

% Added some noise to data
sigma = 0.02 + zeros(nfreq, 1);
err = sigma .* randn(nfreq, 1);
vr_exp = vr + err;

% Invertion parameters
maxiter = 10;
mu = 10;
tol_vs = 0.01;

% New guess (initial solution) is defined to inverse
lng = length(dns);
thk1 = thk;
dns1 = ones(lng, 1) .* mean(dns);
vs1 = ones(lng, 1) .* mean(vs);
vp1 = ones(lng, 1) .* mean(vp);

% Inversion
[niter, vr_iter, vp_iter, vs_iter, dns_iter] = mat_inverse(freq, vr_exp, sigma, thk1, vp1, vs1, dns1, maxiter, mu, tol_vs);


end