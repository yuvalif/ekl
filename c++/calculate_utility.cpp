#include <string.h>
#include <assert.h>
#include <math.h>
#include "calculate_utility.h"
#include "global_params.h"
#include "gross_to_net.h"
#include "random_values.h"
#include "emax.h"
#include "interpolation.h"

calculate_utility_result_t calculate_utility(int cohort, int cb_const, int cb_per_child, int W_N, int H_N, int C_N, 
        float wage_full_w, float wage_part_w, float wage_full_h, float wage_part_h, float capacity_w, float capacity_h, 
        int M_minus_1, float W_HEALTH, float H_HEALTH, float P_minus_1, int draw_f, int t, float Q_UTILITY ,float HS_UTILITY, float WS_UTILITY,
        float home_time_h_m, float home_time_h_um, float home_time_w, int CHOOSE_WORK_F_h, int CHOOSE_WORK_P_h, int CHOOSE_WORK_F_w, int CHOOSE_WORK_P_w, 
        int divorce, int age, int CHOOSE_HUSBAND, int CHOOSE_WIFE, int WS, int HS, int W_HSD, int W_HSG, int W_SC, int W_CG, int W_PC, int WK, 
        int H_HSD, int H_HSG, int H_SC, int H_CG, int H_PC, int HK, int HP)
{
    // net income
    int year;
    if (cohort == 1)
    {
        year = 1945 + 15 + t;
    }
    else if (cohort == 2)
    {
        year = 1955 + 15 + t;
    }
    else if (cohort == 3)
    {
        year = 1965 +15 + t;
    }

    float net_income_single_w_ue;
    if (W_N == 0)
    {
        net_income_single_w_ue = unemp_w;
    }
    else
    {
        net_income_single_w_ue   = unemp_w+cb_const+cb_per_child*(W_N-1);
    }

    float net_income_single_w_ef    =         gross_to_net(W_N, 0 , 0 , wage_full_w, 0     , 0 ,year);
    float net_income_single_w_ep    =         gross_to_net(W_N, 0 , 0 , wage_part_w, 0     , 0 ,year);
    float net_income_single_h_ue   = unemp_h;
    float net_income_single_h_ef    =         gross_to_net( 0 ,H_N, 0 ,     0 , wage_full_h, 0 ,year);
    float net_income_single_h_ep    =         gross_to_net( 0 ,H_N, 0 ,     0 , wage_part_h, 0 ,year);
    // first index wife, second husband
    float net_income_married_ue_ue = unemp_h+unemp_w;
    float net_income_married_ue_ef  = unemp_w+gross_to_net(W_N ,H_N ,C_N,     0 , wage_full_h, 1 ,year);
    // if married, C_N is # of children, if consider geting married, # of children is W_N+H_N
    float net_income_married_ue_ep  = unemp_w+gross_to_net(W_N ,H_N ,C_N,     0 , wage_part_h, 1 ,year);
    // if married, C_N is # of children, if consider geting married, # of children is W_N+H_N
    float net_income_married_ef_ue  = unemp_h+gross_to_net(W_N, H_N ,C_N,wage_full_w ,  0    , 1 ,year);
    float net_income_married_ep_ue  = unemp_h+gross_to_net(W_N, H_N ,C_N,wage_part_w ,  0    , 1 ,year);
    float net_income_married_ef_ef   =         gross_to_net(W_N, H_N ,C_N,wage_full_w ,wage_full_h , 1 ,year);
    float net_income_married_ef_ep   =         gross_to_net(W_N, H_N ,C_N,wage_full_w ,wage_part_h , 1 ,year);
    float net_income_married_ep_ep   =         gross_to_net(W_N, H_N ,C_N,wage_part_w ,wage_part_h , 1 ,year);
    float net_income_married_ep_ef   =         gross_to_net(W_N, H_N ,C_N,wage_part_w ,wage_full_h , 1 ,year);

    // budget constraint
    int eta = 0;
    if (C_N == 0)
    {
        eta = 0;
    }
    else if (C_N == 1)
    {
        eta = eta1; //this is the fraction of parent's income that one child gets
    }
    else if (C_N == 2)
    {
        eta = eta2;
    }
    else if (C_N == 3)
    {
        eta = eta3;
    }
    else if (C_N == 4)
    {
        eta = eta4;
    }
    else
    {
        assert(0);
    }

    int eta_w = 0;
    if (W_N == 0)
    {
        eta_w = 0;
    }
    else if (W_N == 1)
    {
        eta_w = eta1; //this is the fraction of parent's income that one child gets
    }
    else if (W_N == 2)
    {
        eta_w = eta2;
    }
    else if (W_N == 3)
    {
        eta_w = eta3;
    }
    else if (W_N == 4)
    {
        eta_w = eta4;
    }
    else
    {
        assert(0);
    }

    int eta_h = 0;
    if (H_N == 0)
    {
        eta_h = 0;
    }
    else if (H_N == 1)
    {
        eta_h = eta1; //this is the fraction of parent's income that one child gets
    }
    else if (H_N == 2)
    {
        eta_h = eta2;
    }
    else  if (H_N == 3)
    {
        eta_h = eta3;
    }
    else if (H_N == 4)
    {
        eta_h = eta4;
    }
    else
    {
        assert(0);
    }

    float budget_c_single_w_ue   = (1-eta_w)*net_income_single_w_ue;
    float budget_c_single_w_ef    = (1-eta_w)*net_income_single_w_ef;
    float budget_c_single_w_ep    = (1-eta_w)*net_income_single_w_ep;
    float budget_c_single_h_ue   = (1-eta_h)*net_income_single_h_ue;
    float budget_c_single_h_ef    = (1-eta_h)*net_income_single_h_ef  ;
    float budget_c_single_h_ep    = (1-eta_h)*net_income_single_h_ep  ;
    // first index wife, second husband
    float budget_c_married_ue_ue = (1-eta)*(net_income_married_ue_ue);
    float budget_c_married_ue_ef  = (1-eta)*(net_income_married_ue_ef);
    float budget_c_married_ue_ep  = (1-eta)*(net_income_married_ue_ep);
    float budget_c_married_ef_ue  = (1-eta)*(net_income_married_ef_ue);
    float budget_c_married_ep_ue  = (1-eta)*(net_income_married_ep_ue);
    float budget_c_married_ef_ef   = (1-eta)*(net_income_married_ef_ef);
    float budget_c_married_ef_ep   = (1-eta)*(net_income_married_ef_ep);
    float budget_c_married_ep_ep   = (1-eta)*(net_income_married_ep_ep);
    float budget_c_married_ep_ef   = (1-eta)*(net_income_married_ep_ef);
    float divorce_cost_w=alpha41+alpha43*C_N;
    float divorce_cost_h=alpha42+alpha44*C_N;

    // utility from quality and quality of children: //row0 - CES  parameter; row1 - women leisure; row2 - husband leisure; row3 -income
    float children_utility_single_w_ue;
    float children_utility_single_w_ef;
    float children_utility_single_w_ep;

    if (W_N > 0)
    {
        children_utility_single_w_ue = pow((row1*pow((1.0-HP),row0)     + 
                    row3*pow((eta1*net_income_single_w_ue),row0)+(1.0-row1-row2-row3)*pow((W_N),row0)),(1.0/row0));
        children_utility_single_w_ef = pow((                              
                    row3*pow((eta1*net_income_single_w_ef),row0)+(1.0-row1-row2-row3)*pow((W_N),row0)),(1.0/row0));
        children_utility_single_w_ep = pow((row1*pow((1.0-0.5-HP),row0) + 
                    row3*pow((eta1*net_income_single_w_ep),row0)+(1.0-row1-row2-row3)*pow((W_N),row0)),(1.0/row0));
    }
    else if (W_N == 0)
    {
        children_utility_single_w_ue = 0;
        children_utility_single_w_ef = 0;
        children_utility_single_w_ep = 0;
    }
    else
    {
        assert(0);
    }

    float children_utility_single_h_ue;
    float children_utility_single_h_ef;
    float children_utility_single_h_ep;

    if (H_N > 0)
    {
        children_utility_single_h_ue = pow((row2*pow((1.0-HP),row0)     + 
                    row3*pow((eta1*net_income_single_h_ue),row0)+(1.0-row1-row2-row3)*pow((H_N),row0)),(1.0/row0));
        children_utility_single_h_ef = pow((                              
                    row3*pow((eta1*net_income_single_h_ef),row0)+(1.0-row1-row2-row3)*pow((H_N),row0)),(1.0/row0));
        children_utility_single_h_ep = pow((row2*pow((1.0-0.5-HP),row0) + 
                    row3*pow((eta1*net_income_single_h_ep),row0)+(1.0-row1-row2-row3)*pow((H_N),row0)),(1.0/row0));
    }
    else if (H_N ==0)
    {
        children_utility_single_h_ue = 0;
        children_utility_single_h_ef = 0;
        children_utility_single_h_ep = 0;
    }
    else
    {
        assert(0);
    }

    // I assume that each kid get 20// (eta1). if the family has 2 kids, each gets 20//, yet the total is 32// (eta2) since part is common
    float children_utility_married_ue_ue;
    float children_utility_married_ue_ef;
    float children_utility_married_ue_ep;
    float children_utility_married_ef_ue;
    float children_utility_married_ep_ue;
    float children_utility_married_ef_ef;
    float children_utility_married_ef_ep;
    float children_utility_married_ep_ep;
    float children_utility_married_ep_ef;
    float preg_utility_um;
    float preg_utility_m;

    if (M_minus_1 == 1)
    {
        if (C_N > 0)
        {
            // first index wife, second husband
            children_utility_married_ue_ue = pow((row1*pow((1.0-HP),row0)    + 
                        row2*pow((1.0-HP),row0)    +row3*pow((eta1*net_income_married_ue_ue),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ue_ef = pow((row1*pow((1.0-HP),row0)    +
                        row3*pow((eta1*net_income_married_ue_ef),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ue_ep = pow((row1*pow((1.0-HP),row0)    + 
                        row2*pow((1.0-0.5-HP),row0)+row3*pow((eta1*net_income_married_ue_ep),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ef_ue = pow((                      + 
                        row2*pow((1.0-HP),row0)    +row3*pow((eta1*net_income_married_ef_ue),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ep_ue = pow((row1*pow((1.0-0.5-HP),row0)+ 
                        row2*pow((1.0-HP),row0)    +row3*pow((eta1*net_income_married_ep_ue),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ef_ef = pow((                                               
                        row3*pow((eta1*net_income_married_ef_ef),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ef_ep = pow((                      + 
                        row2*pow((1.0-0.5-HP),row0)+row3*pow((eta1*net_income_married_ef_ep),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ep_ep = pow((row1*pow((1.0-0.5-HP),row0)+ 
                        row2*pow((1.0-0.5-HP),row0)+row3*pow((eta1*net_income_married_ep_ep),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
            children_utility_married_ep_ef = pow((row1*pow((1.0-0.5-HP),row0)+                        
                        row3*pow((eta1*net_income_married_ep_ef),row0)+(1-row1-row2-row3)*pow((C_N),row0)),(1.0/row0));
        }
        else if (C_N == 0)
        {
            children_utility_married_ue_ue = 0;
            children_utility_married_ue_ef  = 0;
            children_utility_married_ue_ep  = 0;
            children_utility_married_ef_ue  = 0;
            children_utility_married_ep_ue  = 0;
            children_utility_married_ef_ef = 0;
            children_utility_married_ef_ep = 0;
            children_utility_married_ep_ep = 0;
            children_utility_married_ep_ef = 0;
        }
        // utility from pregnancy when married / utility from pregnancy when SINGLE
        preg_utility_m =         pai2*W_HEALTH+pai3*(C_N)+pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
        preg_utility_um = pai1 + pai2*W_HEALTH+pai3*(C_N)+pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
    }
    else
    {
        if (W_N + H_N > 0)
        {
            // first index wife, second husband
            children_utility_married_ue_ue = pow((row1*pow((1-HP),row0)     + row2*pow((1-HP),row0)     + row3*pow((eta1*net_income_married_ue_ue),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ue_ef = pow((row1*pow((1-HP),row0)     +                           + row3*pow((eta1*net_income_married_ue_ef),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ue_ep = pow((row1*pow((1-HP),row0)     + row2*pow((1-0.5-HP),row0) + row3*pow((eta1*net_income_married_ue_ep),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ef_ue = pow((row2*pow((1-HP),row0)                                 + row3*pow((eta1*net_income_married_ef_ue),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ep_ue = pow((row1*pow((1-0.5-HP),row0) + row2*pow((1-HP),row0)     + row3*pow((eta1*net_income_married_ep_ue),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ef_ef = pow((                                                        row3*pow((eta1*net_income_married_ef_ef),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ef_ep = pow((                            row2*pow((1-0.5-HP),row0) + row3*pow((eta1*net_income_married_ef_ep),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ep_ep = pow((row1*pow((1-0.5-HP),row0) + row2*pow((1-0.5-HP),row0) + row3*pow((eta1*net_income_married_ep_ep),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));
            children_utility_married_ep_ef = pow((row1*pow((1-0.5-HP),row0) +                           + row3*pow((eta1*net_income_married_ep_ef),row0)+(1-row1-row2-row3)*pow((W_N+H_N),row0)),(1/row0));

        }
        else if (W_N+H_N == 0)
        {
            children_utility_married_ue_ue = 0;
            children_utility_married_ue_ef  = 0;
            children_utility_married_ue_ep  = 0;
            children_utility_married_ef_ue  = 0;
            children_utility_married_ep_ue  = 0;
            children_utility_married_ef_ef = 0;
            children_utility_married_ef_ep = 0;
            children_utility_married_ep_ep = 0;
            children_utility_married_ep_ef = 0;
        }
        // utility from pregnancy when married / utility from pregnancy when SINGLE
        preg_utility_um =         pai2*W_HEALTH+pai3*(W_N+H_N)+pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
        preg_utility_m  =  pai1 + pai2*W_HEALTH+pai3*(W_N)    +pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
    }
    // decision making - choose from up to 13 options, according to CHOOSE_HUSBAND, CHOOSE_WORK, AGE  values
    // utility from each option:
    // single options:		     
    //            1-singe+unemployed + non-pregnant
    //		      2-singe+unemployed + pregnant - zero for men
    //            3-singe+employed full + non-pregnant
    //            4-singe+employed full+ pregnant   - zero for men
    //            5-singe+employed part+ non-pregnant
    //            6-singe+employed part+ pregnant   - zero for men
    //            7-schooling: single+ unemployed+non-pregnant+no children
    // marriage options:// first index wife, second husband
    //            1-married+women unemployed       +man employed full    +non-pregnant
    //   		  2-married+women unemployed      +man employed full    +pregnant
    //            3-married+women unemployed      +man employed part    +non-pregnant
    //   		  4-married+women unemployed      +man employed part    +pregnant
    //            5-married+women employed full   +man unemployed       +non-pregnant
    //			  6-married+women employed full   +man unemployed       +pregnant
    //            7-married+women employed part   +man unemployed       +non-pregnant
    //			  8-married+women employed part   +man unemployed       +pregnant
    //            9-married+women employed ful    +man employed fulll   +non-pregnant
    //            10-married+women employed full  +man employed part    +non-pregnant
    //            11-married+women employed part +man employed part     +non-pregnant
    //            12-married+women employed part +man employed full     +non-pregnant
    //			  13-married+women employed full +man employed full     +pregnant
    //			  14-married+women employed full +man employed part     +pregnant
    //			  15-married+women employed part +man employed part     +pregnant
    //			  16-married+women employed part +man employed full     +pregnant
    //			  17-married+woman unemployed    +men unemployed        +non-pregnant
    //			  18-married+woman unemployed    +men unemployed        +pregnant
    // wife current utility from each option:
    // Utility parameters
    //		temp1=(1/alpha0)*(budget_c_single_w_ue^alpha0)
    //        budget_c_single_w_ue
    //        temp2=((alpha12_w*WP+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)
    //        WP
    //        W_HEALTH
    //        temp3=alpha3_s_w*children_utility_single_w_ue
    //        home_time_w
    //        preg_utility_um

    float UC_W_S1= (1/alpha0)*pow(budget_c_single_w_ue,alpha0)+
        ((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_s_w*children_utility_single_w_ue+home_time_w+divorce_cost_w*M_minus_1;
    float UC_W_S2= (1/alpha0)*pow(budget_c_single_w_ue,alpha0)+
        ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_s_w*children_utility_single_w_ue+home_time_w+preg_utility_um+divorce_cost_w*M_minus_1;

    float UC_W_S3, UC_W_S4;
    if (capacity_w == 1)  //to avoid division by zero
    {
        UC_W_S3 = (1/alpha0)*pow(budget_c_single_w_ef,alpha0)+
            +alpha3_s_w*children_utility_single_w_ef+divorce_cost_w*M_minus_1;
        UC_W_S4 = (1/alpha0)*pow(budget_c_single_w_ef,alpha0)+
            +alpha3_s_w*children_utility_single_w_ef+preg_utility_um+divorce_cost_w*M_minus_1;
    }
    else
    {
        UC_W_S3= 0;
        UC_W_S4= 0;
    }

    float UC_W_S5, UC_W_S6;
    if (capacity_w == 0.5)   //capacity_w=0.5
    {
        UC_W_S5 = (1/alpha0)*pow(budget_c_single_w_ep,alpha0)+
            ((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_s_w*children_utility_single_w_ep+home_time_w*(1-capacity_w)+divorce_cost_w*M_minus_1;
        UC_W_S6 = (1/alpha0)*pow(budget_c_single_w_ep,alpha0)+
            ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_s_w*children_utility_single_w_ep+home_time_w*(1-capacity_w)+preg_utility_um+divorce_cost_w*M_minus_1;
    }
    else
    {
        UC_W_S5= 0;
        UC_W_S6= 0;
    }

    float UC_W_S7 = WS_UTILITY; // in school-no leisure, no income, but utility from schooling+increase future value
    // marriage options:// first index wife, second husband
    float UC_W_M1 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ef),alpha0)+
        ((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_w*children_utility_married_ue_ef+home_time_w;
    float UC_W_M2 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ef),alpha0)+
        ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_w*children_utility_married_ue_ef+home_time_w+preg_utility_m;
    float UC_W_M3 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ep),alpha0)+
        ((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_w*children_utility_married_ue_ep+home_time_w;
    float UC_W_M4 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ep),alpha0)+
        ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_w*children_utility_married_ue_ep+home_time_w+preg_utility_m;

    float UC_W_M5;
    float UC_W_M6;
    if (capacity_w == 1)  //to avoid division by zero
    {
        UC_W_M5 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ue),alpha0)+alpha3_m_w*children_utility_married_ef_ue;
        UC_W_M6 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ue),alpha0)+alpha3_m_w*children_utility_married_ef_ue+preg_utility_m;
    }
    else
    {
        UC_W_M5 = 0;
        UC_W_M6 = 0;
    }

    float UC_W_M7;
    float UC_W_M8;
    if (capacity_w == 0.5)     //capacity_w=0.5
    {
        UC_W_M7= Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ue),alpha0)+
            ((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-capacity_w),alpha2)+alpha3_m_w*children_utility_married_ep_ue+home_time_w*(1-capacity_w);
        UC_W_M8= Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ue),alpha0)+
            ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-capacity_w),alpha2)+alpha3_m_w*children_utility_married_ep_ue+home_time_w*(1-capacity_w)+preg_utility_m;
    }
    else
    {
        UC_W_M7 = 0;
        UC_W_M8 = 0;
    }

    float UC_W_M9;
    float UC_W_M10;
    if (capacity_w == 1)  //to avoid division by zero
    {
        UC_W_M9 =  Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ef),alpha0)+alpha3_m_w*children_utility_married_ef_ef;
        UC_W_M10 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ep),alpha0)+alpha3_m_w*children_utility_married_ef_ep;
    }
    else
    {
        UC_W_M9 = 0;
        UC_W_M10 = 0;
    }

    float UC_W_M11;
    float UC_W_M12;
    if (capacity_w == 0.5)
    {
        UC_W_M11 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ep),alpha0)+alpha3_m_w*children_utility_married_ep_ep+
            ((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-0.5),alpha2)+home_time_w*(1-0.5);
        UC_W_M12 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ef),alpha0)+alpha3_m_w*children_utility_married_ep_ef+
            ((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-0.5),alpha2)+home_time_w*(1-0.5);
    }
    else
    {
        UC_W_M11 = 0;
        UC_W_M12 = 0;
    }

    float UC_W_M13;
    float UC_W_M14;
    if (capacity_w == 1)  //to avoid division by zero
    {
        UC_W_M13 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ef),alpha0)+alpha3_m_w*children_utility_married_ef_ef+preg_utility_m;
        UC_W_M14 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ep),alpha0)+alpha3_m_w*children_utility_married_ef_ep+preg_utility_m;
    }
    else
    {
        UC_W_M13 = 0;
        UC_W_M14 = 0;
    }

    float UC_W_M15;
    float UC_W_M16;
    if (capacity_w == 0.5)
    {
        UC_W_M15 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ep),alpha0)+
            alpha3_m_w*children_utility_married_ep_ep+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-0.5),alpha2)+home_time_w*(1-0.5)+preg_utility_m;
        UC_W_M16 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ef),alpha0)+
            alpha3_m_w*children_utility_married_ep_ef+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1-0.5),alpha2)+home_time_w*(1-0.5)+preg_utility_m;
    }
    else
    {
        UC_W_M15 = 0;
        UC_W_M16 = 0;
    }

    float UC_W_M17 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ue),alpha0)+
        ((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_w*children_utility_married_ue_ue+home_time_w;
    float UC_W_M18 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ue),alpha0)+
        ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_w*children_utility_married_ue_ue+home_time_w+preg_utility_m;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // husband (potential husband) current utility from each option:
    float UC_H_S1 = (1/alpha0)*pow(budget_c_single_h_ue,alpha0)+ ((alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)+
        alpha3_s_h*children_utility_single_h_ue+home_time_h_um+divorce_cost_h*M_minus_1;
    float UC_H_S2 = -9999;
    float UC_H_S3;
    if (capacity_h == 1)
    {
        UC_H_S3 = (1/alpha0)*pow(budget_c_single_h_ef,alpha0)+alpha13_h*children_utility_single_h_ef+divorce_cost_h*M_minus_1;
    }
    else
    {
        UC_H_S3 = 0;
    }

    float UC_H_S4 = -9999;
    float UC_H_S5;
    if (capacity_h == 0.5)
    {
        UC_H_S5 = (1/alpha0)*pow(budget_c_single_h_ep,alpha0)+((alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+
            alpha3_s_h*children_utility_single_h_ep+home_time_h_um*(1-0.5)+divorce_cost_h*M_minus_1;
    }
    else
    {
        UC_H_S5 = 0;
    }

    float UC_H_S6 = -9999;
    float UC_H_S7 = HS_UTILITY; // in school-no leisure, no income, but utility from schooling+increase future value

    // marriage options:// first index wife, second husband
    float UC_H_M1;
    float UC_H_M2;
    if (capacity_h == 1)
    {
        UC_H_M1 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ef),alpha0)+
            alpha3_m_h*children_utility_married_ue_ef+home_time_h_m;
        UC_H_M2 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ef),alpha0)+
            alpha3_m_h*children_utility_married_ue_ef+home_time_h_m+preg_utility_m;
    }
    else
    {
        UC_H_M1 = 0;
        UC_H_M2 = 0;
    }

    float UC_H_M3;
    float UC_H_M4;
    if (capacity_h == 0.5)
    {
        UC_H_M3 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ep),alpha0)+
            ((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_m_h*children_utility_married_ue_ep+home_time_h_m*0.5;
        UC_H_M4 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ep),alpha0)+
            ((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_m_h*children_utility_married_ue_ep+home_time_h_m*0.5+preg_utility_m;
    }
    else
    {
        UC_H_M3 = 0;
        UC_H_M4 = 0;
    }

    float UC_H_M5;
    float UC_H_M6;
    if (capacity_w == 1)  //to avoid division by zero
    {
        UC_H_M5 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ue),alpha0)+
            ((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)    +alpha3_m_h*children_utility_married_ef_ue+home_time_h_m;
        UC_H_M6 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ue),alpha0)+
            ((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)    +alpha3_m_h*children_utility_married_ef_ue+home_time_h_m+preg_utility_m;
    }
    else
    {
        UC_H_M5 = 0;
        UC_H_M6 = 0;
    }

    float UC_H_M7 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ue),alpha0)+
        ((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_h*children_utility_married_ep_ue+home_time_h_m;
    float UC_H_M8 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ue),alpha0)+
        ((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_h*children_utility_married_ep_ue+home_time_h_m+preg_utility_m;

    float UC_H_M9, UC_H_M12, UC_H_M13, UC_H_M16;
    if (capacity_h == 1)  //to avoid division by zero
    {
        // in 9 and in 12 and 13 and 16 the husband works full time
        UC_H_M9 =  Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ef),alpha0)+alpha3_m_h*children_utility_married_ef_ef;
        UC_H_M12 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ef),alpha0)+alpha3_m_h*children_utility_married_ep_ef;
        UC_H_M13 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ef),alpha0)+alpha3_m_w*children_utility_married_ef_ef+preg_utility_m;
        UC_H_M16 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ef),alpha0)+alpha3_m_w*children_utility_married_ep_ef+preg_utility_m;
    }
    else
    {
        UC_H_M9 = 0;
        UC_H_M12 = 0;
        UC_H_M13 = 0;
        UC_H_M16 = 0;
    }

    float UC_H_M10, UC_H_M11, UC_H_M14, UC_H_M15;
    if (capacity_h == 0.5)  //to avoid division by zero
    {
        // in 10 and in 11 and 14 and 15 the husband works part time
        UC_H_M10 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ep),alpha0)+
            ((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_m_h*children_utility_married_ef_ep+home_time_h_m*0.5;
        UC_H_M11 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ep),alpha0)+
            ((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_m_h*children_utility_married_ep_ep+home_time_h_m*0.5;
        UC_H_M14 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ef_ep),alpha0)+
            ((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_m_h*children_utility_married_ef_ep+home_time_h_m*0.5+preg_utility_m;
        UC_H_M15 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ep_ep),alpha0)+
            ((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1-0.5),alpha2)+alpha3_m_h*children_utility_married_ep_ep+home_time_h_m*0.5+preg_utility_m;
    }
    else
    {
        UC_H_M10 = 0;
        UC_H_M11 = 0;
        UC_H_M14 = 0;
        UC_H_M15 = 0;
    }

    float UC_H_M17 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ue),alpha0)+
        ((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_h*children_utility_married_ue_ue+home_time_h_m;
    float UC_H_M18 = Q_UTILITY+(1/alpha0)*pow((scale*budget_c_married_ue_ue),alpha0)+
        ((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*pow((1),alpha2)+alpha3_m_h*children_utility_married_ue_ue+home_time_h_m+preg_utility_m;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    float U_W[26];
    float U_H[26];

    if (age == TERMINAL)
    {
        //  t1_w  - HSG;t2_w - SC;t3_w - CG;t4_w  - PC;t5_w- exp wife;t6_w -schooling husband if married - HSD;t7_w - HSG;t8_w - SC;t9_w - CG;t10_w - PC
        //  t11_w - exp husband if married ;t12_w -mrtial status;t13_w - number of children;t14_w - match quality if married;t15_w - number of children if married
        //  t16_w - previous work state - wife
        if (M_minus_1 == 1)  //need this if in order to control children, if already married only common kids otherwise W_N and H_N
        {
            U_W[1]= UC_W_S1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*C_N;
            U_W[2]= -99999;//UC_W_S2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*C_N;  //can't get pregnant at 65
            U_W[3]= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; //one more year of experience
            U_W[4]= -99999;//UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; //3 & 4 are the same since can't get pregnant at 65
            U_W[5]= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t13_w*C_N+t16_w; //one more year of experience
            U_W[6]= -99999;//UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; //3 & 4 are the same since can't get pregnant at 65
            U_W[7]= -99999;//UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; // can't go to school at 65

            U_W[8]= UC_W_M1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[9]= -99999;//UC_W_M2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[10]= UC_W_M3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[11]= -99999;//UC_W_M4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;

            U_W[12]= UC_W_M5+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[13]= -99999;//UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[14]= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[15]= -99999;//UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;

            U_W[16]= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[17]= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[18]= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[19]= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[20]= -99999;//UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[21]= -99999;//UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[22]= -99999;//UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
            U_W[23]= -99999;//UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[24]= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
            U_W[25]= -99999;//UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;

            U_H[1]= UC_H_S1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*C_N;
            U_H[2]= -99999;//UC_H_S2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*C_N;  //can't get pregnant at 65
            U_H[3]= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; //one more year of experience
            U_H[4]= -99999;//UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; //3 & 4 are the same since can't get pregnant at 65
            U_H[5]= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t13_h*C_N+t16_h; //one more year of experience
            U_H[6]= -99999;//UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; //3 & 4 are the same since can't get pregnant at 65
            U_H[7]= -99999;//UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; // can't go to school at 65

            U_H[8]= UC_H_M1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[9]= -99999;//UC_H_M2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(HK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[10]= UC_H_M3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[11]= -99999;//UC_H_M4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;

            U_H[12]= UC_H_M5+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[13]= -99999;//UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[14]= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[15]= -99999;//UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;

            U_H[16]= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[17]= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[18]= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[19]= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[20]= -99999;//UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[21]= -99999;//UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[22]= -99999;//UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
            U_H[23]= -99999;//UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[24]= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
            U_H[25]= -99999;//UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;

        }
        else if (M_minus_1 == 0)//need this if in order to control children, 	since single must use W_N and H_N
        {
            U_W[1]= UC_W_S1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*W_N;
            U_W[2]= -99999;//UC_W_S2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*W_N;  //can't get pregnant at 65
            U_W[3]= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; //one more year of experience
            U_W[4]= -99999;//UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; //3 & 4 are the same since can't get pregnant at 65
            U_W[5]= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t13_w*W_N+t16_w; //one more year of experience
            U_W[6]= -99999;//UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; //3 & 4 are the same since can't get pregnant at 65
            U_W[7]= -99999;//UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; // can't go to school at 65

            U_W[8]= UC_W_M1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[9]= -99999;//UC_W_M2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[10]= UC_W_M3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[11]= -99999;//UC_W_M4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;

            U_W[12]= UC_W_M5+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[13]= -99999;//UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[14]= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[15]= -99999;//UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;

            U_W[16]= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[17]= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[18]= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[19]= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[20]= -99999;//UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[21]= -99999;//UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[22]= -99999;//UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
            U_W[23]= -99999;//UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[24]= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
            U_W[25]= -99999;//UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;

            U_H[1]= UC_H_S1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*H_N;
            U_H[2]= -99999;//UC_H_S2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*H_N;  //can't get pregnant at 65
            U_H[3]= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; //one more year of experience
            U_H[4]= -99999;//UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; //3 & 4 are the same since can't get pregnant at 65
            U_H[5]= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t13_h*H_N+t16_h; //one more year of experience
            U_H[6]= -99999;//UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; //3 & 4 are the same since can't get pregnant at 65
            U_H[7]= -99999;//UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; // can't go to school at 65

            U_H[8]= UC_H_M1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[9]= -99999;//UC_H_M2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(HK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[10]= UC_H_M3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[11]= -99999;//UC_H_M4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;

            U_H[12]= UC_H_M5+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[13]= -99999;//UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[14]= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[15]= -99999;//UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;

            U_H[16]= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[17]= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[18]= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[19]= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[20]= -99999;//UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[21]= -99999;//UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[22]= -99999;//UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
            U_H[23]= -99999;//UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[24]= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
            U_H[25]= -99999;//UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        }   // MARRIED AND NOT MARRIED
        else
        {   // t is not the terminal period so add EMAX
            // t - time 17-65
            // HS,WS - schooling - 5 levels grid
            // HK, WK - experience - 5 level grid
            // C_N, H_N , W_N - number of children - 4 level grid
            // H_HEALTH,W_HEALTH - health - 3 level drid
            // H_L, W_L - taste for leisure - 3 level grid
            // ability_h_index,ability_w_index - 3 level grid
            // prev_state_h,prev_state_w - work at t-1 - 3 level grid
            // PE_H, PE_W - parents education - 2 levels grid
            // p_minus_1 - pregnancy at t-1, always zero for single men
            // EMAX_M_UM(t,HS,HK,C_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, p_minus_1)
            // EMAX_W_UM(t,WS,WK,C_N,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, p_minus_1)
            // EMAX_M_M(t,WS,WK,C_N,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, p_minus_1, HS,HK,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
            // EMAX_W_M(t,WS,WK,C_N,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, p_minus_1, HS,HK,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
            // need to take care of experience and number of children when calling the EMAX:
            // if women is pregnant, add 1 to the number of children unless the number is already 4

            if (C_N == 0)
            {
                C_N = W_N + H_N;
            }
            unsigned C_N_1 = C_N + 1; //number of children at t+1 if pregnant at t
            if (C_N_1 > 3)	//keep # of children smaller than 3
            {
                C_N_1 = 3;
            }
            unsigned W_N_1 = W_N +1;  // number of children at t+1 if pregnant at t
            if (W_N_1 > 3)//keep # of children smaller than 3
            {
                W_N_1 = 3;
            }
            // if the individual is employed, update the k index and choose the right interpolation 
            interpolation_result_t interpolation_result;

            interpolation_result = interpolation(WK);
            unsigned ind1 = interpolation_result.ind1;
            unsigned ind2 = interpolation_result.ind2;
            float w1 = interpolation_result.weight1;
            float w2 = interpolation_result.weight2;

            interpolation_result = interpolation(WK+1);
            unsigned ind1_1 = interpolation_result.ind1;
            unsigned ind2_1 = interpolation_result.ind2;
            float w1_1 = interpolation_result.weight1;
            float w2_1 = interpolation_result.weight2;

            interpolation_result = interpolation(WK+0.5);
            unsigned ind1_2 = interpolation_result.ind1;
            unsigned ind2_2 = interpolation_result.ind2;
            float w1_2 = interpolation_result.weight1;
            float w2_2 = interpolation_result.weight2;

            interpolation_result = interpolation(HK);
            unsigned inh1 = interpolation_result.ind1;
            unsigned inh2 = interpolation_result.ind2;
            float h1 = interpolation_result.weight1;
            float h2 = interpolation_result.weight2;

            interpolation_result = interpolation(HK+1);
            unsigned inh1_1 = interpolation_result.ind1;
            unsigned inh2_1 = interpolation_result.ind2;
            float h1_1 = interpolation_result.weight1;
            float h2_1 = interpolation_result.weight2;

            interpolation_result = interpolation(HK+0.5);
            unsigned inh1_2 = interpolation_result.ind1;
            unsigned inh2_2 = interpolation_result.ind2;
            float h1_2 = interpolation_result.weight1;
            float h2_2 = interpolation_result.weight2;

            //////////////////////////////////////////////////////////////////////////////
            // add EMAX to women's utility 
            //////////////////////////////////////////////////////////////////////////////

            unsigned W_L;
            unsigned ability_w_index;
            unsigned prev_state_w;
            unsigned PE_W;
            unsigned H_L;
            unsigned ability_h_index;
            unsigned prev_state_h;
            unsigned PE_H;


            U_W[1] = UC_W_S1+  w1*EMAX_W_UM(t,WS,ind1  ,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0)
                +(1-w1)*EMAX_W_UM(t,WS,ind2  ,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0);

            U_W[2] = UC_W_S2+  w1*EMAX_W_UM(t,WS,ind1  ,W_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1)
                +(1-w1)*EMAX_W_UM(t,WS,ind2  ,W_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1);

            U_W[3] = UC_W_S3+  w1_1*EMAX_W_UM(t,WS,ind1_1,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0)
                +(1-w1_1)*EMAX_W_UM(t,WS,ind2_1,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0);

            U_W[4] = UC_W_S4+  w1_1*EMAX_W_UM(t,WS,ind1_1,W_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1)
                +(1-w1_1)*EMAX_W_UM(t,WS,ind2_1,W_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1);

            U_W[5] = UC_W_S5+  w1_2*EMAX_W_UM(t,WS,ind1_2,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0)
                +(1-w1_2)*EMAX_W_UM(t,WS,ind2_2,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0);

            U_W[6] = UC_W_S6+  w1_2*EMAX_W_UM(t,WS,ind1_2,W_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1)
                +(1-w1_2)*EMAX_W_UM(t,WS,ind2_2,W_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1);

            U_W[7] = UC_W_S7+  w1*EMAX_W_UM(t,WS,ind1,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0)
                +(1-w1)*EMAX_W_UM(t,WS,ind2,W_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0);

            U_W[8] = UC_W_M1+  w1*EMAX_W_M(t,WS,ind1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1)*EMAX_W_M(t,WS,ind2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[9] = UC_W_M2+  w1*EMAX_W_M(t,WS,ind1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1)*EMAX_W_M(t,WS,ind2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[10]= UC_W_M3+  w1*EMAX_W_M(t,WS,ind1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1)*EMAX_W_M(t,WS,ind2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[11]= UC_W_M4+  w1*EMAX_W_M(t,WS,ind1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1)*EMAX_W_M(t,WS,ind2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[12]= UC_W_M5+w1_1*EMAX_W_M(t,WS,ind1_1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_1)*EMAX_W_M(t,WS,ind2_1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[13]= UC_W_M6+w1_1*EMAX_W_M(t,WS,ind1_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_1)*EMAX_W_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[14]= UC_W_M7+w1_2*EMAX_W_M(t,WS,ind1_2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_2)*EMAX_W_M(t,WS,ind2_2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[15]= UC_W_M8+w1_2*EMAX_W_M(t,WS,ind1_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_2)*EMAX_W_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[16]= UC_W_M9+w1_1*EMAX_W_M(t,WS,ind1_1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_1)*EMAX_W_M(t,WS,ind2_1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[17]= UC_W_M10+w1_1*EMAX_W_M(t,WS,ind1_1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_1)*EMAX_W_M(t,WS,ind2_1,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[18]= UC_W_M11+w1_2*EMAX_W_M(t,WS,ind1_2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_2)*EMAX_W_M(t,WS,ind2_2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[19]= UC_W_M12+w1_2*EMAX_W_M(t,WS,ind1_2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_2)*EMAX_W_M(t,WS,ind2_2,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[20]= UC_W_M13+w1_1*EMAX_W_M(t,WS,ind1_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_1)*EMAX_W_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[21]= UC_W_M14+w1_1*EMAX_W_M(t,WS,ind1_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_1)*EMAX_W_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[22]= UC_W_M15+w1_2*EMAX_W_M(t,WS,ind1_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_2)*EMAX_W_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[23]= UC_W_M16+w1_2*EMAX_W_M(t,WS,ind1_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1_2)*EMAX_W_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[24]= UC_W_M17+  w1*EMAX_W_M(t,WS,ind1  ,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1)*EMAX_W_M(t,WS,ind2  ,C_N  ,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_W[25]= UC_W_M18+  w1*EMAX_W_M(t,WS,ind1  ,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY)
                +(1-w1)*EMAX_W_M(t,WS,ind2  ,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);


            //////////////////////////////////////////////////////////////////////////////
            //                          add EMAX to men's utility                     
            //////////////////////////////////////////////////////////////////////////////
            U_H[1]= UC_H_S1  +h1*EMAX_M_UM(t,HS,inh1,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0)
                +(1-h1)*EMAX_M_UM(t,HS,inh2,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0);
            U_H[2]= -99999;
            U_H[3]= UC_H_S3  +h1_1*EMAX_M_UM(t,HS,inh1_1,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0)
                +(1-h1_1)*EMAX_M_UM(t,HS,inh2_1,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0); 
            U_H[4]= -99999;
            U_H[5]= UC_H_S5  +h1_2*EMAX_M_UM(t,HS,inh1_2,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0)
                +(1-h1_2)*EMAX_M_UM(t,HS,inh2_2,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0); 
            U_H[6]= -99999;
            U_H[7]= UC_H_S7    +h1*EMAX_M_UM(t,HS,inh1,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0)
                +(1-h1)*EMAX_M_UM(t,HS,inh2,H_N,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H, 0); 
            U_H[8] = UC_H_M1 +h1_1*EMAX_M_M(t,WS,ind2,  C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_1)*EMAX_M_M(t,WS,ind2,  C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[9] = UC_H_M2 +h1_1*EMAX_M_M(t,WS,ind2,  C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_1)*EMAX_M_M(t,WS,ind2,  C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[10]= UC_H_M3 +h1_2*EMAX_M_M(t,WS,ind2,  C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_2)*EMAX_M_M(t,WS,ind2,  C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[11]= UC_H_M4 +h1_2*EMAX_M_M(t,WS,ind2,  C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_2)*EMAX_M_M(t,WS,ind2,  C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[12]= UC_H_M5   +h1*EMAX_M_M(t,WS,ind2_1,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1)*EMAX_M_M(t,WS,ind2_1,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[13]= UC_H_M6   +h1*EMAX_M_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1)*EMAX_M_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY); 

            U_H[14]= UC_H_M7   +h1*EMAX_M_M(t,WS,ind2_2,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1)*EMAX_M_M(t,WS,ind2_2,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[15]= UC_H_M8   +h1*EMAX_M_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1)*EMAX_M_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[16]= UC_H_M9 +h1_1*EMAX_M_M(t,WS,ind2_1,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_1)*EMAX_M_M(t,WS,ind2_1,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[17]= UC_H_M10+h1_2*EMAX_M_M(t,WS,ind2_1,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_2)*EMAX_M_M(t,WS,ind2_1,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[18]= UC_H_M11+h1_2*EMAX_M_M(t,WS,ind2_2,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_2)*EMAX_M_M(t,WS,ind2_2,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[19]= UC_H_M12+h1_1*EMAX_M_M(t,WS,ind2_2,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_1)*EMAX_M_M(t,WS,ind2_2,C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[20]= UC_H_M13 +h1_1*EMAX_M_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_1)*EMAX_M_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[21]= UC_H_M14+h1_2*EMAX_M_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_2)*EMAX_M_M(t,WS,ind2_1,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[22]= UC_H_M15+h1_2*EMAX_M_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_2)*EMAX_M_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[23]= UC_H_M16+h1_1*EMAX_M_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1_1)*EMAX_M_M(t,WS,ind2_2,C_N_1,W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2_1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[24]= UC_H_M17  +h1*EMAX_M_M(t,WS,ind2,  C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1)*EMAX_M_M(t,WS,ind2,  C_N,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 0, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

            U_H[25]= UC_H_M18  +h1*EMAX_M_M(t,WS,ind2,C_N_1,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh1,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);
            +(1-h1)*EMAX_M_M(t,WS,ind2,C_N_1,  W_HEALTH,W_L,ability_w_index,prev_state_w,PE_W, 1, HS,inh2,H_HEALTH,H_L,ability_h_index,prev_state_h,PE_H,Q_UTILITY);

        }

        // delete impossible options - no job offer FULL wife
        if (CHOOSE_WORK_F_w == 0)
        {
            U_W[3]= -99999;
            U_W[4] = -99999;
            U_W[7+5] = -99999;U_H[7+6] = -99999;
            U_W[7+9] = -99999;U_H[7+10] = -99999;
            U_W[7+13] = -99999;U_H[7+14] = -99999;
        }
        // delete impossible options - no job offer PART wife
        if (CHOOSE_WORK_P_w == 0)
        {
            U_W[5]= -99999;
            U_W[6] = -99999;
            U_W[7+3] = -99999;U_H[7+4] = -99999;
            U_W[7+10] = -99999;U_H[7+11] = -99999;
            U_W[7+14] = -99999;U_H[7+15] = -99999;
        }
        // delete impossible options - no job offer full husband
        if (CHOOSE_WORK_F_h == 0)
        {
            U_H[3] = -99999;
            U_H[4] = -99999;
            U_H[7+1] = -99999;U_W[7+2] = -99999;
            U_H[7+9] = -99999;U_W[7+12] = -99999;
            U_H[7+13] = -99999;U_W[7+16] = -99999;
        }
        // delete impossible options - no job offer PART husband
        if (CHOOSE_WORK_P_h == 0)
        {
            U_H[5] = -99999;
            U_H[6] = -99999;
            U_H[7+3] = -99999;U_W[7+4] = -99999;
            U_H[7+10] = -99999;U_W[7+11] = -99999;
            U_H[7+14] = -99999;U_W[7+15] = -99999;
        }
        // delete impossible options - no marriage offer wife
        if (M_minus_1 == 0 &&  CHOOSE_HUSBAND == 0)
        {
            U_H[7+1] = -99999;U_W[7+1] = -99999;U_H[1] = -99999;
            U_H[7+2] = -99999;U_W[7+2] = -99999;U_H[2] = -99999;
            U_H[7+3] = -99999;U_W[7+3] = -99999;U_H[3] = -99999;
            U_H[7+4] = -99999;U_W[7+4] = -99999;U_H[4] = -99999;
            U_H[7+5] = -99999;U_W[7+5] = -99999;U_H[5] = -99999;
            U_H[7+6] = -99999;U_W[7+6] = -99999;U_H[6] = -99999;
            U_H[7+7] = -99999;U_W[7+7] = -99999;U_H[7] = -99999;
            U_H[7+8] = -99999;U_W[7+8] = -99999;
            U_H[7+9] = -99999;U_W[7+9] = -99999;
            U_H[7+10] = -99999;U_W[7+10] = -99999;
            U_H[7+11] = -99999;U_W[7+11] = -99999;
            U_H[7+12] = -99999;U_W[7+12] = -99999;
            U_H[7+13] = -99999;U_W[7+13] = -99999;
            U_H[7+14] = -99999;U_W[7+14] = -99999;
            U_H[7+15] = -99999;U_W[7+15] = -99999;
            U_H[7+16] = -99999;U_W[7+16] = -99999;
            U_H[7+17] = -99999;U_W[7+17] = -99999;
            U_H[7+18] = -99999;U_W[7+18] = -99999;
        }
        // delete impossible options - no marriage offer wife
        if (CHOOSE_WIFE == 0) // this condition only hold when solving backwards for single men. all other options, i.e. solving forward or solving for married/unmarried women, CHOOSE_WIFE==1
        {
            U_H[7+1] = -99999;U_W[7+1] = -99999;U_W[1] = -99999;
            U_H[7+2] = -99999;U_W[7+2] = -99999;U_W[2] = -99999;
            U_H[7+3] = -99999;U_W[7+3] = -99999;U_W[3] = -99999;
            U_H[7+4] = -99999;U_W[7+4] = -99999;U_W[4] = -99999;
            U_H[7+5] = -99999;U_W[7+5] = -99999;U_W[5] = -99999;
            U_H[7+6] = -99999;U_W[7+6] = -99999;U_W[6] = -99999;
            U_H[7+7] = -99999;U_W[7+7] = -99999;U_W[7] = -99999;
            U_H[7+8] = -99999;U_W[7+8] = -99999;
            U_H[7+9] = -99999;U_W[7+9] = -99999;
            U_H[7+10] = -99999;U_W[7+10] = -99999;
            U_H[7+11] = -99999;U_W[7+11] = -99999;
            U_H[7+12] = -99999;U_W[7+12] = -99999;
            U_H[7+13] = -99999;U_W[7+13] = -99999;
            U_H[7+14] = -99999;U_W[7+14] = -99999;
            U_H[7+15] = -99999;U_W[7+15] = -99999;
            U_H[7+16] = -99999;U_W[7+16] = -99999;
            U_H[7+17] = -99999;U_W[7+17] = -99999;
            U_H[7+18] = -99999;U_W[7+18] = -99999;
        }
        // delete impossible options - no schooling
        if ( M_minus_1 == 1 || divorce == 1 || age > 30 || C_N > 0 || W_N > 0 || WS == 5)
        {
            U_W[7] = -99999;
        }
        if ( M_minus_1 == 1 ||  age > 30 || C_N > 0 ||  H_N > 0 || HS == 5)
        {
            U_H[7] = -99999;
        }
        // delete impossible options - no pregnancy
        if ( age > 40 || C_N >3 || W_N > 3 )
        {
            U_W[2] = -99999;U_W[4] = -99999;U_W[6] = -99999;
            U_H[7+2] = -99999;U_W[7+2] = -99999;
            U_H[7+4] = -99999;U_W[7+4] = -99999;
            U_H[7+6] = -99999;U_W[7+6] = -99999;
            U_H[7+8] = -99999;U_W[7+8] = -99999;
            U_H[7+13] = -99999;U_W[7+13] = -99999;
            U_H[7+14] = -99999;U_W[7+14] = -99999;
            U_H[7+15] = -99999;U_W[7+15] = -99999;
            U_H[7+16] = -99999;U_W[7+16] = -99999;
            U_H[7+18] = -99999;U_W[7+18] = -99999;
        }
    }

    calculate_utility_result_t result;

    memcpy(result.U_H, U_H, 26);
    memcpy(result.U_W, U_W, 26);

    return result;
}

