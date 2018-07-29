#pragma once

struct health_result_t
{
    int HEALTH;
    int S_GOOD;
    int S_FAIR;
    int S_POOR;
};

health_result_t health(int S_GOOD, int S_FAIR, int S_POOR, int draw_f, int t, int sex);

