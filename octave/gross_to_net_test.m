tax_brackets = load('tax_brackets.out');  % matrix with tax brackets 1962-2012
deductions_exemptions = load('deductions_exemptions.out'); % matrix with deductions, exemptions and EICT

% test 1
% initialize test values
W_N = 0; %single wife # of children
H_N = 0; %single husband # of children
C_N = 1; %married household # of children
wage_w = 3000; %wife's wage
wage_h = 2000;  %husband's wage
M = 1;  % marital status, 1==married
year = 2010;

net = gross_to_net(W_N, H_N, C_N, wage_w, wage_h, M, year, tax_brackets, deductions_exemptions)

% validate return value

