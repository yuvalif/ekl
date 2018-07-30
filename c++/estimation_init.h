#pragma once

struct init_result_t
{
    int husband_prev_kids;
    int husband_prev_emp;
    int wife_prev_kids;
    int wife_prev_emp;
    float emp_mrate_child_wage;
    float emp_mrate_child_wage_m;
    float emp_mrate_child_wage_um;
    float emp_m_with;
    float emp_m_without;
    float emp_um_with;
    float emp_um_without;
    float emp_wage_by_educ;
    float emp_wage_by_educ_m;
    float emp_wage_by_educ_um;
    float educ_comp;
    float educ_comp_m;
    float assortative;
    float nlsy_trans;
};


init_result_t estimation_init(const char* cohort);

