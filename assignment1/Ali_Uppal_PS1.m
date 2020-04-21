% Attempt
clear;
clc;

rng(1234);

N = 500;
T = 5;
n_iter = 1000;
beta = 1;

beta_hat = zeros(n_iter,1);
Y = zeros(3,n_iter);

for i = 1:1:n_iter;
    % create matrix of X values distributed N(0,1) in (NxT) matrix
    X = randn(N,T);
    
    % define the error term with variance of abs(X)^2
    u = abs(X).*(randn(N,T));
        
    % average over time
    X_bar = mean(X,2);
    u_bar = mean(u,2);
    demean_X = X-X_bar;
    demean_u = u-u_bar;
    demean_Xu = demean_X.*demean_u;
        
    % Formula for S_xx as in pset
    S_xx = sum((demean_X).^2,'all');
    beta_hat = beta + S_xx^(-1)*sum(sum(demean_X.*demean_u));
    
    % Formula for sigma tilde
    sigma_tilde = S_xx^(-2)*sum(sum((demean_X.^2).*(demean_u.^2)));

    sigma_hat = S_xx^(-2)*sum(sum(demean_Xu).^2);
    
    Y(1,i) = beta_hat; 
    Y(2,i) = sigma_hat; 
    Y(3,i) = sigma_tilde;
end

% create histograms

% figure(1)
% hist(Y(1,:))
% 
% figure(2)
% hist(Y(2,:))
% 
% figure(3)
% hist(Y(3,:))

%% Other parts of the question
%(b) std sample distribution beta
std_beta = std(Y(1,:));
sigma_hat = Y(2,:); 
sigma_tilde = Y(3,:);

%(c) 
% take expectation
E_hat = mean(sigma_hat);
E_tilde = mean(sigma_tilde);

%
bias_tilde = E_tilde-std_beta; bias_hat = E_hat - std_beta;
std_tilde = std(sigma_tilde);
std_hat = std(sigma_hat);
RMSE_tilde = sqrt((E_tilde-std_beta)^2 +std(sigma_tilde)^2);
RMSE_hat =  sqrt((E_hat-std_beta)^2 +std(sigma_hat)^2);

display(std_beta); 
display(bias_hat);
display(std_hat); 
display(RMSE_hat);
display(bias_tilde);
display(std_tilde);
display(RMSE_tilde);
