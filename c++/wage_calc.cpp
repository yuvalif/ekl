#include <math.h>
#include "wage_calc.h"
#include "random_values.h"
#include "global_params.h"

wage_calc_result_t wage_calc(int EXP, int prev_state, int prev_capacity, int year_of_school, int HEALTH, 
        float draw_f, int t, int HSD, int HSG, int SC, int CG, int PC, int ability, int sex)
{
    
    wage_calc_result_t result;
    result.CHOOSE_WORK_F = 0;
    result.CHOOSE_WORK_P = 0;
    result.wage_full = 0;
    result.wage_part = 0;
    result.capacity = 0;

    if (sex == 1)   //women
    {
        if (prev_state == 0) //didn't worked in previous period
        {
            // draw job offer 
            float prob_full_tmp = lambda0_fw + lambda1_fw*EXP + lambda2_fw*year_of_school + lambda3_fw*HEALTH;
            float prob_part_tmp = lambda0_pw + lambda1_pw*EXP + lambda2_pw*year_of_school +lambda3_pw*HEALTH;
            float prob_full_w = exp(prob_full_tmp)/(1+exp(prob_full_tmp));
            float prob_part_w = exp(prob_part_tmp)/(1+exp(prob_part_tmp));
            if (w_draws(draw_f,t,1) < prob_full_w)   //w_draws = rand(DRAW_F,T,2); 1 - health,2 -job offer,  
            {
                result.CHOOSE_WORK_F = 1;
                // draw wage for full time 
                float tmp1_w = beta11_w*EXP*HSD + beta21_w*pow(EXP,2)*HSD + beta12_w*EXP*HSG + beta22_w*pow(EXP,2)*HSG 
                    + beta13_w*EXP*SC + beta23_w*pow(EXP,2)*SC + beta14_w*EXP*CG + beta24_w*pow(EXP,2)*CG +beta15_w*EXP*PC + beta25_w*pow(EXP,2)*PC
                    + beta31_w*HSD + beta32_w*HSG + beta33_w*SC + beta34_w*CG + beta35_w*PC + ability;
                float tmp2_w = (epsilon_f(draw_f,t,1)*sigma(5,5)); //epsilon_f(draw_f, t, state)
                result.wage_full = exp(tmp1_w + tmp2_w);
                result.capacity = 1;
            }
            if (w_draws(draw_f,t,2)< prob_part_w)
            {
                result.CHOOSE_WORK_P = 1;
                // draw wage for full time - will be multiply by 0.5 if part time job
                float tmp1_w = beta11_w*EXP*HSD + beta21_w*pow(EXP,2)*HSD +beta12_w*EXP*HSG + beta22_w*pow(EXP,2)*HSG
                    + beta13_w*EXP*SC + beta23_w*pow(EXP,2)*SC + beta14_w*EXP*CG + beta24_w*pow(EXP,2)*CG + beta15_w*EXP*PC + beta25_w*pow(EXP,2)*PC
                    + beta31_w*HSD + beta32_w*HSG + beta33_w*SC + beta34_w*CG + beta35_w*PC + ability;			
                float tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); //epsilon_f(draw_f, t, state)  
                result.wage_part = 0.5*exp(tmp1_w + tmp2_w);
                result.capacity = 0.5;
            }  
        }
        else  //work in previous period
        {
            if (prev_capacity == 1)
            {
                float prob_not_laid_off_tmp = lambda0_lw + lambda1_lw*EXP + lambda2_lw*year_of_school + lambda3_lw*HEALTH;
                float prob_not_laid_off_w = exp(prob_not_laid_off_tmp)/(1+exp(prob_not_laid_off_tmp));
                if (w_draws(draw_f,t,1) < prob_not_laid_off_w)
                {
                    result.CHOOSE_WORK_F = 1;
                    result.capacity = 1;
                    // draw wage for full time - will be multiply by 0.5 if part time job
                    float tmp1_w = beta11_w*EXP*HSD + beta21_w*pow(EXP,2)*HSD + beta12_w*EXP*HSG + beta22_w*pow(EXP,2)*HSG
                        + beta13_w*EXP*SC + beta23_w*pow(EXP,2)*SC + beta14_w*EXP*CG + beta24_w*pow(EXP,2)*CG + beta15_w*EXP*PC + beta25_w*pow(EXP,2)*PC
                        + beta31_w*HSD + beta32_w*HSG + beta33_w*SC + beta34_w*CG + beta35_w*PC+ability;			
                    float tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); //epsilon_f(draw_f, t, state)  
                    result.wage_full = exp(tmp1_w + tmp2_w);
                }
                else
                {
                    result.CHOOSE_WORK_F = 0;
                    result.wage_full = 0;
                    result.capacity = 0;		
                }
            }
            else // worked in prevous period as part time      
            {
                float prob_not_laid_off_tmp =lambda0_lw + lambda1_lw*EXP + lambda2_lw*year_of_school + lambda3_lw*HEALTH;
                float prob_not_laid_off_w = exp(prob_not_laid_off_tmp)/(1+exp(prob_not_laid_off_tmp));
                if (w_draws(draw_f,t,2) < prob_not_laid_off_w )
                {
                    result.CHOOSE_WORK_P = 1;
                    result.capacity = 0.5;
                    // draw wage for full time - will be multiply by 0.5 if part time job
                    float tmp1_w = beta11_w*EXP*HSD + beta21_w*pow(EXP,2)*HSD + beta12_w*EXP*HSG + beta22_w*pow(EXP,2)*HSG
                        + beta13_w*EXP*SC + beta23_w*pow(EXP,2)*SC + beta14_w*EXP*CG + beta24_w*pow(EXP,2)*CG + beta15_w*EXP*PC + beta25_w*pow(EXP,2)*PC
                        + beta31_w*HSD+ beta32_w*HSG+beta33_w*SC+ beta34_w*CG + beta35_w*PC + ability;			
                    float tmp2_w = (epsilon_f(draw_f, t,1)*sigma(5,5)); //epsilon_f(draw_f, t, state)  
                    result.wage_part = 0.5*exp(tmp1_w + tmp2_w);
                }
                else
                {
                    result.CHOOSE_WORK_P = 0;
                    result.wage_part = 0;
                    result.capacity = 0;		
                }
            } // worked in last period - full or part
        } //work / didn't work at t-1
    }
    else //men
    {
        if (prev_state == 0) //didn't worked in previous period
        {
            // draw job offer 
            float prob_full_tmp = lambda0_fh + lambda1_fh*EXP + lambda2_fh*year_of_school + lambda3_fh*HEALTH;
            float prob_part_tmp = lambda0_ph + lambda1_ph*EXP + lambda2_ph*year_of_school + lambda3_ph*HEALTH;
            float prob_full_h = exp(prob_full_tmp)/(1+exp(prob_full_tmp));
            float prob_part_h = exp(prob_part_tmp)/(1+exp(prob_part_tmp));
            if (h_draws(draw_f,t,1) < prob_full_h)   //w_draws = rand(DRAW_F,T,2); 1 - health,2 -job offer,  
            {
                result.CHOOSE_WORK_F = 1;
                // draw wage for full time - will be multiply by 0.5 if part time job
                float tmp1_h = beta11_h*EXP*HSD + beta21_h*pow(EXP,2)*HSD + beta12_h*EXP*HSG + beta22_h*pow(EXP,2)*HSG
                    + beta13_h*EXP*SC + beta23_h*pow(EXP,2)*SC +beta14_h*EXP*CG + beta24_h*pow(EXP,2)*CG +beta15_h*EXP*PC + beta25_h*pow(EXP,2)*PC
                    + beta31_h*HSD+ beta32_h*HSG+beta33_h*SC+ beta34_h*CG+ beta35_h*PC+ability;  
                float tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); //epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
                result.wage_full = exp(tmp1_h + tmp2_h);
                result.capacity = 1;
            }
            if (h_draws(draw_f,t,2)< prob_part_h)
            {
                result.CHOOSE_WORK_P = 1;
                // draw wage for full time - will be multiply by 0.5 if part time job
                float tmp1_h = beta11_h*EXP*HSD + beta21_h*pow(EXP,2)*HSD +beta12_h*EXP*HSG + beta22_h*pow(EXP,2)*HSG
                    + beta13_h*EXP*SC + beta23_h*pow(EXP,2)*SC + beta14_h*EXP*CG + beta24_h*pow(EXP,2)*CG +beta15_h*EXP*PC + beta25_h*pow(EXP,2)*PC
                    + beta31_h*HSD+ beta32_h*HSG+beta33_h*SC+ beta34_h*CG+ beta35_h*PC+ability; 
                float tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); //epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
                result.wage_part = 0.5*exp(tmp1_h + tmp2_h);
                result.capacity = 0.5;
            }   // no part time job offer
        }
        else  //work in previous period
        {
            if (prev_capacity == 1)
            {
                float prob_not_laid_off_tmp=lambda0_lh+ lambda1_lh*EXP+lambda2_lh*year_of_school +lambda3_lh*HEALTH;
                float prob_not_laid_off_h = exp(prob_not_laid_off_tmp)/(1+exp(prob_not_laid_off_tmp));
                if (h_draws(draw_f,t,1) < prob_not_laid_off_h)
                {
                    result.CHOOSE_WORK_F = 1;
                    result.capacity = 1;
                    // draw wage for full time - will be multiply by 0.5 if part time job
                    float tmp1_h = beta11_h*EXP*HSD + beta21_h*pow(EXP,2)*HSD + beta12_h*EXP*HSG + beta22_h*pow(EXP,2)*HSG
                        + beta13_h*EXP*SC + beta23_h*pow(EXP,2)*SC + beta14_h*EXP*CG + beta24_h*pow(EXP,2)*CG + beta15_h*EXP*PC + beta25_h*pow(EXP,2)*PC
                        + beta31_h*HSD + beta32_h*HSG+beta33_h*SC + beta34_h*CG + beta35_h*PC + ability;  
                    float tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); //epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
                    result.wage_full = exp(tmp1_h + tmp2_h);
                }
                else
                {
                    result.CHOOSE_WORK_F = 0;
                    result.wage_full = 0;
                    result.capacity = 0;		
                }
            }
            else // worked in prevous period as part time      
            {
                float prob_not_laid_off_tmp = lambda0_lh + lambda1_lh*EXP + lambda2_lh*year_of_school + lambda3_lh*HEALTH;
                float prob_not_laid_off_h = exp(prob_not_laid_off_tmp)/(1+exp(prob_not_laid_off_tmp));
                if (h_draws(draw_f,t,21) < prob_not_laid_off_h)
                {
                    result.CHOOSE_WORK_P = 1;
                    result.capacity = 0.5;
                    // draw wage for full time - will be multiply by 0.5 if part time job
                    float tmp1_h = beta11_h*EXP*HSD + beta21_h*pow(EXP,2)*HSD + beta12_h*EXP*HSG + beta22_h*pow(EXP,2)*HSG
                        + beta13_h*EXP*SC + beta23_h*pow(EXP,2)*SC +beta14_h*EXP*CG + beta24_h*pow(EXP,2)*CG +beta15_h*EXP*PC + beta25_h*pow(EXP,2)*PC
                        + beta31_h*HSD + beta32_h*HSG+beta33_h*SC + beta34_h*CG + beta35_h*PC + ability;  
                    float tmp2_h = (epsilon_f(draw_f, t,2)*sigma(6,6)); //epsilon_f-1-WAGE W, 2-WAGE-H, 3-HOME TIME, 4 - MARRIAGE QUALITY, 5 - PREGNANCY 
                    result.wage_full = 0.5*exp(tmp1_h + tmp2_h);
                }
                else
                {
                    result.CHOOSE_WORK_P = 0;
                    result.wage_part = 0;
                    result.capacity = 0;		
                }
            }
        }

    }
    return result;
}

