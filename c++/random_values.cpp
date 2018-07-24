#include <random>
#include "global_params.h"

float epsilon_f_arr[DRAW_F*3][T_MAX][8];
float epsilon_b_arr[DRAW_B][T_MAX][6];
float h_draws_arr[DRAW_F*3][T_MAX][9];
float w_draws_arr[DRAW_F*3][T_MAX][3];

float epsilon_f(int i, int j, int s)
{
    return epsilon_f_arr[i][j][s];
}

float epsilon_b(int i, int j, int s)
{
    return epsilon_b_arr[i][j][s];
}

float h_draws(int i, int j, int s)
{
    return h_draws_arr[i][j][s];
}

float w_draws(int i, int j, int s)
{
    return w_draws_arr[i][j][s];
}

void init_random_values()
{
    std::random_device rd;  //Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()

    std::normal_distribution<> normal_dist(0, 1);
    // random draw from normal distribution, for shocks realizations in forward solution
    for (auto i = 0; i < DRAW_F*3; ++i)
    {
	    for (auto j = 0; j < T_MAX; ++j)  // T_MAX=65-16
        {
		    for (auto s = 0; s < 8; ++s)
            {
			    epsilon_f_arr[i][j][s] = normal_dist(gen); //1-WAGE W, 2-WAGE-H, 3-HOME TIME_w, 4-HOME TIME_h, 5 - MARRIAGE QUALITY, 6 - PREGNANCY, 7 - school w, 8 - school h
            }
        }
    }

    for (auto i = 0; i < DRAW_B; ++i)
    {
	    for (auto j = 0; j <  T_MAX; ++j)  // T_MAX=65-16
        {
		    for (auto s = 0; s < 6; ++s)
            {
			    epsilon_b_arr[i][j][s] = normal_dist(gen); //1-WAGE W, 2-WAGE-H, 3-HOME TIME_w, 4-HOME TIME_h, 5 - MARRIAGE QUALITY, 6 - PREGNANCY
            }
        }
    }

    std::uniform_int_distribution<> uniform_dist_3(1, 6);
    std::uniform_real_distribution<> uniform_dist_0_1(0, 1.0);

    for (auto i = 0; i < DRAW_F*3; ++i)
    {
	    for (auto j = 0; j < T_MAX; ++j)  // T_MAX=65-16
        {
		    for (auto s = 0; s < 9; ++s)
            {
                // 1 - job offer FULL
                // 2 - job offer part
                // 3 - MEET HUSBAND
                // 4 - HUSBAND SCHOOLING+EXP
                // 5 - HUSBAND ABILITY
                // 6 - HUSBAND CHILDREN
                // 7 - HUSBAND HEALTH
                // 8 - HUSBAND'S PARENTS EDUCATION
                // 9 - prev state husband
                if (s == 2)
                {
                    h_draws_arr[i][j][s] = uniform_dist_3(gen); //ABILITY IS 1 OR 2 OR 3
                }
                else
                {
                    h_draws_arr[i][j][s] = uniform_dist_0_1(gen);
                }
            }
                     
        }
    }
    for (auto i = 0; i < DRAW_F*3; ++i)
    {
	    for (auto j = 0; j < T_MAX; ++j)  // T_MAX=65-16
        {
		    for (auto s = 0; s < 3; ++s)
            {
                // 1 - JOB OFFER FULL
                // 2 - job offer part
                // 3 - marriage permanent 
                w_draws_arr[i][j][s] = uniform_dist_0_1(gen);
            }
                     
        }
    }
}

