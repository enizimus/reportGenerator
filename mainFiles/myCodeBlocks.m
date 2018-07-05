%% TABLE_1
LastName = {'Smith';'Johnson';'Williams';'Jones';'Brown'};
Age = [38;43;38;40;49];
Height = [71;69;64;67;64];
Weight = [176;163;131;133;119];
T = table(Age,Height,Weight,'RowNames',LastName);
%% TEST_1
x = 1:5;
y = x.^2;