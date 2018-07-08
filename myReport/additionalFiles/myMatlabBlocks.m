%% TABFUN

arr = randi(10,[2,3]);
report.addTabular(arr);

%% TABFUN2

row_labels = 'row1,row2';
col_labels = 'col1,col2,col3';

report.set('dataFormat','%i');
report.set('tableRowLabels', row_labels);
report.set('tableColLabels', col_labels);
report.set('tableColumnAlignment','lccc');

report.addTabular(arr);

%% TABFUN21

row_labels = 'row1,row2';
col_labels = 'col1,col2,col3';

report.set('tableRowLabels', row_labels);
report.set('tableColLabels', col_labels);
report.set('tableColumnAlignment','lccc');

report.addTabular(arr);

%% TABFUN3

report.set('dataFormat','%0.1f,%0.3f,%0.1f,%0.2f');
report.set('tableColLabels','col1,col2,col3,col4');
report.set('tableRowLabels','row1,row2,row3,row4');
report.set('booktabs',1);

arr = randn(4,4)*5;
arr(3) = nan;
report.addTabular(arr);

%% TABFUN31


report.set('tableColLabels','col1,col2,col3,col4');
report.set('tableRowLabels','row1,row2,row3,row4');
report.set('booktabs',1);

arr = randn(4,4)*5;
arr(3) = nan;
report.addTabular(arr);


%% TABFUN4

report.set('tableRowLabels','row1, ,row3,row4');
report.set('tableColumnAlignment','c|cccc');
report.addTabular(arr);

%% TABFUN5

report.setDefault('table');
report.set('tableBorders', 0);
report.addTabular(arr);

%% TABFUN6

LastName = {'Smith';'Johnson';'Williams';'Jones';'Brown'};
Age = [38;43;38;40;49];
Height = [71;69;64;67;64];
Weight = [176;163;131;133;119];
T = table(Age,Height,Weight,'RowNames',LastName);

report.addTabular(T);

%% TABFUN7

report.set('transposeTable',1);
report.addTable(T, 'My caption');


%% FIGFUN

figh = gobjects(1,3);
t = linspace(-2*pi,2*pi,100);

figh(1) = figure('visible','off');
plot(t,sin(t));
xlim([-2*pi,2*pi])

figh(2) = figure('visible','off');
plot(t,log(t), 'mo');
xlim([-2*pi,2*pi])

figh(3) = figure('visible','off');
plot(t,sinc(t), 'r-*');
xlim([-2*pi,2*pi])

%% FIGFUN2

report.set('imagePerLine',2);
report.addImage(figh(2:3));


%% FIGFUN3
report.set('imagePerLine',3);
report.set('imageOption', 'width=0.30\textwidth');
report.addFigure(figh, 'sin(t), log(t), sinc(t)');

%% FIGFUN4
report.set('imagePerLine',1);
report.set('imageOption', 'width=0.8\textwidth');
report.addFigure(figh, {'sin(t)', 'log(t)', 'sinc(t)'});



















