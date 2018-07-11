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
report.addFigure(figh, {'sin(t)', ' ', 'sinc(t)'});

%% PRETTYFUN

M1 = logical(eye(6));
M2 = flipud(M1);

report.addMatlabOutput({'M1','M2'});

report.addMatlabOutput({'M1','M2'}, true);

report.set('latexOutputColor','blue');
report.addMatlabOutput({'M1'}, true);
report.set('latexOutputColor','green');
report.addMatlabOutput({'M2'}, true);            

report.set('arrayImageColor',1,'arrayColorbar',1);
imageNames = report.createArrayImage({'M1','M2'});
report.setDefault('array');
report.set('imagePerLine', 2, 'imageOption', 'width=0.4\textwidth');
report.addFigure(imageNames,'Arrays as images');

report.setDefault('image');

report.set('arrayImageColor',0,'arrayColorbar',0);
imageNames = report.createArrayImage({{'M1','M2'}});
report.setDefault('array');
report.addFigure(imageNames,'Arrays as image in bw');

%% PRETTYBIG

bigM = rand(100);
report.set('prettyMaxSize', '[8,6]');
report.addMatlabOutput({'bigM'});

report.set('latexOutputColor','black');
report.addMatlabOutput({'bigM'}, true);

report.setDefault('image');
report.set('arrayImageColor', 1, 'arrayColorbar', 1);
imageNames = report.createArrayImage({'bigM'});
report.setDefault('array');
report.addFigure(imageNames, 'Random values as image');

%% MAGICFUN

M3 = magic(20);

report.set('arrayImageColor', 1, 'arrayColorbar', 1);
magicM = report.createArrayImage({'M3'});
report.set('imageOption', 'width=0.8\textwidth');

report.addFigure(magicM, 'Magic matrix 20x20');

%% FUNFUNC

myfun = 'exampleFunction.m';
pre = 'This part of the text comes before the table';
typ = {'logical','double','double','string','double'};
desc = {
    '1-D array', ...
    '2-D array', ...
    'scalar', ...
    '1-D array' ...
	'scalar'
    };
post = ['this text will be displayed after '...
					'the function description'];
report.addFunctionDescription(myfun,typ,desc,pre,post);

%% MATFUN

myfun = 'matFun.m';
pre = 'The type and description can also be extracted from the MATLAB help output for that function';
post = 'Just by passing empty strings for {\tt type} and {\tt desc} it will get the data from the help output';
report.addFunctionDescription(myfun,'','',pre,post);

%% EQNS

report.addEquation(['\nabla E &= \frac{\rho}{\epsilon_0}\\ \nabla B &= 0\\ \nabla \times E &= -\frac{\partial B}{\partial t}\\ \nabla \times B &= \mu_0(J+ \epsilon_0\frac{\partial E}{\partial t})'],'align*');
	
	
%% LASTSTP



















