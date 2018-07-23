% check that wage=0 if non married
% check that C_N=0 if W_N and/or H_N>0

function [net ]= gross_to_net(W_N,H_N,C_N, wage_w, wage_h, M,year, tax_brackets, deductions_exemptions)
% the tax brackets and the deductions and exemptions starts at 1950 and
% ends at 2035. the 1933 cohort needs data from age 17 and 1975 cohort needs data until
% age 60
row_number=year-1949; %row number on matrix 1950-2035. 
tot_child = W_N+H_N+C_N; % total number of children per household
max_child = tot_child;
if max_child > 3
    max_child = 3;  % 0 or 1 or 2 or 3 
end 
%%%%%%%%  data validation tests %%%%%%%%%%%%%%%%%%%%
if (M == 0 && wage_w ~= 0 && wage_h ~= 0)
    error("not married but wage for both");
end
if (M == 0 && C_N ~= 0 )
    error("not married but C_N not zero");
end
if (M == 1 && (H_N ~= 0 || W_N ~=0))
    error("married but H_N or W_N not zero");
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shift = 0;
deductions = 0;
exemptions = 0;
if (M == 1)%married
    shift = 21; % single 2-22, married 23-42
    deductions = deductions_exemptions(row_number,2);
    exemptions = deductions_exemptions(row_number,4)+deductions_exemptions(row_number,6)*tot_child;
else
    shift = 0; % single 2-22, married 23-42
    deductions= deductions_exemptions(row_number,3); 
    exemptions = deductions_exemptions(row_number,5)+deductions_exemptions(row_number,6)*tot_child;
end    
tot_inc=wage_w+wage_h; % if married - sum of income, if single its a sum of individual plus zero
reduced_inc=wage_w+wage_h-deductions-exemptions; % if married - sum of income, if single its a sum of individual plus zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CALCULATE INCOME TAX           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tax = 0;
if reduced_inc > 0
    for i=2:10
        if (reduced_inc < tax_brackets(row_number,i+shift))
            tax = tax + (reduced_inc-tax_brackets(row_number,(i-1)+shift))*tax_brackets(row_number,11+(i-1)+shift);
        break
        end
        tax = tax + (tax_brackets(row_number,i+shift) - tax_brackets(row_number,(i-1)+shift)) ...
               * tax_brackets(row_number,11+(i-1)+shift);
    end
end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CALCULATE EICT                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EICT = 0;
if (tot_inc < deductions_exemptions(row_number,8+6*max_child))    %first interval  credit rate
    EICT = tot_inc*deductions_exemptions(row_number,7+6*max_child);
    tax = 0;
elseif  ((tot_inc > deductions_exemptions(row_number,8+6*max_child))...      %  second (flat) interval - max EICT 
        && (tot_inc < deductions_exemptions(row_number,11+6*max_child)))
    EICT = deductions_exemptions(row_number,9+6*max_child);
    tax = 0;
elseif  ((tot_inc > deductions_exemptions(row_number,11+6*max_child))...    % third interval - phaseout rate
        && (tot_inc < deductions_exemptions(row_number,12+6*max_child)))
    EICT = tot_inc*deductions_exemptions(row_number,10+6*max_child);
    tax = 0;
else
    EICT = 0;                                                               % income too high for EICT
end    
 
net =  tot_inc - tax + EICT;  
end
    
