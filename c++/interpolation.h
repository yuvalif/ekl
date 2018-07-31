#pragma once

struct interpolation_result_t
{
    int ind1;
    int ind2;
    float weight1;
    float weight2;
};

interpolation_result_t interpolation(float K);

