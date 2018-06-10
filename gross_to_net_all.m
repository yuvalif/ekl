format short

% load data from parameter files
tax_brackets = load('tax_brackets.out');  % matrix with tax brackets 1962-2012
deductions_exemptions = load('deductions_exemptions.out'); % matrix with deductions, exemptions and EICT

% load observation data
observation_file='1965wages.txt';
observation_data=load(observation_file);
W_N = observation_data(:,1); %single wife # of children
H_N = observation_data(:,2); %single husband # of children
C_N = observation_data(:,3); %married household # of children
wage_w = observation_data(:,4); %wife's wage
wage_h = observation_data(:,5);  %husband's wage
M = observation_data(:,6);  % marital status, 1==married
year = observation_data(:,7);
number_of_observation=size(W_N,1)

net = zeros(number_of_observation,2);

for i=1:number_of_observation
    [net(i,1) net(i,2)] = gross_to_net_separate(W_N(i), H_N(i), C_N(i), wage_w(i), wage_h(i), M(i), year(i), tax_brackets, deductions_exemptions);
end

output = horzcat(observation_data, net);

save('output.txt', 'output');
