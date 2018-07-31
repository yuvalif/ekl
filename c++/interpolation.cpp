// interpolation function - input: experience  output: 2 weights, two indexes
// since the grid of actual experience has only 5 levels:
//exp	0		1.5		3.5		7.5	15
//0		1.00	0		0		0		0
//0.5	0.67	0.33333	0		0		0
//1		0.3333	0.66666	0		0		0
//1.5	0		1		0		0		0
//2		0		0.75	0.25	0		0
//2.5	0		0.5		0.5		0		0
//3		0		0.25	0.75	0		0
//3.5	0		0		1		0		0
//4		0		0		0.875	0.125	0
//4.5	0		0		0.75	0.25	0
//5		0		0		0.625	0.375	0
//5.5	0		0		0.5		0.5		0
//6		0		0		0.375	0.625	0
//6.5	0		0		0.25	0.75	0
//7		0		0		0.125	0.875	0
//7.5	0		0		0		1		0
//8		0		0		0		0.9335	0.0665
//8.5	0		0		0		0.8665	0.1335
//9		0		0		0		0.8		0.2
//9.5	0		0		0		0.7335	0.2665
//10		0		0		0		0.6665	0.3335
//10.5	0		0		0		0.6		0.4
//11		0		0		0		0.5335	0.4665
//11.5	0		0		0   	0.4665	0.5335
//12		0		0		0		0.4		0.6
//12.5	0		0		0		0.333	0.667
//13		0		0		0		0.2665	0.7335
//13.5	0		0		0  		0.2		0.8
//14		0		0		0		0.1335	0.8665
//14.5	0		0		0		0.0665	0.9335
//15		0		0		0		0		1

#include <assert.h>
#include "interpolation.h"

interpolation_result_t interpolation(float K)
{
    unsigned ind1;
    unsigned ind2;
    float weight1;
    float weight2;

    if (K == 0)
    {
        ind1 = 1; ind2 = 2; weight1 = 1; weight2 = 0;
    }
    else if (K == 0.5 )
    {
        ind1 = 1; ind2 = 2; weight1 = 0.6666; weight2 = 0.3333;
    }
    else if (K == 1 )
    {
        ind1 = 1; ind2 = 2; weight1 = 0.33333; weight2 = 0.66666;
    }
    else if (K == 1.5 )
    {
        ind1 = 1; ind2 = 2; weight1 = 0.0; weight2 = 1.0;
    }
    else if (K == 2 )
    {
        ind1 = 2; ind2 = 3; weight1 = 0.75; weight2 = 0.25;
    }
    else if (K == 2.5 )
    {
        ind1 = 2; ind2 = 3; weight1 = 0.5; weight2 = 0.5;
    }
    else if (K == 3 )
    {
        ind1 = 2; ind2 = 3; weight1 = 0.25; weight2 = 0.75;
    }
    else if (K == 3.5 )
    {
        ind1 = 2; ind2 = 3; weight1 = 0.0; weight2 = 1.0;
    }
    else if (K == 4 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.875; weight2 = 0.125;
    }
    else if (K == 4.5 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.75; weight2 = 0.25;
    }
    else if (K == 5 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.625; weight2 = 0.375;
    }
    else if (K == 5.5 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.5; weight2 = 0.5;
    }
    else if (K == 6 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.375; weight2 = 0.625;
    }
    else if (K == 6.5 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.25; weight2 = 0.75;
    }
    else if (K == 7 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.125; weight2 = 0.875;
    }
    else if (K == 7.5 )
    {
        ind1 = 3; ind2 = 4; weight1 = 0.0; weight2 = 1.0;
    }
    else if (K == 8 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.9345; weight2 = 0.0655;
    }
    else if (K == 8.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.8665; weight2 = 0.1335;
    }
    else if (K == 9 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.8; weight2 = 0.2;
    }
    else if (K == 9.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.7335; weight2 = 0.2665;
    }
    else if (K == 10 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.665; weight2 = 0.335;
    }
    else if (K == 10.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.6; weight2 = 0.4;
    }
    else if (K == 11 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.5345; weight2 = 0.4655;
    }
    else if (K == 11.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.4665; weight2 = 0.5335;
    }
    else if (K == 12 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.4 ; weight2 = 0.6;
    }
    else if (K == 12.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.3333 ; weight2 = 0.6666;
    }
    else if (K == 13 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.2655; weight2 = 0.7345;
    }
    else if (K == 13.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.2; weight2 = 0.8;
    }
    else if (K == 14 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.1345; weight2 = 0.8655;
    }
    else if (K == 14.5 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0.0665; weight2 = 0.9335;
    }
    else if (K == 15 )
    {
        ind1 = 4; ind2 = 5; weight1 = 0 ; weight2 = 1;
    }
    else
    {
        assert(0);
    }

    interpolation_result_t result;
    result.ind1 = ind1;
    result.ind2 = ind2;
    result.weight1 = weight1;
    result.weight2 = weight2;

    return result;
}
