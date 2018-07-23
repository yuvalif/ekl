#include "global_params.h"
#include "random_values.h"
#include "math.h"
#include "assert.h"

struct health_result
{
    int HEALTH;
    int S_GOOD;
    int S_FAIR;
    int S_POOR;
};

health_result health(int S_GOOD, int S_FAIR, int S_POOR, int draw_f, int t, int sex)
{
    //h1 = global_param(1);    //good health to good health
    //h2 = global_param(1);    //fair health to good health
    //h3 = global_param(1);    //poor health to good health
    //h4 = global_param(1);    //good health to poor health
    //h5 = global_param(1);    //fair health to poor health
    //h6 = global_param(1);    //poor health to poor health
    float p_good_health_tmp = h1*S_GOOD+h2*S_FAIR + h3*S_POOR;
    float p_poor_health_tmp = h4*S_GOOD+h5*S_FAIR + h6*S_POOR;
    float p_good_health = exp(p_good_health_tmp)/(1.0+exp(p_good_health_tmp) + exp(p_poor_health_tmp));
    float p_poor_health = exp(p_poor_health_tmp)/(1.0+exp(p_good_health_tmp) + exp(p_poor_health_tmp));
    float p_fair_health = 1.0 - p_good_health - p_poor_health;

    if (p_fair_health < 0)
    {
        assert(0);
    }            

    health_result result;
    if (sex == 1)
    {
        if (w_draws(draw_f,t,1) <= p_good_health)
        {
            result.HEALTH = GOOD;
            result.S_GOOD = 1;
            result.S_FAIR = 0;
            result.S_POOR = 0;
        }
        else if (w_draws(draw_f,t,1) > p_good_health && w_draws(draw_f,t,1) <= (p_good_health+p_fair_health))
        {
            result.HEALTH = FAIR;
            result.S_GOOD = 0;
            result.S_FAIR = 1;
            result.S_POOR = 0;
        }
        else if (w_draws(draw_f,t,1) > (p_good_health+p_fair_health))
        {
            result.HEALTH = POOR;
            result.S_GOOD = 0;
            result.S_FAIR = 0;
            result.S_POOR = 1;
        }
        else
        {
            assert(0);
        }	
    }
    else
    {   // men's health
        if (h_draws(draw_f,t,5) <= p_good_health)
        {
            result.HEALTH = GOOD;
            result.S_GOOD = 1;
            result.S_FAIR = 0;
            result.S_POOR = 0;
        }
        else if (h_draws(draw_f,t,5) > p_good_health && h_draws(draw_f,t,5) <= (p_good_health+p_fair_health))
        {
            result.HEALTH = FAIR;
            result.S_GOOD = 0;
            result.S_FAIR = 1;
            result.S_POOR = 0;
        }
        else if (h_draws(draw_f,t,5) >  (p_good_health+p_fair_health))
        {
            result.HEALTH = POOR;
            result.S_GOOD = 0;
            result.S_FAIR = 0;
            result.S_POOR = 1;
        }
        else
        {
            assert(0);
        }	           
    }
    return result;
}

