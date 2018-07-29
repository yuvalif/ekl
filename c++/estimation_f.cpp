#include <math.h>
#include <assert.h>
#include "global_params.h"
#include "data.h"
#include "random_values.h"
#include "octave_utils.h"
#include "draw_partner.h"
#include "health.h"
#include "wage_calc.h"
#include "calculate_utility.h"
#include "optimization_decision.h"

using namespace octave_utils;

float estimation_f(int husband_prev_kids, int husband_prev_emp, int wife_prev_kids, int wife_prev_emp,
        float emp_mrate_child_wage, float emp_mrate_child_wage_m, float emp_mrate_child_wage_um,
        float emp_m_with, float emp_m_without, float emp_um_with, float emp_um_without, 
        float emp_wage_by_educ, float emp_wage_by_educ_m, float emp_wage_by_educ_um,
        float educ_comp, float educ_comp_m, float assortative, float nlsy_trans)
{
    ////////////////////////////////////
    // PARAMETERS     //
    ////////////////////////////////////
    // meeting a partner parameters
    omega1   = global_param(1);    //exp(global_param(1))/(1+exp(global_param(1)));			// prob of meeting a husband if below 18
    omega2   = global_param(2);    //exp(global_param(1))/(1+exp(global_param(1)));			// prob of meeting a husband if above 18 but in school
    omega3   = global_param(3);    //exp(global_param(1))/(1+exp(global_param(1)));			// prob of meeting a husband if above 18 and not in school
    omega4_w = global_param(4);    // probability of meeting a  CG - CONSTANT
    omega5_w = global_param(5);    //probability of meeting a  CG if she SC
    omega6_w = global_param(6);    //probability of meeting a  CG if she HS
    omega7_w = global_param(7);    //probability of meeting a  SC - CONSTANT
    omega8_w = global_param(8);    //probability of meeting a  SC if she HS
    omega9_w = global_param(9);    //probability of meeting a  partner by AGE
    omega10_w = global_param(10);   //probability of meeting a  partner by AGE square
    omega4_h = global_param(13);    //probability of meeting a  CG - CONSTANT
    omega5_h = global_param(14);   //probability of meeting a  CG if he SC
    omega6_h = global_param(15);   //probability of meeting a  CG if he HS
    omega7_h = global_param(16);   //probability of meeting a  SC - CONSTANT
    omega8_h = global_param(17);   //probability of meeting a  SC if he HS
    omega9_h= global_param(18);     //probability of meeting a  partner by AGE
    omega10_h = global_param(19);   //probability of meeting a  partner by AGE square
    // taste for marriage parameters :Q = psai0 + psai1*((HS-WS)^2) + psai2*D + shock
    psai0 = global_param(22);    // constant
    psai2 = global_param(23);    //schooling gap - men more educated
    psai3 = global_param(24);    //schooling gap - women more educated
    psai4 = global_param(25);    //health gap
    // utility from pregnancy parameter - PREGNANCY = pai0 + pai1*W_AGE+pai2*W_AGE^2+pai3*N+epsilon_f(draw_f, t, 1);
    // We assume that pregnancy decisions are made jointly by the couple, and that each party gets the same utility from the decision
    pai1 = global_param(26);    //married
    pai2 = global_param(27);    //health
    pai3 = global_param(28);    //# of kids in household
    pai4 = global_param(29);    //pregnency in t-1
    // Wage parameters
    beta11_w = global_param(30);    //experience HSD
    beta12_w = global_param(31);    //experience HSG
    beta13_w = global_param(32);    //experience SC
    beta14_w = global_param(33);    //experience CG
    beta15_w = global_param(34);    //experience PC
    beta21_w = global_param(35);    //exp^2 HSD
    beta22_w = global_param(36);    //exp^2 HSG
    beta23_w = global_param(37);    //exp^2 SC
    beta24_w = global_param(38);    //exp^2 CG
    beta25_w = global_param(39);    //exp^2 PC
    beta31_w = global_param(40);    //education HSD
    beta32_w = global_param(41);    //education HSG
    beta33_w = global_param(42);    //education SC
    beta34_w = global_param(43);    //education CG
    beta35_w = global_param(44);    //education PC
    beta11_h = global_param(45);    //experience HSD
    beta12_h = global_param(46);    //experience HSG
    beta13_h = global_param(47);    //experience SC
    beta14_h = global_param(48);    //experience CG
    beta15_h = global_param(49);    //experience PC
    beta21_h = global_param(50);    //exp^2 HSD
    beta22_h = global_param(51);    //exp^2 HSG
    beta23_h = global_param(52);    //exp^2 SC
    beta24_h = global_param(53);    //exp^2 CG
    beta25_h = global_param(54);    //exp^2 PC
    beta31_h = global_param(55);    //HSD
    beta32_h = global_param(56);    //HSG
    beta33_h = global_param(57);    //SC
    beta34_h = global_param(58);    //CG
    beta35_h = global_param(59);    //PC
    //utility a couple receives from the quality and quality of children
    row0 = exp(global_param(60))/(1+exp(global_param(60))); 
    //CES function's parameter - 
    // if 1:linear or perfect substitutes; if approaches zero:Cobb–Douglas production function;if approaches negative infinity: perfect complements
    row1 = global_param(61);    //wife leisure
    row2 = global_param(62);    //husband leisure
    row3 = global_param(63);    //sping per child
    if (row1+row2+row3 >= 1)
    {
        assert(0);
    }
    // budget constraint
    unemp_h = global_param(64);    // unemployment benefit - husband   -    NOT TO BE ESTIMATED, EXOGENOUSLY GIVEN
    unemp_w = unemp_h;    //unemployment benefit - wife       -    NOT TO BE ESTIMATED, EXOGENOUSLY GIVEN
    // Utility parameters
    alpha0 = global_param(65);    //CRRA consumption parameter
    alpha11_w = global_param(66);    //leisure when pregnant
    alpha12_w = global_param(67);    //leisure by  education
    alpha13_w = global_param(68);    //leisure by health
    alpha12_h = global_param(69);    //leisure by  education
    alpha13_h = global_param(70);    //leisure by health
    alpha2 = global_param(71);    //utility from leisure CRRA parameter
    alpha3_m_w = global_param(72);    //utility from kids when married
    alpha3_s_w = global_param(73);    //utility from kids when single
    alpha3_m_h = global_param(74);    //utility from kids when married
    alpha3_s_h = global_param(75);    //utility from kids when single
    alpha41 = global_param(76);     // cost of divorce - constant wife
    alpha42 = global_param(77);     // cost of divorce - constant husband
    alpha43 = global_param(78);     // cost of divorce - per child wife
    alpha44 = global_param(79);     // cost of divorce - per child husband

    // home time equation - random walk
    float tau0_w = global_param(80);    //constant - alpha
    float tau1_w = global_param(81);    //AR coefficient
    float tau2_w = global_param(82);    //pregnancy in previous period
    float tau0_h = global_param(83);    //constant - alpha
    float tau1_h = global_param(84);    //AR coefficient
    float tau2_h = global_param(85);    //pregnancy in previous period
    // Job offer parameters  wife - full time (wasn't working at t-1)
    lambda0_fw = global_param(86);    //constant
    lambda1_fw = global_param(87);    //experience
    lambda2_fw = global_param(88);    //education
    lambda3_fw = global_param(89);    //health
    // Job offer parameters  husband - full time (wasn't working at t-1)
    lambda0_fh = global_param(90);    //constant
    lambda1_fh = global_param(91);    //experience
    lambda2_fh = global_param(92);    //education
    lambda3_fh = global_param(93);    //health
    // Job offer parameters  wife - part time (wasn't working at t-1)
    lambda0_pw = global_param(94);    //constant
    lambda1_pw = global_param(95);    //experience
    lambda2_pw = global_param(96);    //education
    lambda3_pw = global_param(97);    //health
    // Job offer parameters  husband - part time (wasn't working at t-1)
    lambda0_ph = global_param(98);    //constant
    lambda1_ph = global_param(99);    //experience
    lambda2_ph = global_param(100);    //education
    lambda3_ph = global_param(101);    //health
    // Job offer parameters  wife - laid off (working at t-1)
    lambda0_lw = global_param(102);    //constant
    lambda1_lw = global_param(103);    //experience
    lambda2_lw = global_param(104);    //education
    lambda3_lw = global_param(105);    //health
    // Job offer parameters  husband - laid off (working at t-1)
    lambda0_lh = global_param(106);    //constant
    lambda1_lh = global_param(107);    //experience
    lambda2_lh = global_param(108);    //education
    lambda3_lh = global_param(109);    //health
    // ability distribution
    //should be negative between 0-0.333: param=0.9-->prob decrease by 0.23, param=0.2-->prob decrease by 0.18
    decrease_low_ability = -(exp(global_param(110))/(1+exp(global_param(110))))/3;
    decrease_medium_ability = -(exp(global_param(111))/(1+exp(global_param(111))))/3;
    // random shocks variance-covariance matrix - correlations? identification?
    Matrix sigma = zeros(8,8);
    sigma(1,1) = exp(global_param(112));    //variance wife ability
    sigma(2,2) = exp(global_param(113));    //variance husband ability
    sigma(3,3) = exp(global_param(114));    //variance home time wife
    sigma(4,4) = exp(global_param(115));    //variance home time husband
    sigma(5,5) = exp(global_param(116));    //wife's wage error variance
    sigma(6,6) = exp(global_param(117));    //husband's wage error variance
    sigma(7,7) = exp(global_param(118));    //match quality variance
    sigma(8,8) = exp(global_param(119));    //pregnancy
    //uti11lity from schooling
    float s1_w = global_param(120);    //constant
    float s2_w = global_param(121);    //parents are CG
    float s3_w = global_param(122);    //return for ability
    float s4_w = global_param(123);    //post high school tuition
    float s1_h = global_param(124);    //constant
    float s2_h = global_param(125);    //parents are CG
    float s3_h = global_param(126);    //return for ability
    float s4_h = s4_w ;                   //post high school tuition
    // terminal value Parameters
    t1_w = global_param(127);    //ind. Education - HSG
    t2_w = global_param(128);    //ind. Education - SC
    t3_w = global_param(129);    //ind. Education - CG
    t4_w = global_param(130);    //ind. Education - PC
    t5_w = global_param(131);    //experience
    t6_w = global_param(132);    //partner education - HSD
    t7_w = global_param(133);    //partner education - HSG
    t8_w = global_param(134);    //partner education - SC
    t9_w = global_param(135);    //partner education - CG
    t10_w = global_param(136);    //partner education - PC
    t11_w = global_param(137);    //partner experience
    t12_w = global_param(138);    //marital status
    t13_w = global_param(139);    //# of kids
    t14_w = global_param(140);    //match quality
    t15_w = global_param(141);    //# of kids if married
    t16_w = global_param(142);    //previous work state
    // terminal value Parameters
    t1_h = global_param(143);    //ind. Education - HSG
    t2_h = global_param(144);    //ind. Education - SC
    t3_h = global_param(145);    //ind. Education - CG
    t4_h = global_param(146);    //ind. Education - PC
    t5_h = global_param(147);    //experience
    t6_h = global_param(148);    //partner education - HSD
    t7_h = global_param(149);    //partner education - HSG
    t8_h = global_param(150);    //partner education - SC
    t9_h = global_param(151);    //partner education - CG
    t10_h = global_param(152);    //partner education - PC
    t11_h = global_param(153);    //partner experience
    t12_h = global_param(154);    //marital status
    t13_h = global_param(155);    //# of kids
    t14_h = global_param(156);    //match quality
    t15_h = global_param(157);    //# of kids if married
    t16_h = global_param(158);    //previous work state
    // health parameters 1935
    float h1_35 = global_param(159);    //good health to good health
    float h2_35 = global_param(160);    //fair health to good health
    float h3_35 = global_param(161);    //poor health to good health
    float h4_35 = global_param(162);    //good health to poor health
    float h5_35 = global_param(163);    //fair health to poor health
    float h6_35 = global_param(164);    //poor health to poor health
    // health parameters 1945
    float h1_45 = global_param(165);    //good health to good health
    float h2_45 = global_param(166);    //fair health to good health
    float h3_45 = global_param(167);    //poor health to good health
    float h4_45 = global_param(168);    //good health to poor health
    float h5_45 = global_param(169);    //fair health to poor health
    float h6_45 = global_param(170);    //poor health to poor health
    // health parameters 1955
    float h1_55 = global_param(171);    //good health to good health
    float h2_55 = global_param(172);    //fair health to good health
    float h3_55 = global_param(173);    //poor health to good health
    float h4_55 = global_param(174);    //good health to poor health
    float h5_55 = global_param(175);    //fair health to poor health
    float h6_55 = global_param(176);    //poor health to poor health
    // health parameters 1965
    float h1_65 = global_param(177);    //good health to good health
    float h2_65 = global_param(178);    //fair health to good health
    float h3_65 = global_param(179);    //poor health to good health
    float h4_65 = global_param(180);    //good health to poor health
    float h5_65 = global_param(181);    //fair health to poor health
    float h6_65 = global_param(182);    //poor health to poor health
    // health parameters 1975
    float h1_75 = global_param(183);    //good health to good health
    float h2_75 = global_param(184);    //fair health to good health
    float h3_75 = global_param(185);    //poor health to good health
    float h4_75 = global_param(186);    //good health to poor health
    float h5_75 = global_param(187);    //fair health to poor health
    float h6_75 = global_param(188);    //poor health to poor health
    float HP_55 = 0;                    //time spent on home production by cohort, set to zero at 45-55-65 unified sample, later by cohort
    //HP_35 = (exp(global_param(102))/(1+exp(global_param(102))))/2; // make sure this parameter is less than 50// of time
    //HP_45 = (exp(global_param(102))/(1+exp(global_param(102))))/2;
    //HP_65 = (exp(global_param(102))/(1+exp(global_param(102))))/2;
    //HP_75 = (exp(global_param(102))/(1+exp(global_param(102))))/2;
    float HP = HP_55;                  //time spent on home production by cohort

    ////////////////////
    // CONSTANTS      //
    ////////////////////
    float m_education_35 = 0.06; // probability of collage educated mother - married women with CG+PC at age 45 (no earlier data), cohort 1915
    float m_education_45 = 0.06; // probability of collage educated mother - married women with CG+PC at age 40, cohort 1925
    float m_education_55 = 0.11; // probability of collage educated mother- married women with CG+PC at age 40, cohort 1935
    float m_education_65 = 0.20; // probability of collage educated mother- married women with CG+PC at age 40, cohort 1945
    float m_education_75 = 0.27; // probability of collage educated mother - married women with CG+PC at age 40, cohort 1955
    float eta1 = 0.194;                         //fraction from parents net income that one kid get
    float eta2 = 0.293;                         //fraction from parents net income that 2 kids get
    float eta3 = 0.367;                         //fraction from parents net income that 3 kids get
    float eta4 = 0.423;                         //fraction from parents net income that 4 kids get
    float scale = 0.707 ;                        //fraction of public consumption
    float beta = 0.983;                         // discount rate
    float BP = 0.5;                             // FIXED BARGENING POWER
    GRID = 3;
    AGE = 16;	                          // initial age
    TERMINAL = 60;                        // retirement
    GOOD = 1;	                          // health status
    FAIR = 2;
    POOR = 3;
    HK1 = 1;                              //0-2 years of experience
    HK2 = 4;	                          //3-5 years of experience
    HK3 = 8;	                          //6-10 years of experience
    HK4 = 12;	                          //11+ years of experience
    float cb_const_35 = 4317.681;    //child benefit for single mom+1 kid - annualy
    float cb_per_child_35 = 1517.235;
    float cb_const_45 = 4749.394;    //child benefit for single mom+1 kid - annualy
    float cb_per_child_45 = 1179.676;
    float cb_const_55 = 4530.784;    //child benefit for single mom+1 kid - annualy
    float cb_per_child_55 = 975.3533;
    float cb_const_65 = 3800.542;    //child benefit for single mom+1 kid - annualy
    float cb_per_child_65 = 861.9597;
    float cb_const_75 = 2710.976;    //child benefit for single mom+1 kid - annualy
    float cb_per_child_75 = 764.4601;
    unsigned num_cohort = 3;
    ////////////////////////
    // define moments arrays
    ////////////////////////
    Matrix3 emp_w = zeros(T_MAX, 3, num_cohort); //(periods, [unemployment, full, part] , cohorts)
    Matrix3 emp_h = zeros(T_MAX, 3+1, num_cohort); //(periods, [unemployment, full, part,employment] , cohorts)
    Matrix3 emp_m_w = zeros(T_MAX, 3, num_cohort); //(periods, [unemployment, full, part] , cohorts)
    Matrix3 emp_um_w = zeros(T_MAX, 3, num_cohort); //(periods, [unemployment, full, part] , cohorts)
    Matrix  emp_m_no_kids_w = zeros(T_MAX, num_cohort);
    Matrix  emp_m_with_kids_w = zeros(T_MAX, num_cohort);
    Matrix  emp_um_no_kids_w = zeros(T_MAX, num_cohort);
    Matrix  emp_um_kids_w = zeros(T_MAX, num_cohort);
    Matrix3 wages_w = zeros(DRAW_F, T_MAX, num_cohort);
    Matrix3 wages_m_h = zeros(DRAW_F, T_MAX, num_cohort);
    Matrix3 wages_m_w = zeros(DRAW_F, T_MAX, num_cohort);
    Matrix3 wages_um_w = zeros(DRAW_F, T_MAX, num_cohort);
    Matrix married = zeros(T_MAX, num_cohort);
    Matrix newborn = zeros(T_MAX, num_cohort);
    Matrix newborn_m = zeros(T_MAX, num_cohort);
    Matrix newborn_um = zeros(T_MAX, num_cohort);
    Matrix divorce_arr = zeros(T_MAX, num_cohort);
    Matrix kids  = zeros(T_MAX, num_cohort);
    Matrix kids_m = zeros(T_MAX, num_cohort);
    Matrix kids_um = zeros(T_MAX, num_cohort);
    Matrix count_emp_h = zeros(T_MAX, num_cohort);
    Matrix count_emp_m_no_kids_w = zeros(T_MAX, num_cohort);
    Matrix count_emp_m_with_kids_w = zeros(T_MAX, num_cohort);
    Matrix count_emp_um_no_kids_w = zeros(T_MAX, num_cohort);
    Matrix count_emp_um_kids_w = zeros(T_MAX, num_cohort);
    Matrix count_newborn_m = zeros(T_MAX, num_cohort);
    Matrix count_newborn_um = zeros(T_MAX, num_cohort);
    Matrix3 school_dist_h = zeros(T_MAX, 5, num_cohort);
    Matrix3 school_dist_w = zeros(T_MAX, 5, num_cohort);
    Matrix count_school_dist_h = zeros(T_MAX, num_cohort);
    Matrix3 assortative_mating = zeros(5,5,num_cohort);
    Matrix count_assortative_mating = zeros(5, num_cohort);
    Matrix3 emp_by_educ = zeros(T_MAX, 5, num_cohort);
    Matrix3 count_emp_by_educ = zeros(T_MAX, 5, num_cohort);
    Matrix3 wage_by_educ = zeros(T_MAX, 5, num_cohort);
    Matrix3 count_wage_by_educ = zeros(T_MAX, 5, num_cohort);
    Matrix3 health_dist_h = zeros(T_MAX, 3, num_cohort);
    Matrix3 health_dist_w = zeros(T_MAX, 3, num_cohort);
    Matrix count_health_dist_h = zeros(T_MAX, num_cohort);

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////// SOLVING FORWARD //////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (auto draw_f = 1U; draw_f <= DRAW_F*num_cohort; ++draw_f) //3 cohorts DRAW_F*num_cohort=3000
    {
        unsigned mother_educ_w;
        unsigned cohort;
        unsigned cb_const;
        unsigned cb_per_child;
        const unsigned CHOOSE_WIFE = 1;   //KEEP THIS FLAG=1 ALWAYS!!! SHOULD BE ZERO ONLY IN BACKWARD SOLVING FOR SINGLE MEN

        if (draw_f <= DRAW_F*m_education_45)
        {
            mother_educ_w = 1;
            cohort = 1;
            cb_const = cb_const_45;    //child benefit for single mom+1 kid - annualy
            cb_per_child = cb_per_child_45;
            h1 = h1_45;    //good health to good health
            h2 = h2_45;    //fair health to good health
            h3 = h3_45;    //poor health to good health
            h4 = h4_45;    //good health to poor health
            h5 = h5_45;    //fair health to poor health
            h6 = h6_45;
        }
        else if (draw_f > DRAW_F*m_education_45 && draw_f <= DRAW_F)
        {
            mother_educ_w = 0;
            cohort = 1;
            cb_const = cb_const_45;    //child benefit for single mom+1 kid - annualy
            cb_per_child = cb_per_child_45;
            h1 = h1_45;    //good health to good health
            h2 = h2_45;    //fair health to good health
            h3 = h3_45;    //poor health to good health
            h4 = h4_45;    //good health to poor health
            h5 = h5_45;    //fair health to poor health
            h6 = h6_45;
        }
        else if (draw_f > DRAW_F && draw_f <= DRAW_F+DRAW_F*m_education_55)
        {
            mother_educ_w = 1;
            cohort = 2;
            cb_const = cb_const_55;    //child benefit for single mom+1 kid - annualy
            cb_per_child = cb_per_child_55;
            h1 = h1_55;    //good health to good health
            h2 = h2_55;    //fair health to good health
            h3 = h3_55;    //poor health to good health
            h4 = h4_55;    //good health to poor health
            h5 = h5_55;    //fair health to poor health
            h6 = h6_55;
        }
        else if (draw_f > DRAW_F+DRAW_F*m_education_55 && draw_f <= 2*DRAW_F)
        {
            mother_educ_w = 0;
            cohort = 2;
            cb_const = cb_const_55;    //child benefit for single mom+1 kid - annualy
            cb_per_child = cb_per_child_55;
            h1 = h1_55;    //good health to good health
            h2 = h2_55;    //fair health to good health
            h3 = h3_55;    //poor health to good health
            h4 = h4_55;    //good health to poor health
            h5 = h5_55;    //fair health to poor health
            h6 = h6_55;
        }
        else if (draw_f > 2*DRAW_F && draw_f <= 2*DRAW_F+DRAW_F*m_education_65)
        {
            mother_educ_w = 1;
            cohort = 3;
            cb_const = cb_const_65;    //child benefit for single mom+1 kid - annualy
            cb_per_child = cb_per_child_65;
            h1 = h1_65;    //good health to good health
            h2 = h2_65;    //fair health to good health
            h3 = h3_65;    //poor health to good health
            h4 = h4_65;    //good health to poor health
            h5 = h5_65;    //fair health to poor health
            h6 = h6_65;
        }
        else if (draw_f > 2*DRAW_F+DRAW_F*m_education_65 && draw_f <= 3*DRAW_F)
        {
            mother_educ_w = 0;
            cohort = 3;
            cb_const = cb_const_65;    //child benefit for single mom+1 kid - annualy
            cb_per_child = cb_per_child_65;
            h1 = h1_65;    //good health to good health
            h2 = h2_65;    //fair health to good health
            h3 = h3_65;    //poor health to good health
            h4 = h4_65;    //good health to poor health
            h5 = h5_65;    //fair health to poor health
            h6 = h6_65;
        }
        else
        {
            assert(0);
        }

        // Initialize state
        AGE = 16;
        unsigned WS = 1, W_HSD = 1, W_HSG = 0, W_SC = 0, W_CG = 0, W_PC = 0, WK = 0, W_HEALTH = GOOD;
        unsigned HS = 1, H_HSD = 1, H_HSG = 0, H_SC = 0, H_CG = 0, H_PC = 0, HK = 0, H_HEALTH = GOOD, mother_educ_h = 0;
        unsigned year_of_school_w = 10;
        unsigned prev_state_h = 0, prev_state_w = 0, prev_capacity_w = 0, prev_capacity_h = 0;
        unsigned prev_state_T_minus_1 = 0;
        unsigned dur = 0, dur_minus_1 = 0, P_minus_1 = 0, P = 0;
        float home_time_h_m = exp(tau0_h/(1.0-tau1_h));
        float home_time_h_um = exp(tau0_h/(1.0-tau1_h));
        float home_time_w = exp(tau0_w/(1.0-tau1_w));
        float home_time_h_m_minus_1 = exp(tau0_h/(1.0-tau1_h));
        float home_time_h_um_minus_1 = exp(tau0_h/(1.0-tau1_h));
        float home_time_w_minus_1 = exp(tau0_w/(1.0-tau1_w));
        unsigned M = 0, M_minus_1 = 0, D = 0;
        unsigned W_N = 0;//wife kids as single
        unsigned H_N = 0;//husband kids as single
        unsigned C_N = 0;//common kids when married. if married, W_N and H_N are equal to zero
        unsigned Q = 0, Q_UTILITY = 0;
        unsigned capacity_h = 0, capacity_w = 0, wage_h = 0, wage_w = 0;
        unsigned in_school_at_t_minus_1_w = 1, in_school_at_t_minus_1_h = 1;
        // draw women permanent utility (function of mother education)

        float ability_w;
        if (w_draws_per(draw_f,1) < 0.333 + decrease_low_ability*mother_educ_w)//low ability
        {

            ability_w = normal_arr[1]*sigma(1,1);// w_draw_per: 1 - ability, 2- parents education
        }
        else if (w_draws_per(draw_f,1) > 0.333 + decrease_low_ability*mother_educ_w && 
                w_draws_per(draw_f,1) < 0.666 + decrease_medium_ability*mother_educ_w)//medium ability
        {
            ability_w = normal_arr[2]*sigma(1,1);// w_draw_per: 1 - ability, 2- parents education
        }
        else
        {
            ability_w = normal_arr[3]*sigma(1,1);// w_draw_per: 1 - ability, 2- parents education
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // Make choices for all periods - start period loop//
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        float ability_h = 0;
        unsigned ability_h_index = 0;
        unsigned t = 0;
        unsigned W_GOOD = 1, W_FAIR = 0, W_POOR = 0;
        W_HEALTH = GOOD;
        unsigned Q_UTILITY_PERMANENT = 0 ;  //this one is permanent over t so make sure to initialize only here and when get divorce
        for (auto age = AGE; age <= TERMINAL; ++age) //AGE = 16; TERMINAL = 60;
        {
            t = age - 15;
            // update T-1 variables
            dur_minus_1 = dur;
            P_minus_1 = P;
            M_minus_1 = M;
            home_time_h_m_minus_1 = home_time_h_m;
            home_time_h_um_minus_1 = home_time_h_um;
            home_time_w_minus_1 = home_time_w ;
            unsigned CHOOSE_HUSBAND = 0;
            capacity_h = 0;
            capacity_w = 0;
            D = 0;
            Q = 0;
            Q_UTILITY = 0;
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // if not married DRAW HUSBAND + HUSBAND CHARACTERISTICS
            // h_draws = rand(DRAW_F,T,5); 
            // 1 - MEET HUSBAND;
            // 2 - HUSBAND SCHOOLING+EXP; 
            // 3 - HUSBAND ABILITY; 
            // 4 - HUSBAND CHILDREN; 
            // 5 - HEALTH ; 
            // 6 - PARENTS EDUCATION; 
            // 7 - job offer;
            // 8 - part time/full time; 
            // 9 - prev state husband
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            draw_partner_result_t draw_partner_result;
            if (M == 0)
            {
                draw_partner_result = draw_partner(t, draw_f ,age, in_school_at_t_minus_1_w, WS, 1);
            }
            else
            { 
                // M = 1 - already have husband
                H_N = 0;
            }
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // DRAW AND CALCULATE WOMAN TRANSITORY CHARACTERISTCS  //
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // w_draws: 1 - health, 2 - leisure, 3 - job offer, 4 - part time/full time,
            // draw health status: according to previous status and age
            health_result_t health_results;
            if (age == 16)   //initial health state - uncorrelated with previous since first observation
            {
                if (w_draws(draw_f,t,1) < health_w(t,2))
                {
                    W_HEALTH = GOOD;
                    W_GOOD = 1;
                }
                else if (w_draws(draw_f,t,1) > health_w(t,2) && w_draws(draw_f,t,1) < health_w(t,3))
                {
                    W_HEALTH = FAIR;
                    W_FAIR = 1;
                }
                else if (w_draws(draw_f,t,1) > health_w(t,3) && w_draws(draw_f,t,1) < health_w(t,4))
                {
                    W_HEALTH = POOR;
                    W_POOR = 1;
                }
                else
                {
                    assert(0);
                }
            }
            else if (age > 16)
            {
                health_results = health(W_GOOD, W_FAIR, W_POOR, draw_f, t, 1);
            }  //age ==16 - initial health
            // calculate wage + job offer + capacity

            wage_calc_result_t wage_calc_result = wage_calc(WK, prev_state_w, prev_capacity_w, year_of_school_w, W_HEALTH, 
                    draw_f, t, W_HSD, W_HSG, W_SC, W_CG, W_PC, ability_w, 1);
            // calculate utility from schooling
            float WS_UTILITY;
            if (WS == 1)
            {
                WS_UTILITY = s1_w+s2_w*mother_educ_w+s3_w*ability_w;      // utility from high school
            }
            else if (WS > 1)
            {
                WS_UTILITY = s1_w+s2_w*mother_educ_w+s3_w*ability_w+s4_w;      // utility from post high school
            }
            // home time equation - random walk - tau0_w -pregnancy in previous period, tau1_w - drift term - should be negative
            //		ln_home_time_w =tau1_w*log(home_time_w_minus_1) + tau0_w + tau2_w*P_minus_1 + epsilon_f(draw_f, t, 3)*sigma(3,3);
            home_time_w = exp((tau1_w*log(home_time_w_minus_1))+tau0_w + tau2_w*P_minus_1 + epsilon_f(draw_f, t, 3)*sigma(3,3));

            // home_time_w=exp((home_time_w_minus_1.^tau1_w)*exp(tau0_w + tau2_w*P_minus_1 + epsilon_f(draw_f, t, 3)*sigma(3,3));
            ////////////////////////////////////////////////////////////////////////////////
            // DRAW AND CALCULATE HUSBAND OR POTENTIAL PARTNER TRANSITORY CHARACTERISTCS  //
            ////////////////////////////////////////////////////////////////////////////////
            health_result_t health_result;
            unsigned H_GOOD, H_FAIR, H_POOR;

            if (M == 1) //draw health for existing husband
            {
                health_result = health(H_GOOD, H_FAIR, H_POOR, draw_f, t, 0);
            }

            unsigned year_of_school_h;
            float wage_full_h;
            float wage_full_w;
            float wage_part_w;
            float wage_part_h;
            unsigned HS_UTILITY;
            unsigned CHOOSE_WORK_F_h;
            unsigned CHOOSE_WORK_P_h;
            unsigned CHOOSE_WORK_F_w;
            unsigned CHOOSE_WORK_P_w;
            if (M == 1 || CHOOSE_HUSBAND == 1)
            {
                // calculate wage + job offer + capacity
                wage_calc_result = wage_calc(HK, prev_state_h, prev_capacity_h, year_of_school_h, 
                        H_HEALTH, draw_f, t, H_HSD, H_HSG, H_SC, H_CG, H_PC, ability_h, 0);
                // calculate utility from schooling
                if (HS == 1)
                {
                    HS_UTILITY = s1_h+s2_h*mother_educ_h+s3_h*ability_h;      // utility from high school
                }
                else if (HS>1)
                {
                    HS_UTILITY = s1_h+s2_h*mother_educ_h+s3_h*ability_h+s4_h;      // utility from post high school
                }
                // home time equation - random walk - tau0_w -pregnancy in previous period, tau1_w - drift term - should be negative
                // if husband is not married his home time is not influence by a newborn, the wife is influenced of course, so home time for her is not function of M
                home_time_h_m=exp((tau1_h*log(home_time_h_m_minus_1))+tau0_h + tau2_h*P_minus_1 + epsilon_f(draw_f, t, 4)*sigma(4,4));
                home_time_h_um=exp((tau1_h*log(home_time_h_um_minus_1))+tau0_h +  epsilon_f(draw_f, t, 4)*sigma(4,4));

                //           home_time_h_m =(home_time_h_m_minus_1.^tau1_h )*exp(tau0_h+ tau2_h*P_minus_1 + epsilon_f(draw_f, t, 4)*sigma(4,4));
                //           home_time_h_um=(home_time_h_um_minus_1.^tau1_h)*exp(tau0_h+                    epsilon_f(draw_f, t, 4)*sigma(4,4));
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                // DRAW AND CALCULATE MARRIAGE AND PREGNENCY TRANSITORY UTILITY  //
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                if (HS == WS)
                {
                    Q_UTILITY = Q_UTILITY_PERMANENT + psai0 
                        + psai4*pow((W_HEALTH-H_HEALTH),2) + epsilon_f(draw_f, t, 5)*sigma(7,7);      // utility from marriage
                }
                else if (WS < HS)
                {
                    Q_UTILITY = Q_UTILITY_PERMANENT + psai0 + psai2 
                        + psai4*pow((W_HEALTH-H_HEALTH),2) + epsilon_f(draw_f, t, 5)*sigma(7,7);      // utility from marriage
                }
                else
                {
                    Q_UTILITY = Q_UTILITY_PERMANENT + psai0 + psai3 
                        + psai4*pow((W_HEALTH-H_HEALTH),2) + epsilon_f(draw_f, t, 5)*sigma(7,7);      // utility from marriage
                }
            }
            else
            {   // no husband or potential husband
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
            } // yes/ no husband or potential husband
            ///////////////////////////////////////
            // calculate utility                 //
            ///////////////////////////////////////
            calculate_utility_result_t calculate_utilirt_result = calculate_utility(cohort, cb_const, cb_per_child, 
                    W_N, H_N, C_N, wage_full_w, wage_part_w, wage_full_h, wage_part_h,
                    capacity_w, capacity_h, M_minus_1, W_HEALTH, H_HEALTH, P_minus_1, draw_f, t, 
                    Q_UTILITY ,HS_UTILITY, WS_UTILITY, home_time_h_m,
                    home_time_h_um, home_time_w, CHOOSE_WORK_F_h, CHOOSE_WORK_P_h, CHOOSE_WORK_F_w, CHOOSE_WORK_P_w, 
                    D, age, CHOOSE_HUSBAND, CHOOSE_WIFE, WS, HS, W_HSD, W_HSG, W_SC, W_CG, W_PC, WK, H_HSD, H_HSG, H_SC, H_CG, H_PC, HK, HP);
            ///////////////////////////////////////////////////////////////////////
            //   MAXIMIZATION - MARRIAGE + WORK  + PREGNANCY DESICIONS           //
            ///////////////////////////////////////////////////////////////////////
            optimization_decision_result_t optimization_decision_result = optimization_desicion(calculate_utilirt_result.U_W, 
                    calculate_utilirt_result.U_H);
            ////////////////////////////////////////////////////////
            //  UPDARE T+1 STATE VARIABLES ACCORDING TO THE DECISION
            ////////////////////////////////////////////////////////
            // UPDATE MARRIAGE STATUS - M, DIVORCE, DURATION, PREGNANCY STATUS, EXPERIENCE - K, PREVIOUS STATE - prev_state, NUMBER OF CHILDREN
            if (optimization_decision_result.optimization_desicion_h_i == 5) // man goes to school
            {
                year_of_school_h = year_of_school_h + 1;
                in_school_at_t_minus_1_h=1;
                if (year_of_school_h < 12)
                {
                    HS = 1;
                    H_HSD = 1;
                }
                else if (year_of_school_h == 12)
                {
                    HS = 2;
                    H_HSD = 0; H_HSG = 1;
                }
                else if (year_of_school_h > 12 &&  year_of_school_h < 16)
                {
                    HS = 3;
                    H_HSD = 0; H_HSG = 0; H_SC = 1;
                }
                else if (year_of_school_h > 14 &&  year_of_school_h < 18)
                {
                    HS = 4;
                    H_HSD = 0; H_HSG = 0; H_SC = 0; H_CG = 1;
                }
                else if (year_of_school_h > 17 )
                {
                    HS = 5;
                    H_HSD = 0; H_HSG = 0; H_SC = 0; H_CG = 0; H_PC = 1;
                }
                else
                {
                    in_school_at_t_minus_1_h = 0;
                }
            }
            if (optimization_decision_result.optimization_desicion_w_i == 5) // woman goes to school
            {
                year_of_school_w = year_of_school_w + 1;
                in_school_at_t_minus_1_w = 1;
                if (year_of_school_w < 12)
                {
                    WS = 1;
                    W_HSD = 1;
                }
                else if (year_of_school_w == 12)
                {
                    WS = 2;
                    W_HSD = 0; W_HSG = 1;
                }
                else if (year_of_school_w > 12 &&  year_of_school_w < 15)
                {
                    WS = 3;
                    W_HSD = 0; W_HSG = 0; W_SC = 1;
                }
                else if (year_of_school_w > 14 &&  year_of_school_w < 18)
                {
                    WS = 4;
                    W_HSD = 0; W_HSG = 0; W_SC = 0; W_CG = 1;
                }
                else if (year_of_school_w > 17 )
                {
                    WS = 5;
                    W_HSD = 0; W_HSG = 0; W_SC = 0; W_CG = 0; W_PC = 1;
                }
                else
                {
                    in_school_at_t_minus_1_w = 0;
                }
            }
            if (optimization_decision_result.optimization_desicion_h_i > 5)  //stay married or get married
            {
                unsigned in_school_at_t_minus_1 = 0;
                if (M == 0) //just got married, create common kids
                {
                    if (W_N + H_N > 4)
                    {
                        C_N = 4;
                    }
                    else
                    {
                        C_N = W_N + H_N;
                    }
                    W_N = 0;
                    H_N = 0;
                    // ASSORTATIVE MATING MOMENTS
                    assortative_mating(HS, WS, cohort) = assortative_mating(HS, WS, cohort)+1;
                    count_assortative_mating(WS, cohort) = count_assortative_mating(WS, cohort)+1;
                }
                dur = dur + 1;
                D = 0;
                M = 1;
            }
            else if ((M == 1) && optimization_decision_result.optimization_desicion_h_i < 6)  //get divorced
            {
                dur = 0;
                D = 1;
                M = 0;
                W_N = C_N;
                H_N = C_N;
                C_N = 0;
                Q_UTILITY_PERMANENT = 0;
            }
            else if ((M == 0) && optimization_decision_result.optimization_desicion_h_i < 6)  //stay single
            {
                dur = 0;
                //divorce = 0;   remove the comment and divorce will be only for 1 period and then she can go back to school
                M = 0;
            }
            else
            {
                assert(0);
            }

            if (optimization_decision_result.optimization_desicion_w_i == 2 || optimization_decision_result.optimization_desicion_w_i == 4 || 
                    optimization_decision_result.optimization_desicion_w_i == 7 || optimization_decision_result.optimization_desicion_w_i == 9 || 
                    optimization_decision_result.optimization_desicion_w_i == 11 || optimization_decision_result.optimization_desicion_w_i == 13)  //pregnancy
            {
                P = 1;
                if (M == 1 && C_N < 4)
                {
                    C_N = C_N + 1;
                }
                else if (M == 0 && W_N < 4)
                {
                    W_N = W_N + 1;
                }
            }
            else
            {
                P = 0;
            }

            if (optimization_decision_result.optimization_desicion_w_i == 3 || optimization_decision_result.optimization_desicion_w_i == 4 || 
                    optimization_decision_result.optimization_desicion_w_i == 8 || optimization_decision_result.optimization_desicion_w_i == 9 ||
                    optimization_decision_result.optimization_desicion_w_i == 12 || optimization_decision_result.optimization_desicion_w_i == 13) // women work
            {
                WK = WK + 1;
                prev_state_w = 1;
                prev_capacity_w = capacity_w;
            }
            else
            {
                prev_state_w = 0;
                prev_capacity_w = 0;
            }

            if (optimization_decision_result.optimization_desicion_h_i == 3 || optimization_decision_result.optimization_desicion_h_i == 6 || 
                    optimization_decision_result.optimization_desicion_h_i == 7 || optimization_decision_result.optimization_desicion_h_i == 8 ||
                    optimization_decision_result.optimization_desicion_h_i == 9) 									// man work
            {
                HK = HK + 1;
                prev_state_h = 1;
                prev_capacity_h = capacity_h;
            }
            else
            {
                prev_state_h = 0;
                prev_capacity_h = 0;
            }

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //   CREATE AND SAVE MOMENTS
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //individual moments:
            if (prev_state_w == 0)
            {
                emp_w(t,1, cohort) = emp_w(t,1, cohort)+1;         // unemployment total - prev_state is actually current state at this point
            }
            else if (prev_state_w == 1 && capacity_w == 1)
            {
                emp_w(t,2,cohort) = emp_w(t,2,cohort)+ 1;         // full time employment total - prev_state is actually current state at this point
            }
            else if (prev_state_w == 1 && capacity_w == 0.5)
            {
                emp_w(t,3, cohort) = emp_w(t,3, cohort)+1;         // part time employment total - prev_state is actually current state at this point
            }
            else
            {
                assert(0);
            }

            school_dist_w(t, WS,cohort) = school_dist_w(t, WS,cohort)+1;  //women schooling distribution
            emp_by_educ(t, WS,cohort) = emp_by_educ(t, WS,cohort)+prev_state_w; //women employment by education
            count_emp_by_educ(t, WS,cohort)=count_emp_by_educ(t, WS,cohort)+1;  //women wage by education
            health_dist_w(t, W_HEALTH,cohort) = health_dist_w(t, W_HEALTH,cohort) +1 ;
            if (CHOOSE_HUSBAND == 1 || M == 1)
            {
                if (prev_state_h == 0)
                {
                    emp_h(t,1,cohort) = emp_h(t,1,cohort)+1;         // employment total - prev_state is actually current state at this point
                }
                else if (prev_state_h == 1 && capacity_h == 1)
                {
                    emp_h(t,2,cohort) = emp_h(t,2,cohort)+1;         // employment total - prev_state is actually current state at this point
                    emp_h(t,4,cohort) = emp_h(t,4,cohort)+1;
                }
                else if (prev_state_h == 1 && capacity_h == 0.5)
                {
                    emp_h(t,3,cohort) = emp_h(t,3,cohort)+1;         // employment total - prev_state is actually current state at this point
                    emp_h(t,4,cohort) = emp_h(t,4,cohort)+1;
                }
                else
                {
                    assert(0);
                }
                count_emp_h(t,cohort)=count_emp_h(t,cohort)+1;
                school_dist_h(t, HS,cohort) = school_dist_h(t, HS,cohort)+1;
                count_school_dist_h(t,cohort) = count_school_dist_h(t,cohort)+1;
                health_dist_h(t, H_HEALTH,cohort) = health_dist_h(t, H_HEALTH,cohort)+1;
                count_health_dist_h(t,cohort) = count_health_dist_h(t,cohort) +1;
            }
            if (M == 0)	        // employment unmarried
            {
                ///////////////////////////////////////////////////////////////////////////////////////////////////
                //                   UNMARRIED WOMEN EMPLOYMENT BY KIDS INDIVIDUAL MOMENTS                       //
                ///////////////////////////////////////////////////////////////////////////////////////////////////
                if (prev_state_w==0)
                {
                    emp_um_w(t,1, cohort)= emp_um_w(t,1, cohort)+1;         // unemployment total - prev_state is actually current state at this point
                }
                else if (prev_state_w==1 && capacity_w==1)
                {
                    emp_um_w(t,2,cohort)= emp_um_w(t,2,cohort)+ 1;         // full time employment total - prev_state is actually current state at this point
                }
                else if (prev_state_w==1 && capacity_w==0.5)
                {
                    emp_um_w(t,3, cohort)= emp_um_w(t,3, cohort)+1;         // part time employment total - prev_state is actually current state at this point
                }
                else
                {
                    assert(0);
                }

                if (W_N == 0)
                {
                    emp_um_no_kids_w(t,cohort) = emp_um_no_kids_w(t,cohort) + prev_state_w;     // employment unmarried and no children
                    count_emp_um_no_kids_w(t,cohort) = count_emp_um_no_kids_w(t,cohort) + 1;
                }
                else
                {
                    emp_um_kids_w(t,cohort) = emp_um_kids_w(t,cohort) + prev_state_w;            // employment unmarried and children
                    count_emp_um_kids_w(t,cohort) = count_emp_um_kids_w(t,cohort) + 1;
                }
            }
            else if (M == 1)    // employment unmarried
            {
                ///////////////////////////////////////////////////////////////////////////////////////
                //                   MARRIED WOMEN EMPLOYMENT BY KIDS INDIVIDUAL MOMENTS
                ///////////////////////////////////////////////////////////////////////////////////////
                if (prev_state_w==0)
                {
                    emp_m_w(t,1, cohort)= emp_m_w(t,1, cohort)+1;         // unemployment total - prev_state is actually current state at this point
                }
                else if (prev_state_w==1 && capacity_w==1)
                {
                    emp_m_w(t,2,cohort)= emp_m_w(t,2,cohort)+ 1;         // full time employment total - prev_state is actually current state at this point
                }
                else if (prev_state_w==1 && capacity_w==0.5)
                {
                    emp_m_w(t,3, cohort)= emp_m_w(t,3, cohort)+1;         // part time employment total - prev_state is actually current state at this point
                }
                else
                {
                    assert(0);
                }

                if (C_N == 0)
                {
                    emp_m_no_kids_w(t,cohort) = emp_m_no_kids_w(t,cohort) + prev_state_w;         // employment married no kids
                    count_emp_m_no_kids_w(t,cohort) = count_emp_m_no_kids_w(t,cohort)+1;
                }
                else if (C_N > 0)
                {
                    emp_m_with_kids_w(t,cohort) = emp_m_with_kids_w(t,cohort)+ prev_state_w;          // employment married 1 kid
                    count_emp_m_with_kids_w(t,cohort) = count_emp_m_with_kids_w(t,cohort)+1;
                }
            }
            else
            {
                assert(0);
            }

            ///////////////////////////////////////////////////////////////
            //                    WAGES MOMENTS
            ///////////////////////////////////////////////////////////////
            if (prev_state_w == 1 && capacity_w == 1 && wage_w > 0)
            {
                wages_w(draw_f, t,cohort) = wage_w;        // women wages if employed by experience
                wage_by_educ(t, WS,cohort) = wage_by_educ(t, WS,cohort)+wage_w;
                count_wage_by_educ(t, WS,cohort) = count_wage_by_educ(t, WS,cohort)+1;
            }

            if (M == 1 && prev_state_h == 1 && capacity_h==1 && wage_h>0 )
            {
                wages_m_h(draw_f, t,cohort)=wage_h;         // married men wages
            }

            if (M == 1 && prev_state_w == 1 && capacity_w==1 && wage_w>0 )            //prev_state is actually current state at this point
            {
                wages_m_w(draw_f, t,cohort)=wage_w;          // married women wages if employed
            }
            else if (M == 0 && prev_state_w == 1 && capacity_w==1 && wage_w>0)
            {
                wages_um_w(draw_f, t,cohort)=wage_w;         // unmarried women wages if employed
            }

            ///////////////////////////////////////////////////////////
            //           FERTILITY AND MARRIED RATE MOMENTS
            ///////////////////////////////////////////////////////////
            married(t,cohort) = married(t,cohort) + M  ;             // married yes/no
            newborn(t,cohort) = newborn(t,cohort) + P;               // new born in period t - for probability and distribution
            divorce_arr(t,cohort)= divorce_arr(t,cohort) + D;
            if (M == 1)
            {
                newborn_m(t,cohort)= newborn_m(t,cohort) + P;           // new born in period t - for probability and distribution
                count_newborn_m(t,cohort) = count_newborn_m(t,cohort)+1;
            }
            else
            {
                newborn_um(t,cohort)= newborn_um(t,cohort)+ P;          // new born in period t - for probability and distribution
                count_newborn_um(t,cohort) = count_newborn_um(t,cohort)+1;
            }
            //duration_of_first_marriage(draw_f, school_group) = D_T_minus_1 ;
            if (M==1)
            {
                kids(t,cohort) = kids(t,cohort) + C_N ;          // # of children by age
                kids_m(t,cohort) = kids_m(t,cohort) + C_N;			// # of children for married women
            }
            else
            {
                kids(t,cohort) = kids(t,cohort) +	W_N ;          // # of children by school group
                kids_um(t,cohort) = kids_um(t,cohort) + W_N;
            }

            /////////////////////////////////////////////////////////////////////////////////////////////
            //           END MOMENTS
            /////////////////////////////////////////////////////////////////////////////////////////////
        } // close the time loop
    } // close the draw_f loop
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //            CLOSE SOLVING FORWARD           //////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    return 0.0;
}

