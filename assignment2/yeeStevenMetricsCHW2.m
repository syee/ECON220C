%%%%%%%%%%%%%%%%%%%%%
%%% Steven Yee    %%%
%%% Homework 2 Q3 %%%
%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
N = 100;
T = 6;
nreplic = 1000;
rho0 = 0.5;
NT=N*T;
 
% keep the bias of each estimator
bias_fe=zeros(11,1);
bias_fd=zeros(11,1);
bias_ah2=zeros(11,1);  
bias_pols=zeros(11,1);  

% keep the se of each estimator
se_fe = zeros(11,1);
se_fd = zeros(11,1);
se_ah2 = zeros(11,1);
se_pols = zeros(11,1);

% keep the rmse of each estimator
rmse_fe = zeros(11,1);
rmse_fd = zeros(11,1);
rmse_ah2 = zeros(11,1);
rmse_pols = zeros(11,1);

rho = (0:0.1:1)'; %the values of rho considered

for irho = 1:1:11;  % loop over each value of rho's

  a = [1 -rho(irho)];
  b = 1;  % configure a and b to speed up the data generating

  rho_fe = zeros(nreplic,1);  % keep the fixed effects estimator
  rho_fd = zeros(nreplic,1);
  rho_ah2 = zeros(nreplic,1);
  rho_pols = zeros(nreplic,1);
  
  t_fe = zeros(nreplic,1); % keep the t statistic based on the fe estimator
  t_fd = zeros(nreplic,1);
  t_ah2 = zeros(nreplic,1);
  t_pols = zeros(nreplic,1);
  
  randn('state',pi);
% initialize the random number generator

   for replic = 1:1:nreplic; 
    
		alpha = randn(1,N);  
		e = randn(1,N);
		y0 = rho0*alpha+e; 
		
		temp = [y0; randn(T,N)+alpha(ones(T,1),:)];
		data  =  filter(b,a, temp);   
		
		x = data(1:end-1,:);
		y = data(2:end,:);
          
		% data in wide format
      
        xx = x(:); % vectorize x'  
        yy = y(:); % vectorize y'
        
        %%%%%%%%%%%%% pooled OLS estimate  %%%%%%%%%%%%%%%%%
        rho_pols(replic) = xx\yy;
			
		%%%%%%%%%%%%% FE estimator %%%%%%%%%%%%%%%%%
		x_fe = x-repmat(mean(x),T,1);
		y_fe = y-repmat(mean(y),T,1);
		rho_fe(replic) = x_fe(:)\y_fe(:);

		%%%%%%%%%%%%% FD estimator %%%%%%%%%%%%%%%%%
        x_fd = x(2:end,:)-x(1:end-1,:);
		y_fd = y(2:end,:)-y(1:end-1,:);

        rho_fd(replic) = y_fd(:)'/x_fd(:)';
        		
		%%%%%%%%%%%%% AH2 estimator %%%%%%%%%%%%%%%%%
        x_ah2 = x(2:end,:)-x(1:end-1,:);
        x_ah2 = x_ah2(:);
		y_ah2 = y(2:end,:)-y(1:end-1,:);
        y_ah2 = y_ah2(:);       
        z = x(1:end-1,:);
        z = z(:);

        rho_ah2(replic) = sum(z.*y_ah2,'all')/sum(z.*x_ah2,'all');
%  		rho_ah2(replic) = (z'*y_ah2(:))/(z'*x_ah2(:));
      
   end
%%
bias_fe(irho)  =  mean(rho_fe)-rho(irho);
bias_fd(irho)  =  mean(rho_fd)-rho(irho);
bias_ah2(irho)  =  mean(rho_ah2)-rho(irho);
bias_pols(irho)  =  mean(rho_pols)-rho(irho);

se_fe(irho)  =  std(rho_fe);
se_fd(irho)  =  std(rho_fd);
se_ah2(irho)  =  std(rho_ah2);
se_pols(irho)  =  std(rho_pols);

rmse_fe(irho)  =  sqrt(se_fe(irho)^2+bias_fe(irho)^2);
rmse_fd(irho)  =  sqrt(se_fd(irho)^2+bias_fd(irho)^2);
rmse_ah2(irho)  =  sqrt(se_ah2(irho)^2+bias_ah2(irho)^2);
rmse_pols(irho)  =  sqrt(se_pols(irho)^2+bias_pols(irho)^2);
	
	if rho(irho) == 0.7;
		figure(1);
        histfit(rho_fe);
		title({'Histogram of the \rho_{FE} estimator'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
        saveas(gcf,'metricsCPS2graphs1.png');
        %hold off;
        
        figure(2);
        histfit(rho_fd);
		title({'Histogram of the \rho_{FD} estimator'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
        saveas(gcf,'metricsCPS2graphs2.png');
        %hold off;
        
        figure(3);
        histfit(rho_ah2);
		title({'Histogram of the \rho_{ah2} estimator'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
        saveas(gcf,'metricsCPS2graphs3.png');
        %hold off;
        
        figure(4);
        histfit(rho_pols);
		title({'Histogram of the \rho_{pols} estimator'; ['\rho = ' num2str(0.7) ', N = ' num2str(N) ', T = ' num2str(T)]});
        orient landscape;
        print('-depsc2', ['histogram' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
        saveas(gcf,'metricsCPS2graphs4.png');
        %hold off;
    end;

end;

figure(100)

H1 = plot(rho, bias_fe, 'k+:',...
     rho, bias_fd,  'bo-',...
     rho, bias_ah2,  'rs-.',...
     rho, bias_pols, 'go-');
H2= legend('fe','fd','ah2', 'pols');
title(['Bias of Different Estimators,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12);
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
saveas(gcf,'metricsCPS2graphs5.png');

H1 = plot(rho, se_fe, 'k+:',...
     rho, se_fd,  'bo-',...
     rho, se_ah2,  'rs-.',...
     rho, se_pols, 'go-');
H2= legend('fe','fd','ah2', 'pols');
title(['Standard Error of Different Estimators,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12);
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
saveas(gcf,'metricsCPS2graphs6.png');

H1 = plot(rho, rmse_fe, 'k+:',...
     rho, rmse_fd,  'bo-',...
     rho, rmse_ah2,  'rs-.',...
     rho, rmse_pols, 'go-');
H2= legend('fe','fd','ah2', 'pols');
title(['Root Mean Square Error of Different Estimators,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12);
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps']);
saveas(gcf,'metricsCPS2graphs7.png');

H1 = plot(rho, se_fe, 'k+:',...
     rho, se_fd,  'bo-',...
     rho, se_pols, 'go-');
H2= legend('fe','fd','pols');
title(['Standard Error of Different Estimators,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('bias');
set(H1, 'linewidth', 2,'markersize', 4);
set(H2, 'fontsize', 12);
orient landscape;
print('-depsc2', ['bias_se_rmse' '_N_' num2str(N) '_T_' num2str(T) '.eps']);



        %'Need to draw the graphs for other estimators'
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %                                                       %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
      
