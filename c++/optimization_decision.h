#pragma once

struct optimization_decision_result_t
{
    float optimization_desicion_w_v;
    float optimization_desicion_w_i;
    float optimization_desicion_h_v;
    float optimization_desicion_h_i;
};

optimization_decision_result_t optimization_desicion(float U_W[], float U_H[]);

