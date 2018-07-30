#include <math.h>

float global_param_arr[200];

float sigma_arr[9][9];

float global_param(int i)
{
    return global_param_arr[i];
}

int init_sigma()
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
    return 0;
}

float sigma(int i, int j)
{
    static int dummy = init_sigma();
    return sigma_arr[i][j];
}


float lambda0_fw;  float lambda1_fw;  float lambda2_fw;  float lambda3_fw;  float lambda0_pw;  float lambda1_pw; 
float lambda2_pw;  float lambda3_pw;  float lambda0_lw;  float lambda1_lw;  float lambda2_lw;  float lambda3_lw; 
float lambda0_fh;  float lambda1_fh;  float lambda2_fh;  float lambda3_fh;  float lambda0_ph;  float lambda1_ph; 
float lambda2_ph;  float lambda3_ph;  float lambda0_lh;  float lambda1_lh;  float lambda2_lh;  float lambda3_lh;
float beta11_w;  float beta12_w;  float beta13_w;  float beta14_w;  float beta15_w;  float beta21_w;   
float beta22_w;  float beta23_w;  float beta24_w;  float beta25_w;  float beta31_w;  float beta32_w;   
float beta33_w;  float beta34_w;  float beta35_w;  float beta11_h;  float beta12_h;  float beta13_h;   
float beta14_h;  float beta15_h;  float beta21_h;  float beta22_h;  float beta23_h;  float beta24_h;  
float beta25_h;  float beta31_h;  float beta32_h;  float beta33_h;  float beta34_h;  float beta35_h;
float BP; 
float h1;  float h2;  float h3;  float h4;  float h5;  float h6; 
int GOOD;  int FAIR;  int POOR;  float omega1; 
float omega2;  float omega3;  float omega4_w;  float omega5_w;  float omega6_w;  float omega7_w; 
float omega8_w;  float omega4_h;  float omega5_h;  float omega6_h;  float omega7_h;  float omega8_h;
float omega9_w;  float omega10_w;  float omega9_h;  float omega10_h;
float p_education; 
float HK1;  float HK2;  float HK3;  float HK4;
float unemp_w;  float unemp_h;
float row0;  float row1;  float row2;  float row3;
float eta1;  float eta2;  float eta3;  float eta4;  float pai1;  float pai2;  float pai3;  float pai4;
float alpha0;  float alpha11_w;  float alpha12_w;  float alpha13_w; 
float alpha11_h;
float alpha12_h;  float alpha13_h;  float alpha2;  float alpha3_m_w;  float alpha3_s_w;  float alpha3_m_h; 
float alpha3_s_h;  float alpha41;  float alpha42;  float alpha43;  float alpha44;
float t1_w;  float t2_w;  float t3_w;  float t4_w;  float t5_w;  float t6_w;  float t7_w; 
float t8_w; float t9_w;  float t10_w;  float t11_w;  float t12_w; float t13_w;  float t14_w; 
float t15_w;  float t16_w;
float t1_h;  float t2_h;  float t3_h;  float t4_h; float t5_h;  float t6_h;
float t7_h;  float t8_h; float t9_h;  float t10_h;  float t11_h;  float t12_h; float t13_h; 
float t14_h;  float t15_h;  float t16_h;
float EMAX; 
float scale; 
float TERMINAL;
float decrease_low_ability ; float decrease_medium_ability ;
float psai0;  float psai2;  float psai3;  float psai4; 
float m_education_45; float m_education_55; float m_education_65;
float GRID;
float AGE;

float normal_arr[4] = {0.0, -1.150, 0.0, 1.150};

