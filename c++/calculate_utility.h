#pragma once

struct calculate_utility_result_t
{
    // 25 OPTIONS: 7 OPTIONS AS SINGLE + 19 AS MARRIED
    float U_W[26];
    float U_H[26];
};


calculate_utility_result_t calculate_utility(int cohort, int cb_const, int cb_per_child, int W_N, int H_N, int C_N, 
        float wage_full_w, float wage_part_w, float wage_full_h, float wage_part_h, float capacity_w, float capacity_h, 
        int M_minus_1, float W_HEALTH, float H_HEALTH, float P_minus_1, int draw_f, int t, float Q_UTILITY ,float HS_UTILITY, float WS_UTILITY,
        float home_time_h_m, float home_time_h_um, float home_time_w, int CHOOSE_WORK_F_h, int CHOOSE_WORK_P_h, int CHOOSE_WORK_F_w, int CHOOSE_WORK_P_w, 
        int divorce, int age, int CHOOSE_HUSBAND, int CHOOSE_WIFE, int WS, int HS, int W_HSD, int W_HSG, int W_SC, int W_CG, int W_PC, int WK, 
        int H_HSD, int H_HSG, int H_SC, int H_CG, int H_PC, int HK, int HP);
