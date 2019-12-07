function [mu_est, sigma_est] = kalman_filter_predict(A,B,u,R,mu_1,sigma_1)
%{
 determine state and covariance estimate - kalman predict step
	input:  A - State matrix
		B - Control matrix
		u - Control input
		R - State prediction error
		u_1 - system state at previous time
		sigma_1 - covariance matrix at prev time
	output: mu_est - State estimated
		sigma_est - Est covariance matrix

%}
	mu_est = A*mu_1 + B*u;


	sigma_est = A*sigma_1*A'+R;
	
	
end

