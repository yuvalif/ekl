#include "global_params.h"

struct optimization_desicion_result
{
    float optimization_desicion_w_v;
    float optimization_desicion_w_i;
    float optimization_desicion_h_v;
    float optimization_desicion_h_i;
};

optimization_desicion_result optimization_desicion(float U_W[], float U_H[])
{
    float outside_option_w_v = U_W[1]; // 1-singe+unemployed + non-pregnant
    float outside_option_w_i = 1;
    float outside_option_h_v = U_H[1];
    float outside_option_h_i = 1;
    // marriage decision - outside option value wife
    if (U_W[2] > outside_option_w_v)
    {
        outside_option_w_v = U_W[2]; // 2-singe+unemployed + pregnant - zero for men
        outside_option_w_i = 2;
    }
    if (U_W[3] > outside_option_w_v)
    {
        outside_option_w_v = U_W[3]; // 3-singe+employed + non-pregnant
        outside_option_w_i = 3;
    }
    if (U_W[4] > outside_option_w_v)
    {
        outside_option_w_v = U_W[4]; // 4-singe+employed + pregnant   - zero for men
        outside_option_w_i = 4;
    }
    if (U_W[5] > outside_option_w_v)
    {
        outside_option_w_v = U_W[5]; // 5-singe+ schooling
        outside_option_w_i = 5;
    }
    // marriage decision - outside option value husband
    if (U_H[3] > outside_option_h_v)
    {
        outside_option_h_v = U_H[3]; // 3-singe+employed + non-pregnant
        outside_option_h_i = 3;
    }
    if (U_H[5] > outside_option_h_v)
    {
        outside_option_h_v = U_H[5]; // 5-singe+ schooling
        outside_option_h_i = 5;
    }
    optimization_desicion_result result;
    // marriage decision - choose the max out of all options
    result.optimization_desicion_w_v = outside_option_w_v;
    result.optimization_desicion_w_i = outside_option_w_i;
    result.optimization_desicion_h_v = outside_option_h_v;
    result.optimization_desicion_h_i = outside_option_h_i;
    if (U_H[5 + 1] > outside_option_h_v && U_W[5 + 1] > outside_option_w_v)
    {
        result.optimization_desicion_w_v = U_W[5 + 1]; //         1-married+man employed+women unemployed+unpregnent
        result.optimization_desicion_w_i = 6;
        result.optimization_desicion_h_v = U_H[5 + 1];
        result.optimization_desicion_h_i = 6;
    }
    if ((U_H[5 + 2] > outside_option_h_v && U_W[5 + 2] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 2] > outside_option_h_v && U_W[5 + 2] > outside_option_w_v && result.optimization_desicion_w_i > 5 && 
        U_H[5 + 2] * BP + (1 - BP) * U_W[5 + 2] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 2]; //   		 2-married+man employed+women unemployed+pregnent
        result.optimization_desicion_w_i = 7;
        result.optimization_desicion_h_v = U_H[5 + 2];
        result.optimization_desicion_h_i = 7;
    }
    if ((U_H[5 + 3] > outside_option_h_v && U_W[5 + 3] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 3] > outside_option_h_v && U_W[5 + 3] > outside_option_w_v && result.optimization_desicion_w_i > 5 && 
        U_H[5 + 3] * BP + (1 - BP) * U_W[5 + 3] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 3]; //            3-married+man employed+women eployed+unpregnent
        result.optimization_desicion_w_i = 8;
        result.optimization_desicion_h_v = U_H[5 + 3];
        result.optimization_desicion_h_i = 8;
    }
    if ((U_H[5 + 4] > outside_option_h_v && U_W[5 + 4] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 4] > outside_option_h_v && U_W[5 + 4] > outside_option_w_v && result.optimization_desicion_w_i > 5 && 
        U_H[5 + 4] * BP + (1 - BP) * U_W[5 + 4] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 4]; //			 4-married+man employed+women eployed+pregnent
        result.optimization_desicion_w_i = 9;
        result.optimization_desicion_h_v = U_H[5 + 4];
        result.optimization_desicion_h_i = 9;
    }
    if ((U_H[5 + 5] > outside_option_h_v && U_W[5 + 5] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 5] > outside_option_h_v && U_W[5 + 5] > outside_option_w_v && result.optimization_desicion_w_i > 5 && 
        U_H[5 + 5] * BP + (1 - BP) * U_W[5 + 5] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 5]; //            5-married+man unemployed+women unemployed+unpregnent
        result.optimization_desicion_w_i = 10;
        result.optimization_desicion_h_v = U_H[5 + 5];
        result.optimization_desicion_h_i = 10;
    }
    if ((U_H[5 + 6] > outside_option_h_v && U_W[5 + 6] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 6] > outside_option_h_v && U_W[5 + 6] > outside_option_w_v && result.optimization_desicion_w_i > 5 &&
        U_H[5 + 6] * BP + (1 - BP) * U_W[5 + 6] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 6]; //   		 6-married+man unemployed+women unemployed+pregnent
        result.optimization_desicion_w_i = 11;
        result.optimization_desicion_h_v = U_H[5 + 6];
        result.optimization_desicion_h_i = 11;
    }
    if ((U_H[5 + 7] > outside_option_h_v && U_W[5 + 7] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 7] > outside_option_h_v && U_W[5 + 7] > outside_option_w_v && result.optimization_desicion_w_i > 5 &&
        U_H[5 + 7] * BP + (1 - BP) * U_W[5 + 7] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 7]; //            7-married+man unemployed+women eployed+unpregnent
        result.optimization_desicion_w_i = 12;
        result.optimization_desicion_h_v = U_H[5 + 7];
        result.optimization_desicion_h_i = 12;
    }
    if ((U_H[5 + 8] > outside_option_h_v && U_W[5 + 8] > outside_option_w_v && result.optimization_desicion_w_i < 6) ||
        (U_H[5 + 8] > outside_option_h_v && U_W[5 + 8] > outside_option_w_v && result.optimization_desicion_w_i > 5 &&
        U_H[5 + 8] * BP + (1 - BP) * U_W[5 + 8] > result.optimization_desicion_h_v * BP + (1 - BP) * result.optimization_desicion_w_v))
    {
        result.optimization_desicion_w_v = U_W[5 + 8]; //			 8-married+man unemployed+women eployed+pregnent
        result.optimization_desicion_w_i = 13;
        result.optimization_desicion_h_v = U_H[5 + 8];
        result.optimization_desicion_h_i = 13;
    }

    return result;
}

