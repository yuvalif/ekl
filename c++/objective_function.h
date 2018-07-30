#pragma once

namespace octave_utils
{
    class Matrix;
    class Matrix3;
}


using namespace octave_utils;

// this is the objective functiuon, calculating value based on the estimated moments
double objective_function(
            const Matrix3& emp_w,
            const Matrix3& emp_h, 
            const Matrix3& emp_m_w, 
            const Matrix3& emp_um_w, 
            const Matrix& emp_m_no_kids_w,
            const Matrix& emp_m_with_kids_w,
            const Matrix& emp_um_no_kids_w,
            const Matrix& emp_um_kids_w,
            const Matrix3& wages_w,
            const Matrix3& wages_m_h,
            const Matrix3& wages_m_w,
            const Matrix3& wages_um_w,
            const Matrix& married,
            const Matrix& newborn,
            const Matrix& newborn_m,
            const Matrix& newborn_um,
            const Matrix& divorce_arr,
            const Matrix& kids,
            const Matrix& kids_m,
            const Matrix& kids_um,
            const Matrix& count_emp_h,
            const Matrix& count_emp_m_no_kids_w,
            const Matrix& count_emp_m_with_kids_w,
            const Matrix& count_emp_um_no_kids_w,
            const Matrix& count_emp_um_kids_w,
            const Matrix& count_newborn_m,
            const Matrix& count_newborn_um,
            const Matrix3& school_dist_h,
            const Matrix3& school_dist_w,
            const Matrix& count_school_dist_h,
            const Matrix3& assortative_mating,
            const Matrix& count_assortative_mating,
            const Matrix3& emp_by_educ,
            const Matrix3& count_emp_by_educ,
            const Matrix3& wage_by_educ,
            const Matrix3& count_wage_by_educ,
            const Matrix3& health_dist_h,
            const Matrix3& health_dist_w,
            const Matrix& count_health_dist_h);

