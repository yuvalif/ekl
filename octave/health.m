
function [HEALTH, S_GOOD, S_FAIR, S_POOR]=health(S_GOOD, S_FAIR, S_POOR, w_draws, h_draws,draw_f,t, sex)
global h1; global h2; global h3; global h4; global h5; global h6; 
global GOOD; global FAIR; global POOR; 
%h1 = global_param(1);    %good health to good health
%h2 = global_param(1);    %fair health to good health
%h3 = global_param(1);    %poor health to good health
%h4 = global_param(1);    %good health to poor health
%h5 = global_param(1);    %fair health to poor health
%h6 = global_param(1);    %poor health to poor health
p_good_health_tmp = h1*S_GOOD+h2*S_FAIR+h3*S_POOR;
p_poor_health_tmp = h4*S_GOOD+h5*S_FAIR+h6*S_POOR;
p_good_health = exp(p_good_health_tmp)./(1+exp(p_good_health_tmp)+exp(p_poor_health_tmp));
p_poor_health = exp(p_poor_health_tmp)./(1+exp(p_good_health_tmp)+exp(p_poor_health_tmp));
p_fair_health = 1 - p_good_health - p_poor_health;
if (p_fair_health<0)
    error(0)
end            
if (sex == 1)
    if (w_draws(draw_f,t,1) <= p_good_health)
        HEALTH = GOOD;
        S_GOOD = 1;
        S_FAIR = 0;
        S_POOR = 0;
    elseif 	(w_draws(draw_f,t,1) > p_good_health && w_draws(draw_f,t,1) <= (p_good_health+p_fair_health))
        HEALTH = FAIR;
        S_GOOD = 0;
        S_FAIR = 1;
        S_POOR = 0;
    elseif 	(w_draws(draw_f,t,1) >  (p_good_health+p_fair_health) )
        HEALTH = POOR;
        S_GOOD = 0;
        S_FAIR = 0;
        S_POOR = 1;
    else
        error(0);
    end	
else   % men's health
    if (h_draws(draw_f,t,5) <= p_good_health)
        HEALTH = GOOD;
        S_GOOD = 1;
        S_FAIR = 0;
        S_POOR = 0;
    elseif 	(h_draws(draw_f,t,5) > p_good_health && h_draws(draw_f,t,5) <= (p_good_health+p_fair_health))
        HEALTH = FAIR;
        S_GOOD = 0;
        S_FAIR = 1;
        S_POOR = 0;
    elseif 	(h_draws(draw_f,t,5) >  (p_good_health+p_fair_health) )
        HEALTH = POOR;
        S_GOOD = 0;
        S_FAIR = 0;
        S_POOR = 1;
    else
        error(0);
    end	           
end    