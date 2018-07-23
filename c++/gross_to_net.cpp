#include <assert.h>
#include "tax_data.h"

// check that wage=0 if non married
// check that C_N=0 if W_N and/or H_N>0

float gross_to_net(int W_N, int H_N, int C_N, float wage_w, float wage_h, int M, int year)
{
    // the tax brackets and the deductions and exemptions starts at 1950 and
    // ends at 2035. the 1933 cohort needs data from age 17 and 1975 cohort needs data until age 60
    int row_number = year-1949; //row number on matrix 1950-2035.
    int tot_child = W_N+H_N+C_N; // total number of children per household
    int max_child = tot_child;
    if (max_child > 3)
    {
        max_child = 3;  // 0 or 1 or 2 or 3
    }
    ////////////////  data validation tests ////////////////////////////////////////
    if (M == 0 && wage_w != 0 && wage_h != 0)
    {
        assert(0);
    }
    if (M == 0 && C_N != 0)
    {
        assert(0);
    }
    if (M == 1 && (H_N != 0 || W_N != 0))
    {
        assert(0);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    int shift = 0;
    float deductions = 0;
    float exemptions = 0;
    if (M == 1)//married
    {
        shift = 21; // single 2-22, married 23-42
        deductions = deductions_exemptions(row_number,2);
        exemptions = deductions_exemptions(row_number,4)+deductions_exemptions(row_number,6)*tot_child;
    }
    else
    {
        shift = 0; // single 2-22, married 23-42
        deductions= deductions_exemptions(row_number,3);
        exemptions = deductions_exemptions(row_number,5)+deductions_exemptions(row_number,6)*tot_child;
    }
    float tot_inc = wage_w+wage_h; // if married - sum of income, if single its a sum of individual plus zero
    float reduced_inc = wage_w + wage_h - deductions - exemptions; // if married - sum of income, if single its a sum of individual plus zero
    //////////////////////////////////////////////////////////////////////
    //  CALCULATE INCOME TAX           //
    //////////////////////////////////////////////////////////////////////
    float tax = 0;
    if (reduced_inc > 0)
    {
        for (auto i=2; i <= 10; ++i)
        {
            if (reduced_inc < tax_brackets(row_number,i+shift))
            {
                tax = tax + (reduced_inc-tax_brackets(row_number,(i-1)+shift))*tax_brackets(row_number,11+(i-1)+shift);
                break;
            }
            tax = tax + (tax_brackets(row_number,i+shift) - tax_brackets(row_number,(i-1)+shift))
                * tax_brackets(row_number,11+(i-1)+shift);
        }
    }
    //////////////////////////////////////////////////////////////////////
    //  CALCULATE EICT                 //
    //////////////////////////////////////////////////////////////////////
    float EICT = 0;
    if (tot_inc < deductions_exemptions(row_number,8+6*max_child))    //first interval  credit rate
    {
        EICT = tot_inc*deductions_exemptions(row_number,7+6*max_child);
        tax = 0;
    }
    else if ((tot_inc > deductions_exemptions(row_number,8+6*max_child))      //  second (flat) interval - max EICT
            && (tot_inc < deductions_exemptions(row_number,11+6*max_child)))
    {
        EICT = deductions_exemptions(row_number,9+6*max_child);
        tax = 0;
    }
    else if  ((tot_inc > deductions_exemptions(row_number,11+6*max_child))    // third interval - phaseout rate
            && (tot_inc < deductions_exemptions(row_number,12+6*max_child)))
    {
        EICT = tot_inc*deductions_exemptions(row_number,10+6*max_child);
        tax = 0;
    }
    else
    {
        EICT = 0;                                                               // income too high for EICT
    }

    return tot_inc - tax + EICT;
}

