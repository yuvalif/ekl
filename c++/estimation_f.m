function objective_function = estimation_f(param, f_type, display, global_param, T_MAX, DRAW_B, DRAW_F,...
    husband_prev_kids, husband_prev_emp, wife_prev_kids, wife_prev_emp, health_w, health_h,...
emp_mrate_child_wage, emp_mrate_child_wage_m, emp_mrate_child_wage_um, ... 
emp_m_with, emp_m_without, emp_um_with, emp_um_without, emp_wage_by_educ,emp_wage_by_educ_m, emp_wage_by_educ_um,...
educ_comp, educ_comp_m,assortative,epsilon_b, epsilon_f, w_draws, h_draws, w_draws_per, tax_brackets, deductions_exemptions, nlsy_trans) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   estimation_f
%   T - number of periods
%   numdraws - number of random draws
%   OBS - number of observations
%   Author: Osnat Lifshitz
%   Date: 18-Feb-2014
%   New version: May, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%keyboard();
%debug_on_error();
%global fitted_moments_out;
%global actual_moments_out;
%x_idx = get_global_param_idx(f_type);
%global_param(x_idx) = param;
%%%%%%%%%%%%%%%%%%
% PARAMETERS     %
%%%%%%%%%%%%%%%%%%
global lambda0_fw; global lambda1_fw; global lambda2_fw; global lambda3_fw; 
global lambda0_pw; global lambda1_pw; global lambda2_pw; global lambda3_pw; 
global lambda0_lw; global lambda1_lw; global lambda2_lw; global lambda3_lw; 
global lambda0_fh; global lambda1_fh; global lambda2_fh; global lambda3_fh; 
global lambda0_ph; global lambda1_ph; global lambda2_ph; global lambda3_ph; 
global lambda0_lh; global lambda1_lh; global lambda2_lh; global lambda3_lh; 
global beta11_w;   global beta12_w;   global beta13_w;   global beta14_w;  global  beta15_w; 
global beta21_w;   global beta22_w;   global beta23_w;   global beta24_w;  global  beta25_w; 
global beta31_w;   global beta32_w;   global beta33_w;   global beta34_w;  global  beta35_w;
global beta11_h;   global beta12_h;   global beta13_h;   global beta14_h;  global  beta15_h; 
global beta21_h;   global beta22_h;   global beta23_h;   global beta24_h;  global  beta25_h; 
global beta31_h;   global beta32_h;   global beta33_h;   global beta34_h;  global  beta35_h;
global sigma;      global unemp_h;    global unemp_w;
global decrease_low_ability ;global decrease_medium_ability ;
global omega1 ;global omega2  ;global omega3  ;global omega4_w ;global omega5_w ;global omega6_w;global omega7_w ;global omega8_w ;global omega4_h ;global omega5_h ;global omega6_h ;global omega7_h ;global omega8_h ;
global omega9_w ;global omega10_w ;global omega9_h ;global omega10_h ;
global psai0;global psai2;global psai3;global psai4;global pai1;global pai2;global pai3;global pai4;global row0 ;global row1;global row2 ;global row3;
global alpha0 ;global alpha11_w ;global alpha12_w ;global alpha13_w ;global alpha12_h;global alpha13_h;global alpha2;global alpha3_m_w ;global alpha3_s_w ;
global alpha3_m_h ;global alpha3_s_h ;global alpha41 ;global alpha42 ;global alpha43;global alpha44;
global t1_w; global t2_w; global t3_w; global t4_w;global t5_w; global t6_w;global t7_w; global t8_w;global t9_w; global t10_w; global t11_w; global t12_w;global t13_w; global t14_w; global t15_w; global t16_w;
global t1_h; global t2_h; global t3_h; global t4_h;global t5_h; global t6_h;global t7_h; global t8_h;global t9_h; global t10_h; global t11_h; global t12_h;global t13_h; global t14_h; global t15_h; global t16_h;
global h1;global h2;global h3;global h4;global h5;global h6;
global normal_arr ;global m_education_45;global m_education_55;global m_education_65;global eta1 ;global eta2;global eta3;global eta4;global scale ;global beta ;global BP ;global GRID;global AGE ;
global TERMINAL ;global GOOD ;global FAIR ;global POOR ;global HK1 ;global HK2 ;global HK3 ;global HK4 ;
% meeting a partner parameters
omega1   = global_param(1);    %exp(global_param(1))/(1+exp(global_param(1)));			% prob of meeting a husband if below 18
omega2   = global_param(2);    %exp(global_param(1))/(1+exp(global_param(1)));			% prob of meeting a husband if above 18 but in school
omega3   = global_param(3);    %exp(global_param(1))/(1+exp(global_param(1)));			% prob of meeting a husband if above 18 and not in school
omega4_w = global_param(4);    % probability of meeting a  CG - CONSTANT
omega5_w = global_param(5);    %probability of meeting a  CG if she SC
omega6_w = global_param(6);    %probability of meeting a  CG if she HS
omega7_w = global_param(7);    %probability of meeting a  SC - CONSTANT
omega8_w = global_param(8);    %probability of meeting a  SC if she HS
omega9_w = global_param(9);    %probability of meeting a  partner by AGE
omega10_w = global_param(10);   %probability of meeting a  partner by AGE square
omega4_h = global_param(13);    %probability of meeting a  CG - CONSTANT
omega5_h = global_param(14);   %probability of meeting a  CG if he SC
omega6_h = global_param(15);   %probability of meeting a  CG if he HS
omega7_h = global_param(16);   %probability of meeting a  SC - CONSTANT
omega8_h = global_param(17);   %probability of meeting a  SC if he HS
omega9_h= global_param(18);     %probability of meeting a  partner by AGE
omega10_h = global_param(19);   %probability of meeting a  partner by AGE square
% taste for marriage parameters :Q = psai0 + psai1*((HS-WS)^2) + psai2*D + shock 
psai0 = global_param(22);    % constant
psai2 = global_param(23);    %schooling gap - men more educated
psai3 = global_param(24);    %schooling gap - women more educated
psai4 = global_param(25);    %health gap
% utility from pregnancy parameter - PREGNANCY = pai0 + pai1*W_AGE+pai2*W_AGE^2+pai3*N+epsilon_f(draw_f, t, 1);
% We assume that pregnancy decisions are made jointly by the couple, and that each party gets the same utility from the decision
pai1 = global_param(26);    %married
pai2 = global_param(27);    %health
pai3 = global_param(28);    %# of kids in household
pai4 = global_param(29);    %pregnency in t-1
% Wage parameters
beta11_w = global_param(30);    %experience HSD
beta12_w = global_param(31);    %experience HSG
beta13_w = global_param(32);    %experience SC
beta14_w = global_param(33);    %experience CG
beta15_w = global_param(34);    %experience PC
beta21_w = global_param(35);    %exp^2 HSD
beta22_w = global_param(36);    %exp^2 HSG
beta23_w = global_param(37);    %exp^2 SC
beta24_w = global_param(38);    %exp^2 CG 
beta25_w = global_param(39);    %exp^2 PC
beta31_w = global_param(40);    %education HSD
beta32_w = global_param(41);    %education HSG
beta33_w = global_param(42);    %education SC
beta34_w = global_param(43);    %education CG
beta35_w = global_param(44);    %education PC
beta11_h = global_param(45);    %experience HSD
beta12_h = global_param(46);    %experience HSG
beta13_h = global_param(47);    %experience SC
beta14_h = global_param(48);    %experience CG
beta15_h = global_param(49);    %experience PC
beta21_h = global_param(50);    %exp^2 HSD
beta22_h = global_param(51);    %exp^2 HSG
beta23_h = global_param(52);    %exp^2 SC
beta24_h = global_param(53);    %exp^2 CG 
beta25_h = global_param(54);    %exp^2 PC
beta31_h = global_param(55);    %HSD
beta32_h = global_param(56);    %HSG
beta33_h = global_param(57);    %SC
beta34_h = global_param(58);    %CG
beta35_h = global_param(59);    %PC
%utility a couple receives from the quality and quality of children
row0 = exp(global_param(60))/(1+exp(global_param(60))); %CES function's parameter - if 1:linear or perfect substitutes; if approaches zero:Cobb–Douglas production function;if approaches negative infinity: perfect complements
row1 = global_param(61);    %wife leisure
row2 = global_param(62);    %husband leisure
row3 = global_param(63);    %spending per child
if (row1+row2+row3 >= 1)
	error(0)
end	
% budget constraint
unemp_h = global_param(64);    % unemployment benefit - husband   -    NOT TO BE ESTIMATED, EXOGENOUSLY GIVEN
unemp_w = unemp_h;    %unemployment benefit - wife       -    NOT TO BE ESTIMATED, EXOGENOUSLY GIVEN
% Utility parameters 
alpha0 = global_param(65);    %CRRA consumption parameter
alpha11_w = global_param(66);    %leisure when pregnant
alpha12_w = global_param(67);    %leisure by  education
alpha13_w = global_param(68);    %leisure by health
alpha12_h = global_param(69);    %leisure by  education
alpha13_h = global_param(70);    %leisure by health
alpha2 = global_param(71);    %utility from leisure CRRA parameter
alpha3_m_w = global_param(72);    %utility from kids when married
alpha3_s_w = global_param(73);    %utility from kids when single
alpha3_m_h = global_param(74);    %utility from kids when married
alpha3_s_h = global_param(75);    %utility from kids when single
alpha41 = global_param(76);     % cost of divorce - constant wife
alpha42 = global_param(77);     % cost of divorce - constant husband
alpha43 = global_param(78);     % cost of divorce - per child wife
alpha44 = global_param(79);     % cost of divorce - per child husband

% home time equation - random walk
tau0_w = global_param(80);    %constant - alpha
tau1_w = global_param(81);    %AR coefficient
tau2_w = global_param(82);    %pregnancy in previous period
tau0_h = global_param(83);    %constant - alpha
tau1_h = global_param(84);    %AR coefficient
tau2_h = global_param(85);    %pregnancy in previous period
% Job offer parameters  wife - full time (wasn't working at t-1)
lambda0_fw = global_param(86);    %constant
lambda1_fw = global_param(87);    %experience
lambda2_fw = global_param(88);    %education
lambda3_fw = global_param(89);    %health
% Job offer parameters  husband - full time (wasn't working at t-1)
lambda0_fh = global_param(90);    %constant
lambda1_fh = global_param(91);    %experience
lambda2_fh = global_param(92);    %education
lambda3_fh = global_param(93);    %health
% Job offer parameters  wife - part time (wasn't working at t-1)
lambda0_pw = global_param(94);    %constant
lambda1_pw = global_param(95);    %experience
lambda2_pw = global_param(96);    %education
lambda3_pw = global_param(97);    %health
% Job offer parameters  husband - part time (wasn't working at t-1)
lambda0_ph = global_param(98);    %constant
lambda1_ph = global_param(99);    %experience
lambda2_ph = global_param(100);    %education
lambda3_ph = global_param(101);    %health
% Job offer parameters  wife - laid off (working at t-1)
lambda0_lw = global_param(102);    %constant
lambda1_lw = global_param(103);    %experience
lambda2_lw = global_param(104);    %education
lambda3_lw = global_param(105);    %health
% Job offer parameters  husband - laid off (working at t-1)
lambda0_lh = global_param(106);    %constant
lambda1_lh = global_param(107);    %experience
lambda2_lh = global_param(108);    %education
lambda3_lh = global_param(109);    %health
% ability distribution
%should be negative between 0-0.333: param=0.9-->prob decrease by 0.23, param=0.2-->prob decrease by 0.18
decrease_low_ability = -(exp(global_param(110))/(1+exp(global_param(110))))/3; 
decrease_medium_ability = -(exp(global_param(111))/(1+exp(global_param(111))))/3;
% random shocks variance-covariance matrix - correlations? identification?
sigma = zeros(8,8);
sigma(1,1) = exp(global_param(112));    %variance wife ability
sigma(2,2) = exp(global_param(113));    %variance husband ability
sigma(3,3) = exp(global_param(114));    %variance home time wife
sigma(4,4) = exp(global_param(115));    %variance home time husband
sigma(5,5) = exp(global_param(116));    %wife's wage error variance
sigma(6,6) = exp(global_param(117));    %husband's wage error variance
sigma(7,7) = exp(global_param(118));    %match quality variance
sigma(8,8) = exp(global_param(119));    %pregnancy
%uti11lity from schooling
s1_w = global_param(120);    %constant
s2_w = global_param(121);    %parents are CG
s3_w = global_param(122);    %return for ability
s4_w = global_param(123);    %post high school tuition
s1_h = global_param(124);    %constant
s2_h = global_param(125);    %parents are CG
s3_h = global_param(126);    %return for ability
s4_h = s4_w ;                   %post high school tuition
% terminal value Parameters
t1_w = global_param(127);    %ind. Education - HSG
t2_w = global_param(128);    %ind. Education - SC
t3_w = global_param(129);    %ind. Education - CG
t4_w = global_param(130);    %ind. Education - PC
t5_w = global_param(131);    %experience
t6_w = global_param(132);    %partner education - HSD
t7_w = global_param(133);    %partner education - HSG
t8_w = global_param(134);    %partner education - SC
t9_w = global_param(135);    %partner education - CG
t10_w = global_param(136);    %partner education - PC
t11_w = global_param(137);    %partner experience
t12_w = global_param(138);    %marital status
t13_w = global_param(139);    %# of kids
t14_w = global_param(140);    %match quality
t15_w = global_param(141);    %# of kids if married
t16_w = global_param(142);    %previous work state
% terminal value Parameters
t1_h = global_param(143);    %ind. Education - HSG
t2_h = global_param(144);    %ind. Education - SC
t3_h = global_param(145);    %ind. Education - CG
t4_h = global_param(146);    %ind. Education - PC
t5_h = global_param(147);    %experience
t6_h = global_param(148);    %partner education - HSD
t7_h = global_param(149);    %partner education - HSG
t8_h = global_param(150);    %partner education - SC
t9_h = global_param(151);    %partner education - CG
t10_h = global_param(152);    %partner education - PC
t11_h = global_param(153);    %partner experience
t12_h = global_param(154);    %marital status
t13_h = global_param(155);    %# of kids
t14_h = global_param(156);    %match quality
t15_h = global_param(157);    %# of kids if married
t16_h = global_param(158);    %previous work state
% health parameters 1935
h1_35 = global_param(159);    %good health to good health
h2_35 = global_param(160);    %fair health to good health
h3_35 = global_param(161);    %poor health to good health
h4_35 = global_param(162);    %good health to poor health
h5_35 = global_param(163);    %fair health to poor health
h6_35 = global_param(164);    %poor health to poor health
% health parameters 1945
h1_45 = global_param(165);    %good health to good health
h2_45 = global_param(166);    %fair health to good health
h3_45 = global_param(167);    %poor health to good health
h4_45 = global_param(168);    %good health to poor health
h5_45 = global_param(169);    %fair health to poor health
h6_45 = global_param(170);    %poor health to poor health
% health parameters 1955
h1_55 = global_param(171);    %good health to good health
h2_55 = global_param(172);    %fair health to good health
h3_55 = global_param(173);    %poor health to good health
h4_55 = global_param(174);    %good health to poor health
h5_55 = global_param(175);    %fair health to poor health
h6_55 = global_param(176);    %poor health to poor health
% health parameters 1965
h1_65 = global_param(177);    %good health to good health
h2_65 = global_param(178);    %fair health to good health
h3_65 = global_param(179);    %poor health to good health
h4_65 = global_param(180);    %good health to poor health
h5_65 = global_param(181);    %fair health to poor health
h6_65 = global_param(182);    %poor health to poor health
% health parameters 1975
h1_75 = global_param(183);    %good health to good health
h2_75 = global_param(184);    %fair health to good health
h3_75 = global_param(185);    %poor health to good health
h4_75 = global_param(186);    %good health to poor health
h5_75 = global_param(187);    %fair health to poor health
h6_75 = global_param(188);    %poor health to poor health
HP_55 = 0;                    %time spent on home production by cohort, set to zero at 45-55-65 unified sample, later by cohort
%HP_35 = (exp(global_param(102))/(1+exp(global_param(102))))/2; % make sure this parameter is less than 50% of time
%HP_45 = (exp(global_param(102))/(1+exp(global_param(102))))/2; 
%HP_65 = (exp(global_param(102))/(1+exp(global_param(102))))/2; 
%HP_75 = (exp(global_param(102))/(1+exp(global_param(102))))/2; 
HP = HP_55;                  %time spent on home production by cohort  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
% CONSTANTS      %
%%%%%%%%%%%%%%%%%%
normal_arr = [ -1.150, 0 , 1.150];    %low, medium, high
m_education_35= 0.06; % probability of collage educated mother - married women with CG+PC at age 45 (no earlier data), cohort 1915
m_education_45= 0.06; % probability of collage educated mother - married women with CG+PC at age 40, cohort 1925
m_education_55= 0.11; % probability of collage educated mother- married women with CG+PC at age 40, cohort 1935
m_education_65= 0.20; % probability of collage educated mother- married women with CG+PC at age 40, cohort 1945
m_education_75= 0.27; % probability of collage educated mother - married women with CG+PC at age 40, cohort 1955
eta1 = 0.194;                         %fraction from parents net income that one kid get 
eta2 = 0.293;                         %fraction from parents net income that 2 kids get 
eta3 = 0.367;                         %fraction from parents net income that 3 kids get 
eta4 = 0.423;                         %fraction from parents net income that 4 kids get
scale = 0.707 ;                        %fraction of public consumption
beta = 0.983;                         % discount rate
BP = 0.5;                             % FIXED BARGENING POWER
GRID = 3;	
AGE = 16;	                          % initial age
TERMINAL = 60;                        % retirement
GOOD = 1;	                          % health status
FAIR = 2;
POOR = 3;
HK1 = 1;                              %0-2 years of experience
HK2 = 4;	                          %3-5 years of experience
HK3 = 8;	                          %6-10 years of experience
HK4 = 12;	                          %11+ years of experience
cb_const_35 = 4317.681;    %child benefit for single mom+1 kid - annualy  
cb_per_child_35 = 1517.235;
cb_const_45 = 4749.394;    %child benefit for single mom+1 kid - annualy  
cb_per_child_45 = 1179.676;
cb_const_55 = 4530.784;    %child benefit for single mom+1 kid - annualy  
cb_per_child_55 = 975.3533;
cb_const_65 = 3800.542;    %child benefit for single mom+1 kid - annualy  
cb_per_child_65 = 861.9597;
cb_const_75 = 2710.976;    %child benefit for single mom+1 kid - annualy  
cb_per_child_75 = 764.4601;
num_cohort = 3;
%%%%%%%%%%%%%%%%%%%%%%
% define moments arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%
emp_w = zeros(T_MAX,3, num_cohort); %(periods, [unemployment, full, part] , cohorts)
emp_h = zeros(T_MAX,3+1, num_cohort); %(periods, [unemployment, full, part,employment] , cohorts)
emp_m_w = zeros(T_MAX,3, num_cohort); %(periods, [unemployment, full, part] , cohorts)
emp_um_w = zeros(T_MAX,3, num_cohort); %(periods, [unemployment, full, part] , cohorts)
emp_m_no_kids_w = zeros(T_MAX, num_cohort);
emp_m_with_kids_w = zeros(T_MAX,num_cohort);
emp_um_no_kids_w = zeros(T_MAX, num_cohort);
emp_um_kids_w = zeros(T_MAX, num_cohort);
wages_w = zeros(DRAW_F, T_MAX,num_cohort);
wages_m_h = zeros(DRAW_F, T_MAX,num_cohort);
wages_m_w = zeros(DRAW_F, T_MAX,num_cohort);
wages_um_w = zeros(DRAW_F, T_MAX,num_cohort);
married = zeros(T_MAX, num_cohort);
newborn = zeros(T_MAX, num_cohort);
newborn_m = zeros(T_MAX, num_cohort);
newborn_um = zeros(T_MAX, num_cohort);
divorce_arr = zeros(T_MAX, num_cohort);
kids  = zeros(T_MAX, num_cohort);
kids_m = zeros(T_MAX, num_cohort);
kids_um = zeros(T_MAX, num_cohort);
count_emp_h = zeros(T_MAX, num_cohort);
count_emp_m_no_kids_w = zeros(T_MAX, num_cohort);
count_emp_m_with_kids_w = zeros(T_MAX, num_cohort);
count_emp_um_no_kids_w = zeros(T_MAX, num_cohort);
count_emp_um_kids_w = zeros(T_MAX, num_cohort);
count_newborn_m = zeros(T_MAX, num_cohort);
count_newborn_um = zeros(T_MAX, num_cohort);
school_dist_h = zeros(T_MAX, 5,num_cohort);
school_dist_w = zeros(T_MAX, 5,num_cohort);
count_school_dist_h = zeros(T_MAX, num_cohort);
assortative_mating = zeros(5,5,num_cohort);
count_assortative_mating = zeros(5,1,num_cohort);
emp_by_educ = zeros(T_MAX, 5,num_cohort); 
count_emp_by_educ = zeros(T_MAX, 5,num_cohort);
wage_by_educ = zeros(T_MAX, 5,num_cohort);
count_wage_by_educ = zeros(T_MAX, 5,num_cohort);
health_dist_h = zeros(T_MAX, 3,num_cohort);
health_dist_w = zeros(T_MAX, 3,num_cohort);
count_health_dist_h = zeros(T_MAX, num_cohort);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOLVING FORWARD %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for draw_f = 1 : DRAW_F*num_cohort %3 cohorts DRAW_F*num_cohort=3000
	CHOOSE_WIFE = 1;   %KEEP THIS FLAG=1 ALWAYS!!! SHOULD BE ZERO ONLY IN BACKWARD SOLVING FOR SINGLE MEN
    if (draw_f <= DRAW_F*m_education_45)
		mother_educ_w = 1;
		cohort = 1;
        cb_const = cb_const_45;    %child benefit for single mom+1 kid - annualy  
        cb_per_child = cb_per_child_45;	
        h1 = h1_45 ;    %good health to good health
        h2 = h2_45 ;    %fair health to good health
        h3 = h3_45 ;    %poor health to good health
        h4 = h4_45 ;    %good health to poor health
        h5 = h5_45 ;    %fair health to poor health
        h6 = h6_45 ;
	elseif (draw_f > DRAW_F*m_education_45 && draw_f <= DRAW_F)
		mother_educ_w = 0;
		cohort = 1;
        cb_const = cb_const_45;    %child benefit for single mom+1 kid - annualy  
        cb_per_child = cb_per_child_45;	
        h1 = h1_45 ;    %good health to good health
        h2 = h2_45 ;    %fair health to good health
        h3 = h3_45 ;    %poor health to good health
        h4 = h4_45 ;    %good health to poor health
        h5 = h5_45 ;    %fair health to poor health
        h6 = h6_45 ;
    elseif (draw_f > DRAW_F && draw_f <= DRAW_F+DRAW_F*m_education_55)
		mother_educ_w = 1;	
		cohort = 2;
        cb_const = cb_const_55;    %child benefit for single mom+1 kid - annualy  
        cb_per_child = cb_per_child_55;
        h1 = h1_55 ;    %good health to good health
        h2 = h2_55 ;    %fair health to good health
        h3 = h3_55 ;    %poor health to good health
        h4 = h4_55 ;    %good health to poor health
        h5 = h5_55 ;    %fair health to poor health
        h6 = h6_55 ;
    elseif (draw_f > DRAW_F+DRAW_F*m_education_55 && draw_f <= 2*DRAW_F)
		mother_educ_w = 0;
		cohort = 2;
        cb_const = cb_const_55;    %child benefit for single mom+1 kid - annualy  
        cb_per_child = cb_per_child_55;
        h1 = h1_55 ;    %good health to good health
        h2 = h2_55 ;    %fair health to good health
        h3 = h3_55 ;    %poor health to good health
        h4 = h4_55 ;    %good health to poor health
        h5 = h5_55 ;    %fair health to poor health
        h6 = h6_55 ;
	elseif (draw_f > 2*DRAW_F && draw_f <= 2*DRAW_F+DRAW_F*m_education_65)
		mother_educ_w = 1;	
		cohort = 3;
        cb_const = cb_const_65;    %child benefit for single mom+1 kid - annualy  
        cb_per_child = cb_per_child_65;
        h1 = h1_65 ;    %good health to good health
        h2 = h2_65 ;    %fair health to good health
        h3 = h3_65 ;    %poor health to good health
        h4 = h4_65 ;    %good health to poor health
        h5 = h5_65 ;    %fair health to poor health
        h6 = h6_65 ;
	elseif (draw_f > 2*DRAW_F+DRAW_F*m_education_65 && draw_f <= 3*DRAW_F)
		mother_educ_w = 0;	
		cohort = 3;
        cb_const = cb_const_65;    %child benefit for single mom+1 kid - annualy  
        cb_per_child = cb_per_child_65;
        h1 = h1_65 ;    %good health to good health
        h2 = h2_65 ;    %fair health to good health
        h3 = h3_65 ;    %poor health to good health
        h4 = h4_65 ;    %good health to poor health
        h5 = h5_65 ;    %fair health to poor health
        h6 = h6_65 ;
    else
        error(0)
    end	
    % Initialize state
	AGE = 16;
	WS = 1; W_HSD = 1;		W_HSG = 0;		W_SC = 0;		W_CG = 0;		W_PC = 0;		WK=0; W_HEALTH = GOOD; 
	HS = 1; H_HSD = 1;		H_HSG = 0;		H_SC = 0;		H_CG = 0;		H_PC = 0;		HK=0; H_HEALTH = GOOD; mother_educ_h=0;
	year_of_school_w = 10;
	prev_state_h = 0;	prev_state_w = 0;	prev_capacity_w = 0;	prev_capacity_h = 0;
	prev_state_T_minus_1 = 0;
	dur = 0 ;	dur_minus_1 = 0;	P_minus_1 = 0 ;	P = 0;
	home_time_h_m = exp(tau0_h/(1-tau1_h));
	home_time_h_um = exp(tau0_h/(1-tau1_h));
	home_time_w = exp(tau0_w/(1-tau1_w));
	home_time_h_m_minus_1 = exp(tau0_h/(1-tau1_h));
	home_time_h_um_minus_1 = exp(tau0_h/(1-tau1_h));
	home_time_w_minus_1 = exp(tau0_w/(1-tau1_w));
	M=0 ;	M_minus_1=0;	D = 0;
	W_N = 0;%wife kids as single
	H_N = 0;%husband kids as single
	C_N = 0;%common kids when married. if married, W_N and H_N are equal to zero
	Q = 0;	Q_UTILITY = 0;
	capacity_h = 0;    capacity_w = 0;	wage_h = 0;	wage_w = 0;
    in_school_at_t_minus_1_w = 1;in_school_at_t_minus_1_h = 1;
	% draw women permanent utility (function of mother education)
   
	if (w_draws_per(draw_f,1)<0.333+decrease_low_ability*mother_educ_w)%low ability
		ability_w = normal_arr(1)*sigma(1,1);% w_draw_per: 1 - ability, 2- parents education
	elseif (w_draws_per(draw_f,1)>0.333+decrease_low_ability*mother_educ_w && w_draws_per(draw_f,1)<0.666+decrease_medium_ability*mother_educ_w)%medium ability
		ability_w = normal_arr(2)*sigma(1,1);% w_draw_per: 1 - ability, 2- parents education
	else 
		ability_w = normal_arr(3)*sigma(1,1);% w_draw_per: 1 - ability, 2- parents education
	end	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make choices for all periods - start period loop%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	ability_h = 0;
	ability_h_index = 0;
	t = 0;
	W_GOOD = 1; W_FAIR = 0; W_POOR = 0;W_HEALTH = GOOD;
	Q_UTILITY_PERMANENT = 0 ;  %this one is permanent over t so make sure to initialize only here and when get divorce
    for age = AGE : TERMINAL    %AGE = 16; TERMINAL = 60;
		t = age - 15;
		% update T-1 variables
		dur_minus_1 = dur;
		P_minus_1 = P;
		M_minus_1 = M;
		home_time_h_m_minus_1 = home_time_h_m; 
		home_time_h_um_minus_1 = home_time_h_um; 
		home_time_w_minus_1 = home_time_w ;
		CHOOSE_HUSBAND = 0;
		capacity_h = 0;
		capacity_w = 0;
		D = 0;
		Q = 0;
		Q_UTILITY = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% if not married DRAW HUSBAND + HUSBAND CHARACTERISTICS		
	%h_draws = rand(DRAW_F,T,5); 1- MEET HUSBAND;2-HUSBAND SCHOOLING+EXP; 3-HUSBAND ABILITY; 4 - HUSBAND CHILDREN; 5 - HEALTH ; 6 - PARENTS EDUCATION; 7 - job offer;8-part time/full time; 9- prev state husband
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (M == 0)
            [CHOOSE_HUSBAND, H_N,  ability_h,  HS,  H_HSD,  H_HSG, H_SC, H_CG, H_PC, year_of_school_h, HK,  prev_state_h, prev_capacity_h, mother_educ_h,  H_GOOD,  H_FAIR,  H_POOR,  H_HEALTH,  Q_UTILITY_PERMANENT]= ...
            draw_partner(t, draw_f ,age, in_school_at_t_minus_1_w, WS, h_draws, w_draws, husband_prev_emp, wife_prev_emp, husband_prev_kids,wife_prev_kids, health_h, health_w, 1) ;
        else % M = 1 - already have husband
			H_N = 0;
		end  %IF M=0	
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% DRAW AND CALCULATE WOMAN TRANSITORY CHARACTERISTCS  %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% w_draws: 1 - health, 2 - leisure, 3 - job offer, 4 - part time/full time,
		% draw health status: according to previous status and age 
		if (age == 16)   %initial health state - uncorrelated with previous since first observation
 			if (w_draws(draw_f,t,1)< health_w(t,2))
					W_HEALTH = GOOD;
					W_GOOD = 1;
			elseif (w_draws(draw_f,t,1)>health_w(t,2) && w_draws(draw_f,t,1)<health_w(t,3))
					W_HEALTH = FAIR;
					W_FAIR = 1;
			elseif (w_draws(draw_f,t,1)>health_w(t,3) && w_draws(draw_f,t,1)<health_w(t,4))
					W_HEALTH = POOR;
					W_POOR = 1;
			else
					error(0);
			end
        elseif (age>16)
            [W_HEALTH, W_GOOD, W_FAIR, W_POOR]=health(W_GOOD, W_FAIR, W_POOR, w_draws, h_draws, draw_f,t, 1);
        end  %age ==16 - initial health
        % calculate wage + job offer + capacity
        [CHOOSE_WORK_F_w ,CHOOSE_WORK_P_w, wage_full_w, wage_part_w, capacity_w]= wage_calc(WK, prev_state_w,prev_capacity_w, year_of_school_w, W_HEALTH, w_draws,h_draws, epsilon_f,draw_f, t, W_HSD, W_HSG, W_SC, W_CG, W_PC, ability_w, 1);
        % calculate utility from schooling 
		if (WS==1)
			WS_UTILITY =s1_w+s2_w*mother_educ_w+s3_w*ability_w;      % utility from high school 
        elseif (WS>1)
			WS_UTILITY =s1_w+s2_w*mother_educ_w+s3_w*ability_w+s4_w;      % utility from post high school 
		end	
		% home time equation - random walk - tau0_w -pregnancy in previous period, tau1_w - drift term - should be negative
%		ln_home_time_w =tau1_w*log(home_time_w_minus_1) + tau0_w + tau2_w*P_minus_1 + epsilon_f(draw_f, t, 3)*sigma(3,3);
       home_time_w=exp((tau1_w*log(home_time_w_minus_1))+tau0_w + tau2_w*P_minus_1 + epsilon_f(draw_f, t, 3)*sigma(3,3));

%        home_time_w=exp((home_time_w_minus_1.^tau1_w)*exp(tau0_w + tau2_w*P_minus_1 + epsilon_f(draw_f, t, 3)*sigma(3,3));
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% DRAW AND CALCULATE HUSBAND OR POTENTIAL PARTNER TRANSITORY CHARACTERISTCS  %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if (M == 1) %draw health for existing husband
            [H_HEALTH, H_GOOD, H_FAIR, H_POOR]=health(H_GOOD, H_FAIR, H_POOR, w_draws, h_draws,draw_f,t,  0) ;
        end
        
        if (M == 1 ||  CHOOSE_HUSBAND == 1)
        % calculate wage + job offer + capacity
            [CHOOSE_WORK_F_h ,CHOOSE_WORK_P_h, wage_full_h, wage_part_h, capacity_h]= wage_calc(HK, prev_state_h, prev_capacity_h, year_of_school_h, H_HEALTH, w_draws,h_draws, epsilon_f,draw_f, t, H_HSD, H_HSG, H_SC, H_CG, H_PC, ability_h, 0);
			% calculate utility from schooling 
            if (HS==1)
                HS_UTILITY =s1_h+s2_h*mother_educ_h+s3_h*ability_h;      % utility from high school 
            elseif (HS>1)
                HS_UTILITY =s1_h+s2_h*mother_educ_h+s3_h*ability_h+s4_h;      % utility from post high school 
            end	
            % home time equation - random walk - tau0_w -pregnancy in previous period, tau1_w - drift term - should be negative
 			% if husband is not married his home time is not influence by a newborn, the wife is influenced of course, so home time for her is not function of M
            home_time_h_m=exp((tau1_h*log(home_time_h_m_minus_1))+tau0_h + tau2_h*P_minus_1 + epsilon_f(draw_f, t, 4)*sigma(4,4));
            home_time_h_um=exp((tau1_h*log(home_time_h_um_minus_1))+tau0_h +  epsilon_f(draw_f, t, 4)*sigma(4,4));

 %           home_time_h_m =(home_time_h_m_minus_1.^tau1_h )*exp(tau0_h+ tau2_h*P_minus_1 + epsilon_f(draw_f, t, 4)*sigma(4,4));
 %           home_time_h_um=(home_time_h_um_minus_1.^tau1_h)*exp(tau0_h+                    epsilon_f(draw_f, t, 4)*sigma(4,4));
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% DRAW AND CALCULATE MARRIAGE AND PREGNENCY TRANSITORY UTILITY  %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%			
            if (HS==WS)
                Q_UTILITY = Q_UTILITY_PERMANENT + psai0         + psai4*(W_HEALTH-H_HEALTH).^2 + epsilon_f(draw_f, t, 5)*sigma(7,7);      % utility from marriage
            elseif (WS<HS)
                Q_UTILITY = Q_UTILITY_PERMANENT + psai0 + psai2 + psai4*(W_HEALTH-H_HEALTH).^2 + epsilon_f(draw_f, t, 5)*sigma(7,7);      % utility from marriage
            else
                Q_UTILITY = Q_UTILITY_PERMANENT + psai0 + psai3 + psai4*(W_HEALTH-H_HEALTH).^2 + epsilon_f(draw_f, t, 5)*sigma(7,7);      % utility from marriage
            end
		else   % no husband or potential husband
			Q_UTILITY = 0; 
			wage_full_h = 0;
			wage_part_h = 0;
			capacity_h = 0;
			HS_UTILITY = 0;
			home_time_h_m = 0;
			home_time_h_um = 0;
			CHOOSE_WORK_F_h = 0;
			CHOOSE_WORK_P_h = 0;
            Q_UTILITY_PERMANENT = 0;
		end % yes/ no husband or potential husband
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                calculate utility                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [U_W,U_H]=calculate_utility(cohort, cb_const,cb_per_child,W_N,H_N,C_N, wage_full_w, wage_part_w, wage_full_h, wage_part_h, capacity_w, capacity_h, M_minus_1, W_HEALTH, H_HEALTH, P_minus_1, epsilon_f, draw_f, t, Q_UTILITY ,HS_UTILITY, WS_UTILITY, home_time_h_m,...
          home_time_h_um , home_time_w,	CHOOSE_WORK_F_h, CHOOSE_WORK_P_h, CHOOSE_WORK_F_w, CHOOSE_WORK_P_w, D, age, CHOOSE_HUSBAND,CHOOSE_WIFE, WS, HS, W_HSD, W_HSG,W_SC,W_CG,W_PC, WK, H_HSD, H_HSG, H_SC,H_CG,H_PC, HK, tax_brackets, deductions_exemptions, HP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MAXIMIZATION - MARRIAGE + WORK  + PREGNANCY DESICIONS           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [optimization_desicion_w_v, optimization_desicion_w_i, optimization_desicion_h_v, optimization_desicion_h_i ]=...
         optimization_desicion(U_W,U_H);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  UPDARE T+1 STATE VARIABLES ACCORDING TO THE DECISION:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
% UPDATE MARRIAGE STATUS - M, DIVORCE, DURATION,  PREGNANCY STATUS, EXPERIENCE - K, PREVIOUS STATE - prev_state, NUMBER OF CHILDREN
		if ( optimization_desicion_h_i == 5 ) % man goes to school
			year_of_school_h = year_of_school_h +1;
            in_school_at_t_minus_1_h=1;
			if (year_of_school_h < 12)
				HS = 1;
				H_HSD = 1;
			elseif (year_of_school_h == 12)
				HS = 2;
				H_HSD = 0; H_HSG = 1;
			elseif (year_of_school_h > 12 &&  year_of_school_h < 16)
				HS = 3;
				H_HSD = 0; H_HSG = 0;H_SC = 1;
			elseif (year_of_school_h > 14 &&  year_of_school_h < 18)
				HS = 4;
				H_HSD = 0; H_HSG = 0;H_SC = 0; H_CG = 1;
			elseif (year_of_school_h > 17 )
				HS = 5;
				H_HSD = 0; H_HSG = 0;H_SC = 0; H_CG = 0; H_PC = 1;
            end
        else
           in_school_at_t_minus_1_h = 0;
        end
		if ( optimization_desicion_w_i == 5 ) % woman goes to school
			year_of_school_w = year_of_school_w +1;
            in_school_at_t_minus_1_w=1;
			if (year_of_school_w < 12)
				WS = 1;
				W_HSD = 1;
			elseif (year_of_school_w == 12)
				WS = 2;
				W_HSD = 0; W_HSG = 1;
			elseif (year_of_school_w > 12 &&  year_of_school_w < 15)
				WS = 3;
				W_HSD = 0; W_HSG = 0; W_SC = 1;
			elseif (year_of_school_w > 14 &&  year_of_school_w < 18)
				WS = 4;
				W_HSD = 0; W_HSG = 0; W_SC = 0; W_CG = 1;
			elseif (year_of_school_w > 17 )
				WS = 5;
				W_HSD = 0; W_HSG = 0; W_SC = 0; W_CG = 0; W_PC = 1;
			end
        else
           in_school_at_t_minus_1_w = 0;
		end			
		if ( optimization_desicion_h_i > 5 )  %stay married or get married
        in_school_at_t_minus_1=0;
			if (M == 0) %just got married, create common kids
				if (W_N + H_N >4)
					C_N = 4;
				else	
					C_N = W_N + H_N;
				end
				W_N = 0;
				H_N = 0;
		         % ASSORTATIVE MATING MOMENTS
		        assortative_mating(HS, WS, cohort) = assortative_mating(HS, WS, cohort)+1;
				count_assortative_mating(WS, cohort) = count_assortative_mating(WS, cohort)+1;
			end
			dur = dur + 1;
			D = 0;
			M = 1;			
		elseif 	((M == 1) && optimization_desicion_h_i < 6 )  %get divorced
			dur = 0;
			D = 1;
			M = 0;
			W_N = C_N;
			H_N = C_N;
			C_N = 0;
            Q_UTILITY_PERMANENT = 0;
		elseif 	((M == 0) && optimization_desicion_h_i < 6 )  %stay single
			dur = 0;
			%divorce = 0;   remove the comment and divorce will be only for 1 period and then she can go back to school
			M = 0;
		else
			error(0);
		end
		if ( optimization_desicion_w_i == 2 || optimization_desicion_w_i == 4 || optimization_desicion_w_i == 7 || ...
			 optimization_desicion_w_i == 9 || optimization_desicion_w_i == 11 || optimization_desicion_w_i == 13)  %pregnancy 
			P = 1;
			if (M == 1 && C_N <4 )
				C_N = C_N + 1;
			elseif (M == 0 && W_N <4)
				W_N = W_N + 1;
			end	
		else
			P = 0;
		end
		if (optimization_desicion_w_i == 3 ||optimization_desicion_w_i == 4 || optimization_desicion_w_i == 8 || ...
			 optimization_desicion_w_i == 9 ||optimization_desicion_w_i == 12 || optimization_desicion_w_i == 13) % women work
			WK = WK + 1;
			prev_state_w = 1;
			prev_capacity_w =capacity_w; 
		else
			prev_state_w = 0;
			prev_capacity_w =0; 
		end	
		if (optimization_desicion_h_i == 3 ||optimization_desicion_h_i == 6 || optimization_desicion_h_i == 7 || ...
			 optimization_desicion_h_i == 8 ||optimization_desicion_h_i == 9 ) 									% man work
			HK = HK + 1;
			prev_state_h = 1;
			prev_capacity_h =capacity_h; 
		else
			prev_state_h = 0;
			prev_capacity_h = 0; 
		end	

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%   CREATE AND SAVE MOMENTS
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%individual moments:
		if (prev_state_w==0)
			emp_w(t,1, cohort)= emp_w(t,1, cohort)+1;         % unemployment total - prev_state is actually current state at this point
		elseif 	(prev_state_w==1 && capacity_w==1)
			emp_w(t,2,cohort)= emp_w(t,2,cohort)+ 1;         % full time employment total - prev_state is actually current state at this point
		elseif 	(prev_state_w==1 && capacity_w==0.5)
			emp_w(t,3, cohort)= emp_w(t,3, cohort)+1;         % part time employment total - prev_state is actually current state at this point
		else
			assert(0);
		end
		school_dist_w(t, WS,cohort) = school_dist_w(t, WS,cohort)+1;  %women schooling distribution
		emp_by_educ(t, WS,cohort) = emp_by_educ(t, WS,cohort)+prev_state_w; %women employment by education
		count_emp_by_educ(t, WS,cohort)=count_emp_by_educ(t, WS,cohort)+1;  %women wage by education
        health_dist_w(t, W_HEALTH,cohort) = health_dist_w(t, W_HEALTH,cohort) +1 ;
		if (CHOOSE_HUSBAND == 1 || M == 1)
			if (prev_state_h==0)
				emp_h(t,1,cohort)= emp_h(t,1,cohort)+1;         % employment total - prev_state is actually current state at this point
			elseif 	(prev_state_h==1 && capacity_h==1)
				emp_h(t,2,cohort)= emp_h(t,2,cohort)+1;         % employment total - prev_state is actually current state at this point
                emp_h(t,4,cohort)= emp_h(t,4,cohort)+1;
            elseif 	(prev_state_h==1 && capacity_h==0.5)
				emp_h(t,3,cohort)= emp_h(t,3,cohort)+1;         % employment total - prev_state is actually current state at this point
                 emp_h(t,4,cohort)= emp_h(t,4,cohort)+1;
            else
                assert(0);
			end
			count_emp_h(t,cohort)=count_emp_h(t,cohort)+1;
			school_dist_h(t, HS,cohort) = school_dist_h(t, HS,cohort)+1;
			count_school_dist_h(t,cohort) = count_school_dist_h(t,cohort)+1;
            health_dist_h(t, H_HEALTH,cohort) = health_dist_h(t, H_HEALTH,cohort)+1;
            count_health_dist_h(t,cohort) = count_health_dist_h(t,cohort) +1;   
		end
		if (M == 0)	        % employment unmarried
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%                   UNMARRIED WOMEN EMPLOYMENT BY KIDS INDIVIDUAL MOMENTS                       %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (prev_state_w==0)
                emp_um_w(t,1, cohort)= emp_um_w(t,1, cohort)+1;         % unemployment total - prev_state is actually current state at this point
            elseif 	(prev_state_w==1 && capacity_w==1)
            	emp_um_w(t,2,cohort)= emp_um_w(t,2,cohort)+ 1;         % full time employment total - prev_state is actually current state at this point
            elseif 	(prev_state_w==1 && capacity_w==0.5)
            	emp_um_w(t,3, cohort)= emp_um_w(t,3, cohort)+1;         % part time employment total - prev_state is actually current state at this point
            else
            	assert(0);
            end
			if (W_N == 0)
				emp_um_no_kids_w(t,cohort) = emp_um_no_kids_w(t,cohort) + prev_state_w;     % employment unmarried and no children
				count_emp_um_no_kids_w(t,cohort) = count_emp_um_no_kids_w(t,cohort) + 1;
			else
				emp_um_kids_w(t,cohort) = emp_um_kids_w(t,cohort) + prev_state_w;            % employment unmarried and children
				count_emp_um_kids_w(t,cohort) = count_emp_um_kids_w(t,cohort) + 1;
            end
        elseif (M == 1)    % employment unmarried
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%                   MARRIED WOMEN EMPLOYMENT BY KIDS INDIVIDUAL MOMENTS
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (prev_state_w==0)
                emp_m_w(t,1, cohort)= emp_m_w(t,1, cohort)+1;         % unemployment total - prev_state is actually current state at this point
            elseif 	(prev_state_w==1 && capacity_w==1)
            	emp_m_w(t,2,cohort)= emp_m_w(t,2,cohort)+ 1;         % full time employment total - prev_state is actually current state at this point
            elseif 	(prev_state_w==1 && capacity_w==0.5)
            	emp_m_w(t,3, cohort)= emp_m_w(t,3, cohort)+1;         % part time employment total - prev_state is actually current state at this point
            else
            	assert(0);
            end
            if (C_N == 0  )
    			emp_m_no_kids_w(t,cohort) = emp_m_no_kids_w(t,cohort) + prev_state_w;         % employment married no kids
        		count_emp_m_no_kids_w(t,cohort)=count_emp_m_no_kids_w(t,cohort)+1;
            elseif (C_N > 0)
                emp_m_with_kids_w(t,cohort) = emp_m_with_kids_w(t,cohort)+ prev_state_w;          % employment married 1 kid
                count_emp_m_with_kids_w(t,cohort) = count_emp_m_with_kids_w(t,cohort)+1;
            end
        else
            assert(0);
        end
	  
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%                    WAGES MOMENTS
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if (prev_state_w == 1 && capacity_w==1 && wage_w>0)
			wages_w(draw_f, t,cohort)=wage_w;        % women wages if employed by experience
			wage_by_educ(t, WS,cohort) = wage_by_educ(t, WS,cohort)+wage_w;
			count_wage_by_educ(t, WS,cohort) = count_wage_by_educ(t, WS,cohort)+1;
		end 
		if (M == 1 && prev_state_h == 1 && capacity_h==1 && wage_h>0 )
			wages_m_h(draw_f, t,cohort)=wage_h;         % married men wages
		end	
		if (M == 1 && prev_state_w == 1 && capacity_w==1 && wage_w>0 )            %prev_state is actually current state at this point
			wages_m_w(draw_f, t,cohort)=wage_w;          % married women wages if employed
		elseif (M == 0 && prev_state_w == 1 && capacity_w==1 && wage_w>0)
			wages_um_w(draw_f, t,cohort)=wage_w;         % unmarried women wages if employed
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%           FERTILITY AND MARRIED RATE MOMENTS
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		married(t,cohort) = married(t,cohort) + M  ;             % married yes/no
		newborn(t,cohort) = newborn(t,cohort) + P;               % new born in period t - for probability and distribution
		divorce_arr(t,cohort)= divorce_arr(t,cohort) + D;
        if (M == 1)
			newborn_m(t,cohort)= newborn_m(t,cohort) + P;           % new born in period t - for probability and distribution
			count_newborn_m(t,cohort) = count_newborn_m(t,cohort)+1;
		else
			newborn_um(t,cohort)= newborn_um(t,cohort)+ P;          % new born in period t - for probability and distribution
			count_newborn_um(t,cohort) = count_newborn_um(t,cohort)+1;
		end
		%duration_of_first_marriage(draw_f, school_group) = D_T_minus_1 ;
		if (M==1)
			kids(t,cohort) = kids(t,cohort) + C_N ;          % # of children by age
			kids_m(t,cohort) = kids_m(t,cohort) + C_N;			% # of children for married women
		else
			kids(t,cohort) = kids(t,cohort) +	W_N ;          % # of children by school group
			kids_um(t,cohort) = kids_um(t,cohort) + W_N;
		end
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           END MOMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	end % close the time loop
end % close the draw_f loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            CLOSE SOLVING FORWARD           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS SUMMARY - CREATES MOMENTS IN THE SAME FORMAT AS ACTUAL MOMENTS FOR OBJECTIVE SGMM FUNCTION %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1-age 2-emp 3-married 4-child18 5-wage 6-emp_m 7-child18_m 8-wage_m 9-emp_um 10-wage_um 11-emp_divorce 12-emp_m_with_c 13-emp_m_no_c 14-emp_um_with_c 15-emp_um_no_c
%moments_emp = [moments1(1:43,2:6) moments2(1:43,3:5) moments3(1:43,3:4)  moments4(1:43,3) moments5(1:43,3)];   %11 moments + age
%  1-age 2-6emp_by_educ   7-11emp_m_by_educ 12-16wage_by_educ 17-21wage_m_by_educ 22-26educ_dist 27-31educ_m_dist
%moments_educ = [moments6(1:43,2:7) moments7(1:43,3:7) moments8(1:43,3:7)  moments9(1:43,3:7) moments10(1:43,3:7) moments11(1:43,3:7)]; % 30 moments + age
age_vec = [17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61  ]';
sep_vec = ones(43,1);
tmp_married = married;                % married yes/no
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% emp_sd - employment moments - 13 by 43 matrix - 
% men emp, women emp, married women emp, unmarried women emp, married with kids, married no KIDS, unmarried with kids, unmarried no KIDS, emp by educ for women %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
f_emp_w = (emp_w./DRAW_F); %(mean(emp_w))' ;% employment total by age:zeros(T_MAX,3, num_cohort);
f_emp_h(:,:,1) = (emp_h(:,:,1)./[count_emp_h(:,1) count_emp_h(:,1) count_emp_h(:,1) count_emp_h(:,1)]); % employment total by age:zeros(T_MAX,3, num_cohort);
f_emp_h(:,:,2) = (emp_h(:,:,2)./[count_emp_h(:,2) count_emp_h(:,2) count_emp_h(:,2) count_emp_h(:,2)]); % employment total by age:zeros(T_MAX,3, num_cohort);
f_emp_h(:,:,3) = (emp_h(:,:,3)./[count_emp_h(:,3) count_emp_h(:,3) count_emp_h(:,3) count_emp_h(:,3)]); % employment total by age:zeros(T_MAX,3, num_cohort);
f_emp_m(:,:,1)  = (emp_m_w(:,:,1) ./[tmp_married(:,1) tmp_married(:,1) tmp_married(:,1)]);
f_emp_m(:,:,2)  = (emp_m_w(:,:,2) ./[tmp_married(:,2) tmp_married(:,2) tmp_married(:,2)]);
f_emp_m(:,:,3)  = (emp_m_w(:,:,3) ./[tmp_married(:,3) tmp_married(:,3) tmp_married(:,3)]);

%f_emp_um = sum(emp_um_w);                     % employment unmarried 
tmp_unmarried = [DRAW_F - tmp_married];
f_emp_um(:,:,1)  = (emp_um_w(:,:,1) ./[tmp_unmarried(:,1) tmp_unmarried(:,1) tmp_unmarried(:,1)]);
f_emp_um(:,:,2)  = (emp_um_w(:,:,2) ./[tmp_unmarried(:,2) tmp_unmarried(:,2) tmp_unmarried(:,2)]);
f_emp_um(:,:,3)  = (emp_um_w(:,:,3) ./[tmp_unmarried(:,3) tmp_unmarried(:,3) tmp_unmarried(:,3)]);
%emp_moments_fitted_45 = [ f_emp_h(1:43,1)  f_emp_w(1:43,1) f_emp_m(1:43,1)  f_emp_um(1:43,1) ];
%emp_moments_fitted_55 = [ f_emp_h(1:43,2)  f_emp_w(1:43,2) f_emp_m(1:43,2)  f_emp_um(1:43,2) ];
%emp_moments_fitted_65 = [ f_emp_h(1:43,3)  f_emp_w(1:43,3) f_emp_m(1:43,3)  f_emp_um(1:43,3) ];
%emp_moments = [ h_moments_emp(1:43,2) w_moments_emp(1:43,2) w_moments_emp(1:43,6) w_moments_emp(1:43,9)];
%emp_sd = nansum((emp_moments - emp_moments_fitted_55).^2);
size(age_vec(5:43));
size(f_emp_h(5:43,4,1));
size( emp_mrate_child_wage(1:39,4)  );
size(   emp_mrate_child_wage(99:138,4)  );
size( emp_mrate_child_wage(189:228,4)  );
tmp=emp_mrate_child_wage(189+4:233,4);% the 1965 cohort has observations until age 51
tmp(32:41,1)=0; 
format short g;
disp('			HUSBAND EMP         ');
disp('  45-fitted 45-actual 55-fitted 55-actual 65-fitted 65 actual');
temp = [age_vec(5:45) f_emp_h(1+4:45,4,1) emp_mrate_child_wage(1:41,4)...
         f_emp_h(5:45,4,2) emp_mrate_child_wage(99+4:143,4)...
         f_emp_h(5:45,4,3) tmp]
subplot(1,3,1); plot(age_vec(5:45),f_emp_h(1+4:45,4,1),age_vec(5:45),emp_mrate_child_wage(1:41,4));title('men emp 1945');legend('fitted','actual');axis([20 61 0.5 1]);
subplot(1,3,2); plot(age_vec(5:45),f_emp_h(1+4:45,4,2),age_vec(5:45),emp_mrate_child_wage(99+4:143,4));title('men emp 1955');legend('fitted','actual');axis([20 61 0.5 1]);
subplot(1,3,3); plot(age_vec(5:45),f_emp_h(1+4:45,4,3),age_vec(5:45),tmp);title('men emp 1965');legend('fitted','actual');axis([20 61 0.5 1]);


disp('			       WIFE EMP 1955  		   ');
disp('  	       FITTED               ACTUAL         ');
temp = [age_vec(5:45) f_emp_w(1+4:45,:,2) emp_mrate_child_wage(144+4:188,[11 9 10])  ]
subplot(3,3,1); plot(age_vec(5:45),f_emp_w(1+4:45,1,2),age_vec(5:45),emp_mrate_child_wage(144+4:188,11));title('women unemp 1955');legend('fitted','actual');axis([20 61 0 1]);
subplot(3,3,2); plot(age_vec(5:45),f_emp_w(1+4:45,2,2),age_vec(5:45),emp_mrate_child_wage(144+4:188,9));title('women full 1955');legend('fitted','actual');axis([20 61 0 1]);
subplot(3,3,3); plot(age_vec(5:45),f_emp_w(1+4:45,3,2),age_vec(5:45),emp_mrate_child_wage(144+4:188,10));title('women part 1955');legend('fitted','actual');axis([20 61 0 1]);



disp('			 MARRIED WOMEN EMP 1955   ');
disp('  	       FITTED               ACTUAL         ');
temp = [age_vec(5:45) f_emp_m(1+4:45,:,2) emp_mrate_child_wage_m(144+4:188,[11 9 10])  ]
subplot(3,3,4); plot(age_vec(5:45),f_emp_m(1+4:45,1,2),age_vec(5:45),emp_mrate_child_wage_m(144+4:188,11));title('M women unemp 1955');legend('fitted','actual');axis([20 61 0 1]);
subplot(3,3,5); plot(age_vec(5:45),f_emp_m(1+4:45,2,2),age_vec(5:45),emp_mrate_child_wage_m(144+4:188,9));title('M women full 1955');legend('fitted','actual');axis([20 61 0 1]);
subplot(3,3,6); plot(age_vec(5:45),f_emp_m(1+4:45,3,2),age_vec(5:45),emp_mrate_child_wage_m(144+4:188,10));title('M women part 1955');legend('fitted','actual');axis([20 61 0 1]);

disp('			UNMARRIED WOMEN EMP 1955  ');
disp('  	       FITTED               ACTUAL          ');
temp = [age_vec(5:45) f_emp_um(1+4:45,:,2) emp_mrate_child_wage_um(144+4:188,[11 9 10])  ]
subplot(3,3,7); plot(age_vec(5:45),f_emp_um(1+4:45,1,2),age_vec(5:45),emp_mrate_child_wage_um(144+4:188,11));title('M women unemp 1955');legend('fitted','actual');axis([20 61 0 1]);
subplot(3,3,8); plot(age_vec(5:45),f_emp_um(1+4:45,2,2),age_vec(5:45),emp_mrate_child_wage_um(144+4:188,9));title('M women full 1955');legend('fitted','actual');axis([20 61 0 1]);
subplot(3,3,9); plot(age_vec(5:45),f_emp_um(1+4:45,3,2),age_vec(5:45),emp_mrate_child_wage_um(144+4:188,10));title('M women part 1955');legend('fitted','actual');axis([20 61 0 1]);

% 4 moments: emp by children for married : married with kids, married with NO KIDS, unmarried with kids, unmarried with NO KIDS
f_emp_m_with_kids =    (emp_m_with_kids_w)./count_emp_m_with_kids_w;
f_emp_m_no_kids   =    (emp_m_no_kids_w)./count_emp_m_no_kids_w;
f_emp_um_kids	  =    (emp_um_kids_w)./count_emp_um_kids_w;
f_emp_um_no_kids  =    (emp_um_no_kids_w)./count_emp_um_no_kids_w;
kids_emp_moments = [ emp_m_with(1:41,4) emp_m_without(1:41,4) emp_um_with(1:41,4) emp_um_without(1:41,4) ];
ff_kids_emp = [ f_emp_m_with_kids(1+4:45,2) f_emp_m_no_kids(1+4:45,2)  f_emp_um_kids(1+4:45,2) f_emp_um_no_kids(1+4:45,2)];
kids_emp_sd = nansum((kids_emp_moments - ff_kids_emp).^2);
disp ('Married Women employment by number of children - with  children, with no children 1955'      );
disp ('        FITTED		ACTUAL		FITTED		ACTUAL		                               ');
temp  = [age_vec(5:45)   f_emp_m_with_kids(1+4:45,2) emp_m_with(1:41,4) f_emp_m_no_kids(1+4:45,2) emp_m_without(1:41,4)]
disp ('UnMarried Women employment by number of children - with children, with no children 1955 '      );
disp ('        FITTED		ACTUAL		FITTED		ACTUAL		                               ');
temp  = [age_vec(5:45)   f_emp_um_kids(1+4:45,2) emp_um_with(1:41,4) f_emp_um_no_kids(1+4:45,2) emp_um_without(1:41,4)]

f_emp_by_educ = emp_by_educ./count_emp_by_educ ;   %T by 5 levels by 3 cohorts
men_emp_by_educ_moments_45 = [emp_wage_by_educ(1:41,5) emp_wage_by_educ(46:46+41,5) emp_wage_by_educ(91:91+41,5) emp_wage_by_educ(136:136+41,5) emp_wage_by_educ(181:181+41,5)];
women_emp_by_educ_moments_45 = [emp_wage_by_educ(226:266,5) emp_wage_by_educ(271:311,5) emp_wage_by_educ(316:356,5) emp_wage_by_educ(361:401,5) emp_wage_by_educ(406:446,5)];
men_emp_by_educ_moments_55 = [emp_wage_by_educ(451:491,5) emp_wage_by_educ(492:532,5) emp_wage_by_educ(533:573,5) emp_wage_by_educ(574:614,5) emp_wage_by_educ(615:655,5)];
women_emp_by_educ_moments_55 = [emp_wage_by_educ(656:696,5) emp_wage_by_educ(697:737,5) emp_wage_by_educ(738:778,5) emp_wage_by_educ(779:819,5) emp_wage_by_educ(820:860,5)];
men_emp_by_educ_moments_65 = [emp_wage_by_educ(861:891,5) emp_wage_by_educ(892:922,5) emp_wage_by_educ(923:953,5) emp_wage_by_educ(954:984,5) emp_wage_by_educ(985:1015,5)];
women_emp_by_educ_moments_65 = [emp_wage_by_educ(1016:1046,5) emp_wage_by_educ(1047:1077,5) emp_wage_by_educ(1078:1108,5) emp_wage_by_educ(1109:1139,5) emp_wage_by_educ(1140:1170,5)];
men_emp_by_educ_moments_65(32:41,:)=0;women_emp_by_educ_moments_65(32:41,:)=0;

f_emp_by_educ(1:2,2,:)= 0;
f_emp_by_educ(1:3,3,:)= 0;
f_emp_by_educ(1:6,4,:)= 0;
f_emp_by_educ(1:9,5,:)= 0;
emp_by_educ_moments(1:2,2)= 0;
emp_by_educ_moments(1:3,3)= 0;
emp_by_educ_moments(1:6,4)= 0;
emp_by_educ_moments(1:9,5)= 0;
size(emp_by_educ_moments(1:43,:)); % 45,5
size(f_emp_by_educ(1:43,:));       % 43,5,3
%emp_by_educ_sd = nansum((emp_by_educ_moments(1:43,:)-f_emp_by_educ(1:43,:,2)).^2);
disp('		female employment by education level 1955: ');
disp('         FITTED							ACTUAL                                ');
format bank;
tmp = [ f_emp_by_educ(5:45,:,2) sep_vec(1:41) women_emp_by_educ_moments_55(1:41,:) ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%schooling distribution moments - 10 by 43 matrix   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%women schooling distribution
f_school_dist_w = school_dist_w./DRAW_F;
f_school_dist_w(1:2,2,:)= 0;
f_school_dist_w(1:3,3,:)= 0;
f_school_dist_w(1:6,4,:)= 0;
f_school_dist_w(1:9,5,:)= 0;
%husbands schooling distribution
tmp1 = [count_school_dist_h(:,1) count_school_dist_h(:,1) count_school_dist_h(:,1) count_school_dist_h(:,1) count_school_dist_h(:,1)];
tmp2 = [count_school_dist_h(:,2) count_school_dist_h(:,2) count_school_dist_h(:,2) count_school_dist_h(:,2) count_school_dist_h(:,2)];
tmp3 = [count_school_dist_h(:,3) count_school_dist_h(:,3) count_school_dist_h(:,3) count_school_dist_h(:,3) count_school_dist_h(:,3)];
f_school_dist_h(:,:,1) = school_dist_h(:,:,1)./tmp1; %male schooling distribution
f_school_dist_h(:,:,2) = school_dist_h(:,:,2)./tmp2; %male schooling distribution
f_school_dist_h(:,:,3) = school_dist_h(:,:,3)./tmp3; %male schooling distribution
f_school_dist_h(1:2,2,:)= 0;
f_school_dist_h(1:3,3,:)= 0;
f_school_dist_h(1:6,4,:)= 0;
f_school_dist_h(1:9,5,:)= 0;
educ_comp(1:2,5)= 0;educ_comp(14+1:14+2,5)= 0;educ_comp(28+1:28+2,5)= 0;educ_comp(42+1:42+2,5)= 0;educ_comp(56+1:56+2,5)= 0;educ_comp(70+1:70+2,5)= 0;
educ_comp(1:2,6)= 0;educ_comp(14+1:14+3,6)= 0;educ_comp(28+1:28+3,6)= 0;educ_comp(42+1:42+3,6)= 0;educ_comp(56+1:56+3,6)= 0;educ_comp(70+1:70+3,6)= 0;
educ_comp(1:2,7)= 0;educ_comp(14+1:14+6,7)= 0;educ_comp(28+1:28+6,7)= 0;educ_comp(42+1:42+6,7)= 0;educ_comp(56+1:56+6,7)= 0;educ_comp(70+1:70+6,7)= 0;
educ_comp(1:2,8)= 0;educ_comp(14+1:14+9,8)= 0;educ_comp(28+1:28+9,8)= 0;educ_comp(42+1:42+9,8)= 0;educ_comp(56+1:56+9,8)= 0;educ_comp(70+1:70+9,8)= 0;
%school_d_sd_w = nansum((f_school_dist_w(1:15,:,2) - educ_comp(1:14,:)).^2);
disp('		female schooling distribution 1955: ');
disp('         FITTED							ACTUAL                                ');
tmp = [ f_school_dist_w(1:14,:,2) sep_vec(1:14) educ_comp(43:56,:)   ]
%husbands schooling distribution
%school_d_sd_h = nansum((f_school_dist_h(1:15,:,2) - school_moments_h(1:15,:)).^2);
disp('		male schooling distribution 1955: ');
disp('         FITTED						    ACTUAL       ');
tmp = [ f_school_dist_h(1:14,:,2) sep_vec(1:14) educ_comp(29:42,:) ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% marr_fer_moments - 3 by 43 matrix - marriage rate,divorce rate, fertility rate, married women fertility rate %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_married = married./DRAW_F; 
f_fertility = newborn./DRAW_F; 
f_fertility_um = newborn_um./count_newborn_um;
f_fertility_m = newborn_m./count_newborn_m;
f_divorce =divorce_arr/DRAW_F;   
f_kids = kids./DRAW_F ;     % # of children 
f_kids_m = (kids_m./tmp_married);
mar_sd = nansum((emp_mrate_child_wage(1:45,5) - f_married(1:45,2)).^2);
disp('		MARRIAGE RATE 1955     ');
disp('  		 FITTED       ACTUAL             ');
format short g;
temp = [ age_vec(1:45) f_married(1:45,2)   emp_mrate_child_wage(1:45,5)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
divor_sd = nansum((emp_mrate_child_wage(1:45,6) - f_divorce(1:45,2)).^2);
disp('		DIVORCE RATE 1955      ');
disp('  		 FITTED       ACTUAL             ');
format short g;
temp = [ age_vec(1:45) f_divorce(1:45,2)   emp_mrate_child_wage(1:45,6)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kids_moments_fitted = [ f_kids(1:25,2)  f_kids_m(1:25,2)];
kids_moments = [emp_mrate_child_wage(1:25,7) emp_mrate_child_wage_m(1:25,7)];
kids_sd = nansum((kids_moments - kids_moments_fitted).^2);
disp('		WOMEN # OF CHILDREN       MARRIED WOMEN # OF CHILDREN ');
disp('  		 FITTED    ACTUAL        FITTED     ACTUAL    ');
temp = [  age_vec(1:25) f_kids(1:25,:)  emp_mrate_child_wage(1:25,7)  f_kids_m(1:25,:) emp_mrate_child_wage_m(1:25,7)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%wage_moments - 9 by 43 matrix - women wage, married women wage, unmarried women wage, men wage, wage by educ for women only %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind_tmp=(wages_m_h>0);    % married men wages
tmp = wages_m_h.*ind_tmp;
f_wages_m_h = (sum(tmp)./sum(ind_tmp)); 
f_wages_m_h1=(f_wages_m_h(:,:,1))'
f_wages_m_h2=(f_wages_m_h(:,:,2))'
f_wages_m_h3=(f_wages_m_h(:,:,3))'

ind_tmp=(wages_w>0);    % women wages
tmp = wages_w.*ind_tmp;
f_wages_w = (sum(tmp)./sum(ind_tmp));
f_wages_w_1=(f_wages_w(:,:,1))'
f_wages_w_2=(f_wages_w(:,:,2))'
f_wages_w_3=(f_wages_w(:,:,3))'

ind_tmp=(wages_m_w>0);    % married women wages
tmp = wages_m_w.*ind_tmp;
f_wages_m_w = (sum(tmp)./sum(ind_tmp)); 
f_wages_m_w1=(f_wages_m_w(:,:,1))'
f_wages_m_w2=(f_wages_m_w(:,:,2))'
f_wages_m_w3=(f_wages_m_w(:,:,3))'

ind_tmp=(wages_um_w>0);    % unmarried women wages
tmp = wages_um_w.*ind_tmp;
f_wages_um_w = (sum(tmp)./sum(ind_tmp)); 
f_wages_um_w1=(f_wages_um_w(:,:,1))'
f_wages_um_w2=(f_wages_um_w(:,:,2))'
f_wages_um_w3=(f_wages_um_w(:,:,3))'

tmp=emp_mrate_child_wage(189+4:233,8);% the 1965 cohort has observations until age 51
tmp(32:41,1)=0; 
format short g;
disp('			HUSBAND WAGES         ');
disp('  45-fitted 45-actual 55-fitted 55-actual 65-fitted 65 actual');
temp = [age_vec(5:45) f_wages_w_1 emp_mrate_child_wage(1:41,8)...
         f_wages_w_2 emp_mrate_child_wage(99+4:143,8) f_wages_w_3 tmp]
subplot(1,3,1); plot(age_vec(5:45),f_wages_w_1,age_vec(5:45),emp_mrate_child_wage(1:41,8));title('men WAGE 1945');legend('fitted','actual');axis([20 61 0.5 1]);
subplot(1,3,2); plot(age_vec(5:45),f_wages_w_2,age_vec(5:45),emp_mrate_child_wage(99+4:143,8));title('men WAGE 1955');legend('fitted','actual');axis([20 61 0.5 1]);
subplot(1,3,3); plot(age_vec(5:45),f_wages_w_3,age_vec(5:45),tmp);title('men WAGE 1965');legend('fitted','actual');axis([20 61 0.5 1]);
h_wage_sd = nansum((emp_mrate_child_wage(99+4:143,8) - f_wages_m_h2(1:43,:)).^2);



wage_moments_w = [ w_moments_emp(:,5)  w_moments_emp(:,8) w_moments_emp(:,10) ]; % all women wage
ff_wages_w = [f_wages_w_2(1:43,:)  f_wages_m_w2(1:43,:) f_wages_um_w2(1:43,:)  ];
w_wage_sd = nansum((wage_moments_w - ff_wages_w).^2);
disp ('              WOMEN WAGE   	     MARRIED WOMEN WAGE		UNMARRIED WOMEN WAGE	 '       );
disp ('              FITTED		ACTUAL		FITTED		ACTUAL		FITTED		ACTUAL                                ');
% calculate for 43 periods, display only for 33 - age 22-55
%disp('		HSG ACTUAL HSG FITTED SC ACTUAL SC FITTED CG ACTUAL CG FITTED PC ACTUAL PC FITTED ')
%disp('		HSD ACTUAL HSD FITTED HSG ACTUAL HSG FITTED SC ACTUAL SC FITTED CG ACTUAL CG FITTED PC ACTUAL PC FITTED ')
f_wage_by_educ = wage_by_educ./count_wage_by_educ;
wage_by_educ_moments = w_moments_educ(:,12:16);
f_wage_by_educ(1:2,2,:)= 0;
f_wage_by_educ(1:3,3,:)= 0;
f_wage_by_educ(1:6,4,:)= 0;
f_wage_by_educ(1:9,5,:)= 0;
wage_by_educ_moments(1:2,2)= 0;
wage_by_educ_moments(1:3,3)= 0;
wage_by_educ_moments(1:6,4)= 0;
wage_by_educ_moments(1:9,5)= 0;
wage_by_educ_sd = nansum((wage_by_educ_moments(1:43,:)-f_wage_by_educ(1:43,:,2)).^2);
disp('		female wage by education level: ');
disp('         FITTED							ACTUAL                                ');
tmp = [ f_wage_by_educ(7:40,:,2) wage_by_educ_moments(7:40,:) ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assortative mating - 5 by 5 matrix % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Husband                  Wife  Education group
%* Education |       HSD        HSG         SC         CG         PC |     Total
%*-----------+-------------------------------------------------------+----------
%*       HSD |     56.69      11.83       4.72       1.67       0.99 |     12.54 
%*-----------+-------------------------------------------------------+----------
%*       HSG |     30.74      52.06      24.52      11.77       7.23 |     31.95 
%*-----------+-------------------------------------------------------+----------
%*        SC |     10.02      24.28      41.59      21.23      15.35 |     26.10 
%*-----------+-------------------------------------------------------+----------
%*        CG |      1.99       9.26      20.75      42.51      28.01 |     18.67 
%*-----------+-------------------------------------------------------+----------
%*        PC |      0.56       2.56       8.43      22.82      48.41 |     10.74 
%*-----------+-------------------------------------------------------+----------
format bank;
assortative_mating(:,:,2)

tmp_count1 = [count_assortative_mating(:,1) count_assortative_mating(:,1) count_assortative_mating(:,1) count_assortative_mating(:,1) count_assortative_mating(:,1)]'
tmp_count2 = [count_assortative_mating(:,2) count_assortative_mating(:,2) count_assortative_mating(:,2) count_assortative_mating(:,2) count_assortative_mating(:,2)]'
tmp_count3 = [count_assortative_mating(:,3) count_assortative_mating(:,3) count_assortative_mating(:,3) count_assortative_mating(:,3) count_assortative_mating(:,3)]'

f_assortative_mating(:,:,1) = assortative_mating(:,:,1)./tmp_count1;
f_assortative_mating(:,:,2) = assortative_mating(:,:,2)./tmp_count2;
f_assortative_mating(:,:,3) = assortative_mating(:,:,3)./tmp_count3;
title1 = char( 'HSD' ,'HSG ' ,'SC ', 'CG ' ,'PC ');
disp ('		   ASSORTATIVE MATING -  husband education-rows, wife education-column	 '       );
disp ('        FITTED					         ACTUAL                     ');
temp = [  f_assortative_mating(:,:,2).*100 c_moments(:,1:5) ] 
mating_sd = nansum((c_moments(:,1:5)./100 - f_assortative_mating(:,:,2)).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%health distribution moments - 6 by 43 matrix   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
f_health_dist_w = health_dist_w./DRAW_F;  %women health distribution
health_moments_w = [ health_w(:,2)   (health_w(:,3)-health_w(:,2))    (1-health_w(:,3)) ] ;
health_d_sd_w = nansum((f_health_dist_w(1:43,:,2) - health_moments_w(1:43,:)).^2);
disp('		female health distribution: ');
disp('         FITTED							ACTUAL                                ');
tmp = [ f_health_dist_w(1:43,:,2) sep_vec(1:43) health_moments_w(1:43,:)   ]
%husbands schooling distribution
tmp1 = [count_health_dist_h(:,1) count_health_dist_h(:,1) count_health_dist_h(:,1) ];
tmp2 = [count_health_dist_h(:,2) count_health_dist_h(:,2) count_health_dist_h(:,2) ];
tmp3 = [count_health_dist_h(:,3) count_health_dist_h(:,3) count_health_dist_h(:,3) ];
f_health_dist_h(:,:,1) = health_dist_h(:,:,1)./tmp1; %male health distribution
f_health_dist_h(:,:,2) = health_dist_h(:,:,2)./tmp2; %male health distribution
f_health_dist_h(:,:,3) = health_dist_h(:,:,3)./tmp3; %male health distribution
health_moments_h = [ health_h(:,2)   (health_h(:,3)-health_h(:,2))    (1-health_h(:,3)) ] ;
health_d_sd_h = nansum((f_health_dist_h(1:43,:,2) - health_moments_h(1:43,:)).^2);
disp('		male health distribution: ');
disp('         FITTED						    ACTUAL       ');
tmp = [ f_health_dist_h(1:43,:,2) sep_vec(1:43) health_moments_h(1:43, :) ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           CLOSE MOMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
objective_function = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    ESTIMATION PROCESS - SGMM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wage_actual_std = [ 11697.40153    11470.70449   11362.53483   19288.28561];
w_wage_by_education_std = [4094.164346	6208.976338	9663.951099	16218.99479	25880.24733];
wage_actual_var = wage_actual_std.^2;
w_wage_by_education_var = w_wage_by_education_std.^2;
%devide by moment weight
%emp_sd = emp_sd./emp_moments(29,2:13);
%kids_emp_sd 
%school_d_sd_w 
%school_d_sd_h
%mar_sd
%kids_sd
%emp_by_educ_sd
wage_by_educ_sd = wage_by_educ_sd./w_wage_by_education_var;
w_wage_sd = w_wage_sd./wage_actual_var(1,1:3);
h_wage_sd = h_wage_sd./wage_actual_var(1,4);
%mating_sd = general_sd./general_moments(32:62,:);
objective_function=nansum(emp_sd)+nansum(kids_emp_sd)+nansum(school_d_sd_w)+nansum(school_d_sd_h)+nansum(mar_sd)+...
	nansum(kids_sd)+nansum(w_wage_sd)+nansum(h_wage_sd)+nansum(mating_sd)+nansum(wage_by_educ_sd)+nansum(emp_by_educ_sd)
	%proportion of Wage and # of children in objective function too big, need to take care of weighting matrix
end

