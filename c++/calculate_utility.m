function [U_W , U_H ]= calculate_utility(cohort,cb_const, cb_per_child,W_N,H_N,C_N, wage_full_w, wage_part_w, wage_full_h, wage_part_h, capacity_w, capacity_h, M_minus_1, W_HEALTH, H_HEALTH, P_minus_1, epsilon_f, draw_f, t, Q_UTILITY ,HS_UTILITY, WS_UTILITY, home_time_h_m,...
          home_time_h_um , home_time_w,	CHOOSE_WORK_F_h, CHOOSE_WORK_P_h, CHOOSE_WORK_F_w, CHOOSE_WORK_P_w, divorce, age, CHOOSE_HUSBAND, CHOOSE_WIFE, WS, HS, W_HSD, W_HSG,W_SC,W_CG,W_PC, WK, H_HSD, H_HSG, H_SC,H_CG,H_PC, HK, tax_brackets, deductions_exemptions, HP)
global unemp_w; global unemp_h;  global row0; global row1; global row2; global row3; global sigma; 
global eta1; global eta2; global eta3; global eta4; global pai1; global pai2; global pai3; global pai4;
global alpha0 ;global alpha11_w ;global alpha12_w ;global alpha13_w ;global alpha12_h ;global alpha13_h ;global alpha2 ;global alpha3_m_w ;global alpha3_s_w ;global alpha3_m_h ;global alpha3_s_h ;
global alpha41 ;global alpha42 ;global alpha43 ;global alpha44 ;
global t1_w; global t2_w; global t3_w; global t4_w;global t5_w; global t6_w;global t7_w; global t8_w;global t9_w; global t10_w; global t11_w; global t12_w;global t13_w; global t14_w; global t15_w; global t16_w;
global t1_h; global t2_h; global t3_h; global t4_h;global t5_h; global t6_h;global t7_h; global t8_h;global t9_h; global t10_h; global t11_h; global t12_h;global t13_h; global t14_h; global t15_h; global t16_h;
global EMAX; global scale; global TERMINAL;
% net income
if cohort == 1
    year = 1945 +15 + t;
elseif cohort == 2
    year = 1955 +15 + t;
elseif cohort == 3
    year = 1965 +15 + t;
end
if (W_N==0)
    net_income_single_w_ue   = unemp_w;
else
    net_income_single_w_ue   = unemp_w+cb_const+cb_per_child*(W_N-1);
end    
net_income_single_w_ef    =         gross_to_net(W_N, 0 , 0 , wage_full_w, 0     , 0 ,year, tax_brackets, deductions_exemptions);
net_income_single_w_ep    =         gross_to_net(W_N, 0 , 0 , wage_part_w, 0     , 0 ,year, tax_brackets, deductions_exemptions);
net_income_single_h_ue   = unemp_h;
net_income_single_h_ef    =         gross_to_net( 0 ,H_N, 0 ,     0 , wage_full_h, 0 ,year, tax_brackets, deductions_exemptions);
net_income_single_h_ep    =         gross_to_net( 0 ,H_N, 0 ,     0 , wage_part_h, 0 ,year, tax_brackets, deductions_exemptions);
% first index wife, second husband
net_income_married_ue_ue = unemp_h+unemp_w;
net_income_married_ue_ef  = unemp_w+gross_to_net(W_N ,H_N ,C_N,     0 , wage_full_h, 1 ,year, tax_brackets, deductions_exemptions);% if married, C_N is # of children, if consider geting married, # of children is W_N+H_N
net_income_married_ue_ep  = unemp_w+gross_to_net(W_N ,H_N ,C_N,     0 , wage_part_h, 1 ,year, tax_brackets, deductions_exemptions);% if married, C_N is # of children, if consider geting married, # of children is W_N+H_N
net_income_married_ef_ue  = unemp_h+gross_to_net(W_N, H_N ,C_N,wage_full_w ,  0    , 1 ,year, tax_brackets, deductions_exemptions);
net_income_married_ep_ue  = unemp_h+gross_to_net(W_N, H_N ,C_N,wage_part_w ,  0    , 1 ,year, tax_brackets, deductions_exemptions);
net_income_married_ef_ef   =         gross_to_net(W_N, H_N ,C_N,wage_full_w ,wage_full_h , 1 ,year, tax_brackets, deductions_exemptions);
net_income_married_ef_ep   =         gross_to_net(W_N, H_N ,C_N,wage_full_w ,wage_part_h , 1 ,year, tax_brackets, deductions_exemptions);
net_income_married_ep_ep   =         gross_to_net(W_N, H_N ,C_N,wage_part_w ,wage_part_h , 1 ,year, tax_brackets, deductions_exemptions);
net_income_married_ep_ef   =         gross_to_net(W_N, H_N ,C_N,wage_part_w ,wage_full_h , 1 ,year, tax_brackets, deductions_exemptions);

% budget constraint
eta = 0;
if (C_N == 0)
    eta = 0;
elseif (C_N == 1	)
    eta = eta1; %this is the fraction of parent's income that one child gets
elseif (C_N == 2)
    eta = eta2;
elseif (C_N == 3)
    eta = eta3;
elseif (C_N == 4)
    eta = eta4;
else
    error(0);
end	
eta_w = 0;
if (W_N == 0)
    eta_w = 0;
elseif (W_N == 1)	
    eta_w = eta1; %this is the fraction of parent's income that one child gets
elseif (W_N == 2)
    eta_w = eta2;
elseif (W_N == 3)
    eta_w = eta3;
elseif (W_N == 4)
    eta_w = eta4;
else
    error(0);
end	
eta_h = 0;
if (H_N == 0)
    eta_h = 0;
elseif (H_N == 1)	
    eta_h = eta1; %this is the fraction of parent's income that one child gets
elseif (H_N == 2)
    eta_h = eta2;
elseif (H_N == 3)
    eta_h = eta3;
elseif (H_N == 4)
    eta_h = eta4;
else
    error(0);
end	
budget_c_single_w_ue   = (1-eta_w)*net_income_single_w_ue;
budget_c_single_w_ef    = (1-eta_w)*net_income_single_w_ef;
budget_c_single_w_ep    = (1-eta_w)*net_income_single_w_ep;
budget_c_single_h_ue   = (1-eta_h)*net_income_single_h_ue;
budget_c_single_h_ef    = (1-eta_h)*net_income_single_h_ef  ;
budget_c_single_h_ep    = (1-eta_h)*net_income_single_h_ep  ;
% first index wife, second husband
budget_c_married_ue_ue = (1-eta)*(net_income_married_ue_ue);
budget_c_married_ue_ef  = (1-eta)*(net_income_married_ue_ef);
budget_c_married_ue_ep  = (1-eta)*(net_income_married_ue_ep);
budget_c_married_ef_ue  = (1-eta)*(net_income_married_ef_ue);
budget_c_married_ep_ue  = (1-eta)*(net_income_married_ep_ue);
budget_c_married_ef_ef   = (1-eta)*(net_income_married_ef_ef);
budget_c_married_ef_ep   = (1-eta)*(net_income_married_ef_ep);
budget_c_married_ep_ep   = (1-eta)*(net_income_married_ep_ep);
budget_c_married_ep_ef   = (1-eta)*(net_income_married_ep_ef);
divorce_cost_w=alpha41+alpha43*C_N;
divorce_cost_h=alpha42+alpha44*C_N;

% utility from quality and quality of children: %row0 - CES  parameter; row1 - women leisure; row2 - husband leisure; row3 -income
if (W_N > 0)
    children_utility_single_w_ue  = (row1*((1-HP)^row0)     +row3*((eta1*net_income_single_w_ue)^row0)+(1-row1-row2-row3)*((W_N)^row0))^(1/row0);
    children_utility_single_w_ef  = (                        row3*((eta1*net_income_single_w_ef)^row0)+(1-row1-row2-row3)*((W_N)^row0))^(1/row0);
    children_utility_single_w_ep  = (row1*((1-0.5-HP)^row0)+ row3*((eta1*net_income_single_w_ep)^row0)+(1-row1-row2-row3)*((W_N)^row0))^(1/row0);
elseif (W_N ==0)
    children_utility_single_w_ue  = 0;
    children_utility_single_w_ef  = 0;
    children_utility_single_w_ep  = 0;
end
if (H_N > 0)
    children_utility_single_h_ue  = (row2*((1-HP)^row0)    +row3*((eta1*net_income_single_h_ue)^row0)+(1-row1-row2-row3)*((H_N)^row0))^(1/row0);
    children_utility_single_h_ef  = (                       row3*((eta1*net_income_single_h_ef)^row0)+(1-row1-row2-row3)*((H_N)^row0))^(1/row0);
    children_utility_single_h_ep  = (row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_single_h_ep)^row0)+(1-row1-row2-row3)*((H_N)^row0))^(1/row0);
elseif (H_N ==0)
    children_utility_single_h_ue  = 0;
    children_utility_single_h_ef  = 0;
    children_utility_single_h_ep = 0;
end
% I assume that each kid get 20% (eta1). if the family has 2 kids, each gets 20%, yet the total is 32% (eta2) since part is common
if (M_minus_1 == 1)
    if (C_N > 0)
% first index wife, second husband
        children_utility_married_ue_ue =  (row1*((1-HP)^row0)    + row2*((1-HP)^row0)    +row3*((eta1*net_income_married_ue_ue)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ue_ef  = (row1*((1-HP)^row0)    +                        row3*((eta1*net_income_married_ue_ef)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ue_ep  = (row1*((1-HP)^row0)    + row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_married_ue_ep)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ef_ue  = (                      + row2*((1-HP)^row0)    +row3*((eta1*net_income_married_e_ue)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ep_ue  = (row1*((1-0.5-HP)^row0)+ row2*((1-HP)^row0)    +row3*((eta1*net_income_married_e_ue)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ef_ef   =(                                               row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ef_ep   =(                      + row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ep_ep   =(row1*((1-0.5-HP)^row0)+ row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
        children_utility_married_ep_ef   =(row1*((1-0.5-HP)^row0)+                        row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((C_N)^row0))^(1/row0);
    elseif (C_N == 0)
        children_utility_married_ue_ue = 0;
        children_utility_married_ue_ef  = 0;
        children_utility_married_ue_ep  = 0;
        children_utility_married_ef_ue  = 0;
        children_utility_married_ep_ue  = 0;
        children_utility_married_ef_ef = 0;
        children_utility_married_ef_ep = 0;
        children_utility_married_ep_ep = 0;
        children_utility_married_ep_ef = 0;
    end
    % utility from pregnancy when married / utility from pregnancy when SINGLE
    preg_utility_m =         pai2*W_HEALTH+pai3*(C_N)+pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
    preg_utility_um = pai1 + pai2*W_HEALTH+pai3*(C_N)+pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
else 
    if (W_N+H_N> 0)	
% first index wife, second husband
        children_utility_married_ue_ue = (row1*((1-HP)^row0)    + row2*((1-HP)^row0)    +row3*((eta1*net_income_married_ue_ue)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ue_ef  =(row1*((1-HP)^row0)    +                       +row3*((eta1*net_income_married_ue_e)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ue_ep  =(row1*((1-HP)^row0)    + row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_married_ue_e)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ef_ue  =(row2*((1-HP)^row0)                            +row3*((eta1*net_income_married_e_ue)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ep_ue  =(row1*((1-0.5-HP)^row0)+ row2*((1-HP)^row0)    +row3*((eta1*net_income_married_e_ue)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ef_ef  =(                                               row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ef_ep  =(                        row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ep_ep  =(row1*((1-0.5-HP)^row0)+ row2*((1-0.5-HP)^row0)+row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);
        children_utility_married_ep_ef  =(row1*((1-0.5-HP)^row0)+                       +row3*((eta1*net_income_married_e_e)^row0)+(1-row1-row2-row3)*((W_N+H_N)^row0))^(1/row0);

    elseif (W_N+H_N == 0)
        children_utility_married_ue_ue = 0;
        children_utility_married_ue_ef  = 0;
        children_utility_married_ue_ep  = 0;
        children_utility_married_ef_ue  = 0;
        children_utility_married_ep_ue  = 0;
        children_utility_married_ef_ef = 0;
        children_utility_married_ef_ep = 0;
        children_utility_married_ep_ep = 0;
        children_utility_married_ep_ef = 0;
    end
    % utility from pregnancy when married / utility from pregnancy when SINGLE
    preg_utility_um =         pai2*W_HEALTH+pai3*(W_N+H_N)+pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
    preg_utility_m  =  pai1 + pai2*W_HEALTH+pai3*(W_N)    +pai4*P_minus_1 + epsilon_f(draw_f, t, 6)*sigma(8,8);
end
% decision making - choose from up to 13 options, according to CHOOSE_HUSBAND, CHOOSE_WORK, AGE ... values
% utility from each option:
    % single options:		     1-singe+unemployed + non-pregnant 
                    %		     2-singe+unemployed + pregnant - zero for men
                    %            3-singe+employed full + non-pregnant              
                    %            4-singe+employed full+ pregnant   - zero for men
                    %            5-singe+employed part+ non-pregnant              
                    %            6-singe+employed part+ pregnant   - zero for men
                    %            7-schooling: single+ unemployed+non-pregnant+no children 
    % marriage options:% first index wife, second husband
                     %          1-married+women unemployed       +man employed full    +non-pregnant		
                    %   		 2-married+women unemployed      +man employed full    +pregnant		
                    %            3-married+women unemployed      +man employed part    +non-pregnant		
                    %   		 4-married+women unemployed      +man employed part    +pregnant		
                   %             5-married+women employed full   +man unemployed       +non-pregnant			
                    %			 6-married+women employed full   +man unemployed       +pregnant			
                    %            7-married+women employed part   +man unemployed       +non-pregnant			
                    %			 8-married+women employed part   +man unemployed       +pregnant			
                    %            9-married+women employed ful    +man employed fulll   +non-pregnant			
                    %            10-married+women employed full  +man employed part    +non-pregnant			
                    %            11-married+women employed part +man employed part     +non-pregnant			
                    %            12-married+women employed part +man employed full     +non-pregnant			
                    %			 13-married+women employed full +man employed full     +pregnant			
                    %			 14-married+women employed full +man employed part     +pregnant			
                    %			 15-married+women employed part +man employed part     +pregnant			
                    %			 16-married+women employed part +man employed full     +pregnant			
                    %			 17-married+woman unemployed    +men unemployed        +non-pregnant			
                    %			 18-married+woman unemployed    +men unemployed        +pregnant			
% wife current utility from each option:
% Utility parameters 
%		temp1=(1/alpha0)*(budget_c_single_w_ue^alpha0)
%        budget_c_single_w_ue
%        temp2=((alpha12_w*WP+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)
%        WP
%        W_HEALTH
%        temp3=alpha3_s_w*children_utility_single_w_ue
%        home_time_w
%        preg_utility_um

UC_W_S1= (1/alpha0)*(budget_c_single_w_ue^alpha0)+...
         ((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_s_w*children_utility_single_w_ue+home_time_w+divorce_cost_w*M_minus_1;
UC_W_S2= (1/alpha0)*(budget_c_single_w_ue^alpha0)+...
         ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_s_w*children_utility_single_w_ue+home_time_w+preg_utility_um+divorce_cost_w*M_minus_1;
if (capacity_w == 1)  %to avoid division by zero
    UC_W_S3= (1/alpha0)*(budget_c_single_w_ef^alpha0)+...
                  +alpha3_s_w*children_utility_single_w_ef+divorce_cost_w*M_minus_1;
    UC_W_S4= (1/alpha0)*(budget_c_single_w_ef^alpha0)+...
                  +alpha3_s_w*children_utility_single_w_ef+preg_utility_um+divorce_cost_w*M_minus_1;
else
    UC_W_S3= 0;
    UC_W_S4= 0;
end
if (capacity_w ==0.5)   %capacity_w=0.5 
    UC_W_S5= (1/alpha0)*(budget_c_single_w_ep^alpha0)+...
             ((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-0.5)^alpha2)	      +alpha3_s_w*children_utility_single_w_ep+home_time_w*(1-capacity_w)+divorce_cost_w*M_minus_1;
    UC_W_S6= (1/alpha0)*(budget_c_single_w_ep^alpha0)+...
             ((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_s_w*children_utility_single_w_ep+home_time_w*(1-capacity_w)+preg_utility_um+divorce_cost_w*M_minus_1;
else
    UC_W_S5= 0;
    UC_W_S6= 0;
end
UC_W_S7= WS_UTILITY; % in school-no leisure, no income, but utility from schooling+increase future value
    % marriage options:% first index wife, second husband
UC_W_M1=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ef)^alpha0)+((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_w*children_utility_married_ue_ef+home_time_w;
UC_W_M2=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ef)^alpha0)+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_w*children_utility_married_ue_ef+home_time_w+preg_utility_m;
UC_W_M3=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ep)^alpha0)+((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_w*children_utility_married_ue_ep+home_time_w;
UC_W_M4=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ep)^alpha0)+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_w*children_utility_married_ue_ep+home_time_w+preg_utility_m;
if (capacity_w == 1)  %to avoid division by zero
    UC_W_M5= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ue)^alpha0)                                                                  +alpha3_m_w*children_utility_married_ef_ue;
    UC_W_M6= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ue)^alpha0)                                                                  +alpha3_m_w*children_utility_married_ef_ue+preg_utility_m;
else
    UC_W_M5 = 0;
    UC_W_M6 = 0;
end
if (capacity_w == 0.5 )     %capacity_w=0.5 
    UC_W_M7= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ue)^alpha0)+((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-capacity_w)^alpha2)+alpha3_m_w*children_utility_married_ep_ue+home_time_w*(1-capacity_w);
    UC_W_M8= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ue)^alpha0)+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-capacity_w)^alpha2)+alpha3_m_w*children_utility_married_ep_ue+home_time_w*(1-capacity_w)+preg_utility_m;
else
    UC_W_M7 = 0;
    UC_W_M8 = 0;
end
if (capacity_w == 1)  %to avoid division by zero
    UC_W_M9=  Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ef)^alpha0)+alpha3_m_w*children_utility_married_ef_ef;
    UC_W_M10= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ep)^alpha0)+alpha3_m_w*children_utility_married_ef_ep;
else
    UC_W_M9=0;
    UC_W_M10=0;
end
if (capacity_w == 0.5)
    UC_W_M11= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ep)^alpha0)+alpha3_m_w*children_utility_married_ep_ep+((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-0.5)^alpha2)+home_time_w*(1-0.5);
    UC_W_M12= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ef)^alpha0)+alpha3_m_w*children_utility_married_ep_ef+((alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-0.5)^alpha2)+home_time_w*(1-0.5);
else
    UC_W_M11=0;
    UC_W_M12=0;
end
if (capacity_w == 1)  %to avoid division by zero
    UC_W_M13=  Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ef)^alpha0)+alpha3_m_w*children_utility_married_ef_ef+preg_utility_m;
    UC_W_M14= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ep)^alpha0)+alpha3_m_w*children_utility_married_ef_ep+preg_utility_m;
else
    UC_W_M13=0;
    UC_W_M14=0;
end
if (capacity_w == 0.5)
    UC_W_M15= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ep)^alpha0)+alpha3_m_w*children_utility_married_ep_ep+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-0.5)^alpha2)+home_time_w*(1-0.5)+preg_utility_m;
    UC_W_M16= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ef)^alpha0)+alpha3_m_w*children_utility_married_ep_ef+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1-0.5)^alpha2)+home_time_w*(1-0.5)+preg_utility_m;
else
    UC_W_M15=0;
    UC_W_M16=0;
end
UC_W_M17= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ue)^alpha0)+((          alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_w*children_utility_married_ue_ue+home_time_w;
UC_W_M18= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ue)^alpha0)+((alpha11_w+alpha12_w*WS+alpha13_w*W_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_w*children_utility_married_ue_ue+home_time_w+preg_utility_m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% husband (potential husband) current utility from each option:
UC_H_S1= (1/alpha0)*(budget_c_single_h_ue^alpha0)+ ((alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)+...
          alpha3_s_h*children_utility_single_h_ue+home_time_h_um+divorce_cost_h*M_minus_1;
UC_H_S2= -9999;
if (capacity_h == 1)
    UC_H_S3= (1/alpha0)*(budget_c_single_h_ef^alpha0)+alpha13_h*children_utility_single_h_ef+divorce_cost_h*M_minus_1;
else
    UC_H_S3=0;
end
UC_H_S4= -9999;
if (capacity_h == 0.5)
    UC_H_S5= (1/alpha0)*(budget_c_single_h_ep^alpha0)+((alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+...
         alpha3_s_h*children_utility_single_h_ep+home_time_h_um*(1-0.5)+divorce_cost_h*M_minus_1;
else
   UC_H_S5 = 0; 
end
UC_H_S6= -9999;
UC_H_S7= HS_UTILITY; % in school-no leisure, no income, but utility from schooling+increase future value




    % marriage options:% first index wife, second husband
if (capacity_h == 1)
    UC_H_M1=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ef)^alpha0)+                                                                     +alpha3_m_h*children_utility_married_ue_ef+home_time_h_m;
    UC_H_M2=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ef)^alpha0)+                                                                     +alpha3_m_h*children_utility_married_ue_ef+home_time_h_m+preg_utility_m;
else
    UC_H_M1 = 0;
    UC_H_M2 = 0;
end    
if (capacity_h == 0.5)
    UC_H_M3=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ep)^alpha0)+((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_m_h*children_utility_married_ue_ep+home_time_h_m*0.5;
    UC_H_M4=     Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ep)^alpha0)+((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_m_h*children_utility_married_ue_ep+home_time_h_m*0.5+preg_utility_m;
else
    UC_H_M3 = 0;
    UC_H_M4 = 0;
end
if (capacity_w == 1)  %to avoid division by zero
    UC_H_M5= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ue)^alpha0)+((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)    +alpha3_m_h*children_utility_married_ef_ue+home_time_h_m;
    UC_H_M6= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ue)^alpha0)+((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)    +alpha3_m_h*children_utility_married_ef_ue+home_time_h_m+preg_utility_m;
else
    UC_H_M5 = 0;
    UC_H_M6 = 0;
end
UC_H_M7= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ue)^alpha0)+((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_h*children_utility_married_ep_ue+home_time_h_m;
UC_H_M8= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ue)^alpha0)+((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_h*children_utility_married_ep_ue+home_time_h_m+preg_utility_m;

if (capacity_h == 1)  %to avoid division by zero
% in 9 and in 12 and 13 and 16 the husband works full time
    UC_H_M9=  Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ef)^alpha0)+alpha3_m_h*children_utility_married_ef_ef;
    UC_H_M12= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ef)^alpha0)+alpha3_m_h*children_utility_married_ep_ef;
    UC_H_M13= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ef)^alpha0)+alpha3_m_w*children_utility_married_ef_ef+preg_utility_m;
    UC_H_M16= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ef)^alpha0)+alpha3_m_w*children_utility_married_ep_ef+preg_utility_m;
else
    UC_H_M9 = 0;
    UC_H_M12 = 0;
    UC_H_M13 = 0;
    UC_H_M16 = 0;
end
if (capacity_h == 0.5)  %to avoid division by zero
% in 10 and in 11 and 14 and 15 the husband works part time
    UC_H_M10= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ep)^alpha0)+((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_m_h*children_utility_married_ef_ep+home_time_h_m*0.5;
    UC_H_M11= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ep)^alpha0)+((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_m_h*children_utility_married_ep_ep+home_time_h_m*0.5;
    UC_H_M14= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ef_ep)^alpha0)+((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_m_h*children_utility_married_ef_ep+home_time_h_m*0.5+preg_utility_m;
    UC_H_M15= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ep_ep)^alpha0)+((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1-0.5)^alpha2)+alpha3_m_h*children_utility_married_ep_ep+home_time_h_m*0.5+preg_utility_m;
else
    UC_H_M10 = 0;
    UC_H_M11 = 0;
    UC_H_M14 = 0;
    UC_H_M15 = 0;
end
UC_H_M17= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ue)^alpha0)+((          alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_h*children_utility_married_ue_ue+home_time_h_m;
UC_H_M18= Q_UTILITY+(1/alpha0)*((scale*budget_c_married_ue_ue)^alpha0)+((alpha11_h+alpha12_h*HS+alpha13_h*H_HEALTH)/alpha2)*((1)^alpha2)+alpha3_m_h*children_utility_married_ue_ue+home_time_h_m+preg_utility_m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
U_W = zeros(25,1);
% 25 OPTIONS: 7 OPTIONS AS SINGLE + 19 AS MARRIED
U_H = zeros(25,1);

if (age == TERMINAL)
    %  t1_w  - HSG;t2_w - SC;t3_w - CG;t4_w  - PC;t5_w- exp wife;t6_w -schooling husband if married - HSD;t7_w - HSG;t8_w - SC;t9_w - CG;t10_w - PC
    %t11_w - exp husband if married ;t12_w -mrtial status;t13_w - number of children;t14_w - match quality if married;t15_w - number of children if married
    %t16_w - previous work state - wife
    if (M_minus_1 == 1)  %need this if in order to control children, if already married only common kids otherwise W_N and H_N 
        U_W(1)= UC_W_S1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*C_N;
        U_W(2)= -99999;%UC_W_S2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*C_N;  %can't get pregnant at 65
        U_W(3)= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; %one more year of experience
        U_W(4)= -99999;%UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; %3 & 4 are the same since can't get pregnant at 65
        U_W(5)= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t13_w*C_N+t16_w; %one more year of experience
        U_W(6)= -99999;%UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; %3 & 4 are the same since can't get pregnant at 65
        U_W(7)= -99999;%UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*C_N+t16_w; % can't go to school at 65

        U_W(8)= UC_W_M1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(9)= -99999;%UC_W_M2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(10)= UC_W_M3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(11)= -99999;%UC_W_M4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;

        U_W(12)= UC_W_M5+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(13)= -99999;%UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(14)= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(15)= -99999;%UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
       
        U_W(16)= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(17)= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(18)= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(19)= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(20)= -99999;%UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(21)= -99999;%UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(22)= -99999;%UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY;
        U_W(23)= -99999;%UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(24)= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
        U_W(25)= -99999;%UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*C_N+t14_w*Q_UTILITY+t16_w;
   
        U_H(1)= UC_H_S1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*C_N;
        U_H(2)= -99999;%UC_H_S2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*C_N;  %can't get pregnant at 65
        U_H(3)= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; %one more year of experience
        U_H(4)= -99999;%UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; %3 & 4 are the same since can't get pregnant at 65
        U_H(5)= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t13_h*C_N+t16_h; %one more year of experience
        U_H(6)= -99999;%UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; %3 & 4 are the same since can't get pregnant at 65
        U_H(7)= -99999;%UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*C_N+t16_h; % can't go to school at 65

        U_H(8)= UC_H_M1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(9)= -99999;%UC_H_M2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(HK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(10)= UC_H_M3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(11)= -99999;%UC_H_M4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;

        U_H(12)= UC_H_M5+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(13)= -99999;%UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(14)= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(15)= -99999;%UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
       
        U_H(16)= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(17)= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(18)= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(19)= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(20)= -99999;%UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(21)= -99999;%UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(22)= -99999;%UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY;
        U_H(23)= -99999;%UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(24)= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
        U_H(25)= -99999;%UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
    
    elseif (M_minus_1 == 0)%need this if in order to control children, 	since single must use W_N and H_N 
        U_W(1)= UC_W_S1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*W_N;
        U_W(2)= -99999;%UC_W_S2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t13_w*W_N;  %can't get pregnant at 65
        U_W(3)= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; %one more year of experience
        U_W(4)= -99999;%UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; %3 & 4 are the same since can't get pregnant at 65
        U_W(5)= UC_W_S3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t13_w*W_N+t16_w; %one more year of experience
        U_W(6)= -99999;%UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; %3 & 4 are the same since can't get pregnant at 65
        U_W(7)= -99999;%UC_W_S4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t13_w*W_N+t16_w; % can't go to school at 65

        U_W(8)= UC_W_M1+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(9)= -99999;%UC_W_M2+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(10)= UC_W_M3+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(11)= -99999;%UC_W_M4+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;

        U_W(12)= UC_W_M5+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(13)= -99999;%UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(14)= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(15)= -99999;%UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
       
        U_W(16)= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(17)= UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+1)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(18)= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+0.5)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(19)= UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*(WK+1)+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*(HK+0.5)+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(20)= -99999;%UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(21)= -99999;%UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(22)= -99999;%UC_W_M6+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY;
        U_W(23)= -99999;%UC_W_M7+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(24)= UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
        U_W(25)= -99999;%UC_W_M8+t1_w*W_HSG+t2_w*W_SC+t3_w*W_CG+t4_w*W_PC+t5_w*WK+t6_w*H_HSD+t7_w*H_HSG+t8_w*H_SC+t9_w*H_CG+t10_w*H_PC+t11_w*HK+t12_w+(t13_w+t15_w)*(W_N+H_N)+t14_w*Q_UTILITY+t16_w;
   
        U_H(1)= UC_H_S1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*H_N;
        U_H(2)= -99999;%UC_H_S2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t13_h*H_N;  %can't get pregnant at 65
        U_H(3)= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; %one more year of experience
        U_H(4)= -99999;%UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; %3 & 4 are the same since can't get pregnant at 65
        U_H(5)= UC_H_S3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t13_h*H_N+t16_h; %one more year of experience
        U_H(6)= -99999;%UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; %3 & 4 are the same since can't get pregnant at 65
        U_H(7)= -99999;%UC_H_S4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t13_h*H_N+t16_h; % can't go to school at 65

        U_H(8)= UC_H_M1+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(9)= -99999;%UC_H_M2+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(HK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(10)= UC_H_M3+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(11)= -99999;%UC_H_M4+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;

        U_H(12)= UC_H_M5+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(13)= -99999;%UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(14)= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(15)= -99999;%UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
       
        U_H(16)= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(17)= UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+1)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(18)= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+0.5)+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(19)= UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*(HK+1)+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*(WK+0.5)+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(20)= -99999;%UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(21)= -99999;%UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(22)= -99999;%UC_H_M6+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY;
        U_H(23)= -99999;%UC_H_M7+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(24)= UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*W_HSD+t7_h*W_HSG+t8_h*W_SC+t9_h*W_CG+t10_h*W_PC+t11_h*WK+t12_h+(t13_h+t15_h)*(W_N+H_N)+t14_h*Q_UTILITY+t16_h;
        U_H(25)= -99999;%UC_H_M8+t1_h*H_HSG+t2_h*H_SC+t3_h*H_CG+t4_h*H_PC+t5_h*HK+t6_h*H_HSD+t7_h*H_HSG+t8_h*H_SC+t9_h*H_CG+t10_h*H_PC+t11_h*HK+t12_h+(t13_h+t15_h)*C_N+t14_h*Q_UTILITY+t16_h;
    end   % MARRIED AND NOT MARRIED
else   % t is not the terminal period so add EMAX
    % EMAX(t,K,N_Y,N_O,prev_state,ability_w_index,M,HE+t,HS,Q_INDEX, ability_h_index)
    % will need to multiply this loop in dynamic model to control for kids, as in t=T !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    U_W(1)= UC_W_S1;
    U_W(2)= UC_W_S2;
    U_W(3)= UC_W_S3;
    U_W(4)= UC_W_S4;
    U_W(5)= UC_W_S5;
    U_W(6)= UC_W_S6;
    U_W(7)= UC_W_S7;
    U_W(8)= UC_W_M1;
    U_W(9)= UC_W_M2;
    U_W(10)= UC_W_M3;
    U_W(11)= UC_W_M4;
    U_W(12)= UC_W_M5;
    U_W(13)= UC_W_M6;
    U_W(14)= UC_W_M7;
    U_W(15)= UC_W_M8;
    U_W(16)= UC_W_M9;
    U_W(17)= UC_W_M10;
    U_W(18)= UC_W_M11;
    U_W(19)= UC_W_M12;
    U_W(20)= UC_W_M13;
    U_W(21)= UC_W_M14;
    U_W(22)= UC_W_M15;
    U_W(23)= UC_W_M16;
    U_W(24)= UC_W_M17;
    U_W(25)= UC_W_M18;
    % husband terminal value
    U_H(1)= UC_H_S1;
    U_H(2)= -99999;
    U_H(3)= UC_H_S3;
    U_H(4)= -99999;
    U_H(5)= UC_H_S5;
    U_H(6)= -99999;
    U_H(7)= UC_H_S7;
    U_H(8)= UC_H_M1;
    U_H(9)= UC_H_M2;
    U_H(10)= UC_H_M3;
    U_H(11)= UC_H_M4;
    U_H(12)= UC_H_M5;
    U_H(13)= UC_H_M6;
    U_H(14)= UC_H_M7;
    U_H(15)= UC_H_M8;
    U_H(16)= UC_H_M9;
    U_H(17)= UC_H_M10;
    U_H(18)= UC_H_M11;
    U_H(19)= UC_H_M12;
    U_H(20)= UC_H_M13;
    U_H(21)= UC_H_M14;
    U_H(22)= UC_H_M15;
    U_H(23)= UC_H_M16;
    U_H(24)= UC_H_M17;
    U_H(25)= UC_H_M18;
 end
% delete impossible options - no job offer FULL wife
if CHOOSE_WORK_F_w == 0
    U_W(3)= -99999;
    U_W(4) = -99999;
    U_W(7+5) = -99999;U_H(7+6) = -99999;
    U_W(7+9) = -99999;U_H(7+10) = -99999;
    U_W(7+13) = -99999;U_H(7+14) = -99999;
end
% delete impossible options - no job offer PART wife
if CHOOSE_WORK_P_w == 0
    U_W(5)= -99999;
    U_W(6) = -99999;
    U_W(7+3) = -99999;U_H(7+4) = -99999;
    U_W(7+10) = -99999;U_H(7+11) = -99999;
    U_W(7+14) = -99999;U_H(7+15) = -99999;
end
% delete impossible options - no job offer full husband
if CHOOSE_WORK_F_h == 0
    U_H(3) = -99999;
    U_H(4) = -99999;
    U_H(7+1) = -99999;U_W(7+2) = -99999;
    U_H(7+9) = -99999;U_W(7+12) = -99999;
    U_H(7+13) = -99999;U_W(7+16) = -99999;
end            
% delete impossible options - no job offer PART husband
if CHOOSE_WORK_P_h == 0
    U_H(5) = -99999;
    U_H(6) = -99999;
    U_H(7+3) = -99999;U_W(7+4) = -99999;
    U_H(7+10) = -99999;U_W(7+11) = -99999;
    U_H(7+14) = -99999;U_W(7+15) = -99999;
end
% delete impossible options - no marriage offer wife
if (M_minus_1 == 0 &&  CHOOSE_HUSBAND == 0) 
    U_H(7+1) = -99999;U_W(7+1) = -99999;U_H(1) = -99999;
    U_H(7+2) = -99999;U_W(7+2) = -99999;U_H(2) = -99999;
    U_H(7+3) = -99999;U_W(7+3) = -99999;U_H(3) = -99999;
    U_H(7+4) = -99999;U_W(7+4) = -99999;U_H(4) = -99999;
    U_H(7+5) = -99999;U_W(7+5) = -99999;U_H(5) = -99999;
    U_H(7+6) = -99999;U_W(7+6) = -99999;U_H(6) = -99999;
    U_H(7+7) = -99999;U_W(7+7) = -99999;U_H(7) = -99999;
    U_H(7+8) = -99999;U_W(7+8) = -99999;
    U_H(7+9) = -99999;U_W(7+9) = -99999;
    U_H(7+10) = -99999;U_W(7+10) = -99999;
    U_H(7+11) = -99999;U_W(7+11) = -99999;
    U_H(7+12) = -99999;U_W(7+12) = -99999;
    U_H(7+13) = -99999;U_W(7+13) = -99999;
    U_H(7+14) = -99999;U_W(7+14) = -99999;
    U_H(7+15) = -99999;U_W(7+15) = -99999;
    U_H(7+16) = -99999;U_W(7+16) = -99999;
    U_H(7+17) = -99999;U_W(7+17) = -99999;
    U_H(7+18) = -99999;U_W(7+18) = -99999;
end		
% delete impossible options - no marriage offer wife
if (CHOOSE_WIFE == 0) % this condition only hold when solving backwards for single men. all other options, i.e. solving forward or solving for married/unmarried women, CHOOSE_WIFE==1
    U_H(7+1) = -99999;U_W(7+1) = -99999;U_W(1) = -99999;
    U_H(7+2) = -99999;U_W(7+2) = -99999;U_W(2) = -99999;
    U_H(7+3) = -99999;U_W(7+3) = -99999;U_W(3) = -99999;
    U_H(7+4) = -99999;U_W(7+4) = -99999;U_W(4) = -99999;
    U_H(7+5) = -99999;U_W(7+5) = -99999;U_W(5) = -99999;
    U_H(7+6) = -99999;U_W(7+6) = -99999;U_W(6) = -99999;
    U_H(7+7) = -99999;U_W(7+7) = -99999;U_W(7) = -99999;
    U_H(7+8) = -99999;U_W(7+8) = -99999;
    U_H(7+9) = -99999;U_W(7+9) = -99999;
    U_H(7+10) = -99999;U_W(7+10) = -99999;
    U_H(7+11) = -99999;U_W(7+11) = -99999;
    U_H(7+12) = -99999;U_W(7+12) = -99999;
    U_H(7+13) = -99999;U_W(7+13) = -99999;
    U_H(7+14) = -99999;U_W(7+14) = -99999;
    U_H(7+15) = -99999;U_W(7+15) = -99999;
    U_H(7+16) = -99999;U_W(7+16) = -99999;
    U_H(7+17) = -99999;U_W(7+17) = -99999;
    U_H(7+18) = -99999;U_W(7+18) = -99999;
end		
% delete impossible options - no schooling
if ( M_minus_1 == 1 || divorce == 1 || age > 30 || C_N > 0 || W_N > 0 || WS == 5)      
    U_W(7) = -99999;
end
if ( M_minus_1 == 1 ||  age > 30 || C_N > 0 ||  H_N > 0 || HS == 5)     
    U_H(7) = -99999;
end
% delete impossible options - no pregnancy
if ( age > 40 || C_N >3 || W_N > 3 )      
    U_W(2) = -99999;U_W(4) = -99999;U_W(6) = -99999;
    U_H(7+2) = -99999;U_W(7+2) = -99999;
    U_H(7+4) = -99999;U_W(7+4) = -99999;
    U_H(7+6) = -99999;U_W(7+6) = -99999;
    U_H(7+8) = -99999;U_W(7+8) = -99999;	
    U_H(7+13) = -99999;U_W(7+13) = -99999;	
    U_H(7+14) = -99999;U_W(7+14) = -99999;	
    U_H(7+15) = -99999;U_W(7+15) = -99999;	
    U_H(7+16) = -99999;U_W(7+16) = -99999;	
    U_H(7+18) = -99999;U_W(7+18) = -99999;	
end