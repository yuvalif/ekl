#pragma once

const int DRAW_F = 100;
const int DRAW_B = 100;
const int T_MAX = 65 - 15;

float global_param(int i);

float sigma(int i, int j);

extern float lambda0_fw; extern float lambda1_fw; extern float lambda2_fw; extern float lambda3_fw; extern float lambda0_pw; extern float lambda1_pw; 
extern float lambda2_pw; extern float lambda3_pw; extern float lambda0_lw; extern float lambda1_lw; extern float lambda2_lw; extern float lambda3_lw; 
extern float lambda0_fh; extern float lambda1_fh; extern float lambda2_fh; extern float lambda3_fh; extern float lambda0_ph; extern float lambda1_ph; 
extern float lambda2_ph; extern float lambda3_ph; extern float lambda0_lh; extern float lambda1_lh; extern float lambda2_lh; extern float lambda3_lh;
extern float beta11_w; extern float beta12_w; extern float beta13_w; extern float beta14_w; extern float beta15_w; extern float beta21_w;   
extern float beta22_w; extern float beta23_w; extern float beta24_w; extern float beta25_w; extern float beta31_w; extern float beta32_w;   
extern float beta33_w; extern float beta34_w; extern float beta35_w; extern float beta11_h; extern float beta12_h; extern float beta13_h;   
extern float beta14_h; extern float beta15_h; extern float beta21_h; extern float beta22_h; extern float beta23_h; extern float beta24_h;  
extern float beta25_h; extern float beta31_h; extern float beta32_h; extern float beta33_h; extern float beta34_h; extern float beta35_h;
extern float BP; 
extern float h1; extern float h2; extern float h3; extern float h4; extern float h5; extern float h6; 
extern int GOOD; extern int FAIR; extern int POOR; extern float omega1; 
extern float omega2; extern float omega3; extern float omega4_w; extern float omega5_w; extern float omega6_w; extern float omega7_w; 
extern float omega8_w; extern float omega4_h; extern float omega5_h; extern float omega6_h; extern float omega7_h; extern float omega8_h;
extern float omega9_w; extern float omega10_w; extern float omega9_h; extern float omega10_h;
extern float normal_arr[4]; 
extern float p_education; 
extern float HK1; extern float HK2; extern float HK3; extern float HK4;
extern float unemp_w; extern float unemp_h;
extern float row0; extern float row1; extern float row2; extern float row3;
extern float eta1; extern float eta2; extern float eta3; extern float eta4; extern float pai1; extern float pai2; extern float pai3; extern float pai4;
extern float alpha0; extern float alpha11_w; extern float alpha12_w; extern float alpha13_w; 
extern float alpha11_h;
extern float alpha12_h; extern float alpha13_h; extern float alpha2; extern float alpha3_m_w; extern float alpha3_s_w; extern float alpha3_m_h; 
extern float alpha3_s_h; extern float alpha41; extern float alpha42; extern float alpha43; extern float alpha44;
extern float t1_w; extern float t2_w; extern float t3_w; extern float t4_w; extern float t5_w; extern float t6_w; extern float t7_w; 
extern float t8_w;extern float t9_w; extern float t10_w; extern float t11_w; extern float t12_w;extern float t13_w; extern float t14_w; 
extern float t15_w; extern float t16_w;
extern float t1_h; extern float t2_h; extern float t3_h; extern float t4_h;extern float t5_h; extern float t6_h;
extern float t7_h; extern float t8_h;extern float t9_h; extern float t10_h; extern float t11_h; extern float t12_h;extern float t13_h; 
extern float t14_h; extern float t15_h; extern float t16_h;
extern float EMAX; 
extern float scale; 
extern float TERMINAL;
extern float decrease_low_ability ;extern float decrease_medium_ability ;
extern float psai0; extern float psai2; extern float psai3; extern float psai4; 
extern float m_education_45;extern float m_education_55;extern float m_education_65;
extern float GRID;
extern float AGE;

