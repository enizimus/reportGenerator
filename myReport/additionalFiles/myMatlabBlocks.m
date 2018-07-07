%% TABFUN

arr = randi(10,[2,3]);
report.addTabular(arr);

%% TABFUN2

row_labels = 'row1,row2';
col_labels = 'col1,col2,col3';

report.set('tableRowLabels', row_labels);
report.set('tableColLabels', col_labels);
report.set('tableColumnAlignment','lccc');
%report.set('dataFormat','%.1f')

report.addTabular(arr);

%% TABFUN3

arr = randn(4,4)*5;

%report.set('dataFormat','%0.2f %0.3f %0.1f %0.2f');
report.set('tableColumnAlignment','l|r|r');
report.set('booktabs',1);

report.addTabular(arr);