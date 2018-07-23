function [husband_prev_kids, husband_prev_emp,wife_prev_kids, wife_prev_emp, health_w, health_h, ...
emp_mrate_child_wage, emp_mrate_child_wage_m, emp_mrate_child_wage_um, ... 
emp_m_with, emp_m_without, emp_um_with, emp_um_without, emp_wage_by_educ,emp_wage_by_educ_m, emp_wage_by_educ_um,...
educ_comp, educ_comp_m,assortative, epsilon_b, epsilon_f, w_draws, h_draws, w_draws_per, tax_brackets, deductions_exemptions, nlsy_trans ] = estimation_init(T_MAX, DRAW_B, DRAW_F)


disp('loading files: health matrix ');
health_data = load('init_health.txt');% men1945:17-61, men1955:17-61,men1965:17-51,women1945:17-61, women1955:17-61,women1965:17-51,
health_h = health_data(1:125,3:6);
health_w = health_data(126:205,3:6);
disp('loading moments files');
emp_mrate_child_wage= load('emp_mrate_child_wage.out');
emp_mrate_child_wage_m= load('emp_mrate_child_wage_m.out');
emp_mrate_child_wage_um= load('emp_mrate_child_wage_um.out');

emp_m_with = load('emp_m_with.out');
emp_m_without = load('emp_m_without.out');
emp_um_with = load('emp_um_with.out');
emp_um_without = load('emp_um_without.out');

emp_wage_by_educ = load('emp_wage_by_educ.out');
emp_wage_by_educ_m = load('emp_wage_by_educ_m.out');
emp_wage_by_educ_um = load('emp_wage_by_educ_um.out');

educ_comp = load('educ_comp.out');
educ_comp_m = load('educ_comp_m.out');

assortative = load('assortative.out');
tax_brackets = load('tax_brackets.out');  % matrix with tax brackets 1962-2012
deductions_exemptions = load('deductions_exemptions.out'); % matrix with deductions, exemptions and EICT
nlsy_trans = load('nlsy_trans.out'); % matrix with transition matrix for 1955 cohort, ages 25-55, by marital status and education

% create employment of potential partner at t-1 by emp of unmarried  individual
husband_prev_emp=zeros(49,3);
husband_prev_emp(:,1)    = emp_mrate_child_wage_um(1:49,4);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
husband_prev_emp(1:45,2) = emp_mrate_child_wage_um(99:143,4);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
husband_prev_emp(46:49,2) = husband_prev_emp(45,2);
husband_prev_emp(1:35,3) = emp_mrate_child_wage_um(189:223,4);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
husband_prev_emp(36:49,3) = husband_prev_emp(35,3);

wife_prev_emp=zeros(49,3);
wife_prev_emp(:,1)    = emp_mrate_child_wage_um(50:98,4);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
wife_prev_emp(1:45,2) = emp_mrate_child_wage_um(144:188,4);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
wife_prev_emp(46:49,2) = wife_prev_emp(45,2);
wife_prev_emp(1:35,3) = emp_mrate_child_wage_um(224:258 ,4);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
wife_prev_emp(36:49,3) = wife_prev_emp(35,3);

% create kids of potential partner at t-1 by kids of unmarried  individual
husband_prev_kids=zeros(49,3);
husband_prev_kids(:,1)    = emp_mrate_child_wage_um(1:49,7);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
husband_prev_kids(1:45,2) = emp_mrate_child_wage_um(99:143,7);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
husband_prev_kids(46:49,2) = husband_prev_kids(45,2);
husband_prev_kids(1:35,3) = emp_mrate_child_wage_um(189:223,7);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
husband_prev_kids(36:49,3) = husband_prev_kids(35,3);

wife_prev_kids=zeros(49,3);
wife_prev_kids(:,1)    = emp_mrate_child_wage_um(50:98,7);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
wife_prev_kids(1:45,2) = emp_mrate_child_wage_um(144:188,7);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
wife_prev_kids(46:49,2) = wife_prev_kids(45,2);
wife_prev_kids(1:35,3) = emp_mrate_child_wage_um(224:258 ,7);% the employment of unmarried husnands - column 4 at emp_mrate_child_wage_um.out
wife_prev_kids(36:49,3) = wife_prev_kids(35,3);

% make random draws consistent between runs
rand('seed', 123456789);
randn('seed', 123456789);

% random shocks' mean and variance
myu = [0];
sig = 1;

% random draw from normal distribution, for shocks realizations in forward solution
for i=1:DRAW_F*3
	for j=1: T_MAX  % T_MAX=65-16
		for s=1:8
			epsilon_f(i,j,s)  = mvnrnd(myu, sig); %1-WAGE W, 2-WAGE-H, 3-HOME TIME_w, 4-HOME TIME_h, 5 - MARRIAGE QUALITY, 6 - PREGNANCY, 7 - school w, 8 - school h
		end
	end
end
for i=1:DRAW_B
	for j=1: T_MAX  % T_MAX=65-16
		for s=1:6
			epsilon_b(i,j,s)  = mvnrnd(myu, sig); %1-WAGE W, 2-WAGE-H, 3-HOME TIME_w, 4-HOME TIME_h, 5 - MARRIAGE QUALITY, 6 - PREGNANCY
		end
	end
end

% random draw from uniform distribution, for forward solution
w_draws_per=rand(DRAW_F*3,1);% WIFE'S ability in forward solving
w_draws_per(:,1)=randi(3,DRAW_F*3,1); %ABILITY IS 1 OR 2 OR 3
%1 - job offer FULL;
%2 - job offer part
%3 - MEET HUSBAND;
%4 -HUSBAND SCHOOLING+EXP;
%5 -HUSBAND ABILITY;
%6 - HUSBAND CHILDREN;
%7 - HUSBAND HEALTH ;
%8 - HUSBAND'S PARENTS EDUCATION;
%9- prev state husband; 
h_draws = rand(DRAW_F*3, T_MAX, 9);
h_draws(:,:,3)=randi(3,DRAW_F*3, T_MAX); %ABILITY IS 1 OR 2 OR 3
%1 - JOB OFFER FULL
%2 - job offer part
%3 - marriage permanent 
w_draws = rand(DRAW_F*3, T_MAX, 3); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% random draw from uniform distribution, for backward solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1- MEET PARTNER;
%2-PARTNER SCHOOLING+EXP;
%3-PARTNER ABILITY;
%4 - PARTNER CHILDREN;
%5 - PARTNER HEALTH ;
%6 - PARTNER'S PARENTS EDUCATION;
%7- prev state PARTNER; 
%8 - job offer FULL;
%9- job offer part
h_draws_back = rand(DRAW_B*3, T_MAX, 9);
w_draws_back = rand(DRAW_B*3, T_MAX, 9);
h_draws_back(:,:,3)=randi(3,DRAW_B*3, T_MAX); %ABILITY IS 1 OR 2 OR 3
w_draws_back(:,:,3)=randi(3,DRAW_B*3, T_MAX); %ABILITY IS 1 OR 2 OR 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% just for testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%epsilon_b = zeros(DRAW_B, T_MAX, 2);
%epsilon_f = zeros(DRAW_F, T_MAX, 5);
