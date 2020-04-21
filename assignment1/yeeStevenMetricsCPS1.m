%Steven Yee
%Metrics C PS 1
% 4/20/20

clear;
clc;
N = 500;
T = 5;
beta = 1;
nreplic = 1000;

beta_hat = zeros(nreplic,1);

%This is allowing for possible serial correlation
sigma_beta_hat5 =  zeros(nreplic,1);
%This is saying serial correlation is 0
sigma_beta_tilde5 =  zeros(nreplic,1);

for replic = 1:1:nreplic;
    
    %Create matrix of x values distributed standard normal into a T x N
    %matrix
    X = randn (T,N);
    %sigma = repmat(sqrt(T)*mean(x),T,1);
    %variance covariance matrix for u_{it}
    sigma = abs(X);
    E = sigma.*randn(T,N);
    Y = X + E;
    
    %mean averages over each column. This gives us the average value for
    %each individual. 
    
    %This is the demeaning
    Y = Y - repmat(mean(Y),T,1);
    E = E - repmat(mean(E),T,1);
    X = X - repmat(mean(X),T,1);
    
    yy = Y';  % N x T
    xx = X';  % N x T
    ee = E';
    
    xx = xx(:); % vectorize x' 
    yy = yy(:); % vectorize y'
    ee = ee(:);

    %beta_hat is like the beta from the pooled OLS
    beta_hat(replic) = xx\yy;  %fixed effects estimator
    %Equivalent method of calculating beta with pooled OLS
    
    beta_hat_molly = beta + sum(X.^2, 'all').^ -1 .*  sum(X.*E, 'all');

    beta_hat_beta = beta + (sum(sum(X.^2,2),1)).^(-1) * sum(sum(X.*E,2),1);
    
%     beta_hat = xx\yy;
    
    beta_hat_ali = beta + norm(X,'fro')^(-2) *sum(sum((X).*(E)));
    
    ourBeta = beta + (sum(xx.^2).^-1) * sum(xx.*ee);
    
    % This is the demeaned error terms because it comes from the demeaned X
    % and Y
    e_hat = Y - X*beta_hat(replic);  % residual from fixed effect regression
                                     % T x N
    % equation 3
    sigma_beta_hat5(replic) = sqrt((xx'*xx)^(-2)*sum(sum(X.*e_hat).^2));
    % equation 4
    sigma_beta_tilde5(replic) = sqrt((xx'*xx)^(-2)*sum(sum((X.^2).*(e_hat.^2))));
end

%1a
figure(10);
hist(beta_hat);
title('4a T = 5 Distribution of Beta hat');
saveas(gcf,'beta_hat_4a5.pdf');

figure(1);
hist(sigma_beta_hat5);
title('4a T = 5 Distribution of Sigma hat');
saveas(gcf,'sigma_hat_4a5.pdf');

figure(2);
hist(sigma_beta_tilde5);
title('4a T = 5 Distribution of Sigma tilde');
saveas(gcf,'sigma_tilde_4a5.pdf');

%1b
true_sigma = std(beta_hat);

%1c
sigma_hat5 = mean(sigma_beta_hat5);
sigma_tilde5 = mean(sigma_beta_tilde5);
display(['Mean Hat for T=', num2str(T), ': ', num2str(sigma_hat5)]);
display(['Mean Tilde for T=', num2str(T), ': ', num2str(sigma_tilde5)]);
std_sigma_hat5 = std(sigma_beta_hat5);
std_sigma_tilde5 = std(sigma_beta_tilde5);
display(['Standard error Hat for T=', num2str(T), ': ', num2str(std_sigma_hat5)]);
display(['Standard error Tilde for T=', num2str(T), ': ', num2str(std_sigma_tilde5)]);
bias_hat5 = sigma_hat5 - true_sigma;
bias_tilde5 = sigma_tilde5 - true_sigma;
display(['Bias Hat for T=', num2str(T), ': ', num2str(bias_hat5)]);
display(['Bias Tilde for T=', num2str(T), ': ', num2str(bias_tilde5)]);
rmse_sigma_hat5 = sqrt((sigma_hat5-true_sigma)^2 + std_sigma_hat5^2);
rmse_sigma_tilde5 = sqrt((sigma_tilde5-true_sigma)^2 + std_sigma_tilde5^2);
display(['RMSE Hat for T=', num2str(T), ': ', num2str(rmse_sigma_hat5)]);
display(['RMSE Tilde for T=', num2str(T), ': ', num2str(rmse_sigma_tilde5)]);
display('Based on RMSE criterion, sigma_hat is better than sigma_tilde. Which');
display('suggests there is some serial dependence in our data.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 1d T = 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 500;
T = 10;
beta = 1;
nreplic = 1000;

beta_hat = zeros(nreplic,1);

%This is allowing for possible serial correlation
sigma_beta_hat10 =  zeros(nreplic,1);
%This is saying serial correlation is 0
sigma_beta_tilde10 =  zeros(nreplic,1);

for replic = 1:1:nreplic;
    
    %Create matrix of x values distributed standard normal into a T x N
    %matrix
    X = randn (T,N);
    %sigma = repmat(sqrt(T)*mean(x),T,1);
    %variance covariance matrix for u_{it}
    sigma = abs(X);
    E = sigma.*randn(T,N);
    Y = X + E;
    
    %mean averages over each column. This gives us the average value for
    %each individual. 
    
    %This is the demeaning
    Y = Y - repmat(mean(Y),T,1);
    E = E - repmat(mean(E),T,1);
    X = X - repmat(mean(X),T,1);
    
    yy = Y';  % N x T
    xx = X';  % N x T
    ee = E';
    
    xx = xx(:); % vectorize x' 
    yy = yy(:); % vectorize y'
    ee = ee(:);

    %beta_hat is like the beta from the pooled OLS
    beta_hat(replic) = xx\yy;  %fixed effects estimator
    %Equivalent method of calculating beta with pooled OLS
    
    beta_hat_molly = beta + sum(X.^2, 'all').^ -1 .*  sum(X.*E, 'all');

    beta_hat_beta = beta + (sum(sum(X.^2,2),1)).^(-1) * sum(sum(X.*E,2),1);
    
%     beta_hat = xx\yy;
    
    beta_hat_ali = beta + norm(X,'fro')^(-2) *sum(sum((X).*(E)));
    
    ourBeta = beta + (sum(xx.^2).^-1) * sum(xx.*ee);
    
    e_hat = Y - X*beta_hat(replic);  % residual from fixed effect regression
                                     % T x N
    % equation 3
    sigma_beta_hat10(replic) = sqrt((xx'*xx)^(-2)*sum(sum(X.*e_hat).^2));
    % equation 4
    sigma_beta_tilde10(replic) = sqrt((xx'*xx)^(-2)*sum(sum((X.^2).*(e_hat.^2))));
end

%1d_a
figure(10);
hist(beta_hat);
title('4d T = 10 Distribution of Beta hat');
saveas(gcf,'beta_hat_4d10.pdf');

figure(1);
hist(sigma_beta_hat10);
title('4d T = 10 Distribution of Sigma hat');
saveas(gcf,'sigma_hat_4d10.pdf');

figure(2);
hist(sigma_beta_tilde10);
title('4d T = 10 Distribution of Sigma tilde');
saveas(gcf,'sigma_tilde_4d10.pdf');

%1d_b
true_sigma = std(beta_hat);

%1d_c
sigma_hat10 = mean(sigma_beta_hat10);
sigma_tilde10 = mean(sigma_beta_tilde10);
display(['Mean Hat for T=', num2str(T), ': ', num2str(sigma_hat10)]);
display(['Mean Tilde for T=', num2str(T), ': ', num2str(sigma_tilde10)]);
std_sigma_hat10 = std(sigma_beta_hat10);
std_sigma_tilde10 = std(sigma_beta_tilde10);
display(['Standard error Hat for T=', num2str(T), ': ', num2str(std_sigma_hat10)]);
display(['Standard error Tilde for T=', num2str(T), ': ', num2str(std_sigma_tilde10)]);
bias_hat10 = sigma_hat10 - true_sigma;
bias_tilde10 = sigma_tilde10 - true_sigma;
display(['Bias Hat for T=', num2str(T), ': ', num2str(bias_hat10)]);
display(['Bias Tilde for T=', num2str(T), ': ', num2str(bias_tilde10)]);
rmse_sigma_hat10 = sqrt((sigma_hat10-true_sigma)^2 + std_sigma_hat10^2);
rmse_sigma_tilde10 = sqrt((sigma_tilde10-true_sigma)^2 + std_sigma_tilde10^2);
display(['RMSE Hat for T=', num2str(T), ': ', num2str(rmse_sigma_hat10)]);
display(['RMSE Tilde for T=', num2str(T), ': ', num2str(rmse_sigma_tilde10)]);
display('Based on RMSE criterion, sigma_hat is better than sigma_tilde. Which');
display('suggests there is some serial dependence in our data.');

%Based on RMSE criterion, sigma_hat is better than sigma_tilde. Which
%suggests there is some serial dependence in our data.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 1d T = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 500;
T = 20;
beta = 1;
nreplic = 1000;

beta_hat = zeros(nreplic,1);

%This is allowing for possible serial correlation
sigma_beta_hat20 =  zeros(nreplic,1);
%This is saying serial correlation is 0
sigma_beta_tilde20 =  zeros(nreplic,1);

for replic = 1:1:nreplic;
    
    %Create matrix of x values distributed standard normal into a T x N
    %matrix
    X = randn (T,N);
    %sigma = repmat(sqrt(T)*mean(x),T,1);
    %variance covariance matrix for u_{it}
    sigma = abs(X);
    E = sigma.*randn(T,N);
    Y = X + E;
    
    %mean averages over each column. This gives us the average value for
    %each individual. 
    
    %This is the demeaning
    Y = Y - repmat(mean(Y),T,1);
    E = E - repmat(mean(E),T,1);
    X = X - repmat(mean(X),T,1);
    
    yy = Y';  % N x T
    xx = X';  % N x T
    ee = E';
    
    xx = xx(:); % vectorize x' 
    yy = yy(:); % vectorize y'
    ee = ee(:);

    %beta_hat is like the beta from the pooled OLS
    beta_hat(replic) = xx\yy;  %fixed effects estimator
    %Equivalent method of calculating beta with pooled OLS
%     
%     beta_hat_molly = beta + sum(X.^2, 'all').^ -1 .*  sum(X.*E, 'all');
% 
%     beta_hat_beta = beta + (sum(sum(X.^2,2),1)).^(-1) * sum(sum(X.*E,2),1);
% 
%     beta_hat_ali = beta + norm(X,'fro')^(-2) *sum(sum((X).*(E)));
%     
%     ourBeta = beta + (sum(xx.^2).^-1) * sum(xx.*ee);
    
    e_hat = Y - X*beta_hat(replic);  % residual from fixed effect regression
                                     % T x N
    % equation 3
    sigma_beta_hat20(replic) = sqrt((xx'*xx)^(-2)*sum(sum(X.*e_hat).^2));
    % equation 4
    sigma_beta_tilde20(replic) = sqrt((xx'*xx)^(-2)*sum(sum((X.^2).*(e_hat.^2))));
end

%1d_a
figure(10);
hist(beta_hat);
title('4d T = 20 Distribution of Beta hat');
saveas(gcf,'beta_hat_4d20.pdf');

figure(1);
hist(sigma_beta_hat20);
title('4d T = 20 Distribution of Sigma hat');
saveas(gcf,'sigma_hat_4d20.pdf');

figure(2);
hist(sigma_beta_tilde20);
title('4d T = 20 Distribution of Sigma tilde');
saveas(gcf,'sigma_tilde_4d20.pdf');

%1d_b
true_sigma = std(beta_hat);

%1d_c
sigma_hat20 = mean(sigma_beta_hat20);
sigma_tilde20 = mean(sigma_beta_tilde20);
display(['Mean Hat for T=', num2str(T), ': ', num2str(sigma_hat20)]);
display(['Mean Tilde for T=', num2str(T), ': ', num2str(sigma_tilde20)]);
std_sigma_hat20 = std(sigma_beta_hat20);
std_sigma_tilde20 = std(sigma_beta_tilde20);
display(['Standard error Hat for T=', num2str(T), ': ', num2str(std_sigma_hat20)]);
display(['Standard error Tilde for T=', num2str(T), ': ', num2str(std_sigma_tilde20)]);
bias_hat20 = sigma_hat20 - true_sigma;
bias_tilde20 = sigma_tilde20 - true_sigma;
display(['Bias Hat for T=', num2str(T), ': ', num2str(bias_hat20)]);
display(['Bias Tilde for T=', num2str(T), ': ', num2str(bias_tilde20)]);
rmse_sigma_hat20 = sqrt((sigma_hat20-true_sigma)^2 + std_sigma_hat20^2);
rmse_sigma_tilde20 = sqrt((sigma_tilde20-true_sigma)^2 + std_sigma_tilde20^2);
display(['RMSE Hat for T=', num2str(T), ': ', num2str(rmse_sigma_hat20)]);
display(['RMSE Tilde for T=', num2str(T), ': ', num2str(rmse_sigma_tilde20)]);
display('Based on RMSE criterion, sigma_hat is better than sigma_tilde. Which');
display('suggests there is some serial dependence in our data.');

%Based on RMSE criterion, sigma_hat is better than sigma_tilde. Which
%suggests there is some serial dependence in our data.