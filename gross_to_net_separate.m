
function [net separate_net]= gross_to_net_separate(W_N, H_N, C_N, wage_w, wage_h, M, year, tax_brackets, deductions_exemptions)

net = gross_to_net(W_N, H_N, C_N, wage_w, wage_h, M, year, tax_brackets, deductions_exemptions);

if (M == 1)
    separate_net_h = gross_to_net(0,   0, 0, 0,      wage_h, 0, year, tax_brackets, deductions_exemptions);
    separate_net_w = gross_to_net(C_N, 0, 0, wage_w, 0,      0, year, tax_brackets, deductions_exemptions);
    separate_net = separate_net_h + separate_net_w;
else
    separate_net = net;
end
