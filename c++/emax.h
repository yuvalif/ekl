#pragma once

float EMAX_M_UM(int t, int HS, int HK, int C_N, int H_HEALTH, int H_L, 
        int ability_h_index, int prev_state_h, int PE_H, int p_minus_1);
float EMAX_W_UM(int t, int WS, int WK, int C_N, int W_HEALTH, int W_L,
        int ability_w_index, int prev_state_w, int PE_W, int p_minus_1);
float EMAX_M_M(int t, int WS, int WK, int C_N, int W_HEALTH, int W_L, int ability_w_index, 
        int prev_state_w, int PE_W, int p_minus_1, int HS, int HK, int H_HEALTH, int H_L, int ability_h_index, int prev_state_h, int PE_H, int Q_UTILITY);
float EMAX_W_M(int t, int WS, int WK, int C_N, int W_HEALTH, int W_L,
        int ability_w_index, int prev_state_w, int PE_W, int p_minus_1, int HS, int HK, int H_HEALTH, int H_L, int ability_h_index, int prev_state_h, int PE_H, int Q_UTILITY);

