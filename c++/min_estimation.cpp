#include <iostream>
#include "estimation_f.h"
#include "estimation_init.h"

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        std::cerr << "usage: " << argv[0] << " <cohort>" << std::endl;
        return 1;
    }

    init_result_t data = estimation_init(argv[1]);

    double objective = estimation_f(
            data.husband_prev_kids,
            data.husband_prev_emp,
            data.wife_prev_kids,
            data.wife_prev_emp,
            data.emp_mrate_child_wage, 
            data.emp_mrate_child_wage_m,
            data.emp_mrate_child_wage_um,
            data.emp_m_with,
            data.emp_m_without,
            data.emp_um_with,
            data.emp_um_without, 
            data.emp_wage_by_educ,
            data.emp_wage_by_educ_m,
            data.emp_wage_by_educ_um,
            data.educ_comp,
            data.educ_comp_m, 
            data.assortative,
            data.nlsy_trans);

    std::cout << "objective = " << objective << std::endl;

    return 0;
}

