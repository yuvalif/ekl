#pragma once

struct draw_partner_result_t
{
    float CHOOSE_PARTNER;
    float PARTNER_N;
    float ability_p;
    float PS;
    float P_HSD;
    float P_HSG;
    float P_SC;
    float P_CG;
    float P_PC;
    float year_of_school_p;
    float PK;
    float prev_state_p;
    float capacity_p;
    float PARTNER_P;
    float P_GOOD;
    float P_FAIR;
    float P_POOR;
    float P_HEALTH;
    float Q_UTILITY_PERMANENT;
};


draw_partner_result_t draw_partner(int t, int draw_f_or_b , int age, int in_school_at_t_minus_1, int IND_S, int sex);

