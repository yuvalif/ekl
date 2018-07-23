#include <math.h>

float global_param_arr[200];

float sigma_arr[9][9];

float global_param(int i)
{
    return global_param_arr[i];
}

float sigma(int i, int j)
{
    return sigma_arr[i][j];
}

void init_sigma()
{
    for (auto i = 0; i < 9; ++i)
    {
        for (auto j = 0; j < 9; ++j)
        {
            sigma_arr[i][j] = 0.0;
        }
    }

    sigma_arr[1][1] = exp(global_param(112));    //variance wife ability
    sigma_arr[2][2] = exp(global_param(113));    //variance husband ability
    sigma_arr[3][3] = exp(global_param(114));    //variance home time wife
    sigma_arr[4][4] = exp(global_param(115));    //variance home time husband
    sigma_arr[5][5] = exp(global_param(116));    //wife's wage error variance
    sigma_arr[6][6] = exp(global_param(117));    //husband's wage error variance
    sigma_arr[7][7] = exp(global_param(118));    //match quality variance
    sigma_arr[8][8] = exp(global_param(119));    //pregnancy
}


float lambda0_fw; float lambda1_fw; float lambda2_fw; float lambda3_fw; 
float lambda0_pw; float lambda1_pw; float lambda2_pw; float lambda3_pw; 
float lambda0_lw; float lambda1_lw; float lambda2_lw; float lambda3_lw; 
float lambda0_fh; float lambda1_fh; float lambda2_fh; float lambda3_fh; 
float lambda0_ph; float lambda1_ph; float lambda2_ph; float lambda3_ph; 
float lambda0_lh; float lambda1_lh; float lambda2_lh; float lambda3_lh; 
float beta11_w;   float beta12_w;   float beta13_w;   float beta14_w;  float  beta15_w; 
float beta21_w;   float beta22_w;   float beta23_w;   float beta24_w;  float  beta25_w; 
float beta31_w;   float beta32_w;   float beta33_w;   float beta34_w;  float  beta35_w;
float beta11_h;   float beta12_h;   float beta13_h;   float beta14_h;  float  beta15_h; 
float beta21_h;   float beta22_h;   float beta23_h;   float beta24_h;  float  beta25_h; 
float beta31_h;   float beta32_h;   float beta33_h;   float beta34_h;  float  beta35_h;
float BP;
float h1; float h2; float h3; float h4; float h5; float h6; 
int GOOD; int FAIR; int POOR; 
float omega1; float omega2; float omega3; float omega4_w; float omega5_w; float omega6_w; float omega7_w; float omega8_w;
float omega4_h; float omega5_h; float omega6_h; float omega7_h; float omega8_h;
float omega9_w; float omega10_w; float omega9_h; float omega10_h;

float normal_arr[4] = {0.0, -1.150, 0.0, 1.150};

float p_education; float HK1; float HK2; float HK3; float HK4 ;

