#include "tax_data.h"
#include "gross_to_net.h"
#include <iostream>

int main()
{
    if (!load_tax_data())
    {
        std::cout << "FAIL: failed to load tax data" << std::endl;
        return 0;
    }

    //initialize test values
    int W_N = 0; //single wife # of children
    int H_N = 0; //single husband # of children
    int C_N = 1; //married household # of children
    float wage_w = 3000; //wife's wage
    float wage_h = 2000;  //husband's wage
    int M = 1;  // marital status, 1==married
    int year = 2010;

    float expected_net = 12345;
    float net = gross_to_net(W_N, H_N, C_N, wage_w, wage_h, M, year);

    if (abs(net - expected_net) > 1)
    {
        std::cout << "FAIL: expected " << expected_net << " but recevied " << net << std::endl;
    }


    std::cout << "SUCCESS" << std::endl;
    return 0;
}

