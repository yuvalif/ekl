function[CHOOSE_WORK_F ,CHOOSE_WORK_P, wage_full, wage_part, capacity]= wage_calc(EXP, prev_state, prev_capacity, year_of_school, HEALTH, w_draws,h_draws, epsilon_f,draw_f, t, HSD, HSG, SC, CG, PC, ability, sex) 
global lambda0_fw; global lambda1_fw; global lambda2_fw; global lambda3_fw; 
global lambda0_pw; global lambda1_pw; global lambda2_pw; global lambda3_pw; 
global lambda0_lw; global lambda1_lw; global lambda2_lw; global lambda3_lw; 
global lambda0_fh; global lambda1_fh; global lambda2_fh; global lambda3_fh; 
global lambda0_ph; global lambda1_ph; global lambda2_ph; global lambda3_ph; 
global lambda0_lh; global lambda1_lh; global lambda2_lh; global lambda3_lh; 
global beta11_w;   global beta12_w;   global beta13_w;   global beta14_w;  global  beta15_w; 
global beta21_w;   global beta22_w;   global beta23_w;   global beta24_w;  global  beta25_w; 
global beta31_w;   global beta32_w;   global beta33_w;   global beta34_w;  global  beta35_w;
global beta11_h;   global beta12_h;   global beta13_h;   global beta14_h;  global  beta15_h; 
global beta21_h;   global beta22_h;   global beta23_h;   global beta24_h;  global  beta25_h; 
global beta31_h;   global beta32_h;   global beta33_h;   global beta34_h;  global  beta35_h;global sigma; 
CHOOSE_WORK_F = 0;
CHOOSE_WORK_P = 0;
wage_full = 0;
wage_part = 0;
capacity = 0;
if (sex == 1)   %women
	if (prev_state==0) %didn't worked in previous period
		% draw job offer 
		prob_full_tmp=lambda0_fw+ lambda1_fw*EXP+lambda2_fw*year_of_school +lambda3_fw*HEALTH;
		prob_part_tmp=lambda0_pw+ lambda1_pw*EXP+lambda2_pw*year_of_school +lambda3_pw*HEALTH;
		prob_full_w = exp(prob_full_tmp) ./ (1+exp(prob_full_tmp));
		prob_part_w = exp(prob_part_tmp) ./ (1+exp(prob_part_tmp));
		if (w_draws(draw_f,t,1) < prob_full_w  )   %w_draws = rand(DRAW_F,T,2); 1 - health,2 -job offer,  
			CHOOSE_WORK_F = 1;
			% draw wage for full time 
			tmp1_w = beta11_w*EXP*HSD + beta21_w*(EXP.^2)*HSD +beta12_w*EXP*HSG + beta22_w*(EXP.^2)*HSG....
                +beta13_w*EXP*SC + beta23_w*(EXP.^2)*SC +beta14_w*EXP*CG + beta24_w*(EXP.^2)*CG +beta15_w*EXP*PC + beta25_w*(EXP.^2)*PC...
                + beta31_w*HSD+ beta32_w*HSG+beta33_w*SC+ beta34_w*CG+ beta35_w*PC+ability;
			tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); %epsilon_f(draw_f, t, state)  
			wage_full = exp(tmp1_w + tmp2_w);
            capacity = 1;
        end
        if (w_draws(draw_f,t,2)< prob_part_w   )
			CHOOSE_WORK_P = 1;
			% draw wage for full time - will be multiply by 0.5 if part time job
            tmp1_w = beta11_w*EXP*HSD + beta21_w*(EXP.^2)*HSD +beta12_w*EXP*HSG + beta22_w*(EXP.^2)*HSG....
                +beta13_w*EXP*SC + beta23_w*(EXP.^2)*SC +beta14_w*EXP*CG + beta24_w*(EXP.^2)*CG +beta15_w*EXP*PC + beta25_w*(EXP.^2)*PC...
                + beta31_w*HSD+ beta32_w*HSG+beta33_w*SC+ beta34_w*CG+ beta35_w*PC+ability;			tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); %epsilon_f(draw_f, t, state)  
			wage_part = 0.5*exp(tmp1_w + tmp2_w);
            capacity = 0.5;
        end  
	else  %work in previous period
		if (prev_capacity == 1)
            prob_not_laid_off_tmp=lambda0_lw+ lambda1_lw*EXP+lambda2_lw*year_of_school +lambda3_lw*HEALTH;
            prob_not_laid_off_w = exp(prob_not_laid_off_tmp) ./ (1+exp(prob_not_laid_off_tmp));
            if (w_draws(draw_f,t,1) < prob_not_laid_off_w  )
                CHOOSE_WORK_F = 1;
                capacity = 1;
                % draw wage for full time - will be multiply by 0.5 if part time job
                tmp1_w = beta11_w*EXP*HSD + beta21_w*(EXP.^2)*HSD +beta12_w*EXP*HSG + beta22_w*(EXP.^2)*HSG....
                +beta13_w*EXP*SC + beta23_w*(EXP.^2)*SC +beta14_w*EXP*CG + beta24_w*(EXP.^2)*CG +beta15_w*EXP*PC + beta25_w*(EXP.^2)*PC...
                + beta31_w*HSD+ beta32_w*HSG+beta33_w*SC+ beta34_w*CG+ beta35_w*PC+ability;			tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); %epsilon_f(draw_f, t, state)  
                wage_full = exp(tmp1_w + tmp2_w);
            else
                CHOOSE_WORK_F = 0;
                wage_full = 0;
                capacity = 0;		
            end
        else % worked in prevous period as part time      
            prob_not_laid_off_tmp=lambda0_lw+ lambda1_lw*EXP+lambda2_lw*year_of_school +lambda3_lw*HEALTH;
            prob_not_laid_off_w = exp(prob_not_laid_off_tmp) ./ (1+exp(prob_not_laid_off_tmp));
            if (w_draws(draw_f,t,2) < prob_not_laid_off_w  )
                CHOOSE_WORK_P = 1;
                capacity = 0.5;
                % draw wage for full time - will be multiply by 0.5 if part time job
                tmp1_w = beta11_w*EXP*HSD + beta21_w*(EXP.^2)*HSD +beta12_w*EXP*HSG + beta22_w*(EXP.^2)*HSG....
                +beta13_w*EXP*SC + beta23_w*(EXP.^2)*SC +beta14_w*EXP*CG + beta24_w*(EXP.^2)*CG +beta15_w*EXP*PC + beta25_w*(EXP.^2)*PC...
                + beta31_w*HSD+ beta32_w*HSG+beta33_w*SC+ beta34_w*CG+ beta35_w*PC+ability;			tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); %epsilon_f(draw_f, t, state)  
                wage_part = 0.5*exp(tmp1_w + tmp2_w);
            else
                CHOOSE_WORK_P = 0;
                wage_part = 0;
                capacity = 0;		
            end
        end % worked in last period - full or part
    end	%work / didn't work at t-1
else    %men
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if (prev_state==0) %didn't worked in previous period
		% draw job offer 
		prob_full_tmp=lambda0_fh+ lambda1_fh*EXP+lambda2_fh*year_of_school +lambda3_fh*HEALTH;
		prob_part_tmp=lambda0_ph+ lambda1_ph*EXP+lambda2_ph*year_of_school +lambda3_ph*HEALTH;
		prob_full_h = exp(prob_full_tmp) ./ (1+exp(prob_full_tmp));
		prob_part_h = exp(prob_part_tmp) ./ (1+exp(prob_part_tmp));
		if (h_draws(draw_f,t,1) < prob_full_h  )   %w_draws = rand(DRAW_F,T,2); 1 - health,2 -job offer,  
			CHOOSE_WORK_F = 1;
			% draw wage for full time - will be multiply by 0.5 if part time job
            tmp1_h = beta11_h*EXP*HSD + beta21_h*(EXP.^2)*HSD +beta12_h*EXP*HSG + beta22_h*(EXP.^2)*HSG....
                +beta13_h*EXP*SC + beta23_h*(EXP.^2)*SC +beta14_h*EXP*CG + beta24_h*(EXP.^2)*CG +beta15_h*EXP*PC + beta25_h*(EXP.^2)*PC...
                + beta31_h*HSD+ beta32_h*HSG+beta33_h*SC+ beta34_h*CG+ beta35_h*PC+ability;  
            tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); %epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
            wage_full = exp(tmp1_h + tmp2_h);
   			capacity = 1;
        end
        if (h_draws(draw_f,t,2)< prob_part_h) 	
			CHOOSE_WORK_P = 1;
			% draw wage for full time - will be multiply by 0.5 if part time job
            tmp1_h = beta11_h*EXP*HSD + beta21_h*(EXP.^2)*HSD +beta12_h*EXP*HSG + beta22_h*(EXP.^2)*HSG....
                +beta13_h*EXP*SC + beta23_h*(EXP.^2)*SC +beta14_h*EXP*CG + beta24_h*(EXP.^2)*CG +beta15_h*EXP*PC + beta25_h*(EXP.^2)*PC...
                + beta31_h*HSD+ beta32_h*HSG+beta33_h*SC+ beta34_h*CG+ beta35_h*PC+ability; 
            tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); %epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
            wage_part = 0.5*exp(tmp1_h + tmp2_h);
			capacity = 0.5;
        end   % no part time job offer
	else  %work in previous period
		if (prev_capacity == 1)
            prob_not_laid_off_tmp=lambda0_lh+ lambda1_lh*EXP+lambda2_lh*year_of_school +lambda3_lh*HEALTH;
            prob_not_laid_off_h = exp(prob_not_laid_off_tmp) ./ (1+exp(prob_not_laid_off_tmp));
            if (h_draws(draw_f,t,1) < prob_not_laid_off_h  )
                CHOOSE_WORK_F = 1;
                capacity = 1;
                % draw wage for full time - will be multiply by 0.5 if part time job
                tmp1_h = beta11_h*EXP*HSD + beta21_h*(EXP.^2)*HSD +beta12_h*EXP*HSG + beta22_h*(EXP.^2)*HSG....
                    +beta13_h*EXP*SC + beta23_h*(EXP.^2)*SC +beta14_h*EXP*CG + beta24_h*(EXP.^2)*CG +beta15_h*EXP*PC + beta25_h*(EXP.^2)*PC...
                    + beta31_h*HSD+ beta32_h*HSG+beta33_h*SC+ beta34_h*CG+ beta35_h*PC+ability;  
                tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); %epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
                wage_full = exp(tmp1_h + tmp2_h);
            else
                CHOOSE_WORK_F = 0;
                wage_full = 0;
                capacity = 0;		
            end
        else % worked in prevous period as part time      
            prob_not_laid_off_tmp=lambda0_lh+ lambda1_lh*EXP+lambda2_lh*year_of_school +lambda3_lh*HEALTH;
            prob_not_laid_off_h = exp(prob_not_laid_off_tmp) ./ (1+exp(prob_not_laid_off_tmp));
            if (h_draws(draw_f,t,21) < prob_not_laid_off_h  )
                CHOOSE_WORK_P = 1;
                capacity = 0.5;
                % draw wage for full time - will be multiply by 0.5 if part time job
                tmp1_h = beta11_h*EXP*HSD + beta21_h*(EXP.^2)*HSD +beta12_h*EXP*HSG + beta22_h*(EXP.^2)*HSG....
                    +beta13_h*EXP*SC + beta23_h*(EXP.^2)*SC +beta14_h*EXP*CG + beta24_h*(EXP.^2)*CG +beta15_h*EXP*PC + beta25_h*(EXP.^2)*PC...
                    + beta31_h*HSD+ beta32_h*HSG+beta33_h*SC+ beta34_h*CG+ beta35_h*PC+ability;  
                tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); %epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
                wage_full = 0.5*exp(tmp1_h + tmp2_h);
            else
                CHOOSE_WORK_P = 0;
                wage_part = 0;
                capacity = 0;		
            end
        end
    end
end