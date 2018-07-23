% script for finding the minimum of "estimation_xxx" functions

%clear all;
close all;
format long;
% general parameters
T_MAX = 50;	% periods
DRAW_B = 30;	% draws for monte carlo integration in backward solutionq
DRAW_F = 1000;	% number of observation per cohort

% choose runing mode - "test" - one iteration, good for calibration. "simplex", "ga" - search methods for optimization. "std" - calculates numeric standart errors
run_mode = 'test'; 
% "test" - run one iteration with internal prints
% "simplex" - minimize via simplex, no internal prints
% "ga" - minimize via genetic algorithm, , no internal prints
% "std" - calculate standard error of the parameters
% CHOOSE WHICH PARAMETERS TO RUN ON - FOR PARTIAL OPTIMIZATION
%run_list = {'utility'};
%run_list = {'wage'};
%run_list = {'child', 'utility'};
run_list = {'all'};

run_list_len = length(run_list);
run_list = char(run_list);

global fitted_moments_out
global actual_moments_out
fitted_moments_out =  zeros(T_MAX,14); %TODO: change to multiple matrix
actual_moments_out = zeros(T_MAX,14);

disp('loading file: init_parameters.txt');
%simulation mode;
%char_vec = load('init_parameters_simul.txt');
% original mode:
char_vec = load('init_parameters.txt')
size(char_vec)
%override_global_params
[husband_prev_kids, husband_prev_emp,wife_prev_kids, wife_prev_emp, health_w, health_h, ...
emp_mrate_child_wage, emp_mrate_child_wage_m, emp_mrate_child_wage_um, ... 
emp_m_with, emp_m_without, emp_um_with, emp_um_without, emp_wage_by_educ,emp_wage_by_educ_m, emp_wage_by_educ_um,...
educ_comp, educ_comp_m,assortative, epsilon_b, epsilon_f, w_draws, h_draws, w_draws_per, tax_brackets, deductions_exemptions, nlsy_trans] = estimation_init(T_MAX, DRAW_B, DRAW_F);
if strcmp(run_mode,'test')
   	min_x = minestimation_test(@estimation_f, global_params, T_MAX, DRAW_B, DRAW_F, husband_prev_kids, husband_prev_emp,wife_prev_kids, wife_prev_emp, health_w, health_h,...
    emp_mrate_child_wage, emp_mrate_child_wage_m, emp_mrate_child_wage_um, ... 
    emp_m_with, emp_m_without, emp_um_with, emp_um_without, emp_wage_by_educ,emp_wage_by_educ_m, emp_wage_by_educ_um,...
    educ_comp, educ_comp_m,assortative, epsilon_b, epsilon_f, w_draws, h_draws, w_draws_per, tax_brackets, deductions_exemptions, nlsy_trans)
elseif strcmp(run_mode,'std')
   	minestimation_std(@estimation_f, global_params, T_MAX, DRAW_B, DRAW_F, husband_prev_kids, husband_prev_emp,wife_prev_kids, wife_prev_emp, health_w, health_h,...
    emp_mrate_child_wage, emp_mrate_child_wage_m, emp_mrate_child_wage_um, ... 
    emp_m_with, emp_m_without, emp_um_with, emp_um_without, emp_wage_by_educ,emp_wage_by_educ_m, emp_wage_by_educ_um,...
    educ_comp, educ_comp_m,assortative, epsilon_b, epsilon_f,w_draws, h_draws, w_draws_per, tax_brackets, deductions_exemptions, nlsy_trans);
else
	for run_idx = 1:run_list_len
		run_param = strtrim(run_list(run_idx,:));
		if strcmp(run_mode,'simplex')
%			[min_x global_param] = minestimation_simplex(@estimation_f, run_param, global_params, T_MAX, DRAW_B, DRAW_F, SCHOOL_GROUPS, husbands_HSG, husbands_SC, husbands_CG, husbands_PC, wage_moments, marr_fer_moments, emp_moments, general_moments, epsilon_b, epsilon_f,w_ability_draw, h_draws, w_draws);
		elseif strcmp(run_mode,'ga')	
%			[min_x global_param] = minestimation_ga(@estimation_f, run_param, global_params, T_MAX, DRAW_B, DRAW_F, SCHOOL_GROUPS, husbands_HSG, husbands_SC, husbands_CG, husbands_PC, wage_moments, marr_fer_moments, emp_moments, general_moments, epsilon_b, epsilon_f, w_ability_draw, h_draws, w_draws);
		else
			error(sprintf('unsupported mode %s', mode));
		end
	end%for run_idx
end%if

if strcmp(run_mode,'test') == 0
	for i = 1:length(global_param)
		char_matrix(i,wage_idx) = global_param(i);
		disp(sprintf('global_param(%d) = %f;', i, global_param(i)));
	end
end

format short G

if strcmp(run_mode,'test')
	for i = 1:14
%		disp(sprintf('fitted moment %d for all periods and wage indeces', i));
%		squeeze(fitted_moments_out(:,:,i))'
%		disp(sprintf('actual moment %d for all periods and wage indeces', i));
%		squeeze(actual_moments_out(:,:,i))'
	end%for i
else
	save char_matrix.mat char_matrix
end
