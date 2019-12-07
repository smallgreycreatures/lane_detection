function [mu,sigma] = kalman_filter_update(C,Q,R,mu_est,sigma_est,z)
%create the updated state and covariance matrices
%{
        C - Conversion for measurments
		Q - Measurement error
		mu_est - State estimate
		sigma_est - Est covariance matrix
		z - Measurements
	output: mu - Updated state
		sigma - Updated cov matrix
	%}
	if size(mu_est) %om mu_est inte finns så måste vi initiera. kan bli fel i matlab.

		%Calculate kalman gain

		K = sigma_est*C'* inv(C*sigma_est*C'+Q);

		mu = mu_est+ K*(z - C*mu_est);

		sigma = (eye(4) - K*C)  * sigma_est;
        
    else
		mu = ([z(1);z(2);0;0]);%#state variable [[c],[theta],[c'],[theta']]
		sigma = R; %#Estimate of initial state covriance matrix
    end
end

