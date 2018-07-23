
struct wage_calc_result
{
    int CHOOSE_WORK_F;
    int CHOOSE_WORK_P;
    int wage_full;
    int wage_part;
    float capacity;
};

wage_calc_result wage_calc(int EXP, int prev_state, int prev_capacity, int year_of_school, int HEALTH, 
        float* w_draws, float* h_draws, float* epsilon_f, float draw_f, int t, int HSD, int HSG, int SC, int CG, int PC, int ability, int sex);
